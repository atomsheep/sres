package nz.ac.otago.edtech.sres.util;

import com.mongodb.client.FindIterable;
import com.mongodb.client.MongoDatabase;
import com.mongodb.client.result.DeleteResult;
import com.mongodb.client.result.UpdateResult;
import nz.ac.otago.edtech.auth.util.AuthUtil;
import nz.ac.otago.edtech.spring.bean.UploadLocation;
import org.apache.commons.codec.digest.DigestUtils;
import org.apache.commons.collections.ListUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.commons.lang3.math.NumberUtils;
import org.bson.Document;
import org.bson.conversions.Bson;
import org.bson.types.ObjectId;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.ui.ModelMap;

import javax.servlet.http.HttpServletRequest;
import java.io.File;
import java.util.*;

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
    public static final String COLLECTION_NAME_INTERVENTIONS = "interventions";
    public static final String COLLECTION_NAME_PARAGRAPHS = "paragraphs";
    public static final String COLLECTION_NAME_LOGS = "logs";

    public static final String USERNAME = "username";
    public static final String[] USER_FIELDS = {USERNAME, "givenNames", "surname", "preferredName", "email", "phone"};


    private static final Logger log = LoggerFactory.getLogger(MongoUtil.class);


    public static void putCommonIntoModel(MongoDatabase db, HttpServletRequest request, ModelMap model) {
        if (model.get("user") == null) {
            String userName = AuthUtil.getUserName(request);
            Document user = MongoUtil.getUserByUsername(db, userName);
            model.put("user", user);
        }
    }

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
        for (Document document : iterable)
            documents.add(document);
        return documents;
    }

    /**
     * Get documents for given filters
     *
     * @param db         mongo database
     * @param collection collection
     * @param filter     filter
     * @return document
     */
    public static List<Document> findDocuments(MongoDatabase db, String collection, Bson filter) {
        List<Document> documents = new ArrayList<Document>();
        FindIterable<Document> iterable = db.getCollection(collection).find(filter);
        for (Document document : iterable)
            documents.add(document);
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
        for (Document document : iterable)
            documents.add(document);
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
        List<Document> documents = findDocuments(db, collection, eq("_id", oId));
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
        return findDocuments(db, collection, eq(key, value));
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

    public static DeleteResult removeDocument(MongoDatabase db, String collection, Bson... filters) {
        DeleteResult dr = db.getCollection(collection).deleteOne(and(filters));
        return dr;
    }

    public static DeleteResult removeDocument(MongoDatabase db, String collection, String key, Object value) {
        DeleteResult dr = db.getCollection(collection).deleteOne(eq(key,value));
        return dr;
    }

    public static Document getUserByUsername(MongoDatabase db, String username) {
        return MongoUtil.getDocument(db, MongoUtil.COLLECTION_NAME_USERS, MongoUtil.USERNAME, username);
    }

    public static Document getUser(MongoDatabase db, String _id) {
        ObjectId oId = new ObjectId(_id);
        return getUser(db, oId);
    }

    public static Document getUser(MongoDatabase db, ObjectId id) {
        return MongoUtil.getDocument(db, MongoUtil.COLLECTION_NAME_USERS, "_id", id);
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

    /**
     * change object id to string format, use this when outputting json object
     *
     * @param doc document object
     */
    public static void changeObjectId2String(Document doc) {
        changeObjectId2String(doc, "_id");
    }

    /**
     * change object id to string format, use this when outputting json object
     *
     * @param doc   document object
     * @param field Object id field, by default it's _id
     */
    public static void changeObjectId2String(Document doc, String field) {
        if ((doc != null) && (doc.get(field) != null)) {
            ObjectId oid = (ObjectId) doc.get(field);
            doc.put(field, oid.toString());
        }
    }

    public static void changeUserObjectId2String(Document user) {
        if (user != null) {
            changeObjectId2String(user);
            // remove password from output
            user.remove("password");
            if (user.get("papers") != null) {
                @SuppressWarnings("unchecked")
                List<Document> papersDoc = (List<Document>) user.get("papers");
                for (Document paper : papersDoc)
                    MongoUtil.changeObjectId2String(paper, "paperref");
            }
            if (user.get("paperref") != null)
                MongoUtil.changeObjectId2String(user, "paperref");
        }
    }

    public static void changePaperObjectId2String(Document paper) {
        if (paper != null) {
            changeObjectId2String(paper);
            if (paper.get("owner") != null)
                MongoUtil.changeObjectId2String(paper, "owner");
        }
    }

    /**
     * get all papers given user has access to
     *
     * @param db mongo database
     * @param id paper id
     * @return paper object
     */
    public static Document getPaper(MongoDatabase db, String id) {
        return getPaper(db, new ObjectId(id));
    }

    /**
     * get all papers given user has access to
     *
     * @param db  mongo database
     * @param pid paper object id
     * @return paper object
     */
    public static Document getPaper(MongoDatabase db, ObjectId pid) {
        Document paper = MongoUtil.getDocument(db, COLLECTION_NAME_PAPERS, eq("_id", pid), eq("status", "active"));
        return paper;
    }

    /**
     * get all papers given user has access to
     *
     * @param db  mongo database
     * @param who who
     * @return list of paper objects
     */
    public static List<Document> getPapers(MongoDatabase db, String who) {
        List<Document> papers = new ArrayList<Document>();
        Document userDoc = MongoUtil.getDocument(db, COLLECTION_NAME_USERS, USERNAME, who);
        @SuppressWarnings("unchecked")
        List<Document> papersDoc = (List<Document>) userDoc.get("papers");
        for (Document paper : papersDoc) {
            ObjectId pid = (ObjectId) paper.get("paperref");
            //String role = paper.get("role").toString();
            Document pp = getPaper(db, pid);
            if (pp != null)
                papers.add(pp);
        }
        return papers;
    }

    public static List<String> getStudentList(Document email) {
        @SuppressWarnings("unchecked")
        List<String> studentList = (List<String>) email.get("studentList");
        @SuppressWarnings("unchecked")
        List<String> uncheckedList = (List<String>) email.get("uncheckedList");
        if ((studentList != null) && (uncheckedList != null)) {
            @SuppressWarnings("unchecked")
            List<String> userList = ListUtils.subtract(studentList, uncheckedList);
            studentList = userList;
        }
        return studentList;
    }


    /**
     * Get email information for given user and email
     *
     * @param user  user
     * @param email email
     * @return email information, including email address, subject, body
     */
    public static Map<String, String> getEmailInformation(Document user, List<Document> userdata, Document email, List<Document> paragraphs) {
        if ((user == null) || (email == null))
            throw new IllegalArgumentException("User or emails null");
        @SuppressWarnings("unchecked")
        Document userInfo = (Document) user.get("userInfo");
        String emailField = (String) email.get("emailField");
        String address = (String) userInfo.get(emailField);
        String introductoryParagraph = (String) email.get("introductoryParagraph");
        String concludingParagraph = (String) email.get("concludingParagraph");
        // send email
        String subject = (String) email.get("subject");
        String body = introductoryParagraph;

        for(Document p : paragraphs)
        {
            if(p.get("type").equals("conditional")){
            List<ObjectId> includeList = (ArrayList)p.get("studentList");
            if(includeList != null && includeList.contains(user.get("_id")))
                body += p.get("text") != null ? p.get("text") : "";
            }
            else
            {
                body += p.get("text") != null ? p.get("text") : "";
            }
        }

        body += concludingParagraph;
        subject = MongoUtil.replaceEmailTemplate(subject, userInfo, userdata);
        body = MongoUtil.replaceEmailTemplate(body, userInfo, userdata);
        Map<String, String> result = new HashMap<String, String>();
        result.put("address", address);
        result.put("subject", subject);
        result.put("body", body);
        return result;
    }


    public static String replaceEmailTemplate(String message, Map map, List<Document> userdata) {
        String result = message;
        for (String key : (Set<String>) map.keySet()) {
            // replace here
            result = result.replace("{{student." + key + "}}", (String) map.get(key));
        }
        for(Document d : userdata){
            List data = (ArrayList)d.get("data");
            Document dd = (Document)data.get(0);
            result = result.replace("{{data." + d.get("colref") + "}}", dd.get("value").toString());
        }

        return result;

    }

    public static File getPaperDir(UploadLocation uploadLocation, Document paper) {
        if ((uploadLocation == null) || (paper == null))
            throw new IllegalArgumentException("uploadLocation is not set or paper is null");
        File uploadDir = uploadLocation.getUploadDir();
        File paperDir = new File(uploadDir, paper.get("_id").toString());
        return paperDir;
    }

    /**
     * save user data for given colref and userref, if data does not exist, insert a new one, otherwise, update.
     *
     * @param db      mongo database
     * @param value   value
     * @param colref  colref
     * @param userref userref
     * @param who     who
     * @return user data as map
     */
    public static Map saveUserData(MongoDatabase db, String value, ObjectId colref, ObjectId userref, Document who) {
        Map map;
        Document oldUserData = getDocument(db, COLLECTION_NAME_USERDATA, eq("colref", colref), eq("userref", userref));
        if (oldUserData == null) {
            map = saveNewUserData(db, value, colref, userref, who);
        } else {
            ObjectId userDataId = (ObjectId) oldUserData.get("_id");
            map = updateUserData(db, value, userDataId, who);
        }
        return map;
    }

    /**
     * save user data for given colref and userref without checking
     *
     * @param db      mongo database
     * @param value   value
     * @param colref  colref
     * @param userref userref
     * @param who     who
     * @return user data as map
     */
    public static Map saveNewUserData(MongoDatabase db, String value, ObjectId colref, ObjectId userref, Document who) {
        ObjectId oid = new ObjectId();
        ModelMap userdata = new ModelMap();
        userdata.put("_id", oid);
        userdata.put("colref", colref);
        userdata.put("userref", userref);
        ModelMap datum = new ModelMap();
        if (NumberUtils.isNumber(value)) {
            Number num = NumberUtils.createNumber(value);
            datum.put("value", num);
        } else
            datum.put("value", value);
        datum.put("timestamp", new Date());
        datum.put("updateBy", who.get("_id"));
        List<ModelMap> data = new ArrayList<ModelMap>();
        data.add(datum);
        userdata.put("data", data);
        db.getCollection(MongoUtil.COLLECTION_NAME_USERDATA).insertOne(new Document(userdata));
        return userdata;
    }

    /**
     * Update existing user data
     *
     * @param db    mongo database
     * @param value value
     * @param id    user data id(in string) to update
     * @param who   who
     * @return user data as map
     */
    public static Map updateUserData(MongoDatabase db, String value, String id, Document who) {
        ObjectId userDataId = new ObjectId(id);
        return updateUserData(db, value, userDataId, who);
    }

    /**
     * Update existing user data
     *
     * @param db         mongo database
     * @param value      value
     * @param userDataId user data id to update
     * @param who        who
     * @return user data as map
     */
    private static Map updateUserData(MongoDatabase db, String value, ObjectId userDataId, Document who) {
        Map map = null;
        ModelMap datum = new ModelMap();
        value = value.trim();
        if (NumberUtils.isNumber(value)) {
            Number num = NumberUtils.createNumber(value);
            datum.put("value", num);
        } else
            datum.put("value", value);
        datum.put("timestamp", new Date());
        datum.put("updatedBy", who.get("_id"));
        List<ModelMap> list = new ArrayList<ModelMap>();
        list.add(datum);

        UpdateResult result = db.getCollection(MongoUtil.COLLECTION_NAME_USERDATA).updateOne(
                eq("_id", userDataId),
                new Document("$push", new Document("data", new Document(new Document("$each", list).append("$position", 0)))));
        if (result.getModifiedCount() == 1)
            map = MongoUtil.getDocument(db, COLLECTION_NAME_USERDATA, userDataId);
        return map;
    }

}

