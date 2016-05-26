<h1 style='padding:0 20px'>Email preview</h1>

<#if user?has_content>
<div style='padding:0 20px'>
    <#if (index+1) < size>
        <a href="${baseUrl}/user/emailPreview/${(index+1)?c}?emailId=${emailId}" class="btn btn-default btn-primary btn-square right" style='margin-left:20px'>Next <span class='fa fa-caret-right'></span></a>
    </#if>
    <#if index &gt; 0>
        <a href="${baseUrl}/user/emailPreview/${(index-1)?c}?emailId=${emailId}" class="btn btn-default btn-primary btn-square right"><span class='fa fa-caret-left'></span> Previous</a>
    </#if>
    <span style="color: #eee">To</span> ${address!}<br/>
    <span style="color: #eee">Subject</span> ${subject}
</div>

<div style="border: 1px solid #eee; padding: 10px;margin:20px">
${body}
</div>

</#if>