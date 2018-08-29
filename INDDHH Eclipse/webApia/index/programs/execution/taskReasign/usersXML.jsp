<%@page import="com.dogma.Parameters"%><jsp:useBean id="dBean" scope="session" class="com.dogma.bean.execution.TaskReasignBean"></jsp:useBean><%
response.setCharacterEncoding(Parameters.APP_ENCODING);
response.setContentType("text/xml");
String xml = "";
Integer poolId = null;

if (request.getParameter("poolId")!=null && !"".equals(request.getParameter("poolId")) && !"null".equals(request.getParameter("poolId"))){
	poolId = Integer.valueOf(request.getParameter("poolId"));
}
out.clear();
String users = dBean.getPoolUsers(poolId);
out.print(users);
%>