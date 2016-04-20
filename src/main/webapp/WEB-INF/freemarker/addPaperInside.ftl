<@showProgress 1 5/>

<h1>Add new ${ICN}</h1>

<div class="box">
    Fields marked with <span style="color:#F00;">*</span> are required

    <form name="editStudentList" method="post"
          action="${baseUrl}/user/addPaper">
        <table>
            <tr>
                <td style='padding:0 5px 5px 0'>${ICN_C} code</td>
                <td style='padding:0 5px 5px 0'>
                    <input class='form-control' type="text" name="code" id="papercode" value="" size="8"
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
                           value="" size="40" required/>
                    <span style="color:#F00;">*</span>
                    <i class='fa fa-question-circle' style="width:16px;"
                       data-qtip-content="e.g. Concepts in Biology (alphanumeric only)"></i>
                </td>
            </tr>
            <tr>
                <td style='padding:0 5px 5px 0'>Calendar year</td>
                <td style='padding:0 5px 5px 0'>
                    <input class='form-control' type="text" name="year" value="" size="4"
                           style='display:inline-block;width:200px' required/>
                    <span style="color:#F00;">*</span>
                    <i class='fa fa-question-circle' style="width:16px;"
                       data-qtip-content="e.g. 2012 (numeric only, <strong>no spaces</strong>)"></i>
                </td>
            </tr>
            <tr>
                <td>Semester</td>
                <td style='padding:0 5px 0 0'>
                    <input class='form-control' type="text" name="semester" value=""
                           style='display:inline-block;width:200px' size="2" required/>
                    <span style="color:#F00;">*</span>
                    <i class='fa fa-question-circle' style="width:16px;"
                       data-qtip-content="e.g. 1 (numeric only, <strong>no spaces</strong>)"></i>
                </td>
            </tr>


            <tr>
                <td colspan="2">
                    <input class='btn btn-default btn-primary' type="submit" value="Next"
                           style='margin-top:20px'/></td>
            </tr>
        </table>
    </form>
</div>



