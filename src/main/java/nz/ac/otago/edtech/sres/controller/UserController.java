package nz.ac.otago.edtech.sres.controller;

import com.mongodb.MongoClient;
import com.mongodb.client.AggregateIterable;
import com.mongodb.client.FindIterable;
import com.mongodb.client.MongoDatabase;
import com.mongodb.client.model.UpdateOptions;
import com.mongodb.client.result.UpdateResult;
import nz.ac.otago.edtech.auth.util.AuthUtil;
import nz.ac.otago.edtech.spring.bean.UploadLocation;
import nz.ac.otago.edtech.spring.util.OtherUtil;
import nz.ac.otago.edtech.sres.util.MongoUtil;
import nz.ac.otago.edtech.util.CommonUtil;
import nz.ac.otago.edtech.util.JSONUtil;
import nz.ac.otago.edtech.util.ServletUtil;
import org.apache.commons.csv.CSVFormat;
import org.apache.commons.csv.CSVParser;
import org.apache.commons.csv.CSVRecord;
import org.apache.commons.io.input.BOMInputStream;
import org.apache.commons.lang3.StringUtils;
import org.apache.commons.lang3.math.NumberUtils;
import org.bson.BsonDocument;
import org.bson.BsonDocumentWriter;
import org.bson.Document;
import org.bson.codecs.Encoder;
import org.bson.codecs.EncoderContext;
import org.bson.codecs.configuration.CodecRegistry;
import org.bson.conversions.Bson;
import org.bson.types.ObjectId;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.beans.propertyeditors.CustomDateEditor;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.annotation.PostConstruct;
import javax.servlet.http.HttpServletRequest;
import java.io.*;
import java.text.SimpleDateFormat;
import java.util.*;

import static com.mongodb.assertions.Assertions.notNull;
import static com.mongodb.client.model.Filters.and;
import static com.mongodb.client.model.Filters.eq;
import static java.util.Arrays.asList;

/**
 * User controller.
 *
 * @author Richard Zeng (richard.zeng@otago.ac.nz)
 *         Date: 16/02/16
 *         Time: 9:09 AM
 */
@Controller
@RequestMapping("/user")
public class UserController {

    // Which to use, DBObject, BasicDBObject, or Document
    // http://stackoverflow.com/questions/29722424/java-mongodb-bson-class-confusion

    public static final String DATE_ONLY_FORMAT = "dd/MM/yyyy";
    private SimpleDateFormat dateFormat = new SimpleDateFormat(DATE_ONLY_FORMAT);

    private static final Logger log = LoggerFactory.getLogger(UserController.class);

    @Autowired
    private UploadLocation uploadLocation;

    @Autowired
    MongoClient mongoClient;

    @Value("${mongodb.dbname}")
    private String dbName;


    private MongoDatabase db = null;

    @PostConstruct
    public void init() {
        db = mongoClient.getDatabase(dbName);
    }

    @RequestMapping(method = RequestMethod.GET)
    public String home(HttpServletRequest request, ModelMap model) {

        String userName = AuthUtil.getUserName(request);
        Document user = MongoUtil.getUser(db, userName);
        if (user == null) {
            ModelMap userMap = new ModelMap();
            userMap.put(MongoUtil.USERNAME, userName);
            // TODO: load user information here
            db.getCollection(MongoUtil.COLLECTION_NAME_USERS).insertOne(new Document(userMap));
            user = MongoUtil.getDocument(db, MongoUtil.COLLECTION_NAME_USERS, MongoUtil.USERNAME, userName);
        }
        model.put("user", user);

        List<Document> documents = new ArrayList<Document>();
        AggregateIterable<Document> iterable = db.getCollection(MongoUtil.COLLECTION_NAME_PAPERS).aggregate(asList(
                new Document("$match", new Document("owner", userName).append("status", "active")),
                new Document("$lookup", new Document("from", MongoUtil.COLLECTION_NAME_USERS).append("localField", "_id").append("foreignField", "papers.paperref").append("as", "users"))));
        for (Document document : iterable) {
            documents.add(document);
        }

        model.put("list", documents);
        model.put("pageName", "user");
        MongoUtil.putCommonIntoModel(db, request, model);
        return Common.DEFAULT_VIEW_NAME;
    }

    @RequestMapping(value = "/addPaper", method = RequestMethod.GET)
    public String addPaper(HttpServletRequest request, ModelMap model) {
        model.put("pageName", "addPaper");
        MongoUtil.putCommonIntoModel(db, request, model);
        return Common.DEFAULT_VIEW_NAME;
    }

    @RequestMapping(value = "/addPaper", method = RequestMethod.POST)
    public String addPaper(HttpServletRequest request) {
        // get login username
        String userName = AuthUtil.getUserName(request);
        ModelMap paper = new ModelMap();
        Enumeration<String> parameterNames = request.getParameterNames();
        while (parameterNames.hasMoreElements()) {
            String name = parameterNames.nextElement();
            String value = request.getParameter(name);
            paper.put(name, value);
        }
        ObjectId id = new ObjectId();
        paper.put("_id", id);
        paper.put("owner", userName);
        paper.put("status", "active");
        db.getCollection(MongoUtil.COLLECTION_NAME_PAPERS).insertOne(new Document(paper));
        Document user = MongoUtil.getUser(db, userName);
        if (user != null) {
            // paper info
            ModelMap pp = new ModelMap();
            pp.put("paperref", id);
            List<String> roles = new ArrayList<String>();
            roles.add("owner");
            pp.put("roles", roles);
            db.getCollection(MongoUtil.COLLECTION_NAME_USERS).updateOne(new Document(MongoUtil.USERNAME, userName),
                    new Document("$addToSet", new Document("papers", pp)));
        }
        log.debug("id {}", id);
        return "redirect:/user/addStudentList/" + id.toString();
    }

    @RequestMapping(value = "/addColumn/{id}", method = RequestMethod.GET)
    public String addColumn(@PathVariable String id,
                            HttpServletRequest request,
                            ModelMap model) {
        model.put("paperId", id);
        model.put("pageName", "addColumn");
        MongoUtil.putCommonIntoModel(db, request, model);
        return Common.DEFAULT_VIEW_NAME;
    }

    @RequestMapping(value = "/editColumn/{id}", method = RequestMethod.GET)
    public String editColumn(@PathVariable String id,
                             HttpServletRequest request,
                             ModelMap model) {

        String[] keys = {"_id", "id", "name", "description", "tags", "paperref", "activeFrom", "activeTo"};
        List<String> keyList = Arrays.asList(keys);
        Document column = MongoUtil.getDocument(db, MongoUtil.COLLECTION_NAME_COLUMNS, id);

        ModelMap extra = new ModelMap();
        for (String key : column.keySet()) {
            if (!keyList.contains(key))
                extra.put(key, column.get(key));
        }
        model.put("column", column);
        model.put("extra", extra);
        model.put("paperId", column.get("paperref"));
        model.put("pageName", "addColumn");
        MongoUtil.putCommonIntoModel(db, request, model);
        return Common.DEFAULT_VIEW_NAME;
    }

    @RequestMapping(value = "/saveColumn", method = RequestMethod.POST)
    public ResponseEntity<String> saveColumn(@RequestParam(value = "paperId", required = false) String paperId,
                                             @RequestParam(value = "_id", required = false) String _id,
                                             @RequestParam("name") String name,
                                             @RequestParam(value = "description", required = false) String description,
                                             @RequestParam("tags") String tags,
                                             @RequestParam(value = "activeFrom", required = false) Date activeFrom,
                                             @RequestParam(value = "activeTo", required = false) Date activeTo,
                                             @RequestParam("json") String json,
                                             HttpServletRequest request) {

        String action = "saveColumn";
        boolean success = false;
        String detail = null;
        JSONObject object = JSONUtil.parse(json);
        object.put("name", name);
        if (description != null)
            object.put("description", description);
        object.put("tags", tags);
        if (activeFrom != null)
            object.put("activeFrom", activeFrom);
        if (activeTo != null)
            object.put("activeTo", activeTo);
        if (_id != null) {
            // update existing column
            db.getCollection(MongoUtil.COLLECTION_NAME_COLUMNS)
                    .updateOne(eq("_id", new ObjectId(_id)),
                            new Document("$set", new Document(object)));
        } else {
            ObjectId paperref = new ObjectId(paperId);
            object.put("paperref", paperref);
            // create a new column
            db.getCollection(MongoUtil.COLLECTION_NAME_COLUMNS)
                    .insertOne(new Document(object));
        }
        success = true;
        return OtherUtil.outputJSON(action, success, detail);
    }

    @RequestMapping(value = "/addStudentList/{id}", method = RequestMethod.GET)
    public String editStudentList(@PathVariable String id,
                                  HttpServletRequest request,
                                  ModelMap model) {
        model.put("id", id);
        model.put("pageName", "addStudentList");
        MongoUtil.putCommonIntoModel(db, request, model);
        return Common.DEFAULT_VIEW_NAME;
    }

    @RequestMapping(value = "/addStudentList", method = RequestMethod.POST)
    public String editStudentList(@RequestParam("files") MultipartFile file,
                                  @RequestParam("id") String id,
                                  HttpServletRequest request,
                                  ModelMap model) {
        // when no file uploaded, go to view paper page
        if (file.getSize() == 0)
            return "redirect:/user/viewPaper/" + id;

        File uploadDir = uploadLocation.getUploadDir();
        String filename = CommonUtil.getUniqueFilename(uploadDir.getAbsolutePath(), file.getOriginalFilename());
        File upload = new File(uploadDir, filename);
        if (StringUtils.isNotBlank(upload.getPath())) {
            try {
                file.transferTo(upload);
                List<String[]> list = new ArrayList<String[]>();
                int index = 0;

                // read csv file without header
                Reader in = new FileReader(upload);
                Iterable<CSVRecord> records = CSVFormat.EXCEL.parse(in);
                // go through csv file
                for (CSVRecord record : records) {
                    if (index > 3)
                        break;
                    String[] columns = new String[record.size()];
                    for (int i = 0; i < record.size(); i++) {
                        columns[i] = record.get(i);
                    }
                    list.add(columns);
                }
                model.put("list", list);
                model.put("id", id);
                model.put("filename", filename);
            } catch (IOException e) {
                log.error("Exception", e);
            }
        }
        model.put("fields", MongoUtil.USER_FIELDS);
        model.put("pageName", "mapFields");
        MongoUtil.putCommonIntoModel(db, request, model);
        return Common.DEFAULT_VIEW_NAME;
    }

    @RequestMapping(value = "/importUser", method = RequestMethod.POST)
    public String importUser(HttpServletRequest request,
                             @RequestParam("id") String id,
                             @RequestParam("size") int size,
                             @RequestParam("filename") String filename) {
        boolean hasHeader = false;
        if (request.getParameter("hasHeader") != null)
            hasHeader = true;
      /*  int[] index = new int[MongoUtil.USER_FIELDS.length];
        for (int i = 0; i < MongoUtil.USER_FIELDS.length; i++)
            index[i] = ServletUtil.getParameter(request, MongoUtil.USER_FIELDS[i], -1);     */

        // get extra user information
        Map<String, Integer> userInfoFields = new HashMap<String, Integer>();
        for (int i = 0; i < size; i++) {
            if (request.getParameter("extra" + i) != null) {
                String key = request.getParameter("key" + i).trim();
                int value = ServletUtil.getParameter(request, "value" + i, -1);
                if ((key != null) && (value != -1))
                    userInfoFields.put(key, value);
            }
        }
        File file = new File(uploadLocation.getUploadDir(), filename);
        if (file.exists()) {
            ObjectId paperId = new ObjectId(id);
            Iterable<CSVRecord> records;
            try {
                if (hasHeader) {
                    // read csv file with header
                    InputStream input = new FileInputStream(file);
                    Reader reader = new InputStreamReader(new BOMInputStream(input), "UTF-8");
                    records = new CSVParser(reader, CSVFormat.EXCEL.withHeader());
                } else {
                    // read csv file without header
                    Reader in = new FileReader(file);
                    records = CSVFormat.EXCEL.parse(in);
                }
                // go through csv file
                for (CSVRecord record : records) {
                    ModelMap userMap = new ModelMap();
                    //userMap.put("role", "student");
                  /*  for (int i = 0; i < MongoUtil.USER_FIELDS.length; i++) {
                        if (index[i] != -1)
                            userMap.put(MongoUtil.USER_FIELDS[i], record.get(index[i]));
                    }              */
                    ModelMap userInfo = new ModelMap();
                    for (String k : userInfoFields.keySet()) {
                        int ii = userInfoFields.get(k);
                        if (ii != -1) {
                            userInfo.put(k, record.get(ii));
                        }
                    }
                    // paper info
                    ModelMap pp = new ModelMap();
                    pp.put("paperref", paperId);
                    List<String> roles = new ArrayList<String>();
                    roles.add("student");
                    pp.put("roles", roles);
                    //pp.put("role", "student");
                    if (!userInfo.isEmpty())
                        pp.put("userInfo", userInfo);

               //     List<Document> list = MongoUtil.getDocuments(db, MongoUtil.COLLECTION_NAME_USERS, eq(MongoUtil.USERNAME, userMap.get(MongoUtil.USERNAME)), eq("papers.paperref", paperId));
                //    if (list.isEmpty()) {
                        //UpdateOptions uo = new UpdateOptions().upsert(true);
                        db.getCollection(MongoUtil.COLLECTION_NAME_USERS).insertOne(
                                new Document(userMap)
                                        .append("papers", pp)
                        );
                  /*  } else {
                        db.getCollection(MongoUtil.COLLECTION_NAME_USERS).updateOne(
                                new Document(MongoUtil.USERNAME, userMap.get(MongoUtil.USERNAME)),
                                new Document("$set", new Document(userMap))
                        );
                        db.getCollection(MongoUtil.COLLECTION_NAME_USERS).updateOne(
                                new Document(MongoUtil.USERNAME, userMap.get(MongoUtil.USERNAME))
                                        .append("papers",
                                                new Document("$elemMatch",
                                                        new Document("paperref", paperId))),
                                new Document("$addToSet", new Document("papers.$.roles", "student"))

                        );
             //       }    */
                }
            } catch (IOException ioe) {
                log.error("IOException", ioe);
            }
        }
        return "redirect:/user/importStudentData/" + id;
    }

    @RequestMapping(value = "/importStudentData/{id}", method = RequestMethod.GET)
    public String importStudentData(@PathVariable String id,
                                    HttpServletRequest request,
                                    ModelMap model) {
        model.put("id", id);
        model.put("pageName", "importStudentData");
        MongoUtil.putCommonIntoModel(db, request, model);
        return Common.DEFAULT_VIEW_NAME;
    }


    @RequestMapping(value = "/importStudentData", method = RequestMethod.POST)
    public String importStudentData(
            @RequestParam("files") MultipartFile file,
            @RequestParam("id") String id,
            HttpServletRequest request,
            ModelMap model) {

        // when no file uploaded, go to view paper page
        if (file.getSize() == 0)
            return "redirect:/user/viewPaper/" + id;

        File uploadDir = uploadLocation.getUploadDir();
        String filename = CommonUtil.getUniqueFilename(uploadDir.getAbsolutePath(), file.getOriginalFilename());
        File upload = new File(uploadDir, filename);
        if (StringUtils.isNotBlank(upload.getPath())) {
            try {
                file.transferTo(upload);
                List<String[]> list = new ArrayList<String[]>();
                int index = 0;
                BufferedReader in = new BufferedReader(new FileReader(upload));
                for (String line; (line = in.readLine()) != null; ) {
                    index++;
                    if (index > 3)
                        break;
                    String[] columns = line.split(",");
                    list.add(columns);
                }
                model.put("list", list);
                model.put("id", id);
                model.put("filename", upload.getName());
            } catch (IOException e) {
                log.error("Exception", e);
            }
        }
        model.put("fields", MongoUtil.USER_FIELDS);
        model.put("pageName", "mapDataFields");
        MongoUtil.putCommonIntoModel(db, request, model);
        return Common.DEFAULT_VIEW_NAME;
    }

    @RequestMapping(value = "/importUserData", method = RequestMethod.POST)
    public String importUserData(HttpServletRequest request,
                                 @RequestParam("id") String id,
                                 @RequestParam("size") int size,
                                 @RequestParam("filename") String filename) {

        String userName = AuthUtil.getUserName(request);
        Document user = MongoUtil.getUser(db, userName);
        boolean hasHeader = false;
        if (request.getParameter("hasHeader") != null)
            hasHeader = true;
        int unIndex = ServletUtil.getParameter(request, MongoUtil.USERNAME, -1);
        ObjectId paperId = new ObjectId(id);
        if (unIndex != -1) {
            List<ModelMap> columnFields = new ArrayList<ModelMap>();
            for (int i = 0; i < size; i++) {
                if (request.getParameter("extra" + i) != null) {
                    String name = request.getParameter("name" + i).trim();
                    String description = request.getParameter("description" + i);
                    int value = ServletUtil.getParameter(request, "value" + i, -1);
                    if ((name != null) && (value != -1)) {
                        ModelMap map = new ModelMap();
                        map.put("name", name);
                        map.put("description", description);
                        map.put("index", value);
                        map.put("paperref", paperId);
                        // update column if exists, create a new one if does not exist
                        db.getCollection(MongoUtil.COLLECTION_NAME_COLUMNS)
                                .updateOne(and(eq("name", name), eq("paperref", paperId)),
                                        new Document("$set", new Document(map)),
                                        new UpdateOptions().upsert(true));
                        Document doc = MongoUtil.getDocument(db, MongoUtil.COLLECTION_NAME_COLUMNS,
                                eq("name", name), eq("paperref", paperId));
                        if (doc != null)
                            map.put("_id", doc.get("_id"));
                        columnFields.add(map);
                    }
                }
            }
            if (!columnFields.isEmpty()) {
                File file = new File(uploadLocation.getUploadDir(), filename);
                if (file.exists()) {
                    Iterable<CSVRecord> records;
                    try {
                        if (hasHeader) {
                            // read csv file with header
                            InputStream input = new FileInputStream(file);
                            Reader reader = new InputStreamReader(new BOMInputStream(input), "UTF-8");
                            records = new CSVParser(reader, CSVFormat.EXCEL.withHeader());
                        } else {
                            // read csv file without header
                            Reader in = new FileReader(file);
                            records = CSVFormat.EXCEL.parse(in);
                        }
                        // go through csv file
                        for (CSVRecord record : records) {
                            String un = record.get(unIndex);
                            Document uu = MongoUtil.getDocument(db, MongoUtil.COLLECTION_NAME_USERS, eq("papers.paperref", paperId), eq(MongoUtil.USERNAME, un));
                            if (uu != null)
                                for (ModelMap m : columnFields) {
                                    ObjectId colref = (ObjectId) m.get("_id");
                                    ObjectId userref = (ObjectId) uu.get("_id");
                                    String value = record.get((Integer) m.get("index")).trim();
                                    MongoUtil.saveUserData(db, value, colref, userref, user);
                                }
                        }
                    } catch (IOException ioe) {
                        log.error("IOException", ioe);
                    }
                }
            }
        }
        return "redirect:/user/viewPaper/" + id;
    }

    @RequestMapping(value = "/emailStudents", method = RequestMethod.POST)
    public String emailStudents(HttpServletRequest request,
                                @RequestParam("id") String id,
                                @RequestParam("usernames") String[] usernames,
                                ModelMap model) {
        ObjectId paperId = new ObjectId(id);
        model.put("paper", MongoUtil.getDocument(db, MongoUtil.COLLECTION_NAME_PAPERS, paperId));
        List<Document> users = new ArrayList<Document>();
        for (String username : usernames) {
            FindIterable<Document> iterable = db.getCollection(MongoUtil.COLLECTION_NAME_USERS).find(
                    new Document("username", username).append(
                            "papers", new Document("$elemMatch", new Document("paperref", paperId)
                            .append("roles", "student")))
            );
            for (Document u : iterable)
                users.add(u);
        }
        List<Document> columns = MongoUtil.getDocuments(db, MongoUtil.COLLECTION_NAME_COLUMNS, "paperref", paperId);
        log.debug("id = {}", id);
        log.debug("usernames = {}", (Object[]) usernames);
        model.put("columns", columns);
        model.put("users", users);
        model.put("pageName", "emailStudents");
        MongoUtil.putCommonIntoModel(db, request, model);
        return Common.DEFAULT_VIEW_NAME;
    }

    @RequestMapping(value = "/sendEmails", method = RequestMethod.POST)
    public String sendEmails(HttpServletRequest request,
                             @RequestParam("id") String id,
                             @RequestParam("usernames") String[] usernames,
                             @RequestParam("subject") String subject,
                             @RequestParam("body") String body,
                             ModelMap model) {
        ObjectId paperId = new ObjectId(id);
        model.put("paper", MongoUtil.getDocument(db, MongoUtil.COLLECTION_NAME_PAPERS, paperId));
        List<Document> users = new ArrayList<Document>();
        for (String username : usernames) {
            FindIterable<Document> iterable = db.getCollection(MongoUtil.COLLECTION_NAME_USERS).find(
                    new Document("username", username).append(
                            "papers", new Document("$elemMatch", new Document("paperref", paperId)
                            .append("roles", "student")))
            );
            String thisSubject = subject;
            String thisBody = body;

            for (Document u : iterable)
                users.add(u);
        }
        log.debug("id = {}", id);
        log.debug("usernames = {}", (Object[]) usernames);
        model.put("users", users);
        model.put("pageName", "emailStudents");
        MongoUtil.putCommonIntoModel(db, request, model);
        return Common.DEFAULT_VIEW_NAME;
    }

    // remove given user (id) from paper (paperId)
    @RequestMapping(value = "/removeUser", method = RequestMethod.POST)
    public ResponseEntity<String> removeUser(@RequestParam("id") String id,
                                             @RequestParam("paperId") String paperId,
                                             HttpServletRequest request) {
        String action = "removeUser";
        boolean success = false;
        String detail = null;
        Document user = MongoUtil.getDocument(db, MongoUtil.COLLECTION_NAME_USERS, id);
        Document paper = MongoUtil.getDocument(db, MongoUtil.COLLECTION_NAME_PAPERS, paperId);
        if ((user != null) && (paper != null)) {
            // remove this paper from user's papers array
            db.getCollection(MongoUtil.COLLECTION_NAME_USERS)
                    .updateOne(eq("_id", new ObjectId(id)),
                            new Document("$pull", new Document("papers", new Document("paperref", new ObjectId(paperId))))
                    );
            success = true;
        } else if ((user == null) && (paper == null))
            detail = "Can not find given user and paper";
        else if (user == null)
            detail = "Can not find given user";
        else detail = "Can not find given paper";
        return OtherUtil.outputJSON(action, success, detail);
    }

    @RequestMapping(value = "/deletePaper/{id}", method = RequestMethod.GET)
    public ResponseEntity<String> deletePaper(@PathVariable String id, HttpServletRequest request) {
        String action = "deletePaper";
        boolean success = false;
        String detail = null;
        ObjectId paperId = new ObjectId(id);
        String userName = AuthUtil.getUserName(request);
        UpdateResult result = db.getCollection(MongoUtil.COLLECTION_NAME_PAPERS).updateOne(
                and(eq("_id", paperId), eq("owner", userName)),
                new Document("$set", new Document("status", "deleted")));
        if (result.getModifiedCount() == 1)
            success = true;
        // remove this paper from user's papers array
        db.getCollection(MongoUtil.COLLECTION_NAME_USERS).updateOne(eq(MongoUtil.USERNAME, userName),
                new Document("$pull", new Document("papers", new Document("paperref", paperId)))
        );
        return OtherUtil.outputJSON(action, success, detail);
    }

    @RequestMapping(value = "/viewPaper/{id}", method = RequestMethod.GET)
    public String viewPaper(@PathVariable String id,
                            HttpServletRequest request,
                            ModelMap model) {
        ObjectId paperId = new ObjectId(id);
        Document paper =   MongoUtil.getDocument(db, MongoUtil.COLLECTION_NAME_PAPERS, paperId);
        model.put("paper", paper);

        List<ModelMap> results = new ArrayList<ModelMap>();

        List<Document> columns = MongoUtil.getDocuments(db, MongoUtil.COLLECTION_NAME_COLUMNS, "paperref", paperId);
        /*
        FindIterable<Document> iterable = db.getCollection(MongoUtil.COLLECTION_NAME_USERS).find(
                new Document("papers", new Document("$elemMatch", new Document("paperref", paperId)
                        .append("roles", "student")))
        );
        //*/

        AggregateIterable<Document> iterable = db.getCollection(MongoUtil.COLLECTION_NAME_USERS).aggregate(asList(
                new Document("$match", new Document("papers", new Document("$elemMatch",
                        new Document("paperref", paperId).append("roles", "student") ))),
                new Document("$lookup", new Document("from", MongoUtil.COLLECTION_NAME_USERDATA).append("localField", "_id").append("foreignField", "userref").append("as", "userdata"))));

        for (Document u : iterable) {
            ModelMap result = new ModelMap();
            result.putAll(u);
            /*
            List<ModelMap> data = new ArrayList<ModelMap>();
            log.debug("inside student list, before fetch column");
            for (Document c : columns) {
                ModelMap datum = new ModelMap();
                Document userData = MongoUtil.getDocument(db, MongoUtil.COLLECTION_NAME_USERDATA, eq("userref", u.get("_id")), eq("colref", c.get("_id")));
                datum.put("column", c);
                datum.put("userData", userData);
                data.add(datum);
            }
            result.put("data", data);
            */
            results.add(result);
            //log.debug("inside student list, after fetch column");
        }
        model.put("id", id);
        model.put("results", results);
        model.put("columns", columns);
        model.put("pageName", "viewPaper");
        MongoUtil.putCommonIntoModel(db, request, model);
        return Common.DEFAULT_VIEW_NAME;
    }

    @RequestMapping(value = "/editPaper/{id}", method = RequestMethod.GET)
    public String editPaper(@PathVariable String id,
                            HttpServletRequest request,
                            ModelMap model) {
        String[] keys = {"_id", "id", "code", "name", "year", "semester", "owner", "status"};
        List<String> keyList = Arrays.asList(keys);

        Document paper = MongoUtil.getDocument(db, MongoUtil.COLLECTION_NAME_PAPERS, id);
        ModelMap extra = new ModelMap();
        for (String key : paper.keySet()) {
            if (!keyList.contains(key))
                extra.put(key, paper.get(key));
        }
        model.put("paper", paper);
        model.put("extra", extra);
        model.put("pageName", "editPaper");
        MongoUtil.putCommonIntoModel(db, request, model);
        return Common.DEFAULT_VIEW_NAME;
    }

    @RequestMapping(value = "/savePaper", method = RequestMethod.POST)
    public ResponseEntity<String> savePaper(@RequestParam(value = "paperId", required = false) String paperId,
                                            @RequestParam("_id") String _id,
                                            @RequestParam("code") String code,
                                            @RequestParam("name") String name,
                                            @RequestParam("year") String year,
                                            @RequestParam("semester") String semester,
                                            @RequestParam("json") String json,
                                            HttpServletRequest request) {
        String action = "savePaper";
        boolean success;
        String detail = null;
        JSONObject object = JSONUtil.parse(json);
        object.put("code", code);
        object.put("name", name);
        object.put("year", year);
        object.put("semester", semester);
        // update existing column
        db.getCollection(MongoUtil.COLLECTION_NAME_PAPERS)
                .updateOne(eq("_id", new ObjectId(_id)),
                        new Document("$set", new Document(object)));
        success = true;
        return OtherUtil.outputJSON(action, success, detail);
    }


    @RequestMapping(value = "/filterStudentList", method = RequestMethod.POST)
    public String filterStudentList(@RequestParam("id") String id,
                                    @RequestParam("json") String json,
                                    HttpServletRequest request,
                                    ModelMap model) {

        ObjectId paperId = new ObjectId(id);
        model.put("paper", MongoUtil.getDocument(db, MongoUtil.COLLECTION_NAME_PAPERS, paperId));

        List<ModelMap> results = new ArrayList<ModelMap>();
        List<Document> columns = MongoUtil.getDocuments(db, MongoUtil.COLLECTION_NAME_COLUMNS, "paperref", paperId);

        Set<ObjectId> set = new HashSet<ObjectId>();
        JSONArray array = JSONUtil.parseArray(json);

        for (Object oo : array) {
            JSONObject obj = (JSONObject) oo;
            if ((obj.get("colref") != null) && (obj.get("operator") != null)) {
                String value = obj.get("value").toString();
                Object o = value;
                if (NumberUtils.isNumber(value))
                    o = NumberUtils.createNumber(value);
                String operator = obj.get("operator").toString();
                Bson valueFilter = new OperatorFilter<Object>(operator, "data.0.value", o);
                String colref = obj.get("colref").toString();
                Bson colFilter = eq("colref", new ObjectId(colref));

                // FindIterable<Document> iterable = db.getCollection(COLLECTION_NAME_USERDATA).find(and(valueFilter, colFilter), {"userref":1});

                List<Document> userdata = MongoUtil.getDocuments(db, MongoUtil.COLLECTION_NAME_USERDATA,
                        colFilter,
                        valueFilter
                );
                if (set.isEmpty()) {
                    for (Document doc : userdata)
                        set.add((ObjectId) doc.get("userref"));
                } else {
                    Set<ObjectId> tmp = new HashSet<ObjectId>();
                    for (Document doc : userdata)
                        tmp.add((ObjectId) doc.get("userref"));
                    String join = obj.get("join").toString();
                    if (join.equals("and"))
                        set.retainAll(tmp);
                    else
                        set.addAll(tmp);
                }
            }
        }
        for (ObjectId oid : set) {
            ModelMap result = new ModelMap();
            /*
            Document user = MongoUtil.getUser(db, oid);
            if (user != null) {
                result.putAll(user);
                List<ModelMap> data = new ArrayList<ModelMap>();
                for (Document c : columns) {
                    ModelMap datum = new ModelMap();
                    Document userData = MongoUtil.getDocument(db, MongoUtil.COLLECTION_NAME_USERDATA, eq("userref", oid), eq("colref", c.get("_id")));
                    datum.put("column", c);
                    datum.put("userData", userData);
                    data.add(datum);
                }
                result.put("data", data);
                results.add(result);
            }
            */
            AggregateIterable<Document> iterable = db.getCollection(MongoUtil.COLLECTION_NAME_USERS).aggregate(asList(
                    new Document("$match", new Document("_id", oid)),
                    new Document("$lookup", new Document("from", MongoUtil.COLLECTION_NAME_USERDATA).append("localField", "_id").append("foreignField", "userref").append("as", "userdata"))));
            for(Document doc: iterable) {
                result.putAll(doc);
                results.add(result);
                break;
            }

        }
        model.put("id", id);
        model.put("json", json);
        model.put("results", results);
        model.put("columns", columns);
        model.put("pageName", "viewPaper");
        MongoUtil.putCommonIntoModel(db, request, model);
        return Common.DEFAULT_VIEW_NAME;
    }


    @RequestMapping(value = "/viewColumnList/{id}", method = RequestMethod.GET)
    public String viewColumnList(@PathVariable String id,
                                 HttpServletRequest request,
                                 ModelMap model) {
        ObjectId paperId = new ObjectId(id);
        Document paper = MongoUtil.getDocument(db, MongoUtil.COLLECTION_NAME_PAPERS, paperId);
        model.put("paper", paper);

        List<Document> columns = MongoUtil.getDocuments(db, MongoUtil.COLLECTION_NAME_COLUMNS, "paperref", paperId);
        log.debug("columns {}", columns);
        model.put("columns", columns);

        model.put("pageName", "viewColumnList");
        MongoUtil.putCommonIntoModel(db, request, model);
        return Common.DEFAULT_VIEW_NAME;
    }

    @RequestMapping(value = "/saveColumnValue", method = RequestMethod.POST)
    public ResponseEntity<String> saveColumnValue(@RequestParam(value = "id", required = false) String id,
                                                  @RequestParam(value = "userId", required = false) String userId,
                                                  @RequestParam(value = "columnId", required = false) String columnId,
                                                  @RequestParam("value") String value,
                                                  HttpServletRequest request) {
        String action = "saveColumnValue";
        String userName = AuthUtil.getUserName(request);
        Document user = MongoUtil.getUser(db, userName);
        boolean success = false;
        String detail = null;
        if (id != null) {
            Map map = MongoUtil.updateUserData(db, value, id, user);
            if (map != null)
                success = true;
        } else if ((userId != null) && (columnId != null)) {
            log.debug("save data here {}", value);
            Map map = MongoUtil.saveUserData(db, value, new ObjectId(columnId), new ObjectId(userId), user);
            if (map != null) {
                detail = map.get("_id").toString();
                success = true;
            }
        }
        return OtherUtil.outputJSON(action, success, detail);
    }

    @InitBinder
    public void initBinder(WebDataBinder binder) {
        dateFormat.setLenient(false);
        // true passed to CustomDateEditor constructor means convert empty String to null
        binder.registerCustomEditor(Date.class, new CustomDateEditor(dateFormat, true));
    }

    // copy from com.mongodb.client.model.Filters
    private static final class OperatorFilter<TItem> implements Bson {
        private final String operatorName;
        private final String fieldName;
        private final TItem value;

        OperatorFilter(final String operatorName, final String fieldName, final TItem value) {
            this.operatorName = notNull("operatorName", operatorName);
            this.fieldName = notNull("fieldName", fieldName);
            this.value = value;
        }

        public <TDocument> BsonDocument toBsonDocument(final Class<TDocument> documentClass, final CodecRegistry codecRegistry) {
            BsonDocumentWriter writer = new BsonDocumentWriter(new BsonDocument());

            writer.writeStartDocument();
            writer.writeName(fieldName);
            writer.writeStartDocument();
            writer.writeName(operatorName);
            BuildersHelper.encodeValue(writer, value, codecRegistry);
            writer.writeEndDocument();
            writer.writeEndDocument();

            return writer.getDocument();
        }
    }

}

// copy from com.mongodb.client.model.BuildersHelper
final class BuildersHelper {

    @SuppressWarnings("unchecked")
    static <TItem> void encodeValue(final BsonDocumentWriter writer, final TItem value, final CodecRegistry codecRegistry) {
        if (value == null) {
            writer.writeNull();
        } else if (value instanceof Bson) {
            ((Encoder) codecRegistry.get(BsonDocument.class)).encode(writer,
                    ((Bson) value).toBsonDocument(BsonDocument.class, codecRegistry),
                    EncoderContext.builder().build());
        } else {
            ((Encoder) codecRegistry.get(value.getClass())).encode(writer, value, EncoderContext.builder().build());
        }
    }

    private BuildersHelper() {
    }
}
