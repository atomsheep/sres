<#assign arrayOfColours = [
["#1A90C7","#26A7E3","#4AB6E8","#6FC4EC","#93D3F1","#072736","#0C415A","#105C7E","#1576A2"],
["#C71AAD","#E326C7","#E84AD0","#F193E3","#F6B7EC", "#36072F","#5A0C4E","#7E106E","#A2158D"],
["#1AC78D","#26E3A4","#4AE8B3","#6FECC2","#93F1D2", "#073626","#0C5A40","#107E5A","#15A273"],
["#C7651A","#E37826","#E88F4A","#ECA56F","#F1BC93","#361B07","#5A2E0C","#7E4010","#A25215"],
["#C71A1A","#E32626","#E84A4A","#EC6F6F","#F19393","#360707","#5A0C0C","#7E1010","#A21515"]
] />
<div id='topBar' class='topPanel' style='top:50px'>
    <span style='font-weight:bold;float:left;margin:10px;color:#043B4E'><a style='color:white;text-decoration: underline' href="${baseUrl}/user/">Home</a> > View paper (${paper.code!}  ${paper.name!} ${paper.year!} ${paper.semester!})</span>
    <#if paper?has_content>
        <div style='position:relative'>
            <div id='paperMenu' style='padding:9px 10px 10px;float:right;margin:0;font-size:20px;border-radius:0' class='btn btn-default btn-primary'><span style='display:block;' class='fa fa-bars'></span></div>

            <div class='paper_buttons' style='margin-left:20px;display:none;position:absolute;top:40px;right:0;background:white;z-index:100'>
                <a href="${baseUrl}/user/" class='menuButton'>Back to ${ICN} list</a>
                <a href="${baseUrl}/user/${paper._id}" class='menuButton'>Edit ${ICN} details</a>
                <a href="${baseUrl}/user/viewColumnList/${paper._id}" class='menuButton'>Edit columns</a>
                <a href="${baseUrl}/user/addStudentList/${paper._id}" class='menuButton'>Import student list</a>
                <a href="${baseUrl}/user/importStudentData/${paper._id}" class='menuButton'>Import student data</a>
            </div>

            <#--<div id='layoutButton' style='float:right;margin:0 0 0 20px;font-size:20px;border-radius:0' class='btn btn-default btn-primary'><img style='width:20px;height:20px;margin-top:-1px' src="${baseUrl}/assets/img/layout1.svg" /></div>-->

            <div class='layout_buttons' style='margin-left:20px;display:none;position:absolute;top:100px;right:81px;background:white;color:#0886AF'>
                <div class='menuButton'><div class='layout1 layout'></div> <div style='float:left;margin-left:5px'>Layout 1</div><div style='clear:both'></div></div>
                <div class='menuButton'><div class='layout2 layout'></div> <div style='float:left;margin-left:5px'>Layout 2</div><div style='clear:both'></div></div>
            </div>
        </div>
    </#if>
</div>

<div style='position:absolute;left:0;right:0;bottom:0;top:90px;overflow-y:scroll;overflow-x: hidden'>

    <div class="gridster">
        <ul>
            <li class='sres_panel' data-row="1" data-col="1" data-sizex="2" data-sizey="1">
                <h4 style='margin:0;padding:10px;background:#043B4E'>Columns <span class='deletePanel fa fa-times' style='float:right;'></span></h4>
                <div style='overflow-y:scroll;position:absolute;top:40px;bottom:0;left:0;right:0;'>
                    <table width=100% cellspacing=0 cellpadding=0 id='column_table'>
                        <tr>
                            <th style='text-align:center;border-left:none'><input checked="checked" type="checkbox" name="columnsAll"/></th>
                            <th style='text-align:left;'>Column name</th>
                            <th style='text-align:left;'>Description</th>
                            <th style='text-align:left;'>Tags</th>
                            <th style='text-align:left;border-right:none'></th>
                        </tr>
                    <#list columns?chunk(1) as cc>
                        <tr>
                            <#list cc as c>
                                <td>
                                    <input id='check_${c._id}' type="checkbox" value="${c._id}" checked="checked" class="columnCheckbox" name="columns"/>
                                </td>
                                <td style='text-align:left'>${c.name}</td>
                                <td style='text-align:left'>${c.description!}</td>
                                <td style='text-align:left'>${c.tags!}</td>
                                <td style='border-right:none;text-align:center;'><span class='fa fa-square' style='font-size:18px;color:${arrayOfColours[cc_index%arrayOfColours?size][0]}'></span></td>
                            </#list>
                        </tr>
                    </#list>
                    </table>
                </div>
            </li>
            <li class='sres_panel' data-row="2" data-col="1" data-sizex="2" data-sizey="1">
                <h4 id='filterTitle' style='background:#043B4E;margin:0;padding:10px'>Filters <span class='fa fa-times deletePanel' style='float:right'></span></h4>
                <div class='topPanel'>
                    <span class="btn btn-default btn-primary newFilter" style='border-radius:0;padding:10px 10px 9px;border-right:1px solid #043B4E'><span class='fa fa-plus'></span> New filter</span>
                    <button class="btn btn-default btn-primary submit" style='float:right;border-radius:0;padding:10px 10px 9px;border-left:1px solid #043B4E'><span class='fa fa-check'></span> Apply filters</button>
                </div>
                <div style="clear:both"></div>

                <form id='filterForm' action="${baseUrl}/user/filterStudentList" method="post" name="filterForm"
                      class="form-inline" style='position:absolute;top:80px;bottom:0;left:0;right:0;overflow-y:scroll;overflow-x: hidden'>
                    <input type="hidden" name="id" value="${id}"/>
                    <input type="hidden" name="json" value=""/>


                    <div id="filterList">
                        <div class="filterDiv">
                            <select name="colref" class="form-control" style='float:left;border-radius:0;width:40%'>
                            <#list columns as c>
                                <option value="${c._id}">${c.name}</option>
                            </#list>
                            </select>

                            <select name="operator" class="form-control" style='float:left;border-radius:0;width:20%'>
                                <option value="$eq">equal to</option>
                                <option value="$lt">less than</option>
                                <option value="$lte">less than or equal to</option>
                                <option value="$gt">greater than</option>
                                <option value="$gte">greater than or equal to</option>
                                <option value="$ne">not equal to</option>
                            </select>

                            <input placeholder="enter a value here, e.g. 10" type="text" name="value" class="form-control" style="width: 35%;float:left;border-radius:0"/>

                            <select name="join" class="form-control" style='display:none;float:left;border-radius:0;width:10%'>
                                <option value="and">and</option>
                                <option value="or">or</option>
                            </select>

                            <div class='removeFilter btn btn-default btn-danger' style='padding:0;border-radius:0;width:5%;float:right;text-align:center'><span style='padding:10px' class="fa fa-times"></span></div>
                            <div style='clear:both'></div>

                        </div>
                    </div>
                </form>
            </li>
            <li class='sres_panel' data-row="3" data-col="1" data-sizex="3" data-sizey="2">

                <h4 style='margin:0;padding:10px;background:#043B4E'>
                    <#if json?has_content>
                        Search results (${results?size})
                <#--<a href="${baseUrl}/user/viewPaper/${id}" class="btn btn-default btn-primary">Back to all student list</a>-->
                    <#else>
                        Students: ${results?size}
                    </#if>
                    <span class='fa fa-times deletePanel' style='float:right'></span>
                </h4>

                <div class='topPanel'>
                    <#if results?has_content>
                        <span class="btn btn-default btn-primary" style='float:left;border-radius:0;padding:10px 10px 9px;border-right:1px solid #043B4E'><span class='fa fa-envelope'></span> Email selected students</span>
                        <button class="btn btn-default btn-primary" style='float:left;border-radius:0;padding:10px 10px 9px;border-right:1px solid #043B4E'><span class='fa fa-mobile-phone'></span> SMS selected students</button>
                        <button class="btn btn-default btn-primary" style='float:left;border-radius:0;padding:10px 10px 9px;border-right:1px solid #043B4E'><span class='fa fa-pencil'></span> Edit selected students</button>
                    </#if>
                </div>

                <div style='position:absolute;top:80px;left:0;right:0;bottom:0;padding:0;overflow-y:scroll'>
                    <#if results?has_content>
                        <form id="resultsForm" method="post" action="${baseUrl}/user/emailStudents">
                            <input name="id" type="hidden" value="${id}" />
                            <table id="studentList" width=100%>
                                <thead>
                                    <th style='text-align:center;border-left:none'><input type="checkbox" name="usernameAll"/></th>
                                    <th style='text-align:left;'>Username</th>
                                    <th style='text-align:left;'>Given names</th>
                                    <th style='text-align:left;'>Surname</th>
                                    <th style='text-align:left;'>Email</th>
                                    <#list columns as c>
                                        <th class="${c._id}" style='color:white;background:${arrayOfColours[c_index%arrayOfColours?size][0]};border-bottom-color: ${arrayOfColours[c_index%arrayOfColours?size][6]};<#if !c_has_next>border-right:none</#if>'>${c.name}</th>
                                    </#list>
                                </thead>
                                <tbody>
                                <#list results as r>
                                    <tr>
                                        <td style='text-align:center;border-left:none'><input type="checkbox" value="${r.username}" name="usernames"/></td>
                                        <td style='text-align:left'>${r.username}</td>
                                        <td style='text-align:left'>${r.givenNames}</td>
                                        <td style='text-align:left'>${r.surname}</td>
                                        <td style='text-align:left'>${r.email!}</td>
                                        <#list r.data as d>
                                            <#if d.userData?has_content>
                                                <td data-id="${d.userData._id}" class="${d.column._id} columnData" style='text-align:center;<#if !d_has_next>border-right:none</#if>' data-value="<#if d.userData?has_content>${d.userData.data[0].value}</#if>">
                                                    ${d.userData.data[0].value}
                                                </td>
                                            <#else>
                                                <td></td>
                                            </#if>
                                        </#list>
                                    </tr>
                                </#list>
                                </tbody>
                            </table>
                        </form>
                    <#else>
                        <div style="padding:20px">
                            No students found.
                        </div>
                    </#if>
                </div>
            </li>

            <li class='sres_panel' data-row="1" data-col="3" data-sizex="1" data-sizey="1">
                <h4 style='margin:0;padding:10px;background:#043B4E'>${ICN_C} information <span class='fa fa-times deletePanel' style='float:right'></span></h4>
                <div style='font-size:24px;padding:10px;font-weight:300;'>
                    ${ICN_C} code: ${paper.code!}<br/>
                    ${ICN_C} name: ${paper.name!}<br/>
                    Year : ${paper.year!}<br/>
                    Semester: ${paper.semester!}
                </div>
            </li>
            <li class='sres_panel' data-row="2" data-col="3" data-sizex="1" data-sizey="1" style='background:white;overflow:hidden'>
                <h4 style='margin:0;padding:10px;background:#043B4E'>Data overview <span class='fa fa-times deletePanel' style='float:right'></span></h4>
                <#list columns as c>
                    <div id="${c._id}" class="${c._id} chart chart_${c_index} pieChart" style="margin:0 auto"></div>
                </#list>
            </li>
        </ul>
    </div>

</div>

<script type="text/javascript" src="https://www.google.com/jsapi"></script>

<script type="text/javascript">

$(function () {


    var third = 1/3;
    var quarter = 1/4;
    var gap = 10;
    var screenwidth = $(document).width() - (gap*10);
    var firstPanelStart = 50 + $('#topBar').height() + (gap*2);
    var screenheight = $(document).height() - firstPanelStart - (gap*8);

    $(".gridster ul").gridster({
        widget_margins: [gap, gap],
        widget_base_dimensions: [(screenwidth*third), (screenheight*quarter)],
        max_cols: 3,
        resize: {
            enabled:true
        }
    });

    $('input[name=usernameAll]').on('click', function () {
        if ($(this).is(':checked')){
            $('input[name=usernames]').prop('checked', true);
            $('input[name=usernames]').next('.sres_checkbox').addClass('fa-check-circle').removeClass('fa-circle-thin');
        }
        else{
            $('input[name=usernames]').prop('checked', false);
            $('input[name=usernames]').next('.sres_checkbox').removeClass('fa-check-circle').addClass('fa-circle-thin');
        }
    });

    $('input[name=columnsAll]').on('click', function () {
        $('input[name=columns]').each(function(){
            var self = $(this);
            self.click();
            var checked = self.is(":checked");

            if (checked)
            {
                self.prop('checked', true);
                self.next('.sres_checkbox').addClass('fa-check-circle').removeClass('fa-circle-thin');
            }
            else
            {
                self.prop('checked', false);
                self.next('.sres_checkbox').removeClass('fa-check-circle').addClass('fa-circle-thin');
            }
        });
    });

    $('input[name=usernameAll]').click();

    $(document).on('click', '.deletePanel', function(){
        var self = $(this);
        var parent = self.parents('.sres_panel');
        parent.prev('.placeHolder').show();
        parent.hide();
    });

    $('#studentList').DataTable({
        searching:false,
        paging:false,
        sDom : 'rt'
    });

    $('input[type=checkbox]').each(function(i,e){
        var self = $(this);
        var newCheckbox = "";
        if(self.is(":checked")){
            newCheckbox = "<span class='sres_checkbox fa fa-check-circle'></span>";
        }   else{
            newCheckbox = "<span class='sres_checkbox fa fa-circle-thin'></span>";
        }
        self.after(newCheckbox);
        self.css('display','none');
    });

    $(document).on('click','.sres_checkbox',function(){
        var self = $(this);
        if(self.hasClass('fa-check-circle')){
            self.removeClass('fa-check-circle').addClass('fa-circle-thin');
        }                  else{
            self.addClass('fa-check-circle').removeClass('fa-circle-thin');
        }
        self.prev('input[type=checkbox]').click();
    });

    $('.chart').css('margin-top','5px').css('width', (screenwidth*third) + 'px').css("height",(screenheight*quarter-30) + "px");

    var filterList = $('#filterList');
    var filterDivHtml = $('.filterDiv').html();
 //   $('div.removeFilter').remove();
    $('.operatorDiv').remove();

    $.fn.shortText = function(str,length){
        var item = $(this);
        var toset = str;
        if(str.length > length)
            toset = str.substring(0,length) +'...';
        item.text(toset).attr('title',str);
    };

    $('th').each(function(){
        var self = $(this);
        if(self.find("input").length == 0){
            var text = self.text();
            self.shortText(text,20);
        }
    });


    $('span.newFilter').on('click', function () {
        var div = $('<div/>').addClass('filterDiv').html(filterDivHtml).appendTo(filterList);
        div.prev('.filterDiv').find('input[name=value]').css('width','25%');
        div.prev('.filterDiv').find('select[name=join]').css('display','inline-block');
        $('span.removeFilter').show();
    });

    var columns = $('.topLeftPanel:last').html();
    var filters = $('.midLeftPanel:last').html();
    var studentList = $('.bottomLeftPanel:last').html();
    var paperInfo = $('.topRightPanel:last').html();
    var dataOverview = $('.midRightPanel:last').html();

    var p;

    $(document).on('click','.addPanel',function(){
        var self = $(this);
        p.popup_simple('destroy');
        var placeholder = p.data('placeholder');
        var div = placeholder.next('.sres_panel');
        placeholder.hide();
        if(self.hasClass("addColumns"))
            div.html(columns).show();
        else if(self.hasClass("addFilters"))
            div.html(filters).show();
        else if(self.hasClass('addStudentList'))
            div.html(studentList).show();
        else if(self.hasClass('addPaperInfo'))
            div.html(paperInfo).show();
        else if(self.hasClass("addDataOverview"))
            div.html(dataOverview).show();
    });

    $('.placeHolder').on('click', function(){
        var self = $(this);
        p = $("<div></div>").appendTo("body");
        p.data('placeholder',self);

        var inner = $("<div></div>");
        var table = $("<table style='width:100%'></table>");
        var tr1 = $("<tr></tr>");
        var tr2 = $("<tr></tr>");
        var button1 = "<td><button class='addPanel addColumns btn btn-default btn-primary' style='width:120px;height:120px'><span class='fa fa-bars' style='font-size:32px;transform:rotate(90deg)' ></span><br/>Columns</button></td>";
        var button2 = "<td><button class='addPanel addFilters btn btn-default btn-primary' style='width:120px;height:120px'><span class='fa fa-sitemap' style='font-size:32px;' ></span><br/>Filters</button></td>";
        var button3 = "<td><button class='addPanel addStudentList btn btn-default btn-primary' style='width:120px;height:120px'><span class='fa fa-bars' style='font-size:32px;' ></span><br/>Student list</button></td>";

        var button4 = "<td><button class='addPanel addDataOverview btn btn-default btn-primary' style='width:120px;height:120px'><span class='fa fa-pie-chart' style='font-size:32px;' ></span><br/>Data overview</button></td>";
        var button5 = "<td><button class='addPanel addPaperInfo btn btn-default btn-primary' style='width:120px;height:120px'><span class='fa fa-file-text-o' style='font-size:32px;' ></span><br/>${ICN_C} info</button></td>";
        var button6 = "<td><button class='addPanel btn btn-default btn-primary' style='width:120px;height:120px'><span class='fa fa-envelope' style='font-size:32px;' ></span><br/>Email log</button></td>";

        tr1.append(button1, button2, button3);
        tr2.append(button4, button5, button6);
        table.append(tr1, tr2);

        inner.append("<h4 style='color:#021E27'>Add a panel</h4>");
        inner.append(table);

        p.popup_simple('init',{
            content:inner,
            extraClasses : ["mainPopup"],
            confirm : false,
            cancel:true
        }).popup_simple("show").popup_simple("centre");
    });


<#if json?has_content>
    {
        var jsonString = "${json?js_string}";
        if (jsonString) {
            var array = $.parseJSON(jsonString);
            console.log('array', array);
            for (var i = 0; i < array.length; i++) {
                var join = array[i].join;
                var colref = array[i].colref;
                var operator = array[i].operator;
                var value = array[i].value;
                if (i == 0) {
                    var filterDiv = $('.filterDiv');
                    $('[name=colref]', filterDiv).val(colref);
                    $('[name=operator]', filterDiv).val(operator);
                    $('[name=value]', filterDiv).val(value);
                } else {
                    $('span.newFilter').click();
                    var filterDiv = $('.filterDiv:last');
                    $('[name=join]', filterDiv).val(join);
                    $('[name=colref]', filterDiv).val(colref);
                    $('[name=operator]', filterDiv).val(operator);
                    $('[name=value]', filterDiv).val(value);
                }
            }
        }
    }
</#if>

    $(document).on('click', 'div.removeFilter', function () {
        $(this).parent().remove();
    });

    $('button.submit').on('click', function () {
        var id = $('[name=id]').val();
        var array = [];
        $('.filterDiv').each(function (i, e) {
            var slf = $(this);
            var obj = {};
            obj.join = $('[name=join]', slf).val();
            obj.colref = $('[name=colref]', slf).val();
            obj.operator = $('[name=operator]', slf).val();
            obj.value = $('[name=value]', slf).val();
            array.push(obj);
        });
        var jsonString = JSON.stringify(array);
        console.log('json string', jsonString);
        $('[name=json]').val(jsonString);
        $('[name=filterForm]').submit();
    });

    $('td', '#studentList').on("dblclick", function () {
        var slf = $(this);
        var id = slf.data('id');
        if (id) {
            var oldValue = $.trim(slf.text());
            var input = $('<input/>').attr('type', 'text').attr('value', oldValue);
            slf.html(input);
            input.focus();
            input.select();
            input.on('keydown', function (e) {
                if (e.keyCode == 13) {
                    saveChanges(slf, input, oldValue);
                    return false;
                } else if (e.keyCode == 27)
                    changeInputBackToText(slf, input, oldValue);
            });
            input.on('blur', function (e) {
                var value = $.trim(input.val());
                if (value != oldValue) {
                    if (confirm('Do you want to save your changes?'))
                        saveChanges(slf, input, oldValue);
                    else
                        changeInputBackToText(slf, input, oldValue);
                }
            });
        }
    });

    $('input.columnCheckbox').on('change', function () {
        var slf = $(this);
        var value = slf.val();
        if (slf.is(':checked')) {
            $('.' + value).show();
        } else {
            $('.' + value).hide();
        }

    });

    function saveChanges(td, input, oldValue) {
        var id = td.data('id');
        var value = $.trim(input.val());
        if (value != oldValue) {
            $.post('${baseUrl}/user/saveColumnValue',
                    { id: id, value: value },
                    function (json) {
                        if (json.success) {
                            changeInputBackToText(td, input, value);
                        } else if (json.detail)
                            alert(json.detail);
                    });
        } else
            changeInputBackToText(td, input, value);


    }

    function changeInputBackToText(td, input, value) {
        td.text(value);
        input.remove();
    }

    var arrayOfColours = [
        ["#1A90C7","#26A7E3","#4AB6E8","#6FC4EC","#93D3F1","#072736","#0C415A","#105C7E","#1576A2"],
        ["#C71AAD","#E326C7","#E84AD0","#F193E3","#F6B7EC", "#36072F","#5A0C4E","#7E106E","#A2158D"],
        ["#1AC78D","#26E3A4","#4AE8B3","#6FECC2","#93F1D2", "#073626","#0C5A40","#107E5A","#15A273"],
        ["#C7651A","#E37826","#E88F4A","#ECA56F","#F1BC93","#361B07","#5A2E0C","#7E4010","#A25215"],
        ["#C71A1A","#E32626","#E84A4A","#EC6F6F","#F19393","#360707","#5A0C0C","#7E1010","#A21515"]
    ];


    google.load('visualization', '1.1', {packages: ['corechart'], callback: drawCharts});

    function drawCharts() {

    <#list columns as c>
        var column = {};
        column.name = "${c.name?js_string}";
        column.id = "${c._id}";
        column.data = {};
        $('td.' + column.id).each(function (i, e) {
            var value = $(e).data('value');
            if (value == "")
                value = "[blank]";
            if (!column.data[value])
                column.data[value] = 1;
            else
                column.data[value] += 1;
        });
        console.log('column.data', column.data);

        var arrayOfArray = [
            ['Task', 'sdd']
        ];
        $.each(column.data, function (i, e) {
            arrayOfArray.push([i, e]);
        });

        var data = google.visualization.arrayToDataTable(arrayOfArray);

        var options = {
            title: column.name,
            backgroundColor: 'transparent',
            legend: {textStyle: {color: '#000'}, position: "labeled"},
            pieSliceTextStyle: {
                color: 'transparent'
            },
            colors: arrayOfColours[${c_index}%arrayOfColours.length],
            chartArea: {width:"100%",left:20,right: 20}
        };

        var chart = new google.visualization.PieChart(document.getElementById(column.id));
        chart.draw(data, options);
    </#list>
    }

    $('.emailStudents').on('click', function() {
        $('#resultsForm').submit();
        return false;
    });

    var $paperButtons = $('.paper_buttons');
    var $layoutButtons = $('.layout_buttons');
    $('html').on('click', function () {
        if ($paperButtons.is(":visible"))
            $paperButtons.hide();
        if ($layoutButtons.is(":visible"))
            $layoutButtons.hide();
    });

    $('#paperMenu').on('click', function (event) {
        if ($paperButtons.is(':hidden'))
            $paperButtons.show();
        else
            $paperButtons.hide();
        if ($layoutButtons.is(":visible"))
            $layoutButtons.hide();
        event.stopPropagation();
    });

    $('#layoutButton').on('click', function (event) {
        if ($layoutButtons.is(':hidden'))
            $layoutButtons.show();
        else
            $layoutButtons.hide();
        if ($paperButtons.is(":visible"))
            $paperButtons.hide();
        event.stopPropagation();
    });

    var colTotal = ${columns?size};
    var colCount = 0;

    var interval = setInterval(function(){
        $('.chart_'+(colCount%colTotal)).css('display','none');
        colCount++;
        $('.chart_'+(colCount%colTotal)).css('display','inline-block');
    },5000);

});


</script>