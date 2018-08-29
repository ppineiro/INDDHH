
<%@page import="com.dogma.bean.GenericBean"%><%@page import="com.dogma.Parameters"%><jsp:useBean id="gBean" scope="session" class="com.dogma.bean.GenericBean"></jsp:useBean><%
response.setCharacterEncoding(Parameters.APP_ENCODING);
response.setContentType("text/xml");
String xml = "";
xml = gBean.getEnvUsersProfiles(request.getParameter("usrLogin"), gBean.getEnvId(request), request.getParameter("name"));


out.clear();
out.print(xml);
%>