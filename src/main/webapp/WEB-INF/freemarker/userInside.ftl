<style>
    td {
        padding: 10px 10px 0 0;
    }
</style>

<h1>SRES</h1>

<div>
${SRES_INTRO_TEXT}
</div>

<div class="box" id="div_student_lists">
    <h3>${ICN_C} list</h3>
    <table class="borderless">
        <tr>
            <td>List administrator actions:</td>
            <td>
                <a class='btn btn-default btn-success' id="addList" href="${baseUrl}/user/addPaper">
                    Add a new ${ICN}</a>
            </td>
        </tr>
        <tr>
            <td>
                <label for="studentLists">Available ${ICN}s:</label>
            </td>
            <td>
                <select class='form-control' id="paperLists">
                    <option value='0'></option>
                <#if list?has_content>
                    <#list list as ti>
                        <option value="${ti._id}">
                        ${ti.code!} ${ti.name!} ${ti.year!} ${ti.semester!}
                        </option>
                    </#list>
                </#if>
                </select>
            </td>
            <td>
        </tr>
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
    </table>
</div>

<script type='text/javascript'>
    $(function () {

        var $paperLists = $('#paperLists');

        $paperLists.on('change', function () {
            console.log('change');
            if ($('option:selected', $paperLists).val() != 0)   {
                $('tr.listOptions').show();
                $('#deleteList').removeAttr("disabled");
            } else {
                $('tr.listOptions').hide();
                $('#deleteList').attr("disabled", "disabled");
            }
        });

        $('#viewList').on('click', function () {
            var val = $paperLists.val();
            if (val.length > 0)
                location.href = "${baseUrl}/user/viewStudentList/" + val;
            else {
                alert("Please choose a paper first.");
                $paperLists.focus();
            }
        });

        $('#viewPaper').on('click', function () {
            var val = $paperLists.val();
            if (val.length > 0)
                location.href = "${baseUrl}/user/viewPaper/" + val;
            else {
                alert("Please choose a paper first.");
                $paperLists.focus();
            }
        });

        $('#deleteList').on('click', function () {
            if (confirm('Are you sure you wish to delete this ${ICN}? There is no recovering from this action!')) {
                var val = $paperLists.val();
                if (val.length > 0)
                    $.get("${baseUrl}/user/deletePaper/" + val, function (json) {
                        if (json.success) {
                            console.log('deleted', val);
                            $('option:selected', $paperLists).remove();
                        } else if (json.detail)
                            alert(json.detail);
                    });
                else {
                    alert("Please choose a paper first.");
                    $paperLists.focus();
                }
            }
        });

        $paperLists.change();

    });
</script>