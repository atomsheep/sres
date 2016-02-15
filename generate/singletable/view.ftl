[#ftl]
[#assign filename]src/main/webapp/WEB-INF/freemarker/admin/${table.name?uncap_first}View.ftl[/#assign]
<#assign title>View ${table.name?cap_first}</#assign>
<#include "/common/head.ftl" />

<#include "/common/header.ftl" />

<#include "custom/*/${table.name?uncap_first}ViewInside.ftl" />

<#include "/common/footer.ftl" />
