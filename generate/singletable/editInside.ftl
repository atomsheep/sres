[#ftl]
[#assign filename]src/main/webapp/WEB-INF/freemarker/admin/${table.name?uncap_first}EditInside.ftl[/#assign]
[#import "functions.fff" as functions]
<h1><#if ${table.name?uncap_first}.id?has_content>Edit<#else>Create a new</#if> ${table.description?html}</h1>

[#assign isMultipart=false]
[#list table.fields.list as field]
    [#if field.formType = "FILE"]
        [#assign isMultipart=true]
    [/#if]
[/#list]
<form action="" name="${table.name?uncap_first}Form" method="post"[#if isMultipart] enctype="multipart/form-data"[/#if]>
<#if pageNumber??>
<input type="hidden" name="p" value="${r"${"}pageNumber?c}"/>
</#if>
<#if pageSize??>
<input type="hidden" name="s" value="${r"${"}pageSize?c}"/>
</#if>
<table summary="" class="results">

[#list table.fields.list as field]
[#if !field. disableEditRow]
<!-- ${field.name?uncap_first}: ${field.description?html} -->
[#assign isParent = false]
[#if field.tableReference?? && table.parent?? && (field.tableReference=table.parent)]
[#assign isParent = true]
[/#if]
[#if !functions.isChild(table, field)]
[#if field_index = 0]
<tr class="hide">
[#else]
<tr>
[/#if]
<th>${field.description?html}</th>
<td>
[#if field.type?uncap_first = "boolean"]
<input type="radio" name="${field.name?uncap_first}" value="true"<#if ${table.name?uncap_first}.${field.name?uncap_first}?has_content && (${table.name?uncap_first}.${field.name?uncap_first}?string == "true")> checked="checked"</#if> /> Yes
<input type="radio" name="${field.name?uncap_first}" value="false"<#if ${table.name?uncap_first}.${field.name?uncap_first}?has_content && (${table.name?uncap_first}.${field.name?uncap_first}?string == "false")> checked="checked"</#if> /> No
[#else]
[#if !field.tableReference??]
    [#switch field.formType]
        [#case "FILE"]
<input type="${field.formType?lower_case}" name="${field.name?uncap_first}" />
            [#break]
        [#default]
        [#if (field.hibernate.type)?? && field.hibernate.type == "text"]
            <textarea name="${field.name?uncap_first}" rows="2"
                      cols="20"><#if ${table.name?uncap_first}.${field.name?uncap_first}?has_content>${r"${"}${table.name?uncap_first}.${field.name?uncap_first}?html}</#if></textarea>
            [#if field.useFCKEditor]
                <script type="text/javascript">
                    CKEDITOR.replace( '${field.name?uncap_first}', {
                        customConfig : '${r"${"}baseUrl}/assets/js/ckeditor_config.js'
                    });
                </script>
            [/#if]
        [#else]
            <input type="text" class="text" placeholder="${field.description?html}" name="${field.name?uncap_first}" id="${field.name?uncap_first}"
                   value="<#if ${table.name?uncap_first}.${field.name?uncap_first}?has_content><#if ${table.name?uncap_first}.${field.name?uncap_first}?is_number>${r"${"}${table.name?uncap_first}.${field.name?uncap_first}?c}<#else>${r"${"}${table.name?uncap_first}.${field.name?uncap_first}?html}</#if></#if>"/>
        [/#if]
    [/#switch]
[#else]
    [#if isParent]
    <#if ${table.parent?uncap_first}??>
${r"${"}${table.parent?uncap_first}.meaningfulName}
<input type="hidden" name="${field.name?uncap_first}" value="${r"${"}${table.parent?uncap_first}.id?c}" />
    </#if>
    [#else]
    [#assign mm=""]
    [#if field.mapping?ends_with("MANY")]
        [#assign mm=" multiple=\"multiple\""]
    [/#if]
<select name="${field.name?uncap_first}Id"${mm}[#if isParent] readonly="true"[/#if][#if mm?has_content]<#if ${field.name?uncap_first}List?size &gt; 4> size="4"</#if>[/#if]>
    [#if mm = ""]
<option value="0">&nbsp;</option>
    [/#if]
    <#list ${field.name?uncap_first}List as option>
        <option value="${r"${"}option.id?c}">${r"${"}option.meaningfulName}</option>
    </#list>
</select>
    [/#if]

[/#if]

[/#if]
</td>
<td>
${field.fieldLabel!}
[#if field.formType = "FILE"]
<#if ${table.name?uncap_first}.${field.name?uncap_first}UserName?has_content>
<a href="<#if !uploadLocation.absolutePath>${r"${"}baseUrl}/</#if>${r"${"}uploadLocation.baseLink}${r"${"}${table.name?uncap_first}.${field.name?uncap_first}UserName?url}">${r"${"}${table.name?uncap_first}.${field.name?uncap_first}UserName!}</a>
</#if>
[/#if]
</td>
</tr>
[/#if]
[/#if]
[/#list]
<tr>
<td colspan="3">
<input name="submit" type="submit" value="Save" />
<input name="reset" type="reset" value="Reset" />
</td>
</tr>

</table>
</form>

<div id="bottomNav">

<a href="${r"${"}baseUrl}/admin/">Back to Admin List</a>

| <a href="${table.name?uncap_first}List?aa=list<#if pageNumber??>&amp;p=${r"${"}pageNumber?c}</#if><#if pageSize??>&amp;s=${r"${"}pageSize?c}</#if>[#if table.parent??]&amp;${table.parent?uncap_first}Id=${r"${"}${table.parent?uncap_first}.id?c}[/#if]">Back to ${table.name?cap_first} list</a>

</div>

<script type="text/javascript">
$(function () {
[#list table.fields.list as field]
    [#if field.tableReference??]
        [#if !functions.isChild(table, field)]

        [#if field.mapping?ends_with("MANY")]
            <#list ${table.name?uncap_first}.${field.name?uncap_first} as obj>
            [#if field.associatedList?? && field.associatedList != field.tableReference]
                <#if (obj.${field.associatedList?uncap_first}.id)??>
    $('[name=${field.name?uncap_first}Id]').val("${r"${"}obj.${field.associatedList?uncap_first}.id?c}");
                </#if>
            [#else]
                <#if (obj.id)??>
    $('[name=${field.name?uncap_first}Id]').val("${r"${"}obj.id?c}");
                </#if>
            [/#if]
            </#list>
        [#else]
            <#if (${table.name?uncap_first}.${field.name?uncap_first}.id)??>
    $('[name=${field.name?uncap_first}Id]').val("${r"${"}${table.name?uncap_first}.${field.name?uncap_first}.id?c}");
            </#if>
        [/#if]

        [/#if]
    [/#if]
[/#list]
});
</script>
