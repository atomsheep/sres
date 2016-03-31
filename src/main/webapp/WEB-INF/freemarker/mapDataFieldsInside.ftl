<h1>Map Data Fields</h1>

<#assign record = list?first/>

<form action="${baseUrl}/user/importGrade" method="post">
    <input type="hidden" name="id" value="${id}"/>
    <input type="hidden" name="filename" value="${filename}"/>
    <input type="hidden" name="size" value="${record?size}"/>

    <input type="checkbox" name="hasHeader" checked="checked"/> Has header in CSV file?

    <table>
        <tr>
            <td></td>
            <td>username</td>
            <td>
                <select name="username">
                    <option value="-1"></option>
                    <#list record as r>
                        <option value="${r_index}" <#if r_index == 0>selected="selected"</#if>  > ${r}</option>
                    </#list>
                </select>
            </td>
        </tr>
    <#list record as r>
        <tr>
            <td>
                <input type="checkbox" name="extra${r_index?c}" <#if (r_index >= 1)> checked="checked"</#if>/>
            </td>
            <td>
                name:<input type="text" name="name${r_index?c}" value="${r?html}"
                    <#if (r_index < 1)>disabled="disabled"</#if>/>
                description: <input type="text" name="description${r_index?c}" value=""
                                    <#if (r_index < 1)>disabled="disabled"</#if>/>

            </td>
            <td>
                <select name="value${r_index?c}" <#if (r_index < 1)>disabled="disabled"</#if>>
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


</script>