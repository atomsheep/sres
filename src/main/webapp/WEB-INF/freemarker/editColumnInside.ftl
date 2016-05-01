<span>
    <a style='text-decoration: underline' href="${baseUrl}/user/">Home</a> >
    <a style='text-decoration: underline' href="${baseUrl}/user/viewPaper/${paperId}">View paper</a> >
    <a style='text-decoration: underline' href='${baseUrl}/user/viewColumnList/${id}'>Edit columns</a> >
    Edit column
</span>

<h1>Edit column</h1>

<div class="box">
    <form name="editColumnForm" method="post" action="${baseUrl}/user/saveColumn">
    <#if paperId?has_content>
        <input type="hidden" name="paperId" value="${paperId}"/>
    </#if>
    <#if column?has_content>
        <input type="hidden" name="_id" value="${column._id}"/>
    </#if>
        <input type="hidden" name="size" value="0"/>
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
            <tr>
                <td style='padding:0 5px 5px 0;vertical-align:top'>Entry method</td>
                <td style='padding:0 5px 5px 0'>
                    <input class='form-control' type="text" name="entryMethod" value="${(column.entryMethod)!?html}" size="8"
                           style='display:inline-block;width:300px' required/>
                </td>
            </tr>
            <tr>
                <td style='padding:0 5px 5px 0;vertical-align:top'>Custom display</td>
                <td style='padding:0 5px 5px 0'>
                    <textarea class='form-control' name="customDisplay"
                              style='resize:vertical;width:300px'><#if (column.customDisplay)?has_content>${column.customDisplay}</#if></textarea>
                </td>
            </tr>
            <tr>
                <td style='padding:0 5px 5px 0;vertical-align:top'>Possible values</td>
                <td style='padding:0 5px 5px 0'>
                    <textarea class='form-control' name="possibleValues"
                              style='resize:vertical;width:300px'><#if (column.possibleValues)?has_content>${column.possibleValues}</#if></textarea>
                </td>
            </tr>
        <#if extra?has_content>
            <#list extra?keys as key>
                <tr class="extra">
                    <td style='padding:0 5px 5px 0'>
                        <input placeholder='attribute name' class='form-control' type='text' name='key${key_index}'
                               value='${key?html}' size='4'
                               style='vertical-align: top;display:inline-block;width:300px'/>
                    </td>
                    <td style='padding:0 5px 5px 0;vertical-align: top'>
                        <input placeholder='attribute value' class='form-control' type='text' name='value${key_index}'
                               value='${extra[key]?html}' size='4'
                               style='vertical-align: top;display:inline-block;width:300px'/>
                    </td>
                </tr>
            </#list>
        </#if>

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
                    <input class='btn btn-default btn-primary' type="submit" value="Save"
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

        var index = 0;
    <#if extra?has_content>
        index = ${extra?keys?size};
        $('input[name=size]').val(index);
    </#if>

        $('#addKeyValue').on('click', function () {
            var newRow = "<tr class='extra'><td style='padding:0 5px 5px 0'><input placeholder='attribute name' class='form-control' type='text' name='key" + index + "' value='' size='4' style='vertical-align: top;display:inline-block;width:300px' /></td><td style='padding:0 5px 5px 0;vertical-align: top'><input placeholder='attribute value' class='form-control' type='text' name='value" + index + "' value='' size='4' style='vertical-align: top;display:inline-block;width:300px' /></td></tr>";
            index++;
            $('input[name=size]').val(index);
            $('#addNewColumnAttribute').before(newRow);
            return false;
        });

    });
</script>


