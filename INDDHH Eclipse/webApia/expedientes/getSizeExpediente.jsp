<%@ page import="uy.com.st.adoc.expedientes.arbolExpediente.obj.sql.Consultas"%>
<%@ page import="uy.com.st.adoc.expedientes.helper.HelperDocAdjunta"%>
<%@page import="com.dogma.controller.ThreadData"%>
<%@page import="com.dogma.UserData"%>

<%
	UserData ud = ThreadData.getUserData();
	String expediente = request.getParameter("ee").toString();
	int envId = ud.getEnvironmentId();
	int tamanio = Consultas.getTamanioTotalEE(expediente, envId);
	String size = HelperDocAdjunta.getUnitSize(tamanio);
	response.getWriter().write(size);
%>
