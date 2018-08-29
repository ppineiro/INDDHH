<%@page import="com.dogma.Parameters"%><%
String url = Parameters.PUSH_NOTIFICATIONS_SERVER;
if(url!=null && !url.endsWith("/")) url = url + "/";
out.clear();
out.print(url);
%>