<%@page import="com.dogma.Parameters"%><%
response.setCharacterEncoding(Parameters.APP_ENCODING);
response.setContentType("text/xml");
String xml = request.getParameter("result");
out.clear();
out.print(xml);
%>