<div style='width:66%;float:left'>
    <h1>Paper Information</h1>

<#if paper?has_content>

    <p> ${paper.code!}  ${paper.name!} ${paper.year!} ${paper.semester!}        </p>


    <a href="${baseUrl}/user/${paper._id}" class="btn btn-default btn-primary">Change ${ICN} information</a>
    <a href="${baseUrl}/user/addStudentList/${paper._id}" class="btn btn-default btn-primary">Import Student List</a>
    <a href="${baseUrl}/user/importStudentData/${paper._id}" class="btn btn-default btn-primary">Import Student Data</a>

    <a href="${baseUrl}/user/viewColumnList/${paper._id}" class="btn btn-default btn-primary">View Column List</a>

</#if>

    <h1>
    <#if json?has_content>
        Search results
    <#else>
        View Student List
    </#if>
    </h1>


<#list columns as c>
    <input type="checkbox" value="${c._id}" checked="checked" class="columnCheckbox"/> ${c.name}
</#list>

    <h2>Filters
    <#if json?has_content>
        <a href="${baseUrl}/user/viewStudentList/${id}">Back to all student list</a>
    </#if>
    </h2>

    <form action="${baseUrl}/user/filterStudentList" method="post" name="filterForm" class="form-inline">
        <input type="hidden" name="id" value="${id}"/>
        <input type="hidden" name="json" value=""/>

        <span class="btn btn-default newFilter">New filter</span>

        <div id="filterList">
            <div class="filterDiv">
                <div class="operatorDiv">
                    <select name="join" class="form-control">
                        <option value="and">and</option>
                        <option value="or">or</option>
                    </select>
                </div>
                Column:
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

                <input type="text" name="value" class="form-control" style="width: 300px"/>

                <span class="fa fa-times removeFilter"></span>
            </div>
        </div>

        <button class="btn btn-default btn-primary submit">Filter</button>

    </form>
<#if results?has_content>

${results?size}
    <table border="1" id="studentList">
        <tr>
            <th>Username</th>
            <th>Given Names</th>
            <th>Surname</th>
            <th>Email</th>
            <#list columns as c>
                <th class="${c._id}">${c.name}</th>
            </#list>
        </tr>

        <#list results as r>
            <tr>
                <td>${r.username}</td>
                <td>${r.givenNames}</td>
                <td>${r.surname}</td>
                <td>${r.email!}</td>
                <#list r.data as d>
                    <td data-id="${d.data._id}" class="${d.column._id} columnData"
                        data-value="<#if d.data?has_content>${d.data.value}</#if>">
                        <#if d.data?has_content>
                    ${d.data.value}
                </#if>
                    </td>
                </#list>
            </tr>
        </#list>


    </table>
<#else>
    No students found.
</#if>

</div>
<div id="sidePanel" style="width:33%;float:right;background:black;position:fixed;top:0;right:0;bottom:0">


<#list columns as c>

    <div id="${c._id}" class="${c._id} chart" style="width: 400px; height: 300px;"></div>
</#list>


</div>

<script type="text/javascript" src="https://www.google.com/jsapi"></script>

<script type="text/javascript">

    $(function () {

        var sideWidth = $('#sidePanel').width();
        $('.chart').css('width', sideWidth + 'px');

        var filterList = $('#filterList');
        var filterDivHtml = $('.filterDiv').html();
        //var operatorDivHtml =   $('.operatorDiv').html();
        $('span.removeFilter').remove();
        $('.operatorDiv').remove();

        $('span.newFilter').on('click', function () {
            // var operatorDiv = $('<div/>').addClass('operatorDiv').html(operatorDivHtml).appendTo(filterList);
            var div = $('<div/>').addClass('filterDiv').html(filterDivHtml).appendTo(filterList);
            $('span.removeFilter').show();

        });

        $(document).on('click', 'span.removeFilter', function () {
            $(this).parent().prev().remove();
            $(this).parent().remove();
            if ($('.filterDiv').length == 1)
                $('span.removeFilter').hide();
        });

        $('button.submit').on('click', function () {
            var id = $('[name=id]').val();
            var json = [];
            $('.filterDiv').each(function (i, e) {
                var slf = $(this);
                var obj = {};
                obj.join = $('[name=join]', slf).val();
                obj.colref = $('[name=colref]', slf).val();
                obj.operator = $('[name=operator]', slf).val();
                obj.value = $('[name=value]', slf).val();
                json.push(obj);
            });
            var jsonString = JSON.stringify(json);
            console.log('json string', jsonString);
            $('[name=json]').val(jsonString);
            $('[name=filterForm]').submit();
        });

        $('#studentList td').on("dblclick", function () {
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
                    } else if (e.keyCode == 27)
                        changeInputBackToText(slf, input, oldValue);
                });
                input.on('blur', function (e) {
                    if (confirm('Do you want to save your changes?')) {
                        saveChanges(slf, input, oldValue);
                    } else {
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

        //google.charts.load('current', {'packages':['corechart']});
        //google.charts.setOnLoadCallback(drawChart);

        google.load('visualization', '1.1', {packages: ['corechart'], callback:drawCharts});

        function drawCharts() {

        <#list columns as c>
        var column = {};
        column.name = "${c.name?js_string}";
        column.id = "${c._id}";
        column.data = {};
        $('td.' + column.id).each(function (i, e) {
            var value = $(e).data('value');
            if (!column.data[value])
                column.data[value] = 1;
            else
                column.data[value] += 1;
        });
        console.log('column.data', column.data);

        var arrayOfArray = [['Task', 'sdd']];
            $.each(column.data, function(i, e){
                  arrayOfArray.push([i, e]);
            }) ;



                var data = google.visualization.arrayToDataTable(arrayOfArray);

                var options = {
                    title: column.name,
                    backgroundColor: 'transparent',
                    pieSliceBorderColor: 'black'
                };

                var chart = new google.visualization.PieChart(document.getElementById(column.id));

                chart.draw(data, options);
    </#list>
        }


    });

</script>