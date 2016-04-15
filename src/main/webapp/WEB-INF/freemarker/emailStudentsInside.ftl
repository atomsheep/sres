<h1>Email students</h1>

<form action="${baseUrl}/user/sendEmails" method="post">
    <input type="hidden" name="id" value="${paper._id}"/>

    <div style="height: 100%; width: 40%; overflow: scroll; float: left">
        total students: ${users?size}
        <table>
        <#list users as u>
            <tr>
                <td>
                    <input type="checkbox" name="usernames" value="${u.username}"
                           checked="checked"/> ${u.username} (${u.givenNames} ${u.surname}) ${u.email!}
                </td>
            </tr>
        </#list>
        </table>
    </div>


    <div style="height: 100%; width: 60%">
    <table>
        <tr style="height: 50px;">
            <th style="padding-right: 10px">Subject</th>
            <td><input type="text" name="subject" class="form-control"
                       value="<#if paper.code?has_content>[From ${paper.code}]</#if> "/></td>
        </tr>
        <tr>
            <th>Body</th>
            <td><textarea name="body" class="form-control"></textarea></td>
        </tr>
        <tr style="height: 50px">
            <td></td>
            <td>
                <button type="submit" class="btn btn-default btn-primary">Send emails</button>
            </td>
        </tr>
    </table>
    </div>
</form>