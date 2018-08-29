<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.util.Hashtable"%>
<%@page import="com.dogma.Parameters"%>
<%@page import="st.constants.Labels"%>
<%@page import="st.url.TramiteHelper"%>
<%
//no dejamos que la pagina se cache
response.setHeader("Pragma", "no-cache");
response.setHeader("Cache-Control", "no-store");
response.setDateHeader("Expires", -1);
%>

<%
Hashtable<String, String> htPaginaMsg = new Hashtable<String, String>(); 
htPaginaMsg.put("TIPO", "warning");
htPaginaMsg.put("TITULO", "Trámite no disponible");
htPaginaMsg.put("MSG", "No se encontró ningún trámite con los datos ingresados.");
session.setAttribute("MSG_PAGINA", htPaginaMsg);

String URL_D = Parameters.EXTERNAL_URL + "/portal/paginaMensajes.jsp";

response.sendRedirect(URL_D);
%>
