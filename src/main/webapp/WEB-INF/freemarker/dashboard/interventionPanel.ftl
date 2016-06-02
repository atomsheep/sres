<h4 style='margin:0;padding:10px;background:#043B4E'>Intervention log <span
        class='fa fa-times deletePanel' style='float:right'></span></h4>

<div style='position:absolute;top:40px;left:0;bottom:0;right:0;overflow-y:scroll'>
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
                <td style='padding:5px 5px 0 5px;'>${i.type!}</td>
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