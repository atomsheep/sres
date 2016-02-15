[#ftl]
[#assign filename]src/main/webapp/WEB-INF/freemarker/admin/${table.name?uncap_first}ViewInside.ftl[/#assign]

<#if obj??>
[#list table.fields.list as field]
      <div>
      <div>${field.description?html}</div>
      [#if field.tableReference?? && field.mapping?ends_with("MANY")]
      <div>
      <#list obj.${field.name?uncap_first} as ${field.tableReference}>
        ${r"${"}${field.tableReference}} <br/>
      </#list>
      </div>
      [#else]
      <div>${r"${"}obj.${field.name?uncap_first}!?string?html}</div>
      [/#if]
      </div>
[/#list]
<#else>
no object found.
</#if>