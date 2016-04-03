<h1>Paper Information</h1>

<#if paper?has_content>

<p> ${paper.code!}  ${paper.name!} ${paper.year!} ${paper.semester!}        </p>


<p>Student no. <#if users?has_content>${users?size}<#else>0</#if>  </p>

<a href="${baseUrl}/user/viewStudentList/${paper._id}" class="btn btn-default btn-primary">View Student List</a>
<a href="${baseUrl}/user/addStudentList/${paper._id}" class="btn btn-default btn-primary">Import Student List</a>
<a href="${baseUrl}/user/importStudentData/${paper._id}" class="btn btn-default btn-primary">Import Student Data</a>

<a href="${baseUrl}/user/viewColumnList/${paper._id}" class="btn btn-default btn-primary">View Column List</a>

</#if>