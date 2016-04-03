package nz.ac.otago.edtech.sres.util;

import com.mongodb.client.FindIterable;
import com.mongodb.client.MongoDatabase;
import org.bson.Document;
import org.bson.conversions.Bson;
import org.bson.types.ObjectId;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.ui.ModelMap;

import javax.servlet.http.HttpServletRequest;
import java.util.ArrayList;
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
        List<Document> documents = new ArrayList<Document>();
        FindIterable<Document> iterable = db.getCollection(collection).find(eq("_id", oId));
        for (Document document : iterable) {
            log.debug("document {} for {}", document, oId);
            documents.add(document);
        }
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
        List<Document> documents = new ArrayList<Document>();
        FindIterable<Document> iterable = db.getCollection(collection).find(eq(key, value));
        for (Document document : iterable) {
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
            documents.add(document);
        }
        return documents;
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

}
