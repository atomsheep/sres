<span><a style='text-decoration: underline' href="${baseUrl}/user/">Home</a> > <a style='text-decoration: underline' href="${baseUrl}/user/viewStudentList/${id}">View paper</a> > Edit columns</span>

<h1>Edit columns</h1>

<a class='btn btn-default btn-primary' id="addList" href="${baseUrl}/user/addColumn/${id}">Add a new column</a>

<h3>Column list</h3>
<#if (columns)?has_content>
<form id="resultsForm" method="post" action="${baseUrl}/user/emailStudents">
    <input name="id" type="hidden" value="${id}" />
    <table id="studentList" width=100%>
        <tr>
            <th style='text-align:left;background:#066888;border-left:none'><input type="checkbox" name="usernameAll"/></th>
            <th style='text-align:left;background:#066888;'>Column name</th>
            <th style='text-align:left;background:#066888'>Description</th>
        </tr>
        <#list columns as c>
        <tr>
            <td style='text-align:left;border-left:none'><input type="checkbox" name="columns"/></td>
            <td style='text-align:left'>${c.name}</td>
            <td style='text-align:left'>${c.description}</td>
        </tr>
        </#list>
    </table>
</form>
</#if>
