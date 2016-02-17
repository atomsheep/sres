<h1>Add student list</h1>

<div class="box">
Fields marked with <span style="color:#F00;">*</span> are required
<form name="editStudentList" id="editStudentList" method="post"
      action="${baseUrl}/user/addPaper"
      onSubmit="$('#submitButton').attr('disabled', 'disabled').val('please wait...')">
<table>
<tr>
    <td>Paper code</td>
    <td>
        <input class='form-control' type="text" name="code" id="papercode" value="" size="8"
               style='display:inline-block;width:200px' required/>
        <span style="color:#F00;">*</span>
        <i class='fa fa-question-circle' style="width:16px;"
           data-qtip-content="e.g. BIOL101 or CHEM202 (alphanumeric only, <strong>no spaces</strong>)"></i>
    </td>
</tr>
<tr>
    <td>Paper name</td>
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
    <td colspan="2"><input class='btn btn-default btn-primary' type="submit" id="submitButton" value="add student list"/></td>
</tr>
</table>
</form>
</div>


<script>

    $('#timetabling_class_list_file_number').on('change', function () {
        $('div.input-group.timetable').hide().removeAttr('required');
        for (i = 0; i <= $(this).val(); i++) {
            $('div#input-group_tt_' + i).show().attr('required', 'required');
        }
    });
    $('#timetabling_enrolment_list_file_number').on('change', function () {
        $('div.input-group.enrolment').hide().removeAttr('required');
        for (i = 0; i <= $(this).val(); i++) {
            $('div#input-group_' + i).show().attr('required', 'required');
        }
    });
    $(document).ready(function () {
        $('#timetabling_enrolment_list_file_number').trigger('change');
        $('#timetabling_class_list_file_number').trigger('change');
    });
</script>


<script>
    $(function() {

        $('.btn-file :file').on('fileselect', function(event, numFiles, label) {

            var input = $(this).parents('.input-group').find(':text'),
                    log = numFiles > 1 ? numFiles + ' files selected' : label;

            if( input.length ) {
                input.val(log);
            } else {
                if( log ) alert(log);
            }

        });

        $(document).on('change', '.btn-file :file', function() {
            var input = $(this),
                    numFiles = input.get(0).files ? input.get(0).files.length : 1,
                    label = input.val().replace(/\\/g, '/').replace(/.*\//, '');
            input.trigger('fileselect', [numFiles, label]);
        });
    });
</script>