package nz.ac.otago.edtech.sres.util;

import com.mongodb.MongoClient;
import com.mongodb.client.FindIterable;
import com.mongodb.client.MongoDatabase;
import org.bson.Document;
import org.bson.types.ObjectId;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.ui.ModelMap;

import javax.servlet.http.HttpServletRequest;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.List;

import static com.mongodb.client.model.Filters.eq;

/**
 * name here.
 *
 * @author Richard Zeng (richard.zeng@otago.ac.nz)
 *         Date: 16/02/16
 *         Time: 12:21 PM
 */
public class MongoUtil {

    private static final Logger log = LoggerFactory.getLogger(MongoUtil.class);


    public static ObjectId insertOne(HttpServletRequest request, MongoDatabase db, String collection) {

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

    public static List<Document> getAllDocuments( MongoDatabase db, String collection) {
        List<Document> documents = new ArrayList<Document>();
        FindIterable<Document> iterable = db.getCollection(collection).find();
        for (Document document : iterable)
            documents.add(document);
        return documents;
    }

    public static Document getDocument( MongoDatabase db, String collection, String _id) {
        Document doc = null;
        List<Document> documents = new ArrayList<Document>();
        ObjectId oId = new ObjectId(_id);
        FindIterable<Document> iterable = db.getCollection(collection).find(eq("_id", oId));
        for (Document document : iterable) {
            log.debug("document {} for {}", document, _id);
            documents.add(document);
        }
        if (!documents.isEmpty())   {
            doc = documents.get(0);
            if(documents.size() > 1)
                log.info("There is more than one document with id {}", _id);
        }
        return doc;
    }

}
