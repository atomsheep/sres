[#ftl]
[#import "functions.fff" as functions]
[#assign filename]src/main/java/nz/ac/otago/edtech/${application.projectName}/controller/Admin${table.name?cap_first}.java[/#assign]
package nz.ac.otago.edtech.${application.projectName}.controller;

[#assign refs = [table.name?uncap_first]]
[#list table.fields.list as field]
    [#if field.tableReference?? && !refs?seq_contains(field.tableReference?uncap_first) && (field.tableReference?uncap_first != "user")]
    [#assign refs = refs + [field.tableReference?uncap_first]]
    [/#if]
[/#list]
[#list refs?sort as r]
import nz.ac.otago.edtech.${application.projectName}.bean.${r?cap_first};
[/#list]
import nz.ac.otago.edtech.page.Page;
import nz.ac.otago.edtech.page.PageBean;
[#if functions.hasUser(table)]
import nz.ac.otago.edtech.spring.bean.User;
[/#if]
[#if functions.hasUpload(table)]
import nz.ac.otago.edtech.spring.bean.UploadLocation;
[/#if]
import nz.ac.otago.edtech.spring.service.BaseService;
import nz.ac.otago.edtech.spring.service.SearchCriteria;
import nz.ac.otago.edtech.spring.util.ModelUtil;
import nz.ac.otago.edtech.spring.util.OtherUtil;
import nz.ac.otago.edtech.util.JSONUtil;
[#if functions.hasUpload(table)]
import nz.ac.otago.edtech.spring.util.UploadUtil;
[/#if]
[#if functions.hasRandomCode(table)]
import nz.ac.otago.edtech.util.CommonUtil;
[/#if]
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.MessageSourceAccessor;
[#if functions.hasDate(table)]
import org.springframework.beans.propertyeditors.CustomDateEditor;
[/#if]
import org.springframework.dao.DataAccessException;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
[#if functions.hasDate(table)]
import org.springframework.web.bind.WebDataBinder;
[/#if]
import org.springframework.web.bind.annotation.*;
[#if functions.hasUpload(table)]
import org.springframework.web.context.ServletContextAware;
[/#if]

import javax.annotation.Resource;
[#if functions.hasUpload(table)]
import javax.servlet.ServletContext;
[/#if]
import javax.servlet.http.HttpServletRequest;
[#if functions.hasUpload(table)]
import java.io.File;
[/#if]
[#if functions.hasDate(table)]
import java.text.SimpleDateFormat;
[/#if]
import java.util.*;

/**
 * ${table.name?cap_first} Admin Controller.
 *
 * @author Richard Zeng (richard.zeng@otago.ac.nz)
 *         Date: 13/01/12
 *         Time: 9:53 AM
 */
@Controller
@RequestMapping("/admin")
public class Admin${table.name?cap_first} [#if functions.hasUpload(table)]implements ServletContextAware [/#if]{

    private static final Logger log = LoggerFactory.getLogger(Admin${table.name?cap_first}.class);
[#if functions.hasUpload(table)]
    ServletContext servletContext;
[/#if]
    @Autowired
    private BaseService service;
    @Resource
    private ApplicationContext ctx;
[#if functions.hasUpload(table)]
    @Autowired
    private UploadLocation uploadLocation;
[/#if]
    // order by field name
    private String orderBy;
    // order by descend
    private boolean orderByDesc;
    // we use these two variables here for order by, it will get value from url, or from "orderBy" and "orderByDesc"
    // we will not change "orderBy" and "orderByDesc" to the value we got from url,
    // otherwise, it will change the order by for everyone
    private String theOrderBy;
    private boolean theOrderByDesc;

    public void setOrderBy(String orderBy) {
        this.orderBy = orderBy;
    }

    public void setOrderByDesc(boolean orderByDesc) {
        this.orderByDesc = orderByDesc;
    }

    public String getTheOrderBy() {
        return theOrderBy;
    }

    public void setTheOrderBy(String theOrderBy) {
        this.theOrderBy = theOrderBy;
    }

    public boolean isTheOrderByDesc() {
        return theOrderByDesc;
    }

[#if functions.hasUpload(table)]
    public void setServletContext(ServletContext servletContext) {
        this.servletContext = servletContext;
    }

[/#if]
    @RequestMapping(value = "/${table.name?uncap_first}View", method = RequestMethod.GET)
    public String ${table.name?uncap_first}View(@RequestParam("id") Long id, ModelMap model, HttpServletRequest request) {
        if ((id != null) && (id > 0)) {
            Object obj = service.get(${table.name?cap_first}.class, id);
            model.put("obj", obj);
        }
        ModelUtil.putCommonIntoModel(request, model);
        return "admin/${table.name?uncap_first}View";
    }

    @RequestMapping(value = "/${table.name?uncap_first}Delete", method = RequestMethod.POST)
    public ResponseEntity<String> ${table.name?uncap_first}Delete(@RequestParam("id") Long[] ids, HttpServletRequest request) {
        String action = "${table.name?uncap_first}Delete";
        boolean success = false;
        String detail = null;
        MessageSourceAccessor msa = new MessageSourceAccessor(ctx);
        if (ids != null) {
            List<Map<String, Object>> deleted = new ArrayList<Map<String, Object>>();
            for (long id : ids) {
                ${table.name?cap_first} obj = (${table.name?cap_first}) service.get(${table.name?cap_first}.class, id);
                if (obj != null) {
                    if (OtherUtil.canEdit(service, request, obj.getOwner())) {
                        try {
                            service.delete(obj);
                            Map<String, Object> map = new HashMap<String, Object>();
                            map.put("id", id);
                            deleted.add(map);
                            success = true;
                        } catch (DataAccessException e) {
                            log.error("DataAccessException", e);
                            if (ids.length == 1)
                                detail = msa.getMessage("can.not.delete", new String[]{"${table.name?uncap_first}"});
                        }
                    } else if (ids.length == 1)
                        detail = msa.getMessage("delete.not.allowed", new String[]{"${table.name?uncap_first}"});;
                } else if (ids.length == 1)
                    detail = msa.getMessage("can.not.find", new String[]{"${table.name?uncap_first}"});
            }
            if (!deleted.isEmpty())
                detail = JSONUtil.toJSONArrayString(deleted);
        } else
            detail = msa.getMessage("id.is.needed");
        return OtherUtil.outputJSON(action, success, detail);
    }

    @RequestMapping(value = "/${table.name?uncap_first}List", method = RequestMethod.GET)
    public String ${table.name?uncap_first}List(@ModelAttribute("pageBean") PageBean pageBean, ModelMap model, HttpServletRequest request) {
[#if table.parent??]
        long id = ServletUtil.getParameter(request, "${table.parent?uncap_first}Id", 0L);
        ${table.parent?cap_first} ${table.parent?uncap_first} = null;
        if (id > 0)
            ${table.parent?uncap_first} = (${table.parent?cap_first}) service.get(${table.parent?cap_first}.class, id);
        if (${table.parent?uncap_first} != null) {
            getOrderBy(request, model);
            Page page;
            if (StringUtils.isBlank(getTheOrderBy())) {
                SearchCriteria criteria = new SearchCriteria.Builder()
                        .eq("${table.parent?uncap_first}", ${table.parent?uncap_first})
                        .build();
                page = service.pagination(${table.name?cap_first}.class,
                        pageBean.getP(), pageBean.getS(),
                        criteria);
            } else {
                SearchCriteria criteria = new SearchCriteria.Builder()
                        .eq("${table.parent?uncap_first}", ${table.parent?uncap_first})
                        .orderBy(getTheOrderBy(), !isTheOrderByDesc())
                        .build();
                page = service.pagination(${table.name?cap_first}.class,
                        pageBean.getP(), pageBean.getS(),
                        criteria);
            }
            if (page != null) {
                page.setRequest(request);
                model.put("pager", page);
            }
            model.put("${table.parent?uncap_first}", ${table.parent?uncap_first});
            ModelUtil.putCommonIntoModel(request, model);
            return "admin/${table.name?uncap_first}List";
        } else {
            getOrderBy(request, model);
            SearchCriteria.Builder builder = new SearchCriteria.Builder();
            if (StringUtils.isNotBlank(getTheOrderBy()))
                builder.orderBy(getTheOrderBy(), !isTheOrderByDesc());
            else
                builder.orderBy("id");
            SearchCriteria criteria = builder.build();
            Page page = service.pagination(${table.name?cap_first}.class,
                    pageBean.getP(), pageBean.getS(), criteria);
            if (page != null) {
                page.setRequest(request);
                model.put("pager", page);
            }
            ModelUtil.putCommonIntoModel(request, model);
            return "admin/${table.name?uncap_first}List";
        }
[#else]
        getOrderBy(request, model);
        SearchCriteria.Builder builder = new SearchCriteria.Builder();
        if (StringUtils.isNotBlank(getTheOrderBy()))
            builder.orderBy(getTheOrderBy(), !isTheOrderByDesc());
        else
            builder.orderBy("id");
        SearchCriteria criteria = builder.build();
        Page page = service.pagination(${table.name?cap_first}.class,
                pageBean.getP(), pageBean.getS(), criteria);
        if (page != null) {
            page.setRequest(request);
            model.put("pager", page);
        }
        ModelUtil.putCommonIntoModel(request, model);
        return "admin/${table.name?uncap_first}List";
[/#if]
    }

    @RequestMapping(value = "/${table.name?uncap_first}Edit", method = RequestMethod.GET)
    public String ${table.name?uncap_first}Edit(@RequestParam(value = "id", required = false) Long id, ModelMap model, HttpServletRequest request) {
        ${table.name?cap_first} ${table.name?uncap_first} = null;
        if ((id != null) && (id > 0))
            ${table.name?uncap_first} = (${table.name?cap_first}) service.get(${table.name?cap_first}.class, id);
        if (${table.name?uncap_first} == null)
            ${table.name?uncap_first} = new ${table.name?cap_first}();
[#list table.fields.list as field]
    [#if field.tableReference??]
        [#if table.parent?? && (table.parent == field.tableReference)]
        long pid = ServletUtil.getParameter(request, "${table.parent?uncap_first}Id", 0);
        ${table.parent?cap_first} ${table.parent?uncap_first} = null;
        if (pid != 0)
            ${table.parent?uncap_first} = (${table.parent?cap_first}) service.get(${table.parent?cap_first}.class, pid);
        if (${table.parent?uncap_first} != null)
            model.put("${table.parent?uncap_first}", ${table.parent?uncap_first});
        else {
            List ${table.parent?uncap_first}List = service.list(${table.parent?cap_first}.class);
            model.put("${table.parent?uncap_first}List", ${table.parent?uncap_first}List);
        }
        [#else]
        [#if field.associatedList?? && field.associatedList != field.tableReference]
        List ${field.name?uncap_first}List = service.list(${field.associatedList?cap_first}.class);
        [#else]
        List ${field.name?uncap_first}List = service.list(${field.tableReference?cap_first}.class);
        [/#if]
        model.put("${field.name?uncap_first}List", ${field.name?uncap_first}List);
        [/#if]
    [/#if]
[/#list]
[#if functions.hasUpload(table)]
        model.put("uploadLocation", uploadLocation);
[/#if]
        model.put("${table.name?uncap_first}", ${table.name?uncap_first});
        ModelUtil.putCommonIntoModel(request, model);
        return "admin/${table.name?uncap_first}Edit";
    }

    @RequestMapping(value = "/${table.name?uncap_first}Edit", method = RequestMethod.POST)
    public String ${table.name?uncap_first}Edit(@ModelAttribute("${table.name?uncap_first}") ${table.name?cap_first} ${table.name?uncap_first}) {
        if (${table.name?uncap_first} != null) {
[#list table.fields.list as field]
    [#if field.tableReference??]
        [#-- one to one or many to one here --]
        [#if field.mapping?ends_with("ONE")]
            // deal with ${field.tableReference?uncap_first}
            Long ${field.name?uncap_first}Id = ${table.name?uncap_first}.get${field.name?cap_first}Id();
            if (${field.name?uncap_first}Id != null) {
                ${field.tableReference?cap_first} tmp = (${field.tableReference?cap_first}) service.get(${field.tableReference?cap_first}.class, ${field.name?uncap_first}Id);
                ${table.name?uncap_first}.set${field.name?cap_first}(tmp);
            } else {
                ${table.name?uncap_first}.set${field.name?cap_first}(null);
            }
        [#else]
        [#-- many to many or one to many here --]
            // deal with ${field.tableReference?uncap_first}
            Long[] ${field.name?uncap_first}Id = ${table.name?uncap_first}.get${field.name?cap_first}Id();
            if (${field.name?uncap_first}Id != null) {
                Set<Long> ids = new HashSet<Long>(Arrays.asList(${field.name?uncap_first}Id));
                Set<${field.tableReference?cap_first}> toBeRemove = new HashSet<${field.tableReference?cap_first}>();
                if (${table.name?uncap_first}.get${field.name?cap_first}() != null)
                    for (${field.tableReference?cap_first} tmp : ${table.name?uncap_first}.get${field.name?cap_first}()) {
            [#if field.associatedList?? && field.associatedList != field.tableReference]
                        if (ids.contains(tmp.get${field.associatedList?cap_first}().getId())) {
                            ids.remove(tmp.get${field.associatedList?cap_first}().getId());
            [#else]
                        if (ids.contains(tmp.getId())) {
                            ids.remove(tmp.getId());
            [/#if]
                        } else {
                            toBeRemove.add(tmp);
                        }
                    }
                for (${field.tableReference?cap_first} tmp : toBeRemove) {
                    ${table.name?uncap_first}.remove${field.name?cap_first}(tmp);
                }
                for (Long id : ids) {
            [#if field.associatedList?? && field.associatedList != field.tableReference]
                    ${field.associatedList?cap_first} tmp1 = (${field.associatedList?cap_first}) service.get(${field.associatedList?cap_first}.class, id);
                    ${field.tableReference?cap_first} tmp2 = new ${field.tableReference?cap_first}();
                    tmp2.set${field.associatedList?cap_first}(tmp1);
                    ${table.name?uncap_first}.add${field.name?cap_first}(tmp2);
            [#else]
                    @SuppressWarnings("unchecked")
                    ${field.tableReference?cap_first} tmp = (${field.tableReference?cap_first}) service.get(${field.tableReference?cap_first}.class, id);
                    ${table.name?uncap_first}.add${field.name?cap_first}(tmp);
            [/#if]
                }
            }
        [/#if]
    [/#if]
[/#list]
            try {
                [#if functions.hasUpload(table)]
                uploadLocation.setServletContext(servletContext);
                File uploadDir = uploadLocation.getUploadDir();
                if (!uploadDir.exists())
                    if (!uploadDir.mkdirs())
                        log.warn("Can not create directory {}", uploadDir.getAbsolutePath());
                UploadUtil.saveUploadFile(form, uploadDir);
                [/#if]
                [#if functions.hasRandomCode(table)]
                if (StringUtils.isBlank(${table.name?uncap_first}.getRandomCode()))
                    ${table.name?uncap_first}.setRandomCode(CommonUtil.generateRandomCode());
                [/#if]
                if ((${table.name?uncap_first}.getId() != null) && (${table.name?uncap_first}.getId() > 0))
                    service.update(${table.name?uncap_first});
                else
                    service.save(${table.name?uncap_first});
            } catch (DataAccessException e) {
                log.error("DataAccessException", e);
                throw e;
            }
        }
        return "redirect:${table.name?uncap_first}List";
    }

    /**
     * Get order by field and descend from parameters
     *
     * @param request request object
     * @param model   data model
     */
    protected void getOrderBy(HttpServletRequest request, ModelMap model) {
        String val = request.getParameter("orderBy");
        if (StringUtils.isBlank(val))
            theOrderBy = orderBy;
        else
            theOrderBy = val;
        val = request.getParameter("orderByDesc");
        if (StringUtils.isBlank(val))
            theOrderByDesc = orderByDesc;
        else
            theOrderByDesc = Boolean.valueOf(val);
        // put orderBy and orderByDesc into data model
        model.put("orderBy", theOrderBy);
        model.put("orderByDesc", theOrderByDesc);
    }

[#if functions.hasDate(table)]
    @InitBinder
    public void initBinder(WebDataBinder binder) {
        SimpleDateFormat dateFormat = new SimpleDateFormat(Common.DATE_FORMAT);
        dateFormat.setLenient(false);
        // true passed to CustomDateEditor constructor means convert empty String to null
        binder.registerCustomEditor(Date.class, new CustomDateEditor(dateFormat, true));
    }
[/#if]

}

