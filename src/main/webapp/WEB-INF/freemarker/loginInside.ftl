<h1>Login</h1>

<div style="max-width: 600px; border: 1px solid green; padding: 10px; margin: 10px 0; font-size: 120%">
    For first time user, just input your normal university username, or your email as username, and input a password you
    can remember. DO NOT USE ANY VALUABLE PASSWORD. Next time, make sure you input the same username and password.
</div>

<form action="${baseUrl}/login" method="post">
    <input name="from" type="hidden" value="${fromUrl!}"/>

    <div class="form-group">
        <label for="username">Username</label>
        <input type="text" class="form-control" name="username" id="username" placeholder="Username" style="max-width: 600px"/>
    </div>
    <div class="form-group">
        <label for="password">Password</label>
        <input type="password" class="form-control" name="password" id="password" placeholder="Password" style="max-width: 600px"/>
    </div>
    <button type="submit" class="btn btn-default">Submit</button>
</form>