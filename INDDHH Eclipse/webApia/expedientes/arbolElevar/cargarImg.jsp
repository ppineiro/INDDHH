<%response.setCharacterEncoding(com.dogma.Parameters.APP_ENCODING);%>
<%@page import="uy.com.st.adoc.expedientes.helper.Helper"%>
<%@page import="uy.com.st.adoc.expedientes.constantes.Mensajes"%>
<%@page import="uy.com.st.adoc.expedientes.util.TestUrlImg"%>
<%@page import="uy.com.st.adoc.expedientes.domain.Usr"%>
<%@page import="com.dogma.Parameters"%>
<%@page import="uy.com.st.adoc.mensajes.MensajeDAO"%>
<%@page import="uy.com.st.adoc.log.LogDocumentum"%>
<% 

response.setHeader("Pragma","no-cache");
response.setHeader("Cache-Control","no-store");
response.setDateHeader("Expires",-1); 

try {
	
	com.dogma.UserData uData = (com.dogma.UserData)session.getAttribute("sessionAttribute");
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
		out.print(Parameters.ROOT_PATH + "/expedientes/arbolDestino/images/NoPicture.gif");	
		LogDocumentum.debug"usr: " + usr);
		String foto = new Helper().getFotoUsr(usr,environmentId,currentLanguage);
		
		if (TestUrlImg.executeTest(foto,environmentId,currentLanguage)){
			String urlImg = "http://" + Mensajes.com_st_apia_expedientes_foto_servidor +
				":" +
		    	Mensajes.com_st_apia_expedientes_foto_puerto +
		    	Mensajes.com_st_apia_expedientes_foto_path + 
		    	foto + 
		    	Mensajes.com_st_apia_expedientes_foto_tipo;
			
			out.print(urlImg);
		}else{
			out.print(Parameters.ROOT_PATH + "/expedientes/arbolDestino/images/NoPicture.gif");
		}		
		out.print(Mensajes.EXP_SEPARADOR_PARAMETROS1);
		out.print("nada");
		
		
	}else{
		
		Helper h = new Helper();
		Usr u = h.getUsuarioLicencia(usr,environmentId);
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
	LogDocumentum.error(e.getMessage(), e);
}		
%>
