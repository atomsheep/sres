<span style='font-weight:bold;float:left;margin:0 10px;color:#0886AF'>
        <a style='color:white;text-decoration: underline' href="${baseUrl}/user/">Home</a> >
        <a style='color:white;text-decoration: underline' href="${baseUrl}/user/addPaper">Add ${ICN} information</a> >
        <a style='color:white;text-decoration: underline' href="${baseUrl}/user/addPaper">Add student list</a> >
        Map student fields
    </span>
<div style='clear:both'></div>
<@showProgress 3 5/>
<form action="${baseUrl}/user/importUser" method="post">

<div style='position:absolute;top:180px;bottom:40px;left:0;right:0;overflow:hidden'>
<h1 style='margin:0 20px'>Step 3: map student fields</h1>

<div class='info_text'>Choose the fields you want to import from your student list. Later, when importing data, SRES will expect an identifier (e.g. username or student ID), to match to your users, so one of the fields you upload now should be a unique identifier field.
If the first line of your CSV file is the header, please indicate so by ticking the checkbox below.</div>

<#assign record = list?first/>

    <input type="hidden" name="id" value="${id}"/>
    <input type="hidden" name="filename" value="${filename}"/>
    <input type="hidden" name="size" value="${record?size}"/>

    <div class='info_text' style='clear:both;margin-top:20px'>
            <span class="fa-stack " style="font-size: 11px;margin-right: 5px;">
                <i class="fa fa-circle fa-stack-2x" style="color: #fff;"></i>
                <i class="fa fa-stack-1x" style="font-family:Roboto, sans-serif;color:#033141;font-weight: bold;font-size: 14px;">1</i>
            </span>
        Does your CSV file have a header in the first line?
        <input type="checkbox" name="hasHeader" checked="checked"/>
    </div>
          <#--
    <div class='info_text side1' style='padding:0;float:left;margin:20px 10px 20px 20px;width:calc(50% - 30px);height:20px;'>
        <h4 style='margin:0 0 20px;padding:10px 10px 10px 20px;background:#043B4E;'>
            <span class="fa-stack " style="font-size: 11px;margin-right: 5px;">
                <i class="fa fa-circle fa-stack-2x" style="color: #fff;"></i>
                <i class="fa fa-stack-1x" style="font-family:Roboto, sans-serif;color:#033141;font-weight: bold;font-size: 14px;">2</i>
            </span>
            Default SRES fields
        </h4>

        <table style='margin:0;width:100%;overflow-y:scroll'>
    <#list fields as f>
        <tr class="fieldRow">
            <td style='padding:0'></td>
            <td style='padding:0 5px 5px 20px'>
                <#switch f>
                    <#case 'username'>
                        Identifier
                        <#break>
                    <#case 'givenNames'>
                        Given names
                        <#break>
                    <#case 'surname'>
                        Surname
                        <#break>
                    <#case 'preferredName'>
                        Preferred name
                        <#break>
                    <#case 'email'>
                        Email
                        <#break>
                    <#case 'phone'>
                        Phone number
                        <#break>
                    <#default>
                        ${f}
                </#switch>
            </td>
            <td style='padding:0 20px 5px 0'>
                <select name="${f}" class="form-control">
                    <option value="-1"></option>
                    <#list record as r>
                        <option value="${r_index}" <#if r_index == f_index>selected="selected"</#if>  > ${r}</option>
                    </#list>
                </select>
            </td>
        </tr>
    </#list>
    </table>
    </div>  -->
    <div class='info_text side2' style='padding:0;margin:20px 20px 0;height:20px;position:relative'>
        <h4 style='margin:0 0 20px;padding:10px 10px 10px 20px;background:#043B4E;'>
            <span class="fa-stack " style="font-size: 11px;margin-right: 5px;">
                <i class="fa fa-circle fa-stack-2x" style="color: #fff;"></i>
                <i class="fa fa-stack-1x" style="font-family:Roboto, sans-serif;color:#033141;font-weight: bold;font-size: 14px;">2</i>
            </span>
            Student fields (<span class='numberChecked'>0</span> selected)
        </h4>

        <div style='overflow-y:scroll;position:absolute;top:60px;bottom:0;left:0;right:0'>
        <table>
        <tr class="fieldRow">
            <td style='padding:0 5px 5px 20px'>
                <input type="checkbox" name="extra" checked='checked'/>
            </td>
            <td style='padding:0 5px 5px 0'>Select all</td>
            <td style='padding:0 5px 5px 0'></td>
        </tr>
    <#list record as r>
        <tr class="fieldRow">
            <td style='padding:0 5px 5px 20px'>
                <input type="checkbox" name="extra${r_index?c}" class="checkField" checked="checked"/>
            </td>
            <td style='padding:0 5px 5px 0'>
                <input type="text" name="key${r_index?c}" value="${r?html}" class='form-control' />
            </td>
            <td style='padding:0 5px 5px 0'>
                <select name="value${r_index?c}" class="form-control" <#if (r_index < fields?size)>disabled="disabled"</#if>>
                    <option value="-1"></option>
                    <#list record as rr>
                        <option value="${rr_index}" <#if r_index == rr_index>selected="selected"</#if>  > ${rr}</option>
                    </#list>
                </select>
            </td>
        </tr>
    </#list>
    </table>
        </div>
    </div>

</div>

<div class='bottomPanel'>
    <button type="button" class="btn btn-default btn-primary" style='float:left;border-radius:0;padding:10px 10px 9px;border-right:1px solid #043B4E'><span class='fa fa-caret-left'></span> Go back to step 2: add student list</button>
    <button type="submit" class="btn btn-default btn-primary" style='float:right;border-radius:0;padding:10px 10px 9px;border-left:1px solid #043B4E'>Go to step 4: add student data <span class='fa fa-caret-right'></span></button>
    <button type="button" class="btn btn-default btn-primary" style="float:right;border-radius:0;padding:10px 10px 9px;border-left:1px solid #043B4E"><span class='fa fa-check'></span> Finish and return to home page</button>
</div>

</form>


<script type="text/javascript">

    $(function () {

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

        $('.checkField').on('change', function () {
            var slf = $(this);
            var name = slf.attr('name');
            var num = name.substring(5, name.length);
            if (slf.is(':checked')) {
                $('[name=key' + num + ']').removeAttr('disabled');
                $('[name=value' + num + ']').removeAttr('disabled');
            } else {
                $('[name=key' + num + ']').attr('disabled', 'disabled');
                $('[name=value' + num + ']').attr('disabled', 'disabled');
            }
            $('.numberChecked').text($('.checkField:checked').length);
        });

        $('[name=extra]').on('change', function () {
            if ($(this).is(':checked')){
                $('.checkField').prop('checked', true);
                $('.checkField').next('.sres_checkbox').addClass('fa-check-circle').removeClass('fa-circle-thin');
            }
            else{
                $('.checkField').prop('checked', false);
                $('.checkField').next('.sres_checkbox').removeClass('fa-check-circle').addClass('fa-circle-thin');
            }
            $('.checkField').change();
        });

        $('.checkField').change();


        var top = $('.side2').offset().top;
        var height = $(window).height();
        var newHeight = height - top - (40+20);
        $('.side2').css("height",newHeight+"px");

    });


</script>