package nz.ac.otago.edtech.sres.controller;

import com.mongodb.MongoClient;
import com.mongodb.client.MongoDatabase;
import nz.ac.otago.edtech.auth.util.AuthUtil;
import nz.ac.otago.edtech.sres.util.MongoUtil;
import nz.ac.otago.edtech.util.CommonUtil;
import org.bson.Document;
import org.bson.types.ObjectId;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import javax.annotation.PostConstruct;
import javax.servlet.http.HttpServletRequest;
import java.util.Date;
import java.util.Map;

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
            ObjectId id = new ObjectId();
            map.put("_id", id);
            map.put("username", username);
            String token = CommonUtil.generateRandomCode();
            log.debug("token = {}", token);
            map.put("token", token);
            map.put("lastModified", new Date());
            map.put("ipAddress", ipAddress);
            db.getCollection(MongoUtil.COLLECTION_NAME_TOKENS).insertOne(new Document(map));
            return new ResponseEntity<Map>(map, HttpStatus.OK);
        } else {
            map.put("username", username);
            return new ResponseEntity<Map>(map, HttpStatus.NOT_ACCEPTABLE);
        }
    }

    @RequestMapping(value = "/logout", method = RequestMethod.POST)
    public ResponseEntity<Map> logout(@RequestParam("token") String token) {
        Map map = new ModelMap();
        return new ResponseEntity<Map>(map, HttpStatus.OK);
    }


}
