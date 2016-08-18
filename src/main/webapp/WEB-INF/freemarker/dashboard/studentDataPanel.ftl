<#-- change this - move to server -->
<#assign arrayOfColours = [
["#1A90C7","#26A7E3","#4AB6E8","#6FC4EC","#93D3F1","#072736","#0C415A","#105C7E","#1576A2"],
["#C71AAD","#E326C7","#E84AD0","#F193E3","#F6B7EC", "#36072F","#5A0C4E","#7E106E","#A2158D"],
["#1AC78D","#26E3A4","#4AE8B3","#6FECC2","#93F1D2", "#073626","#0C5A40","#107E5A","#15A273"],
["#C7651A","#E37826","#E88F4A","#ECA56F","#F1BC93","#361B07","#5A2E0C","#7E4010","#A25215"],
["#C71A1A","#E32626","#E84A4A","#EC6F6F","#F19393","#360707","#5A0C0C","#7E1010","#A21515"]
] />
<#--
<h4 class='panelHeader'>
    Students <span class='studentCount'>${results?size}</span> / ${results?size}
    <span class='fa fa-times deletePanel' style='float:right'></span>
</h4>
-->
<div style="float:right;margin-bottom:20px;text-align:right">
    <#if results?has_content>
        <button type="submit" class="top_buttons button_clear"><div class="iris-email button_icon"></div><div class="button_text">Email students</div></button>
        <#--<button class="top_buttons button_clear"><span class='fa fa-comments'></span> SMS selected students</button>-->
    </#if>
</div>

<h2 style="float:left;color:#b19209">Student list (<#if results?has_content>${results?size}<#else>0</#if>)</h2>

<div style="clear:both"></div>

<div style="position: absolute;bottom: 0;top: 70px;left: 0;right: 0;overflow-y: scroll;overflow-x: hidden;">
<table class="paperList_table" style="font-size:20px">
    <colgroup class="myCol">
        <col span="${studentFields?size}">
    </colgroup>
    <tr>
        <td class="button_clear" style="width:50px;border-bottom:1px solid #333;box-shadow:none">
            <div class="iris-check" style="margin-bottom:-5px"></div>
        </td>
        <#if studentFields?has_content>
            <#list studentFields as f>
                <td class="studentField-td" style="border-right:1px solid #999;background:#333;color:white;border-bottom-color:#333">${f?html}</td>
            </#list>
        </#if>
        <td style="background:#f1cf3d;border-bottom-color:#f1cf3d"></td>
        <#if columns?has_content>
            <#list columns as c>
                <td class="studentData-td" style="background:#fdefbb;border-right:1px solid #f1cf3d">${c.name!}</td>
            </#list>
        </#if>
    </tr>
    <#if results?has_content>
        <#list results as r>
        <tr>
            <td class="button_clear" style="width:50px;border-bottom:1px solid #333;box-shadow:none"><div class="iris-check" style="margin-bottom:-5px"></div></td>
            <#list studentFields as f>
                <td data-value="${f?html}" class="studentField-td" style="border-right:1px solid #999;border-bottom-color:#999" >
                    ${r.userInfo[f]}
                </td>
            </#list>
            <td style="background:#f1cf3d;border-bottom-color:#f1cf3d"></td>
            <#list columns as c>
                <#if r[c._id]?has_content>
                    <#assign ud = r[c._id]/>
                    <td class="studentData-td ${ud.colref}" data-id="${ud._id}" data-userid="${ud.userref}"
                        data-columnid="${ud.colref}" style="border-right:1px solid #f1cf3d;
                        <#if paper.uncheckedList?has_content && paper.uncheckedList?seq_contains(c._id)>
                        display:none;
                        </#if>
                            "
                        data-value="${ud.data[0].value?html}">${ud.data[0].value?html}</td>
                <#else>
                    <td class="${c._id} studentData-td" data-userid="${r._id}" data-columnid="${c._id}" style="border-right:1px solid #f1cf3d"></td>
                </#if>
            </#list>
        <#--    <td style="background:#f4db6d">${l.code!}</td>
            <td style="background:#f4db6d">${l.name!}</td>
            <td style="background:#f4db6d">${l.year!}</td>
            <td style="background:#f4db6d;border-right:10px solid #f1cf3d">${l.semester!}</td>
            <td style="width:8%"><a href="${baseUrl}/user/viewPaper/${l._id}" class="paper_buttons"><div class="iris-open paper_controls" style="font-size:32px"></div><div class="paper_controls small_text">Open</div></a></td>
            <td style="width:8%"><a href="${baseUrl}/user/editPaper/${l._id}" class="paper_buttons"><div class="iris-settings paper_controls" style="font-size:32px"></div><div class="paper_controls small_text">Edit</div></a></td>
            <td style="width:8%"><a href="${baseUrl}/user/sharePaper/${l._id}" class="paper_buttons"><div class="iris-share paper_controls" style="font-size:32px"></div><div class="paper_controls small_text">Share</div></a></td>
            <td style="width:8%"><a data-id="${l._id}" href="#" class="paper_buttons deleteList"><div class="iris-delete paper_controls" style="font-size:32px"></div><div class="paper_controls small_text">Delete</div></a></td>
      -->  </tr>
        </#list>
    </#if>
</table>
</div>
<#--
<div class='innerPanel' style='top:80px;padding:0;'>
<#if results?has_content>
    <form id="resultsForm" method="post" action="${baseUrl}/user/emailStudents">
        <input name="id" type="hidden" value="${id}"/>
        <table id="studentList" width=100%>
            <thead>
            <th style='text-align:center;border-left:none'><input type="checkbox" name="usernameAll" checked="checked"/>
            </th>
                <#list studentFields as f>
                <th style='text-align:left;'>${f?html}</th>
                </#list>
                <#list columns as c>
                        <th class="${c._id}"
                            style="
                                <#if paper.uncheckedList?has_content && paper.uncheckedList?seq_contains(c._id)>
                                    display:none;
                                </#if>
                        color:white;background:<#if c.colour?has_content>${c.colour}<#else>${arrayOfColours[c_index%arrayOfColours?size][0]}</#if>;border-bottom-color: ${arrayOfColours[c_index%arrayOfColours?size][6]};<#if !c_has_next>border-right:none</#if>">${c.name}</th>
                </#list>
            </thead>
            <tbody>
                <#list results as r>
                <tr>
                    <td style='text-align:center;border-left:none'>
                        <input type="checkbox" value="${r._id}" name="usernames" checked='checked'/>
                    </td>
                    <#list studentFields as f>
                        <td style='text-align:left;position:relative' data-value="${f?html}">
                            ${r.userInfo[f]}
                            <#if f_index == 0>
                                <div class='editControls'>
                                    <a href="${baseUrl}/user/editStudent/${r._id}"><span class='fa fa-pencil btn btn-default btn-primary btn-square' style='font-size:11px'></span></a><a href="${baseUrl}/user/deleteStudent/${r._id}"><span class='fa fa-times btn btn-default btn-danger btn-square' style='border-left:1px solid #043B4E;font-size:11px'></span></a>
                                </div>
                            </#if>
                        </td>
                    </#list>
                    <#list columns as c>
                            <#if r[c._id]?has_content>
                                <#assign ud = r[c._id]/>
                                <td class="${ud.colref}" data-id="${ud._id}" data-userid="${ud.userref}"
                                    data-columnid="${ud.colref}"
                                    <#if paper.uncheckedList?has_content && paper.uncheckedList?seq_contains(c._id)>
                                        style="display:none"
                                    </#if>
                                    data-value="${ud.data[0].value?html}"> ${ud.data[0].value?html}</td>
                            <#else>
                                <td class="${c._id}" data-userid="${r._id}" data-columnid="${c._id}"></td>
                            </#if>
                    </#list>
                </tr>
                </#list>
            </tbody>
        </table>
    </form>
<#else>
    <div style="padding:20px">
        No students found.
    </div>
</#if>
</div>
-->