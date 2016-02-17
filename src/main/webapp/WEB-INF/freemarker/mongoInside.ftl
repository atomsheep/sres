<h1>Mongo DB test</h1>

<#if list?has_content>

There are ${list?size} results.
<ul>

    <#list list as r>

        <li>
        ${r.name}
        </li>
    </#list>
</ul>
</#if>