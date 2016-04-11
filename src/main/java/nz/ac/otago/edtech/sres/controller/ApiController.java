package nz.ac.otago.edtech.sres.controller;

import com.mongodb.MongoClient;
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
import java.util.Date;
import java.util.List;
import java.util.Map;

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

    @RequestMapping(value = "/papers", method = RequestMethod.GET)
    public ResponseEntity<List<Document>> papers(@RequestParam("token") String token) {
        List<Document> papers = null;
        Document doc = validateToken(token);
        if (doc != null) {
            String username = (String) doc.get("username");
            papers = MongoUtil.getDocuments(db, MongoUtil.COLLECTION_NAME_PAPERS, eq("owner", username), eq("status", "active"));
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
            return new ResponseEntity<Document>(paper, HttpStatus.OK);
        } else
            return new ResponseEntity<Document>(paper, HttpStatus.UNAUTHORIZED);
    }

    @RequestMapping(value = "/logout", method = RequestMethod.GET)
    public ResponseEntity<Map> logout(@RequestParam("token") String token) {
        Map map = new ModelMap();
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

}
