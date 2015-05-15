<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@page import="java.util.*" %>
<%@page import="nexcore.framework.core.data.IDataSet" %>
<%@page import="nexcore.framework.core.data.IRecordSet" %>
<%@page import="nexcore.framework.core.data.IRecord" %>
<%@page import="nexcore.framework.core.data.IResultMessage" %>
<%@page import="nexcore.framework.core.util.BaseUtils" %>
<%@page import="nexcore.framework.core.util.ExceptionUtil" %>
<%@page import="nexcore.framework.online.channel.util.*" %>
<%
	IDataSet dataSet = WebUtils.getResultDataSet(request);
	IResultMessage resultMessage = null;
	if(dataSet != null){
		resultMessage = dataSet.getResultMessage();
	}
%>
<html>
<head>
<title>DataSet</title>
<link rel="stylesheet" href="<%= request.getContextPath() %>/debug/common.css" type="text/css">
</head>
<body>
<fieldset style="background-color:#FFFFFF">
<legend>ResultMessage</legend>
<table cellpadding="2" cellspacing="0" class="contents">
	<colgroup>
		<col width="20%">
		<col width="80%">
	</colgroup>
	<tr><th>Status</th><td><%= resultMessage == null ? "&nbsp;" : resultMessage.getStatus() == IResultMessage.FAIL ? IResultMessage.STR_FAIL : IResultMessage.STR_OK %></td></tr>
	<tr><th>ID</th><td><%= resultMessage == null ? "&nbsp;" : resultMessage.getMessageId() == null ? "&nbsp;" : resultMessage.getMessageId() %></td></tr>
	<tr><th>Message</th><td><%= resultMessage == null ? "&nbsp;" : BaseUtils.getMessage(resultMessage.getMessageId(), resultMessage.getMessageParams()) %></td></tr>
	<tr><th>StackTrace</th><td><pre><%= resultMessage == null ? "&nbsp;" : resultMessage.getThrowable() == null ? "&nbsp;" : ExceptionUtil.toString(resultMessage.getThrowable()) %></pre></td></tr>
</table>
</fieldset>
<%
	if(dataSet != null){
%>
<fieldset style="background-color:#FFFFFF">
<legend>Field</legend>
<table cellpadding="2" cellspacing="0" class="contents">
	<tr align='center'>
		<th>Name</th>
		<th>Type</th>
		<th>Value</th>
	</tr>
<%
		Map<String, Object> fields = dataSet.getFieldMap();
		Iterator<Map.Entry<String, Object>> entrys = fields.entrySet().iterator();
		while(entrys.hasNext()){
			Map.Entry<String, Object> entry = entrys.next();
%>
	<tr>
		<th align='right'><%= entry.getKey() %></th>
		<th align='center'><%= entry.getValue() == null ? "&nbsp;" : entry.getValue().getClass().getName() %></th>
		<th align='left'><%= entry.getValue() %></th>
	</tr>
<%		
		}
%>	
</table>
</fieldset>
<br>
<%
		Iterator<IRecordSet> recordSets = dataSet.getRecordSets();
		while(recordSets.hasNext()){
			IRecordSet recordSet = recordSets.next();
			
%>
<fieldset style="background-color:#FFFFFF">
<legend>RecordSet - <%= recordSet.getId() %></legend>
<table cellpadding="2" cellspacing="0" class="contents">
	<tr align='center'>
<%
			for(int i=0; i<recordSet.getHeaderCount(); i++){
%>
		<th><%= recordSet.getHeader(i).getName() %></th>
<%				
			}
%>
	</tr>
<%
			for(int i=0; i<recordSet.getRecordCount(); i++){
				IRecord record = recordSet.getRecord(i);
%>
	<tr>
<%
				for(int j=0; j<recordSet.getHeaderCount(); j++){
%>					
		<td><%= record.get(j) %></td>				
<%					
				}
%>
	</tr>
<%
			}
%>	
</table>
</fieldset>
<%		
		}
	}
%>	
</body>
</html>