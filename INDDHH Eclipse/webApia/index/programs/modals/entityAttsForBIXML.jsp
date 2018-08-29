<%@page import="com.dogma.bean.administration.EntitiesBean"%><%@page import="com.dogma.Parameters"%><jsp:useBean id="sBean" scope="session" class="com.dogma.bean.administration.EntitiesBean"></jsp:useBean><%
response.setCharacterEncoding(Parameters.APP_ENCODING);
response.setContentType("text/xml");
String xml = sBean.getXMLEntAttInfo(new Integer(request.getParameter("busEntId")),new Integer(request.getParameter("envId")),new Integer(request.getParameter("page")), request);

out.clear();
out.print(xml);
%>