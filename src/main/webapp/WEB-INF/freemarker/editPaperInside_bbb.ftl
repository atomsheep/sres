<h1>Edit ${ICN}</h1>

<div class="box">
    Fields marked with <span style="color:#F00;">*</span> are required

    <form name="editPaperForm">
        <input type="hidden" name="_id" value="${paper._id}"/>
        <table>
            <tr>
                <td style='padding:0 5px 5px 0'>${ICN_C} code</td>
                <td style='padding:0 5px 5px 0'>
                    <input class='form-control' type="text" name="code" value="${paper.code}" size="8"
                           style='display:inline-block;width:200px' required/>
                    <span style="color:#F00;">*</span>
                    <i class='fa fa-question-circle' style="width:16px;"
                       data-qtip-content="e.g. BIOL101 or CHEM202 (alphanumeric only, <strong>no spaces</strong>)"></i>
                </td>
            </tr>
            <tr>
                <td style='padding:0 5px 5px 0'>${ICN_C} name</td>
                <td style='padding:0 5px 5px 0'>
                    <input class='form-control' type="text" name="name" style='display:inline-block;width:200px'
                           value="${paper.name}" size="40" required/>
                    <span style="color:#F00;">*</span>
                    <i class='fa fa-question-circle' style="width:16px;"
                       data-qtip-content="e.g. Concepts in Biology (alphanumeric only)"></i>
                </td>
            </tr>
            <tr>
                <td style='padding:0 5px 5px 0'>Calendar year</td>
                <td style='padding:0 5px 5px 0'>
                    <input class='form-control' type="text" name="year" value="${paper.year}" size="4"
                           style='display:inline-block;width:200px' required/>
                    <span style="color:#F00;">*</span>
                    <i class='fa fa-question-circle' style="width:16px;"
                       data-qtip-content="e.g. 2012 (numeric only, <strong>no spaces</strong>)"></i>
                </td>
            </tr>
            <tr>
                <td>Semester</td>
                <td style='padding:0 5px 0 0'>
                    <input class='form-control' type="text" name="semester" value="${paper.semester}"
                           style='display:inline-block;width:200px' size="2" required/>
                    <span style="color:#F00;">*</span>
                    <i class='fa fa-question-circle' style="width:16px;"
                       data-qtip-content="e.g. 1 (numeric only, <strong>no spaces</strong>)"></i>
                </td>
            </tr>
        <#list extra?keys as key>
            <tr class="extra">
                <td>
                    <input placeholder='attribute name' class='form-control' type='text' name='attName'
                           value='${key?html}' size='4' style='vertical-align: top;display:inline-block;width:300px'/>
                </td>
                <td>
                    <input class='form-control' type='text' name='attValue' placeholder='attribute value'
                           value='${extra[key]?html}' size='4'
                           style='vertical-align: top;display:inline-block;width:300px'/>
                </td>
            </tr>

        </#list>
            <tr id='addNewColumnAttribute'>
                <td colspan="2">
                    <button class='btn btn-default btn-primary' type="button" id="addKeyValue" style='margin-top:20px'>
                        Add new paper attribute
                    </button>
                </td>
            </tr>

            <tr>
                <td colspan="2">
                    <input class='btn btn-default btn-primary submit' type="button" value="Save"
                           style='margin-top:20px'/></td>
            </tr>
        </table>
    </form>
</div>


<script type="text/javascript">
    $(function () {

        $('#addKeyValue').on('click', function () {
            var newRow = "<tr class='extra'><td style='padding:0 5px 5px 0'><input placeholder='attribute name' class='form-control' type='text' name='attName' value='' size='4' style='vertical-align: top;display:inline-block;width:300px' /></td><td style='padding:0 5px 5px 0;vertical-align: top'><input class='form-control' type='text' name='attValue' placeholder='attribute value' value='' size='4' style='vertical-align: top;display:inline-block;width:300px' /></td></tr>";
            $('#addNewColumnAttribute').before(newRow);
            return false;
        });

        $('input.submit').on("click", function () {
            var paperId = $('input[name=paperId]').val();
            var _id = $('input[name=_id]').val();
            var code = $('input[name=code]').val();
            var name = $('input[name=name]').val();
            var year = $('input[name=year]').val();
            var semester = $('input[name=semester]').val();
            var attributes = {};
            $('tr.extra').each(function (i, e) {
                var attName = $('[name=attName]', this).val();
                var attValue = $('[name=attValue]', this).val();
                attributes[attName] = attValue;
            });
            var attString = JSON.stringify(attributes);
            console.log("attribute string", attString);
            //*
            $.post("${baseUrl}/user/savePaper",
                    { _id: _id, code: code, name: name, year: year, semester: semester, json: attString},
                    function (json) {
                        console.log('json', json);
                        if (json.success) {
                            var url = "${baseUrl}/user/";
                            console.log('url', url);
                            location.href = url;
                        } else if (json.detail)
                            alert(json.detail);
                    });
            //*/
        });
    });
</script>
