<span style='font-weight:bold;float:left;margin:0 10px;color:#0886AF'>
<a style='color:white;text-decoration: underline' href="${baseUrl}/user/">Home</a> >
<a style='color:white;text-decoration: underline' href="${baseUrl}/user/viewPaper/${paperId}">View paper</a> >
<a style='color:white;text-decoration: underline' href="${baseUrl}/user/columns">View columns</a> >
<a style='color:white;text-decoration: underline' href="${baseUrl}/user/columns">Edit column info</a> >
Edit column restrictions
</span>
<div style='clear:both'></div>
<@showProgress 2 3/>

<form name="editColumnForm" method="post" action="${baseUrl}/user/saveColumnRestrictions">

<h1 style='margin:0 20px'>
    Step 2: edit column restrictions
    <button type="submit" class="btn btn-default btn-primary"
            style='float:right;border-radius:0;padding:10px 10px 9px;'>
        Next step <span class='fa fa-caret-right submit'></span></button>
    <a href="${baseUrl}/user/addStudentList/${id}" class="btn btn-default btn-primary"
       style='float:right;border-radius:0;padding:10px 10px 9px;margin-right:20px'><span
            class='fa fa-caret-left'></span> Previous step</a>
</h1>

<div class='info_text'>
    Some information
</div>

    <div class='info_text side1' style='padding:0;margin:20px 10px 20px 20px;'>
        <h4 style='margin:0;padding:10px;background:#043B4E;'>Column restrictions</h4>

        <div style='padding:20px'>
    <#if paperId?has_content>
        <input type="hidden" name="paperId" value="${paperId}"/>
    </#if>
    <#if column?has_content>
        <input type="hidden" name="_id" value="${column._id}"/>
    </#if>
        <input type="hidden" name="size" value="0"/>
        <table style='width:100%'>
            <tr>
                <td colspan='2' style='padding:0 5px 20px 0;'>
                    <span class="fa-stack " style="font-size: 11px;margin-right: 5px;">
                    <i class="fa fa-circle fa-stack-2x" style="color: #fff;"></i>
                    <i class="fa fa-stack-1x"
                       style="font-family:Roboto, sans-serif;color:#033141;font-weight: bold;font-size: 14px;">1</i>
                </span>
                    If you would like to restrict when data can be entered into this column, please indicate the start and end times here:
                </td>
            </tr>
            <tr>
                <td style='padding:0 5px 5px 0'>
                    <div class="input-daterange input-group" id="datepicker" style='width:50%'>
                        <span class="input-group-addon sres_name">Data can be entered from:</span>
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
                <td colspan='2' style='padding:40px 5px 20px 0;'>
                    <span class="fa-stack " style="font-size: 11px;margin-right: 5px;">
                    <i class="fa fa-circle fa-stack-2x" style="color: #fff;"></i>
                    <i class="fa fa-stack-1x"
                       style="font-family:Roboto, sans-serif;color:#033141;font-weight: bold;font-size: 14px;">2</i>
                </span>
                    If you would like to restrict who can enter data into this column, please indicate their usernames here: (comma-separated)
                </td>
            </tr>
            <tr>
                <td style='padding:0 0 5px'>
                    <div class='input-group input-group2' style='width:50%'>
                        <span class='input-group-addon sres_name' style='width:150px;text-align:left'>Data can be entered by:</span>
                        <textarea class='form-control' name="" style='resize:vertical;min-height:150px'></textarea>
                    </div>
                </td>
            </tr>
        </table>
        </div>
    </div>
</form>


<script type="text/javascript">
    $(function () {

        var top = $('.side1').offset().top;
        var height = $(window).height();
        var newHeight = height - top - (20);
        $('.side1, .side2').css("height", newHeight + "px");

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
            var newRow = "<tr class='extra'><td style='padding:0 5px 5px 20px'><input placeholder='attribute name' class='form-control' type='text' name='key" + index + "' value='' size='4' style='vertical-align: top;display:inline-block;' /></td><td style='padding:0 20px 5px 0;vertical-align: top'><input class='form-control' type='text' name='value" + index + "' placeholder='attribute value' value='' size='4' style='vertical-align: top;display:inline-block;' /></td></tr>";
            index++;
            $('input[name=size]').val(index);
            $('#addNewColumnAttribute').before(newRow);
            return false;
        });

    });
</script>


