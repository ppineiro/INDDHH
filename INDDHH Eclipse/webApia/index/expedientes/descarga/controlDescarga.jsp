<%@page import="java.util.HashMap"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.sql.SQLException"%>
<%@page import="com.dogma.controller.ThreadData"%>
<%@page import="com.dogma.DogmaException"%>
<%@page import="com.dogma.Parameters"%>
<%@page import="com.dogma.EnvParameters"%>
<%@page import="com.dogma.UserData"%>
<%@page import="uy.com.st.documentum.seguridad.Base64"%>
<%@page import="uy.com.st.adoc.expedientes.constantes.Values"%>
<%@page import="uy.com.st.adoc.expedientes.domain.Entidad"%>
<%@page import="uy.com.st.adoc.expedientes.domain.Historial"%>
<%@page import="uy.com.st.adoc.expedientes.helper.Helper"%>
<%@page import="uy.com.st.adoc.expedientes.helper.HelperExpedientes"%>
<%@page import="uy.com.st.adoc.expedientes.dao.UtilidadesDao"%>
<%@page import="uy.com.st.adoc.expedientes.dao.HistorialActuacionDao"%>
<%@page import="uy.com.st.adoc.expedientes.dao.ArchivosActuacionDao"%>
<%@page import="uy.com.st.adoc.log.LogDocumentum"%>
<%@page trimDirectiveWhitespaces="true"%>

<%
	response.setHeader("Pragma", "no-cache");
	response.setHeader("Cache-Control", "no-store");
	response.setDateHeader("Expires", -1);
	String nroExp = "";
	String tipo = "";
	String tarea = "";
	String nroAct = "";
	String nameArchivo = "";
	nroExp = request.getParameter(Values.PARAM_NRO_EXP);
	if (nroExp!=null && !nroExp.equals("")){
		nroExp = new Base64().decode(nroExp);
	}	
	tipo = request.getParameter(Values.PARAM_TIPO);
	tarea = request.getParameter(Values.PARAM_TAREA);
	nroAct = request.getParameter(Values.PARAM_NRO_ACT);
	nameArchivo = request.getParameter(Values.PARAM_NAME_ARCHIVO);
	if (nameArchivo!=null && !nameArchivo.equals("")){
		nameArchivo = new Base64().decode(nameArchivo);
	}
	HashMap<String,Object> hash = new HashMap<String,Object>();
	
	int envId = 1001;
	int currentLanguage = 1;
	UserData uData = ThreadData.getUserData();
	String usuario = "";

	if (uData != null) {
		usuario = uData.getUserId() + "";
	}

	String tokenId = "";
	if (request.getParameter("tokenId") != null) {
		tokenId = request.getParameter("tokenId").toString();
	}
	String tabId = "";
	if (request.getParameter("tabId") != null) {
		tabId = request.getParameter("tabId").toString();
	}
	String TAB_ID_REQUEST = "&tabId=" + tabId + "&tokenId=" + tokenId;

	boolean mostrarArchivo = true;

	if (tipo.equals(Values.VAL_FOLIADO)) {

		Entidad entExpediente = new UtilidadesDao()
				.getEntidadExpediente(nroExp, envId);

		//En caso de que se este en la tarea de firma y se presione el boton Descargar, dejo que el usuario 
		//vea el expediente sin importar si pertenece a la oficina donde se encuentre el mismo.
		if (tarea.equals("TSKFirma") || tarea.equals("TSKEnOE")) {
			mostrarArchivo = new Helper()
					.verificarAccesoAlExpedienteSinCheckOficina(
							entExpediente, usuario, envId);
		} else {
			mostrarArchivo = new Helper().verificarAccesoAlExpediente(
					entExpediente, usuario, envId, currentLanguage);
		}
		if (mostrarArchivo) {
			hash.put("nroExp",nroExp);
			uData.setUserAttributes(hash);
			response.getWriter().write("si");			
		} else {
			hash.put("nroExp","");
			uData.setUserAttributes(hash);
			response.getWriter().write("no");
		}
	}
	
	if(tipo.equals(Values.VAL_FOLIADO_ACT)){
		HelperExpedientes hp = new HelperExpedientes();

		//Chequeo que el usuario que esta logueado sea el que realizo la actuacion
		String archivo = "Actuacion-"+nroAct+"-"+nroExp+".pdf";
		HistorialActuacionDao oHAD = new HistorialActuacionDao();
		ArrayList<Historial> arrHistorial = null;
		try{
			arrHistorial = (ArrayList<Historial>) oHAD.obtenerHistorial(nroExp,envId,currentLanguage);
		}catch(SQLException sqle){
			LogDocumentum.error(sqle.getMessage(), sqle);
		}catch(DogmaException sqle){
			LogDocumentum.error(sqle.getMessage(), sqle);
		}

		String actuante = hp.obtenerIdUsuarioPorArchivoActuacion(archivo,nroExp,arrHistorial);

		if (!actuante.isEmpty() && actuante.equals(usuario)){
			hash.put("nroExp",nroExp);
			uData.setUserAttributes(hash);
			response.getWriter().write("si");
		} else {
			hash.put("nroExp","");
			uData.setUserAttributes(hash);
			response.getWriter().write("no");
		}
	}
	
	if (tipo.equals(Values.VAL_VER_ACT_CA)){
		HelperExpedientes hp = new HelperExpedientes();
		//Chequeo que el usuario que esta logueado sea el que realizo la actuacion
		String archivo = nroAct;
		HistorialActuacionDao oHAD = new HistorialActuacionDao();
		ArrayList<Historial> arrHistorial = null;
		try{
			arrHistorial = (ArrayList<Historial>) oHAD.obtenerHistorial(nroExp,envId,currentLanguage);
		}catch(SQLException sqle){
			LogDocumentum.error(sqle.getMessage(), sqle);
		}catch(DogmaException sqle){
			LogDocumentum.error(sqle.getMessage(), sqle);
		}
		//Si es la caratula la muestro			
		if (archivo.startsWith("Caratula-")){	
			response.getWriter().write("si");			
		}else{
			String actuante = hp.obtenerIdUsuarioPorArchivoActuacion(archivo,nroExp,arrHistorial);
			//Si el usuario que quiere ver la actuacion es el que la actuo la muestro aunque ahora ya no tenga permisos
			if (!actuante.isEmpty() && actuante.equals(usuario)){								
				hash.put("nroExp",nroExp);
				uData.setUserAttributes(hash);
				response.getWriter().write("si");
			} else {
				hash.put("nroExp","");
				uData.setUserAttributes(hash);
				response.getWriter().write("no");
			}
		}
	}
	
	if (tipo.equals(Values.VAL_ARCHIVO)){				
		//NO ES PASE MASIVO
		if (!nroExp.contains(";")){			
			Entidad entExpediente = new UtilidadesDao().getEntidadExpediente(nroExp,envId);
			String esExpedienteConfidencial = entExpediente.getATT_VALUE_3();
			//Expediente confidencial
			if (esExpedienteConfidencial.equals("2")){				
				if (nameArchivo != null && nameArchivo.startsWith(usuario+"_Act-") && nameArchivo.endsWith("-"+nroExp+".pdf")){
					mostrarArchivo = true;
				}else{
					mostrarArchivo = new Helper().verificarAccesoAlExpediente(entExpediente, usuario,envId,currentLanguage);
				}				
			}
			else{//Expediente no confidencial
				if (new Helper().esActuacionConfidencial(nameArchivo,usuario,nroExp,envId)){
					ArrayList<String> actuacionesQuePuedeVerTemp = new ArrayList<String>();
					ArrayList<String> actuacionesQuePuedeVer = new ArrayList<String>();	
					actuacionesQuePuedeVerTemp = new ArchivosActuacionDao().obtenerActuacionesQuePuedeVer(nroExp,usuario,envId);
					for (int i=0; i<actuacionesQuePuedeVerTemp.size();i++){
						actuacionesQuePuedeVer.add(usuario+"_Act-"+actuacionesQuePuedeVerTemp.get(i)+"-"+nroExp+".pdf");
						actuacionesQuePuedeVer.add("Actuacion-"+actuacionesQuePuedeVerTemp.get(i)+"-"+nroExp+".pdf");
					}
					if (new Helper().puedeVerArchivo(nameArchivo,nroExp,actuacionesQuePuedeVerTemp,envId)){
						mostrarArchivo = true;
					}
					else{
						mostrarArchivo = actuacionesQuePuedeVer.contains(nameArchivo);
					}
				}
				else{
					mostrarArchivo = true;
				}
			}
			if (tarea != null && tarea.equals("TSKFirma")){
				mostrarArchivo = true;
			}
			if (mostrarArchivo == true){
				hash.put("nroExp",nroExp);
				uData.setUserAttributes(hash);
				response.getWriter().write("si");
			}
			else{
				hash.put("nroExp","");
				uData.setUserAttributes(hash);
				response.getWriter().write("no");
			}
		}		
	}		
%>