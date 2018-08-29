<%@page import="com.dogma.Parameters"%><jsp:useBean id="dBean" scope="session" class="com.dogma.bean.administration.TaskSchedulerBean"></jsp:useBean><%
response.setCharacterEncoding(Parameters.APP_ENCODING);
response.setContentType("text/xml");
String xml = "";
String monday = dBean.getMonday(request, request.getParameter("monday"), request.getParameter("act"));
Integer calId = null;
Integer fracc = null;
Integer ovrAsgn = null;
Integer tskSchId = null;

if (request.getParameter("calId")!=null && !"".equals(request.getParameter("calId")) && !"null".equals(request.getParameter("calId"))){
	calId = Integer.valueOf(request.getParameter("calId"));
}
if (request.getParameter("fracc")!=null && !"".equals(request.getParameter("fracc")) && !"null".equals(request.getParameter("fracc"))){
	fracc = Integer.valueOf(request.getParameter("fracc"));
}
if (request.getParameter("ovrAsgn")!=null && !"".equals(request.getParameter("ovrAsgn")) && !"null".equals(request.getParameter("ovrAsgn"))){
	ovrAsgn = Integer.valueOf(request.getParameter("ovrAsgn"));
}
if (request.getParameter("tskSchId") != null && !"".equals(request.getParameter("tskSchId"))){
	tskSchId = Integer.valueOf(request.getParameter("tskSchId"));
}

if ("deleteWeek".equals(request.getParameter("act"))){
	xml = dBean.deleteActualWeek(request, tskSchId, fracc, calId, monday, ovrAsgn);
}else{
	xml = dBean.getGridTskScheduler(request, tskSchId, fracc, calId, monday, ovrAsgn);
}
out.clear();
out.print(xml);
%>