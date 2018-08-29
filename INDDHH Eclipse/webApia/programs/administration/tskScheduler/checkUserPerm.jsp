<%@page import="com.dogma.Parameters"%><jsp:useBean id="dBean" scope="session" class="com.dogma.bean.administration.TaskSchedulerBean"></jsp:useBean><%
response.setCharacterEncoding(Parameters.APP_ENCODING);
response.setContentType("text/xml");
Integer tskSchId = Integer.valueOf(request.getParameter("tskSchId"));
Integer permCheck = Integer.valueOf(request.getParameter("permCheck"));

String xml = String.valueOf(dBean.checkUserPerm(request, tskSchId, permCheck));
out.clear();
out.print(xml);
%>