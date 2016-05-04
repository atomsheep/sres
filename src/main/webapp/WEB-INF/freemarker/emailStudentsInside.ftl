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
                <div style='position:absolute;top:40px;bottom:0;left:0;right:0;overflow-y:scroll'>
                <table style='width:100%'>
                <#list users as u>
                    <tr>
                        <td style='padding:5px'>
                            <input id="user_${u._id}" type="checkbox" name="usernames" value="${u._id}" checked="checked"/>
                        </td>
                        <#list u.userInfo?keys as k>
                            <td>
                                ${u.userInfo[k]}
                            </td>
                        </#list>
                    </tr>
                </#list>
                </table>
                </div>
            </li>

            <li class='sres_panel' data-row="3" data-col="1" data-sizex="1" data-sizey="1">
                <h4 style='cursor:default;margin:0;padding:10px;background:#043B4E'>Attribute shortcodes</h4>
                <div style='position: absolute;top:40px;bottom:0;left:0;right:0;overflow-y:scroll'>
                <table style='width:100%'>
                    <#list studentFields as f>
                        <tr>
                            <td style='padding:5px 5px 0'>
                                <div class='input-group input-group1' style="width:100%">
                                    <span class='input-group-addon sres_name shortcode_name' style='width:35%'>${f}:</span>
                                    <input type="text" class="form-control shortcode" value="{{user.${f}}}"/>
                                </div>
                            </td>
                        </tr>
                    </#list>
                    <#list columns as c>
                        <tr>
                            <td style='padding:5px 5px 0'>
                                <div class='input-group input-group1' style="width:100%">
                                    <span class='input-group-addon sres_name shortcode_name' style='width:35%'>${c.name!}:</span>
                                    <input type="text" class="form-control shortcode" value="{{data.${c._id}}}"/>
                                </div>
                            </td>
                        </tr>
                    </#list>
                </table>
                </div>
            </li>

            <li class='sres_panel' data-row="4" data-col="1" data-sizex="1" data-sizey="1">
                <h4 style='cursor:default;margin:0;padding:10px;background:#043B4E'>Something else</h4>
                Third
            </li>

            <li class='sres_panel' data-row="1" data-col="2" data-sizex="2" data-sizey="4">
                <h4 style='margin:0;padding:10px;background:#043B4E;cursor:default'>Email panel</h4>
                <div style='padding:20px;overflow-y:scroll;position:absolute;top:40px;bottom:0;left:0;right:0'>
                    <div class='info_text' style="margin:0 0 20px">
                        Construct your email to students here. First select the user field that SRES should use to email the students.
                    </div>
                    <table style='width:100%'>
                        <tr>
                            <td style='padding:0 0 20px 0'>
                                <div class='input-group input-group1'>
                                    <span class='input-group-addon sres_name'>Student email field:</span>
                                    <select class='form-control'>
                                        <#list studentFields as f>
                                            <option>${f}</option>
                                        </#list>
                                    </select>
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
                            <th style='padding-top:20px'><h4 style="margin: 0;padding-bottom: 5px;cursor:default;">Introductory paragraph (for <span class='totalStudents'>${users?size}</span> students)</h4></th>
                        </tr>
                        <tr>
                            <td style='padding:10px 0'>
                                <div id="intro-toolbar" class='quill-toolbar'>
                                    <div class="ql-format-group">
                                        <button class="btn btn-quill ql-bold ql-format-button"></button>
                                        <span class="ql-format-separator"></span>
                                        <button class="btn btn-quill ql-italic ql-format-button"></button>
                                        <span class="ql-format-separator"></span>
                                        <button class="btn btn-quill ql-underline ql-format-button"></button>
                                    </div>
                                    <div class="ql-format-group">
                                        <button title="Link" class="btn btn-quill ql-format-button ql-list"></button>
                                        <span class="ql-format-separator"></span>
                                        <button title="Link" class="btn btn-quill ql-format-button ql-bullet"></button>
                                        <span class="ql-format-separator"></span>
                                        <select title="Text Alignment" class="ql-align">
                                            <option value="left" label="Left" selected=""></option>
                                            <option value="center" label="Center"></option>
                                            <option value="right" label="Right"></option>
                                            <option value="justify" label="Justify"></option>
                                        </select>
                                    </div>
                                    <div class="ql-format-group">
                                        <button title="Link" class="btn btn-quill ql-format-button ql-link"></button>
                                    </div>
                                </div>
                                <div id="introductoryParagraphEditor" class='quillField' data-toolbar='intro-toolbar'>
                                    <div></div>
                                </div>
                            </td>
                        </tr>
                        <tr id='addParagraphs'>
                            <td style='padding:0'>
                                <table width='100%'>
                                    <tr>
                                        <td colspan='5' style="vertical-align:bottom;position:relative"><h4 style='cursor:default;position: absolute;bottom:10px'>Additional/conditional paragraphs</h4>
                                            <div id='paperMenu' style='float:right;margin:10px 0;font-size:20px;border-radius:0' class='btn btn-default btn-primary'><span class='fa fa-plus'></span></div>
                                            <div class='paper_buttons' style='z-index:1000;margin-left:20px;display:none;position:absolute;top:50px;right:0;background:white;color:#0886AF'>
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
                            <th style='padding-top:20px'><h4 style="margin: 0;padding-bottom: 5px;cursor:default;">Concluding paragraph (for <span class='totalStudents'>${users?size}</span> students)</h4></th>
                        </tr>
                        <tr>
                            <td style='padding:10px 0'>
                                <div id="concluding-toolbar" class='quill-toolbar'>
                                    <div class="ql-format-group">
                                        <button class="btn btn-quill ql-bold ql-format-button"></button>
                                        <span class="ql-format-separator"></span>
                                        <button class="btn btn-quill ql-italic ql-format-button"></button>
                                        <span class="ql-format-separator"></span>
                                        <button class="btn btn-quill ql-underline ql-format-button"></button>
                                    </div>
                                    <div class="ql-format-group">
                                        <button title="Link" class="btn btn-quill ql-format-button ql-list"></button>
                                        <span class="ql-format-separator"></span>
                                        <button title="Link" class="btn btn-quill ql-format-button ql-bullet"></button>
                                        <span class="ql-format-separator"></span>
                                        <select title="Text Alignment" class="ql-align">
                                            <option value="left" label="Left" selected=""></option>
                                            <option value="center" label="Center"></option>
                                            <option value="right" label="Right"></option>
                                            <option value="justify" label="Justify"></option>
                                        </select>
                                    </div>
                                    <div class="ql-format-group">
                                        <button title="Link" class="btn btn-quill ql-format-button ql-link"></button>
                                    </div>
                                </div>
                                <div id="concludingParagraphEditor" class='quillField' data-toolbar='concluding-toolbar'>
                                    <div></div>
                                </div>
                            </td>
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

        var configs = {
            theme: 'snow'
        };

        var editorArray = [];

        $('.quillField').each(function(){
            var self = $(this);
            var tb = "#"+self.data("toolbar");
            var quill = new Quill(self[0],configs);
            quill.addModule('toolbar',{
                container : tb
            });
            editorArray.push(quill);
        });

        $('.shortcode').on('keydown', function(){
            return false;
        });

        $('.shortcode').on('click', function(){
            $(this).select();
        });

        $('input[type=checkbox]').each(function (i, e) {
            var self = $(this);
            var newCheckbox = "";
            if (self.is(":checked")) {
                newCheckbox = "<span class='sres_checkbox fa fa-check-circle'></span>";
            } else {
                newCheckbox = "<span class='sres_checkbox fa fa-circle-thin'></span>";
            }
            self.after(newCheckbox);
            self.css('display', 'none');
        });

        $(document).on('click', '.sres_checkbox', function () {
            var self = $(this);
            if (self.hasClass('fa-check-circle')) {
                self.removeClass('fa-check-circle').addClass('fa-circle-thin');
            } else {
                self.addClass('fa-check-circle').removeClass('fa-circle-thin');
            }
            self.prev('input[type=checkbox]').click();
        });

        var third = 1 / 3;
        var quarter = 1 / 4;
        var gap = 10;
        var screenwidth = $(document).width() - (gap * 8);
        var firstPanelStart = 50 + $('#topBar').height() + (gap * 2);
        var screenheight = $(document).height() - firstPanelStart - (gap * 8);

        var gridster = $(".gridster ul").gridster({
            widget_margins: [gap, gap],
            widget_base_dimensions: [(screenwidth * third), (screenheight * quarter)],
            max_cols: 3,
            resize: { enabled: false }
        }).data('gridster');

        gridster.disable();

        $.fn.shortText = function (str, length) {
            var item = $(this);
            var toset = str;
            if (str.length > length)
                toset = str.substring(0, length) + '...';
            item.text(toset).attr('title', str);
        };

        $('.shortcode_name').each(function(){
            var self = $(this);
            if (self.find("input").length == 0) {
                var text = self.text();
                self.shortText(text, 20);
            }
        });

        $('#previewEmail').on('click',function(e){

            var subject = $('input[name=subject]').val();
            /*var val = $('textarea[name=body]').val().replace(/(?:\r\n|\r|\n)/g, '<br />');
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
            return false;     */
            var body = subject + "<br/><br/>";

            $.each(editorArray, function(i,e){
                body += e.getHTML();
                body += "<br/>";
            });

            var myWindow = window.open("","Email preview","width=500");
            myWindow.document.write(body);
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
            var newParagraph = "<tr class='paragraph paragraph_" + num + "'><th colspan='5' style='background:#0886AF'><h4 style='cursor:default;padding:10px;margin:0'>Additional paragraph (for <span class='totalStudents'>" + totalStudents + "</span> students) <span style='cursor:pointer;float:right' class='fa fa-times removeParagraph' data-num='" + num + "'></span></h4></th></tr><tr class='paragraph paragraph_" + num + "'><td colspan='5' style='border-left:1px solid #0886AF;border-right:1px solid #0886AF;border-bottom:1px solid #0886AF;padding:0'><textarea style='border-radius:0;min-height:100px' placeholder='Add some text to include in the email for all students' class='form-control'></textarea></td></tr>";
            $('#additionalParagraphs').before(newParagraph);
        });

        var totalStudents = ${users?size};

        $('.addConditional').on('click', function(){
            var num = $('.paragraph').length;
            var newParagraph = "<tr class='paragraph paragraph_" + num + "'><th style='border-left:1px solid #AF0808;border-right:1px solid #AF0808;background:#AF0808' colspan='5'><h4 style='cursor:default;padding:10px;margin:0'>Conditional paragraph (for <span class='conditionalStudentCount'>0</span> students) <span style='cursor:pointer;float:right' class='fa fa-times removeParagraph' data-num='" + num + "'></span></h4></th></tr><tr class='paragraph_" + num +"' ><td class='input-group-addon' style='border-radius:0;border-left:1px solid #AF0808;text-align:center;border-right:1px solid #043B4E;width:5%;'>if</td><td style='padding:0;width:30%'><select style='float:left;border-radius:0;width:100%;border: none;border-right: 1px solid #043B4E;' name='conditionalColref' class='conditionalElement form-control'>"
                <#list columns as c>
                    + "<option value='${c._id}'>${c.name?js_string}</option>"
                </#list>
                + "</select></td>"

                + "<td style='width:30%;'><select style='float:left;border-radius:0;width:100%;border: none;border-right: 1px solid #043B4E;' name='conditionalOperator' class='conditionalElement form-control'>"
                    + "<option value='$eq'>equal to</option>"
                    + "<option value='$lt'>less than</option>"
                    + "<option value='$lte'>less than or equal to</option>"
                    + "<option value='$gt'>greater than</option>"
                    + "<option value='$gte'>greater than or equal to</option>"
                    + "<option value='$ne'>not equal to</option>"
                    + "</select></td>"

                    + "<td style='width:30%;padding:0'><input type='text' name='conditionalValue' class='conditionalElement form-control' placeholder='enter a value here, e.g. 10'  style='float:left;border-radius:0;width:100%;border: none;border-right: 1px solid #043B4E;'/>"

                    + "</td><td class='input-group-addon' style='border-right:1px solid #AF0808;text-align:center;width:5%;border-radius:0'>then</td></tr><tr class='paragraph paragraph_" + num + "'><td colspan='5' style='border-left:1px solid #AF0808;border-right:1px solid #AF0808;border-bottom:1px solid #AF0808;padding:0'><textarea style='border-radius:0;min-height:100px' class='form-control' placeholder='Add some text to include in the email to students matching the above condition'></textarea></td></tr>";
            $('#additionalParagraphs').before(newParagraph);
        });

        $('input[name=usernames]').on('click', function(){
            totalStudents = $('input[name=usernames]:checked').length;
            $('.totalStudents').text(totalStudents);
        });

        $(document).on('change','.conditionalElement',function(){
            var self = $(this);
            var parent = self.parents('tr:first');
            var colref = $("select[name=conditionalColref]",parent).find("option:selected").val();
            var operator = $("select[name=conditionalOperator]",parent).find("option:selected").val();
            var value = $("input[name=conditionalValue]",parent).val();

            $.post("${baseUrl}/user/runConditional",
                    {colref:colref, operator:operator, value:value},
            function(result){
                parent.data(result);
                var classes = parent.attr("class");
                $('.' + classes).find('.conditionalStudentCount').text(result.length);
            });
        });

        $(document).on('click','.removeParagraph',function(){
            var self = $(this);
            var num = self.data('num');
            $('tr.paragraph_'+num).remove();
        });
    });
</script>