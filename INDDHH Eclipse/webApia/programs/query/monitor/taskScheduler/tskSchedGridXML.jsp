<%@page import="com.dogma.Parameters"%><jsp:useBean id="dBean" scope="session" class="com.dogma.bean.query.TaskSchedulerMonitorBean"></jsp:useBean><%
response.setCharacterEncoding(Parameters.APP_ENCODING);
response.setContentType("text/xml");
String xml = "";
String monday = dBean.getMonday(request, request.getParameter("monday"), request.getParameter("act"));
xml = dBean.getGridTskSchedulerForExec(request, monday, request.getParameter("actualMonday"), Integer.valueOf(request.getParameter("tskSchId")), null, null, null);
out.clear();
out.print(xml);
%>