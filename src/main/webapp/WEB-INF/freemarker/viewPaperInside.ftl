<h1>Paper Information</h1>

<#if doc?has_content>

<p>
${doc.code!}  ${doc.name!} ${doc.year!} ${doc.semester!}        </p>

<p>Student no. ${doc.users?size}  </p>




<a href="${baseUrl}/user/viewStudentList/${doc._id}" class="btn btn-default btn-primary">View Student List</a>
<a href="${baseUrl}/user/addStudentList/${doc._id}" class="btn btn-default btn-primary">Import Student List</a>

</#if>