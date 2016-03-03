<@showProgress 1 1/>

<h1>Add new ${ICN}</h1>

<div class="box">
Fields marked with <span style="color:#F00;">*</span> are required
<form name="editStudentList" id="editStudentList" method="post"
      action="${baseUrl}/user/addPaper"
      onSubmit="$('#submitButton').attr('disabled', 'disabled').val('please wait...')">
<table>
<tr>
    <td>${ICN_C} code</td>
    <td>
        <input class='form-control' type="text" name="code" id="papercode" value="" size="8"
               style='display:inline-block;width:200px' required/>
        <span style="color:#F00;">*</span>
        <i class='fa fa-question-circle' style="width:16px;"
           data-qtip-content="e.g. BIOL101 or CHEM202 (alphanumeric only, <strong>no spaces</strong>)"></i>
    </td>
</tr>
<tr>
    <td>${ICN_C} name</td>
    <td>
        <input class='form-control' type="text" name="name" style='display:inline-block;width:200px'
               value="" size="40" required/>
        <span style="color:#F00;">*</span>
        <i class='fa fa-question-circle' style="width:16px;"
           data-qtip-content="e.g. Concepts in Biology (alphanumeric only)"></i>
    </td>
</tr>
<tr>
    <td>Calendar year</td>
    <td>
        <input class='form-control' type="text" name="year" value="" size="4"
               style='display:inline-block;width:200px' required/>
        <span style="color:#F00;">*</span>
        <i class='fa fa-question-circle' style="width:16px;"
           data-qtip-content="e.g. 2012 (numeric only, <strong>no spaces</strong>)"></i>
    </td>
</tr>
<tr>
    <td>Semester</td>
    <td>
        <input class='form-control' type="text" name="semester" value=""
               style='display:inline-block;width:200px' size="2" required/>
        <span style="color:#F00;">*</span>
        <i class='fa fa-question-circle' style="width:16px;"
           data-qtip-content="e.g. 1 (numeric only, <strong>no spaces</strong>)"></i>
    </td>
</tr>





<tr>
    <td colspan="2"><input class='btn btn-default btn-primary' type="submit" id="submitButton" value="Save ${ICN} information"/></td>
</tr>
</table>
</form>
</div>



