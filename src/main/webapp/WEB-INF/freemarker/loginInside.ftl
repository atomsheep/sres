<div style='margin:0 20px'>
    <h1>Login</h1>

    <div class="slideInner">

        <div class='info_text' style='display:none;margin-left:0;margin-bottom:20px'>
            For first time user, just input your normal university username, or your email as username, and input a password you
            can remember. DO NOT USE ANY VALUABLE PASSWORD. Next time, make sure you input the same username and password.
        </div>

        <#if error?has_content>
            <div style="color: #b19209; font-weight: 300;font-size:32px;font-size:2vw;">${error}</div>
        </#if>

        <form action="${baseUrl}/login" method="post">
            <input name="from" type="hidden" value="${fromUrl!}"/>

            <div class="search_bar">
                <div class="iris-user text-icon"></div>
                <input name="username" id="username" type="text" class="iris-input" placeholder="Username"/>
                <div style="clear:both"></div>
            </div>

            <div class="search_bar">
                <div class="iris-key text-icon"></div>
                <input name="password" id="password" type="password" class="iris-input" placeholder="Password"/>
                <div style="clear:both"></div>
            </div>

            <table style="width:100%;font-size:32px;font-size:2vw;font-weight:300">
                <tr>
                    <td style="padding:0 0 10px"><button type="submit" class="top_buttons button_clear"><div class="iris-check button_icon"></div><div class="button_text">Login</div></button></td>
                </tr>
            </table>
        </form>
    </div>
</div>