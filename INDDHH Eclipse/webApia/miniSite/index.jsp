<%@page import="com.dogma.Parameters"%><%
response.setStatus(response.SC_MOVED_PERMANENTLY);
response.setHeader("Location", Parameters.ROOT_PATH);
%>