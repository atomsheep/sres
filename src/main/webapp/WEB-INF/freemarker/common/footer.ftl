<script type="text/javascript">
    <!--
    $(function () {
        var logoutUrl, casLogoutUrl;
        var keepAliveUrl = "${baseUrl}/keepAlive";
    <#if contextUrl?has_content>
        logoutUrl = "${contextUrl}/logout";
    </#if>
    <#if casLogoutUrl?has_content>
        casLogoutUrl = "${casLogoutUrl}";
    </#if>
        initFun(keepAliveUrl, logoutUrl, casLogoutUrl);
    });
    //-->
</script>
</div>
<!-- end of content -->

<div id="footer">
</div>

</div>
<!-- end of container -->
</body>
</html>
