package nz.ac.otago.edtech.sres.util;

import com.mongodb.client.FindIterable;
import com.mongodb.client.MongoDatabase;
import com.mongodb.client.result.UpdateResult;
import org.apache.commons.codec.digest.DigestUtils;
import org.apache.commons.lang3.StringUtils;
import org.bson.Document;
import org.bson.conversions.Bson;
import org.bson.types.ObjectId;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.ui.ModelMap;

import javax.servlet.http.HttpServletRequest;
import java.util.ArrayList;
import java.util.Date;
import java.util.Enumeration;
import java.util.List;

import static com.mongodb.client.model.Filters.and;
import static com.mongodb.client.model.Filters.eq;

/**
 * Utility functions.
 *
 * @author Richard Zeng (richard.zeng@otago.ac.nz)
 *         Date: 16/02/16
 *         Time: 12:21 PM
 */
public class MongoUtil {

    public static final String COLLECTION_NAME_PAPERS = "papers";
    public static final String COLLECTION_NAME_USERS = "users";
    public static final String COLLECTION_NAME_COLUMNS = "columns";
    public static final String COLLECTION_NAME_USERDATA = "userdata";
    public static final String COLLECTION_NAME_TOKENS = "tokens";

    public static final String USERNAME = "username";
    public static final String[] USER_FIELDS = {USERNAME, "givenNames", "surname", "preferredName", "email", "phone"};


    private static final Logger log = LoggerFactory.getLogger(MongoUtil.class);


    public static ObjectId insertOne(MongoDatabase db, String collection, HttpServletRequest request) {

        ObjectId id = new ObjectId();
        ModelMap map = new ModelMap();
        map.put("_id", id);
        Enumeration<String> parameterNames = request.getParameterNames();
        while (parameterNames.hasMoreElements()) {
            String name = parameterNames.nextElement();
            String value = request.getParameter(name);
            map.put(name, value);
        }
        db.getCollection(collection).insertOne(new Document(map));
        return id;

    }

    /**
     * Get all documents for given collection
     *
     * @param db         mongo database
     * @param collection collection
     * @return list of documents
     */
    public static List<Document> getAllDocuments(MongoDatabase db, String collection) {
        List<Document> documents = new ArrayList<Document>();
        FindIterable<Document> iterable = db.getCollection(collection).find();
        for (Document document : iterable) {
            document.put("id", document.get("_id").toString());
            documents.add(document);
        }
        return documents;
    }

    /**
     * Get documents for given filters
     *
     * @param db         mongo database
     * @param collection collection
     * @param filters    filters
     * @return document
     */
    public static List<Document> getDocuments(MongoDatabase db, String collection, Bson... filters) {
        List<Document> documents = new ArrayList<Document>();
        FindIterable<Document> iterable = db.getCollection(collection).find(and(filters));
        for (Document document : iterable) {
            document.put("id", document.get("_id").toString());
            documents.add(document);
        }
        return documents;
    }

    /**
     * Get document for given _id
     *
     * @param db         mongo database
     * @param collection collection
     * @param _id        _id
     * @return document
     */
    public static Document getDocument(MongoDatabase db, String collection, String _id) {
        ObjectId oId = new ObjectId(_id);
        return getDocument(db, collection, oId);
    }

    /**
     * Get document for given object id
     *
     * @param db         mongo database
     * @param collection collection
     * @param oId        object id
     * @return document
     */
    public static Document getDocument(MongoDatabase db, String collection, ObjectId oId) {
        Document doc = null;
        List<Document> documents = getDocuments(db, collection, eq("_id", oId));
        if (!documents.isEmpty()) {
            doc = documents.get(0);
            if (documents.size() > 1)
                log.warn("There is more than one document with id {}", oId);
        }
        return doc;
    }

    /**
     * Get document for given key and value
     *
     * @param db         mongo database
     * @param collection collection
     * @param key        key
     * @param value      value
     * @return document
     */
    public static List<Document> getDocuments(MongoDatabase db, String collection, String key, Object value) {
       return getDocuments(db, collection, eq(key,value));
    }



    /**
     * Get document for given key and value
     *
     * @param db         mongo database
     * @param collection collection
     * @param key        key
     * @param value      value
     * @return document
     */
    public static Document getDocument(MongoDatabase db, String collection, String key, Object value) {
        Document doc = null;
        List<Document> documents = getDocuments(db, collection, key, value);
        if (!documents.isEmpty()) {
            doc = documents.get(0);
            if (documents.size() > 1)
                log.warn("There is more than one document with key {} value {}", key, value);
        }
        return doc;
    }

    /**
     * Get document for given filters
     *
     * @param db         mongo database
     * @param collection collection
     * @param filters    filters
     * @return document
     */
    public static Document getDocument(MongoDatabase db, String collection, Bson... filters) {
        Document doc = null;
        List<Document> documents = new ArrayList<Document>();
        FindIterable<Document> iterable = db.getCollection(collection).find(and(filters));
        for (Document document : iterable) {
            documents.add(document);
        }
        if (!documents.isEmpty()) {
            doc = documents.get(0);
            if (documents.size() > 1)
                log.warn("There is more than one document with filters");
        }
        return doc;
    }

    public static boolean authenticate(MongoDatabase db, String username, String password) {
        if (StringUtils.isNotBlank(username) && StringUtils.isNotBlank(password)) {
            String sha256 = DigestUtils.sha256Hex(password);
            Document userDoc = MongoUtil.getDocument(db, MongoUtil.COLLECTION_NAME_USERS, MongoUtil.USERNAME, username);
            if (userDoc == null) {
                // if no user in db, create a new one with given username and password
                // TODO: this part should be deleted in production server, it's for easy testing only
                createNewUser(db, username, password);
                return true;
            } else if (userDoc.get("password") == null) {
                // if no password in db, add password to db for given username
                // TODO: this part should be deleted in production server, it's for easy testing only
                updatePassword(db, username, password);
                return true;
            }

            // TODO: use and only use this on production server
            if ((userDoc != null) && (userDoc.get("password") != null))
                return sha256.equals(userDoc.get("password"));
        }
        return false;
    }

    /**
     * Create a new user with given username and password
     *
     * @param db       mongo database
     * @param username username
     * @param password password
     */
    public static void createNewUser(MongoDatabase db, String username, String password) {
        String sha256 = DigestUtils.sha256Hex(password);
        ModelMap userMap = new ModelMap();
        userMap.put(MongoUtil.USERNAME, username);
        userMap.put("password", sha256);
        userMap.put("created", new Date());
        db.getCollection(MongoUtil.COLLECTION_NAME_USERS).insertOne(new Document(userMap));
    }

    /**
     * Update existing user's password to given password
     *
     * @param db       mongo database
     * @param username username
     * @param password new password
     * @return true if successful, otherwise false
     */
    public static boolean updatePassword(MongoDatabase db, String username, String password) {
        String sha256 = DigestUtils.sha256Hex(password);
        UpdateResult updateResult = db.getCollection(MongoUtil.COLLECTION_NAME_USERS).updateOne(eq(MongoUtil.USERNAME, username),
                new Document("$set", new Document("password", sha256)));
        if (updateResult.getModifiedCount() == 1)
            return true;
        return false;
    }

}

