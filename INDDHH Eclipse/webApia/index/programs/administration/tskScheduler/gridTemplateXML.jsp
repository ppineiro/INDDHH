<%@page import="com.dogma.Parameters"%><jsp:useBean id="dBean" scope="session" class="com.dogma.bean.administration.TaskSchedulerBean"></jsp:useBean><%
response.setCharacterEncoding(Parameters.APP_ENCODING);
response.setContentType("text/xml");
String xml = dBean.getGridTskSchedulerFromTemplate(request, new Integer(request.getParameter("tempId")), new Integer(request.getParameter("calId")), request.getParameter("txtWeekSel"));
out.clear();
out.print(xml);
%>