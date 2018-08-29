<%@page import="com.dogma.vo.*"%><%@page import="com.st.util.*"%><%@page import="java.util.*"%><%@include file="../components/scripts/server/startInc.jsp" %><HTML><head><title><%=LabelManager.getName(Parameters.DEFAULT_LABEL_SET,Parameters.DEFAULT_LANG,"titSys")%></title><link href="<%=Parameters.ROOT_PATH%>/styles/<%= styleDirectory %>/css/printArea.css" rel="styleSheet" type="text/css" media="all"><link href="<%=Parameters.ROOT_PATH%>/styles/<%= styleDirectory %>/css/printTabElement.css" rel="styleSheet" type="text/css" media="all"><%if(null==request.getParameter("body")){%><%}else{%><%
String body = request.getParameter("body");
int start = body.indexOf("<script");
int end = body.indexOf("</script");
if (start == -1) {
	start = body.indexOf("<SCRIPT");
}
if (end == -1) {
	end = body.indexOf("</SCRIPT");
}
while (start != -1) {
	body = body.substring(0,start) + body.substring(end+9,body.length());
	start = body.indexOf("<script");
	end = body.indexOf("</script");
	if (start == -1) {
		start = body.indexOf("<SCRIPT");
	}
	if (end == -1) {
		end = body.indexOf("</SCRIPT");
	}
}

start = body.indexOf("<TEXTAREA id=errorText");
if (start != -1) {
	end = body.lastIndexOf("</TEXTAREA>");
	body = body.substring(0,start) + body.substring(end+12,body.length());
}
%><script src="<%=Parameters.ROOT_PATH%>/frames/print.js" <%=defer%>></script></head><body><div style="height:200px;border:1px solid black" id="printContent"><%= body %></div><table><tr><td width="100%" align="right"><button type="button" id="print" name="print" onclick="startPrint();"><%=LabelManager.getNameWAccess(labelSet,"btnStaPri")%></button></td><td><button type="button" name="btnExitPrint" id="btnExitPrint" style="display:none;" onclick="btnExit_click();" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnSal")%>" title="<%=LabelManager.getToolTip(labelSet,"btnSal")%>"><%=LabelManager.getNameWAccess(labelSet,"btnSal")%></button></td></tr></table><%}%></body></html><%@include file="../components/scripts/server/endIncTasksList.jsp" %>