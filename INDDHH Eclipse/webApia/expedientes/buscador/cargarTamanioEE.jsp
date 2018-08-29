<%@page import="st.access.BusquedaDao"%>
<%@page import="st.access.Busqueda"%>
<%@page import="java.util.ArrayList"%>
<%@page import="uy.com.st.adoc.expedientes.conf.ConfigurationManager"%>
<%@page import="com.dogma.Parameters"%>
<%@page import="com.dogma.EnvParameters"%>
<%@page import="com.dogma.UserData"%>
<%@page import="com.dogma.controller.ThreadData"%>
<%@page import="com.dogma.Configuration"%>

<%
UserData uData = ThreadData.getUserData();
int envId = uData.getEnvironmentId();

BusquedaDao BDao = new BusquedaDao();
String nroEE = "";
String tamanioEE = "";
if (request.getParameter("nroEE")!=null){
	nroEE = request.getParameter("nroEE").toString();
	tamanioEE = BDao.getTamanioEE(nroEE, envId);
}

System.out.println("tamanioEE: " + tamanioEE);
%>
<%=tamanioEE%>