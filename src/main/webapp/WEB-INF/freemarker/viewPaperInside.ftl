<#assign arrayOfColours = [
["#1A90C7","#26A7E3","#4AB6E8","#6FC4EC","#93D3F1","#072736","#0C415A","#105C7E","#1576A2"],
["#C71AAD","#E326C7","#E84AD0","#F193E3","#F6B7EC", "#36072F","#5A0C4E","#7E106E","#A2158D"],
["#1AC78D","#26E3A4","#4AE8B3","#6FECC2","#93F1D2", "#073626","#0C5A40","#107E5A","#15A273"],
["#C7651A","#E37826","#E88F4A","#ECA56F","#F1BC93","#361B07","#5A2E0C","#7E4010","#A25215"],
["#C71A1A","#E32626","#E84A4A","#EC6F6F","#F19393","#360707","#5A0C0C","#7E1010","#A21515"]
] />

<div style='right:33%;float:left;position:absolute;top:51px;bottom:0;left:0;overflow-y:scroll'>
    <span style='float:left;margin:20px'><a style='text-decoration: underline' href="${baseUrl}/user/">Home</a> > View paper</span>
    <h1 style='clear:left;margin:0;padding:0 20px 20px;float:left'>${paper.code!}  ${paper.name!} ${paper.year!} ${paper.semester!}</h1>
<#if paper?has_content>
<div style='position:relative'>
    <div id='paperMenu' style='float:right;margin:0 20px;font-size:20px;border-radius:0' class='btn btn-default btn-primary'><span class='fa fa-bars'></span></div>

    <div class='paper_buttons' style='margin-left:20px;display:none;position:absolute;top:100px;right:20px;background:white'>
        <a href="${baseUrl}/user/" class='menuButton'>Back to ${ICN} list</a>
        <a href="${baseUrl}/user/${paper._id}" class='menuButton'>Edit ${ICN} details</a>
        <a href="${baseUrl}/user/addStudentList/${paper._id}" class='menuButton'>Import student list</a>
        <a href="${baseUrl}/user/importStudentData/${paper._id}" class='menuButton'>Import student data</a>
        <a href="${baseUrl}/user/viewColumnList/${paper._id}" class='menuButton'>Edit columns</a>
    </div>
</div>
</#if>
    <div style='clear:both'></div>

<div style='margin:0 20px 20px;border:1px solid #066888;padding:20px;background:#043B4E'>
    <h3 style='margin:0 0 10px'>Columns</h3>
    <table width=100% cellspacing=0 cellpadding=0>
<#list columns?chunk(2) as cc>
    <tr>
        <#list cc as c>
            <td style='padding:5px'>
                <input id='check_${c._id}' type="checkbox" value="${c._id}" checked="checked" class="columnCheckbox"/> <label for='check_${c._id}'>${c.name}</label>
            </td>
        </#list>
    </tr>
        </#list>
        </table>
    </div>

    <div style='margin:20px;border:1px solid #AF08AF'>
        <h3 id='filterTitle' style='cursor:pointer;margin:0;padding:10px 20px;background:#AF08AF'>Filters
            <div style='float:right;padding:5px;font-style:italic;font-size:14px'>(click to expand)</div>
        </h3>
        <div style="clear:both"></div>

        <form id='filterForm' action="${baseUrl}/user/filterStudentList" method="post" name="filterForm"
              class="form-inline" style='background:#130113;display:none;padding:20px'>
            <input type="hidden" name="id" value="${id}"/>
            <input type="hidden" name="json" value=""/>

            <span class="btn btn-default btn-success newFilter" style="margin-bottom:10px">New filter</span>

            <div id="filterList">
                <div class="filterDiv">
                    <div class="operatorDiv">
                        <select name="join" class="form-control">
                            <option value="and">and</option>
                            <option value="or">or</option>
                        </select>
                    </div>
                    <select name="colref" class="form-control">
                    <#list columns as c>
                        <option value="${c._id}">${c.name}</option>
                    </#list>
                    </select>

                    <select name="operator" class="form-control">
                        <option value="$eq">equal to</option>
                        <option value="$lt">less than</option>
                        <option value="$lte">less than or equal to</option>
                        <option value="$gt">greater than</option>
                        <option value="$gte">greater than or equal to</option>
                        <option value="$ne">not equal to</option>
                    </select>

                    <input type="text" name="value" class="form-control" style="width: 250px"/>

                    <span class="fa fa-times removeFilter" style='margin-left:10px'></span>
                </div>
            </div>

            <button class="btn btn-default btn-purple submit" style='margin-top:20px'>Filter results</button>

        </form>
    </div>

    <h3 style='margin:0;padding:0 20px 20px'>
    <#if json?has_content>
        Search results (${results?size})
        <a href="${baseUrl}/user/viewPaper/${id}" class="btn btn-default btn-primary">Back to all student list</a>
    <#else>
        Students: ${results?size}
    </#if>
        <#if results?has_content>
        <a href="#" class="btn btn-default btn-primary emailStudents" style='margin-left:5px'>Email selected students</a>
        </#if>
    </h3>


<#if results?has_content>
<div style='padding: 0 20px '>
<form id="resultsForm" method="post" action="${baseUrl}/user/emailStudents">
    <input name="id" type="hidden" value="${id}" />
    <table id="studentList" width=100%>
        <tr>
            <th style='text-align:left;background:#066888;border-left:none'><input type="checkbox" name="usernameAll"/>
            </th>
            <th style='text-align:left;background:#066888;'>Username</th>
            <th style='text-align:left;background:#066888'>Given names</th>
            <th style='text-align:left;background:#066888'>Surname</th>
            <th style='text-align:left;background:#066888'>Email</th>
            <#list columns as c>
                <th class="${c._id}" style='background:${arrayOfColours[c_index%arrayOfColours?size][0]};border-bottom-color: ${arrayOfColours[c_index%arrayOfColours?size][6]};<#if !c_has_next>border-right:none</#if>'>${c.name}</th>

            </#list>
        </tr>

        <#list results as r>
            <tr>
                <td style='text-align:left;border-left:none'><input type="checkbox" value="${r.username}" name="usernames"/></td>
                <td style='text-align:left'>${r.username}</td>
                <td style='text-align:left'>${r.givenNames}</td>
                <td style='text-align:left'>${r.surname}</td>
                <td style='text-align:left'>${r.email!}</td>
                <#list r.data as d>
                    <#if d.userData?has_content>
                    <td data-id="${d.userData._id}" class="${d.column._id} columnData" style='text-align:center;<#if !d_has_next>border-right:none</#if>'
                        data-value="<#if d.userData?has_content>${d.userData.data[0].value}</#if>">
                        <#if d.userData?has_content>
                    ${d.userData.data[0].value}
                        </td>
                </#if>
                    <#else>
                    <td></td>
                    </#if>
                </#list>
            </tr>
        </#list>
    </table>
</form>
<#else>
<div style="padding: 0 20px 20px">
    No students found.
</div>
</#if>
</div>

</div>
<div id="sidePanel" style="width:33%;float:right;background:white;position:fixed;top:51px;right:0;bottom:0;overflow-y:scroll;overflow-x:hidden">
    <h1 style='margin:0;padding:20px;color:black;font-weight: 400'>${ICN_C} overview</h1>

<#list columns as c>
    <div id="${c._id}" class="${c._id} chart pieChart" style="width: 400px; height: 300px;"></div>
</#list>

</div>

<script type="text/javascript" src="https://www.google.com/jsapi"></script>

<script type="text/javascript">

$(function () {

    var sideWidth = $('#sidePanel').width();
    $('.chart').css('width', sideWidth + 'px');

    var filterList = $('#filterList');
    var filterDivHtml = $('.filterDiv').html();
    $('span.removeFilter').remove();
    $('.operatorDiv').remove();

    $('span.newFilter').on('click', function () {
        var div = $('<div/>').addClass('filterDiv').html(filterDivHtml).appendTo(filterList);
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

    $(document).on('click', 'span.removeFilter', function () {
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
            chartArea: {left: 20, right: 20, width: (sideWidth - 60)}
        };

        var chart = new google.visualization.PieChart(document.getElementById(column.id));

        chart.draw(data, options);
    </#list>
    }

    $('#filterTitle').on('click', function () {
        if ($('#filterForm').is(':hidden'))
            $('#filterForm').show();
        else
            $('#filterForm').hide();
    });

    $('input[name=usernameAll]').on('click', function () {
        if ($(this).is(':checked'))
            $('input[name=usernames]').prop('checked', true);
        else
            $('input[name=usernames]').prop('checked', false);
    });

    $('input[name=usernameAll]').click();

    $('.emailStudents').on('click', function() {
        $('#resultsForm').submit();
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

});


</script>