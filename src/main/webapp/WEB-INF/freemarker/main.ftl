<#if !pageName??>
    <#assign pageName="home"/>
</#if>

<#include "common/head.ftl" />

<#include "common/header.ftl" />

<#include "${pageName}Inside.ftl" />