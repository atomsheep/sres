<h1>User home</h1>


<div class="box" id="div_student_lists">
    <table class="borderless" width="100%">
        <tr>
            <td>
                <h3>Student lists</h3>
                <table class="borderless">
                    <tr>
                        <td>
                            <label for="studentLists">Available lists:</label>
                        </td>
                        <td>
                            <select id="studentLists">
                                <option></option>
                            <#if list?has_content>
                                <#list list as ti>
                                    <option value="${ti._id}">
                                    ${ti._id} ${ti.code!} ${ti.name!} ${ti.year!} ${ti.semester!}
                                    </option>
                                </#list>
                            </#if>
                            </select>
                        </td>
                        <td>
                    </tr>
                    <tr>
                        <td>List actions:</td>
                        <td>
                            <input class='btn btn-default btn-primary' type="button" id="viewList"
                                   value="view full list"/>
                            <button id="viewPaper" class="btn btn-default btn-primary">View Paper Information</button>
                            <input class='btn btn-default btn-primary' type="button" id="showPerson"
                                   value="show information for one person"
                                   onClick="javascript:window.location='showPersonInfo.cfm?tableuuid=' + $('##studentLists').val();"/>
                        </td>
                    </tr>
                    <tr>
                        <td>Administrator actions:</td>
                        <td>
                            <input class='btn btn-default btn-primary' type="button" id="editList"
                                   value="edit list options"
                                   onClick="javascript:window.location = 'editStudentListTable.cfm?action=edit&tableuuid='+$('##studentLists').val();">
                            <input class='btn btn-default btn-primary' type="button" id="bulk_import_data"
                                   value="bulk import data"
                                   onClick="javascript:window.location = 'importData.cfm?tableuuid=' + $('##studentLists').val();"/>
                        </td>
                    </tr>
                    <tr>
                        <td>List administrator actions:</td>
                        <td>
                            <a class='btn btn-default btn-success' id="addList" href="${baseUrl}/user/addPaper">add a
                                new list</a>
                        </td>
                    </tr>
                    <tr>
                        <td>Superadministrator actions:</td>
                        <td>
                            <input class='btn btn-default btn-danger' type="button" id="deleteList"
                                   value="delete selected list">
                        </td>
                    </tr>
                </table>

            </td>

            <td align="right" valign="top">
                <table>
                    <tr>
                        <td>
                        </td>
                    </tr>
                    <tr>
                        <td>
                        </td>
                    </tr>
                    <tr>
                        <td>
                    </tr>
                    <tr>
                        </td>
                        <td>
                        </td>
                    </tr>
                    <tr>
                        </td>
                        <td>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
</div>

<script type='text/javascript'>
    $(function () {

        $('#viewList').on('click', function () {
            var val = $('#studentLists').val();
            if (val.length > 0)
                location.href = "${baseUrl}/user/viewStudentList/" + val;
            else {
                alert("Please choose a paper first.");
                $('#studentLists').focus();
            }
        });

        $('#viewPaper').on('click', function () {
            var val = $('#studentLists').val();
            if (val.length > 0)
                location.href = "${baseUrl}/user/viewPaper/" + val;
            else {
                alert("Please choose a paper first.");
                $('#studentLists').focus();
            }
        });

        $('#deleteList').on('click', function () {
            if (confirm('Are you sure you wish to delete this list? There is no recovering from this action!')) {
                var val = $('#studentLists').val();
                if (val.length > 0)
                    $.get("${baseUrl}/user/deletePaper/" + val, function (json) {
                        if (json.success) {
                            console.log('deleted', val);
                            $('#studentLists option:selected').remove();
                        } else if (json.detail)
                            alert(json.detail);
                    });
                else {
                    alert("Please choose a paper first.");
                    $('#studentLists').focus();
                }
            }
        });


    });
</script>