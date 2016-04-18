<@showProgress 4 5/>


<h1>Import student data</h1>

<div class="box">
    <form name="editStudentList" id="editStudentList" method="post"
          action="${baseUrl}/user/importStudentData" enctype="multipart/form-data">

        <input type="hidden" name="id" value="${id}"/>
        <table>

            <tr>
                <td id="timetablingData">
                    <div>
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
                <td colspan="2"><input class='btn btn-default btn-primary' type="submit" id="submitButton" value="import student data"/></td>
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