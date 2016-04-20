<form action="${baseUrl}/user/sendEmails" method="post">
    <input type="hidden" name="id" value="${paper._id}"/>

    <div id="sidePanel" style="padding:20px;color:black;width:40%;background:white;position:fixed;top:51px;left:0;bottom:0;overflow-y:scroll;overflow-x:hidden">
        <h3 style='margin-top:0'>Email <span class='totalStudents'>${users?size}</span> / ${users?size} students</h3>
        <table>
        <#list users as u>
            <tr>
                <td>
                    <input id="user_${u.username}" type="checkbox" name="usernames" value="${u.username}" checked="checked"/>
                    <label for="user_${u.username}">${u.username} (${u.givenNames} ${u.surname}) ${u.email!}</label>
                </td>
            </tr>
        </#list>
        </table>
    </div>
  <#--
    <div id="sidePanel2" style="padding:20px;color:black;width:50%;background:white;position:fixed;top:40%;left:0;bottom:0;overflow-y:scroll;overflow-x:hidden">
        <h3 style='margin-top:0'>Conditions</h3>
    </div>
      -->

    <div style='left:40%;position:absolute;top:51px;bottom:0;right:0;overflow-y:scroll;padding:20px'>
        <div>
            <span style='float:left;'><a style='text-decoration: underline' href="${baseUrl}/user/">Home</a> > <a href='${baseUrl}/user/viewPaper/${paper._id}' style='text-decoration: underline'>View paper</a> > Email students</span>

            <button type="submit" class="btn btn-default btn-primary" style='float:right'>Send to students</button>
            <button type="button" id='previewEmail' class="btn btn-default btn-primary" style='float:right;margin-right:10px'>Preview email</button>
        </div>
        <div style='padding-bottom:20px;clear:both'></div>
    <table style='width:100%'>
        <tr>
            <th style="padding-right: 10px">Subject</th>
        </tr>
        <tr>
            <td><input style='width:100%' type="text" name="subject" class="form-control" value="<#if paper.code?has_content>[From ${paper.code}]</#if> "/></td>
        </tr>
        <tr>
            <th style='padding-top:20px'>Introductory paragraph</th>
        </tr>
        <tr>
            <td style='padding-bottom:20px'><textarea placeholder="Dear [givenNames]," name="body" class="form-control"></textarea></td>
        </tr>
        <tr id='addParagraphs'>
            <td style='padding:0'>
                <table width='100%'>
                    <tr>
                        <td colspan='5' style="vertical-align:bottom;position:relative"><div style='font-weight:bold;position: absolute;bottom:10px'>Additional/conditional paragraphs</div>
                            <div id='paperMenu' style='float:right;margin:0 0 10px;font-size:20px;border-radius:0' class='btn btn-default btn-primary'><span class='fa fa-plus'></span></div>
                            <div class='paper_buttons' style='margin-left:20px;display:none;position:absolute;top:50px;right:0;background:white;color:#0886AF'>
                                <div class='menuButton addAdditional'><div class='conditional1 layout'></div> <div style='float:left;margin-left:5px'>Add additional paragraph</div><div style='clear:both'></div></div>
                                <div class='menuButton addConditional'><div class='conditional2 layout'></div> <div style='float:left;margin-left:5px'>Add conditional paragraph</div><div style='clear:both'></div></div>
                            </div>
                        </td>
                    </tr>
                    <tr id='additionalParagraphs'></tr>
                </table>
            </td>
        </tr>
        <tr id='concludingParagraph'>
            <th style='padding-top:20px'>Concluding paragraph</th>
        </tr>
        <tr>
            <td><textarea name="end" class="form-control" placeholder="Regards, [staff name]"></textarea></td>
        </tr>
    </table>
    </div>
</form>

<script type="text/javascript">
    $(function(){

        $('#previewEmail').on('click',function(e){
            var subject = $('input[name=subject]').val();
            var val = $('textarea[name=body]').val().replace(/(?:\r\n|\r|\n)/g, '<br />');
            var body = "<p>" + val + "</p>";

            $('textarea','tr.paragraph').each(function(){
                var self = $(this);
                val = self.val().replace(/(?:\r\n|\r|\n)/g, '<br />');
                body += "<p>" + val + "</p>";
            });

            val = $('textarea[name=end]').val().replace(/(?:\r\n|\r|\n)/g, '<br />');
            body += "<p>" + val + "</p>";

            var myWindow = window.open("","Email preview","width=500");
            myWindow.document.write(subject + "<br/><br/>");
            myWindow.document.write(body);
            return false;
        });

        var $paperButtons = $('.paper_buttons');
        $('html').on('click', function () {
            if ($paperButtons.is(":visible"))
                $paperButtons.hide();
        });

        $('#paperMenu').on('click', function (event) {
            if ($paperButtons.is(':hidden'))
                $paperButtons.show();
            else
                $paperButtons.hide();
            event.stopPropagation();
        });

        $('.addAdditional').on('click', function(){
            var num = $('.paragraph').length;
            var newParagraph = "<tr class='paragraph paragraph_" + num + "'><th colspan='5' style='padding:10px;background:#0886AF'>Additional paragraph (for <span class='totalStudents'>" + totalStudents + "</span> students) <span style='cursor:pointer;float:right' class='fa fa-times removeParagraph' data-num='" + num + "'></span></th></tr><tr class='paragraph paragraph_" + num + "'><td colspan='5' style='background:#0886AF;padding:0 10px 10px'><textarea placeholder='Add some text to include in the email for all students' class='form-control'></textarea></td></tr>";
            $('#additionalParagraphs').before(newParagraph);
        });

        var totalStudents = ${users?size};

        $('.addConditional').on('click', function(){
            var num = $('.paragraph').length;
            var newParagraph = "<tr class='paragraph paragraph_" + num + "'><th style='padding:10px;background:#AF0808' colspan='5'>Conditional paragraph (for 0 students) <span style='cursor:pointer;float:right' class='fa fa-times removeParagraph' data-num='" + num + "'></span></th></tr><tr class='paragraph_" + num +"' ><td style='background:#AF0808;text-align:center;padding:0 10px 10px ;width:5%;font-weight:bold;font-style:italic'>if</td><td style='background:#AF0808;padding:0 10px 10px 0;width:30%'><select style='width:100%' name='colref' class='form-control'>"
                <#list columns as c>
                    + "<option value='${c._id}'>${c.name?js_string}</option>"
                </#list>
                + "</select></td>"

                + "<td style='background:#AF0808;width:30%;padding:0 10px 10px 0'><select style='width:100%' name='operator' class='form-control'>"
                    + "<option value='$eq'>equal to</option>"
                    + "<option value='$lt'>less than</option>"
                    + "<option value='$lte'>less than or equal to</option>"
                    + "<option value='$gt'>greater than</option>"
                    + "<option value='$gte'>greater than or equal to</option>"
                    + "<option value='$ne'>not equal to</option>"
                    + "</select></td>"

                    + "<td style='background:#AF0808;width:30%;padding:0 10px 10px 0'><input type='text' name='value' class='form-control' style='width: 100%'/>"

                    + "</td><td style='background:#AF0808;text-align:center;width:5%;padding:0 10px 10px 0;font-weight:bold;font-style:italic'>then</td></tr><tr class='paragraph paragraph_" + num + "'><td colspan='5' style='background:#AF0808;padding:0 10px 10px'><textarea class='form-control' placeholder='Add some text to include in the email to students matching the above condition'></textarea></td></tr>";
            $('#additionalParagraphs').before(newParagraph);
        });

        $('input[name=usernames]').on('click', function(){
            totalStudents = $('input[name=usernames]:checked').length;
            $('.totalStudents').text(totalStudents);
        });

        $(document).on('click','.removeParagraph',function(){
            var self = $(this);
            var num = self.data('num');
            $('tr.paragraph_'+num).remove();
        });
    });
</script>