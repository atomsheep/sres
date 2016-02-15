function updateTips(tips, t) {
    tips.text(t)
        .addClass('ui-state-highlight');
    setTimeout(function () {
        tips.removeClass('ui-state-highlight', 1500);
    }, 500);
}

function checkLength(o, n, min, max, tips) {
    if (o.val().length > max || o.val().length < min) {
        o.addClass("ui-state-error");
        updateTips(tips, "Length of " + n + " must be between " + min + " and " + max + ".");
        return false;
    } else
        return true;
}

function required(o, n, tips) {
    if (o.val() == 0) {
        o.addClass("ui-state-error");
        updateTips(tips, n + " is compulsory.");
        o.focus();
        return false;
    } else
        return true;
}

/**
 * set keepAlive url and logout action
 *
 * @param keepAliveUrl      keep alive url
 * @param logoutUrl         logout url
 * @param casLogoutUrl      cas logout url
 * @param logoutConfirmMsg  logout confirmation message
 */
function initFun(keepAliveUrl, logoutUrl, casLogoutUrl, logoutConfirmMsg) {
    keepAlive(keepAliveUrl);
    $('a.logout').click(function () {
        logout(logoutUrl, casLogoutUrl, logoutConfirmMsg);
        return false;
    });
}

// script for logout
/**
 * logout
 * @param logoutUrl         logout url
 * @param casLogoutUrl      cas logout url
 * @param logoutConfirmMsg  logout confirmation message
 */
function logout(logoutUrl, casLogoutUrl, logoutConfirmMsg) {
    var url = logoutUrl;
    if (casLogoutUrl && (casLogoutUrl.length > 0)) {
        url = casLogoutUrl + '?service=' + encodeURIComponent(logoutUrl)
        console.log('logout url = ' + url);
        var msg = 'Are you sure you want to log out?';
        if (logoutConfirmMsg)
            msg = logoutConfirmMsg;
        if (confirm(msg))
            gotoLogout(url);
    } else
        gotoLogout(url);
}

// go to logout url
function gotoLogout(logoutUrl) {
    if (logoutUrl) {
        console.log('logout url = ' + logoutUrl);
        location.href = logoutUrl;
    } else
        console.warn('Logout url is not set. Please set logout url first.')
}

/**
 * keep alive
 * @param keepAliveUrl url to send request to keep alive
 * @param interval  in seconds
 */
function keepAlive(keepAliveUrl, interval) {
    // default interval 1000 seconds
    var theInterval = 1000 * 1000;
    if (interval)
        theInterval = interval * 1000;
    window.setInterval(function () {
        sendRequest(keepAliveUrl);
    }, theInterval);
}

function sendRequest(keepAliveUrl) {
    if (!keepAliveUrl) {
        console.log("Keep alive url is not set. Please set keep alive url first.");
        return;
    }
    // add timestamp to url
    var theUrl = keepAliveUrl + "?" + Math.random();
    console.log("keep alive url: " + theUrl);
    $.get(theUrl, function (json) {
        if (json.time)
            console.log("keep alive @ ", json.time);
    });
}

if (!window.console)
    window.console = {log: $.noop, debug: $.noop, info: $.noop, warn: $.noop, error: $.noop, assert: $.noop, dir: $.noop, group: $.noop, groupEnd: $.noop, time: $.noop, timeEnd: $.noop, timeStamp: $.noop};
