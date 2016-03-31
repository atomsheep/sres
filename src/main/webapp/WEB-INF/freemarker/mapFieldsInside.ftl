<@showProgress 3 3/>

<h1>Map Fields</h1>

<#assign record = list?first/>

<form action="${baseUrl}/user/importUser" method="post">
    <input type="hidden" name="id" value="${id}"/>
    <input type="hidden" name="filename" value="${filename}"/>
    <input type="hidden" name="size" value="${record?size}"/>

    <table>
        <tr class="fieldRow">
            <td style="width: 20px">
                <input type="checkbox" name="hasHeader" checked="checked"/>
            </td>
            <td style="width: 350px">
                Has header in CSV file?
            </td>
            <td></td>
        </tr>
    <#list fields as f>
        <tr class="fieldRow">
            <td></td>
            <td>${f}</td>
            <td>
                <select name="${f}">
                    <option value="-1"></option>
                    <#list record as r>
                        <option value="${r_index}" <#if r_index == f_index>selected="selected"</#if>  > ${r}</option>
                    </#list>
                </select>
            </td>
        </tr>
    </#list>
        <tr class="fieldRow">
            <td>
                <input type="checkbox" name="extra"/>
            </td>
            <td></td>
            <td></td>
        </tr>
    <#list record as r>
        <tr class="fieldRow">
            <td>
                <input type="checkbox" name="extra${r_index?c}" class="checkField" <#if (r_index >= fields?size)> checked="checked"</#if>/>
            </td>
            <td>
                <input type="text" name="key${r_index?c}" style="width: 300px" value="${r}"<#if (r_index < fields?size)>
                       disabled="disabled"</#if>/>
            </td>
            <td>
                <select name="value${r_index?c}" <#if (r_index < fields?size)> disabled="disabled"</#if>>
                    <option value="-1"></option>
                    <#list record as rr>
                        <option value="${rr_index}" <#if r_index == rr_index>selected="selected"</#if>  > ${rr}</option>
                    </#list>
                </select>
            </td>
        </tr>
    </#list>
    </table>
          <br/>
    <input type="submit" class="btn btn-default btn-primary" value="Go"/>

</form>

<script type="text/javascript">

    $(function(){
        $('.checkField').on('change', function(){
           var slf = $(this);
            var name = slf.attr('name');
            var num = name.substring(5, name.length);
            if(slf.is(':checked')) {
                $('[name=key' + num + ']').removeAttr('disabled');
                $('[name=value' + num + ']').removeAttr('disabled');
            } else {
                $('[name=key' + num + ']').attr('disabled', 'disabled');
                $('[name=value' + num + ']').attr('disabled', 'disabled');
            }
        });

        $('[name=extra]').on('change', function(){
            var slf = $(this);
            if(slf.is(':checked')) {
                $('.checkField').prop('checked', true);
                $('.checkField').change();
            } else {
                $('.checkField').prop('checked', false);
                $('.checkField').change();
            }
        });

    });


</script>