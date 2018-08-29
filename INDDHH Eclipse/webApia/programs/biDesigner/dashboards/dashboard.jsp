<%@page import="com.dogma.Parameters"%><jsp:useBean id="dBean" scope="session" class="com.dogma.bean.administration.DashboardBean"></jsp:useBean><%
if("true".equals(request.getParameter("setSize"))){
	dBean.setDashboardVoWidth(new Double(request.getParameter("width")));
	dBean.setDashboardVoHeight(new Double(request.getParameter("height")));
}else{
	String xml = "";
	response.setCharacterEncoding(Parameters.APP_ENCODING);
	response.setContentType("text/xml");
	xml = dBean.getDashboardXML();
	out.clear();
	out.print(xml);
}
%>
