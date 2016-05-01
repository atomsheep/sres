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
        <button type="submit" class="btn btn-default btn-primary"
                style='float:right;border-radius:0;padding:10px 10px 9px;'>
            Next step <span class='fa fa-caret-right submit'></span></button>
    </h1>

    <div class='info_text'>Edit your ${ICN} information. By default, SRES requires a ${ICN} code, name, year and
        semester, but you can add extra fields if you wish to store additional information about this ${ICN}.
    </div>

    <div class="box info_text side1" style='padding:0;margin:20px 10px 20px 20px;width:calc(50% - 30px);float:left'>
        <h4 style='margin:0 0 20px;padding:10px;background:#043B4E;'>Required default ${ICN} fields</h4>
        <table style='width:100%'>
            <tr>
                <td style='padding:0 5px 5px 20px'>${ICN_C} code</td>
                <td style='padding:0 20px 5px 0;width:80%'>
                    <input class='form-control' type="text" name="code" value="${(paper.code)!}" size="8"
                           style='display:inline-block;' required/>
                </td>
            </tr>
            <tr>
                <td style='padding:0 5px 5px 20px'>${ICN_C} name</td>
                <td style='padding:0 20px 5px 0'>
                    <input class='form-control' type="text" name="name" style='display:inline-block;'
                           value="${(paper.name)!}" size="40" required/>
                </td>
            </tr>
            <tr>
                <td style='padding:0 5px 5px 20px'>Calendar year</td>
                <td style='padding:0 20px 5px 0'>
                    <input class='form-control' type="text" name="year" value="${(paper.year)!}" size="4"
                           style='display:inline-block;' required/>
                </td>
            </tr>
            <tr>
                <td style='padding:0 5px 5px 20px'>Semester</td>
                <td style='padding:0 20px 0 0'>
                    <input class='form-control' type="text" name="semester" value="${(paper.semester)!}"
                           style='display:inline-block;' size="2" required/>
                </td>
            </tr>
        </table>
    </div>

    <div class="box info_text side2" style='padding:0;margin:20px 20px 20px 10px;width:calc(50% - 30px);float:left'>
        <h4 style='margin:0 0 20px;padding:10px;background:#043B4E;'>Extra ${ICN} fields</h4>

        <table style='width:100%'>
        <#if extra?has_content>
            <#list extra?keys as key>
                <tr class="extra">
                    <td>
                        <input placeholder='attribute name' class='form-control' type='text' name='key${key_index}'
                               value='${key?html}' size='4'
                               style='vertical-align: top;display:inline-block;width:300px'/>
                    </td>
                    <td>
                        <input class='form-control' type='text' name='value${key_index}' placeholder='attribute value'
                               value='${extra[key]?html}' size='4'
                               style='vertical-align: top;display:inline-block;width:300px'/>
                    </td>
                </tr>

            </#list>
        </#if>
            <tr id='addNewColumnAttribute'>
                <td colspan="2">
                    <button class='btn btn-default btn-primary' type="button" id="addKeyValue" style='margin-top:20px'>
                        Add new paper attribute
                    </button>
                </td>
            </tr>

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
            var newRow = "<tr class='extra'><td style='padding:0 5px 5px 0'><input placeholder='attribute name' class='form-control' type='text' name='key" + index + "' value='' size='4' style='vertical-align: top;display:inline-block;width:300px' /></td><td style='padding:0 5px 5px 0;vertical-align: top'><input placeholder='attribute value' class='form-control' type='text' name='value" + index + "' value='' size='4' style='vertical-align: top;display:inline-block;width:300px' /></td></tr>";
            index++;
            $('input[name=size]').val(index);
            $('#addNewColumnAttribute').before(newRow);
            return false;
        });

    });
</script>

