<%@page import="uy.com.st.adoc.expedientes.solicitudes.HelperSolicitudes"%>
<%@page import="com.dogma.UserData"%>
<%@page import="com.dogma.controller.ThreadData"%>


<%
		
	String nroExp = request.getParameter("nroExp");		
	String estado = request.getParameter("estado");
	UserData uData = ThreadData.getUserData();
		
	HelperSolicitudes helper = new HelperSolicitudes();
	helper.updateExpSolicitado(uData.getEnvironmentId() , estado , nroExp , uData.getUserId());
	
	response.getWriter().write("termino");
	
%>
