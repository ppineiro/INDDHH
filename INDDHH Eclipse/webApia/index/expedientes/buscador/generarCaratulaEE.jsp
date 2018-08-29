<%@page import="st.access.BusquedaDao"%>
<%@page import="st.access.Busqueda"%>
<%@page import="java.util.ArrayList"%>
<%@page import="uy.com.st.adoc.expedientes.conf.ConfigurationManager"%>
<%@page import="com.dogma.Parameters"%>
<%@page import="com.dogma.EnvParameters"%>
<%@page import="com.dogma.UserData"%>
<%@page import="com.dogma.Configuration"%>

<%
ArrayList<Busqueda> arr = new ArrayList<Busqueda>();
BusquedaDao BDao = new BusquedaDao();
Busqueda t = new Busqueda();
int indice = 0;
if (session.getAttribute("arrExp")!=null){
	arr = (ArrayList<Busqueda>)session.getAttribute("arrExp");
	indice = Integer.parseInt( request.getParameter("indice") );
	t = arr.get(indice);
}
String nroEE = request.getParameter("nroEE").toString();
String path = BDao.getCaratula(nroEE);

System.out.println("path_web JSP: " + path);

%>
<html>
<head>
</head>
<body>

<table border="0">
<tr>	
	<td><a href='<%=path%>' target="_blank"><img src='<%=path%>' width="100%"></a></td>	
</tr>
</table>
	
</body>