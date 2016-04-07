<h1>Email students</h1>

<form action="${baseUrl}/user/sendEmails" method="post">

    <div style="max-height: 200px; overflow: scroll">
        total students: ${users?size}
        <table>
        <#list users as u>
            <tr>
                <td>
                    <input type="checkbox" name="usernames" value="${u.username}"
                           checked="checked"/> ${u.username} ${u.givenNames} ${u.surname}
                </td>
            </tr>
        </#list>
        </table>
    </div>

    <table>
        <tr style="height: 50px;">
            <th>Subject</th>
            <td><input type="text" name="subject" class="form-control"/></td>
        </tr>
        <tr>
            <th>Body</th>
            <td><textarea name="body" class="form-control"></textarea></td>
        </tr>
        <tr style="height: 40px">
            <td colspan="2">
                <button type="submit" class="btn btn-default btn-primary">Send emails</button>
            </td>
        </tr>
    </table>
</form>