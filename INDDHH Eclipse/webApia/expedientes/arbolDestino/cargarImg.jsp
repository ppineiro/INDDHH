<%response.setCharacterEncoding(com.dogma.Parameters.APP_ENCODING);%>

<%@page import="uy.com.st.adoc.expedientes.constantes.Mensajes"%>
<%@page import="uy.com.st.adoc.expedientes.servlet.BoundSession"%>
<%@page import="uy.com.st.adoc.expedientes.helper.Helper"%>
<%@page import="uy.com.st.adoc.expedientes.util.TestUrlImg"%>
<%@page import="uy.com.st.adoc.expedientes.domain.Usr"%>
<%@page import="com.dogma.Parameters"%>
<%@page import="com.dogma.controller.ThreadData"%>
<%@page import="uy.com.st.adoc.mensajes.MensajeDAO"%>
<%@page import="uy.com.st.adoc.log.LogDocumentum"%>
<% 

response.setHeader("Pragma","no-cache");
response.setHeader("Cache-Control","no-store");
response.setDateHeader("Expires",-1); 

try {
	com.dogma.UserData uData = ThreadData.getUserData();
	
	String sessionId = session.getId();
	int currentLanguage = uData.getLangId();
	Integer environmentId = uData.getEnvironmentId(); 
	
	if (uData != null){
		currentLanguage =uData.getLangId();
		environmentId =uData.getEnvironmentId();
	}
	
	MensajeDAO mensajeDao = new MensajeDAO();
		
	String usr = request.getParameter("usr").toString();	
	String operacion = request.getParameter("op").toString();	
	
	if (operacion != null && operacion.equalsIgnoreCase("2")){
		
		/* if (session != null && session.getAttribute("BoundSession") == null){
			
			session.setAttribute("BoundSession",new BoundSession(session));
				out.println("This is the example of HttpSessionBindingListener");
		 }*/
		
		out.print(Parameters.ROOT_PATH + "/expedientes/arbolDestino/images/NoPicture.gif");	
		LogDocumentum.debug("usr: " + usr);
		String foto = new Helper().getFotoUsr(usr,environmentId,currentLanguage); //,sessionId);	
		if (TestUrlImg.executeTest(usr,environmentId,currentLanguage)){
			String urlImg = foto;
			
			out.clearBuffer();
			out.print(urlImg);
		}else{
			out.clearBuffer();
			out.print(Parameters.ROOT_PATH + "/expedientes/arbolDestino/images/NoPicture.gif");
		}
		
		out.print(Mensajes.EXP_SEPARADOR_PARAMETROS1);
		out.print("nada");
		
		
	}else{
		
		Helper h = new Helper();
		Usr u = h.getUsuarioLicencia(usr,environmentId);
		//u = h.getUsuarioNoActivo(usr,environmentId);
		out.print("nada");
		out.print(Mensajes.EXP_SEPARADOR_PARAMETROS1);
		out.print(u.isUsrLicencia());
		out.print(Mensajes.EXP_SEPARADOR_PARAMETROS1);
		
		if (u.isUsrLicencia()){
			//out.print(u.getUsrDesignadoLicencia());
			out.print(u.getUsrMsgLicencia());
		}
		out.print(Mensajes.EXP_SEPARADOR_PARAMETROS1);
		out.print(u.getUsrFechaInicioLicencia());
		out.print(Mensajes.EXP_SEPARADOR_PARAMETROS1);
		out.print(u.getUsrFechaFinLicencia());
	
	}

	
} catch (Exception e) {
	LogDocumentum.debug("Error en ejecucion ../arbolDestino/cargarImg.jsp");
	LogDocumentum.error(e.getMessage(), e);
}		
%>
