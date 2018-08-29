<%@page import="uy.com.st.adoc.expedientes.conf.ConfigurationManager"%>
<%@page import="com.dogma.controller.ThreadData"%>
<%@page import="com.dogma.UserData"%>

<%

	UserData ud = ThreadData.getUserData();
	int envId = ud.getEnvironmentId();
	int langId = ud.getLangId();

	String limit = ConfigurationManager.getTamanioPiezas(envId , langId , true);
	
	response.getWriter().write(limit);
	
%>