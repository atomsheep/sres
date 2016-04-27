<span style='font-weight:bold;float:left;margin:0 10px;color:#0886AF'>
        <a style='color:white;text-decoration: underline' href="${baseUrl}/user/">Home</a> >
        <a style='color:white;text-decoration: underline' href="${baseUrl}/user/addPaper">Add ${ICN} information</a> >
        Add student list
    </span>
<div style='clear:both'></div>
<@showProgress 2 5/>

<h1 style='margin:0 20px'>Step 2: add student list</h1>

<div class='info_text'>Upload a list of students for this ${ICN}. SRES only accepts student lists in CSV (comma separated value) format. Your CSV file must contain a unique identifier for each student (e.g. a username or student ID).
    You will be asked to map your student attributes to SRES fields in the next step.</div>

<form name="editStudentList" id="editStudentList" method="post" action="${baseUrl}/user/addStudentList" enctype="multipart/form-data" onSubmit="">

    <div class="box info_text" style='margin:20px;padding:20px 20px 0'>

        <h4 style='margin-top:0'>Upload student list</h4>
        <input type="hidden" name="id" value="${id}"/>
        <table>
            <tr>
                <td>
                    <div class="input-group enrolment" id='input-group'>
                        <span class="input-group-btn">
                            <span class="btn btn-primary btn-file">
                                Browse files ... <input type="file" name="files"/>
                            </span>
                        </span>
                        <input type="text" style="display:inline-block;width:200px;color:#555" class="form-control" readonly />
                    </div>
                    <br/>
                </td>
            </tr>
        </table>
    </div>

    <input class="btn btn-default btn-primary" type="submit" value="Upload student list and go to step 3: map student fields" style='margin:0 20px'/>

</form>


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
