<%@page import="com.dogma.bean.administration.ProcessBean"%><%@page import="com.dogma.Parameters"%><jsp:useBean id="sBean" scope="session" class="com.dogma.bean.administration.ProcessBean"></jsp:useBean><%
response.setCharacterEncoding(Parameters.APP_ENCODING);
response.setContentType("text/xml");
Integer proId = new Integer(request.getParameter("proId"));
Integer busEntId = new Integer(request.getParameter("busEntId"));
Integer envId = new Integer(request.getParameter("envId"));
Integer pageNum = new Integer(request.getParameter("page"));
String xml = sBean.getXMLProAttInfo(proId,busEntId,envId,pageNum, request);

out.clear();
out.print(xml);
%>