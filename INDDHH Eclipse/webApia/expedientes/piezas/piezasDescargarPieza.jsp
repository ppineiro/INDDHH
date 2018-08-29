<%@page import="uy.com.st.adoc.expedientes.piezas.HelperPiezas"%>
<%@page import="com.dogma.UserData"%>
<%@page import="com.dogma.controller.ThreadData"%>


<%
	String paths = request.getParameter("paths").toString();
	String nro = request.getParameter("nro").toString();
	String nro_pieza = request.getParameter("pieza").toString();
	
	UserData uData = ThreadData.getUserData();
	
	HelperPiezas hp = new HelperPiezas();
	
	String pieza = hp.armarPdfPieza(paths , nro , nro_pieza , uData.getEnvironmentId() , uData.getLangId());
	response.getWriter().write(pieza);	
%>
