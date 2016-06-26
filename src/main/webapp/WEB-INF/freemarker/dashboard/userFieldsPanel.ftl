<#--do this better - put server side maybe?? -->
<#assign arrayOfColours = [
["#1A90C7","#26A7E3","#4AB6E8","#6FC4EC","#93D3F1","#072736","#0C415A","#105C7E","#1576A2"],
["#C71AAD","#E326C7","#E84AD0","#F193E3","#F6B7EC", "#36072F","#5A0C4E","#7E106E","#A2158D"],
["#1AC78D","#26E3A4","#4AE8B3","#6FECC2","#93F1D2", "#073626","#0C5A40","#107E5A","#15A273"],
["#C7651A","#E37826","#E88F4A","#ECA56F","#F1BC93","#361B07","#5A2E0C","#7E4010","#A25215"],
["#C71A1A","#E32626","#E84A4A","#EC6F6F","#F19393","#360707","#5A0C0C","#7E1010","#A21515"]
] />

<h4 class='panelHeader'>Student fields <span class='deletePanel fa fa-times' style='float:right;'></span></h4>

<div class='innerPanel' style='top:40px;'>
    <table id="studentList" width=100%>
            <thead>
                <th style='text-align:center;border-left:none'><input type="checkbox" name="usernameAll" checked="checked"/></th>
                <th style='text-align:left'>Field name</th>
            </thead>
            <tbody>
                <#list studentFields as f>
                    <tr>
                        <td></td>
                        <td style='text-align:left;'>${f?html}</td>
                    </tr>
                </#list>
            </tbody>
    </table>
</div>