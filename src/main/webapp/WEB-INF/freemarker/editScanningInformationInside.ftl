<span style='font-weight:bold;float:left;margin:0 10px;color:#0886AF'>
<a style='color:white;text-decoration: underline' href="${baseUrl}/user/">Home</a> >
<a style='color:white;text-decoration: underline' href="${baseUrl}/user/viewPaper/${paperId}">View paper</a> >
<a style='color:white;text-decoration: underline' href="${baseUrl}/user/columns">View columns</a> >
<a style='color:white;text-decoration: underline' href="${baseUrl}/user/columns">Edit column info</a> >
Edit column restrictions
</span>
<div style='clear:both'></div>
<@showProgress 3 3/>

<form name="editColumnForm" method="post" action="${baseUrl}/user/saveScanningInformation">

<h1 style='margin:0 20px'>
    Step 3: edit scanning information (optional)
    <button type="submit" class="btn btn-default btn-primary"
            style='float:right;border-radius:0;padding:10px 10px 9px;'>
        Finish</button>
    <a href="${baseUrl}/user/addStudentList/${id}" class="btn btn-default btn-primary"
       style='float:right;border-radius:0;padding:10px 10px 9px;margin-right:20px'><span
            class='fa fa-caret-left'></span> Previous step</a>
</h1>

<div class='info_text'>
    Some information
</div>

    <div class='info_text side1' style='position:relative;padding:0;margin:20px 10px 20px 20px;width:calc(50% - 30px);float:left'>
        <h4 style='margin:0 0 20px;padding:10px;background:#043B4E;'>
                <span class="fa-stack " style="font-size: 11px;margin-right: 5px;">
                    <i class="fa fa-circle fa-stack-2x" style="color: #fff;"></i>
                    <i class="fa fa-stack-1x"
                       style="font-family:Roboto, sans-serif;color:#033141;font-weight: bold;font-size: 14px;">1</i>
                </span>
            Predefined values
        </h4>

        <div class='topPanel'>
            <div class='btn btn-default btn-primary' id="addKeyValue"  style='border-radius:0;padding:10px 10px 9px;border-right:1px solid #043B4E'>
                Add new predefined value
            </div>
        </div>

    <#if paperId?has_content>
        <input type="hidden" name="paperId" value="${paperId}"/>
    </#if>
    <#if column?has_content>
        <input type="hidden" name="_id" value="${column._id}"/>
    </#if>
        <input type="hidden" name="size" value="0"/>
        <table style='width:100%;margin-top:60px'>

            <tr>
                <td style='padding:0 10px 5px 20px'>
                    <div class='input-group input-group1' style='width:100%'>
                        <span class='input-group-addon sres_name' style='text-align:left'>Value:</span>
                        <input class='form-control' type="text"
                               name="value" value="" style='vertical-align: top;display:inline-block;'/>
                    </div>
                </td>
                <td style='padding:0 20px 5px 0'>
                    <div class='input-group input-group2' style='width:100%'>
                        <span class='input-group-addon sres_name' style='text-align:left'>Display text:</span>
                        <input class='form-control' type="text"
                               name="display" value="" style='vertical-align: top;display:inline-block;'/>
                    </div>
                </td>
            </tr>

            <tr style='display:none'>
                <td style='padding:0 5px 5px 0;vertical-align:top'>Custom display</td>
                <td style='padding:0 5px 5px 0'>
                    <textarea class='form-control' name="customDisplay"
                              style='resize:vertical;width:300px'><#if (column.customDisplay)?has_content>${column.customDisplay}</#if></textarea>
                </td>
            </tr>

        </table>
    </div>

    <div class="box info_text side2" style='position:relative;padding:0;margin:20px 20px 20px 10px;width:calc(50% - 30px);float:left'>
        <h4 style='margin:0 0 20px;padding:10px;background:#043B4E;'>
                <span class="fa-stack " style="font-size: 11px;margin-right: 5px;">
                    <i class="fa fa-circle fa-stack-2x" style="color: #fff;"></i>
                    <i class="fa fa-stack-1x"
                       style="font-family:Roboto, sans-serif;color:#033141;font-weight: bold;font-size: 14px;">2</i>
                </span>
            Extra column fields (<span class='extraFieldsSize'>0</span>)
        </h4>

        <div class='topPanel'>
            <div class='btn btn-default btn-primary' id="addKeyValue"  style='border-radius:0;padding:10px 10px 9px;border-right:1px solid #043B4E'>
                Add new column attribute
            </div>
        </div>

        <table style='width:100%;margin-top:60px'>
            <tr id='addNewColumnAttribute'><td></td></tr>
        </table>

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


