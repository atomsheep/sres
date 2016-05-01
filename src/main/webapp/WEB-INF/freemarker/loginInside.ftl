<div style='margin-left:20px'>
<h1>Login</h1>

<div class='info_text' style='margin-left:0;margin-bottom:20px'>
    For first time user, just input your normal university username, or your email as username, and input a password you
    can remember. DO NOT USE ANY VALUABLE PASSWORD. Next time, make sure you input the same username and password.
</div>

<#if error?has_content>
    <div style="color: red; font-weight: bold">${error}</div>
</#if>

<form action="${baseUrl}/login" method="post">
    <input name="from" type="hidden" value="${fromUrl!}"/>

    <div class='input-group input-group1' style='margin-bottom:20px'>
        <span class='input-group-addon sres_name'>Username:</span>
        <input type="text" class="form-control" name="username" id="username" placeholder="Username" style="max-width: 600px"/>
    </div>

    <div class='input-group input-group1' style='margin-bottom:20px'>
        <span class='input-group-addon sres_name'>Password:</span>
        <input type="password" class="form-control" name="password" id="password" placeholder="Password" style="max-width: 600px"/>
    </div>

    <button type="submit" class="btn btn-default btn-primary">Submit</button>
</form>
</div>