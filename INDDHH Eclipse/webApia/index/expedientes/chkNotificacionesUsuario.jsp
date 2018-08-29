<%response.setCharacterEncoding(com.dogma.Parameters.APP_ENCODING);%>
<%@page import="java.util.ArrayList"%>
<%@page import="uy.com.st.adoc.expedientes.helper.Helper"%>
<%@page import="uy.com.st.adoc.mensajes.MensajeDAO"%>
<%
//no dejamos que la pagina se cache
response.setHeader("Pragma","no-cache");
response.setHeader("Cache-Control","no-store");
response.setDateHeader("Expires",-1); 
%>
<% 

com.dogma.UserData uData = (com.dogma.UserData)session.getAttribute("sessionAttribute");
int currentLanguage = 1;
Integer environmentId = 1001;
MensajeDAO mensajeDao = new MensajeDAO();

if (uData!= null){
currentLanguage = uData.getLangId();
environmentId = uData.getEnvironmentId();
}

try {		
	String usr = request.getParameter("param").toString();
	Helper h = new Helper();	
	ArrayList<String> arr = h.getNotificacionesDeUsuario(usr,environmentId);
	out.clearBuffer();
	for (int i=0;i<arr.size();i++){
		out.print( arr.get(i) + "<br>");
	}		
} catch (Exception e) {
	//out.print( "ERROR en getMensaje.jsp: " + e.getMessage() );	
}		
%>
