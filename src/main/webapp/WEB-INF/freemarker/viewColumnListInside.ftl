<h1>View Column List</h1>


<h3>Column list</h3>
<#if (columns)?has_content>
<ul>
    <#list columns as column>

        <li>
            <#list column?keys as key>
                "${key}": "${column[key]}" <#if key_has_next>,</#if>
            </#list>

        </li>

    </#list>
</ul>
</#if>
