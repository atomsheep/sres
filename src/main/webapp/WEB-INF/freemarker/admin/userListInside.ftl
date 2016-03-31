

<h2>List All User</h2>

<#if pager.elements?size = 0>
<p>No records.</p>
<#else>

<form action="" name="listForm">
<#if pageNumber??>
<input type="hidden" name="p" value="${pager.pageNumber?c}"/>
</#if>
<#if pageSize??>
<input type="hidden" name="s" value="${pager.pageSize?c}"/>
</#if>
<table summary="">
<thead>
<tr>
<th>
<input type="checkbox" name="all" onclick="if(isChecked(this)){checkElement(this.form.id)}else{clearElementValue(this.form.id)}"/>
#
</th>
<th>name</th>
<th>First Name</th>
<th>Last Name</th>
<th>Login Times</th>
<th>First Login Time</th>
<th>Last Login Time</th>
<th>Online Time(ms)</th>
<th>School</th>
<th>Year</th>
<th>Run</th>
<th></th>
</tr>
</thead>
<tbody>
<#list pager.elements as entity>
<tr>
<td><input type="checkbox" name="id" value="${entity.id?c}"/></td>
<td><a href="userEdit.do?id=${entity.id?c}<#if pageNumber??>&amp;p=${pager.pageNumber?c}</#if><#if pageSize??>&amp;s=${pager.pageSize?c}</#if>">${entity.meaningfulName}</a></td>
<td>
${entity.firstName!?string}
</td>
<td>
${entity.lastName!?string}
</td>
<td>
${entity.loginTimes!?string}
</td>
<td>
${entity.firstLoginTime!?string}
</td>
<td>
${entity.lastLoginTime!?string}
</td>
<td>
${entity.onlineTime!?string}
</td>
<td>
${entity.school!?string}
</td>
<td>
${entity.year!?string}
</td>
<td>
${entity.run!?string}
</td>
<td><a href="userDelete.do?id=${entity.id?c}<#if pageNumber??>&amp;p=${pager.pageNumber?c}</#if><#if pageSize??>&amp;s=${pager.pageSize?c}</#if>" onclick="return deleteConfirm();">delete</a></td>
</tr>
</#list>
 </tbody>
</table>
</form>

<#if pager.lastPageNumber &gt; 1>
<div id="pager">
<form method="get" action="" name="pagerForm">
<#list pager.paramListWithoutPageNumber as param>
<input type="hidden" name="${param.name?html}" value="${param.value?html}" />
</#list>
<a href="${pager.firstLink?html}">first page</a> |
<a href="${pager.previousLink?html}">previous page</a> |
<a href="${pager.nextLink?html}">next page</a> |
<a href="${pager.lastLink?html}">last page</a>
${pager.pageNumber}/${pager.lastPageNumber}
<input type="text" name="p" size="2" maxlength="${pager.lastPageNumber?length}" value="${pager.pageNumber?c}" />
</form>
</div>
</#if>

</#if>

<div id="bottomNav">
<!--
<a href="${baseUrl}/admin.do">Back to Admin List</a>
-->
<a href="userEdit.do?aa=new<#if pageNumber??>&amp;p=${pager.pageNumber?c}</#if><#if pageSize??>&amp;s=${pager.pageSize?c}</#if>">Create a new User</a>
<#if pager.elements?size &gt; 0>
<a href="#" onclick="return deleteRecords();">Delete selected User</a>
</#if>
</div>

