<h4 style='margin:0;padding:10px;background:#043B4E'>Data overview <span class='fa fa-times deletePanel' style='float:right'></span></h4>
<div style='position:absolute;top:40px;bottom:0;left:0;right:0;overflow-y:scroll;background:white'>
    <#list columns as c>
        <div id="${c._id}" class="${c._id} chart chart_${c_index} pieChart" style="margin:0 auto;
            ">
            <img src='${baseUrl}/assets/img/saving.gif' style='position:absolute;left:50%;margin-left:-25px;top:50%;margin-top:-10px' />
            </div>
    </#list>
</div>

    <script>
        var arrayOfColours = [
            ["#1A90C7", "#26A7E3", "#4AB6E8", "#6FC4EC", "#93D3F1", "#072736", "#0C415A", "#105C7E", "#1576A2"],
            ["#C71AAD", "#E326C7", "#E84AD0", "#F193E3", "#F6B7EC", "#36072F", "#5A0C4E", "#7E106E", "#A2158D"],
            ["#1AC78D", "#26E3A4", "#4AE8B3", "#6FECC2", "#93F1D2", "#073626", "#0C5A40", "#107E5A", "#15A273"],
            ["#C7651A", "#E37826", "#E88F4A", "#ECA56F", "#F1BC93", "#361B07", "#5A2E0C", "#7E4010", "#A25215"],
            ["#C71A1A", "#E32626", "#E84A4A", "#EC6F6F", "#F19393", "#360707", "#5A0C0C", "#7E1010", "#A21515"]
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
                colors: arrayOfColours[${c_index}% arrayOfColours.length
        ],
            chartArea: {
                width:"100%", left:20, right:20
            }
        };

            var chart = new google.visualization.PieChart(document.getElementById(column.id));
            chart.draw(data, options);

            <#if paper.uncheckedList?has_content>
                <#if paper.uncheckedList?seq_contains(c._id)>
                    $('#'+column.id).hide();
                </#if>
            </#if>

        </#list>
        }

    </script>