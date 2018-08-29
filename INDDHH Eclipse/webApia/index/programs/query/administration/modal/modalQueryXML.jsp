<%@page import="com.dogma.bean.GenericBean"%><%@page import="com.dogma.Parameters"%><jsp:useBean id="dBeanModal" scope="session" class="com.dogma.bean.query.ModalBean"></jsp:useBean><%
response.setCharacterEncoding(Parameters.APP_ENCODING);
response.setContentType("text/xml");
String xml = dBeanModal.getQueryDataXML(request);
out.clear();
out.print(xml);
%>