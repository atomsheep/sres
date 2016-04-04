<@showProgress 2 5/>

<h1>Add student list</h1>

<div class="box">
    <form name="editStudentList" id="editStudentList" method="post"
          action="${baseUrl}/user/addStudentList" enctype="multipart/form-data"
          onSubmit="">

        <input type="hidden" name="id" value="${id}"/>
        <table>
            <tr>
                <td>
                    <div class="input-group enrolment" id='input-group'>
                        <span class="input-group-btn">
                            <span class="btn btn-primary btn-file">
                                Browse … <input type="file" name="files"/>
                            </span>
                        </span>
                        <input type="text" style="display:inline-block;width:200px" class="form-control" readonly/>
                    </div>
                    <br/>
                </td>
            </tr>
            <tr>
                <td colspan="2">
                    <input class="btn btn-default btn-primary" type="submit"
                                       value="Add student list"/>
                </td>
            </tr>
        </table>
    </form>
</div>


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
