<#assign tabs = [ICN_C + " info", "Student list", "Student data" ] />

<div style="margin-left:50px">
    <a href="${baseUrl}/user"><div style="background:#333;color:white" class="top_tab" data-tab="back"><div class="iris-left button_icon" style="margin-left:-5px;padding-top:5px"></div> Back</div></a>
<#list tabs as t>
    <div class="top_tab <#if t_index == 0>active</#if>" data-tab="${t_index}">${t}</div>
</#list>
    <div style="clear:both"></div>
</div>
<ul id="lightSlider" style="">
    <li class="slide">
        <div class="slideInner">
            <form name="editPaperForm" method="post" action="${baseUrl}/user/savePaper">
                <#if (paper._id)?has_content>
                    <input type="hidden" name="_id" value="${paper._id}"/>
                </#if>
                    <input type="hidden" name="size" value="0"/>

                <h2 style="color:#b19209">Basic info</h2>
                <div class="search_bar">
                    <div class="iris-edit text-icon"></div>
                    <input name="name" id="name" value="${(paper.name)!}" size="40" required type="text" class="iris-input" placeholder="${ICN_C} name"/>
                    <div style="clear:both"></div>
                </div>

                <div class="search_bar" style="width:calc(34% - 20px);float:left">
                    <div class="iris-edit text-icon"></div>
                    <input name="code" id="code" value="${(paper.code)!}" size="40" required type="text" class="iris-input" placeholder="${ICN_C} code"/>
                    <div style="clear:both"></div>
                </div>

                <div class="search_bar" style="width:calc(33% - 10px);margin-left:20px;float:left">
                    <div class="iris-edit text-icon"></div>
                    <input name="year" id="year" type="text" class="iris-input" placeholder="Year"/>
                    <div style="clear:both"></div>
                </div>

                <div class="search_bar" style="width:calc(33% - 10px);float:right">
                    <div class="iris-edit text-icon"></div>
                    <input name="semester" id="semester" type="text" class="iris-input" placeholder="Semester"/>
                    <div style="clear:both"></div>
                </div>

                <div style="clear:both"></div>

                <div style="margin-bottom:20px;text-align:right;float:right">
                    <button class="top_buttons button_clear">
                        <div class="iris-check button_icon"></div>
                        <div class="button_text">Save paper</div>
                    </button>
                </div>
            </form>
        </div>
    </li>
    <li class="slide">
        <div class="slideInner">
            <h2 style="color:#b19209">Upload a student list (csv, tsv, excel)</h2>
            <div class="search_bar" style="width:75%;float:left">
                <div class="iris-search text-icon"></div>
                <input type="text" class="iris-input" placeholder="Choose student list file..."/>
                <div style="clear:both"></div>
            </div>
            <div style="margin-bottom:20px;text-align:right;float:right">
                <button class="top_buttons button_clear">
                    <div class="iris-upload button_icon"></div>
                    <div class="button_text">Upload file</div>
                </button>
            </div>

            <div style="clear:both"></div>
        </div>
    </li>
    <li class="slide">
        <div class="slideInner">
            <h2 style="color:#b19209">Upload a student data file (csv, tsv, excel)</h2>
            <div class="search_bar" style="width:75%;float:left">
                <div class="iris-search text-icon"></div>
                <input type="text" class="iris-input" placeholder="Choose student data file..."/>
                <div style="clear:both"></div>
            </div>
            <div style="margin-bottom:20px;text-align:right;float:right">
                <button class="top_buttons button_clear">
                    <div class="iris-upload button_icon"></div>
                    <div class="button_text">Upload file</div>
                </button>
            </div>

            <div style="clear:both"></div>
        </div>
    </li>
</ul>

<#--
<span style='font-weight:bold;float:left;margin:0 10px;color:#0886AF'>
<a style='color:white;text-decoration: underline' href="${baseUrl}/user/">Home</a> >
Edit ${ICN} information
</span>
<div style='clear:both'></div>
<@showProgress 1 5/>
<form name="editPaperForm" method="post" action="${baseUrl}/user/savePaper">
<#if (paper._id)?has_content>
    <input type="hidden" name="_id" value="${paper._id}"/>
</#if>
    <input type="hidden" name="size" value="0"/>

    <h1 style='margin:0 20px'>Step 1: edit ${ICN} information
        <button type="submit" class="btn btn-default btn-primary btn-square right">Next step <span class='fa fa-caret-right submit'></span></button>
    </h1>

    <div class='info_text'>Edit your ${ICN} information. By default, SRES requires a ${ICN} code, name, year and
        semester, but you can add extra fields if you wish to store additional information about this ${ICN}.
    </div>

    <div class="box info_text side1" style='padding:0;margin:20px 10px 20px 20px;width:calc(50% - 30px);float:left'>
        <h4 style='margin:0 0 20px;padding:10px;background:#043B4E;'>Required default ${ICN} fields</h4>
        <table style='width:100%'>
            <tr>
                <td style='padding:0 20px 5px 20px'>
                    <div class='input-group input-group1' style='width:100%'>
                        <span class='input-group-addon sres_name' style='width:150px;text-align:left'>${ICN_C} code:</span>
                        <input class='form-control' type="text" name="code" value="${(paper.code)!}" size="8"
                           style='display:inline-block;' required/>
                    </div>
                </td>
            </tr>
            <tr>
                <td style='padding:0 20px 5px 20px'>
                    <div class='input-group input-group2' style='width:100%'>
                        <span class='input-group-addon sres_name' style='width:150px;text-align:left'>${ICN_C} name:</span>
                        <input class='form-control' type="text" name="name" style='display:inline-block;'
                               value="${(paper.name)!}" size="40" required/>
                    </div>
                </td>
            </tr>
            <tr>
                <td style='padding:0 20px 5px 20px'>
                    <div class='input-group input-group3' style='width:100%'>
                        <span class='input-group-addon sres_name' style='width:150px;text-align:left'>Year:</span>
                        <input class='form-control' type="text" name="year" value="${(paper.year)!}" size="4"
                               style='display:inline-block;' required/>
                    </div>
                </td>
            </tr>
            <tr>
                <td style='padding:0 20px 0 20px'>
                    <div class='input-group input-group4' style='width:100%'>
                        <span class='input-group-addon sres_name' style='width:150px;text-align:left'>Semester:</span>
                        <input class='form-control' type="text" name="semester" value="${(paper.semester)!}"
                               style='display:inline-block;' size="2" required/>
                    </div>
                </td>
            </tr>
        </table>
    </div>

    <div class="box info_text side2" style='position:relative;padding:0;margin:20px 20px 20px 10px;width:calc(50% - 30px);float:left'>
        <h4 style='margin:0;padding:10px;background:#043B4E;'>Extra ${ICN} fields (<span class='extraFieldsSize'>0</span>)</h4>

        <div class='topPanel'>
            <div class='btn btn-default btn-primary btn-square left' id="addKeyValue">
                <span class='fa fa-plus'></span> Add new paper attribute
            </div>
        </div>

        <table style='width:100%;margin-top:60px'>
        <#if extra?has_content>
            <#list extra?keys as key>
                <tr class="extra">
                    <td style='padding:0 20px 5px 20px'>
                        <input placeholder='attribute name' class='form-control' type='text' name='key_${key_index}'
                               value='${key?html}' size='4'
                               style='width:47.5%;border-radius:0;vertical-align: top;float:left;'/>
                        <input class='form-control' type='text' name='value_${key_index}' placeholder='attribute value'
                               value='${extra[key]?html}' size='4' style='width:47.5%;border-radius:0;vertical-align: top;float:left;'/>
                        <div class='removeAttribute btn btn-default btn-danger'
                                             style='padding:0;border-radius:0;width:5%;float:right;text-align:center'><span
                                                style='padding:10px' class="fa fa-times"></span></div>
                                        <div style='clear:both'></div>
                    </td>
                </tr>

            </#list>
        </#if>
            <tr id='addNewColumnAttribute'><td></td></tr>
        </table>
    </div>

</form>

<table style='display:none'>
    <tbody id='addAttribute'>
        <tr class='extra'>
            <td style='padding:0 20px 5px 20px'>
                <input placeholder='attribute name' class='form-control' type='text' name='key_{num}' value='' size='4' style='width:47.5%;border-radius:0;vertical-align: top;float:left;' />
                <input class='form-control' type='text' name='value_{num}' placeholder='attribute value' value='' size='4' style='width:47.5%;border-radius:0;vertical-align: top;float:left;' />
                <div class='removeAttribute btn btn-default btn-danger'
                     style='padding:0;border-radius:0;width:5%;float:right;text-align:center'><span
                        style='padding:10px' class="fa fa-times"></span></div>
                <div style='clear:both'></div>
            </td>
        </tr>
    </tbody>
</table>

-->

<script type="text/javascript">
    $(document).ready(function() {
        $("li","#lightSlider").css("height",($(document).height() - 50)+"px");
        var slider = $("#lightSlider").lightSlider({
            item : 1,
            pager : false,
            enableDrag : false,
            controls:false
        });

        $(document).on("click",".top_tab", function () {
            var self = $(this);
            var num = self.data("tab");
            slider.goToSlide(num);
            $('.top_tab.active').removeClass("active");
            self.addClass("active");
        })
    });
</script>

<script type="text/javascript">
    $(function () {
      /*  var top = $('.side1').offset().top;
        var height = $(window).height();
        var newHeight = height - top - (20);
        $('.side1, .side2').css("height", newHeight + "px");*/

        var index = 0;
        <#if extra?has_content>
            index = ${extra?keys?size};
            $('input[name=size]').val(index);
            $('.extraFieldsSize').text(index);
        </#if>

        var numRegEx = new RegExp('{num}', 'g');

        $('#addKeyValue').on('click', function () {
            var html = $('#addAttribute').html();
            html = html.replace(numRegEx, index);
            var newRow = $(html);
            $(newRow).addClass("extra"+index);
            $(newRow).find('.removeAttribute').data("index",index);
            $('#addNewColumnAttribute').before(newRow);
            var numberOfAttr = $('.extra:visible').length;
            $('.extraFieldsSize').text(numberOfAttr);
            $('input[name=size]').val(numberOfAttr);

            return false;
        });

        $(document).on('click','.removeAttribute', function(){
            var self = $(this);
            var inx = self.data("index");
            self.parents('.extra'+inx).remove();
            var numberOfAttr = $('.extra:visible').length;
            $('.extraFieldsSize').text(numberOfAttr);
            $('input[name=size]').val(numberOfAttr);
        });

    });
</script>

