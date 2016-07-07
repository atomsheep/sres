<h4 class='panelHeader'>Intervention log <span
        class='fa fa-times deletePanel' style='float:right'></span></h4>

<div class='innerPanel' style='top:40px;'>
    <table style='width:100%' id='intervention_table'>
        <tr>
            <th>Type</th>
            <th>Status</th>
            <th>Students</th>
            <th>Created</th>
        </tr>
    <#if interventions?has_content>
        <#list interventions as i>
            <tr>
                <td style='padding:5px 5px 0 5px;'><#if i.type! == "email" && i.status == "draft" ><a href=/sres/user/emailStudents/${i._id}>${i.type!}</a><#elseif i.type! == "email" && i.status == "send" ><a onclick="window.open('/sres/user/emailPreview?emailId=${i._id}', 'Email_Preview', 'height=600, location=no, menubar=no, toolbar=no, width=600');">${i.type!}</a><#else>${i.type!}</#if></td>
                <td style=''>${i.status!}</td>
                <td style=''><#if i.studentList?has_content>${i.studentList?size}</#if></td>
                <td style=''><#if i.created?has_content>${i.created?datetime}</#if></td>
            </tr>
        </#list>
    <#else>
        <tr>
            <td style='padding:20px;text-align:left'>No interventions found.</td>
        </tr>
    </#if>
    </table>
</div>