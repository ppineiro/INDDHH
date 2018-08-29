<%@page import="uy.com.st.adoc.log.LogDocumentum"%>
<%response.setCharacterEncoding(com.dogma.Parameters.APP_ENCODING);%>
<%@page import="com.dogma.Parameters"%>
<%@page import="com.dogma.EnvParameters"%>
<%@page import="com.dogma.controller.ThreadData"%>
<%@page import="uy.com.st.adoc.expedientes.constantes.Mensajes"%>
<%@page import="com.dogma.UserData"%>
<%@page import="uy.com.st.adoc.expedientes.conf.ConfigurationManager"%>
<%@page import="com.dogma.Configuration"%>
<%@page import="uy.com.st.adoc.mensajes.MensajeDAO"%>
<%@page import="uy.com.st.adoc.log.LogDocumentum"%>
<%
response.setHeader("Pragma","no-cache");
response.setHeader("Cache-Control","no-store");
response.setDateHeader("Expires",-1); 

//**************THIS IS USED TO GET THE LABEL SET OF THE USER***************//
String styleDirectory = "default";
Integer environmentId = null;
MensajeDAO mensajeDao = new MensajeDAO();
int currentLanguage = 1;
//com.dogma.UserData uData = (com.dogma.UserData)session.getAttribute("sessionAttribute");
UserData uData = ThreadData.getUserData();
if (uData!=null) {
	environmentId = uData.getEnvironmentId();
	currentLanguage = uData.getLangId();
	styleDirectory = EnvParameters.getEnvParameter(environmentId,EnvParameters.ENV_STYLE);
}
%>

<HTML>
<HEAD>
	<script TYPE="text/javascript" LANGUAGE="javacript" SRC="toc.js"></script>
	<script TYPE="text/javascript" LANGUAGE="javascript" SRC="<%=Parameters.ROOT_PATH%>/expedientes/scripts/image.js"></script>
	<link href="toc.css" type="text/css" rel="styleSheet">

<title><%= mensajeDao.obtenerMensajePorCodigo("VAL_LBL_TITULO_PASE_OE_ARTEE_JSP_TXT", currentLanguage, environmentId)%></title>

<SCRIPT LANGUAGE=javascript>
var MSIE = window.navigator.appVersion.indexOf("MSIE")>=0;
var URL_ROOT_PATH	 	= "<%=Parameters.ROOT_PATH%>";
var URL_STYLE_PATH		= "<%=Parameters.ROOT_PATH%>/styles/<%= styleDirectory %>"
var FORCE_SYNC = true;
var TAB_ID_REQUEST = "<%="&tabId=" + request.getParameter("tabId").toString() +"&tokenId="+ request.getParameter("tokenId").toString()%>"


function fnFlash(oTitle){
	oList=document.all[oTitle.sourceIndex + 1];
	if(oList.className=="tocItemHide"){
		oList.className="tocItemShow";
		document.frmMain.tipPagina.value=oTitle.tipPag
	}else{
		oList.className="tocItemHide";
		document.frmMain.tipPagina.value=oTitle.tipPag
	}
	
}
var sep1;

function cancel(){
	window.returnValue="cancel";
	window.close();
}

function whenLoad(){  
	document.getElementById("waittoload").style.display="none";
	document.getElementById("treefield").style.display="";		
	sep1 = document.getElementById("textSeparador1").value;	
}

function ok(){
	
	/*var destino = "";
		
	destino = document.getElementById("organismoDestino").value;
	
	if (destino == "" ){
		alert("Debe elegir un destino");
	}else{	
		window.returnValue = destino;
		window.close();
	}  	
	*/
	var destino = "";
	
	destino = document.getElementById("organismoDestino").value 
		+ sep1 + document.getElementById("textNombOrganismoDestino").value
		+ sep1 + document.getElementById("textIdMesaDestino").value
		+ sep1 + document.getElementById("textMesaDestino").value;
	if (destino == "" ){
		alert("<%= mensajeDao.obtenerMensajePorCodigo("MSG_ELEGIR_UN_DESTINO_JSP", currentLanguage, environmentId)%>"); //alert("Debe elegir un destino");
	}else if (document.getElementById("textMesaDestino").value == ""){
		alert("<%= mensajeDao.obtenerMensajePorCodigo("MSG_ELEGIR_MESA_ENTRADA_JSP", currentLanguage, environmentId)%>"); //alert("Debe elegir una mesa de entrada.");
	}else{
		if (document.getElementById("textHayMEenOE").value == "0"){
			destino = "";
			alert("<%= mensajeDao.obtenerMensajePorCodigo("MSG_ORGANISMO_SIN_MESA_ENTRADA_JSP", currentLanguage, environmentId)%>"); //alert("No hay mesa de entrada para ese organismo!");
		}else{
			//var truthBeTold = window.confirm("¿Realmente desea realizar el pase?");
			//if (truthBeTold) {		
				window.returnValue = destino;
				window.close();
			//}
		}
	}  	
	
}

var ajax;

function funcionCallBackCargarUsuarios(){
	// Comprobamos si la peticion se ha completado (estado 4)
	if( ajax.readyState == 4 ){
		// Comprobamos si la respuesta ha sido correcta (resultado HTTP 200)
		if( ajax.status == 200 ){
			// Escribimos el resultado en la pagina HTML mediante DHTML
			var result = ajax.responseText;
			//alert(result);			
			document.getElementById("oPrimaryTOCUsr").innerHTML = result;
			if (result.indexOf("<table><table>") != -1){
				document.getElementById("textHayMEenOE").value = "0";				
			}else{
				document.getElementById("textHayMEenOE").value = "1";
			}
		}
	}	
}

function cargarUsuarios(flag){
	// Creamos el control XMLHttpRequest segun el navegador en el que estemos
	if( window.XMLHttpRequest )
		ajax = new XMLHttpRequest(); // No Internet Explorer
	else
		ajax = new ActiveXObject("Microsoft.XMLHTTP"); // Internet Explorer
		// Almacenamos en el control al funcion que se invocara cuando la peticion
		// cambie de estado
	
	ajax.onreadystatechange = funcionCallBackCargarUsuarios;
	// Enviamos la peticion	
	var URL = "<%=ConfigurationManager.getServerAddress(environmentId,currentLanguage) + Configuration.ROOT_PATH%>/expedientes/arbolDestino/cargarUsuarios.jsp?unidad=" + document.getElementById("textIdOficinaDestino").value + "&flag=" + flag + "&envId=" + <%=environmentId%>;					
	//alert(URL);
	ajax.open( "GET", URL, true );	
	ajax.send( "" );	
}


//Funciones para cargar Mesa de entrada
function funcionCallBackCargarMesasEntrada(){
	// Comprobamos si la peticion se ha completado (estado 4)
	if( ajax.readyState == 4 ){
		// Comprobamos si la respuesta ha sido correcta (resultado HTTP 200)
		if( ajax.status == 200 ){
			funcionCallBackCargarMesasEntradaLoaded()
		}
	}	
}

function funcionCallBackCargarMesasEntradaLoaded(){
	// Escribimos el resultado en la pagina HTML mediante DHTML
	var result = ajax.responseText;
	document.getElementById("oPrimaryTOCUsr").style.display="block";
	document.getElementById("oPrimaryTOCUsr").innerHTML = result;
	if (result.indexOf("<table><table>") != -1){
		document.getElementById("textHayMEenOE").value = "0";				
	}else{
		document.getElementById("textHayMEenOE").value = "1";
	}
}

function cargarMesasEntrada(flag){
	// Creamos el control XMLHttpRequest segun el navegador en el que estemos
	if( !MSIE ){
		ajax = new XMLHttpRequest(); // No Internet Explorer
		ajax.onload = function(){
			funcionCallBackCargarMesasEntradaLoaded();
		}
	}else{
		ajax = new ActiveXObject("Microsoft.XMLHTTP"); // Internet Explorer
		// Almacenamos en el control al funcion que se invocara cuando la peticion
		// cambie de estado
		ajax.onreadystatechange = funcionCallBackCargarMesasEntrada;
	}
	// Enviamos la peticion	
	var URL = "<%=ConfigurationManager.getServerAddress(environmentId,currentLanguage) + Configuration.ROOT_PATH%>/expedientes/arbolOrganismoExternoARTEEDestino/cargarMesasEntrada.jsp?orgext=" + document.getElementById("organismoDestino").value + "&flag=" + flag + TAB_ID_REQUEST;					
	//alert(URL);
	ajax.open( "POST", URL, false );	
	ajax.send( "" );	
}


function funcionCallbackFoto(){
	// Comprobamos si la peticion se ha completado (estado 4)
	if( ajax.readyState == 4 ){
		// Comprobamos si la respuesta ha sido correcta (resultado HTTP 200)
		if( ajax.status == 200 ){
			// Escribimos el resultado en la pagina HTML mediante DHTML
			var result = ajax.responseText;
						
			var vec = result.split("<%=Mensajes.EXP_SEPARADOR_PARAMETROS1%>");
			
			if (vec[1] == 'true'){
				if (vec[2] == ''){	
					if (!vec[4]){
						alert("<%=mensajeDao.obtenerMensajePorCodigo("MSG_USUARIO_AUSENTE_HASTA_DIA_JSP", currentLanguage, environmentId)%>.replace('<DIA>',vec[4])");
						//alert("El usuario se encuentra asuente de la oficina hasta el día: " + vec[4]);
					}else{
						alert("<%=mensajeDao.obtenerMensajePorCodigo("MSG_USUARIO_AUSENTE_JSP", currentLanguage, environmentId)%>");
					}
				}else{
					if (!vec[4]){
						alert("<%=mensajeDao.obtenerMensajePorCodigo("MSG_USUARIO_AUSENTE_HASTA_DIA_CON_MENSAJE_JSP", currentLanguage, environmentId)%>.replace('<DIA>',vec[4]).replace('<MENSAJE>',vec[2])");
						//alert("El usuario se encuentra ausente hasta el día: " + vec[4] + ".\nMensaje del usuario: " + vec[2]);
						//document.getElementById("textUsuarioDestino").value = vec[2];
					}else{
						alert("<%=mensajeDao.obtenerMensajePorCodigo("MSG_USUARIO_AUSENTE_CON_MENSAJE_JSP", currentLanguage, environmentId)%>");
					}
				}
			}else{
				//alert("El usuario no esta de licencia");
			}	
			//document.getElementById("imgFoto").width = 200;
			//document.getElementById("imgFoto").height = 200;				
			document.getElementById("imgFoto").src=vec[0];			
			//ajustarIMG(document.getElementById("imgFoto"));								
		}
	}	
}

function cargarFOTO(usr){	
	// Creamos el control XMLHttpRequest segun el navegador en el que estemos
	if( window.XMLHttpRequest )
		ajax = new XMLHttpRequest(); // No Internet Explorer
	else
		ajax = new ActiveXObject("Microsoft.XMLHTTP"); // Internet Explorer
		// Almacenamos en el control al funcion que se invocara cuando la peticion
		// cambie de estado
	
	ajax.onreadystatechange = funcionCallbackFoto;
	// Enviamos la peticion		
	var URL = "<%=ConfigurationManager.getServerAddress(environmentId,currentLanguage) + Configuration.ROOT_PATH%>/expedientes/arbolDestino/cargarImg.jsp?usr=" + usr + TAB_ID_REQUEST;
	//alert(URL);	
	ajax.open( "GET", URL, true );
	ajax.send( "" );	
}
</script>


</HEAD>

<BODY onLoad="whenLoad()">
	<form name="frmMain" id="frmMain" method="post">
		
		<input id="organismoDestino" type="hidden">		
		<input id=textSeparador1 name=textSeparador1 type="hidden" value="<%=Mensajes.EXP_SEPARADOR_PARAMETROS1%>">
		<input id=textSeparador2 name=textSeparador2 type="hidden" value="<%=Mensajes.EXP_SEPARADOR_PARAMETROS2%>">
		<input id=textHayMEenOE name=textHayMEenOE type="hidden">
		<input id=textNombOrganismoDestino name=textNombOrganismoDestino type="hidden">
		<input id=textMesaDestino name=textMesaDestino type="hidden">
		<input id=textIdMesaDestino name=textIdMesaDestino type="hidden">
		
		<input readonly id="waittoload" value="Espere un momento.." style="background-color:yellow;color:navy;position:absolute;top:120px;left:130px;display:none">
		
<table border="0" width="100%">
<tr>
	<td>
		<div id="tree" onclick="treeClick(event)">	
		<fieldset id="treefield" name="treefield" style="display:none; HEIGHT: 287px; WIDTH: 300px">
			<legend><font style="FONT-FAMILY: verdana; FONT-SIZE: 8pt;"><%=mensajeDao.obtenerMensajePorCodigo("VAL_LBL_SELECCIONAR_ORG_EXTERNO_JSP_TXT", currentLanguage, environmentId)%> <!-- Seleccionar organismo externo: --></font></legend>
			<BLOCKQUOTE CLASS="body">
				<DIV id="oTocDiv" style="BACKGROUND-COLOR: <%=Mensajes.com_st_apia_expedientes_style_arbol_destino%>; BORDER-BOTTOM: #505050 1px solid; BORDER-LEFT: #505050 1px solid; BORDER-RIGHT: #505050 1px solid; BORDER-TOP: #505050 1px solid; FONT-FAMILY: verdana; FONT-SIZE: 8pt; HEIGHT: 238px; OVERFLOW: auto; WIDTH: 341px">
				<DIV ID="oPrimaryTOC">   
				<%try{ 																							
					if (uData!=null){
						//UserData uData = (UserData)session.getAttribute(Parameters.SESSION_ATTRIBUTE);

						if (uData.getUserAttributes().get("ESTRUCTURA_JERARQUICA")!=null){
							String htmlData = (String)uData.getUserAttributes().get("ESTRUCTURA_JERARQUICA");
							out.print( htmlData );
						}else{
							LogDocumentum.debug("NO HAY DATOS EN SESSION 1" );
						}
					}else{
						LogDocumentum.debug("NO HAY DATOS EN SESSION 2 " );
					}
					LogDocumentum.debug("FIN");
				}
				catch(Exception e){e.printStackTrace();}
				%>
				</DIV>
				</DIV>
			</BLOCKQUOTE>
		</fieldset> 
	</div>
</td>
<td>&nbsp;&nbsp;</td>
<td>

<fieldset id="treefieldusr" name="treefieldusr" style="HEIGHT: 287px; WIDTH: 229px">
			<legend><font style="FONT-FAMILY: verdana; FONT-SIZE: 8pt;"><%=mensajeDao.obtenerMensajePorCodigo("VAL_LBL_MESA_ENTRADA_DESTINO_JSP_TXT", currentLanguage, environmentId)%> <!--Mesa entrada destino:--></font></legend>
			<BLOCKQUOTE CLASS="body">
				<DIV id="oTocDivUsr" style="BACKGROUND-COLOR: <%=Mensajes.com_st_apia_expedientes_style_arbol_destino%>; BORDER-BOTTOM: #505050 1px solid; BORDER-LEFT: #505050 1px solid; BORDER-RIGHT: #505050 1px solid; BORDER-TOP: #505050 1px solid; FONT-FAMILY: verdana; FONT-SIZE: 8pt; HEIGHT: 238px; OVERFLOW: auto; WIDTH: 191px">
				<DIV ID="oPrimaryTOCUsr">   
				
				</DIV>
				</DIV>
			</BLOCKQUOTE>
</fieldset> 

</td>

<td>&nbsp;&nbsp;</td>
<td>

</td>
</tr>
<tr>
<td colspan=3 align="center">
	<div id="field2" >
		<BUTTON type="BUTTON" onclick="ok()" ID=btnOk NAME=btnOk><%= mensajeDao.obtenerMensajePorCodigo("VAL_BTN_SELECCIONAR_JSP_TXT", currentLanguage, environmentId)%></BUTTON>&nbsp;
		<BUTTON type="BUTTON" onclick="cancel();" id=btnCancel name=btnCancel><%= mensajeDao.obtenerMensajePorCodigo("VAL_BTN_CANCELAR_JSP_TXT", currentLanguage, environmentId)%></BUTTON>
	</div>
</td>
</tr>		
</table>
	
	</form>
</BODY>


</HTML>
