<%@page import="com.dogma.bean.GenericBean"%><%@page import="com.dogma.Parameters"%><jsp:useBean id="dBean" scope="session" class="com.dogma.bean.administration.CubeBean"></jsp:useBean><%
response.setCharacterEncoding(Parameters.APP_ENCODING);
response.setContentType("text/xml");
String tableName = null;
if (request.getParameter("tableName")!=null){
	tableName = request.getParameter("tableName").toString();
}
Integer dbConId=(!"null".equals(request.getParameter("dbConId"))?new Integer(request.getParameter("dbConId")):null);
String xml = dBean.getColumnsXML(request, tableName, dbConId);
out.clear();
out.print(xml);
%>