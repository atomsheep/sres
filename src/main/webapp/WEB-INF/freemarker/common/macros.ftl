<#assign baseUrl><@spring.url ""/></#assign>
<#if baseUrl?contains(";jsessionid")>
<#--
has session id in baseUrl
-->
    <#assign baseUrl=baseUrl?keep_before(";jsessionid")/>
</#if>
<#if baseUrl?ends_with("/")><#assign baseUrl=baseUrl?remove_ending("/")/></#if>
<#--
    name: orderByLink
    desc: add a link to headers of the list, which will order by the field name
    @param: fieldName field name
-->
<#function orderByLink fieldName>
    <#local link = pager.linkWithoutOrderBy + "&orderBy=" + fieldName + "&"/>
    <#if orderBy! == fieldName>
        <#local link = link + "orderByDesc=" + (!orderByDesc)?string/>
        <#else>
            <#local link = link + "orderByDesc=false"/>
    </#if>
    <#return link/>
</#function>

<#--
    name: displayFieldName
    desc: display field name, and an input box to change field name
-->
<#macro displayFieldName>
<div class="fieldName">
    <#if spring.status.value?has_content>
    ${spring.status.value?html}
    <#else>
    ${fieldName}
    </#if>
</div>
<input type="text" class="fieldName" name="${spring.status.expression}"
       value="<#if spring.status.value?has_content>${spring.status.value?html}<#else>${fieldName}</#if>"/>
</#macro>

<#--
    name: displayContent
    desc: display content. If there is html tag inside, display as is, otherwise, replace \n with <br/>
    @param: content content to display
-->
<#macro displayContent content>
    <#if content?has_content &&  (content?matches("<\\w+>", "m") || content?matches("<\\w+[^>]*>", "m"))>
    ${content}
    <#else>
    ${content!?html?replace("\n", "<br/>")}
    </#if>
</#macro>

<#macro showProgress step totalSteps>
<table style='font-size:32px'>
    <tr>
        <#list 1..totalSteps as i>
            <td>
                <#if i == step>
            <span class="fa-stack fa-lg">
            <i class="fa fa-circle fa-stack-2x" style='color:#9ecc4f'></i>
            <i class="fa fa-stack-1x" style='color:#033141'>${i}</i>
            </span>
                <#else>
                    <span class="fa-stack ">
            <i class="fa fa-circle fa-stack-2x" style='color:#f2935d'></i>
            <i class="fa fa-stack-1x" style='color:#033141'>${i}</i>
            </span>
                </#if>
            </td>
        </#list>

    </tr>
</table>
</#macro>