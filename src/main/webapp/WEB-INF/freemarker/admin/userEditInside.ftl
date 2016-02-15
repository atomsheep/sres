<@spring.bind "user.id" />

<h2><#if spring.status.value??>Edit<#else>Create a new</#if> User</h2>

<form action="${this_url}" name="userForm" method="post">
<#if pageNumber??>
<input type="hidden" name="p" value="${pageNumber?c}"/>
</#if>
<#if pageSize??>
<input type="hidden" name="s" value="${pageSize?c}"/>
</#if>
<table summary="">

<!-- id: Id -->
<@spring.bind "user.id" />
<tr class="hidden">
<th>ID</th>
<td>

<input type="hidden" class="text" name="${spring.status.expression}" value="<#if spring.status.value??><#if spring.status.value?is_number>${spring.status.value?c}<#else>${spring.status.value?html}</#if></#if>" />

</td>
<td>

<#if spring.status.errorMessages?has_content>
<div class="errorMessage">
<#list spring.status.errorMessages as error>
<p>${error}</p>
</#list>
</div>
</#if>
</td>
</tr>
<!-- userName: User Name -->
<@spring.bind "user.userName" />
<tr>
<th>User Name</th>
<td>

<input type="text" class="text" name="${spring.status.expression}" value="<#if spring.status.value??><#if spring.status.value?is_number>${spring.status.value?c}<#else>${spring.status.value?html}</#if></#if>" />

</td>
<td>

<#if spring.status.errorMessages?has_content>
<div class="errorMessage">
<#list spring.status.errorMessages as error>
<p>${error}</p>
</#list>
</div>
</#if>
</td>
</tr>
<tr>
<td colspan="3">
<input name="submit" type="submit" value="Save" />
<input name="reset" type="reset" value="Reset" />
</td>
</tr>

</table>
</form>

<div id="bottomNav">
<#--
<a href="${baseUrl}/admin.do">Back to Admin List</a>
-->
<a href="userList.do?aa=list<#if pageNumber??>&amp;p=${pageNumber?c}</#if><#if pageSize??>&amp;s=${pageSize?c}</#if>">Back to User list</a>
</div>

<script type="text/javascript">
<!--
function presetValue() {
}

presetValue();
//-->
</script>
