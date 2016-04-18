package nz.ac.otago.edtech.sres.controller;

import com.mongodb.MongoClient;
import com.mongodb.client.FindIterable;
import com.mongodb.client.MongoDatabase;
import nz.ac.otago.edtech.auth.util.AuthUtil;
import nz.ac.otago.edtech.sres.util.MongoUtil;
import nz.ac.otago.edtech.util.CommonUtil;
import org.apache.commons.codec.digest.DigestUtils;
import org.apache.commons.lang.time.DateUtils;
import org.bson.Document;
import org.bson.types.ObjectId;
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
            for (Document p : papers)
                MongoUtil.changeObjectId2String(p);
            /**
             papers = MongoUtil.getDocuments(db, MongoUtil.COLLECTION_NAME_PAPERS, eq("owner", username), eq("status", "active"));
             for (Document paper : papers)
             MongoUtil.changeObjectId2String(paper);
             //*/
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
            paper = MongoUtil.getDocument(db, MongoUtil.COLLECTION_NAME_PAPERS, id);
            MongoUtil.changeObjectId2String(paper);
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
            Document user = MongoUtil.getUser(db, username);
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
                                                @RequestParam(value = "paperid", required = false) String[] paperIds,
                                                @RequestParam("term") String term) {
        List<Document> users = new ArrayList<Document>();
        Document doc = validateToken(token);
        if (doc != null) {
            String username = (String) doc.get("username");
            // all papers this user has access to
            List<Document> papers = MongoUtil.getPapers(db, username);
            if (paperIds != null) {
                List<String> list = new ArrayList<String>();
                for (String id : paperIds) {
                    for (Document pp : papers) {
                        if (pp.get("_id").toString().equals(id)) {
                            list.add(id);
                            break;
                        }
                    }
                }
                papers = new ArrayList<Document>();
                for (String id : list) {
                    Document pp = MongoUtil.getDocument(db, MongoUtil.COLLECTION_NAME_PAPERS, id);
                    papers.add(pp);
                }
            }
            List<ObjectId> oids = new ArrayList<ObjectId>();
            for (Document pp : papers)
                oids.add((ObjectId) pp.get("_id"));
            Document regex = new Document("$regex", ".*" + term + ".*").append("$options", "i");
            Set<Document> set = new HashSet<Document>();
            String[] fields = {"username", "givenNames", "surname", "email"};
            for (String field : fields) {
                FindIterable<Document> iterable = db.getCollection(MongoUtil.COLLECTION_NAME_USERS)
                        .find(
                                new Document(field, regex)
                                        .append("papers.paperref", new Document("$in", oids))
                        );
                for (Document document : iterable) {
                    document.put("id", document.get("_id").toString());
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
                                         @RequestParam("data") Document user) {
        Document oldUser = null;
        Document doc = validateToken(token);
        if (doc != null) {
            ObjectId uId = new ObjectId(id);
            oldUser = MongoUtil.getDocument(db, MongoUtil.COLLECTION_NAME_USERS, uId);
            if (oldUser != null) {
                for (String key : user.keySet())
                    oldUser.put(key, user.get(key));
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
