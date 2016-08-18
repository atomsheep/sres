<div class="container-fluid" style="position:absolute;top:0;bottom:0;right:0;left:0;">
<#if !pageName?? || pageName != "home">

    <div style="height: 50px;position: absolute;left: 0;right: 0;">
        <a href='${baseUrl}/user'>
           <#-- <img height="32" src="/sres/assets/img/iris_logo_dark.svg" style="float: left;margin-top: 9px;margin-left:5px"> -->
            <div style="font-size: 36px;float: right;margin: 5px 20px 0 0;font-weight:300;color:#b19209">IRIS<span style="color:#fdefbb">Analytics</span></div>
        </a>
        <#if user?has_content>
      <#-- <span style='position: absolute;bottom: 5px;right: 60px;font-style: italic;color:#333'>Welcome ${user.username!}</span> -->
        </#if>
        <div style='position:relative'>
            <#-- <div id='topMenu' style='float:right;margin:4.5px;font-size:20px;border-radius:0;background:#fff' class='btn btn-default btn-primary'><span style="margin-bottom:-5px;font-size:32px;color:#b19209" class='iris-settings'></span></div> -->

            <div class='top_buttons' style='z-index:100;margin-left:20px;display:none;position:absolute;top:44px;right:4px;background:white'>
                <a href="${baseUrl}/user/" class='menuButton'>Go home (${ICN} list)</a>
                <a href="${baseUrl}/user/" class='menuButton'>Edit user profile</a>
                <a href="${baseUrl}/user/" class='menuButton'>Get help using SRES</a>
                <a href="${baseUrl}/logout" class='menuButton'>Log out of SRES</a>
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
    <div class="row-fluid" style="position:absolute;top:0;bottom:0;right:0;left:0;">
    <#--    <div style='height:50px;margin-bottom:20px'></div> -->

