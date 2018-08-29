<%response.setCharacterEncoding(com.dogma.Parameters.APP_ENCODING);%>
<%@page import="uy.com.st.adoc.expedientes.helper.HelperFirma"%>
<%@page import="uy.com.st.adoc.expedientes.domain.Firma"%>
<%@page import="com.dogma.Parameters"%>
<%@page import="com.dogma.UserData"%>
<%@page import="uy.com.st.adoc.expedientes.conf.ConfigurationManager"%>
<%@page import="java.net.URLDecoder"%>
<%@page import="com.dogma.controller.ThreadData"%>
<%
//no dejamos que la pagina se cache
response.setHeader("Pragma","no-cache");
response.setHeader("Cache-Control","no-store");
response.setDateHeader("Expires",-1); 
%>
<%
try {
	UserData uData = ThreadData.getUserData();	
	String nombre = request.getParameter("nombre").toString();	
	
	String nroDocumento = (String)uData.getUserAttributes().get("TMP_NRO_DOC_A_FIRMAR_STR");
	String usuario = uData.getUserId();
		
	System.out.println("**********************************************************");		
	System.out.println("******************CHK FIRMA ***********************");	
	System.out.println("nroDocumento: " + nroDocumento);
	System.out.println("usuario: " + usuario);
	System.out.println("nombre: " + nombre);
	System.out.println("**********************************************************");
	
	HelperFirma hf = new HelperFirma();
	
	Firma firma = hf.getFirmaArchivoByUsuarioAndName(nroDocumento, nombre, usuario);
	
	if (firma!=null){
		out.clearBuffer();
		out.println(firma.getNombArchivo());
	}else{
		out.clearBuffer();
	}
	
} catch (Exception e) {
	out.print( "ERROR en getParameter.jsp: " + e.getMessage() );	
}		
%>
