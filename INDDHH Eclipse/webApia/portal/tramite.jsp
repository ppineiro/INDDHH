<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.util.Hashtable"%>
<%@page import="com.dogma.Parameters"%>
<%@page import="st.constants.Labels"%>
<%@page import="st.url.TramiteHelper"%>

<%
TramiteHelper th = new TramiteHelper();

String IFRAME_ID = "ifr1";
String TITLE = "Trámites en Línea";
String URL_D = Parameters.EXTERNAL_URL;
String URL_R = Parameters.EXTERNAL_URL;
String URL_INICIO_TRAMITE = "/page/externalAccess/open.jsp?logFromFile=true&onFinish=102&env=1&type=P&entCode=1006&proCode=1033&eatt_STR_TRM_COD_TRAMITE_STR=";

if (session.getAttribute("ID_TRAMITE")!=null){
	session.removeAttribute("ID_TRAMITE");
}

int envId = 1;
if ( request.getParameter(Labels.PAR_EXT_ACC_ENV_ID) != null) {
	envId=Integer.parseInt(request.getParameter(Labels.PAR_EXT_ACC_ENV_ID));
}
String urlRetorno=th.getUrlRetorno(envId);
if (urlRetorno != null && !urlRetorno.isEmpty()) {
	URL_R=urlRetorno;
}
try{
	String parCodTramite = request.getParameter(Labels.PAR_EXT_ACC_ID);
	if(parCodTramite != null && !parCodTramite.isEmpty()){
		
		int codTramite = Integer.parseInt(parCodTramite);
		
		int busEntInstNameNum = TramiteHelper.getDefTramiteNumByCodigoUnico(codTramite, 1);
		if(busEntInstNameNum > 0){
			URL_D = Parameters.EXTERNAL_URL + URL_INICIO_TRAMITE + busEntInstNameNum;
		}
		
	}else{
		String parIdTramite = request.getParameter(Labels.PAR_EXT_ACC_TRM);
		if(parIdTramite != null && !parIdTramite.isEmpty()){
			int idTramite = Integer.parseInt(parIdTramite);
			if ( idTramite > 0 ) {
				URL_D = Parameters.EXTERNAL_URL + URL_INICIO_TRAMITE + idTramite;
			}
		} else {
			String parTitle = TramiteHelper.decode(request.getParameter(Labels.PAR_EXT_ACC_TITLE));
			String parDest = TramiteHelper.decode(request.getParameter(Labels.PAR_EXT_ACC_DESTINATION));
			String parRedir = TramiteHelper.decode(request.getParameter(Labels.PAR_EXT_ACC_REDIRECTION));
			
			if(parTitle != null && !parTitle.isEmpty()){
				TITLE = parTitle;
			}
			
			if(parDest != null && !parDest.isEmpty()){
				URL_D = parDest;
			}
			
			if(parRedir != null && !parRedir.isEmpty()){
				URL_R = parRedir;
			}
			
			String nroInt = "";
			
			if (URL_D.indexOf("numInst") != -1){
				int inicio = URL_D.indexOf("numInst") + "numInst".length() + 1;
				nroInt = URL_D.substring(inicio, URL_D.length());
				int fin = inicio + nroInt.indexOf("&");
				nroInt = URL_D.substring(inicio, fin);
			}
			
			if (URL_D.indexOf("id_tramite") != - 1){
				int inicio = URL_D.indexOf("id_tramite") + "id_tramite".length() + 1;
				nroInt = URL_D.substring(inicio, URL_D.length());				
			}
			
			if (!th.isTareaDisponible(envId, Integer.parseInt(nroInt))){				
				
				Hashtable<String, String> htPaginaMsg = new Hashtable<String, String>(); 
				htPaginaMsg.put("TIPO", "warning");
				htPaginaMsg.put("TITULO", "Trámite no disponible");
				htPaginaMsg.put("MSG", "Estimado ciudadano, el trámite ya no se encuentra disponible para ser trabajado.<br> Le fue asignado el número provisorio " + nroInt + ".<br>Para obtener más información, comuníquese con el organismo.");
				session.setAttribute("MSG_PAGINA", htPaginaMsg);
				
				URL_D = Parameters.EXTERNAL_URL + "/portal/paginaMensajes.jsp";
			}
			
		}	
	}
}catch(Exception e){
	e.printStackTrace();
}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html style='height:100%;'>
<head>
<style type="text/css">
body{
	margin: 0;
	overflow: hidden;
	height: 100%;
}

iframe{
	border: none;
}
</style>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script type="text/javascript">

	function customOnFinish(){
		document.getElementById('<%=IFRAME_ID%>').src = '<%=URL_R%>';
	}
	
	function centrarMensaje(){
		alert('lalala');
		window.location.hash = 'focusErrMsg';
	}
	
	function redirect(){		
		window.location.href = "<%=URL_D%>";
	}
	
</script>
<title><%=TITLE%></title>
</head>
<body onLoad="redirect()">
<!-- 
	<iframe id='<%=IFRAME_ID%>' style='width: 100%; height: 100%; border: 0px none; left: 0px; top: 0px;' src="<%=URL_D%>"></iframe>
 -->
</body>
</html>