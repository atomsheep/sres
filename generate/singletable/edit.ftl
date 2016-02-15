[#ftl]
[#assign filename]src/main/webapp/WEB-INF/freemarker/admin/${table.name?uncap_first}Edit.ftl[/#assign]
<#assign title>Edit ${table.name?cap_first}</#assign>
<#include "/common/head.ftl" />

<#include "/common/header.ftl" />

<#include "custom/*/${table.name?uncap_first}EditInside.ftl" />

<#include "/common/footer.ftl" />
