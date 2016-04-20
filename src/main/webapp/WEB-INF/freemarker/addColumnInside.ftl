<span>
    <a style='text-decoration: underline' href="${baseUrl}/user/">Home</a> >
    <a style='text-decoration: underline' href="${baseUrl}/user/viewPaper/${id}">View paper</a> >
    <a style='text-decoration: underline' href='${baseUrl}/user/viewColumnList/${id}'>Edit columns</a> >
<#if column?has_content>
    Edit column
<#else>
    Add new column
</#if>
</span>

<h1>
<#if column?has_content>
    Edit column
<#else>
    Add new column
</#if>
</h1>

<div class="box">
    <form name="addColumnForm">
    <#if paperId?has_content>
        <input type="hidden" name="paperId" value="${paperId}"/>
    </#if>
    <#if column?has_content>
        <input type="hidden" name="_id" value="${column._id}"/>
    </#if>
        <table>
            <tr>
                <td style='padding:0 5px 5px 0'>Column name</td>
                <td style='padding:0 5px 5px 0'>
                    <input class='form-control' type="text" name="name" value="${(column.name)!?html}" size="8"
                           style='display:inline-block;width:300px' required/>
                </td>
            </tr>
            <tr>
                <td style='padding:0 5px 5px 0;vertical-align:top'>Column description</td>
                <td style='padding:0 5px 5px 0'>
                    <textarea class='form-control' name="description"
                              style='resize:vertical;width:300px'><#if (column.description)?has_content>${column.description?html}</#if></textarea>
                </td>
            </tr>
            <tr>
                <td style='padding:0 5px 5px 0'>Column tags (comma-separated)</td>
                <td style='padding:0 5px 5px 0;vertical-align: top'>
                    <input placeholder='tag1, tag2, etc' class='form-control' data-role='tagsinput' type="text"
                           name="tags" value="<#if (column.tags)?has_content>${column.tags?html}</#if>"
                           style='vertical-align: top;display:inline-block;width:300px'/>
                </td>
            </tr>
        <#list extra?keys as key>
            <tr class="extra">
                <td style='padding:0 5px 5px 0'>
                    <input placeholder='attribute name' class='form-control' type='text' name='attName'
                           value='${key?html}' size='4'
                           style='vertical-align: top;display:inline-block;width:300px'/>
                </td>
                <td style='padding:0 5px 5px 0;vertical-align: top'>
                    <input class='form-control' type='text' name='attValue' placeholder='attribute value'
                           value='${extra[key]?html}' size='4'
                           style='vertical-align: top;display:inline-block;width:300px'/>
                </td>
            </tr>
        </#list>

            <tr id='addNewColumnAttribute'>
                <td colspan="2">
                    <button class='btn btn-default btn-primary' type="button" id="addKeyValue" style='margin-top:20px'>
                        Add new column attribute
                    </button>
                </td>
            </tr>
            <tr>
                <td colspan='2'><h3>Column restrictions</h3></td>
            </tr>
            <tr>
                <td colspan='2' style='padding:0 5px 10px 0;font-style: italic'>
                    If you would like to restrict when data
                    can be entered into this column, please indicate the start and end times here:
                </td>
            </tr>
            <tr>
                <td style='padding:0 5px 5px 0'>Data can be entered from:</td>
                <td style='padding:0 5px 5px 0'>
                    <div class="input-daterange input-group" id="datepicker">
                        <input type="text" class="form-control" name="activeFrom"
                               value="<#if (column.activeFrom)?has_content>${column.activeFrom?string('dd/MM/yyyy')}</#if>"/>
                        <span class="input-group-addon">to</span>
                        <input type="text" class="form-control" name="activeTo"
                               value="<#if (column.activeTo)?has_content>${column.activeTo?string('dd/MM/yyyy')}</#if>"/>
                        <span class="input-group-addon">inclusive</span>
                    </div>
                </td>
            </tr>
            <tr>
                <td colspan='2' style='padding:10px 5px 10px 0;font-style: italic'>If you would like to restrict who can
                    enter data into this column, please indicate their usernames here: (comma-separated)
                </td>
            </tr>
            <tr>
                <td style='padding:0 5px 5px 0;vertical-align: top'>Data can be entered by:</td>
                <td style='padding:0 5px 5px 0'>
                    <textarea class='form-control' name="" style='resize:vertical;width:300px'></textarea>
                </td>
            </tr>
            <tr>
                <td colspan="2">
                    <input class='btn btn-default btn-primary submit' type="button" value="Save"
                           style='margin-top:20px'/>
                </td>
            </tr>
        </table>
    </form>
</div>

<script type="text/javascript">
    $(function () {
        $('.input-daterange').datepicker({
            autoclose: true,
            format: "dd/mm/yyyy"
        });

        $('#addKeyValue').on('click', function () {
            var newRow = "<tr class='extra'><td style='padding:0 5px 5px 0'><input placeholder='attribute name' class='form-control' type='text' name='attName' value='' size='4' style='vertical-align: top;display:inline-block;width:300px' /></td><td style='padding:0 5px 5px 0;vertical-align: top'><input class='form-control' type='text' name='attValue' placeholder='attribute value' value='' size='4' style='vertical-align: top;display:inline-block;width:300px' /></td></tr>";
            $('#addNewColumnAttribute').before(newRow);
            return false;
        });

        $('input.submit').on("click", function () {
            var paperId = $('input[name=paperId]').val();
            var _id = $('input[name=_id]').val();
            var name = $('input[name=name]').val();
            var description = $('textarea[name=description]').val();
            var tags = $('input[name=tags]').val();
            var activeFrom = $('input[name=activeFrom]').val();
            var activeTo = $('input[name=activeTo]').val();
            var attributes = {};
            $('tr.extra').each(function (i, e) {
                var attName = $('[name=attName]', this).val();
                var attValue = $('[name=attValue]', this).val();
                attributes[attName] = attValue;
            });
            var attString = JSON.stringify(attributes);
            console.log("attribute string", attString);
            $.post("${baseUrl}/user/saveColumn",
                    {paperId: paperId, _id: _id, name: name, description: description, tags: tags, activeFrom: activeFrom, activeTo: activeTo, json: attString},
                    function (json) {
                        console.log('json', json);
                        if (json.success) {
                            var url = "${baseUrl}/user/viewColumnList/" + paperId;
                            console.log('url', url);
                            location.href = url;
                        } else if (json.detail)
                            alert(json.detail);
                    });
        });
    });
</script>


