<#assign arrayOfColours = [
["#1A90C7","#26A7E3","#4AB6E8","#6FC4EC","#93D3F1","#072736","#0C415A","#105C7E","#1576A2"],
["#C71AAD","#E326C7","#E84AD0","#F193E3","#F6B7EC", "#36072F","#5A0C4E","#7E106E","#A2158D"],
["#1AC78D","#26E3A4","#4AE8B3","#6FECC2","#93F1D2", "#073626","#0C5A40","#107E5A","#15A273"],
["#C7651A","#E37826","#E88F4A","#ECA56F","#F1BC93","#361B07","#5A2E0C","#7E4010","#A25215"],
["#C71A1A","#E32626","#E84A4A","#EC6F6F","#F19393","#360707","#5A0C0C","#7E1010","#A21515"]
] />
<div id='topBar' style='position:absolute;top:50px;left:0;right:0;background:#0886AF'>
    <span style='font-weight:bold;float:left;margin:10px;color:#043B4E'>
        <a style='color:white;text-decoration: underline' href="${baseUrl}/user/">Home</a> >
        View ${ICN} (${paper.code!}  ${paper.name!} ${paper.year!} ${paper.semester!})
    </span>
    <#if paper?has_content>
        <div style='position:relative'>
            <div id='paperMenu' style='float:right;margin:0;font-size:20px;border-radius:0' class='btn btn-default btn-primary'><span class='fa fa-bars'></span></div>

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

<div class='topPanel sres_panel placeHolder'><div style='padding:50px;text-align:center'>click here to add a panel</div></div>

<div class='topPanel sres_panel'>

<div style='margin:0;'>
    <h4 style='margin:0;padding:10px;background:#043B4E'>Columns <span class='deletePanel fa fa-times' style='float:right;'></span></h4>
    <div style='overflow-y:scroll;position:absolute;top:40px;bottom:0;left:0;right:0;'>
    <table width=100% cellspacing=0 cellpadding=0 id='column_table'>
        <tr>
            <th style='text-align:center;background:#066888;border-left:none'><input  checked="checked" type="checkbox" name="columnsAll"/></th>
            <th style='text-align:left;background:#066888;'>Column name</th>
            <th style='text-align:left;background:#066888'>Description</th>
            <th style='text-align:left;background:#066888'>Tags</th>
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
        </#list>
    </tr>
        </#list>
        </table>
    </div>
</div>
</div>

<div class='midPanel sres_panel placeHolder'><div style='padding:50px;text-align:center'>click here to add a panel</div></div>

<div class='midPanel sres_panel'>

    <div style='margin:0;'>
        <h4 id='filterTitle' style='background:#043B4E;margin:0;padding:10px'>Filters <span class='fa fa-times deletePanel' style='float:right'></span></h4>
        <div id='topBar' style='position:absolute;top:40px;left:0;right:0;background:#0886AF;height:40px'>
            <span class="btn btn-default btn-primary newFilter" style='border-radius:0;padding:10px;border-right:1px solid #043B4E'><span class='fa fa-plus'></span> New filter</span>
            <button class="btn btn-default btn-primary submit" style='float:right;border-radius:0;padding:10px;border-left:1px solid #043B4E'><span class='fa fa-check'></span> Apply filters</button>
        </div>
        <div style="clear:both"></div>

        <form id='filterForm' action="${baseUrl}/user/filterStudentList" method="post" name="filterForm"
              class="form-inline" style='padding:40px 0 10px'>
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
    </div>
</div>

<div class='bottomPanel sres_panel placeHolder'><div style='padding:50px;text-align:center'>click here to add a panel</div></div>

<div class='bottomPanel sres_panel'>

    <h4 style='margin:0;padding:10px;background:#043B4E'>
    <#if json?has_content>
        Search results (${results?size})
        <#--<a href="${baseUrl}/user/viewPaper/${id}" class="btn btn-default btn-primary">Back to all student list</a>-->
    <#else>
        Students: ${results?size}
    </#if>
        <#if results?has_content>
       <#-- <a href="#" class="btn btn-default btn-primary emailStudents" style='margin-left:5px'>Email selected students</a>-->
        </#if>
        <span class='fa fa-times deletePanel' style='float:right'></span>
    </h4>


<#if results?has_content>
<div style='position:absolute;top:40px;left:0;right:0;bottom:0;padding:0;overflow-y:scroll'>
<form id="resultsForm" method="post" action="${baseUrl}/user/emailStudents">
    <input name="id" type="hidden" value="${id}" />
    <table id="studentList" width="100%">
        <thead>
        <tr>
            <th style='text-align:center;background:#066888;border-left:none'><input type="checkbox" name="usernameAll"/></th>
            <th style='text-align:left;background:#066888;'>Username</th>
            <th style='text-align:left;background:#066888'>Given names</th>
            <th style='text-align:left;background:#066888'>Surname</th>
            <th style='text-align:left;background:#066888'>Email</th>
            <#list columns as c>
                <th class="${c._id}" style='background:${arrayOfColours[c_index%arrayOfColours?size][0]};border-bottom-color: ${arrayOfColours[c_index%arrayOfColours?size][6]};<#if !c_has_next>border-right:none</#if>'>${c.name}</th>

            </#list>
        </tr>
        </thead>
        <tbody>
        <#list results as r>
            <tr>
                <td style='text-align:center;border-left:none' class="userCheck"><input type="checkbox" value="${r.username}" name="usernames"/> <span class="fa fa-times deleteUser" style="display:none" data-id="${r._id}"></span> </td>
                <td style='text-align:left'>${r.username}</td>
                <td style='text-align:left'>${r.givenNames}</td>
                <td style='text-align:left'>${r.surname}</td>
                <td style='text-align:left'>${r.email!}</td>
                <#list r.data as d>
                    <#if d.userData?has_content>
                    <td data-id="${d.userData._id}" class="${d.column._id} columnData" style='text-align:center;<#if !d_has_next>border-right:none</#if>'
                        data-value="${d.userData.data[0].value}">
                        ${d.userData.data[0].value}
                    </td>
                    <#else>
                    <td class="${d.column._id} columnData" data-columnid="${d.column._id}" data-userid="${r._id}"></td>
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

</div>

<div class='sidePanel1 sres_panel placeHolder'><div style='padding:50px;text-align:center'>click here to add a panel</div></div>

<div id="sidePanel1" class='sidePanel1 sres_panel'>
<#--<h3 style='margin:0;padding:20px;color:black;font-weight: 400'>${ICN_C} overview</h3>-->
    <h4 style='margin:0;padding:10px;background:#043B4E'>${ICN_C} information <span class='fa fa-times deletePanel' style='float:right'></span></h4>
    <div style='font-size:24px;padding:10px;font-weight:300;'>
    ${ICN_C} code: ${paper.code!}<br/>
    ${ICN_C} name: ${paper.name!}<br/>
    Year : ${paper.year!}<br/>
    Semester: ${paper.semester!}
    </div>
</div>

<div class='sidePanel2 sres_panel placeHolder'><div style='padding:50px;text-align:center'>click here to add a panel</div></div>

<div id="sidePanel2" class='sidePanel2 sres_panel' style='background:white'>
    <#--<h3 style='margin:0;padding:20px;color:black;font-weight: 400'>${ICN_C} overview</h3>-->
        <h4 style='margin:0;padding:10px;background:#043B4E'>Data overview <span class='fa fa-times deletePanel' style='float:right'></span></h4>
    <#list columns as c>
    <div id="${c._id}" class="${c._id} chart chart_${c_index} pieChart" style="margin:0 auto"></div>
</#list>

</div>

<script type="text/javascript" src="https://www.google.com/jsapi"></script>

<script type="text/javascript">

$(function () {

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

    $('.deletePanel').on('click', function(){
        var self = $(this);
        var parent = self.parents('.sres_panel');
        parent.prev('.placeHolder').show();
        parent.hide();
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

    var third = 1/3;
    var screenwidth = $(document).width() - 60;

    var firstPanelStart = 50 + $('#topBar').height();
    var screenheight = $(document).height() - firstPanelStart - 80;
    console.log(screenheight);
    var secondPanelStart = firstPanelStart + (screenheight *.25) + 20;
    var thirdPanelStart = secondPanelStart + (screenheight *.25) + 20;

    var $sidePanel1 = $('.sidePanel1');
    var $sidePanel2 = $('.sidePanel2');

    $sidePanel1.css("width",(screenwidth*third)+"px").css("height",(screenheight *.25)+"px").css('top',firstPanelStart+"px");
    $sidePanel2.css("width",(screenwidth*third)+"px").css("height",(screenheight *.25)+"px").css('top',secondPanelStart+"px");

    $('.topPanel').css("width",(screenwidth*third*2)+"px").css("height",(screenheight *.25)+"px").css('top',firstPanelStart+"px");
    $('.midPanel').css("width",(screenwidth*third*2)+"px").css("height",(screenheight *.25)+"px").css('top',secondPanelStart+"px");
    $('.bottomPanel').css("width",(screenwidth*third*3+20)+"px").css("height",(screenheight *.5)+"px").css('top',thirdPanelStart+"px");

    var sideWidth = $sidePanel1.width();
    var sideHeight = $sidePanel1.height() -40;
    $('.chart').css('margin-top','10px').css('width', sideWidth + 'px').css("height",sideHeight + "px");

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

    var columns = $('.topPanel:last').html();
    var filters = $('.midPanel:last').html();
    var studentList = $('.bottomPanel:last').html();
    var paperInfo = $('.sidePanel1:last').html();
    var dataOverview = $('.sidePanel2:last').html();

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


    $('.sres_panel').draggable({ handle: "h4",
        helper:function(event){
            var div = "<div class='sres_panel' style='width:" + (screenwidth*third)+"px;height:" + (screenheight *.25)+"px'></div>";
            return div;
        }, containment: "document",
        start: function(e, ui){
            $(e.target).css('opacity',.5);
            console.log(e);
        },
        stop : function(e, ui){
            $(e.target).css('opacity',1);
        }
    }).droppable({
        tolerance : "intersect",
        over : function(ui,e){
            var firstCSS = $(ui.target).css(['top','left','right','width','height']);
            var secondCSS = $(e.draggable[0]).css(['top','left','right','width','height']);

            $(ui.target).css({
                top:secondCSS['top'],
                left:secondCSS['left'],
                right:secondCSS['right'],
                width:secondCSS['width'],
                height:secondCSS['height']
            });
            $(e.draggable[0]).css({
                top:firstCSS['top'],
                left:firstCSS['left'],
                right:firstCSS['right'],
                width:firstCSS['width'],
                height:firstCSS['height']
            });
        }
    });

    //.resizable({handles:"n, s, e, w"})


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
        var userId = slf.data("userid");
        var columnId = slf.data("columnid");
        if ((id !=null) || ((userId!=null) && (columnId!=null))) {
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
        var value = $.trim(input.val());
        if (value != oldValue) {
            var id = td.data('id');
            var userId = td.data("userid");
            var columnId = td.data("columnid");
            $.post('${baseUrl}/user/saveColumnValue',
                    { id: id, userId: userId, columnId: columnId, value: value },
                    function (json) {
                        if (json.success) {
                            if(json.detail) {
                                console.log("detail", json.detail);
                                td.data("id", json.detail);
                            }
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
            if ((value == null) || (value == ""))
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

    $('td.userCheck').on("mouseover", function(){
        var slf = $(this);
        slf.find('span').show();
    });

    $('td.userCheck').on("mouseout", function () {
        var slf = $(this);
        slf.find('span').hide();
    });

    $('span.deleteUser').on('click', function(){
        if(confirm("Are you sure you want to remove this user from current paper?")) {
            var slf = $(this);
            var id = slf.data('id');
            console.log('delete user here', id);
            var paperId = "${id}";
            $.post('${baseUrl}/user/removeUser',
                    {id: id, paperId: paperId},
                    function(json){
                        if(json.success) {
                            console.log('removed user', id, 'from', paperId);
                            slf.closest('tr').remove();
                        }
                    });
        }
    });

});


</script>