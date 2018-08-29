<%response.setCharacterEncoding(com.dogma.Parameters.APP_ENCODING);%>
<%
//no dejamos que la pagina se cache
response.setHeader("Pragma","no-cache");
response.setHeader("Cache-Control","no-store");
response.setDateHeader("Expires",-1); 
%>
<%@page language="java" contentType="text/html"%>
<%@page import="java.util.*" %>
<html>
<head><title>Datos del Cliente</title></head>
<body>

<h1>DATOS DEL CLIENTE</h1>

<table align="center" border="1" cellpadding="0" cellspacing="0">
	<%
	String headername = "";
	String headervalue = "";
	for(Enumeration e = request.getHeaderNames(); e.hasMoreElements();){
		headername = (String)e.nextElement();
		headervalue = (String)request.getHeader(headername);
	%>
	<tr>
		<td><b><%=headername%>:</b></td>
		<td><%=headervalue%></td>
	</tr>
	<%}%>
	<tr>
		<td><b>IP:</b></td>
		<td><%=request.getRemoteAddr()%></td>
	</tr>
</table>

</body>
</html>
