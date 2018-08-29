<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.dogma.controller.ThreadData"%>
<%@page import="com.dogma.UserData"%>
<%@page import="java.util.ArrayList"%>
<%@page import="st.access.Busqueda"%>
<%@page import="st.access.BusquedaDao"%>

<!DOCTYPE html>
<html>
	<head>
	
	<%
	UserData uData = ThreadData.getUserData();
	ArrayList<Busqueda> busqueda = (ArrayList<Busqueda>) session.getAttribute("arrExp");
	
	String filtros = request.getParameter("filtros").toString();
	
	BusquedaDao BDao = new BusquedaDao();
	String html = BDao.getExportHtml(busqueda , filtros , uData.getEnvironmentId());
	
	response.getWriter().write(html);
	%>
	
	</head>
	
	<body>
	
	</body>
</html>