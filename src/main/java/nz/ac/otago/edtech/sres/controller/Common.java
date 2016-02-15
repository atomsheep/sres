package nz.ac.otago.edtech.sres.controller;

import nz.ac.otago.edtech.auth.util.AuthUtil;
import nz.ac.otago.edtech.spring.bean.User;
import nz.ac.otago.edtech.spring.service.BaseService;
import nz.ac.otago.edtech.spring.util.OtherUtil;
import nz.ac.otago.edtech.util.JSONUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.context.ServletContextAware;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

/**
 * Common Controller.
 *
 * @author Richard Zeng (richard.zeng@otago.ac.nz)
 *         Date: 16/01/12
 *         Time: 11:41 AM
 */
@Controller
public class Common implements ServletContextAware {

    // default view name
    public static final String DEFAULT_VIEW_NAME = "main";
    // date format string
    public static final String DATE_FORMAT = "dd/MM/yyyy HH:mm";
    private static final Logger log = LoggerFactory.getLogger(Common.class);
    ServletContext servletContext;
    @Autowired
    private BaseService service;

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
        User who = OtherUtil.getCurrentUser(service, request);
        if (who != null)
            log.debug("keep alive @ {} from {} {}", map.get("time"), AuthUtil.getIpAddress(request), who.getUserName());
        else
            log.debug("keep alive @ {} from {}", map.get("time"), AuthUtil.getIpAddress(request));
        return OtherUtil.outputJSON(answer);
    }

}
