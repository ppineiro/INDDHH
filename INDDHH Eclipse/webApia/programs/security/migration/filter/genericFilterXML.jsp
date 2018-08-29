<%@page import="com.dogma.bean.security.MigrationBean"%><jsp:useBean id="mBean" scope="session" class="com.dogma.bean.security.MigrationBean"></jsp:useBean><%
	Integer envId = new Integer(request.getParameter("envId"));
    String xml = mBean.getObjectXML(envId, request.getParameter("object"), request.getParameter("name"),request);
    out.clear();
    out.print(xml);
%>