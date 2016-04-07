package nz.ac.otago.edtech.sres.controller;

import com.mongodb.MongoClient;
import com.mongodb.client.MongoDatabase;
import nz.ac.otago.edtech.auth.bean.AuthUser;
import nz.ac.otago.edtech.auth.util.AuthUtil;
import nz.ac.otago.edtech.spring.bean.User;
import nz.ac.otago.edtech.spring.util.OtherUtil;
import nz.ac.otago.edtech.sres.util.MongoUtil;
import nz.ac.otago.edtech.util.CommonUtil;
import nz.ac.otago.edtech.util.JSONUtil;
import org.apache.commons.codec.digest.DigestUtils;
import org.apache.commons.lang3.StringUtils;
import org.bson.Document;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.context.ServletContextAware;

import javax.annotation.PostConstruct;
import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import static com.mongodb.client.model.Filters.eq;


/**
 * Common Controller.
 *
 * @author Richard Zeng (richard.zeng@otago.ac.nz)
 *         Date: 16/01/12
 *         Time: 11:41 AM
 */
@Controller
public class Common implements ServletContextAware {

    @Autowired
    MongoClient mongoClient;

    @Value("${mongodb.dbname}")
    private String dbName;

    private static MongoDatabase db = null;

    @PostConstruct
    public void init() {
        db = mongoClient.getDatabase(dbName);
    }

    // default view name
    public static final String DEFAULT_VIEW_NAME = "main";
    // date format string
    public static final String DATE_FORMAT = "dd/MM/yyyy HH:mm";

    private static final Logger log = LoggerFactory.getLogger(Common.class);


    ServletContext servletContext;

    public void setServletContext(ServletContext servletContext) {
        this.servletContext = servletContext;
    }

    @RequestMapping(value = "/", method = RequestMethod.GET)
    public String home(ModelMap model) {
        model.put("pageName", "home");
        return DEFAULT_VIEW_NAME;
    }

    /**
     * Logout controller
     *
     * @param request request
     * @return view name
     */
    @RequestMapping(value = "/logout", method = RequestMethod.GET)
    public String logout(HttpServletRequest request) {
        request.getSession().invalidate();
        return "redirect:/";
    }

    /**
     * Keep alive controller
     *
     * @return response entity
     */
    @RequestMapping(value = "/keepAlive", method = RequestMethod.GET)
    public ResponseEntity<String> keepAlive(HttpServletRequest request) {
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("time", new Date().toString());
        String answer = JSONUtil.toJSONString(map);
        return OtherUtil.outputJSON(answer);
    }

    /**
     * Login controller
     *
     * @param request request
     * @param model   data model
     * @return view name
     */
    @RequestMapping(value = "/login", method = RequestMethod.GET)
    public String loginForm(HttpServletRequest request, ModelMap model) {

        String code = CommonUtil.generateRandomCode();
        model.put(AuthUser.ONE_TIME_TOKEN_KEY, code);
        HttpSession session = request.getSession();
        session.setAttribute(AuthUser.ONE_TIME_TOKEN_KEY, code);
        model.put("fromUrl", request.getParameter("from"));
        model.put("pageName", "login");
        return DEFAULT_VIEW_NAME;
    }

    /**
     * Login controller
     *
     * @param request request
     * @param model   data model
     * @return view name
     */
    @RequestMapping(value = "/login", method = RequestMethod.POST)
    public String loginSubmit(@RequestParam("username") String username,
                              @RequestParam("password") String password,
                              ModelMap model,
                              HttpServletRequest request, HttpServletResponse response) {

        boolean validUser = MongoUtil.authenticate(db, username, password);

        if (!validUser) {
            log.warn("Invalid user: username = {} from {}", username, AuthUtil.getIpAddress(request));
            model.put("error", "Invalid username or password. Please try again.");
            // generate a new token
            String code = CommonUtil.generateRandomCode();
            model.put(AuthUser.ONE_TIME_TOKEN_KEY, code);
            HttpSession session = request.getSession();
            session.setAttribute(AuthUser.ONE_TIME_TOKEN_KEY, code);
            model.put("pageName", "login");
            model.put("fromUrl", request.getParameter("from"));
            return DEFAULT_VIEW_NAME;
        } else {
            User user = new User();
            user.setUserName(username);
            String sha256 = DigestUtils.sha256Hex(password);
            user.setPassWord(sha256);

            HttpSession session = request.getSession();
            AuthUser authUser = AuthUtil.getAuthUser(user, session);
            AuthUtil.setAuthUser(session, authUser);

            String from = request.getParameter("from");
            if (StringUtils.isNotBlank(from)) {
                try {
                    response.sendRedirect(from);
                } catch (IOException e) {
                    log.error("IO Exception", e);
                }
                return null;
            }
        }
        model.put("pageName", "login");
        return DEFAULT_VIEW_NAME;
    }

}
