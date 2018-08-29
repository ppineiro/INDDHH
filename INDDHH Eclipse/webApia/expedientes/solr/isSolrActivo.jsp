<%@page import="uy.com.st.adoc.expedientes.conf.ConfigurationManager"%>
<%@page import="com.dogma.controller.ThreadData"%>
<%@page import="com.dogma.UserData"%>

<%
	ConfigurationManager cm = new ConfigurationManager();
	UserData ud = ThreadData.getUserData();
	String activo = cm.isSolrActivo(ud.getEnvironmentId(), ud.getLangId(), false);
	response.getWriter().write(activo);
%>