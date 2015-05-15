<%@page contentType="text/xml; charset=UTF-8" pageEncoding="UTF-8" 
%><%@page import="nexcore.framework.core.ioc.ComponentRegistry"
%><%@page import="nexcore.framework.core.Constants"
%><%@page import="nexcore.framework.core.util.BaseUtils"
%><%@page import="nexcore.framework.core.ServiceConstants"
%><%@page import="nexcore.framework.core.data.xml.*"
%><%@page import="nexcore.framework.core.data.IResultMessage"
%><%@page import="nexcore.framework.core.message.IMessageManager"
%><%@page import="nexcore.framework.core.message.IMessage"
%><%@page import="nexcore.framework.core.prototype.IMessageCoded"
%><%@page import="nexcore.framework.online.channel.util.WebUtils"
%><%@page import="org.apache.commons.lang.StringEscapeUtils"
%><%
    Throwable cause = (Throwable) request.getAttribute("javax.servlet.error.exception");
    
    if (cause == null) {
        cause = (Throwable) request.getAttribute("javax.servlet.jsp.jspException");
    }
    
    if (cause == null) {
        cause = (Throwable) request.getAttribute("nexcore.bizlogic.exception");
    }
    
    String messageId = "N/A";
    String messageName =  "N/A";
    String reason = "N/A";
    String remark = "N/A";
    String stackTrace = "N/A";
    
    IMessageManager mm = (IMessageManager) ComponentRegistry.lookup(ServiceConstants.MESSAGE);
    if (cause instanceof IMessageCoded){
        IMessageCoded imc = ((IMessageCoded)cause);
        messageId = imc.getMessageId();
        IMessage message = mm.getMessage(messageId, WebUtils.getLocale(pageContext));
        messageName = message.getName(imc.getMessageParams());
        reason = message.getReason();
        remark = message.getRemark();
    }
    if (cause != null) {
        if (cause instanceof javax.servlet.jsp.JspException) {
            Throwable jspCause = ((javax.servlet.jsp.JspException)cause).getRootCause();
            if (jspCause != null) {
                cause = jspCause;
            }
        }
    }
    if (cause != null){
        stackTrace = BaseUtils.getExceptionStackTrace(cause);
    }
    
    String transactionId = request.getParameter(Constants.TRANSACTION_ID);
    
    // print
	out.println("<?xml version=\"1.0\" encoding=\"utf-8\"?>");
	out.println("<"+JdomProcessor.ELM_RESPONSE+">");
	
	out.println("\t<"+JdomProcessor.ELM_TX+">");
	out.println("\t\t<"+JdomProcessor.ELM_TX_ID+">"+ StringEscapeUtils.escapeXml(transactionId == null ? "" : transactionId) + "</"+JdomProcessor.ELM_TX_ID+">");
	out.println("\t\t<"+JdomProcessor.ELM_TX_START_DT+">"+ StringEscapeUtils.escapeXml("N/A") + "</"+JdomProcessor.ELM_TX_START_DT+">");
	out.println("\t\t<"+JdomProcessor.ELM_TX_END_DT+">"+ StringEscapeUtils.escapeXml("N/A") + "</"+JdomProcessor.ELM_TX_END_DT+">");
	out.println("\t</"+JdomProcessor.ELM_TX+">");

	out.println("\t<"+JdomProcessor.ELM_DS+">");
	out.println("\t\t<"+JdomProcessor.ELM_DS_MSG+">");
	out.println("\t\t\t<"+JdomProcessor.ELM_DS_MSG_RESULT+">"+ StringEscapeUtils.escapeXml(IResultMessage.STR_FAIL) + "</"+JdomProcessor.ELM_DS_MSG_RESULT+">");
	out.println("\t\t\t<"+JdomProcessor.ELM_DS_MSG_ID+">"+ StringEscapeUtils.escapeXml(messageId == null ? "" : messageId) + "</"+JdomProcessor.ELM_DS_MSG_ID+">");
	out.println("\t\t\t<"+JdomProcessor.ELM_DS_MSG_NAME+">"+ StringEscapeUtils.escapeXml(messageName == null ? "" : messageName) + "</"+JdomProcessor.ELM_DS_MSG_NAME+">");
	out.println("\t\t\t<"+JdomProcessor.ELM_DS_MSG_REASON+">"+ StringEscapeUtils.escapeXml(reason == null ? "" : reason) + "</"+JdomProcessor.ELM_DS_MSG_REASON+">");
	out.println("\t\t\t<"+JdomProcessor.ELM_DS_MSG_REMARK+">"+ StringEscapeUtils.escapeXml(remark == null ? "" : remark) + "</"+JdomProcessor.ELM_DS_MSG_REMARK+">");
	out.println("\t\t\t<"+JdomProcessor.ELM_DS_MSG_EXCEPTION+">"+ StringEscapeUtils.escapeXml(stackTrace == null ? "" : stackTrace) + "</"+JdomProcessor.ELM_DS_MSG_EXCEPTION+">");
	out.println("\t\t</"+JdomProcessor.ELM_DS_MSG+">");
	out.println("\t</"+JdomProcessor.ELM_DS+">");
	out.println("</"+JdomProcessor.ELM_RESPONSE+">");
%>