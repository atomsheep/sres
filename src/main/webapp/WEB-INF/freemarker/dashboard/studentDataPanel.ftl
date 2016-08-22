<#assign studentTotal = 0 />
<#if results?has_content><#assign studentTotal = results?size/></#if>
<table style="width:100%">
    <tr>
        <td style="vertical-align: bottom;text-align:left">
            <h1 style='padding:0;margin:5px 0 0;'>
                <span style="font-weight:300;color:#333">${paper.code!} </span><span style="font-weight:500;color:#333">${paper.name!}</span>
            </h1>
            <h2 style="margin:0 0 20px"><span class="studentCount">${studentTotal}</span> / ${studentTotal} selected</h2>
        </td>
        <td style="vertical-align: bottom;text-align:right">
            <div style="float:right;text-align:right;margin-bottom:20px">
                <button type="button" id="options_button" class="paper_buttons" style="border:none;color:white;margin-left:10px;background:#367;float:right;padding:15px 30px;">
                    <div class="iris-options paper_controls" style="margin-top:0"></div>
                    <div class="paper_controls small_text" style="margin-bottom:0">Options</div>
                </button>
                <button id="filter_button" type="button" class="paper_buttons" style="border:none;color:white;background:#009590;float:right;padding:15px 30px;">
                    <div class="iris-filter paper_controls" style="margin-top:0"></div>
                    <div class="paper_controls small_text" style="margin-bottom:0">Filter</div>
                </button>
            <#--<button class="top_buttons button_clear"><span class='fa fa-comments'></span> SMS selected students</button>-->
            </div>
        </td>
    </tr>
</table>

<div style="clear:both"></div>
<#assign span = 0 />

<table class="paperList_table table_headers" style="font-size:20px;font-size:1.2vw;width:calc(100% - 17px) !important">
    <tr>
        <td class="button_clear row_check master_check">
            <div class="iris-check" style="margin-bottom:-5px"></div>
        </td>
        <#assign span = span + 1 />
        <#if studentFields?has_content>
            <#list studentFields as f>
                <td class="studentField-td field_${f_index}" style="border-right:1px solid #999;background:#333;color:white;border-bottom-color:#999" title="${f?html}">
                    <div>${f?html}</div>
                </td>
                <#assign span = span + 1 />
            </#list>
        </#if>
        <td class="filler"></td>
        <#assign span = span + 1 />
        <#if columns?has_content>
            <#list columns as c>
                <td class="studentData-td data_${c_index}" style="background:#fdefbb;border-right:1px solid #f1cf3d" title="${c.name!}">
                    <div>${c.name!}</div>
                </td>
                <#assign span = span + 1 />
            </#list>
        </#if>
    </tr>
</table>
<div id="scrollable_table" style="position: absolute;bottom: 0;left: 0;right: 0;overflow-y: scroll;overflow-x: hidden;">
<table class="paperList_table table_body" style="font-size:20px;font-size:1.2vw">
    <tr>
        <td class="trick_cell"></td>
        <#list studentFields as n>
            <td class="trick_cell studentField-td field_${n_index}"></td>
        </#list>
        <td class="trick_cell"></td>
        <#list columns as n>
            <td class="trick_cell studentData-td data_${n_index}"></td>
        </#list>
    </tr>
    <#if results?has_content>
        <#list results as r>
        <tr>
            <td class="button_clear row_check"><div class="iris-check" style="margin-bottom:-5px"></div></td>
            <#list studentFields as f>
                <td data-value="${f?html}" class="studentField-td field_${f_index}" style="border-right:1px solid #999;border-bottom-color:#333" >
                    ${r.userInfo[f]}
                </td>
            </#list>
            <td class="filler"></td>
            <#list columns as c>
                <#if r[c._id]?has_content>
                    <#assign ud = r[c._id]/>
                    <td class="studentData-td ${ud.colref} data_${c_index}" data-id="${ud._id}" data-userid="${ud.userref}"
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
          </tr>
        </#list>
    </#if>
</table>
</div>

<script type="text/javascript">

    <#if studentFields?has_content>
        <#list 0..(studentFields?size-1) as n>
            var $table_header = $('.field_${n}:first','.table_headers');
            var $table_body = $('.field_${n}:first','.table_body');
            var width1 = $table_header.outerWidth();
            var width2 = $table_body.outerWidth();
            var width = width1 > width2 ? width1 : width2;

            $table_header.css("width",width+"px");
            $table_header.find('div').css("width",(width-45)+"px").addClass('nowrap');
            $table_body.css("width",width+"px");
            <#if (n > 0)>
                $('.field_${n}').addClass('not_shown');
            </#if>
        </#list>
    </#if>

    <#if columns?has_content>
        <#list 0..(columns?size-1) as n>
            $table_header = $('.data_${n}:first','.table_headers');
            $table_body = $('.data_${n}:first','.table_body');
            width1 = $table_header.outerWidth();
            width2 = $table_body.outerWidth();
            width = width1 > width2 ? width1 : width2;

            $table_header.css("width",width+"px");
            $table_header.find('div').css("width",(width-41)+"px").addClass('nowrap');
            $table_body.css("width",width+"px");
        </#list>
    </#if>

    function getBottom(el) {
        return el.position().top + el.outerHeight();
    }

    $('#scrollable_table').css("top",getBottom($(".table_headers")) + "px");

</script>
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