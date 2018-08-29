<%response.setCharacterEncoding(com.dogma.Parameters.APP_ENCODING);%>
<%@page import="uy.com.st.adoc.expedientes.constantes.Mensajes"%>
<%
//no dejamos que la pagina se cache
response.setHeader("Pragma","no-cache");
response.setHeader("Cache-Control","no-store");
response.setDateHeader("Expires",-1); 
%>
<% 
try {	
	String clave = request.getParameter("clave").toString();
	out.print( Mensajes.getMsg(clave) );		
} catch (Exception e) {
	out.print( "ERROR en getMensaje.jsp: " + e.getMessage() );	
}		
%>
