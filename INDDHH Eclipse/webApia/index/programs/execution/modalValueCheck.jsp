<%@page import="com.dogma.Parameters"%><%
response.setCharacterEncoding(Parameters.APP_ENCODING);
response.setContentType("text/xml");
out.clear();
out.write("<?xml version=\"1.0\" encoding=\"UTF-8\"?>"+request.getParameter("check").toString());
%>