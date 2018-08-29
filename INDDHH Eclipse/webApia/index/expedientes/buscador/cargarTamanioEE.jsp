<%@page import="st.access.BusquedaDao"%>
<%@page import="st.access.Busqueda"%>
<%@page import="java.util.ArrayList"%>
<%@page import="uy.com.st.adoc.expedientes.conf.ConfigurationManager"%>
<%@page import="com.dogma.Parameters"%>
<%@page import="com.dogma.EnvParameters"%>
<%@page import="com.dogma.UserData"%>
<%@page import="com.dogma.Configuration"%>

<%
BusquedaDao BDao = new BusquedaDao();
String nroEE = "";
String tamanioEE = "";
if (request.getParameter("nroEE")!=null){
	nroEE = request.getParameter("nroEE").toString();
	tamanioEE = BDao.getTamanioEE(nroEE);
}

System.out.println("tamanioEE: " + tamanioEE);
%>
<%=tamanioEE%>