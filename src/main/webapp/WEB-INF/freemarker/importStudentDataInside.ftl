<span style='font-weight:bold;float:left;margin:0 10px;color:#0886AF'>
        <a style='color:white;text-decoration: underline' href="${baseUrl}/user/">Home</a> >
        <a style='color:white;text-decoration: underline' href="${baseUrl}/user/editPaper/${id}">Add ${ICN} information</a> >
        <a style='color:white;text-decoration: underline' href="${baseUrl}/user/addStudentList/${id}">Add student list</a> >
        <a style='color:white;text-decoration: underline' href="${baseUrl}/user/mapFields/${id}">Map student fields</a> >
        Import student data
    </span>
<div style='clear:both'></div>

<@showProgress 4 5/>

<form name="importStudentData" method="post" action="${baseUrl}/user/importStudentData" enctype="multipart/form-data">

<h1 style='margin:0 20px'>Step 4: import student data
    <button type="submit" class="btn btn-default btn-primary" style='float:right;border-radius:0;padding:10px 10px 9px;'>Next step <span class='fa fa-caret-right'></span></button>
    <a href="${baseUrl}/user/mapFields/${id}" class="btn btn-default btn-primary" style='float:right;border-radius:0;padding:10px 10px 9px;margin-right:20px'><span class='fa fa-caret-left'></span> Previous step</a>
</h1>

<div class='info_text'>Upload a file of student data for this ${ICN}. SRES only accepts student data in CSV (comma separated value) format. Your CSV file must contain a unique identifier for each student (e.g. a username or student ID).
    You will be asked to specify which fields you want to import into SRES in the next step.</div>

    <div class="box info_text" style='margin:20px;padding:0'>

        <h4 style='margin:0 0 20px;padding:10px;background:#043B4E;'>Upload student data</h4>

        <input type="hidden" name="id" value="${id}"/>
        <table style='width:100%'>
            <tr>
                <td style='padding:0 20px 20px'>
                    <div class="input-group enrolment" id='input-group'>
                        <span class="input-group-btn">
                            <span class="btn btn-primary btn-file">
                                Browse files ... <input type="file" name="files" id="timetabling_enrolment_list_file"/>
                            </span>
                        </span>
                        <input type="text" style="display:inline-block;color:#555;width:50%" class="form-control" readonly />
                    </div>
                </td>
            </tr>
        </table>
</div>

</form>





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

        var top = $('.box').offset().top;
        var height = $(window).height();
        var newHeight = height - top - (20);
        $('.box').css("height",newHeight+"px");
    });
</script>