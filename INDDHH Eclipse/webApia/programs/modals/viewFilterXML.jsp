<%@page import="com.dogma.bean.GenericBean"%><%@page import="com.dogma.Parameters"%><jsp:useBean id="gBean" scope="session" class="com.dogma.bean.GenericBean"></jsp:useBean><%
String xml = "";

response.setCharacterEncoding(Parameters.APP_ENCODING);
response.setContentType("text/xml");
if(request.getParameter("vwId")!=null && !"null".equals(request.getParameter("vwId"))){
	xml = gBean.getVwFilterXML(Integer.valueOf(request.getParameter("vwId")));
}
out.clear();
out.print(xml);
%>