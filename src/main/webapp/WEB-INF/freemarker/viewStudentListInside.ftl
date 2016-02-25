<h1>View Student List</h1>

<#if (results)?has_content>
<table border="1">
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
            <td>${r.email}</td>
            <#list r.data as d>
                <td>
                    <#if d.data?has_content>
                 ${d.data.value}
             </#if>

                </td>
            </#list>
        </tr>
    </#list>


</table>

</#if>
