<span style='font-weight:bold;float:left;margin:0 10px;color:#0886AF'>
<a style='color:white;text-decoration: underline' href="${baseUrl}/user/">Home</a> >
Edit ${ICN} information
</span>
<div style='clear:both'></div>
<@showProgress 1 5/>
<form name="editPaperForm" method="post" action="${baseUrl}/user/savePaper">
<#if (paper._id)?has_content>
    <input type="hidden" name="_id" value="${paper._id}"/>
</#if>
    <input type="hidden" name="size" value="0"/>

    <h1 style='margin:0 20px'>Step 1: edit ${ICN} information
        <button type="submit" class="btn btn-default btn-primary btn-square right">Next step <span class='fa fa-caret-right submit'></span></button>
    </h1>

    <div class='info_text'>Edit your ${ICN} information. By default, SRES requires a ${ICN} code, name, year and
        semester, but you can add extra fields if you wish to store additional information about this ${ICN}.
    </div>

    <div class="box info_text side1" style='padding:0;margin:20px 10px 20px 20px;width:calc(50% - 30px);float:left'>
        <h4 style='margin:0 0 20px;padding:10px;background:#043B4E;'>Required default ${ICN} fields</h4>
        <table style='width:100%'>
            <tr>
                <td style='padding:0 20px 5px 20px'>
                    <div class='input-group input-group1' style='width:100%'>
                        <span class='input-group-addon sres_name' style='width:150px;text-align:left'>${ICN_C} code:</span>
                        <input class='form-control' type="text" name="code" value="${(paper.code)!}" size="8"
                           style='display:inline-block;' required/>
                    </div>
                </td>
            </tr>
            <tr>
                <td style='padding:0 20px 5px 20px'>
                    <div class='input-group input-group2' style='width:100%'>
                        <span class='input-group-addon sres_name' style='width:150px;text-align:left'>${ICN_C} name:</span>
                        <input class='form-control' type="text" name="name" style='display:inline-block;'
                               value="${(paper.name)!}" size="40" required/>
                    </div>
                </td>
            </tr>
            <tr>
                <td style='padding:0 20px 5px 20px'>
                    <div class='input-group input-group3' style='width:100%'>
                        <span class='input-group-addon sres_name' style='width:150px;text-align:left'>Year:</span>
                        <input class='form-control' type="text" name="year" value="${(paper.year)!}" size="4"
                               style='display:inline-block;' required/>
                    </div>
                </td>
            </tr>
            <tr>
                <td style='padding:0 20px 0 20px'>
                    <div class='input-group input-group4' style='width:100%'>
                        <span class='input-group-addon sres_name' style='width:150px;text-align:left'>Semester:</span>
                        <input class='form-control' type="text" name="semester" value="${(paper.semester)!}"
                               style='display:inline-block;' size="2" required/>
                    </div>
                </td>
            </tr>
        </table>
    </div>

    <div class="box info_text side2" style='position:relative;padding:0;margin:20px 20px 20px 10px;width:calc(50% - 30px);float:left'>
        <h4 style='margin:0;padding:10px;background:#043B4E;'>Extra ${ICN} fields (<span class='extraFieldsSize'>0</span>)</h4>

        <div class='topPanel'>
            <div class='btn btn-default btn-primary btn-square left' id="addKeyValue">
                <span class='fa fa-plus'></span> Add new paper attribute
            </div>
        </div>

        <table style='width:100%;margin-top:60px'>
        <#if extra?has_content>
            <#list extra?keys as key>
                <tr class="extra">
                    <td>
                        <input placeholder='attribute name' class='form-control' type='text' name='key${key_index}'
                               value='${key?html}' size='4'
                               style='vertical-align: top;display:inline-block;'/>
                    </td>
                    <td>
                        <input class='form-control' type='text' name='value${key_index}' placeholder='attribute value'
                               value='${extra[key]?html}' size='4'
                               style='vertical-align: top;display:inline-block;'/>
                    </td>
                </tr>

            </#list>
        </#if>
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
            $('.extraFieldsSize').text($('.extra').length);
            return false;
        });

    });
</script>

