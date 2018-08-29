
<%@page import="com.dogma.bean.GenericBean"%><%@page import="com.dogma.Parameters"%><jsp:useBean id="gBean" scope="session" class="com.dogma.bean.GenericBean"></jsp:useBean><%
response.setCharacterEncoding(Parameters.APP_ENCODING);
response.setContentType("text/xml");
Integer envId = new Integer(request.getParameter("envId"));
Integer poolId = new Integer(request.getParameter("poolId"));

String xml = "";
xml = gBean.getEnvPoolUsers(envId,poolId);

out.clear();
out.print(xml);
%>