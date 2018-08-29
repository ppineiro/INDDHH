<%@page import="com.dogma.bean.GenericBean"%><%@page import="com.dogma.Parameters"%><jsp:useBean id="gBean" scope="session" class="com.dogma.bean.GenericBean"></jsp:useBean><%
String xml = "";

response.setCharacterEncoding(Parameters.APP_ENCODING);
response.setContentType("text/xml");
if(request.getParameter("onlyEnv")!=null && !"null".equals(request.getParameter("onlyEnv"))){
	xml = gBean.getProfilesEnvXML(request.getParameter("name"),new Integer(request.getParameter("envId")),"true".equals(request.getParameter("exactMatch")));
} else {
	xml = gBean.getProfilesXML(request.getParameter("name"),"true".equals(request.getParameter("exactMatch")));
}
out.clear();
out.print(xml);
%>