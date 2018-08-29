<%response.setCharacterEncoding(com.dogma.Parameters.APP_ENCODING);%>
<%@page import="com.dogma.Parameters"%>
<%@page import="com.dogma.UserData"%>
<%@page import="com.dogma.controller.ThreadData"%>
<%
//no dejamos que la pagina se cache
response.setHeader("Pragma","no-cache");
response.setHeader("Cache-Control","no-store");
response.setDateHeader("Expires",-1); 
%>
<%
if (session.getAttribute(Parameters.SESSION_ATTRIBUTE)!=null){
	UserData uData = ThreadData.getUserData();
	out.clearBuffer();
	out.print(uData.getUserId());
}
%>
