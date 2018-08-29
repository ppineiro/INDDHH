<%@page import="com.dogma.bean.GenericBean"%><%@page import="com.dogma.Parameters"%><jsp:useBean id="dBean" scope="session" class="com.dogma.bean.administration.BPMNBean"></jsp:useBean><%
response.setCharacterEncoding(Parameters.APP_ENCODING);
response.setContentType("text/xml");
String xml = dBean.getQuerysXML(request,request.getParameter("proAction"),request.getParameter("busEntId"));
out.clear();
out.print(xml);
%>