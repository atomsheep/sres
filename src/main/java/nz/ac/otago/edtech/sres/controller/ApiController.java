package nz.ac.otago.edtech.sres.controller;

import com.mongodb.MongoClient;
import com.mongodb.client.FindIterable;
import com.mongodb.client.MongoDatabase;
import nz.ac.otago.edtech.auth.util.AuthUtil;
import nz.ac.otago.edtech.sres.util.MongoUtil;
import nz.ac.otago.edtech.util.CommonUtil;
import nz.ac.otago.edtech.util.JSONUtil;
import org.apache.commons.codec.digest.DigestUtils;
import org.apache.commons.lang.time.DateUtils;
import org.apache.commons.lang3.StringUtils;
import org.bson.Document;
import org.bson.types.ObjectId;
import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.*;

import javax.annotation.PostConstruct;
import javax.servlet.http.HttpServletRequest;
import java.util.*;

import static com.mongodb.client.model.Filters.eq;

/**
 * REST api controller.
 *
 * @author Richard Zeng (richard.zeng@otago.ac.nz)
 *         Date: 1/04/16
 *         Time: 10:37 AM
 */
@RestController
@RequestMapping("/api")
public class ApiController {

    private static final Logger log = LoggerFactory.getLogger(ApiController.class);

    private static final int TIMEOUT_MINUTES = 20;

    @Autowired
    MongoClient mongoClient;

    @Value("${mongodb.dbname}")
    private String dbName;

    private MongoDatabase db = null;

    @PostConstruct
    public void init() {
        db = mongoClient.getDatabase(dbName);
    }

    @RequestMapping(value = "/login", method = RequestMethod.POST)
    public ResponseEntity<Map> login(@RequestParam("username") String username,
                                     @RequestParam("password") String password,
                                     HttpServletRequest request) {
        ModelMap map = new ModelMap();
        String ipAddress = AuthUtil.getIpAddress(request);
        log.debug("ip address = {}", ipAddress);
        // check username and password here
        if (MongoUtil.authenticate(db, username, password)) {
            Document userDoc = MongoUtil.getDocument(db, MongoUtil.COLLECTION_NAME_USERS, MongoUtil.USERNAME, username);
            MongoUtil.changeUserObjectId2String(userDoc);
            map.put("user", userDoc);
            {
                // create a new token
                ModelMap tokenMap = new ModelMap();
                ObjectId id = new ObjectId();
                tokenMap.put("_id", id);
                tokenMap.put("username", username);
                String token = CommonUtil.generateRandomCode();
                token = DigestUtils.sha256Hex(token);
                tokenMap.put("token", token);
                tokenMap.put("lastModified", new Date());
                tokenMap.put("ipAddress", ipAddress);
                db.getCollection(MongoUtil.COLLECTION_NAME_TOKENS).insertOne(new Document(tokenMap));
                log.debug("User {} logged in with token = {}", username, token);
                map.put("token", token);
            }
            return new ResponseEntity<Map>(map, HttpStatus.OK);
        } else {
            map.put("username", username);
            return new ResponseEntity<Map>(map, HttpStatus.UNAUTHORIZED);
        }
    }

    @RequestMapping(value = "/papers", method = RequestMethod.GET)
    public ResponseEntity<List<Document>> papers(@RequestParam("token") String token) {
        List<Document> papers = null;
        Document doc = validateToken(token);
        if (doc != null) {
            String username = (String) doc.get("username");
            papers = MongoUtil.getPapers(db, username);
            for (Document p : papers) {
                p.remove("studentFile");
                p.remove("dataFile");
                MongoUtil.changePaperObjectId2String(p);
            }
            return new ResponseEntity<List<Document>>(papers, HttpStatus.OK);
        } else
            return new ResponseEntity<List<Document>>(papers, HttpStatus.UNAUTHORIZED);
    }

    @RequestMapping(value = "/paper/{id}", method = RequestMethod.GET)
    public ResponseEntity<Document> paper(@PathVariable String id,
                                          @RequestParam("token") String token) {
        Document paper = null;
        Document doc = validateToken(token);
        if (doc != null) {
            // TODO: if user has not access to given paper, maybe return something different
            paper = MongoUtil.getPaper(db, id);
            paper.remove("studentFile");
            paper.remove("dataFile");
            MongoUtil.changePaperObjectId2String(paper);
            return new ResponseEntity<Document>(paper, HttpStatus.OK);
        } else
            return new ResponseEntity<Document>(paper, HttpStatus.UNAUTHORIZED);
    }

    @RequestMapping(value = "/columns/{id}", method = RequestMethod.GET)
    public ResponseEntity<List<Document>> columns(@PathVariable String id,
                                                  @RequestParam("token") String token) {
        List<Document> columns = null;
        Document doc = validateToken(token);
        if (doc != null) {
            ObjectId paperref = new ObjectId(id);
            columns = MongoUtil.getDocuments(db, MongoUtil.COLLECTION_NAME_COLUMNS, "paperref", paperref);
            for (Document column : columns) {
                MongoUtil.changeObjectId2String(column);
                MongoUtil.changeObjectId2String(column, "paperref");
            }
            return new ResponseEntity<List<Document>>(columns, HttpStatus.OK);
        } else
            return new ResponseEntity<List<Document>>(columns, HttpStatus.UNAUTHORIZED);
    }

    @RequestMapping(value = "/column/{id}", method = RequestMethod.GET)
    public ResponseEntity<Document> column(@PathVariable String id,
                                           @RequestParam("token") String token) {
        Document column = null;
        Document doc = validateToken(token);
        if (doc != null) {
            column = MongoUtil.getDocument(db, MongoUtil.COLLECTION_NAME_COLUMNS, id);
            MongoUtil.changeObjectId2String(column);
            MongoUtil.changeObjectId2String(column, "paperref");
            return new ResponseEntity<Document>(column, HttpStatus.OK);
        } else
            return new ResponseEntity<Document>(column, HttpStatus.UNAUTHORIZED);
    }

    @RequestMapping(value = "/column/{id}/customDisplay", method = RequestMethod.GET)
    public ResponseEntity<Document> customDisplay(@PathVariable String id,
                                                  @RequestParam("userid") String userid,
                                                  @RequestParam("token") String token) {
        Document output = null;
        Document doc = validateToken(token);
        if (doc != null) {
            Document column = MongoUtil.getDocument(db, MongoUtil.COLLECTION_NAME_COLUMNS, id);
            if ((column != null) && (column.get("customDisplay") != null)) {
                String customDisplay = column.get("customDisplay").toString();
                Document user = MongoUtil.getUserByUsername(db, userid);
                if ((user != null) && (user.get("userInfo") != null)) {
                    Document userInfo = (Document) user.get("userInfo");
                    for (String key : userInfo.keySet()) {
                        customDisplay = customDisplay.replace("{" + key + "}", userInfo.get(key).toString());
                    }
                    output.put("html", customDisplay);
                }
            }
            return new ResponseEntity<Document>(output, HttpStatus.OK);
        } else
            return new ResponseEntity<Document>(output, HttpStatus.UNAUTHORIZED);
    }

    @RequestMapping(value = "/userdata", method = RequestMethod.GET)
    public ResponseEntity<Document> userdata(@RequestParam("token") String token,
                                             @RequestParam("userid") String userId,
                                             @RequestParam("columnid") String columnId) {
        Document userdata = null;
        Document doc = validateToken(token);
        if (doc != null) {
            ObjectId colref = new ObjectId(columnId);
            ObjectId userref = new ObjectId(userId);
            userdata = MongoUtil.getDocument(db, MongoUtil.COLLECTION_NAME_USERDATA, eq("colref", colref), eq("userref", userref));
            MongoUtil.changeObjectId2String(userdata);
            MongoUtil.changeObjectId2String(userdata, "colref");
            MongoUtil.changeObjectId2String(userdata, "userref");
            @SuppressWarnings("unchecked")
            List<Document> data = (List<Document>) userdata.get("data");
            for (Document datum : data)
                MongoUtil.changeObjectId2String(datum, "updateBy");
            return new ResponseEntity<Document>(userdata, HttpStatus.OK);
        } else
            return new ResponseEntity<Document>(userdata, HttpStatus.UNAUTHORIZED);
    }

    @RequestMapping(value = "/userdata", method = RequestMethod.POST)
    public ResponseEntity<List<Map>> userdata(@RequestParam("token") String token,
                                              @RequestParam("userid") String[] userId,
                                              @RequestParam("columnid") String columnId,
                                              @RequestParam("data") String data) {
        List<Map> userdataList = new ArrayList<Map>();
        Document doc = validateToken(token);
        if (doc != null) {
            String username = (String) doc.get("username");
            Document user = MongoUtil.getUserByUsername(db, username);
            ObjectId colref = new ObjectId(columnId);
            for (String uid : userId) {
                ObjectId userref = new ObjectId(uid);
                Map map = MongoUtil.saveUserData(db, data, colref, userref, user);
                userdataList.add(map);
            }
            return new ResponseEntity<List<Map>>(userdataList, HttpStatus.OK);
        } else
            return new ResponseEntity<List<Map>>(userdataList, HttpStatus.UNAUTHORIZED);
    }

    @RequestMapping(value = "/users", method = RequestMethod.GET)
    public ResponseEntity<List<Document>> users(@RequestParam("token") String token,
                                                //@RequestParam(value = "paperid", required = false) String[] paperIds,
                                                @RequestParam("paperid") String paperId,
                                                @RequestParam("term") String term) {
        List<Document> users = new ArrayList<Document>();
        Document doc = validateToken(token);
        if (doc != null) {
            String username = (String) doc.get("username");
            Document paper = MongoUtil.getPaper(db, paperId);
            @SuppressWarnings("unchecked")
            List<String> studentFields = (List<String>) paper.get("studentFields");
            Document regex = new Document("$regex", ".*" + term + ".*").append("$options", "i");
            Set<Document> set = new HashSet<Document>();
            for (String field : studentFields) {
                FindIterable<Document> iterable = db.getCollection(MongoUtil.COLLECTION_NAME_USERS)
                        .find(new Document("userInfo." + field, regex)
                                .append("paperref", paper.get("_id"))
                        );
                for (Document document : iterable) {
                    set.add(document);
                }
            }
            users.addAll(set);
            for (Document u : users)
                MongoUtil.changeUserObjectId2String(u);
            return new ResponseEntity<List<Document>>(users, HttpStatus.OK);

        } else
            return new ResponseEntity<List<Document>>(users, HttpStatus.UNAUTHORIZED);
    }

    @RequestMapping(value = "/user", method = RequestMethod.GET)
    public ResponseEntity<Document> userSearch(@RequestParam("token") String token,
                                               @RequestParam("paperid") String paperId,
                                               @RequestParam("term") String term,
                                               @RequestParam(value = "field", required = false) String fieldName) {
        Document user = null;
        List<Document> users = new ArrayList<Document>();
        Document doc = validateToken(token);
        if (doc != null) {
            String username = (String) doc.get("username");
            Document paper = MongoUtil.getPaper(db, paperId);
            @SuppressWarnings("unchecked")
            List<String> identifiers = (List<String>) paper.get("identifiers");
            if (StringUtils.isNotBlank(fieldName)) {
                identifiers.clear();
                identifiers.add(fieldName);
            }
            Document regex = new Document("$regex", ".*" + term + ".*").append("$options", "i");
            Set<Document> set = new HashSet<Document>();
            for (String field : identifiers) {
                FindIterable<Document> iterable = db.getCollection(MongoUtil.COLLECTION_NAME_USERS)
                        .find(new Document("userInfo." + field, regex)
                                .append("paperref", paper.get("_id"))
                        );
                for (Document document : iterable) {
                    set.add(document);
                }
            }
            users.addAll(set);
            for (Document u : users) {
                MongoUtil.changeUserObjectId2String(u);
                user = u;
                break;
            }
            return new ResponseEntity<Document>(user, HttpStatus.OK);

        } else
            return new ResponseEntity<Document>(user, HttpStatus.UNAUTHORIZED);
    }

    @RequestMapping(value = "/user/{id}", method = RequestMethod.GET)
    public ResponseEntity<Document> user(@PathVariable String id,
                                         @RequestParam("token") String token) {
        Document user = null;
        Document doc = validateToken(token);
        if (doc != null) {
            user = MongoUtil.getDocument(db, MongoUtil.COLLECTION_NAME_USERS, id);
            MongoUtil.changeUserObjectId2String(user);
            return new ResponseEntity<Document>(user, HttpStatus.OK);
        } else
            return new ResponseEntity<Document>(user, HttpStatus.UNAUTHORIZED);
    }

    @RequestMapping(value = "/user/{id}", method = RequestMethod.POST)
    public ResponseEntity<Document> user(@PathVariable String id,
                                         @RequestParam("token") String token,
                                         @RequestParam("data") String data) {
        Document oldUser = null;
        Document doc = validateToken(token);
        if (doc != null) {
            ObjectId uId = new ObjectId(id);
            oldUser = MongoUtil.getDocument(db, MongoUtil.COLLECTION_NAME_USERS, uId);
            if (oldUser != null) {
                JSONObject object = JSONUtil.parse(data);
                for (String key : (Set<String>) object.keySet())
                    oldUser.put(key, object.get(key));
                db.getCollection(MongoUtil.COLLECTION_NAME_USERS).updateOne(eq("_id", uId),
                        new Document("$set", oldUser));
                MongoUtil.changeUserObjectId2String(oldUser);
            }
            return new ResponseEntity<Document>(oldUser, HttpStatus.OK);
        } else
            return new ResponseEntity<Document>(oldUser, HttpStatus.UNAUTHORIZED);
    }


    @RequestMapping(value = "/logout", method = RequestMethod.GET)
    public ResponseEntity<Map> logout(@RequestParam("token") String token) {
        ModelMap map = new ModelMap();
        map.put("success", true);
        db.getCollection(MongoUtil.COLLECTION_NAME_TOKENS).deleteOne(eq("token", token));
        return new ResponseEntity<Map>(map, HttpStatus.OK);
    }


    /**
     * validate token
     *
     * @param token given token
     * @return username if token is valid, otherwise returns null
     */
    private Document validateToken(String token) {
        Document doc = MongoUtil.getDocument(db, MongoUtil.COLLECTION_NAME_TOKENS, "token", token);
        if (doc != null) {
            Date lastModifed = (Date) doc.get("lastModified");
            Date now = new Date();
            log.debug("lastModified = {}, now = {}", lastModifed, now);
            if (DateUtils.addMinutes(lastModifed, TIMEOUT_MINUTES).before(now)) {
                // delete expired token
                db.getCollection(MongoUtil.COLLECTION_NAME_TOKENS).deleteOne(eq("token", token));
                doc = null;
            } else {
                db.getCollection(MongoUtil.COLLECTION_NAME_TOKENS).updateOne(eq("token", token),
                        new Document("$set", new Document("lastModified", now))
                );
            }
        }
        return doc;
    }


    @RequestMapping(value = "/loginJson", method = RequestMethod.POST, consumes = "application/json")
    public ResponseEntity<Map> loginJson(@RequestBody Map<String, String> user,
                                         HttpServletRequest request) {
        String username = user.get("username");
        String password = user.get("password");
        ModelMap map = new ModelMap();
        String ipAddress = AuthUtil.getIpAddress(request);
        log.debug("ip address = {}", ipAddress);
        // check username and password here
        if (MongoUtil.authenticate(db, username, password)) {
            Document userDoc = MongoUtil.getDocument(db, MongoUtil.COLLECTION_NAME_USERS, MongoUtil.USERNAME, username);
            userDoc.remove("_id");
            userDoc.remove("password");
            map.put("user", userDoc);
            ModelMap tokenMap = new ModelMap();
            ObjectId id = new ObjectId();
            tokenMap.put("_id", id);
            tokenMap.put("username", username);
            String token = CommonUtil.generateRandomCode();
            token = DigestUtils.sha256Hex(token);
            tokenMap.put("token", token);
            tokenMap.put("lastModified", new Date());
            tokenMap.put("ipAddress", ipAddress);
            db.getCollection(MongoUtil.COLLECTION_NAME_TOKENS).insertOne(new Document(tokenMap));
            log.debug("User {} logged in with token = {}", username, token);
            map.put("token", token);
            return new ResponseEntity<Map>(map, HttpStatus.OK);
        } else {
            map.put("username", username);
            return new ResponseEntity<Map>(map, HttpStatus.UNAUTHORIZED);
        }
    }
}
