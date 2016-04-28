<div id='topBar' class='topPanel' style='top:50px'>
    <span style='font-weight:bold;float:left;margin:10px;color:#043B4E'>
        <a style='color:white;text-decoration: underline' href="${baseUrl}/user/">Home</a> >
        <a style='color:white;text-decoration: underline' href="${baseUrl}/user/">View ${ICN} (${paper.code!}  ${paper.name!} ${paper.year!} ${paper.semester!})</a> >
        Email students
    </span>

    <button type="submit" class="btn btn-default btn-primary" style='float:right;border-radius:0;padding:10px 10px 9px;border-left:1px solid #043B4E'>Send to students</button>
    <button type="button" id='previewEmail' class="btn btn-default btn-primary" style='float:right;border-radius:0;padding:10px 10px 9px;border-left:1px solid #043B4E'>Preview email</button>
</div>


<div style='position:absolute;left:0;right:0;bottom:0;top:90px;overflow: hidden'>
    <div class="gridster">
        <ul>
            <li class='sres_panel' data-row="1" data-col="1" data-sizex="1" data-sizey="2">
                <h4 style='cursor:default;margin:0;padding:10px;background:#043B4E'>Students <span class='totalStudents'>${users?size}</span> / ${users?size}</h4>
                <table style='width:100%'>
                <#list users as u>
                    <tr>
                        <td>
                            <input id="user_${u._id}" type="checkbox" name="usernames" value="${u._id}" checked="checked"/>
                            <label for="user_${u._id}">

                                <#list u.userInfo?keys as k>
                                 ${k}: ${u.userInfo[k]}
                                </#list>
                            </label>
                        </td>
                    </tr>
                </#list>
                </table>
            </li>

            <li class='sres_panel' data-row="3" data-col="1" data-sizex="1" data-sizey="1">
                <h4 style='cursor:default;margin:0;padding:10px;background:#043B4E'>Attribute shortcodes</h4>
                Second
            </li>

            <li class='sres_panel' data-row="4" data-col="1" data-sizex="1" data-sizey="1">
                <h4 style='cursor:default;margin:0;padding:10px;background:#043B4E'>Something else</h4>
                Third
            </li>

            <li class='sres_panel' data-row="1" data-col="2" data-sizex="2" data-sizey="4">
                <h4 style='margin:0;padding:10px;background:#043B4E;cursor:default'>Email panel</h4>
                <div style='padding:20px;overflow-y:scroll;position:absolute;top:40px;bottom:0;left:0;right:0'>
                    <table style='width:100%'>
                        <tr>
                            <td style='padding:0 0 20px 0'>
                                <div class='input-group input-group1'>
                                    <span class='input-group-addon sres_name'>Email field:</span>
                                    <select class='form-control'></select>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <div class='input-group input-group1'>
                                    <span class='input-group-addon sres_name'>Subject:</span>
                                    <input style='width:100%' type="text" name="subject" class="form-control" value="<#if paper.code?has_content>[From ${paper.code}]</#if> "/>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <th style='padding-top:20px'>Introductory paragraph</th>
                        </tr>
                        <tr>
                            <td style='padding-bottom:20px'><textarea style='border-radius:0;min-height:100px' placeholder="Dear [givenNames]," name="body" class="form-control"></textarea></td>
                        </tr>
                        <tr id='addParagraphs'>
                            <td style='padding:0'>
                                <table width='100%'>
                                    <tr>
                                        <td colspan='5' style="vertical-align:bottom;position:relative"><div style='font-weight:bold;position: absolute;bottom:10px'>Additional/conditional paragraphs</div>
                                            <div id='paperMenu' style='float:right;margin:0 0 10px;font-size:20px;border-radius:0' class='btn btn-default btn-primary'><span class='fa fa-plus'></span></div>
                                            <div class='paper_buttons' style='margin-left:20px;display:none;position:absolute;top:40px;right:0;background:white;color:#0886AF'>
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
                            <td><textarea style='border-radius:0;min-height:100px' name="end" class="form-control" placeholder="Regards, [staff name]"></textarea></td>
                        </tr>
                    </table>
                </div>
            </li>
        </ul>
    </div>
</div>
<#--
<form action="${baseUrl}/user/sendEmails" method="post">
    <input type="hidden" name="id" value="${paper._id}"/>

</form>
               -->
<script type="text/javascript">
    $(function(){

        var third = 1 / 3;
        var quarter = 1 / 4;
        var gap = 10;
        var screenwidth = $(document).width() - (gap * 8);
        var firstPanelStart = 50 + $('#topBar').height() + (gap * 2);
        var screenheight = $(document).height() - firstPanelStart - (gap * 8);

        $(".gridster ul").gridster({
            widget_margins: [gap, gap],
            widget_base_dimensions: [(screenwidth * third), (screenheight * quarter)],
            max_cols: 3,
            resize: {
                enabled: false
            },
            draggable: {ignore_dragging: true}
        });

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
            var newParagraph = "<tr class='paragraph paragraph_" + num + "'><th colspan='5' style='background:#0886AF'><h4 style='padding:10px;margin:0'>Additional paragraph (for <span class='totalStudents'>" + totalStudents + "</span> students) <span style='cursor:pointer;float:right' class='fa fa-times removeParagraph' data-num='" + num + "'></span></h4></th></tr><tr class='paragraph paragraph_" + num + "'><td colspan='5' style='border-left:1px solid #0886AF;border-right:1px solid #0886AF;border-bottom:1px solid #0886AF;padding:0'><textarea style='border-radius:0;min-height:100px' placeholder='Add some text to include in the email for all students' class='form-control'></textarea></td></tr>";
            $('#additionalParagraphs').before(newParagraph);
        });

        var totalStudents = ${users?size};

        $('.addConditional').on('click', function(){
            var num = $('.paragraph').length;
            var newParagraph = "<tr class='paragraph paragraph_" + num + "'><th style='border-left:1px solid #AF0808;border-right:1px solid #AF0808;background:#AF0808' colspan='5'><h4 style='padding:10px;margin:0'>Conditional paragraph (for 0 students) <span style='cursor:pointer;float:right' class='fa fa-times removeParagraph' data-num='" + num + "'></span></h4></th></tr><tr class='paragraph_" + num +"' ><td class='input-group-addon' style='border-radius:0;border-left:1px solid #AF0808;text-align:center;border-right:1px solid #043B4E;width:5%;'>if</td><td style='padding:0;width:30%'><select style='float:left;border-radius:0;width:100%;border: none;border-right: 1px solid #043B4E;' name='colref' class='form-control'>"
                <#list columns as c>
                    + "<option value='${c._id}'>${c.name?js_string}</option>"
                </#list>
                + "</select></td>"

                + "<td style='width:30%;'><select style='float:left;border-radius:0;width:100%;border: none;border-right: 1px solid #043B4E;' name='operator' class='form-control'>"
                    + "<option value='$eq'>equal to</option>"
                    + "<option value='$lt'>less than</option>"
                    + "<option value='$lte'>less than or equal to</option>"
                    + "<option value='$gt'>greater than</option>"
                    + "<option value='$gte'>greater than or equal to</option>"
                    + "<option value='$ne'>not equal to</option>"
                    + "</select></td>"

                    + "<td style='width:30%;padding:0'><input type='text' name='value' class='form-control' placeholder='enter a value here, e.g. 10'  style='float:left;border-radius:0;width:100%;border: none;border-right: 1px solid #043B4E;'/>"

                    + "</td><td class='input-group-addon' style='border-right:1px solid #AF0808;text-align:center;width:5%;border-radius:0'>then</td></tr><tr class='paragraph paragraph_" + num + "'><td colspan='5' style='border-left:1px solid #AF0808;border-right:1px solid #AF0808;border-bottom:1px solid #AF0808;padding:0'><textarea style='border-radius:0;min-height:100px' class='form-control' placeholder='Add some text to include in the email to students matching the above condition'></textarea></td></tr>";
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