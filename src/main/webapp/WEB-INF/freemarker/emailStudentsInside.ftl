<div id='topBar' class='topPanel' style='top:50px'>
    <span style='font-weight:bold;float:left;margin:10px;color:#043B4E'>
        <a style='color:white;text-decoration: underline' href="${baseUrl}/user/">Home</a> >
        <a style='color:white;text-decoration: underline' href="${baseUrl}/user/">View ${ICN}
            (${paper.code!}  ${paper.name!} ${paper.year!} ${paper.semester!})</a> >
        Email students
    </span>

    <button type="button" class="btn btn-default btn-primary sendEmail"
            style='float:right;border-radius:0;padding:10px 10px 9px;border-left:1px solid #043B4E'>Send to students
    </button>
    <button type="button" id='previewEmail' class="btn btn-default btn-primary"
            style='float:right;border-radius:0;padding:10px 10px 9px;border-left:1px solid #043B4E'>Preview email
    </button>
</div>


<div style='position:absolute;left:0;right:0;bottom:0;top:90px;overflow: hidden'>
    <div class="gridster">
        <ul>
            <li class='sres_panel' data-row="1" data-col="1" data-sizex="1" data-sizey="2">
                <h4 style='cursor:default;margin:0;padding:10px;background:#043B4E'>Students <span
                        class='totalStudents'>${users?size}</span> / ${users?size}</h4>

                <div style='position:absolute;top:40px;bottom:0;left:0;right:0;overflow-y:scroll'>
                    <table style='width:100%'>
                    <#list users as u>
                        <tr>
                            <td style='padding:5px'>
                                <input id="user_${u._id}" type="checkbox" name="usernames" value="${u._id}"
                                       checked="checked"/>
                            </td>
                            <td>
                                <#if email.emailField?has_content>
                                ${u.userInfo[email.emailField]}
                                </#if>
                            <#list u.userInfo?keys as k>
                                <#if !email.emailField?has_content || (email.emailField != k)>
                                ${u.userInfo[k]}
                                </#if>
                            </#list>
                            </td>

                        </tr>
                    </#list>
                    </table>
                </div>
            </li>

            <li class='sres_panel' data-row="3" data-col="1" data-sizex="1" data-sizey="1">
                <h4 style='cursor:default;margin:0;padding:10px;background:#043B4E'>Student fields shortcodes</h4>

                <div style='position: absolute;top:40px;bottom:0;left:0;right:0;overflow-y:scroll'>
                    <table style='width:100%'>
                        <#list studentFields as f>
                            <tr>
                                <td style='padding:5px 5px 0'>
                                    <div class='input-group input-group1' style="width:100%">
                                        <span class='input-group-addon sres_name shortcode_name' style='width:35%'>${f}:</span>
                                        <input type="text" class="form-control shortcode" value="{{student.${f}}}"/>
                                    </div>
                                </td>
                            </tr>
                        </#list>
                    </table>
                </div>
            </li>

            <li class='sres_panel' data-row="4" data-col="1" data-sizex="1" data-sizey="1">
                <h4 style='cursor:default;margin:0;padding:10px;background:#043B4E'>Column shortcodes</h4>

                <div style='position: absolute;top:40px;bottom:0;left:0;right:0;overflow-y:scroll'>
                    <table style='width:100%'>
                        <#list columns as c>
                            <tr>
                                <td style='padding:5px 5px 0'>
                                    <div class='input-group input-group1' style="width:100%">
                                                <span class='input-group-addon sres_name shortcode_name'
                                                      style='width:35%'>${c.name!}:</span>
                                        <input type="text" class="form-control shortcode" value="{{data.${c._id}}}"/>
                                    </div>
                                </td>
                            </tr>
                        </#list>
                    </table>
                </div>
            </li>

            <li class='sres_panel' data-row="1" data-col="2" data-sizex="2" data-sizey="4">
                <h4 style='margin:0;padding:10px;background:#043B4E;cursor:default'>Email panel</h4>

                <div style='padding:20px;overflow-y:scroll;position:absolute;top:40px;bottom:0;left:0;right:0'>
                    <div class='info_text' style="margin:0 0 20px">
                        Construct your email to students here. First select the user field that SRES should use to email
                        the students.
                    </div>

                    <table style='width:100%'>
                        <tr>
                            <td style='padding:0 0 20px 0'>
                                <div class='input-group input-group1'>
                                    <span class='input-group-addon sres_name'>Student email field:</span>
                                    <select class='form-control' name="emailField"
                                            <#if email.emailField?has_content>data-value="${email.emailField}"</#if>>
                                    <#list studentFields as f>
                                        <option value="${f}">${f}</option>
                                    </#list>
                                    </select>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <div class='input-group input-group1'>
                                    <span class='input-group-addon sres_name'>Subject:</span>
                                    <input style='width:100%' type="text" name="subject" class="form-control"
                                           value="${email.subject!}" data-value="${email.subject!}"/>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <th style='padding-top:20px'><h4 style="margin: 0;padding-bottom: 5px;cursor:default;">
                                Introductory paragraph (for <span class='totalStudents'>${users?size}</span> students)
                            </h4></th>
                        </tr>
                        <tr>
                            <td style='padding:10px 0' id="introEditor">
                            </td>
                        </tr>
                        <tr id='addParagraphs'>
                            <td style='padding:0'>
                                <table width='100%'>
                                    <tr>
                                        <td colspan='5' style="vertical-align:bottom;position:relative">
                                            <h4 style='cursor:default;position: absolute;bottom:10px'>
                                            Additional/conditional paragraphs</h4>

                                            <div id='paperMenu'
                                                 style='float:right;margin:10px 0;font-size:20px;border-radius:0'
                                                 class='btn btn-default btn-primary'><span class='fa fa-plus'></span>
                                            </div>
                                            <div class='paper_buttons'
                                                 style='z-index:1000;margin-left:20px;display:none;position:absolute;top:50px;right:0;background:white;color:#0886AF'>
                                                <div class='menuButton addAdditional'>
                                                    <div class='conditional1 layout'></div>
                                                    <div style='float:left;margin-left:5px'>Add additional paragraph
                                                    </div>
                                                    <div style='clear:both'></div>
                                                </div>
                                                <div class='menuButton addConditional'>
                                                    <div class='conditional2 layout'></div>
                                                    <div style='float:left;margin-left:5px'>Add conditional paragraph
                                                    </div>
                                                    <div style='clear:both'></div>
                                                </div>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr id='additionalParagraphs'></tr>
                                </table>
                            </td>
                        </tr>
                        <tr id='concludingParagraph'>
                            <th style='padding-top:20px'><h4 style="margin: 0;padding-bottom: 5px;cursor:default;">
                                Concluding paragraph (for <span class='totalStudents'>${users?size}</span> students)
                            </h4></th>
                        </tr>
                        <tr>
                            <td style='padding:10px 0' id="concludingEditor">

                            </td>
                        </tr>
                    </table>
                </div>
            </li>
        </ul>
    </div>
</div>


<div id="elementTemplate" style="display: none">
    <div class='quill-toolbar'>
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
    <div class='quill-field'>
    </div>

    <table class="additionalParagraphTemplate">
        <tr class='paragraph paragraph_{num}'>
            <th colspan='5' style='background:#0886AF'>
                <h4 style='cursor:default;padding:10px;margin:0'>
                    Additional paragraph
                    (for <span class='totalStudents'>{totalStudents}</span> students)
                    <span style='cursor:pointer;float:right' class='fa fa-times removeParagraph'
                          data-num='{num}'></span></h4>
            </th>
        </tr>
        <tr class='paragraph_{num}'>
            <td colspan='5' class="inputArea"
                style='border-left:1px solid #0886AF;border-right:1px solid #0886AF;border-bottom:1px solid #0886AF;padding:0'>

            </td>
        </tr>

    </table>

    <table class="conditionalParagraphTemplate">

        <tr class='paragraph paragraph_{num}'>
            <th style='border-left:1px solid #AF0808;border-right:1px solid #AF0808;background:#AF0808' colspan='5'>
                <h4 style='cursor:default;padding:10px;margin:0'>
                    Conditional paragraph
                    (for <span class='conditionalStudentCount'>0</span> students)
                    <span style='cursor:pointer;float:right' class='fa fa-times removeParagraph'
                          data-num='{num}'></span>
                </h4>
            </th>
        </tr>
        <tr class='paragraph_{num}'>
            <td class='input-group-addon'
                style='border-radius:0;border-left:1px solid #AF0808;text-align:center;border-right:1px solid #043B4E;width:5%;'>
                if
            </td>
            <td style='padding:0;width:30%'>
                <select style='float:left;border-radius:0;width:100%;border: none;border-right: 1px solid #043B4E;'
                        name='conditionalColref' class='conditionalElement form-control'>
                <#list columns as c>
                    <option value='${c._id}'>${c.name?js_string}</option>
                </#list>
                </select>
            </td>
            <td style='width:30%;'>
                <select style='float:left;border-radius:0;width:100%;border: none;border-right: 1px solid #043B4E;'
                        name='conditionalOperator' class='conditionalElement form-control'>
                    <option value='$eq'>equal to</option>
                    <option value='$lt'>less than</option>
                    <option value='$lte'>less than or equal to</option>
                    <option value='$gt'>greater than</option>
                    <option value='$gte'>greater than or equal to</option>
                    <option value='$ne'>not equal to</option>
                </select>
            </td>
            <td style='width:30%;padding:0'>
                <input type='text' name='conditionalValue' class='conditionalElement form-control'
                       placeholder='enter a value here, e.g. 10'
                       style='float:left;border-radius:0;width:100%;border: none;border-right: 1px solid #043B4E;'/>
            </td>
            <td class='input-group-addon'
                style='border-right:1px solid #AF0808;text-align:center;width:5%;border-radius:0'>then
            </td>
        </tr>
        <tr class='paragraph_{num}'>
            <td colspan='5' class="inputArea"
                style='border-left:1px solid #AF0808;border-right:1px solid #AF0808;border-bottom:1px solid #AF0808;padding:0'>

            </td>
        </tr>
    </table>

</div>

<script type="text/javascript">
$(function () {

    var quillToolbar = $('#elementTemplate').find('.quill-toolbar');
    var quillField = $('#elementTemplate').find('.quill-field');
    var additionalParagraph = $('#elementTemplate').find('.additionalParagraphTemplate');
    var conditionalParagraph = $('#elementTemplate').find('.conditionalParagraphTemplate');

    addQuillEditor($('td#introEditor'), 'intro-toolbar', 'introductoryParagraph');
    addQuillEditor($('td#concludingEditor'), 'concluding-toolbar', 'concludingParagraph');

    function addQuillEditor(container, toolbarId, fieldId) {
        console.log('add quill editor', toolbarId, fieldId);
        container.append(quillToolbar.clone());
        container.append(quillField.clone());
        $('.quill-toolbar', container).attr('id', toolbarId);
        $('.quill-field', container)
                .attr('id', fieldId)
                .addClass("quillField")
                .data('toolbar', toolbarId);
    }

    var configs = {
        theme: 'snow',
        pollInterval: 500
    };

    var editorArray = [];

    $('.quillField').each(function () {
        var self = $(this);
        var tb = "#" + self.data("toolbar");
        var quill = new Quill(self[0], configs);
        quill.addModule('toolbar', {
            container: tb
        });
    <#if (email.introductoryParagraph)?has_content>
        if (self.attr('id') == 'introductoryParagraph')
            quill.setHTML("${email.introductoryParagraph?j_string}");
    </#if>
    <#if (email.concludingParagraph)?has_content>
        if (self.attr('id') == 'concludingParagraph')
            quill.setHTML("${email.concludingParagraph?j_string}");
    </#if>
        quill.on('text-change', function (delta, source) {
            console.log('text change', quill, quill.container.id);
            var fieldName = quill.container.id;
            var value = quill.getHTML();
            $.post("${baseUrl}/user/saveEmail",
                    {emailId: '${email._id}', name: fieldName, value: value},
                    function (json) {
                        if (json.success) {
                            console.log("update field", fieldName, "successfully.");
                        }
                    });
        });
        editorArray.push(quill);
    });

    $('.shortcode').on('keydown', function () {
        return false;
    });

    $('.shortcode').on('click', function () {
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

    $('.shortcode_name').each(function () {
        var self = $(this);
        if (self.find("input").length == 0) {
            var text = self.text();
            self.shortText(text, 20);
        }
    });

    $('#previewEmail').on('click', function (e) {
        var options = "height=600, location=no, menubar=no, toolbar=no, width=600";
        var myWindow = window.open("${baseUrl}/user/emailPreview?emailId=${email._id}", "Email preview", options);
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

    var numRegEx = new RegExp('{num}', 'g');

    var totalStudents = ${users?size};

    $('.addAdditional').on('click', function () {
        console.log('additional', additionalParagraph);
        var num = $('.paragraph').length;
        // var newParagraph = "<tr class='paragraph paragraph_" + num + "'><th colspan='5' style='background:#0886AF'><h4 style='cursor:default;padding:10px;margin:0'>Additional paragraph (for <span class='totalStudents'>" + totalStudents + "</span> students) <span style='cursor:pointer;float:right' class='fa fa-times removeParagraph' data-num='" + num + "'></span></h4></th></tr><tr class='paragraph paragraph_" + num + "'><td colspan='5' style='border-left:1px solid #0886AF;border-right:1px solid #0886AF;border-bottom:1px solid #0886AF;padding:0'><textarea style='border-radius:0;min-height:100px' placeholder='Add some text to include in the email for all students' class='form-control'></textarea></td></tr>";
        var html = additionalParagraph.html();
        console.log('html', html);
        html = html.replace(numRegEx, num);
        html = html.replace('{totalStudents}', totalStudents);
        console.log('html', html);
        var newParagraph = $(html).find('tr');
        var td = $('td.inputArea', newParagraph);
        td.attr('id', '__paragraph_' + num);
        addQuillEditor(td, '__toolbar_'+num, '__filed_' + num);

        $('#additionalParagraphs').before(newParagraph);
        var self = $('#__filed_' + num);
        var tb = "#" + self.data("toolbar");
        var quill = new Quill(self[0], configs);
        quill.addModule('toolbar', {
            container: tb
        });
        // TODO: add paragraph to db
    });


    $('.addConditional').on('click', function () {
        console.log('conditional', conditionalParagraph);
        var num = $('.paragraph').length;
        <#--
        var newParagraph = "<tr class='paragraph paragraph_" + num + "'><th style='border-left:1px solid #AF0808;border-right:1px solid #AF0808;background:#AF0808' colspan='5'><h4 style='cursor:default;padding:10px;margin:0'>Conditional paragraph (for <span class='conditionalStudentCount'>0</span> students) <span style='cursor:pointer;float:right' class='fa fa-times removeParagraph' data-num='" + num + "'></span></h4></th></tr><tr class='paragraph_" + num + "' ><td class='input-group-addon' style='border-radius:0;border-left:1px solid #AF0808;text-align:center;border-right:1px solid #043B4E;width:5%;'>if</td><td style='padding:0;width:30%'><select style='float:left;border-radius:0;width:100%;border: none;border-right: 1px solid #043B4E;' name='conditionalColref' class='conditionalElement form-control'>"
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

        -->
        var html = conditionalParagraph.html();
        console.log('html', html);
        html = html.replace(numRegEx, num);
        html = html.replace('{totalStudents}', totalStudents);
        console.log('html', html);
        var newParagraph = $(html).find('tr');
        var td = $('td.inputArea', newParagraph);
        td.attr('id', '__paragraph_' + num);
        addQuillEditor(td, '__toolbar_'+num, '__filed_' + num);

        $('#additionalParagraphs').before(newParagraph);
        var self = $('#__filed_' + num);
        var tb = "#" + self.data("toolbar");
        var quill = new Quill(self[0], configs);
        quill.addModule('toolbar', {
            container: tb
        });

    });

    $('input[name=usernames]').on('click', function () {
        var self = $(this);
        $.post('${baseUrl}/user/addRemoveUser',
                {emailId: '${email._id}', userId: self.val(), remove: !self.is(":checked")},
                function (json) {
                    totalStudents = $('input[name=usernames]:checked').length;
                    $('.totalStudents').text(totalStudents);
                });
    });

    $(document).on('change', '.conditionalElement', function () {
        var self = $(this);
        var parent = self.parents('tr:first');
        var colref = $("select[name=conditionalColref]", parent).find("option:selected").val();
        var operator = $("select[name=conditionalOperator]", parent).find("option:selected").val();
        var value = $("input[name=conditionalValue]", parent).val();

        $.post("${baseUrl}/user/runConditional",
                {colref: colref, operator: operator, value: value},
                function (result) {
                    parent.data(result);
                    var classes = parent.attr("class");
                    $('.' + classes).find('.conditionalStudentCount').text(result.length);
                });
    });

    $(document).on('click', '.removeParagraph', function () {
        var self = $(this);
        var num = self.data('num');
        $('tr.paragraph_' + num).remove();
    });

    // set email field if available
    var emailField = $('[name=emailField]');
    if (emailField.data('value')) {
        emailField.val(emailField.data('value'));
    }

    $('[name=emailField]').on("change", function () {
        var slf = $(this);
        var fieldName = slf[0].name;
        var oldValue = slf.data("value");
        var newValue = slf.val();
        if (oldValue != newValue) {
            $.post("${baseUrl}/user/saveEmail",
                    {emailId: '${email._id}', name: fieldName, value: newValue },
                    function (json) {
                        if (json.success) {
                            console.log("update field", fieldName, "successfully.");
                            slf.data("value", newValue);
                        }
                    });
        }
    });

    $('[name=subject]').on("blur", function () {
        var slf = $(this);
        var fieldName = slf[0].name;
        var oldValue = slf.data("value");
        var newValue = slf.val();
        if (oldValue != newValue) {
            $.post("${baseUrl}/user/saveEmail",
                    {emailId: '${email._id}', name: fieldName, value: newValue },
                    function (json) {
                        if (json.success) {
                            console.log("update field", fieldName, "successfully.");
                            slf.data("value", newValue);
                        }
                    });
        }
    });


    $('button.sendEmail').on('click', function () {
        console.log("sending email");
        $.post("${baseUrl}/user/sendEmails",
                {emailId: '${email._id}'},
                function (json) {
                    if (json.success) {
                        console.log("Emails sent.");

                    }
                });
    });

    <#if email.uncheckedList?has_content>
        <#list email.uncheckedList as u>
        console.log('set checked to false', $('#user_${u}'));
             $('#user_${u}').next().click();
        </#list>
    </#if>

});
</script>