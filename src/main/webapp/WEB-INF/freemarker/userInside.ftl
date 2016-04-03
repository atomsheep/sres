<style>
    td {
        padding: 10px 10px 0 0;
    }
</style>

<h1 style='font-family:Impact, sans-serif'>SRES</h1>

<div>
${SRES_INTRO_TEXT}
</div>

<div class="box" id="div_student_lists">
    <h3>${ICN_C} list</h3>

        List administrator actions:
                <a class='btn btn-default btn-success' id="addList" href="${baseUrl}/user/addPaper">
                    Add a new ${ICN}</a>
    <table id='paperlist' class="borderless" width='100%' style='margin-top:20px;'>
    <tr>
        <th width='12%'>${ICN} code</th>
        <th width='12%'>${ICN} name</th>
        <th width='12%' style='text-align:center'>${ICN} year</th>
        <th width='12%' style='text-align:center'>${ICN} semester</th>
        <th width='12%' style='text-align:center'>Number of students</th>
        <th width='12%'></th>
        <th width='12%'></th>
        <th width='12%'></th>
        </tr>
    <#if list?has_content>
        <#list list as l>
            <tr class='paperRow_${l._id}'>
                <td style='border-top:1px solid #eee'>
            ${l.code!}
            </td>
                <td style='font-size:16px;font-style:italic;font-weight:bold'>${l.name!}</td>
                <td style='text-align:center'>${l.year!}</td>
                <td style='text-align:center'>${l.semester!}</td>
                <td style='text-align:center'>
                    <#assign studentCount = 0 />
                    <#list l.users as u>
                        <#list u.papers as p>
                            <#if p.paperref == l._id>
                                <#if p.roles?seq_contains("student")>
                                    <#assign studentCount = studentCount + 1 />
                                </#if>
                            </#if>
                        </#list>
                    </#list>
                    ${studentCount}
                </td>
                <td style='text-align:center'>
                    <a href="${baseUrl}/user/viewStudentList/${l._id}" id="viewList" class="btn btn-default btn-primary">View student list</a>
                </td>
                <td style='text-align:center'>
                    <a href="${baseUrl}/user/viewPaper/${l._id}" id="viewPaper" class="btn btn-default btn-primary">View ${ICN} information</a>
                </td>
                <td style='text-align:center'>
                    <button data-id='${l._id}' class="deleteList btn btn-default btn-danger">Delete ${ICN}</button>
                </td>
            </tr>
        </#list>
    </#if>
       <#--
        <tr class='listOptions' style='display:none'>
            <td>List actions:</td>
            <td>
                <button id="viewList" class="btn btn-default btn-primary">View student list</button>
                <button id="viewPaper" class="btn btn-default btn-primary">View ${ICN} information</button>
            </td>
        </tr>
        <tr>
            <td>Administrator actions:</td>
            <td>
                <input class='btn btn-default btn-primary' type="button" id="editList"
                       value="edit list options"
                       onClick="javascript:window.location = 'editStudentListTable.cfm?action=edit&tableuuid='+$('#paperLists').val();">
                <input class='btn btn-default btn-primary' type="button" id="bulk_import_data"
                       value="bulk import data"
                       onClick="javascript:window.location = 'importData.cfm?tableuuid=' + $('#paperLists').val();"/>
            </td>
        </tr>
        <tr>
            <td>Superadministrator actions:</td>
            <td>
                <button id="deleteList" class="btn btn-default btn-danger">Delete selected ${ICN}</button>
            </td>
        </tr>
        -->
    </table>
</div>

<script type="text/javascript">
    $(function () {

        $('.deleteList').on('click', function () {
            var self = $(this);
            var id = self.data("id");
            if (confirm('Are you sure you wish to delete this ${ICN}? There is no recovering from this action!')) {
                    $.get("${baseUrl}/user/deletePaper/" + id, function (json) {
                        if (json.success) {
                            var $paperRow = $('.paperRow_'+id);
                            $paperRow.fadeOut(300);
                        } else if (json.detail)
                            alert(json.detail);
                    });
            }
        });
    });
</script>