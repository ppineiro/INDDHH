<%@page import="com.dogma.bean.security.UserSubstituteBean"%><%@page import="com.dogma.Parameters"%><jsp:useBean id="dBean" scope="session" class="com.dogma.bean.security.UserSubstituteBean"></jsp:useBean><%
response.setCharacterEncoding(Parameters.APP_ENCODING);
response.setContentType("text/xml");
String xml = "";

xml = dBean.getSubstitutesXML(Integer.valueOf(request.getParameter("poolId")));


System.out.println(xml);
out.clear();
out.print(xml);
%>