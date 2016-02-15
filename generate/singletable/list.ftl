[#ftl]
[#assign filename]src/main/webapp/WEB-INF/freemarker/admin/${table.name?uncap_first}List.ftl[/#assign]
<#import "../spring.ftl" as spring />
<#assign title>List All ${table.name?cap_first}</#assign>
<#include "/common/head_1.ftl" />

<#include "/common/head_2.ftl" />
<#include "/common/header.ftl" />

<#include "custom/*/${table.name?uncap_first}ListInside.ftl" />

<#include "/common/footer.ftl" />
