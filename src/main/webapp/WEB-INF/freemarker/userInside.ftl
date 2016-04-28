<div class='info_text'>
${SRES_INTRO_TEXT}
</div>

<div class="box" id="div_student_lists" style='margin:0 20px'>

    <a class='btn btn-default btn-primary' id="addList" href="${baseUrl}/user/editPaper" style='margin-top:20px'>
        Add a new ${ICN}</a>
    <h3>${ICN_C} list</h3>
    <table id='paperList' class="borderless" width='100%' style='margin-top:20px;'>
    <tr>
        <th width='12%' style='text-align:center;border-left:none'>${ICN_C} code</th>
        <th width='12%' style='text-align:center;'>${ICN_C} name</th>
        <th width='12%' style='text-align:center;'>${ICN_C} year</th>
        <th width='12%' style='text-align:center;'>${ICN_C} semester</th>
        <th width='12%' style='text-align:center;'>Number of students</th>
        <th width='12%' style='text-align:center;background:none;border-right:none'></th>
        <th width='12%' style='text-align:center;background:none;border-right:none'></th>
        <th width='12%' style='text-align:center;background:none;border-right:none'></th>
        <th width='12%' style='text-align:center;background:none;border-right:none'></th>
        </tr>
    <#if list?has_content>
        <#list list as l>
            <tr class='paperRow_${l._id}'>
                <td style='text-align:center;border-left:none'>${l.code!}</td>
                <td style='text-align:center;font-size:16px;font-style:italic;font-weight:bold'>${l.name!}</td>
                <td style='text-align:center'>${l.year!}</td>
                <td style='text-align:center'>${l.semester!}</td>
                <td style='text-align:center'>
                    ${l.studentCount!0}
                </td>
                <td style='text-align:center'>
                    <a href="${baseUrl}/user/viewPaper/${l._id}" id="viewList" class="btn btn-default btn-primary" style="width:100%;display:block">View paper</a>
                </td>
                <td style='text-align:center'>
                    <a href="${baseUrl}/user/editPaper/${l._id}" id="editPaper" class="btn btn-default btn-primary" style="width:100%;display:block">Edit paper information</a>
                </td>
                <td style='text-align:center'>
                    <a href="${baseUrl}/user/viewColumnList/${l._id}" id="editColumns" class="btn btn-default btn-primary" style="width:100%;display:block">Edit columns</a>
                </td>
                <td style='text-align:center;border-right:none'>
                    <button data-id='${l._id}' class="deleteList btn btn-default btn-danger" style="width:100%;display:block">Delete ${ICN}</button>
                </td>
            </tr>
        </#list>
    </#if>

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