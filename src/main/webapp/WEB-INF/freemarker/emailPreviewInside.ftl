<h1>Email preview</h1>

<#if user?has_content>
<div>
    <span style="color: #eee">To</span> ${emailAddress}
</div>

<div>
    <span style="color: #eee">Subject</span> ${subject}
</div>

<div style="border: 1px solid #eee; padding: 10px">
${body}
</div>

<div>
    <#if index &gt; 0>
        <a href="${baseUrl}/user/emailPreview/${(index-1)?c}?emailId=${emailId}">Previous</a>
    </#if>
    <#if (index+1) < size>
        <a href="${baseUrl}/user/emailPreview/${(index+1)?c}?emailId=${emailId}">Next</a>
    </#if>
</div>
</#if>