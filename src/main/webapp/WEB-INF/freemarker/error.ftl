<#assign title>Error</#assign>
<#include "common/head.ftl" />

<#include "common/header.ftl" />

<#if url??>
<h1>Error when accessing ${url}</h1>
</#if>

<div>${handler!}</div>
<div>${message!}</div>

<#include "common/footer.ftl" />
