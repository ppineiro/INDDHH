<%@page import="uy.com.st.adoc.expedientes.solicitudes.HelperSolicitudes"%>
<%@page import="com.dogma.UserData"%>
<%@page import="com.dogma.controller.ThreadData"%>

<%
	
	String nroExp = request.getParameter("nroExp");

	UserData uData = ThreadData.getUserData();
	int envId = uData.getEnvironmentId();
	String actuante = uData.getUserId();
	
	HelperSolicitudes hs = new HelperSolicitudes();
	
	String datos = hs.cargarDatosPaseSolicitante(envId, nroExp, actuante);
	
	response.getWriter().write(datos + "$");
	
%>
