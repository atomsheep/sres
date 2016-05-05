<span style='font-weight:bold;float:left;margin:0 10px;color:#0886AF'>
<a style='color:white;text-decoration: underline' href="${baseUrl}/user/">Home</a> >
<a style='color:white;text-decoration: underline' href="${baseUrl}/user/viewPaper/${id}">View paper</a> >
View columns
</span>
<div style='clear:both'></div>

<h1 style='margin:20px 20px 0'>View columns</h1>

<div class='info_text'>These are the columns for this paper - columns contain student data. You can edit existing columns, or add new columns in preparation for
    adding data at a later stage (e.g. from scanning).
</div>

<#if (columns)?has_content>
<form id="resultsForm" method="post" action="">

    <div class="box info_text side1" style='padding:0;margin:20px;position:relative'>
        <h4 style='margin:0 0 20px;padding:10px;background:#043B4E;'>Columns</h4>

        <div class='topPanel'>
            <a class='btn btn-default btn-primary' id="addKeyValue"  style='border-radius:0;padding:10px 10px 9px;border-right:1px solid #043B4E' href="${baseUrl}/user/addColumn/${id}">
                Add new column
            </a>
        </div>

        <div style='position:absolute;top:80px;bottom:0;left:0;right:0;overflow-y:scroll'>
            <input name="id" type="hidden" value="${id}"/>
            <table id="studentList" width=100%>
                <tr>
                    <th style='text-align:left;border-left:none'><input type="checkbox" name="usernameAll"/>
                    </th>
                    <th style='text-align:left;'>Column name</th>
                    <th style='text-align:left;'>Description</th>
                    <th></th>
                </tr>
                <#list columns as c>
                    <tr>
                        <td style='text-align:left;border-left:none'><input type="checkbox" name="columns"/></td>
                        <td style='text-align:left'><a href="${baseUrl}/user/editColumn/${c._id}">${c.name}</a></td>
                        <td style='text-align:left'>${c.description!}</td>
                        <td style='text-align:left;border-right:none'></td>
                    </tr>
                </#list>
            </table>
        </div>
    </div>
</form>
</#if>

<script type='text/javascript'>
    $(function(){

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


        var top = $('.side1').offset().top;
        var height = $(window).height();
        var newHeight = height - top - (20);
        $('.side1').css("height", newHeight + "px");
    });
</script>