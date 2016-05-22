<h1>Email preview</h1>

<#if user?has_content>
<div>
    <span style="color: #eee">To</span> ${emailAddress!}
</div>

<div>
    <span style="color: #eee">Subject</span> ${subject}
</div>

<div style="border: 1px solid #eee; padding: 10px">
${body}
</div>

<div>
    <#if index &gt; 0>
        <a href="${baseUrl}/user/emailPreview/${(index-1)?c}?emailId=${emailId}" class="btn btn-default btn-primary" style='border-radius:0;padding:10px 10px 9px;'><span class='fa fa-caret-left'></span> Previous</a>
    </#if>
    <#if (index+1) < size>
        <a href="${baseUrl}/user/emailPreview/${(index+1)?c}?emailId=${emailId}" class="btn btn-default btn-primary" style='border-radius:0;padding:10px 10px 9px;'>Next <span class='fa fa-caret-right'></span></a>
    </#if>
</div>
</#if>