<h1>View Student List</h1>

<#if (doc.users)?has_content>
    <ul>
    <#list doc.users as user>
        <li>

        ${user.username} ${user.givenNames} ${user.surname} ${user.email}

        <#if user.extra?has_content>
        [
        <#list user.extra?keys as key>
            ${key}: ${user.extra[key]}
        </#list>
        ]
        </#if>

        </li>

      </#list>
    </ul>
</#if>
