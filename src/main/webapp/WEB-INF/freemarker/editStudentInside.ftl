<span style='font-weight:bold;float:left;margin:0 10px;color:#0886AF'>
<a style='color:white;text-decoration: underline' href="${baseUrl}/user/">Home</a> >
        <a style='color:white;text-decoration: underline' href="${baseUrl}/user/viewPaper/${paper._id}">View ${ICN}
            (${paper.code!}  ${paper.name!} ${paper.year!} ${paper.semester!})</a> >
Edit student information
</span>
<div style='clear:both'></div>

<form name="editPaperForm" method="post" action="${baseUrl}/user/savePaper">
<#if (paper._id)?has_content>
    <input type="hidden" name="_id" value="${paper._id}"/>
</#if>
    <input type="hidden" name="size" value="0"/>

    <h1 style='margin:20px 20px 0'>Edit student information
        <button type="submit" class="btn btn-default btn-primary btn-square right">Save</button>
    </h1>

    <div class='info_text'>Edit this student's information. You can directly edit any of this student's details or uploaded data.
    </div>

    <div class="box info_text side1" style='padding:0;margin:20px 10px 20px 20px;width:calc(50% - 30px);float:left'>
        <h4 style='margin:0 0 20px;padding:10px;background:#043B4E;'>Student fields</h4>
        <table style='width:100%'>
            <#list paper.studentFields as f>
                <tr>
                    <td style='padding:0 20px 5px 20px'>
                        <div class='input-group input-group4' style='width:100%'>
                            <span class='input-group-addon sres_name' style='width:150px;text-align:left'>${f}</span>
                            <input class='form-control' type="text" name="semester" value="${user.userInfo[f]}"
                                style='display:inline-block;'/>
                        </div>
                    </td>
                </tr>
            </#list>
        </table>
    </div>

    <div class="box info_text side2" style='position:relative;padding:0;margin:20px 20px 20px 10px;width:calc(50% - 30px);float:left'>
        <h4 style='margin:0 0 20px;padding:10px;background:#043B4E;'>Student data</h4>

        <table style='width:100%;'>

            <#list user.userData as ud>
                <tr>
                    <td style='padding:0 20px 5px 20px'>
                        <div class='input-group input-group4' style='width:100%'>
                            <span class='input-group-addon sres_name' style='width:150px;text-align:left'>${ud.name!}</span>
                            <input class='form-control' type="text" name="semester" value="${ud.data[0].value!}"
                                style='display:inline-block;'/>
                        </div>
                    </td>
                </tr>
            </#list>

        </table>
    </div>

</form>

<script type="text/javascript">
    $(function () {
        var top = $('.side1').offset().top;
        var height = $(window).height();
        var newHeight = height - top - (20);
        $('.side1, .side2').css("height", newHeight + "px");

        var index = 0;

        $.fn.shortText = function (str, length) {
            var item = $(this);
            var toset = str;
            if (str.length > length)
                toset = str.substring(0, length) + '...';
            item.text(toset).attr('title', str);
        };

        $('.sres_name').each(function () {
            var self = $(this);
            if (self.find("input").length == 0) {
                var text = self.text();
                self.shortText(text, 20);
            }
        });

    });
</script>

