<#assign tabs = ["Student list", "Data overview", "Interventions" ] />

<div style="margin-left:50px">
<#list tabs as t>
    <div class="top_tab <#if t_index == 0>active</#if>" data-tab="${t_index}">${t}</div>
</#list>
    <div style="clear:both"></div>
</div>
<ul id="lightSlider" style="">
    <li class="slide">
        <div class="slideInner">
            <div id="studentData" style="position: absolute;overflow: hidden;top: 20px;bottom: 20px;left: 20px;right: 20px;"></div>
        </div>
    </li>
    <li class="slide">
        <div class="slideInner">
            <div class="search_bar">
                <div class="iris-search text-icon"></div>
                <input type="text" class="iris-input" placeholder="Search"/>
                <div style="clear:both"></div>
            </div>
            <table class="paperList_table" style="margin-top:20px">
            <#if list?has_content>
                <#list list as l>
                    <tr>
                        <td style="background:#fdefbb">Owner</td>
                        <td style="background:#fdefbb">${l.code!}</td>
                        <td style="background:#fdefbb">${l.name!}</td>
                        <td style="background:#fdefbb">${l.year!}</td>
                        <td style="background:#fdefbb;border-right:10px solid #f1cf3d">${l.semester!}</td>
                        <td style="width:16%"><a href="#" class="paper_buttons"><div class="iris-lock paper_controls"></div><div class="paper_controls small_text">Request access</div></a></td>
                    </tr>
                </#list>
            </#if>
            </table>
        </div>
    </li>
    <li class="slide">
        <div class="slideInner">
            <h3>My profile</h3>
            <p>Lorem ipsum Excepteur amet adipisicing fugiat velit nisi.</p>
        </div>
    </li>
</ul>

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
        });

        $(document).on("mouseover",".paperList_table td",function(){
            $(this).parent("tr").find("td").addClass("highlight");
        }).on("mouseout",".paperList_table td",function(){
            $(this).parent("tr").find("td").removeClass("highlight");
        });

        $(document).on("mouseover",".studentField-td",function(){
            $(".studentField-td").show();
            $("tr",".paperList_table").each(function(k,v){
                $(".studentData-td",v).each(function(i,e){
                    if(i!=0)
                        $(this).hide();
                    else
                        $(this).width(50);
                });
            });
        });

        $(document).on("mouseover",".studentData-td",function(){
            $(".studentData-td").show();
            $("tr",".paperList_table").each(function(k,v){
                $(".studentField-td",v).each(function(i,e){
                    if(i!=0)
                        $(this).hide();
                    else
                        $(this).width(50);
                });
            });
        });
    });
</script>

<#--

<#assign arrayOfColours = [
["#1A90C7","#26A7E3","#4AB6E8","#6FC4EC","#93D3F1","#072736","#0C415A","#105C7E","#1576A2"],
["#C71AAD","#E326C7","#E84AD0","#F193E3","#F6B7EC", "#36072F","#5A0C4E","#7E106E","#A2158D"],
["#1AC78D","#26E3A4","#4AE8B3","#6FECC2","#93F1D2", "#073626","#0C5A40","#107E5A","#15A273"],
["#C7651A","#E37826","#E88F4A","#ECA56F","#F1BC93","#361B07","#5A2E0C","#7E4010","#A25215"],
["#C71A1A","#E32626","#E84A4A","#EC6F6F","#F19393","#360707","#5A0C0C","#7E1010","#A21515"]
] />

<div id='topBar' class='topPanel' style='top:50px'>
    <span style='font-weight:bold;float:left;margin:10px;color:#043B4E'>
        <a style='color:white;text-decoration: underline' href="${baseUrl}/user/">Home</a> >
        View ${ICN} (${paper.code!}  ${paper.name!} ${paper.year!} ${paper.semester!})
    </span>
<#if paper?has_content>
    <div style='position:relative'>
        <div id='paperMenu' style='padding:9px 10px 10px;float:right;margin:0;font-size:20px;border-radius:0'
             class='btn btn-default btn-primary'><span style='display:block;' class='fa fa-bars'></span></div>

        <div class='paper_buttons'
             style='margin-left:20px;display:none;position:absolute;top:40px;right:0;background:white;z-index:100'>
            <a href="${baseUrl}/user/" class='menuButton'>Back to ${ICN} list</a>
            <a href="${baseUrl}/user/editPaper/${paper._id}" class='menuButton'>Edit ${ICN} info</a>
            <a href="${baseUrl}/user/viewColumnList/${paper._id}" class='menuButton'>Edit columns</a>
            <a href="${baseUrl}/user/addStudentList/${paper._id}" class='menuButton'>Import student list</a>
            <a href="${baseUrl}/user/importStudentData/${paper._id}" class='menuButton'>Import student data</a>
        </div>

    <div id='layoutButton' style='padding:5px 10px 6px;float:right;margin:0;font-size:20px;border-radius:0' class='btn btn-default btn-primary'><img style='width:20px;height:20px;margin-top:-1px' src="${baseUrl}/assets/img/layout1.svg" /></div>

        <div class='layout_buttons' style='margin-left:20px;display:none;position:absolute;top:40px;right:40px;background:white;color:#0886AF;z-index:100'>
            <div class='menuButton addPanel'>
                <span class='fa fa-plus'></span>
                <div style='display:inline;margin-left:5px'>Add dashboard panel</div>
                <div style='clear:both'></div>
            </div>
            <div class='menuButton restoreLayout'>
                <div class='layout2 layout'></div>
                <div style='float:left;margin-left:5px'>Restore default layout</div>
                <div style='clear:both'></div>
            </div>
        </div>
    </div>
    <div id='panels' style='display:none;clear:both;background:white;height:40px;z-index:50;position:absolute;top:40px;left:0;right:0'>
        <div class='fa fa-times closePanels' style='cursor:pointer;float:left;color:#0886AF;font-size: 18px;padding: 10px 10px;'></div>

        <div class='btn btn-default addPanelButton btn-square right' data-panel="columns">Columns</div>
        <div class='btn btn-default addPanelButton btn-square right' data-panel="filters">Filters</div>
        <div class='btn btn-default addPanelButton btn-square right' data-panel="userFields">Student fields</div>
        <div class='btn btn-default addPanelButton btn-square right' data-panel="paperInfo">Paper info</div>
        <div class='btn btn-default addPanelButton btn-square right' data-panel="dataOverview">Data overview</div>
        <div class='btn btn-default addPanelButton btn-square right' data-panel="interventions">Intervention log</div>
        <div class='btn btn-default addPanelButton btn-square right' data-panel="studentData">Student data</div>
    </div>
</#if>
</div>
-->
<#-- panel name : row, col, sizex, sizey -->
<#assign panels = {
    "columns":[1,1,2,1],
    "filters":[2,1,2,1],
    "studentData":[3,1,2,2],
    "paperInfo":[1,3,1,1],
    "userFields":[2,3,1,1],
    "dataOverview":[3,3,1,1],
    "interventions":[4,3,1,1]
}/>
<#--
<div style='position:absolute;left:0;right:0;bottom:0;top:90px;overflow-y:scroll;overflow-x: hidden'>

    <div class="gridster">
        <ul>
            <#if !paper.gridData?has_content>
                <#list panels?keys as k>
                    <li class='sres_panel' data-row="${panels[k][0]}" data-col="${panels[k][1]}" data-sizex="${panels[k][2]}" data-sizey="${panels[k][3]}" data-paneltype="${k}">
                        <div class='innerContent'>
                            <img src='${baseUrl}/assets/img/saving.gif' style='position:absolute;left:50%;margin-left:-25px;top:50%;margin-top:-10px' />
                        </div>
                    </li>
                </#list>
            </#if>
        </ul>
    </div>

</div>
-->
<script type="text/javascript" src="https://www.google.com/jsapi"></script>

<script type="text/javascript">

$(function () {

    $.get("${baseUrl}/user/getStudentData/${paper._id}", function(data){
        $('#studentData').html(data);
       /* replaceCheckboxes(self);

        self.find('th').each(function () {
            var slf = $(this);
            if (slf.find("input").length == 0) {
                var text = slf.text();
                slf.shortText(text, 20);
            }
        });*/
    });


    $('.restoreLayout').on('click', function(){
        saveGridData(true, function(){
            location.reload();
        });
    });

    $('.addPanel').on('click', function(){
        $('#panels').slideDown();
    });

    $('.closePanels').on('click', function(){
        $('#panels').slideUp();
    });

    <#if paper.gridData?has_content>
        var gridData = JSON.parse("${paper.gridData?js_string}");
        gridData = Gridster.sort_by_row_and_col_asc(gridData);
        $.each(gridData, function(i,e){
            gridster.add_widget("<li data-paneltype='" + this.paneltype + "' class='sres_panel'><div class='innerContent'><img src='${baseUrl}/assets/img/saving.gif' style='position:absolute;left:50%;margin-left:-25px;top:50%;margin-top:-10px' /></div></li>", this.size_x, this.size_y, this.col, this.row);
        });
    </#if>

    function saveGridData(nullData,callback){
        var gridData = null;
        if(!nullData)
            gridData = JSON.stringify(gridster.serialize());
        $.post("${baseUrl}/user/saveDashboardLayout",
                {gridData:gridData,paperId:"${paper._id}"},
                function(response){
                    if(callback)
                        callback();
                });
    }

    //async loading of panels-------------------------------------------------

    function loadPanel(self){
        var pt = self.data("paneltype");
        if(pt == "columns"){
            $.get("${baseUrl}/user/getColumns/${paper._id}", function(data){
                self.find('.innerContent').html(data);
                replaceCheckboxes(self);
                $(".showPalette").each(function(i,e){
                    var columnId = $(e).data('column');
                    $(e).spectrum({
                        showPaletteOnly: true,
                        showPalette:true,
                        color: colours[i%colours.length],
                        palette: [
                            ['#1A90C7', '#C71AAD', '#1AC78D','#C7651A','#C71A1A']
                        ],
                        change: function(color) {
                            console.log(color);
                            $.post("${baseUrl}/user/changeColour",
                                    {columnId:columnId,colour:color.toHexString()},
                                    function(response){
                                        $('.showPalette_'+columnId).css('color',color);
                                        $('th.'+columnId).css('background',color);
                                    }
                            );
                        }
                    });
                });
            });
        } else if (pt == "filters"){
            $.get("${baseUrl}/user/getFilters/${paper._id}", function(data){
                self.find('.innerContent').html(data);
                replaceCheckboxes(self);
                filterList = $('#filterList');
                filterDivHtml = $('.filterDiv').html();
            });
        } else if (pt == "studentData"){
            $.get("${baseUrl}/user/getStudentData/${paper._id}", function(data){
                self.find('.innerContent').html(data);
                replaceCheckboxes(self);

                self.find('th').each(function () {
                    var slf = $(this);
                    if (slf.find("input").length == 0) {
                        var text = slf.text();
                        slf.shortText(text, 20);
                    }
                });
            });
        } else if (pt == "paperInfo"){
            $.get("${baseUrl}/user/getPaperInfo/${paper._id}", function(data){
                self.find('.innerContent').html(data);
                replaceCheckboxes(self);
            });
        } else if (pt == "interventions") {
            $.get("${baseUrl}/user/getInterventions/${paper._id}", function(data){
                self.find('.innerContent').html(data);
                replaceCheckboxes(self);
            });
        } else if (pt == "userFields") {
            $.get("${baseUrl}/user/getUserFields/${paper._id}", function(data){
                self.find('.innerContent').html(data);
                replaceCheckboxes(self);
            });
        } else if (pt == "dataOverview") {
            $.get("${baseUrl}/user/getDataOverview/${paper._id}", function(data){
                self.find('.innerContent').html(data);
                replaceCheckboxes(self);
            });
        }
    }

    var colours = ['#1A90C7', '#C71AAD', '#1AC78D','#C7651A','#C71A1A'];
    $('.sres_panel').each(function(i,e){
        var self = $(this);
        loadPanel(self);
    });

    //-------------------------------------------------------------------------

    $(document).on('click', 'input[name=usernames]', function() {
        var count = $('input[name=usernames]:checked').length;
        $('.studentCount').text(count);
    });

    $(document).on('click', 'input[name=usernameAll]', function () {
        if ($(this).is(':checked')) {
            $('input[name=usernames]').prop('checked', true);
            $('input[name=usernames]').next('.sres_checkbox').addClass('fa-check-circle').removeClass('fa-circle-thin');
        }
        else {
            $('input[name=usernames]').prop('checked', false);
            $('input[name=usernames]').next('.sres_checkbox').removeClass('fa-check-circle').addClass('fa-circle-thin');
        }
    });

    $(document).on('click', 'input[name=columnsAll]', function () {
        $('input[name=columns]').each(function () {
            var self = $(this);
            self.click();
            var checked = self.is(":checked");

            if (checked) {
                self.prop('checked', true);
                self.next('.sres_checkbox').addClass('fa-check-circle').removeClass('fa-circle-thin');
            }
            else {
                self.prop('checked', false);
                self.next('.sres_checkbox').removeClass('fa-check-circle').addClass('fa-circle-thin');
            }
        });
    });

    $(document).on('click', '.deletePanel', function () {
        var self = $(this);
        var parent = self.parents('.sres_panel');
        gridster.remove_widget(parent);
        saveGridData();
    });

    function replaceCheckboxes(div){
        $('input[type=checkbox]',div).each(function (i, e) {
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
    }
    
    function replaceStudentDataCheckboxes(div){
        $('input[type=checkbox]',div).each(function (i, e) {
            var self = $(this);
            if(this.className != "" && this.className != "columnCheckbox")
            {
            var newCheckbox = "";
            if (self.is(":checked")) {
                newCheckbox = "<span class='sres_checkbox fa fa-check-circle'></span>";
                self.after(newCheckbox);
                self.css('display', 'none');
            } else {
                newCheckbox = "<span class='sres_checkbox fa fa-circle-thin'></span>";
                self.after(newCheckbox);
                self.css('display', 'none');
            }
          }
        });
    }

    $(document).on('click', '.sres_checkbox', function () {
        var self = $(this);
        if (self.hasClass('fa-check-circle')) {
            self.removeClass('fa-check-circle').addClass('fa-circle-thin');
        } else {
            self.addClass('fa-check-circle').removeClass('fa-circle-thin');
        }
        self.prev('input[type=checkbox]').click();
    });

  //  $('.chart').css('margin-top', '5px').css('width', (screenwidth * third) + 'px').css("height", (screenheight * quarter - 30) + "px");

    var filterList = $('#filterList');
    var filterDivHtml = $('.filterDiv').html();
    $('.operatorDiv').remove();

    $.fn.shortText = function (str, length) {
        var item = $(this);
        var toset = str;
        if (str.length > length)
            toset = str.substring(0, length) + '...';
        item.text(toset).attr('title', str);
    };

    $(document).on('click', 'span.newFilter', function () {
        var div = $('<div/>').addClass('filterDiv').html(filterDivHtml).appendTo(filterList);
        div.prev('.filterDiv').find('input[name=value]').css('width', '25%');
        div.prev('.filterDiv').find('select[name=join]').css('display', 'inline-block');
        $('span.removeFilter').show();
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

    $(document).on('click', 'button.submit', function () {
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

        $.post("${baseUrl}/user/filterStudentList",
            {id:id, json:jsonString},
            function(data){
                $('.sres_panel').each(function(i,e){
                    var self = $(this);
                    var id = self.attr('id');
                    var pt = self.data("paneltype");
                    if (pt == "studentData"){
                        self.find('.innerContent').html(data);
                       replaceStudentDataCheckboxes(id);

                        self.find('th').each(function () {
                            var slf = $(this);
                            if (slf.find("input").length == 0) {
                                var text = slf.text();
                                slf.shortText(text, 20);
                            }
                        });
                    }
                });
            }
        );
    });
/* TODO:remove?
    $(document).on("dblclick", '#studentList td', function () {
        var slf = $(this);
        var id = slf.data('id');
        var userId = slf.data("userid");
        var columnId = slf.data("columnid");
        if ((id != null) || ((userId != null) && (columnId != null))) {
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
*/
    $(document).on('change', 'input.columnCheckbox', function () {
        var slf = $(this);
        var value = slf.val();
        var remove = !slf.is(":checked");
        if (remove) {
            $('.' + value).hide();
        } else {
            $('.' + value).show();
        }

        $.post("${baseUrl}/user/addRemoveColumn",
            {
                paperId:"${paper._id}",
                columnId:value,
                remove: remove
            },
            function(){ }
        );
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
                            if (json.detail) {
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
        ["#1A90C7", "#26A7E3", "#4AB6E8", "#6FC4EC", "#93D3F1", "#072736", "#0C415A", "#105C7E", "#1576A2"],
        ["#C71AAD", "#E326C7", "#E84AD0", "#F193E3", "#F6B7EC", "#36072F", "#5A0C4E", "#7E106E", "#A2158D"],
        ["#1AC78D", "#26E3A4", "#4AE8B3", "#6FECC2", "#93F1D2", "#073626", "#0C5A40", "#107E5A", "#15A273"],
        ["#C7651A", "#E37826", "#E88F4A", "#ECA56F", "#F1BC93", "#361B07", "#5A2E0C", "#7E4010", "#A25215"],
        ["#C71A1A", "#E32626", "#E84A4A", "#EC6F6F", "#F19393", "#360707", "#5A0C0C", "#7E1010", "#A21515"]
    ];

    $(document).on('click', '.emailStudents', function () {
        $('#resultsForm').submit();
        return false;
    });

    var panelsObj = {};
    <#list panels?keys as k>
        panelsObj["${k}"] = [];
        <#list panels[k] as p>
            panelsObj["${k}"].push("${p}");
        </#list>
    </#list>

    $('.addPanelButton').on('click', function(){
        var self = $(this);
        var pt = self.data("panel");
        var li = "<li class='sres_panel' data-paneltype='" + pt + "' data-row='" + panelsObj[pt][0] + "' data-col='" + panelsObj[pt][1] + "' data-sizex='" + panelsObj[pt][2] + "' data-sizey='" + panelsObj[pt][3] + "'><div class='innerContent'><img src='${baseUrl}/assets/img/saving.gif' style='position:absolute;left:50%;margin-left:-25px;top:50%;margin-top:-10px' /></div></li>";
        var newPanel = gridster.add_widget(li,panelsObj[pt][2],panelsObj[pt][3]);
        loadPanel(newPanel);
        saveGridData();
        $('#panels').slideUp();
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

    $('td.userCheck').on("mouseover", function () {
        var slf = $(this);
        slf.find('span').show();
    });

    $('td.userCheck').on("mouseout", function () {
        var slf = $(this);
        slf.find('span').hide();
    });

    $('span.deleteUser').on('click', function () {
        if (confirm("Are you sure you want to remove this user from current paper?")) {
            var slf = $(this);
            var id = slf.data('id');
            console.log('delete user here', id);
            var paperId = "${id}";
            $.post('${baseUrl}/user/removeUser',
                    {id: id, paperId: paperId},
                    function (json) {
                        if (json.success) {
                            console.log('removed user', id, 'from', paperId);
                            slf.closest('tr').remove();
                        }
                    });
        }
    });

});

</script>