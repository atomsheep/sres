<span><a style='text-decoration: underline' href="${baseUrl}/user/">Home</a> > <a style='text-decoration: underline' href="${baseUrl}/user/viewStudentList/${id}">View paper</a> > <a style='text-decoration: underline' href='${baseUrl}/user/viewColumnList/${id}'>Edit columns</a> > Add new column</span>

<h1>Add new column</h1>

<div class="box">
<form name="editStudentList" id="editStudentList" method="post"
      action="${baseUrl}/user/addColumn">
<table>
<tr>
    <td style='padding:0 5px 5px 0'>Column name</td>
    <td style='padding:0 5px 5px 0'>
        <input class='form-control' type="text" name="name" id="columnname" value="" size="8" style='display:inline-block;width:300px' required />
    </td>
</tr>
<tr>
    <td style='padding:0 5px 5px 0;vertical-align:top'>Column description</td>
    <td style='padding:0 5px 5px 0'>
        <textarea class='form-control' name="description" style='resize:vertical;width:300px'></textarea>
    </td>
</tr>
<tr>
    <td style='padding:0 5px 5px 0'>Column tags (comma-separated)</td>
    <td style='padding:0 5px 5px 0;vertical-align: top'>
        <input placeholder='tag1, tag2, etc' class='form-control' data-role='tagsinput' type="text" name="tags" style='vertical-align: top;display:inline-block;width:300px' />
    </td>
</tr>
    <tr id='addNewColumnAttribute'>
        <td colspan="2"><button class='btn btn-default btn-primary' id="addKeyValue" style='margin-top:20px'>Add new column attribute</button></td>
    </tr>

    <tr>
        <td colspan='2'><h3>Column restrictions</h3></td>
    </tr>
<tr>
    <td colspan='2' style='padding:0 5px 10px 0;font-style: italic'>If you would like to restrict when data can be entered into this column, please indicate the start and end times here:</td>
</tr>
<tr>
    <td style='padding:0 5px 5px 0'>Data can be entered from:</td>
    <td style='padding:0 5px 5px 0'>
        <div class="input-daterange input-group" id="datepicker">
            <input type="text" class="form-control" name="start" />
            <span class="input-group-addon">to</span>
            <input type="text" class="form-control" name="end" />
            <span class="input-group-addon">inclusive</span>
        </div>
    </td>
</tr>
<tr>
    <td colspan='2' style='padding:10px 5px 10px 0;font-style: italic'>If you would like to restrict who can enter data into this column, please indicate their usernames here: (comma-separated)</td>
</tr>
<tr>
    <td style='padding:0 5px 5px 0;vertical-align: top'>Data can be entered by:</td>
    <td style='padding:0 5px 5px 0'>
        <textarea class='form-control' name="" style='resize:vertical;width:300px'></textarea>
    </td>
</tr>


<tr>
    <td colspan="2"><input class='btn btn-default btn-primary' type="submit" id="submitButton" value="Next" style='margin-top:20px'/></td>
</tr>
</table>
</form>
</div>

<script type="text/javascript">

    $('.input-daterange').datepicker({    });

    $('#addKeyValue').on('click', function(){
        var newRow = "<tr><td style='padding:0 5px 5px 0'><input placeholder='attribute name' class='form-control' type='text' name='tags' value='' size='4' style='vertical-align: top;display:inline-block;width:300px' /></td><td style='padding:0 5px 5px 0;vertical-align: top'><input class='form-control' type='text' name='tags' placeholder='attribute value' value='' size='4' style='vertical-align: top;display:inline-block;width:300px' /></td></tr>";
        $('#addNewColumnAttribute').before(newRow);
        return false;
    });

</script>


