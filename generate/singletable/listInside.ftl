[#ftl]
[#assign filename]src/main/webapp/WEB-INF/freemarker/admin/${table.name?uncap_first}ListInside.ftl[/#assign]

[#import "functions.fff" as functions ]

<h1>List all ${table.description}s[#if table.parent??]<#if ${table.parent?uncap_first}??> for ${r"${"}${table.parent?uncap_first}.meaningfulName}</#if>[/#if]</h1>

<#if pager.elements?size = 0>
<p>No records.</p>
<#else>

<form action="" name="listForm">
<#list pager.paramList as param>
<input type="hidden" name="${r"${"}param.name?html}" value="${r"${"}param.value?html}" />
</#list>
<table summary="" width="100%" cellpadding="5" style="text-align: left" class="results">
<thead>
<tr>
<th>
<input type="checkbox" name="all"/>
#
</th>
[#list table.fields.list as field]
[#if !field.disableRowsetColumn && field_index &gt; 0 && field.name != "lastModified" && (field.formType != "NONE" || field.showList)]
<th><a href="${r"${"}orderByLink("${field.name}")?html}">${field.description?html}</a></th>
[/#if]
[/#list]
<th></th>
</tr>
</thead>
<tbody>
<#list pager.elements as obj>
<tr id="__et_tr_${r"${"}obj.id?c}">
<td><input type="checkbox" name="id" value="${r"${"}obj.id?c}"/></td>
[#list table.fields.list as field]
    [#if !field.disableRowsetColumn && field_index &gt; 0 && field.name != "lastModified" && (field.formType != "NONE" || field.showList)]
    [#if  field_index == 1]
    <td><a href="${table.name?uncap_first}Edit?id=${r"${"}obj.id?c}${r"${"}pager.parameters?html}"><#if obj.meaningfulName?has_content>${r"${"}obj.meaningfulName}<#else>Empty</#if></a></td>
        [#elseif field.formType == "FILE"]
<td>${r"${"}obj.${field.name?uncap_first}UserName!}</td>
        [#else]
<td>
[#if functions.isChild(table, field)]
<a href="${field.tableReference?uncap_first}List?${table.name?uncap_first}Id=${r"${"}obj.id?c}">all ${field.name?uncap_first} (${r"${"}obj.${field.name?uncap_first}?size})</a>
[#else]
${r"${"}obj.${field.name?uncap_first}!?string}
[/#if]
</td>
        [/#if]
    [/#if]
[/#list]
<td><a href="#" class="delete" data-id="${r"${"}obj.id?c}"><span class="fa fa-remove"></span> delete</a></td>
</tr>
</#list>
</tbody>
</table>
</form>

<#if pager.lastPageNumber &gt; 1>
<div id="pager">
<form method="get" action="" name="pagerForm">
<#list pager.paramListWithoutPageNumber as param>
<input type="hidden" name="${r"${"}param.name?html}" value="${r"${"}param.value?html}" />
</#list>
<a href="${r"${"}pager.firstLink?html}">first page</a> |
<a href="${r"${"}pager.previousLink?html}">previous page</a> |
<a href="${r"${"}pager.nextLink?html}">next page</a> |
<a href="${r"${"}pager.lastLink?html}">last page</a>
${r"${"}pager.pageNumber}/${r"${"}pager.lastPageNumber}
<input type="text" name="p" size="2" maxlength="${r"${"}pager.lastPageNumber?length}" value="${r"${"}pager.pageNumber?c}" />
</form>
</div>
</#if>

</#if>

<div id="bottomNav">

<a href="${r"${"}baseUrl}/admin/">Back to Admin List</a>

[#if table.parent??]
<#if ${table.parent?uncap_first}??>
    [#assign parent = functions.getTable(table.parent)]
    [#if parent.parent??]
        [#assign url = "?" + parent.parent?uncap_first + "Id"]
    [/#if]
| <a href="${table.parent?uncap_first}List[#if url??]${url}=${r"${"}${table.parent?uncap_first}.${parent.parent?uncap_first}.id?c}[/#if]">Back to ${table.parent?uncap_first} list</a>
</#if>
[/#if]
| <a href="${table.name?uncap_first}Edit?id=0${r"${"}pager.parameters?html}">Create a new ${table.name?cap_first}</a>
<#if pager.elements?size &gt; 0>
| <a href="#" onclick="return deleteRecords();">Delete selected ${table.name?cap_first}</a>
</#if>
</div>

<script type="text/javascript">
    <#assign entityName = ["${table.name?uncap_first}"]/>
    <#assign message1><@spring.message "delete.select.first"/></#assign>
    <#assign message2><@spring.messageArgs "delete.confirm" entityName/></#assign>
    $(function () {
        // check or un-check all checkboxes
        $('input:checkbox[name=all]').click(function () {
            $('input:checkbox[name=id]').prop('checked', $('input:checkbox[name=all]').is(':checked'));
        });
        $('a.delete').click(function () {
            deleteRecord($(this));
            return false;
        });
        $('input:button[value=Delete]').click(function () {
            deleteRecord();
            return false;
        });
        function deleteRecord(element) {
            var ids = [];
            if (element) {
                ids.push(element.data('id'));
            } else
                $('input:checkbox[name=id]:checked').each(function () {
                    ids.push($(this).val());
                });
            if (ids.length == 0) {
                var message1 = "${r"${"}message1?js_string}";
                alert(message1);
                return false;
            }
            var message2 = "${r"${"}message2?js_string}";
            if (confirm(message2)) {
                $.post('${table.name?uncap_first}Delete',
                        {id: ids.join(',')},
                        function (json) {
                            if (json.success) {
                                var detail = json.detail;
                                if (detail.substring(0, 1) == "[") {
                                    var list = $.parseJSON(detail);
                                    for (var i = 0; i < list.length; i++) {
                                        var obj = list[i];
                                        if ($('#__et_tr_' + obj.id))
                                            $('#__et_tr_' + obj.id).remove();
                                    }
                                }
                            } else {
                                console.log('delete ${table.name?uncap_first} failed', json);
                                if (json.detail)
                                    alert(json.detail);
                            }
                        });
            }
        }
    });
</script>

