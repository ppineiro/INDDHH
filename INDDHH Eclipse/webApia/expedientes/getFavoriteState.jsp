<%@page import="com.dogma.UserData"%>
<%@page import="com.dogma.controller.ThreadData"%>
<%@page import="st.access.Busqueda"%>


<%
UserData uData = ThreadData.getUserData();
	
String nroExp = request.getParameter("nroExp").toString();	
String user = uData.getUserId();
int envId = uData.getEnvironmentId();
	
Busqueda b = new Busqueda();
boolean resultado = !(b.obtenerEstadoFavorito(user, nroExp, envId));
response.getWriter().write(resultado + "");
%>
