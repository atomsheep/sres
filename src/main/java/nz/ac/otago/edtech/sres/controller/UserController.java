package nz.ac.otago.edtech.sres.controller;

import com.mongodb.MongoClient;
import com.mongodb.client.FindIterable;
import com.mongodb.client.MongoDatabase;
import com.mongodb.client.model.UpdateOptions;
import com.mongodb.client.result.DeleteResult;
import nz.ac.otago.edtech.spring.bean.UploadLocation;
import nz.ac.otago.edtech.spring.util.OtherUtil;
import nz.ac.otago.edtech.sres.util.MongoUtil;
import nz.ac.otago.edtech.util.ServletUtil;
import org.apache.commons.csv.CSVFormat;
import org.apache.commons.csv.CSVParser;
import org.apache.commons.csv.CSVRecord;
import org.apache.commons.io.input.BOMInputStream;
import org.apache.commons.lang3.StringUtils;
import org.bson.Document;
import org.bson.types.ObjectId;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import javax.annotation.PostConstruct;
import javax.servlet.http.HttpServletRequest;
import java.io.*;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;

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

    private static final Logger log = LoggerFactory.getLogger(UserController.class);


    private static final String[] USER_FIELDS = {"username", "givenNames", "surname", "preferredName", "email", "phone"};

    @Autowired
    private UploadLocation uploadLocation;


    DateFormat format = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'", Locale.ENGLISH);


    @Autowired
    MongoClient mongoClient;

    @Value("${mongodb.dbname}")
    private String dbName;


    private static final String COLLECTION_NAME_PAPERS = "papers";
    private static final String COLLECTION_NAME_USERS = "users";
    private static final String COLLECTION_NAME_COLUMNS = "columns";
    private static final String COLLECTION_NAME_USERDATA = "userdata";

    MongoDatabase db = null;

    @PostConstruct
    public void init() {
        db = mongoClient.getDatabase(dbName);
    }

    @RequestMapping(method = RequestMethod.GET)
    public String home(ModelMap model) {

        List<Document> documents = MongoUtil.getAllDocuments(db, COLLECTION_NAME_PAPERS);
        model.put("list", documents);
        model.put("pageName", "user");
        return Common.DEFAULT_VIEW_NAME;
    }


    @RequestMapping(value = "/addPaper", method = RequestMethod.GET)
    public String addPaper(ModelMap model) {
        model.put("pageName", "addPaper");
        return Common.DEFAULT_VIEW_NAME;
    }


    @RequestMapping(value = "/addPaper", method = RequestMethod.POST)
    public String addPaper(HttpServletRequest request) {
        ObjectId id = MongoUtil.insertOne(request, db, COLLECTION_NAME_PAPERS);
        log.debug("id {}", id);
        return "redirect:/user/addStudentList/" + id.toString();
    }

    @RequestMapping(value = "/addStudentList/{id}", method = RequestMethod.GET)
    public String editStudentList(@PathVariable String id, ModelMap model) {
        model.put("id", id);
        model.put("pageName", "addStudentList");
        return Common.DEFAULT_VIEW_NAME;
    }

    @RequestMapping(value = "/addStudentList", method = RequestMethod.POST)
    public String editStudentList(
            @RequestParam("files") MultipartFile file,
            @RequestParam("id") String id,
            ModelMap model) {
        File upload = new File(uploadLocation.getUploadDir(), file.getOriginalFilename());
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
        model.put("fields", USER_FIELDS);
        model.put("pageName", "mapFields");
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
        int[] index = new int[USER_FIELDS.length];
        for (int i = 0; i < USER_FIELDS.length; i++)
            index[i] = ServletUtil.getParameter(request, USER_FIELDS[i], -1);

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
            Document paper = MongoUtil.getDocument(db, COLLECTION_NAME_PAPERS, paperId);
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
                    Map userMap = new ModelMap();
                    userMap.put("role", "student");
                    for (int i = 0; i < USER_FIELDS.length; i++) {
                        if (index[i] != -1)
                            userMap.put(USER_FIELDS[i], record.get(index[i]));
                    }
                    Map userInfo = new ModelMap();
                    for (String k : userInfoFields.keySet()) {
                        int ii = userInfoFields.get(k);
                        if (ii != -1) {
                            userInfo.put(k, record.get(ii));
                        }
                    }
                    // paper info
                    Map pp = new ModelMap();
                    pp.put("paperref", paperId);
                    if (!userInfo.isEmpty())
                        pp.put("userInfo", userInfo);

                    Document oldUser = MongoUtil.getDocument(db, COLLECTION_NAME_USERS, USER_FIELDS[0], userMap.get(USER_FIELDS[0]));
                    if (oldUser == null) {
                        // insert a new user
                        ObjectId userId = new ObjectId();
                        userMap.put("_id", userId);
                        List<Map> papers = new ArrayList<Map>();
                        papers.add(pp);
                        userMap.put("papers", papers);
                        db.getCollection(COLLECTION_NAME_USERS).insertOne(new Document(userMap));
                    } else {
                        // update user
                        if (oldUser.get("papers") == null) {
                            List<Map> papers = new ArrayList<Map>();
                            papers.add(pp);
                            userMap.put("papers", papers);
                        } else {
                            List<Map> papers = new ArrayList<Map>();
                            @SuppressWarnings("unchecked")
                            List<Map> papersDoc = (List<Map>) oldUser.get("papers");
                            for (Map p : papersDoc) {
                                if (!p.get("paperref").equals(paperId))
                                    papers.add(p);
                                else {
                                    p.putAll(pp);
                                    pp = p;
                                }
                            }
                            papers.add(pp);
                            userMap.put("papers", papers);
                        }
                        db.getCollection(COLLECTION_NAME_USERS).updateOne(new Document(USER_FIELDS[0], userMap.get(USER_FIELDS[0])),
                                new Document("$set", new Document(userMap)));
                    }
                }
            } catch (IOException ioe) {
                log.error("IOException", ioe);
            }
        }
        return "redirect:/user/viewPaper/" + id;
    }

    @RequestMapping(value = "/importStudentData/{id}", method = RequestMethod.GET)
    public String importStudentData(@PathVariable String id, ModelMap model) {
        model.put("id", id);
        model.put("pageName", "importStudentData");
        return Common.DEFAULT_VIEW_NAME;
    }


    @RequestMapping(value = "/importStudentData", method = RequestMethod.POST)
    public String importStudentData(
            @RequestParam("files") MultipartFile file,
            @RequestParam("id") String id,
            ModelMap model) {
        File upload = new File(uploadLocation.getUploadDir(), file.getOriginalFilename());
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
        model.put("fields", USER_FIELDS);
        model.put("pageName", "mapDataFields");
        return Common.DEFAULT_VIEW_NAME;
    }

    @RequestMapping(value = "/importGrade", method = RequestMethod.POST)
    public String importGrade(HttpServletRequest request,
                              @RequestParam("id") String id,
                              @RequestParam("size") int size,
                              @RequestParam("filename") String filename) {

        boolean hasHeader = false;
        if (request.getParameter("hasHeader") != null)
            hasHeader = true;
        int unIndex = ServletUtil.getParameter(request, USER_FIELDS[0], -1);
        ObjectId paperId = new ObjectId(id);
        Document paper = MongoUtil.getDocument(db, COLLECTION_NAME_PAPERS, paperId);
        if (unIndex != -1) {
            List<Map> columnFields = new ArrayList<Map>();
            for (int i = 0; i < size; i++) {
                if (request.getParameter("extra" + i) != null) {
                    String name = request.getParameter("name" + i).trim();
                    String description = request.getParameter("description" + i);
                    int value = ServletUtil.getParameter(request, "value" + i, -1);
                    if ((name != null) && (value != -1)) {
                        Map map = new ModelMap();
                        map.put("name", name);
                        map.put("description", description);
                        map.put("index", value);
                        map.put("paperref", paperId);
                        columnFields.add(map);
                        UpdateOptions uo = new UpdateOptions();
                        uo.upsert(true);

                        FindIterable<Document> iterable = db.getCollection(COLLECTION_NAME_COLUMNS).find(and(eq("name", name), eq("paperref", paperId)));
                        for(Document dd: iterable ) {
                            log.debug("dd = {}", dd);
                        }

                        db.getCollection(COLLECTION_NAME_COLUMNS).updateOne(and(eq("name", name), eq("paperref", paperId)),
                              new Document("$set",  new Document(map)), uo);
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
                            Document user = MongoUtil.getDocument(db, COLLECTION_NAME_USERS, eq("papers.paperref", paperId), eq(USER_FIELDS[0], un));
                            if (user != null)
                                for (Map m : columnFields) {
                                    Map datum = new ModelMap();
                                    datum.put("colref", m.get("_id"));
                                    datum.put("userref", user.get("_id"));
                                    datum.put("value", record.get((Integer) m.get("index")));
                                    UpdateOptions uo = new UpdateOptions();
                                    uo.upsert(true);
                                    db.getCollection(COLLECTION_NAME_USERDATA).updateOne(and(eq("colref", m.get("_id")), eq("userref", user.get("_id"))),
                                          new Document("$set",  new Document(datum)), uo);
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


    @RequestMapping(value = "/deletePaper/{id}", method = RequestMethod.GET)
    public ResponseEntity<String> deletePaper(@PathVariable String id) {
        String action = "deletePaper";
        boolean success = false;
        String detail = null;

        ObjectId oi = new ObjectId(id);

        DeleteResult result = db.getCollection(COLLECTION_NAME_PAPERS).deleteOne(eq("_id", oi));
        if (result.getDeletedCount() == 1)
            success = true;
        return OtherUtil.outputJSON(action, success, detail);
    }

    @RequestMapping(value = "/viewPaper/{id}", method = RequestMethod.GET)
    public String viewPaper(@PathVariable String id, ModelMap model) {
        ObjectId paperId = new ObjectId(id);
        model.put("paper", MongoUtil.getDocument(db, COLLECTION_NAME_PAPERS, paperId));

        List<Document> users = new ArrayList<Document>();
        FindIterable<Document> iterable = db.getCollection(COLLECTION_NAME_USERS).find(eq("papers.paperref", paperId));
        for (Document document : iterable)
            users.add(document);
        model.put("users", users);

        model.put("pageName", "viewPaper");
        return Common.DEFAULT_VIEW_NAME;
    }

    @RequestMapping(value = "/viewStudentList/{id}", method = RequestMethod.GET)
    public String viewStudentList(@PathVariable String id, ModelMap model) {
        ObjectId paperId = new ObjectId(id);
        List<ModelMap> results = new ArrayList<ModelMap>();

        List<Document> users = MongoUtil.getDocuments(db, COLLECTION_NAME_USERS, "papers.paperref", paperId);
        List<Document> columns = MongoUtil.getDocuments(db, COLLECTION_NAME_COLUMNS, "paperref", paperId);

        model.put("columns", columns);
        for(Document u: users) {
            ModelMap result = new ModelMap();
            result.putAll(u);
            List<ModelMap> data = new ArrayList<ModelMap>();
            for(Document c : columns) {
                ModelMap datum =  new ModelMap();
                Document userData  = MongoUtil.getDocument(db, COLLECTION_NAME_USERDATA, eq("userref", u.get("_id")), eq("colref", c.get("_id")));
                datum.put("column", c);
                datum.put("data", userData);
                data.add(datum);
            }
            result.put("data", data);
            results.add(result);
        }
        model.put("results", results);

        model.put("pageName", "viewStudentList");
        return Common.DEFAULT_VIEW_NAME;
    }

    @RequestMapping(value = "/viewColumnList/{id}", method = RequestMethod.GET)
    public String viewColumnList(@PathVariable String id, ModelMap model) {
        ObjectId paperId = new ObjectId(id);
        Document paper = MongoUtil.getDocument(db, COLLECTION_NAME_PAPERS, paperId);
        model.put("paper", paper);

        List<Document> columns = MongoUtil.getDocuments(db, COLLECTION_NAME_COLUMNS, "paperref", paperId);
        log.debug("columns {}", columns);
        model.put("columns", columns);

        model.put("pageName", "viewColumnList");
        return Common.DEFAULT_VIEW_NAME;
    }

    @RequestMapping(value = "/mongo", method = RequestMethod.GET)
    public String mongo(HttpServletRequest request, ModelMap model) {
        List<Document> documents = new ArrayList<Document>();
        ObjectId id = new ObjectId("56c29ee5628be38bcea305bf");
        FindIterable<Document> iterable = db.getCollection(COLLECTION_NAME_PAPERS).find(eq("_id", id));
        for (Document document : iterable) {
            log.debug("document {}", document);
            documents.add(document);
        }
        model.put("list", documents);
        model.put("pageName", "user");
        return Common.DEFAULT_VIEW_NAME;
    }

    @RequestMapping(value = "/insert", method = RequestMethod.GET)
    public String insert(HttpServletRequest request, ModelMap model) {
        try {
            db.getCollection("restaurants").insertOne(
                    new Document("address",
                            new Document()
                                    .append("street", "2 Avenue")
                                    .append("zipcode", "10075")
                                    .append("building", "1480")
                                    .append("coord", asList(-73.9557413, 40.7720266)))
                            .append("borough", "Manhattan")
                            .append("cuisine", "Italian")
                            .append("grades", asList(
                                    new Document()
                                            .append("date", format.parse("2014-10-01T00:00:00Z"))
                                            .append("grade", "A")
                                            .append("score", "32"),
                                    new Document()
                                            .append("date", format.parse("2014-01-16T00:00:00Z"))
                                            .append("grade", "B")
                                            .append("score", "28")))
                            .append("name", "Vella")
                            .append("restaurant_id", "4795458"));

        } catch (ParseException pe) {
            log.error("ParseException", pe);
        }
        model.put("pageName", "user");
        return Common.DEFAULT_VIEW_NAME;
    }

}