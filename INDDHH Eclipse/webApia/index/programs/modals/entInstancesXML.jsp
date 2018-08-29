<%@page import="com.dogma.bean.GenericBean"%><%@page import="com.dogma.Parameters"%><jsp:useBean id="gBean" scope="session" class="com.dogma.bean.GenericBean"></jsp:useBean><%
response.setCharacterEncoding(Parameters.APP_ENCODING);
response.setContentType("text/xml");
Integer busEntId = new Integer(request.getParameter("busEntId")); 
String xml = gBean.getEntInstancesXML(busEntId,request);
out.clear();
out.print(xml);
%>