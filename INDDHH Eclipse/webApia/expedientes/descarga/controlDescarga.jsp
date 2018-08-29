<%@page import="java.util.HashMap"%>
<%@page import="com.dogma.controller.ThreadData"%>
<%@page import="com.dogma.UserData"%>
<%@page import="uy.com.st.adoc.expedientes.constantes.Values"%>
<%@page import="uy.com.st.documentum.seguridad.Base64"%>
<%@page import="uy.com.st.adoc.expedientes.descarga.ControlDescarga"%>
<%@page trimDirectiveWhitespaces="true"%>

<%

	response.setHeader("Pragma", "no-cache");
	response.setHeader("Cache-Control", "no-store");
	response.setDateHeader("Expires", -1);

	String tipo = request.getParameter(Values.PARAM_TIPO);

	String tarea = request.getParameter(Values.PARAM_TAREA);

	String nroAct = request.getParameter(Values.PARAM_NRO_ACT);

	String nameArchivo = request.getParameter(Values.PARAM_NAME_ARCHIVO);
	if (nameArchivo != null && !nameArchivo.equals("")) {
		nameArchivo = new Base64().decode(nameArchivo);
	}

	String nroExp = request.getParameter(Values.PARAM_NRO_EXP);
	if (nroExp != null && !nroExp.equals("")) {
		nroExp = new Base64().decode(nroExp);
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

	UserData uData = ThreadData.getUserData();
	String usuario = "";

	if (uData != null) {
		usuario = uData.getUserId() + "";
	}

	int envId = uData.getEnvironmentId();
	int langId = uData.getLangId();
	
	String descargar = "pendiente";
	
	if (nameArchivo != null && nameArchivo != "" && tipo.equals(Values.VAL_VER_ACT_CA)) {
		if (nameArchivo.startsWith("Caratula-")) {
			descargar = "caratula";
		}
	}

	if (descargar.equals("caratula")) {
		response.getWriter().write("si");
	}

	if (descargar.equals("pendiente")) {
		
		HashMap<String, Object> hash = uData.getUserAttributes();
		if (hash == null) {
			hash = new HashMap<String, Object>();
		}
		
		System.out.println("entro");
		ControlDescarga cd = new ControlDescarga();
		
		String control = cd.puedeDescargarArchivo(envId , langId , tipo , nroExp , nroAct , nameArchivo , tarea , usuario);

		if (control.equals("si")) {

			hash.put("nroExp", nroExp);
			uData.setUserAttributes(hash);
			response.getWriter().write("si");

		} else if (control.equals("no_borrados")){
			
			System.out.println("entro no_borrados");
			hash.put("nroExp", "");
			uData.setUserAttributes(hash);
			response.getWriter().write("no_borrados");
			
		} else {
			System.out.println("entro");
			hash.put("nroExp", "");
			uData.setUserAttributes(hash);
			response.getWriter().write("no");

		}

	}
	
%>