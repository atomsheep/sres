<span style='font-weight:bold;float:left;margin:0 10px;color:#0886AF'>
        <a style='color:white;text-decoration: underline' href="${baseUrl}/user/">Home</a> >
        <a style='color:white;text-decoration: underline' href="${baseUrl}/user/addPaper">Add ${ICN} information</a> >
        Add student list
    </span>
<div style='clear:both'></div>
<@showProgress 2 5/>

<h1 style='margin:0 20px'>Step 2: add student list</h1>

<div class='info_text'>Upload a list of students for this ${ICN}. SRES only accepts student lists in CSV (comma separated value) format. Your CSV file must contain a unique identifier for each student (e.g. a username or student ID).
    You will be asked to specify which fields you want to import into SRES in the next step.</div>

<form name="editStudentList" id="editStudentList" method="post" action="${baseUrl}/user/addStudentList" enctype="multipart/form-data" onSubmit="">

    <div class="box info_text" style='margin:20px;padding:0'>

        <h4 style='margin:0 0 20px;padding:10px;background:#043B4E;'>Upload student list</h4>
        <input type="hidden" name="id" value="${id}"/>
        <table style='width:100%'>
            <tr>
                <td style='padding:0 20px 20px'>
                    <div class="input-group enrolment" id='input-group'>
                        <span class="input-group-btn">
                            <span class="btn btn-primary btn-file">
                                Browse files ... <input type="file" name="files"/>
                            </span>
                        </span>
                        <input type="text" style="display:inline-block;color:#555;width:50%" class="form-control" readonly />
                    </div>
                    <br/>
                </td>
            </tr>
        </table>
    </div>


    <div class='bottomPanel'>
        <button type="button" class="btn btn-default btn-primary" style='float:left;border-radius:0;padding:10px 10px 9px;border-right:1px solid #043B4E'><span class='fa fa-caret-left'></span> Go back to step 1: add paper information</button>
        <button type="submit" class="btn btn-default btn-primary" style='float:right;border-radius:0;padding:10px 10px 9px;border-left:1px solid #043B4E'>Upload student list and go to step 3: map student fields <span class='fa fa-caret-right'></span></button>
    </div>

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

        var top = $('.box').offset().top;
        var height = $(window).height();
        var newHeight = height - top - (40+20);
        $('.box').css("height",newHeight+"px");
    });
</script>
