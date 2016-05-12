<#--do this better - put server side maybe?? -->
<#assign arrayOfColours = [
["#1A90C7","#26A7E3","#4AB6E8","#6FC4EC","#93D3F1","#072736","#0C415A","#105C7E","#1576A2"],
["#C71AAD","#E326C7","#E84AD0","#F193E3","#F6B7EC", "#36072F","#5A0C4E","#7E106E","#A2158D"],
["#1AC78D","#26E3A4","#4AE8B3","#6FECC2","#93F1D2", "#073626","#0C5A40","#107E5A","#15A273"],
["#C7651A","#E37826","#E88F4A","#ECA56F","#F1BC93","#361B07","#5A2E0C","#7E4010","#A25215"],
["#C71A1A","#E32626","#E84A4A","#EC6F6F","#F19393","#360707","#5A0C0C","#7E1010","#A21515"]
] />

<h4 style='margin:0;padding:10px;background:#043B4E'>Columns <span class='deletePanel fa fa-times' style='float:right;'></span></h4>

<div style='overflow-y:scroll;position:absolute;top:40px;bottom:0;left:0;right:0;'>
    <table width=100% cellspacing=0 cellpadding=0 id='column_table'>
        <tr>
            <th style='text-align:center;border-left:none'><input checked="checked" type="checkbox" name="columnsAll"/></th>
            <th style='text-align:left;'>Column name</th>
            <th style='text-align:left;'>Description</th>
            <th style='text-align:left;'>Tags</th>
            <th style='text-align:left;border-right:none'></th>
        </tr>
    <#if columns?has_content>
        <#list columns?chunk(1) as cc>
            <tr>
                <#list cc as c>
                    <td>
                        <input id='check_${c._id}' type="checkbox" value="${c._id}"
                                <#if paper.uncheckedList?has_content>
                                    <#if !paper.uncheckedList?seq_contains(c._id)>
                                        checked="checked"
                                    </#if>
                                <#else>
                                    checked="checked"
                                </#if> class="columnCheckbox" name="columns"/>
                    </td>
                    <td style='text-align:left'>${c.name}</td>
                    <td style='text-align:left'>${c.description!}</td>
                    <td style='text-align:left'>${c.tags!}</td>
                    <td style='border-right:none;text-align:center;'><span class='fa fa-square colourPicker' data-column='${c._id}' style='cursor:pointer;font-size:18px;color:${arrayOfColours[cc_index%arrayOfColours?size][0]}'></span></td>
                </#list>
            </tr>
        </#list>
    <#else>
        <tr>
            <td style='padding:20px;text-align:left'>No columns found.</td>
        </tr>
    </#if>
    </table>
</div>