<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="st.access.BusquedaDao"%>

<!DOCTYPE html>
<html>
	<head>
		<%
		BusquedaDao BDao = new BusquedaDao();
		
		int envId = Integer.parseInt(request.getParameter("envId"));
		String expediente = request.getParameter("exp");
		
		String htlm = BDao.getTitularesOnHTML(envId, expediente);
		response.getWriter().write(htlm);
		%>
	
	</head>
	
	<body>
	
	</body>
	
</html>