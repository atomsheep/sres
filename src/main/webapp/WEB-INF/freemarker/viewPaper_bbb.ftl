<script>


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
</script>