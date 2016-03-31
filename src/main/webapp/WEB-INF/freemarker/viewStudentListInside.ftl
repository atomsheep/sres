<h1>
<#if json?has_content>
    Search results
<#else>
    View Student List
</#if>
</h1>


<#list columns as c>
    <input type="checkbox" value="${c._id}"/> ${c.name}
</#list>

<h2>Filters
<#if json?has_content>
    <a href="${baseUrl}/user/viewStudentList/${id}">Back to all student list</a>
</#if>
</h2>

<form action="${baseUrl}/user/filterStudentList" method="post" name="filterForm">
    <input type="hidden" name="id" value="${id}"/>
    <input type="hidden" name="json" value=""/>

    <span class="btn btn-default newFilter">New filter</span>

    <div id="filterList">
        <div class="filterDiv">
            <div class="operatorDiv">
                <select name="join">
                    <option value="and">and</option>
                    <option value="or">or</option>
                </select>
            </div>
            Column:
            <select name="colref">
            <#list columns as c>
                <option value="${c._id}">${c.name}</option>
            </#list>
            </select>

            <select name="operator">
                <option value="$eq">equal to</option>
                <option value="$lt">less than</option>
                <option value="$lte">less than or equal to</option>
                <option value="$gt">greater than</option>
                <option value="$gte">greater than or equal to</option>
                <option value="$ne">not equal to</option>
            </select>

            <input type="text" name="value"/>

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
            <th>${c.name}</th>
        </#list>
    </tr>

    <#list results as r>
        <tr>
            <td>${r.username}</td>
            <td>${r.givenNames}</td>
            <td>${r.surname}</td>
            <td>${r.email!}</td>
            <#list r.data as d>
                <td data-id="${d.data._id}">
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

<script type="text/javascript">

    $(function () {

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
                   if(confirm('Do you want to save your changes?')) {
                       saveChanges(slf, input, oldValue);
                   }  else {
                       changeInputBackToText(slf, input, oldValue);
                   }
                });
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

    });

</script>