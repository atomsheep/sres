<@showProgress 4 5/>


<h1>Import student data</h1>

<div class="box">
    Fields marked with <span style="color:#F00;">*</span> are required
    <form name="editStudentList" id="editStudentList" method="post"
          action="${baseUrl}/user/importStudentData" enctype="multipart/form-data"
          onSubmit="$('#submitButton').attr('disabled', 'disabled').val('please wait...')">

        <input type="hidden" name="id" value="${id}"/>
        <table>

            <tr>
                <td style="vertical-align:top;">
                    Populate student data from
                </td>
                <td id="timetablingData">
                    <div>
                        <span style="color:#F00;">*</span>
                        <strong>"Enrolment list" (tab-separated text file[s]) from timetabling unit</strong>
                        <i class='fa fa-question-circle' style="width:16px;"
                           data-qtip-content="File contains student enrolment information (identifiers, degree, address, etc). Expected column headers:SID,GivenNames,FamilyName,Email,DegreeAlias,Gender,PermAddressPostcode,PermAddressCountry,SemAddressPostcode,SemAddressCountry"></i>
                        Download file(s) <a href="https://web.timetable.usyd.edu.au/uosEnrolmentIndex.jsp"
                                            target="_blank">here</a>, then load it/them here:
                        <br/>

                        <div class="input-group enrolment" id='input-group'>
                <span class="input-group-btn">
                    <span class="btn btn-primary btn-file">
                        Browse… <input type="file" name="files" id="timetabling_enrolment_list_file"/>
                    </span>
                </span>
                            <input type="text" style='display:inline-block;width:200px' class="form-control" readonly/>
                        </div>
                    </div>
                    <br/>


            <tr>
                <td colspan="2"><input class='btn btn-default btn-primary' type="submit" id="submitButton"
                                       value="import student data"/></td>
            </tr>
        </table>
    </form>
</div>





<script>
    $(function () {

        $('.btn-file :file').on('fileselect', function (event, numFiles, label) {

            var input = $(this).parents('.input-group').find(':text'),
                    log = numFiles > 1 ? numFiles + ' files selected' : label;

            if (input.length) {
                input.val(log);
            } else {
                if (log) alert(log);
            }

        });

        $(document).on('change', '.btn-file :file', function () {
            var input = $(this),
                    numFiles = input.get(0).files ? input.get(0).files.length : 1,
                    label = input.val().replace(/\\/g, '/').replace(/.*\//, '');
            input.trigger('fileselect', [numFiles, label]);
        });
    });
</script>