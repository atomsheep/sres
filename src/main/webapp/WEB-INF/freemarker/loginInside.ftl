<h1>Login</h1>

<form action="${baseUrl}/login" method="post">
    <input name="from" type="hidden" value="${fromUrl}"/>

    <div class="form-group">
        <label for="username">Username</label>
        <input type="text" class="form-control" name="username" id="username" placeholder="Username">
    </div>
    <div class="form-group">
        <label for="password">Password</label>
        <input type="password" class="form-control" name="password" id="password" placeholder="Password">
    </div>
    <button type="submit" class="btn btn-default">Submit</button>
</form>