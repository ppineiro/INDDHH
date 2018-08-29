<%@page import="com.dogma.bean.GenericBean"%><%@page import="com.dogma.Parameters"%><jsp:useBean id="gBean" scope="session" class="com.dogma.bean.GenericBean"></jsp:useBean><%
response.setCharacterEncoding(Parameters.APP_ENCODING);
response.setContentType("text/xml");
String xml = gBean.getBusClaParameterXML(new Integer(request.getParameter("busClaId")),request.getParameter("notParType"),request.getParameter("name"),request);
out.clear();
out.print(xml);
%>