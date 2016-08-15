package nz.ac.otago.edtech.sres.controller;

import com.mongodb.Mongo;
import com.mongodb.MongoClient;
import com.mongodb.client.AggregateIterable;
import com.mongodb.client.FindIterable;
import com.mongodb.client.MongoDatabase;
import com.mongodb.client.model.UpdateOptions;
import com.mongodb.client.result.DeleteResult;
import com.mongodb.client.result.UpdateResult;
import nz.ac.otago.edtech.auth.util.AuthUtil;
import nz.ac.otago.edtech.spring.bean.UploadLocation;
import nz.ac.otago.edtech.spring.util.OtherUtil;
import nz.ac.otago.edtech.sres.util.MailUtil;
import nz.ac.otago.edtech.sres.util.MongoUtil;
import nz.ac.otago.edtech.util.CommonUtil;
import nz.ac.otago.edtech.util.JSONUtil;
import nz.ac.otago.edtech.util.ServletUtil;
import org.apache.commons.collections.ListUtils;
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
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.beans.propertyeditors.CustomDateEditor;
import org.springframework.http.HttpStatus;
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
import static com.mongodb.client.model.Filters.in;
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
        Document user = MongoUtil.getUserByUsername(db, userName);
        if (user == null) {
            Document userMap = new Document();
            userMap.put(MongoUtil.USERNAME, userName);
            // TODO: load user information here
            db.getCollection(MongoUtil.COLLECTION_NAME_USERS).insertOne(new Document(userMap));
            user = MongoUtil.getDocument(db, MongoUtil.COLLECTION_NAME_USERS, MongoUtil.USERNAME, userName);
        }
        model.put("user", user);
        List<Document> documents = new ArrayList<Document>();
        AggregateIterable<Document> iterable = db.getCollection(MongoUtil.COLLECTION_NAME_PAPERS).aggregate(asList(
        		new Document("$match", new Document("owner", new Document("$elemMatch",new Document("$eq",user.get("_id")))).append("status", "active")),
                new Document("$lookup", new Document("from", MongoUtil.COLLECTION_NAME_USERS).append("localField", "_id").append("foreignField", "papers.paperref").append("as", "users"))));
        for (Document document : iterable) {
            documents.add(document);
        }
        model.put("list", documents);
        model.put("pageName", "user");
        MongoUtil.putCommonIntoModel(db, request, model);
        return Common.DEFAULT_VIEW_NAME;
    }

    // display edit paper form 1/5
    @RequestMapping(value = "/editPaper", method = RequestMethod.GET)
    public String editPaper(HttpServletRequest request,
                            ModelMap model) {
        model.put("pageName", "editPaper");
        MongoUtil.putCommonIntoModel(db, request, model);
        return Common.DEFAULT_VIEW_NAME;
    }

    // display edit paper form (for existing paper) 1/5
    @RequestMapping(value = "/editPaper/{id}", method = RequestMethod.GET)
    public String editPaper(@PathVariable String id,
                            HttpServletRequest request,
                            ModelMap model) {
        Document paper = MongoUtil.getDocument(db, MongoUtil.COLLECTION_NAME_PAPERS, id);
        Document extra = (Document) paper.get("extra");
        model.put("paper", paper);
        model.put("extra", extra);
        model.put("pageName", "editPaper");
        MongoUtil.putCommonIntoModel(db, request, model);
        return Common.DEFAULT_VIEW_NAME;
    }

    // save paper information
    @RequestMapping(value = "/savePaper", method = RequestMethod.POST)
    public String savePaper(@RequestParam(value = "_id", required = false) String _id,
                            @RequestParam("code") String code,
                            @RequestParam("name") String name,
                            @RequestParam("year") String year,
                            @RequestParam("semester") String semester,
                            @RequestParam("size") int size,
                            HttpServletRequest request) {

        Document extra = new Document();
        for (int i = 0; i < size; i++) {
            if ((request.getParameter("key_" + i) != null) && (request.getParameter("value_" + i) != null)) {
                String key = request.getParameter("key_" + i).trim();
                String value = request.getParameter("value_" + i).trim();
                if (StringUtils.isNotBlank(key))
                    extra.put(key, value);
            }
        }
        Date now = new Date();
        ObjectId id;
        Document paper;
        if (_id == null) {
            id = new ObjectId();
            paper = new Document();
            String userName = AuthUtil.getUserName(request);
            Document user = MongoUtil.getUserByUsername(db, userName);
            paper.put("_id", id);
            List<ObjectId> owners=new ArrayList<ObjectId>();
            owners.add((ObjectId)user.get("_id"));
            paper.put("owner", owners);
            paper.put("status", "active");
            paper.put("created", now);
            log.debug("new paper id {}", id);
            // paper info
            Document pp = new Document();
            pp.put("paperref", id);
            List<String> roles = new ArrayList<String>();
            roles.add("owner");
            pp.put("roles", roles);
            db.getCollection(MongoUtil.COLLECTION_NAME_USERS).updateOne(eq("_id", user.get("_id")),
                    new Document("$addToSet", new Document("papers", pp)));
            log.debug("new paper id {}", id);
        } else {
            paper = MongoUtil.getPaper(db, _id);
            paper.put("lastModified", now);
            id = new ObjectId(_id);
        }

        paper.put("code", code);
        paper.put("name", name);
        paper.put("year", year);
        paper.put("semester", semester);
        paper.put("extra", extra);

        db.getCollection(MongoUtil.COLLECTION_NAME_PAPERS)
                .updateOne(eq("_id", id), new Document("$set", new Document(paper)),
                        new UpdateOptions().upsert(true));

        return "redirect:/user/addStudentList/" + id.toString();
    }

    // display upload student list form  2/5
    @RequestMapping(value = "/addStudentList/{id}", method = RequestMethod.GET)
    public String editStudentList(@PathVariable String id,
                                  HttpServletRequest request,
                                  ModelMap model) {
        model.put("id", id);
        model.put("pageName", "addStudentList");
        MongoUtil.putCommonIntoModel(db, request, model);
        return Common.DEFAULT_VIEW_NAME;
    }

    // upload student list, redirect to fields mapping page
    @RequestMapping(value = "/addStudentList", method = RequestMethod.POST)
    public String editStudentList(@RequestParam("files") MultipartFile file,
                                  @RequestParam("id") String id) {
        // when no file uploaded, go to view paper page
        if (file.getSize() == 0)
            return "redirect:/user/viewPaper/" + id;

        ObjectId paperId = new ObjectId(id);
        Document paper = MongoUtil.getPaper(db, paperId);
        File paperDir = MongoUtil.getPaperDir(uploadLocation, paper);
        if (!paperDir.exists())
            paperDir.mkdirs();
        String filename = CommonUtil.getUniqueFilename(paperDir.getAbsolutePath(), file.getOriginalFilename());
        File upload = new File(paperDir, filename);
        if (StringUtils.isNotBlank(upload.getPath())) {
            try {
                file.transferTo(upload);
                db.getCollection(MongoUtil.COLLECTION_NAME_PAPERS).updateOne(
                        eq("_id", paperId),
                        new Document("$set", new Document("studentFile", filename))
                );
            } catch (IOException e) {
                log.error("Exception", e);
            }
        }
        return "redirect:/user/mapFields/" + id;
    }

    // upload student list, display fields mapping page 3/5
    @RequestMapping(value = "/mapFields/{id}", method = RequestMethod.GET)
    public String mapFields(@PathVariable String id,
                            HttpServletRequest request,
                            ModelMap model) {
        Document paper = MongoUtil.getDocument(db, MongoUtil.COLLECTION_NAME_PAPERS, id);
        String filename = paper.get("studentFile").toString();
        File paperDir = MongoUtil.getPaperDir(uploadLocation, paper);
        File upload = new File(paperDir, filename);
        if (upload.exists()) {
            try {
            	JSONParser parser=new JSONParser();
            	List<String> columns = new ArrayList<String>();
            	List<String> values = new ArrayList<String>();
                // read csv file without header
                Reader in = new FileReader(upload);
				if (upload.getName().endsWith("json")) {

					JSONArray records = (JSONArray) parser.parse(in);
					if (records.size() > 0) {
						JSONObject object = (JSONObject) records.get(0);
						columns.addAll(object.keySet());
						values.addAll(object.values());
						model.put("record", columns);
						model.put("columns", columns);
						model.put("values", values);
					}

				} else if (upload.getName().endsWith("csv") || upload.getName().endsWith("tsv") ) {
	
						Iterable<CSVRecord> records;
						if(upload.getName().endsWith("csv")) {
				           records = CSVFormat.EXCEL.parse(in);
						}else{
							records = CSVFormat.TDF.parse(in);
						}
		                CSVRecord record = records.iterator().next();
		                if (record != null) {
		                 
		                    for (String s : record) {
		                        columns.add(s);
		                    }
		                    model.put("record", columns);
		                    model.put("columns", columns);
		                }
		                record = records.iterator().next();
		                if (record != null) {
		                    values = new ArrayList<String>();
		                    for (String s : record) {
		                        values.add(s);
		                    }
		                    model.put("values", values);
		                }
				}
     
             
                model.put("id", id);
            } catch (IOException e) {
                log.error("Exception", e);
            } catch (ParseException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
        }
        model.put("fields", MongoUtil.USER_FIELDS);
        model.put("pageName", "mapFields");
     
        MongoUtil.putCommonIntoModel(db, request, model);
        return Common.DEFAULT_VIEW_NAME;
    }

    // save user information into users, redirect to upload student data page
    @RequestMapping(value = "/importUser", method = RequestMethod.POST)
    public String importUser(HttpServletRequest request,
                             @RequestParam("id") String id,
                             @RequestParam(value = "identifiers", required = false) int[] identifiers,
                             @RequestParam("size") int size) {
        boolean hasHeader = false;
        if (request.getParameter("hasHeader") != null)
            hasHeader = true;

        List<String> columns = new ArrayList<String>();
        // get extra user information
        Map<String, Integer> userInfoFields = new HashMap<String, Integer>();
        for (int i = 0; i < size; i++) {
            if (request.getParameter("extra" + i) != null) {
                String key = request.getParameter("key" + i).trim();
                int value = ServletUtil.getParameter(request, "value" + i, -1);
                if ((key != null) && (value != -1)) {
                    userInfoFields.put(key, value);
                    columns.add(key);
                }
            }
        }
        List<String> identifierList = new ArrayList<String>();
        if (identifiers != null)
            for (int ii : identifiers) {
                String fieldName = request.getParameter("key" + ii);
                log.debug("ii = {} field name = {}", ii, fieldName);
                identifierList.add(fieldName);
            }

        // TODO: get old student fields first, then combine with new fields
        // update studentFields in paper
        db.getCollection(MongoUtil.COLLECTION_NAME_PAPERS).updateOne(
                eq("_id", new ObjectId(id)),
                new Document("$set", new Document("studentFields", columns).append("identifiers", identifierList))
        );
        Document paper = MongoUtil.getDocument(db, MongoUtil.COLLECTION_NAME_PAPERS, id);
        String filename = paper.get("studentFile").toString();
        File paperDir = MongoUtil.getPaperDir(uploadLocation, paper);
        File file = new File(paperDir, filename);
       try {
        if (file.exists()) {

			ObjectId paperId = new ObjectId(id);
				if (filename.endsWith("csv") || filename.endsWith("tsv")) {
					Iterable<CSVRecord> records;
					// try {
					if (hasHeader) {
						// read csv file with header
						InputStream input = new FileInputStream(file);
						Reader reader = new InputStreamReader(new BOMInputStream(input), "UTF-8");
						if (filename.endsWith("csv")) {
							records = new CSVParser(reader, CSVFormat.EXCEL.withHeader());
							
						} else {
							records = new CSVParser(reader, CSVFormat.TDF.withHeader());
						}
					} else {
						// read csv file without header
						Reader in = new FileReader(file);
						if (filename.endsWith("csv")) {
						records = CSVFormat.EXCEL.parse(in);
						}else{
							records = CSVFormat.TDF.parse(in);
						}
					}
					int studentCount = 0;
					// go through csv file
					for (CSVRecord record : records) {
                        Document userMap = new Document();
						// all user info into userInfo
                        Document userInfo = new Document();
						for (String k : userInfoFields.keySet()) {
							int ii = userInfoFields.get(k);
							if (ii != -1) {
								userInfo.put(k, record.get(ii));
							}
						}
						userMap.put("userInfo", userInfo);
						userMap.put("paperref", paperId);

						db.getCollection(MongoUtil.COLLECTION_NAME_USERS).insertOne(new Document(userMap));
						studentCount++;
					}
					// update studentCount for paper
					db.getCollection(MongoUtil.COLLECTION_NAME_PAPERS).updateOne(eq("_id", paperId),
							new Document("$set", new Document("studentCount", studentCount)));
					// } catch (IOException ioe) {
					// log.error("IOException", ioe);
					// }
				} else if (filename.endsWith("json")) {

					JSONParser parser=new JSONParser();
					
						Reader in = new FileReader(file);
						JSONArray records=(JSONArray)parser.parse(in);
				
					int studentCount = 0;
					// go through csv file
				//	for (CSVRecord record : records) {
					for(int i=0;i<records.size();i++) {
						JSONObject record=(JSONObject)records.get(i);
                        Document userMap = new Document();
						// all user info into userInfo
                        Document userInfo = new Document();
						for (String k : userInfoFields.keySet()) {
							int ii = userInfoFields.get(k);
							if (ii != -1) {
								userInfo.put(k, record.get(k));
							}
						}
						userMap.put("userInfo", userInfo);
						userMap.put("paperref", paperId);

						db.getCollection(MongoUtil.COLLECTION_NAME_USERS).insertOne(new Document(userMap));
						studentCount++;
					}
					// update studentCount for paper
					db.getCollection(MongoUtil.COLLECTION_NAME_PAPERS).updateOne(eq("_id", paperId),
							new Document("$set", new Document("studentCount", studentCount)));

				}
			}
	       }catch (IOException ioe) {
          
       } catch (ParseException parseException) {
    	   log.error("IOException",parseException);
		}
        return "redirect:/user/importStudentData/" + id;
    }

    // display upload student data page 4/5
    @RequestMapping(value = "/importStudentData/{id}", method = RequestMethod.GET)
    public String importStudentData(@PathVariable String id,
                                    HttpServletRequest request,
                                    ModelMap model) {
        model.put("id", id);
        model.put("pageName", "importStudentData");
        MongoUtil.putCommonIntoModel(db, request, model);
        return Common.DEFAULT_VIEW_NAME;
    }

    // upload student data, redirect to data fields mapping page
    @RequestMapping(value = "/importStudentData", method = RequestMethod.POST)
    public String importStudentData(
            @RequestParam("files") MultipartFile file,
            @RequestParam("id") String id,
            ModelMap model) {

        // when no file uploaded, go to view paper page
        if (file.getSize() == 0)
            return "redirect:/user/viewPaper/" + id;

        Document paper = MongoUtil.getDocument(db, MongoUtil.COLLECTION_NAME_PAPERS, id);
        model.put("studentFields", paper.get("studentFields"));
        File paperDir = MongoUtil.getPaperDir(uploadLocation, paper);
        if (!paperDir.exists())
            paperDir.mkdirs();
        String filename = CommonUtil.getUniqueFilename(paperDir.getAbsolutePath(), file.getOriginalFilename());
        File upload = new File(paperDir, filename);
        if (StringUtils.isNotBlank(upload.getPath())) {
            try {
                file.transferTo(upload);
                db.getCollection(MongoUtil.COLLECTION_NAME_PAPERS).updateOne(
                        eq("_id", new ObjectId(id)),
                        new Document("$set", new Document("dataFile", filename))
                );
            } catch (IOException e) {
                log.error("Exception", e);
            }
        }
        return "redirect:/user/mapDataFields/" + id;
    }

    // display data fields mapping page 5/5
    @RequestMapping(value = "/mapDataFields/{id}", method = RequestMethod.GET)
    public String mapDataFields(@PathVariable String id,
                                HttpServletRequest request,
                                ModelMap model) {

        Document paper = MongoUtil.getDocument(db, MongoUtil.COLLECTION_NAME_PAPERS, id);
        String filename = paper.get("dataFile").toString();
        @SuppressWarnings("unchecked")
        List<String> studentFields = (List<String>) paper.get("studentFields");
        @SuppressWarnings("unchecked")
        List<String> identifiers = (List<String>) paper.get("identifiers");

        Set<String> set = new LinkedHashSet<String>();
        set.addAll(identifiers);
        set.addAll(studentFields);
        model.put("studentFields", set);

        Document oneUser = MongoUtil.getDocument(db,MongoUtil.COLLECTION_NAME_USERS,"paperref",new ObjectId(id));
        model.put("userInfo",oneUser.get("userInfo"));

        File paperDir = MongoUtil.getPaperDir(uploadLocation, paper);
        File upload = new File(paperDir, filename);
        if (upload.exists()) {
            try {
				// read csv file without header
				Reader in = new FileReader(upload);
				if (upload.getName().endsWith("csv") || upload.getName().endsWith("tsv")) {
					Iterable<CSVRecord> records;
					if(upload.getName().endsWith("csv")){
						records = CSVFormat.EXCEL.parse(in);	
					}else{
						records = CSVFormat.TDF.parse(in);
					}
					CSVRecord record = records.iterator().next();
					if (record != null) {
						String[] columns = new String[record.size()];
						for (int i = 0; i < record.size(); i++) {
							columns[i] = record.get(i);
						}
						model.put("record", columns);
					}
					record = records.iterator().next();
					if (record != null) {
						String[] values = new String[record.size()];
						for (int i = 0; i < record.size(); i++) {
							values[i] = record.get(i);
						}
						model.put("values", values);
					}
					model.put("id", id);
				} else if (upload.getName().endsWith("json")) {

					JSONParser parser = new JSONParser();
					JSONArray records = (JSONArray) parser.parse(in);
					if (records.size() > 0) {
						JSONObject record = (JSONObject) records.get(0);
						Object columns[]=record.keySet().toArray();
						String values[]=new String[columns.length];
						int i=0;
						for(Object s:columns){
							values[i]=record.get(s.toString()).toString();
							i++;
						}
						model.put("record",columns );
						model.put("values", values);
						model.put("id", id);
					}					
				}
			} catch (IOException e) {
				log.error("Exception", e);
			} catch (ParseException parseException) {

				log.error("Exception", parseException);
			}
        }
        model.put("fields", MongoUtil.USER_FIELDS);
        model.put("pageName", "mapDataFields");
        MongoUtil.putCommonIntoModel(db, request, model);
        return Common.DEFAULT_VIEW_NAME;
    }

    // save student data into userdata
    @RequestMapping(value = "/importUserData", method = RequestMethod.POST)
    public ResponseEntity<String> importUserData(HttpServletRequest request,
                                                 @RequestParam("id") String id,
                                                 @RequestParam("size") int size) {

        String action = "importUserData";
        boolean success;
        String detail = null;
        String userName = AuthUtil.getUserName(request);
        Document user = MongoUtil.getUserByUsername(db, userName);
        boolean hasHeader = false;
        if (request.getParameter("hasHeader") != null)
            hasHeader = true;
        String fieldName = ServletUtil.getParameter(request, "sres_id");
        int unIndex = ServletUtil.getParameter(request, "csv_id", -1);
        ObjectId paperId = new ObjectId(id);
        Document paper = MongoUtil.getPaper(db, paperId);
        // update paper identifiers
        db.getCollection(MongoUtil.COLLECTION_NAME_PAPERS).updateOne(eq("_id", paperId),
                new Document("$addToSet", new Document("identifiers", fieldName)));

        int userCount = 0;
        if (unIndex != -1) {
            List<Document> columnFields = new ArrayList<Document>();
            for (int i = 0; i < size; i++) {
                if (request.getParameter("extra" + i) != null) {
                    String name = request.getParameter("name" + i).trim();
                    String description = request.getParameter("description" + i);
                    int value = ServletUtil.getParameter(request, "value" + i, -1);
                    if ((name != null) && (value != -1)) {
                        Document map = new Document();
                        map.put("name", name);
                        map.put("description", description);
                        map.put("index", value);
                        map.put("paperref", paperId);
                        map.put("identifier", fieldName);
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
            try {
				if (!columnFields.isEmpty()) {
					String filename = paper.get("dataFile").toString();
					File paperDir = MongoUtil.getPaperDir(uploadLocation, paper);
					File upload = new File(paperDir, filename);
					if (upload.exists()) {
						if (upload.getName().endsWith("csv") || upload.getName().endsWith("tsv")) {
							Iterable<CSVRecord> records;

							if (hasHeader) {
								// read csv file with header
								InputStream input = new FileInputStream(upload);
								Reader reader = new InputStreamReader(new BOMInputStream(input), "UTF-8");
								if(upload.getName().endsWith("csv")){
									records = new CSVParser(reader, CSVFormat.EXCEL.withHeader());		
								}else{
									records = new CSVParser(reader, CSVFormat.TDF.withHeader());
								}
							
							} else {
								// read csv file without header
								Reader in = new FileReader(upload);
								if(upload.getName().endsWith("csv")){
									records = CSVFormat.EXCEL.parse(in);
								}else{
									records = CSVFormat.TDF.parse(in);
								}
							}
							// go through csv file
							for (CSVRecord record : records) {
								String un = record.get(unIndex);
								Document uu = MongoUtil.getDocument(db, MongoUtil.COLLECTION_NAME_USERS,
										eq("paperref", paperId), eq("userInfo." + fieldName, un));
								log.debug("find user.");
								if ((uu != null) && (uu.get("_id") != null)) {
									userCount++;
									for (Document d : columnFields) {
										ObjectId colref = (ObjectId) d.get("_id");
										ObjectId userref = (ObjectId) uu.get("_id");
										String value = record.get((Integer) d.get("index")).trim();
										MongoUtil.saveNewUserData(db, value, colref, userref, user);
									}
								}
							}
						} else if (upload.getName().endsWith("json")) {
							Reader in = new FileReader(upload);
							JSONParser parser=new JSONParser();
							JSONArray records=(JSONArray)parser.parse(in);
							for (int i = 0; i < records.size(); i++) {

								JSONObject record = (JSONObject) records.get(i);
								String un = (String)record.get(columnFields.get(unIndex).get("name"));
								Document uu = MongoUtil.getDocument(db, MongoUtil.COLLECTION_NAME_USERS,
										eq("paperref", paperId), eq("userInfo." + fieldName, un));
								log.debug("find user.");
								if ((uu != null) && (uu.get("_id") != null)) {
									userCount++;
									for (Document d : columnFields) {
										ObjectId colref = (ObjectId) d.get("_id");
										ObjectId userref = (ObjectId) uu.get("_id");
										String value = record.get(d.get("name")).toString().trim();
										MongoUtil.saveNewUserData(db, value, colref, userref, user);
									}

								}
							}
							
						}

					}
				}
			} catch (IOException ioe) {
				log.error("IOException", ioe);
			} catch (ParseException parseException) {
				log.error("ParseException", parseException);
			}
		}
        success = true;
        Document extra = new Document();
        extra.put("userCount", userCount);
        extra.put("studentCount", paper.get("studentCount"));
        extra.put("paperId", id);
        return OtherUtil.outputJSON(action, success, detail, extra);
    }

    @RequestMapping(value = "/addRemoveUser", method = RequestMethod.POST)
    public ResponseEntity<String> addRemoveUser(@RequestParam("emailId") String emailId,
                                                @RequestParam("userId") String userId,
                                                @RequestParam("remove") boolean remove) {

        String action = "addRemoveUser";
        boolean success = true;
        String detail = null;
        String operation = remove ? "$addToSet" : "$pull";

        db.getCollection(MongoUtil.COLLECTION_NAME_INTERVENTIONS).updateOne(eq("_id", new ObjectId(emailId)),
            new Document(operation, new Document("uncheckedList", userId))
        );
        return OtherUtil.outputJSON(action, success, detail);
    }

    @RequestMapping(value = "/saveEmail", method = RequestMethod.POST)
    public ResponseEntity<String> saveEmail(@RequestParam("emailId") String emailId,
                                            @RequestParam("name") String name,
                                            @RequestParam("value") String value) {

        String action = "saveEmail";
        boolean success = true;
        String detail = null;
        if (StringUtils.isNotBlank(name) && StringUtils.isNotBlank(value)) {
            db.getCollection(MongoUtil.COLLECTION_NAME_INTERVENTIONS).updateOne(eq("_id", new ObjectId(emailId)),
                    new Document("$set", new Document(name, value))
            );
        }
        return OtherUtil.outputJSON(action, success, detail);
    }

    @RequestMapping(value = "/saveParagraph", method = RequestMethod.POST)
    public ResponseEntity<String> saveParagraph(@RequestParam("id") String id,
                                            @RequestParam("value") String value) {

        String action = "saveParagraph";
        boolean success = true;
        String detail = null;
        if (StringUtils.isNotBlank(value)) {
            db.getCollection(MongoUtil.COLLECTION_NAME_PARAGRAPHS).updateOne(eq("_id", new ObjectId(id)),
                    new Document("$set", new Document("text", value))
            );
        }
        return OtherUtil.outputJSON(action, success, detail);
    }

    @RequestMapping(value = "/emailStudents", method = RequestMethod.POST)
    public String emailStudents(HttpServletRequest request,
                                @RequestParam("id") String id,
                                @RequestParam("usernames") String[] userIds) {
        ObjectId paperId = new ObjectId(id);
        Document paper = MongoUtil.getPaper(db, paperId);
        String studentName = null;
        @SuppressWarnings("unchecked")
        List<String> identifiers = (List<String>) paper.get("identifiers");
        if (identifiers != null)
            studentName = identifiers.get(0);
        String userName = AuthUtil.getUserName(request);
        Document user = MongoUtil.getUserByUsername(db, userName);
        Document email = new Document();
        ObjectId eid = new ObjectId();
        email.put("_id", eid);
        email.put("owner", user.get("_id"));
        email.put("paperref", paperId);
        email.put("studentList", Arrays.asList(userIds));
        email.put("type", "email");
        email.put("fromemail", user.get("email"));
        email.put("status", "draft");
        email.put("created", new Date());
        email.put("subject", "[from " + paper.get("code") + "]");

        String introParagraph = (StringUtils.isBlank(studentName)) ? "Dear student," : "Dear {{student." + studentName + "}},";
        email.put("introductoryParagraph", introParagraph);

        String concludingParagraph = "Regards,\n\n{{user.firstName}}";
        email.put("concludingParagraph", concludingParagraph);
        db.getCollection(MongoUtil.COLLECTION_NAME_INTERVENTIONS).insertOne(new Document(email));
        return "redirect:/user/emailStudents/" + eid.toString();
    }

    @RequestMapping(value = "/emailStudents/{id}", method = RequestMethod.GET)
    public String emailStudents(@PathVariable String id,
                                HttpServletRequest request,
                                ModelMap model) {

        ObjectId emailId = new ObjectId(id);
        Document email = MongoUtil.getDocument(db, MongoUtil.COLLECTION_NAME_INTERVENTIONS, emailId);
        List<Document> paragraphs = MongoUtil.getDocuments(db,MongoUtil.COLLECTION_NAME_PARAGRAPHS,"emailref",emailId);
        email.put("paragraphs",paragraphs);
        model.put("email", email);

        @SuppressWarnings("unchecked")
        List<String> userIds = (List<String>) email.get("studentList");

        List<Document> users = new ArrayList<Document>();
        for (String uid : userIds) {
            FindIterable<Document> iterable = db.getCollection(MongoUtil.COLLECTION_NAME_USERS)
                    .find(eq("_id", new ObjectId(uid)));
            for (Document u : iterable)
                users.add(u);
        }

        ObjectId paperId = (ObjectId) email.get("paperref");
        List<Document> columns = MongoUtil.getDocuments(db, MongoUtil.COLLECTION_NAME_COLUMNS, "paperref", paperId);

        Document paper = MongoUtil.getDocument(db, MongoUtil.COLLECTION_NAME_PAPERS, paperId);
        model.put("paper", paper);
        model.put("studentFields", paper.get("studentFields"));
        model.put("columns", columns);
        model.put("users", users);
        model.put("pageName", "emailStudents");
        MongoUtil.putCommonIntoModel(db, request, model);
        return Common.DEFAULT_VIEW_NAME;
    }

    @RequestMapping(value = "/runConditional", method = RequestMethod.POST)
    public ResponseEntity<List<Document>> runConditional(@RequestParam("paragraphId") String paragraphId,
                                                         @RequestParam("colref") String colref,
                                                         @RequestParam("operator") String operator,
                                                         @RequestParam("value") String value) {

        List<Document> results = new ArrayList<Document>();
        Set<ObjectId> set = new HashSet<ObjectId>();
            Document paragraph = MongoUtil.getDocument(db, MongoUtil.COLLECTION_NAME_PARAGRAPHS,paragraphId);
            ObjectId emailId = (ObjectId)paragraph.get("emailref");
            Document email = MongoUtil.getDocument(db, MongoUtil.COLLECTION_NAME_INTERVENTIONS,emailId);
            List<String> studentList = (ArrayList)email.get("studentList");
            List<ObjectId> ids = new ArrayList<ObjectId>();

            for(String s : studentList){
                ids.add(new ObjectId(s));
            }
            Iterable<ObjectId> iterable = ids;

            Object o = value;
            if (NumberUtils.isNumber(value))
                o = NumberUtils.createNumber(value);
            Bson valueFilter = new OperatorFilter<Object>(operator, "data.0.value", o);
            Bson colFilter = eq("colref", new ObjectId(colref));

            List<Document> userdata = MongoUtil.getDocuments(db, MongoUtil.COLLECTION_NAME_USERDATA,colFilter,valueFilter, in("userref", iterable));
            if (set.isEmpty())
                for (Document doc : userdata)
                    set.add((ObjectId) doc.get("userref"));

        paragraph.put("studentList",set);
        paragraph.put("colref",colref);
        paragraph.put("operator",operator);
        paragraph.put("value",value);

        db.getCollection(MongoUtil.COLLECTION_NAME_PARAGRAPHS)
            .updateOne(eq("_id", new ObjectId(paragraphId)), new Document("$set", new Document(paragraph)),
                new UpdateOptions().upsert(true));

        {
            for (ObjectId oid : set) {
                Document doc = MongoUtil.getUser(db, oid);
                MongoUtil.changeUserObjectId2String(doc);
                results.add(doc);
            }
        }
        return new ResponseEntity<List<Document>>(results, HttpStatus.OK);
    }

    @RequestMapping(value = "/addAdditional", method = RequestMethod.POST)
    public String addAdditional(@RequestParam("id") String id,
                                @RequestParam("type") String type,
                                HttpServletRequest request,
                                ModelMap model) {
        ObjectId emailId = new ObjectId(id);
        Document email = MongoUtil.getDocument(db, MongoUtil.COLLECTION_NAME_INTERVENTIONS, "_id", emailId);
        ObjectId paragraphId = new ObjectId();
        Document paragraph = new Document("_id",paragraphId);
        paragraph.put("type",type);
        paragraph.put("emailref",emailId);

        db.getCollection(MongoUtil.COLLECTION_NAME_PARAGRAPHS)
                .updateOne(eq("_id", paragraphId), new Document("$set", new Document(paragraph)),
                        new UpdateOptions().upsert(true));

        List<Document> columns = MongoUtil.getDocuments(db, MongoUtil.COLLECTION_NAME_COLUMNS, "paperref", email.get("paperref"));
        model.put("columns",columns);
        model.put("paragraph",paragraph);
        model.put("id", id);
        model.put("baseUrl", ServletUtil.getContextURL(request));
        MongoUtil.putCommonIntoModel(db, request, model);
        return type+"Paragraph";
    }

    @RequestMapping(value = "/removeParagraph", method = RequestMethod.POST)
    public ResponseEntity<String> removeParagraph(@RequestParam("id") String id,
                                HttpServletRequest request,
                                ModelMap model) {
        ObjectId paragraphId = new ObjectId(id);
        DeleteResult dr = MongoUtil.removeDocument(db,MongoUtil.COLLECTION_NAME_PARAGRAPHS,"_id",paragraphId);
        model.put("baseUrl", ServletUtil.getContextURL(request));
        return OtherUtil.outputJSON("removeParagraph", true, "");
    }

    @RequestMapping(value = "/getParagraph/{id}", method = RequestMethod.GET)
    public String getParagraph(@PathVariable String id,
                               HttpServletRequest request,
                               ModelMap model){
        ObjectId paragraphId = new ObjectId(id);
        Document paragraph = MongoUtil.getDocument(db, MongoUtil.COLLECTION_NAME_PARAGRAPHS, "_id",paragraphId);
        Document email = MongoUtil.getDocument(db,MongoUtil.COLLECTION_NAME_INTERVENTIONS,"_id",paragraph.get("emailref"));

        List studentList = (ArrayList)paragraph.get("studentList");
        if(studentList != null){
            List<String> uncheckedList = (ArrayList)email.get("uncheckedList");
            List<ObjectId> uncheckedObList = new ArrayList<ObjectId>();

            for(String s : uncheckedList){
                uncheckedObList.add(new ObjectId(s));
            }

            List userList = ListUtils.subtract(studentList, uncheckedObList);
            paragraph.put("studentList",userList);
            List excludedList = ListUtils.intersection(studentList,uncheckedObList);
            paragraph.put("excludedList",excludedList);
        }

        String type = paragraph.get("type").toString();
        List<Document> columns = MongoUtil.getDocuments(db, MongoUtil.COLLECTION_NAME_COLUMNS, "paperref", email.get("paperref"));
        model.put("columns",columns);
        model.put("paragraph",paragraph);
        model.put("id", id);
        model.put("baseUrl", ServletUtil.getContextURL(request));
        MongoUtil.putCommonIntoModel(db, request, model);
        return type+"Paragraph";
    }

    @RequestMapping(value = "/emailPreview", method = RequestMethod.GET)
    public String emailPreview(@RequestParam("emailId") String emailId,
                               HttpServletRequest request,
                               ModelMap model) {

        String userName = AuthUtil.getUserName(request);
        Document teacher = MongoUtil.getDocument(db, MongoUtil.COLLECTION_NAME_USERS,"username",userName);
        Document email = MongoUtil.getDocument(db, MongoUtil.COLLECTION_NAME_INTERVENTIONS, emailId);
        List<String> studentList = MongoUtil.getStudentList(email);
        int size = 0;
        int index = 0;
        if (studentList != null)
            size = studentList.size();
        if (index < size) {
            String id = studentList.get(index);
            model = returnEmailModel(model,id,email,teacher,index,size);
        }
        model.put("emailId", emailId);
        model.put("pageName", "emailPreview");
        MongoUtil.putCommonIntoModel(db, request, model);
        return Common.DEFAULT_VIEW_NAME;
    }

    @RequestMapping(value = "/emailPreview/{index}", method = RequestMethod.GET)
    public String emailPreview(@PathVariable int index,
                               @RequestParam("emailId") String emailId,
                               HttpServletRequest request,
                               ModelMap model) {

        String userName = AuthUtil.getUserName(request);
        Document teacher = MongoUtil.getDocument(db, MongoUtil.COLLECTION_NAME_USERS,"username",userName);
        Document email = MongoUtil.getDocument(db, MongoUtil.COLLECTION_NAME_INTERVENTIONS, emailId);
        List<String> studentList = MongoUtil.getStudentList(email);
        int size = 0;
        if (studentList != null)
            size = studentList.size();
        // if index is too big or too small, set to 0
        if ((size > 0) && ((index >= size) || (index < 0)))
            index = 0;
        if (index < size) {
            String id = studentList.get(index);
            model = returnEmailModel(model, id, email, teacher, index, size);
        }

        model.put("emailId", emailId);
        model.put("pageName", "emailPreview");
        MongoUtil.putCommonIntoModel(db, request, model);
        return Common.DEFAULT_VIEW_NAME;
    }

    private ModelMap returnEmailModel(ModelMap model, String id, Document email, Document teacher, int index, int size){
        Document user = MongoUtil.getUser(db, id);
        List<Document> userdata = MongoUtil.getDocuments(db,MongoUtil.COLLECTION_NAME_USERDATA,eq("userref",user.get("_id")));
        List<Document> paragraphs = MongoUtil.getDocuments(db,MongoUtil.COLLECTION_NAME_PARAGRAPHS,eq("emailref",email.get("_id")));
        Document map = MongoUtil.getEmailInformation(user, userdata,teacher, email,paragraphs);
        String address = (String)map.get("address");
        String fromemail = (String)map.get("fromemail");
        String ccmail = (String)map.get("ccmail");
        String bccmail = (String)map.get("bccmail");
        String subject = (String)map.get("subject");
        String body = (String)map.get("body");
        model.put("emailAddress", address);
        model.put("fromemail", fromemail);
        model.put("ccmail", ccmail);
        model.put("bccmail", bccmail);
        model.put("subject", subject);
        model.put("body", body);
        model.put("user", user);
        model.put("size", size);
        model.put("index", index);
        return model;
    }


    @RequestMapping(value = "/sendEmails", method = RequestMethod.POST)
    public ResponseEntity<String> sendEmails(@RequestParam("emailId") String emailId,
                                             @Value("${email.smtp.server}") String smtpServer,
                                             @Value("${in.development.mode}") boolean inDevelopmentMode,
                                             HttpServletRequest request) {

        String action = "sendEmails";
        boolean success = false;
        String detail = null;
        String userName = AuthUtil.getUserName(request);
        Document teacher = MongoUtil.getDocument(db, MongoUtil.COLLECTION_NAME_USERS,"username",userName);
        Document email = MongoUtil.getDocument(db, MongoUtil.COLLECTION_NAME_INTERVENTIONS, emailId);
        
        @SuppressWarnings("unchecked")
        List<String> studentList = (List<String>) email.get("studentList");
        @SuppressWarnings("unchecked")
        List<String> uncheckedList = (List<String>) email.get("uncheckedList");
        String emailField = (String) email.get("emailField");
        if (uncheckedList != null) {
            @SuppressWarnings("unchecked")
            List<String> userList = ListUtils.subtract(studentList, uncheckedList);
            studentList = userList;
        }
        String fromEmail = email.getString("fromemail");
        for (String u : studentList) {
            Document uu = MongoUtil.getUser(db, new ObjectId(u));
            List<Document> userdata = MongoUtil.getDocuments(db,MongoUtil.COLLECTION_NAME_USERDATA,eq("userref",uu.get("_id")));
            List<Document> paragraphs = MongoUtil.getDocuments(db,MongoUtil.COLLECTION_NAME_PARAGRAPHS,eq("emailref",email.get("_id")));
            Document map = MongoUtil.getEmailInformation(uu,userdata,teacher, email,paragraphs);
            String address = (String)map.get("address");
            String subject = (String)map.get("subject");
            String body = (String)map.get("body");
            String ccmail = (String)map.get("ccmail");
            String bccmail = (String)map.get("bccmail");
            if (StringUtils.isNotBlank(address) && address.contains("@")) {
            	fromEmail = (String)map.get("fromemail");
                log.debug("send email to {} with subject {} body {}", address, subject, body);
                if (inDevelopmentMode) {
                    //address = fromEmail;
                }
                success = MailUtil.sendEmail(smtpServer, fromEmail, null, address, subject, body,ccmail,bccmail);
            }
        }
        if(success) {
        db.getCollection(MongoUtil.COLLECTION_NAME_INTERVENTIONS).updateOne(eq("_id", new ObjectId(emailId)),
                new Document("$set", new Document("status", "sent")));
        }
        return OtherUtil.outputJSON(action, success, detail);
    }

    @RequestMapping(value = "/addColumn/{id}", method = RequestMethod.GET)
    public String addColumn(@PathVariable String id,
                            HttpServletRequest request,
                            ModelMap model) {
        model.put("paperId", id);
        model.put("pageName", "editColumn");
        MongoUtil.putCommonIntoModel(db, request, model);
        return Common.DEFAULT_VIEW_NAME;
    }

    @RequestMapping(value = "/editColumn/{id}", method = RequestMethod.GET)
    public String editColumn(@PathVariable String id,
                             HttpServletRequest request,
                             ModelMap model) {

        Document column = MongoUtil.getDocument(db, MongoUtil.COLLECTION_NAME_COLUMNS, id);
        Document extra = (Document) column.get("extra");
        model.put("column", column);
        model.put("extra", extra);
        model.put("paperId", column.get("paperref"));
        model.put("pageName", "editColumn");
        MongoUtil.putCommonIntoModel(db, request, model);
        return Common.DEFAULT_VIEW_NAME;
    }

    @RequestMapping(value = "/saveColumn", method = RequestMethod.POST)
    public String saveColumn(@RequestParam(value = "paperId", required = false) String paperId,
                             @RequestParam(value = "_id", required = false) String _id,
                             @RequestParam("name") String name,
                             @RequestParam(value = "description", required = false) String description,
                             @RequestParam("tags") String tags,
                             @RequestParam("size") int size,
                             HttpServletRequest request) {

        Document extra = new Document();
        for (int i = 0; i < size; i++) {
            if ((request.getParameter("key" + i) != null) && (request.getParameter("value" + i) != null)) {
                String key = request.getParameter("key" + i).trim();
                String value = request.getParameter("value" + i).trim();
                extra.put(key, value);
            }
        }
        Date now = new Date();
        ObjectId cId;
        Document column;

        if (_id == null) {
            cId = new ObjectId();
            column = new Document();
            column.put("_id", cId);
            ObjectId paperref = new ObjectId(paperId);
            column.put("paperref", paperref);
            column.put("created", now);
        } else {
            cId = new ObjectId(_id);
            column = MongoUtil.getDocument(db, MongoUtil.COLLECTION_NAME_COLUMNS, cId);
            column.put("lastModified", now);
        }

        column.put("name", name);
        if (description != null)
            column.put("description", description);
        column.put("tags", tags);
        column.put("extra", extra);

        db.getCollection(MongoUtil.COLLECTION_NAME_COLUMNS)
                .updateOne(eq("_id", cId), new Document("$set", new Document(column)),
                        new UpdateOptions().upsert(true));

        return "redirect:/user/editColumnRestrictions/" + cId.toString();
    }

    @RequestMapping(value = "/editColumnRestrictions/{id}", method = RequestMethod.GET)
    public String editColumnRestrictions(@PathVariable String id,
                                         HttpServletRequest request,
                                         ModelMap model) {

        Document column = MongoUtil.getDocument(db, MongoUtil.COLLECTION_NAME_COLUMNS, id);
        Document extra = (Document) column.get("extra");
        model.put("column", column);
        model.put("extra", extra);
        model.put("paperId", column.get("paperref"));
        model.put("pageName", "editColumnRestrictions");
        MongoUtil.putCommonIntoModel(db, request, model);
        return Common.DEFAULT_VIEW_NAME;
    }

    @RequestMapping(value = "/saveColumnRestrictions", method = RequestMethod.POST)
    public String saveColumnRestrictions(
            @RequestParam(value = "_id", required = false) String _id,
            @RequestParam(value = "activeFrom", required = false) Date activeFrom,
            @RequestParam(value = "activeTo", required = false) Date activeTo) {

        Date now = new Date();
        ObjectId cId = new ObjectId(_id);
        Document column = MongoUtil.getDocument(db, MongoUtil.COLLECTION_NAME_COLUMNS, cId);
        if (activeFrom != null)
            column.put("activeFrom", activeFrom);
        if (activeTo != null)
            column.put("activeTo", activeTo);
        column.put("lastModified", now);
        // update existing column
        db.getCollection(MongoUtil.COLLECTION_NAME_COLUMNS)
                .updateOne(eq("_id", cId), new Document("$set", new Document(column)));

        return "redirect:/user/editScanningInformation/" + cId.toString();
    }

    @RequestMapping(value = "/editScanningInformation/{id}", method = RequestMethod.GET)
    public String editScanningInformation(@PathVariable String id,
                                          HttpServletRequest request,
                                          ModelMap model) {

        Document column = MongoUtil.getDocument(db, MongoUtil.COLLECTION_NAME_COLUMNS, id);
        ObjectId pId = new ObjectId(column.get("paperref").toString());
        Document paper = MongoUtil.getPaper(db, pId);
        Document extra = (Document) column.get("extra");
        List<Document> columns = MongoUtil.getDocuments(db, MongoUtil.COLLECTION_NAME_COLUMNS, "paperref", pId);
        model.put("column", column);
        model.put("columns", columns);
        model.put("extra", extra);
        model.put("paper", paper);
        model.put("paperId", column.get("paperref"));
        model.put("pageName", "editScanningInformation");
        MongoUtil.putCommonIntoModel(db, request, model);
        return Common.DEFAULT_VIEW_NAME;
    }

    @RequestMapping(value = "/saveScanningInformation", method = RequestMethod.POST)
    public String saveScanningInformation(
            @RequestParam(value = "id", required = false) String _id,
            @RequestParam(value = "customDisplay", required = false) String customDisplay) {

        Date now = new Date();
        ObjectId cId = new ObjectId(_id);
        Document column = MongoUtil.getDocument(db, MongoUtil.COLLECTION_NAME_COLUMNS, cId);
        String pId = column.get("paperref").toString();

        if (customDisplay != null)
            column.put("customDisplay", customDisplay);

        column.put("lastModified", now);
        // update existing column
        db.getCollection(MongoUtil.COLLECTION_NAME_COLUMNS)
                .updateOne(eq("_id", cId), new Document("$set", new Document(column)));

        return "redirect:/user/viewColumnList/" + pId;
    }

    // remove given user (id) from paper (paperId)
    @RequestMapping(value = "/removeUser", method = RequestMethod.POST)
    public ResponseEntity<String> removeUser(@RequestParam("id") String id,
                                             @RequestParam("paperId") String paperId) {
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
        Document user = MongoUtil.getUserByUsername(db, userName);
        UpdateResult result = db.getCollection(MongoUtil.COLLECTION_NAME_PAPERS).updateOne(
                and(eq("_id", paperId), eq("owner", user.get("_id"))),
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
        Document paper = MongoUtil.getDocument(db, MongoUtil.COLLECTION_NAME_PAPERS, paperId);
        model.put("paper", paper);
        model.put("studentFields", paper.get("studentFields"));
        model.put("id", id);
        model.put("pageName", "viewPaper");
        MongoUtil.putCommonIntoModel(db, request, model);
        return Common.DEFAULT_VIEW_NAME;
    }

    @RequestMapping(value = "/saveDashboardLayout", method = RequestMethod.POST)
    public ResponseEntity<String> saveDashboardLayout(
            @RequestParam(value = "paperId", required = false) String paperId,
            @RequestParam(value = "gridData", required = false) String gridData) {

        ObjectId pId = new ObjectId(paperId);
        Document paper = MongoUtil.getDocument(db, MongoUtil.COLLECTION_NAME_PAPERS, pId);
        paper.put("gridData", gridData);

        // update existing column
        db.getCollection(MongoUtil.COLLECTION_NAME_PAPERS)
                .updateOne(eq("_id", pId), new Document("$set", new Document(paper)));

        return OtherUtil.outputJSON("", true, "");
    }

    @RequestMapping(value = "/addRemoveColumn", method = RequestMethod.POST)
    public ResponseEntity<String> addRemoveColumn(
            @RequestParam(value = "paperId", required = false) String paperId,
            @RequestParam(value = "columnId", required = false) String columnId,
            @RequestParam(value = "remove", required = false) boolean remove,
            HttpServletRequest request) {

        ObjectId pId = new ObjectId(paperId);
        String operation = remove ? "$addToSet" : "$pull";

        db.getCollection(MongoUtil.COLLECTION_NAME_PAPERS).updateOne(eq("_id", pId),
            new Document(operation, new Document("uncheckedList", columnId))
        );

        return OtherUtil.outputJSON("", true, "");
    }

    @RequestMapping(value = "/filterStudentList", method = RequestMethod.POST)
    public String filterStudentList(@RequestParam("id") String id,
                                    @RequestParam("json") String json,
                                    HttpServletRequest request,
                                    ModelMap model) {

        ObjectId paperId = new ObjectId(id);
        Document paper = MongoUtil.getDocument(db, MongoUtil.COLLECTION_NAME_PAPERS, paperId);
        model.put("paper", paper);
        model.put("studentFields", paper.get("studentFields"));

        List<Document> results = new ArrayList<Document>();
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
            Document result = new Document();
            AggregateIterable<Document> iterable = db.getCollection(MongoUtil.COLLECTION_NAME_USERS).aggregate(asList(
                    new Document("$match", new Document("_id", oid)),
                    new Document("$lookup", new Document("from", MongoUtil.COLLECTION_NAME_USERDATA).append("localField", "_id").append("foreignField", "userref").append("as", "userdata"))));
            for (Document u : iterable) {
                result.put("_id", u.get("_id"));
                result.put("userInfo", u.get("userInfo"));
                @SuppressWarnings("unchecked")
                List<Document> userdata = (List<Document>) u.get("userdata");
                for (Document ud : userdata) {
                    String colref = ud.get("colref").toString();
                    result.put(colref, ud);
                }
                results.add(result);
                break;
            }

        }
        model.put("id", id);
        model.put("json", json);
        model.put("results", results);
        model.put("columns", columns);
        model.put("pageName", "viewPaper");
        model.put("baseUrl", ServletUtil.getContextURL(request));
        MongoUtil.putCommonIntoModel(db, request, model);
        return "dashboard/studentDataPanel";
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

    
    @RequestMapping(value = "/sharePaper/{id}", method = RequestMethod.GET)
    public String sharePaper(@PathVariable String id,
                                 HttpServletRequest request,
                                 ModelMap model) {
        ObjectId paperId = new ObjectId(id);
        List<Document> students=MongoUtil.getAllDocuments(db, MongoUtil.COLLECTION_NAME_USERS);
        log.debug("users {}", students);
        List<Document> records=new ArrayList<Document>(); 
		for (Document student : students) {
			if (null != student.get(MongoUtil.USERNAME) && null!=student.get("_id")) {
				Document data = new Document();
				data.put("_id", student.get("_id"));
				data.put(MongoUtil.USERNAME, student.get(MongoUtil.USERNAME));
				data.put("firstName", student.get("firstName"));
				data.put("lastName", student.get("lastName"));
				data.put("email", student.get("email"));
				records.add(data);
			}
		}

        model.put("students", records);
        model.put("pageName", "sharePaper");
        MongoUtil.putCommonIntoModel(db, request, model);
        return Common.DEFAULT_VIEW_NAME;
    }
    
    
    
    @RequestMapping(value = "/sharePapers/{id}", method = RequestMethod.POST)
    public ResponseEntity<String> sharePaperWithStudents(@PathVariable String id,@RequestParam(value = "user_id", required = false) String user_id,
                                 HttpServletRequest request,
                                 ModelMap model) {
    	
        boolean success = false;
        String action = "/sharePapers/{id}";
        String detail = null;
        JSONParser parser=new JSONParser();
    	try {
			JSONObject data=(JSONObject)parser.parse(user_id);
			Document paperref=new Document();
			paperref.put("paperref", new  ObjectId(id));
			List<String> roles=new ArrayList<String>();
			roles.add("owner");
			paperref.put("roles",roles);
			List<ObjectId> user_ids=new ArrayList<ObjectId>();
			for(Object user:data.keySet()){
				//user_ids.add(new ObjectId((String)user.toString()));
				
		        db.getCollection(MongoUtil.COLLECTION_NAME_USERS).updateOne(
		                eq("_id", new ObjectId((String)user.toString())),
		                new Document("$push", new Document("papers",paperref)));
		        db.getCollection(MongoUtil.COLLECTION_NAME_PAPERS).updateOne(
		                eq("_id", new  ObjectId(id)),
		                new Document("$push", new Document("owner",new ObjectId((String)user.toString()))));
		        success = true;
			}
		} catch (ParseException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
    	return OtherUtil.outputJSON(action, success, detail);

    }
    
    @RequestMapping(value = "/saveColumnValue", method = RequestMethod.POST)
    public ResponseEntity<String> saveColumnValue(@RequestParam(value = "id", required = false) String id,
                                                  @RequestParam(value = "userId", required = false) String userId,
                                                  @RequestParam(value = "columnId", required = false) String columnId,
                                                  @RequestParam("value") String value,
                                                  HttpServletRequest request) {
        String action = "saveColumnValue";
        String userName = AuthUtil.getUserName(request);
        Document user = MongoUtil.getUserByUsername(db, userName);
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

    @RequestMapping(value = "/changeColour", method = RequestMethod.POST)
    public ResponseEntity<String> saveColumnValue(@RequestParam(value = "columnId", required = false) String columnId,
                                                  @RequestParam(value = "colour", required = false) String colour,
                                                  HttpServletRequest request) {
        String action = "changeColour";
        db.getCollection(MongoUtil.COLLECTION_NAME_COLUMNS).updateOne(
                eq("_id", new ObjectId(columnId)),
                new Document("$set", new Document("colour", colour))
        );
        String detail = null;
        return OtherUtil.outputJSON(action, true, "");
    }

    @RequestMapping(value = "/editStudent/{id}", method = RequestMethod.GET)
    public String editStudent(@PathVariable String id,
                                  HttpServletRequest request,
                                  ModelMap model) {
        ObjectId studentId = new ObjectId(id);
        AggregateIterable<Document> iterable = db.getCollection(MongoUtil.COLLECTION_NAME_USERS).aggregate(asList(
                new Document("$match", new Document("_id", studentId)),
                new Document("$lookup", new Document("from", MongoUtil.COLLECTION_NAME_USERDATA).append("localField", "_id").append("foreignField", "userref").append("as", "userdata"))));

        Document user = null;
        for (Document u : iterable)
        {
            Document result = new Document();
            result.put("_id", u.get("_id"));
            result.put("userInfo", u.get("userInfo"));
            @SuppressWarnings("unchecked")
            List<Document> userdata = (List<Document>) u.get("userdata");
            for(Document ud : userdata) {
                String colref = ud.get("colref").toString();
                Document column = MongoUtil.getDocument(db, MongoUtil.COLLECTION_NAME_COLUMNS, "_id", new ObjectId(colref));
                ud.put("name",column.get("name"));
                Document paper = MongoUtil.getPaper(db, column.get("paperref").toString());
                model.put("paper", paper);
            }
            result.put("userData",userdata);
            user = result;
        }

        model.put("user",user);
        model.put("baseUrl", ServletUtil.getContextURL(request));
        model.put("pageName", "editStudent");
        MongoUtil.putCommonIntoModel(db, request, model);
        return Common.DEFAULT_VIEW_NAME;
    }
//*
    @RequestMapping(value = "/saveStudent", method = RequestMethod.POST)
    public String saveStudent(@RequestParam(value = "_id", required = false) String _id,
                              @RequestParam("userDataSize") int userDataSize,
                              @RequestParam("studentFieldsSize") int studentFieldsSize,
                              @RequestParam("paperId") String paperId,
                              HttpServletRequest request) {
        String userName = AuthUtil.getUserName(request);
        Document who = MongoUtil.getUserByUsername(db, userName);
        Document user = MongoUtil.getDocument(db,MongoUtil.COLLECTION_NAME_USERS,_id);
        Document userInfo = new Document();
        for (int i = 0; i < studentFieldsSize; i++) {
            if ((request.getParameter("sf_key_" + i) != null) && (request.getParameter("sf_value_" + i) != null)) {
                String key = request.getParameter("sf_key_" + i).trim();
                String value = request.getParameter("sf_value_" + i).trim();
                if (StringUtils.isNotBlank(key)) {
                    userInfo.put(key, value);
                }
            }
        }
        user.put("userInfo",userInfo);
        db.getCollection(MongoUtil.COLLECTION_NAME_USERS)
                .updateOne(eq("_id", user.get("_id")), new Document("$set", new Document(user)),
                        new UpdateOptions().upsert(true));

        for (int i = 0; i < userDataSize; i++) {
            if ((request.getParameter("ud_key_" + i) != null) && (request.getParameter("ud_value_" + i) != null)) {
                String key = request.getParameter("ud_key_" + i).trim();
                String value = request.getParameter("ud_value_" + i).trim();
                if (StringUtils.isNotBlank(key)) {
                    MongoUtil.saveUserData(db,value,new ObjectId(key),(ObjectId)user.get("_id"),who);
                }
            }
        }
        user.put("userInfo",userInfo);
        return "redirect:/user/viewPaper/" + paperId;
    }
//*/

    //async loading
    @RequestMapping(value = "/getDataOverview/{id}", method = RequestMethod.GET)
    public String getDataOverview(@PathVariable String id,
                             HttpServletRequest request,
                             ModelMap model) {
        ObjectId paperId = new ObjectId(id);
        Document paper = MongoUtil.getPaper(db, paperId);
        List<Document> columns = MongoUtil.getDocuments(db, MongoUtil.COLLECTION_NAME_COLUMNS, "paperref", paperId);
        model.put("columns", columns);
        model.put("paper", paper);
        model.put("baseUrl", ServletUtil.getContextURL(request));
        MongoUtil.putCommonIntoModel(db, request, model);
        return "dashboard/dataOverview";
    }

    @RequestMapping(value = "/getColumns/{id}", method = RequestMethod.GET)
    public String getColumns(@PathVariable String id,
                             HttpServletRequest request,
                             ModelMap model) {
        ObjectId paperId = new ObjectId(id);
        Document paper = MongoUtil.getPaper(db, paperId);
        List<Document> columns = MongoUtil.getDocuments(db, MongoUtil.COLLECTION_NAME_COLUMNS, "paperref", paperId);
        model.put("columns", columns);
        model.put("paper",paper);
        model.put("baseUrl", ServletUtil.getContextURL(request));
        MongoUtil.putCommonIntoModel(db, request, model);
        return "dashboard/columnPanel";
    }

    @RequestMapping(value = "/getUserFields/{id}", method = RequestMethod.GET)
    public String getUserFields(@PathVariable String id,
                             HttpServletRequest request,
                             ModelMap model) {
        ObjectId paperId = new ObjectId(id);
        Document paper = MongoUtil.getPaper(db, paperId);
        model.put("studentFields", paper.get("studentFields"));
        model.put("paper",paper);
        MongoUtil.putCommonIntoModel(db, request, model);
        return "dashboard/userFieldsPanel";
    }

    @RequestMapping(value = "/getFilters/{id}", method = RequestMethod.GET)
    public String getFilters(@PathVariable String id,
                             HttpServletRequest request,
                             ModelMap model) {
        ObjectId paperId = new ObjectId(id);
        List<Document> columns = MongoUtil.getDocuments(db, MongoUtil.COLLECTION_NAME_COLUMNS, "paperref", paperId);
        model.put("columns", columns);
        model.put("id", id);
        model.put("baseUrl", ServletUtil.getContextURL(request));
        MongoUtil.putCommonIntoModel(db, request, model);
        return "dashboard/filterPanel";
    }

    @RequestMapping(value = "/getPaperInfo/{id}", method = RequestMethod.GET)
    public String getPaperInfo(@PathVariable String id,
                               HttpServletRequest request,
                               ModelMap model) {
        ObjectId paperId = new ObjectId(id);
        Document paper = MongoUtil.getPaper(db, paperId);
        model.put("paper", paper);
        model.put("id", id);
        //TODO: add ICN here
        model.put("ICN_C", "Paper");
        model.put("baseUrl", ServletUtil.getContextURL(request));
        MongoUtil.putCommonIntoModel(db, request, model);
        return "dashboard/paperInfoPanel";
    }

    @RequestMapping(value = "/getInterventions/{id}", method = RequestMethod.GET)
    public String getInterventions(@PathVariable String id,
                                   HttpServletRequest request,
                                   ModelMap model) {
        ObjectId paperId = new ObjectId(id);
        List<Document> interventions = MongoUtil.getDocuments(db, MongoUtil.COLLECTION_NAME_INTERVENTIONS, "paperref", paperId);
        model.put("interventions", interventions);
        MongoUtil.putCommonIntoModel(db, request, model);
        return "dashboard/interventionPanel";
    }

    @RequestMapping(value = "/getStudentData/{id}", method = RequestMethod.GET)
    public String getStudentData(@PathVariable String id,
                                 HttpServletRequest request,
                                 ModelMap model) {
        ObjectId paperId = new ObjectId(id);
        Document paper = MongoUtil.getDocument(db, MongoUtil.COLLECTION_NAME_PAPERS, paperId);
        model.put("paper", paper);
        model.put("studentFields", paper.get("studentFields"));

        List<Document> results = new ArrayList<Document>();
        List<Document> columns = MongoUtil.getDocuments(db, MongoUtil.COLLECTION_NAME_COLUMNS, "paperref", paperId);
        AggregateIterable<Document> iterable = db.getCollection(MongoUtil.COLLECTION_NAME_USERS).aggregate(asList(
                new Document("$match", new Document("paperref", paperId)),
                new Document("$lookup", new Document("from", MongoUtil.COLLECTION_NAME_USERDATA).append("localField", "_id").append("foreignField", "userref").append("as", "userdata"))));

        for (Document u : iterable) {
            Document result = new Document();
            result.put("_id", u.get("_id"));
            result.put("userInfo", u.get("userInfo"));
            @SuppressWarnings("unchecked")
            List<Document> userdata = (List<Document>) u.get("userdata");
            for (Document ud : userdata) {
                String colref = ud.get("colref").toString();
                result.put(colref, ud);
            }
            results.add(result);
        }

        model.put("id", id);
        model.put("results", results);
        model.put("columns", columns);
        model.put("pageName", "viewPaper");
        model.put("baseUrl", ServletUtil.getContextURL(request));
        MongoUtil.putCommonIntoModel(db, request, model);
        return "dashboard/studentDataPanel";
    }

    @RequestMapping(value = "/saveProfile", method = RequestMethod.POST)
    public String saveProfile(@RequestParam(value = "userName", required = false) String userName,
                                              @RequestParam(value = "firstName", required = false) String firstName,
                                              @RequestParam(value = "lastName", required = false) String lastName,
                                              @RequestParam(value = "email", required = false) String email,
                                              @RequestParam(value = "phone", required = false) String phone,
                                              HttpServletRequest request) {

        Document user = MongoUtil.getUserByUsername(db, userName);
        user.put("firstName",firstName);
        user.put("lastName",lastName);
        user.put("email",email);
        user.put("phone",phone);

        db.getCollection(MongoUtil.COLLECTION_NAME_USERS)
                .updateOne(eq("_id", user.get("_id")), new Document("$set", new Document(user)),
                        new UpdateOptions().upsert(true));

        return "redirect:/user";
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
