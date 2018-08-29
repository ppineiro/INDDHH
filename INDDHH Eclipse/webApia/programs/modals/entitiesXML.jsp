<%@page import="com.dogma.bean.GenericBean"%><%@page import="com.dogma.Parameters"%><jsp:useBean id="gBean" scope="session" class="com.dogma.bean.GenericBean"></jsp:useBean><%
String xml = "";

response.setCharacterEncoding(Parameters.APP_ENCODING);
response.setContentType("text/xml");
xml = gBean.getEntitiesEnvXML(request.getParameter("name"),new Integer(request.getParameter("envId")));
out.clear();
out.print(xml);
%>