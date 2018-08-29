<%@page import="com.dogma.Configuration"%>
<%@page import="com.dogma.UserData"%>
<%@page import="com.dogma.controller.ThreadData"%>
<%
//no dejamos que la pagina se cache
response.setHeader("Pragma", "no-cache");
response.setHeader("Cache-Control", "no-store");
response.setDateHeader("Expires", -1);
%>
<%//=ThreadData.getUserData().getUserAttributes().get("URL_RETOMA").toString()%>
<%response.sendRedirect(ThreadData.getUserData().getUserAttributes().get("URL_RETOMA").toString());%>


