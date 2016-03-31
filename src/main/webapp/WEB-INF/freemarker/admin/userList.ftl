<#import "../spring.ftl" as spring />
<#assign title>List All User</#assign>
<#include "/common/head_1.ftl" />
    <script type="text/javascript">
    <!--
<#assign message1><@spring.message "delete.select.first"/></#assign>
<#assign message2><@spring.message "delete.confirm.user"/></#assign>
function deleteRecords() {
    var message1 = "${message1?js_string}";
    if(getElementValue(document.listForm.id) == "") {
        alert(message1);
        return false;
    }
    if(deleteConfirm()) {
        document.listForm.action = "userDelete.do";
        document.listForm.submit();
        return true;
    } else
        return false;
}

function deleteConfirm() {
    var message2 = "${message2?js_string}";
    return confirm(message2);
}
    //-->
    </script>
<#include "/common/head_2.ftl" />
<#include "/common/header.ftl" />

<#include "custom/*/userListInside.ftl" />

<#include "/common/footer.ftl" />
