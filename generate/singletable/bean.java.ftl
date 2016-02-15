[#ftl]
[#import "functions.fff" as functions]
[#assign filename]src/main/java/nz/ac/otago/edtech/${application.projectName}/bean/[#if table.makeModelAbstract]Abstract[/#if]${table.name?cap_first}.java[/#assign]
package nz.ac.otago.edtech.${application.projectName}.bean;

[#if functions.hasUser(table)]
import nz.ac.otago.edtech.spring.bean.User;
[/#if]
[#if functions.hasRandomCode(table)]
import nz.ac.otago.edtech.spring.bean.WebID;
[/#if]

import java.util.HashSet;
import java.util.Set;

[#macro addOneToManyManagement member]
    /**
     * @param ${member.tableReference?uncap_first} to add
     */
    public void add${member.name?cap_first}(${member.tableReference?cap_first} ${member.tableReference?uncap_first}) {
        ${member.tableReference?uncap_first}.set${table.name?cap_first}(this);
        ${member.name?uncap_first}.add(${member.tableReference?uncap_first});
    }

    /**
     * @param ${member.tableReference?uncap_first} to remove
     */
    public void remove${member.name?cap_first}(${member.tableReference?cap_first} ${member.tableReference?uncap_first}) {
        ${member.tableReference?uncap_first}.set${table.name?cap_first}(null);
        ${member.name?uncap_first}.remove(${member.tableReference?uncap_first});
    }

    /**
     * @return a new ${member.tableReference?cap_first}
     */
    public ${member.tableReference?cap_first} create${member.name?cap_first}() {
        ${member.tableReference?cap_first} new${member.tableReference?cap_first} = new ${member.tableReference?cap_first}();
        add${member.name?cap_first}(new${member.tableReference?cap_first});
        return new${member.tableReference?cap_first};
    }
[/#macro]
[#macro addOneToManyLinkManagement member]
    /**
     * @param ${member.tableReference?uncap_first} to add
     */
    public void add${member.tableReference?cap_first}(${member.tableReference?cap_first} ${member.tableReference?uncap_first}) {
        ${member.tableReference?uncap_first}.get${member.associatedList?cap_first}().addInternal${member.tableReference?cap_first}(${member.tableReference?uncap_first});
        addInternal${member.tableReference?cap_first}(${member.tableReference?uncap_first});
    }

    /**
     * @param ${member.tableReference?uncap_first} to add
     */
    void addInternal${member.tableReference?cap_first}(${member.tableReference?cap_first} ${member.tableReference?uncap_first}) {
        ${member.tableReference?uncap_first}.set${table.name?cap_first}(this);
        ${member.name?uncap_first}.add(${member.tableReference?uncap_first});
    }

    /**
     * @param ${member.tableReference?uncap_first} to remove
     */
    public void remove${member.tableReference?cap_first}(${member.tableReference?cap_first} ${member.tableReference?uncap_first}) {
        ${member.tableReference?uncap_first}.get${member.associatedList?cap_first}().removeInternal${member.tableReference?cap_first}(${member.tableReference?uncap_first});
        removeInternal${member.tableReference?cap_first}(${member.tableReference?uncap_first});
    }

    /**
     * @param ${member.tableReference?uncap_first} to remove
     */
    void removeInternal${member.tableReference?cap_first}(${member.tableReference?cap_first} ${member.tableReference?uncap_first}) {
        ${member.name?uncap_first}.remove(${member.tableReference?uncap_first});
    }

    /**
     * @return a new ${member.tableReference?cap_first}
     */
    public ${member.tableReference?cap_first} create${member.tableReference?cap_first}(${member.associatedList?cap_first} ${member.associatedList}) {
        ${member.tableReference?cap_first} new${member.tableReference?cap_first} = new ${member.tableReference?cap_first}();
        new${member.tableReference?cap_first}.set${member.associatedList?cap_first}(${member.associatedList});
        add${member.tableReference?cap_first}(new${member.tableReference?cap_first});
        return new${member.tableReference?cap_first};
    }
[/#macro]

/**
 * ${table.name?cap_first} bean. This bean has the following fields:
 * <p/>
 * <ul>
[#list table.fields.list as field]
 * <li><b>${field.name?uncap_first} </b>- ${field.description}</li>
[/#list]
 * </ul>
 *
 * @author Richard Zeng (richard.zeng@otago.ac.nz)
 */
public [#if table.makeModelAbstract]abstract [/#if]class [#if table.makeModelAbstract]Abstract[/#if]${table.name?cap_first}[#if functions.hasRandomCode(table)] extends WebID[/#if] {

    // --------------------------- VARIABLES START ----------------------------

[#list table.fields.list as field]
    /**
     * ${field.description}
     */
[#if field.tableReference??]
    [#if field.mapping?ends_with("MANY")]
        [#assign association = functions.getTable(field.tableReference)]
        [#if false && association.orderBy??]
    private SortedSet<${field.tableReference?cap_first}> ${field.name?uncap_first} = new TreeSet<${field.tableReference?cap_first}>();
        [#else]
    private Set<${field.tableReference?cap_first}> ${field.name?uncap_first} = new HashSet<${field.tableReference?cap_first}>();
        [/#if]
    private Long[] ${field.name?uncap_first}Id;
    [#else]
    private ${field.tableReference?cap_first} ${field.name?uncap_first};

    private Long ${field.name?uncap_first}Id;
    [/#if]
[#else]
    [#if field.formType = "FILE"]
    private org.springframework.web.multipart.MultipartFile ${field.name?uncap_first};

    private String ${field.name?uncap_first}UserName;
    [#else]
    private ${field.type} ${field.name?uncap_first};
    [/#if]
[/#if]

[/#list]

    // --------------------------- RELATIONSHIP MANAGEMENT --------------------
[#list table.fields.list as field]
[#assign managementAdded="false"]
[#if field.tableReference?? && field.associatedList??]
[#if field.linkManagement]
[@addOneToManyLinkManagement member=field /]
[#assign managementAdded="true"]
[/#if]
[/#if]
[#if managementAdded="false" && field.mapping! = "ONETOMANY"]
[@addOneToManyManagement member=field /]
[/#if]
[/#list]

    // --------------------------- GET METHODS START --------------------------

[#list table.fields.list as field]
    /**
     * Returns ${field.description}.
     *
     * @return ${field.name?uncap_first}
     */
[#if field.tableReference??]
    [#if field.mapping?ends_with("MANY")]
        [#assign association = functions.getTable(field.tableReference)]
        [#if false && association.orderBy??]
    public SortedSet<${field.tableReference?cap_first}> get${field.name?cap_first}() {
        return this.${field.name?uncap_first};
    }
        [#else]
    public Set<${field.tableReference?cap_first}> get${field.name?cap_first}() {
        return this.${field.name?uncap_first};
    }
        [/#if]

    public Long[] get${field.name?cap_first}Id() {
        return this.${field.name?uncap_first}Id;
    }
    [#else]
    public ${field.tableReference?cap_first} get${field.name?cap_first}() {
        return this.${field.name?uncap_first};
    }

    public Long get${field.name?cap_first}Id() {
        return this.${field.name?uncap_first}Id;
    }
    [/#if]
[#else]
    [#if field.formType = "FILE"]
    public org.springframework.web.multipart.MultipartFile get${field.name?cap_first}() {
        return this.${field.name?uncap_first};
    }

    public String get${field.name?cap_first}UserName() {
        return this.${field.name?uncap_first}UserName;
    }
    [#else]
    public ${field.type} get${field.name?cap_first}() {
        return this.${field.name?uncap_first};
    }
    [/#if]
[/#if]

[/#list]

    // --------------------------- SET METHODS START --------------------------

[#list table.fields.list as field]
    /**
     * Sets ${field.description}.
     *
     * @param ${field.name?uncap_first} ${field.description}
     */
[#if field.tableReference??]
    [#if field.mapping?ends_with("MANY")]
        [#assign association = functions.getTable(field.tableReference)]
        [#if false && association.orderBy??]
    public void set${field.name?cap_first}(SortedSet<${field.tableReference?cap_first}> ${field.name?uncap_first}) {
        this.${field.name?uncap_first} = ${field.name?uncap_first};
    }
        [#else]
    public void set${field.name?cap_first}(Set<${field.tableReference?cap_first}> ${field.name?uncap_first}) {
        this.${field.name?uncap_first} = ${field.name?uncap_first};
    }
        [/#if]

    public void set${field.name?cap_first}Id(Long[] ${field.name?uncap_first}Id) {
        this.${field.name?uncap_first}Id = ${field.name?uncap_first}Id;
    }
    [#else]
    public void set${field.name?cap_first}(${field.tableReference?cap_first} ${field.name?uncap_first}) {
        this.${field.name?uncap_first} = ${field.name?uncap_first};
    }

    public void set${field.name?cap_first}Id(Long ${field.name?uncap_first}Id) {
        this.${field.name?uncap_first}Id = ${field.name?uncap_first}Id;
    }
    [/#if]
[#else]
    [#if field.formType = "FILE"]
    public void set${field.name?cap_first}(org.springframework.web.multipart.MultipartFile ${field.name?uncap_first}) {
        this.${field.name?uncap_first} = ${field.name?uncap_first};
    }

    public void set${field.name?cap_first}UserName(String ${field.name?uncap_first}UserName) {
        this.${field.name?uncap_first}UserName = ${field.name?uncap_first}UserName;
    }
    [#else]
    public void set${field.name?cap_first}(${field.type} ${field.name?uncap_first}) {
        this.${field.name?uncap_first} = ${field.name?uncap_first};
    }
    [/#if]
[/#if]

[/#list]

    /**
     * @return a short name which should meaningfully identify this row to the user
     */
    public String getMeaningfulName() {
        StringBuilder sb = new StringBuilder();
[#if (table.display.list)??]
    [#list table.display.list as displayItem]
        [#if displayItem.referenceField??]
        sb.append(${displayItem.referenceField}.get${displayItem.value?cap_first}());
        [#else]
        sb.append(${displayItem.value});
        [/#if]
        sb.append("${displayItem.separator}");
    [/#list]
[#else]
        sb.append(get${table.fields.list[1].name?cap_first}());
[/#if]
        return sb.toString();
    }
    [#if table.parent??]

    /**
     * @return the parent of this object
     */
    public ${table.parent?cap_first} getParentClass() {
        return get${table.parent?cap_first}();
    }
    [/#if]

    /**
     * Returns a string representation of the object.
     */
    public String toString() {
        StringBuilder sb = new StringBuilder("[");
[#list table.fields.list as field]
[#if !field.tableReference??]
        sb.append("${field.name?uncap_first}=\"");
        sb.append(get${field.name?cap_first}());
        sb.append("\" ");
[/#if]
[/#list]
        sb.append("]");
        return sb.toString();
    }

}