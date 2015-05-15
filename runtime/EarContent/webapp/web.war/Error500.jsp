<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="nexcore.framework.core.prototype.IMessageCoded"%>
<%@page import="nexcore.framework.core.message.IMessageManager"%>
<%@page import="nexcore.framework.core.ioc.ComponentRegistry"%>
<%@page import="nexcore.framework.core.ServiceConstants"%>
<%@page import="nexcore.framework.core.util.ExceptionUtil"%>
<%@page import="nexcore.framework.online.channel.util.WebUtils"%>
<%
    Throwable cause = (Throwable) request.getAttribute("javax.servlet.error.exception");
    if (cause == null) {
        cause = (Throwable) request.getAttribute("javax.servlet.jsp.jspException");
    }
    if (cause == null) {
        cause = (Throwable) request.getAttribute("nexcore.bizlogic.exception");
    }
    
    String message =  "N/A";
    IMessageManager mm = (IMessageManager) ComponentRegistry.lookup(ServiceConstants.MESSAGE);
    if (cause instanceof IMessageCoded){
        IMessageCoded imc = ((IMessageCoded)cause);
        message = mm.getMessage(imc.getMessageId(), WebUtils.getLocale(pageContext)).getName(imc.getMessageParams());
    }
    if (cause != null) {
        if (cause instanceof javax.servlet.jsp.JspException) {
            Throwable jspCause = ((javax.servlet.jsp.JspException)cause).getRootCause();
            if (jspCause != null) {
                cause = jspCause;
            }
        }
    }
%>
<html>
<head>
<title>HTTP 500</title>
<link rel="stylesheet" href="<%= request.getContextPath() %>/debug/common.css" type="text/css">
</head>
<body>
<h1>HTTP 500 : Internal Server Error</h1>
<table cellpadding="2" cellspacing="0" class="contents">
	<colgroup>
		<col width="20%">
		<col width="80%">
	</colgroup>
	<tr>
		<th>Message</th>
	    <td><pre><%=message%></pre></td>
	</tr>
	<tr>
		<th>StackTrace</th>
	    <td><pre><%= cause == null ? "" : ExceptionUtil.toString(cause) %></pre>
	    </td>
	</tr>
</table>

<jsp:include page="/ErrorDetail.jsp"/>

</body>
</html>