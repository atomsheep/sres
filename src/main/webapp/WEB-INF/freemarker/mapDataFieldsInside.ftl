<@showProgress 5 5/>

<h1>Map Data Fields</h1>


<form action="${baseUrl}/user/importUserData" method="post">
    <input type="hidden" name="id" value="${id}"/>
    <input type="hidden" name="filename" value="${filename}"/>
    <input type="hidden" name="size" value="${record?size}"/>

    <input type="checkbox" name="hasHeader" checked="checked"/> Has header in CSV file?

    <table>
        <tr class="fieldRow">
            <td></td>
            <td>
                Identifier field:
                <select name="sres_id" class="form-control">
                <#list studentFields as f>
                    <option value="${f?html}"> ${f?html}</option>
                </#list>
                </select>
            </td>
            <td>
                Identifier field in CSV:
                <select name="csv_id" class="form-control">
                <#list record as r>
                    <option value="${r_index}"> ${r?html}</option>
                </#list>
                </select>
            </td>
        </tr>
        <tr class="fieldRow">
            <td>
                <input type="checkbox" name="extra"/>
            </td>
            <td>select all</td>
            <td></td>
        </tr>
        <tr>
            <td></td>
            <th>Column name</th>
            <th>Column description</th>
        </tr>
    <#list record as r>
        <tr class="fieldRow">
            <td>
                <input type="checkbox" name="extra${r_index?c}" class="checkField" <#if (r_index >= 1)>
                       checked="checked"</#if>/>
            </td>
            <td>
                <input type="text" name="name${r_index?c}" class='form-control' value="${r?html}"
                       <#if (r_index < 1)>disabled="disabled"</#if>/>
            </td>
            <td>
                <input type="text" name="description${r_index?c}" value="" class='form-control'
                       <#if (r_index < 1)>disabled="disabled"</#if>/>
            </td>
            <td>
                <select name="value${r_index?c}" class="form-control" <#if (r_index < 1)>disabled="disabled"</#if>>
                    <option value="-1"></option>
                    <#list record as rr>
                        <option value="${rr_index}" <#if r_index == rr_index>selected="selected"</#if>  > ${rr}</option>
                    </#list>
                </select>
            </td>
        </tr>
    </#list>
    </table>

    <input type="submit" class="btn btn-default btn-primary" value="Go"/>

</form>

<script type="text/javascript">

    $(function () {

        $('.checkField').on('change', function () {
            var slf = $(this);
            var name = slf.attr('name');
            var num = name.substring(5, name.length);
            if (slf.is(':checked')) {
                $('[name=name' + num + ']').removeAttr('disabled');
                $('[name=description' + num + ']').removeAttr('disabled');
                $('[name=value' + num + ']').removeAttr('disabled');
            } else {
                $('[name=name' + num + ']').attr('disabled', 'disabled');
                $('[name=description' + num + ']').attr('disabled', 'disabled');
                $('[name=value' + num + ']').attr('disabled', 'disabled');
            }
        });

        $('[name=extra]').on('change', function () {
            var slf = $(this);
            if (slf.is(':checked'))
                $('.checkField').prop('checked', true);
            else
                $('.checkField').prop('checked', false);
            $('.checkField').change();
        });
    });

</script>