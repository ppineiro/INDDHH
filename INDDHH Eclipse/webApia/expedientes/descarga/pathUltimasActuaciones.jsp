<%@page import="uy.com.st.adoc.expedientes.preview.Preview"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.dogma.UserData"%>
<%@page import="com.dogma.controller.ThreadData"%>

<%
	UserData uData = ThreadData.getUserData();
	Preview preview = new Preview();

	String expediente = request.getParameter("exp").toString();
	int nroAct = Integer.parseInt(request.getParameter("cant").toString());
	String path = preview.getUltimasActuaciones(uData.getUserId(), expediente, nroAct, uData.getEnvironmentId(), uData.getLangId());	
	response.getWriter().write(path);	
%>