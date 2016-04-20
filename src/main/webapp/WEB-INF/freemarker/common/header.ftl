<div class="container-fluid">
<#if !pageName?? || pageName != "home">

    <div style="height: 50px;border-bottom: 1px solid #066888;background: #043B4E;position: absolute;left: 0;right: 0;">
        <a href='${baseUrl}/user'>
            <img height="40px" src="/sres/assets/img/logo1.svg" style="float: left;margin-top: 5px;margin-left:3px">
            <span style="font-size: 36px;float: left;margin-left: 5px;font-weight:bold;color:white">SRES</span>
        </a>
        <#if user?has_content>
        <span style='position: absolute;bottom: 5px;right: 60px;font-style: italic;'>Welcome ${user.username!}</span>
        </#if>
        <div style='position:relative'>
            <div id='topMenu' style='float:right;margin:4.5px;font-size:20px;border-radius:0' class='btn btn-default btn-primary'><span class='fa fa-cog'></span></div>

            <div class='top_buttons' style='z-index:100;margin-left:20px;display:none;position:absolute;top:44px;right:4px;background:white'>
                <a href="${baseUrl}/user/" class='menuButton'>Go home (${ICN} list)</a>
                <a href="${baseUrl}/user/" class='menuButton'>Edit user profile</a>
                <a href="${baseUrl}/user/" class='menuButton'>Get help using SRES</a>
                <a href="${baseUrl}/user/" class='menuButton'>Log out of SRES</a>
            </div>
        </div>

    </div>

<script type="text/javascript">

    var $topButtons = $('.top_buttons');
    $('html').on('click', function() {
        if($topButtons.is(":visible"))
            $topButtons.hide();
    });

    $('#topMenu').on('click', function(event){
        if($topButtons.is(':hidden'))
            $topButtons.show();
        else
            $topButtons.hide();
        event.stopPropagation();
    });

</script>

</#if>
    <div class="row-fluid">
        <div style='height:50px;margin-bottom:20px'></div>

