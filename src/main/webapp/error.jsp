<!DOCTYPE html>
<html lang="en">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="Author" content="Educational Technology, HEDC, University of Otago"/>
    <meta name="keywords" content="sres, Educational Technology, HEDC, University of Otago"/>
    <link rel="stylesheet" type="text/css" media="screen" href="assets/css/main.css"/>
    <title>sres - Error</title>
</head>
<body>

<%@ page isErrorPage="true" %>
<%@page import="org.slf4j.Logger" %>
<%@page import="org.slf4j.LoggerFactory" %>

<%
    String errorMsg = (String) request.getAttribute("ERROR_MSG");

    // if ticket is invalid, redirect to home page of this application
    if ((errorMsg != null) && (errorMsg.indexOf("Unable to validate ProxyTicketValidator") != -1)) {
        response.sendRedirect(request.getContextPath() + "/");
        return;
    }

    Logger log = LoggerFactory.getLogger("error.jsp");

    //String servlet_name = (String) request.getAttribute("javax.servlet.error.servlet_name");
    String from_uri = (String) request.getAttribute("javax.servlet.error.request_uri");
    if (from_uri == null)
        from_uri = "unknown";
    String message = (String) request.getAttribute("javax.servlet.error.message");
    if (message == null)
        message = "";

    Integer status_code = (Integer) request.getAttribute("javax.servlet.error.status_code");
    if (status_code != null) {
        if ("".equals(message))
            message += "status code = " + status_code;
        else
            message += "<br/>status code = " + status_code;
    }

    log.error("An error occurred when you access " + from_uri);
    log.error(message, exception);

%>


<h1>Error</h1>

<p>An error occurred when you access
    <a href="<%=from_uri%>"><%=from_uri%>
    </a>.</p>

<p class="error"><%=message%>
</p>

<% if (errorMsg != null) { %>

<p class="error">Message:
    <%= errorMsg %>
</p>
<% } %>

<p>If this problem persists please contact the <a href="mailto:helpdesk@otago.ac.nz">Help Desk</a> with details
    of your activities when the error occurred.</p>

<p>Thank you.</p>


<% if (exception != null) {%>
<p>
    The name of the exception was:
    <span class="error"><%= exception.toString() %>    </span>
</p>
<p>
    The message of the exception was:
    <span class="error"><%= exception.getMessage() %>    </span>
</p>
    <% }   %>

</body>
</html>