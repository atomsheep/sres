<span style='font-weight:bold;float:left;margin:0 10px;color:#0886AF'>
        <a style='color:white;text-decoration: underline' href="${baseUrl}/user/">Home</a> >
        Add ${ICN} information
    </span>
<div style='clear:both'></div>
<@showProgress 1 5/>
<h1 style='margin:0 20px'>Step 1: add ${ICN} information</h1>

<div class='info_text'>Add your ${ICN} information. By default, SRES requires a ${ICN} code, name, year and semester, but you can add extra fields if you wish to store additional information about this ${ICN}.</div>

<form name="editStudentList" id="editStudentList" method="post" action="${baseUrl}/user/addPaper">

    <div class="box info_text side1" style='padding:0;margin:20px 10px 20px 20px;width:calc(50% - 30px);float:left'>
        <h4 style='margin:0 0 20px;padding:10px;background:#043B4E;'>Required default ${ICN} fields</h4>
        <table>
            <tr>
                <td style='padding:0 5px 5px 20px'>${ICN_C} code</td>
                <td style='padding:0 5px 5px 0'>
                    <input class='form-control' type="text" name="code" id="papercode" value="" size="8" style='display:inline-block;' required/>
                </td>
            </tr>
            <tr>
                <td style='padding:0 5px 5px 20px'>${ICN_C} name</td>
                <td style='padding:0 5px 5px 0'>
                    <input class='form-control' type="text" name="name" style='display:inline-block;' value="" size="40" required/>
                </td>
            </tr>
            <tr>
                <td style='padding:0 5px 5px 20px'>Calendar year</td>
                <td style='padding:0 5px 5px 0'>
                    <input class='form-control' type="text" name="year" value="" size="4" style='display:inline-block;' required/>
                </td>
            </tr>
            <tr>
                <td style='padding:0 5px 5px 20px'>Semester</td>
                <td style='padding:0 5px 0 0'>
                    <input class='form-control' type="text" name="semester" value="" style='display:inline-block;' size="2" required/>
                </td>
            </tr>
        </table>
    </div>

    <div class="box info_text side2" style='padding:0;margin:20px 20px 20px 10px;width:calc(50% - 30px);float:left'>
        <h4 style='margin:0 0 20px;padding:10px;background:#043B4E;'>Extra ${ICN} fields</h4>
    </div>

    <div class='bottomPanel'>
        <button type="submit" class="btn btn-default btn-primary" style='float:right;border-radius:0;padding:10px 10px 9px;border-left:1px solid #043B4E'>Go to step 2: add student list <span class='fa fa-caret-right'></span></button>
        <button type="button" class="btn btn-default btn-primary" style="float:right;border-radius:0;padding:10px 10px 9px;border-left:1px solid #043B4E"><span class='fa fa-check'></span> Finish and return to home page</button>
    </div>

</form>

<script type="text/javascript">
    $(function(){
        var top = $('.side1').offset().top;
        var height = $(window).height();
        var newHeight = height - top - (40+20);
        $('.side1, .side2').css("height",newHeight+"px");
    });
</script>

