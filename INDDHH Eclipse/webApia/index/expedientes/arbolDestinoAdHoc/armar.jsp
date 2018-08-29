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
Integer currentLanguage = null;
MensajeDAO mensajeDao = new MensajeDAO();
//com.dogma.UserData uData = (com.dogma.UserData)session.getAttribute("sessionAttribute");
//UserData uData = (UserData)session.getAttribute(Parameters.SESSION_ATTRIBUTE);
UserData uData = ThreadData.getUserData();
if (uData!=null) {
	environmentId = uData.getEnvironmentId();
	currentLanguage = uData.getLangId();
	styleDirectory = EnvParameters.getEnvParameter(environmentId,EnvParameters.ENV_STYLE);
}
%>

<HTML>
<HEAD>

<SCRIPT LANGUAGE="javascript">
var sep1;
var MSIE = window.navigator.appVersion.indexOf("MSIE")>=0;
var FORCE_SYNC = true;
var TAB_ID_REQUEST = "<%="&tabId=" + request.getParameter("tabId").toString() +"&tokenId="+ request.getParameter("tokenId").toString()%>"


function whenLoad(){  	
	document.getElementById("waittoload").style.display="none";
	document.getElementById("treefield").style.display="block";
	HideAll('UL');	
	sep1 = document.getElementById("textSeparador1").value;
}

function getModalReturnValue(modal) {
	var destino = "";
	
	destino = document.getElementById("textLstUsuarioDestino").value;
	destino = sacarSeperadorDeLosExtremos(destino, document.getElementById("textSeparador2").value);
	
	destino = document.getElementById("textOficinaDestino").value 
		+ sep1 + document.getElementById("textNombOficinaDestino").value
		+ sep1 + destino;
	
	if (destino == "" ){
		alert("Debe elegir un destino");
	}else{						
		modal.setearDestino(destino);
		return true;	
	} 
}
</SCRIPT>

<script>
var ajax;
var ajax2;

function funcionCallback(){
	// Comprobamos si la peticion se ha completado (estado 4)
	if( ajax.readyState == 4 ){
		// Comprobamos si la respuesta ha sido correcta (resultado HTTP 200)
		if( ajax.status == 200 ){
			funcionCallBackCargarUsuariosLoaded()
		}
	}	
}

function funcionCallBackCargarUsuariosLoaded(){
	// Escribimos el resultado en la pagina HTML mediante DHTML
	var result = ajax.responseText;
	document.getElementById("oPrimaryTOCUsr").style.display="block";
	document.getElementById("oPrimaryTOCUsr").innerHTML = result;
	if (result.indexOf("<table><table>") != -1){
		document.getElementById("textHayUsrOficina").value = "0";				
	}else{
		document.getElementById("textHayUsrOficina").value = "1";
	}
}

function cargarUsuarios(flag){
	// Creamos el control XMLHttpRequest segun el navegador en el que estemos
	if( !MSIE ){
		ajax = new XMLHttpRequest(); // No Internet Explorer
		ajax.onload = function(){
			funcionCallBackCargarUsuariosLoaded();
		}
	}else{
		ajax = new ActiveXObject("Microsoft.XMLHTTP"); // Internet Explorer
		// Almacenamos en el control al funcion que se invocara cuando la peticion
		// cambie de estado
		ajax.onreadystatechange = funcionCallback;
	}
	// Enviamos la peticion	
	var URL = "<%=ConfigurationManager.getServerAddress(environmentId,currentLanguage) + Configuration.ROOT_PATH%>/expedientes/arbolDestinoAdHoc/cargarUsuarios.jsp?unidad=" + document.getElementById("textIdOficinaDestino").value + "&flag=" + flag;					
	//alert(URL);
	ajax.open( "POST", URL, false );	
	ajax.send( "" );	
}

function funcionCallbackAusente(){
	// Comprobamos si la peticion se ha completado (estado 4)
	if( ajax.readyState == 4 ){
		// Comprobamos si la respuesta ha sido correcta (resultado HTTP 200)
		if( ajax.status == 200 ){
			// Escribimos el resultado en la pagina HTML mediante DHTML
			var result = ajax.responseText;
						
			var vec = result.split("<%=Mensajes.EXP_SEPARADOR_PARAMETROS1%>");
			
			if (vec[1] == 'true'){
				if (vec[2] == ''){
					if (vec[4] == null || (vec[4].indexOf("-") == -1)) {
						alert("<%=mensajeDao.obtenerMensajePorCodigo("MSG_USUARIO_AUSENTE_JSP", currentLanguage, environmentId)%>");
					}else{
						alert("<%=mensajeDao.obtenerMensajePorCodigo("MSG_USUARIO_AUSENTE_HASTA_DIA_JSP", currentLanguage, environmentId)%>".replace('<DIA>',vec[4]));
						//alert("El usuario se encuentra asuente de la oficina hasta el día: " + vec[4]);
					}
				}else{
					if (vec[4] == null || (vec[4].indexOf("-") == -1)) {
						alert("<%=mensajeDao.obtenerMensajePorCodigo("MSG_USUARIO_AUSENTE_CON_MENSAJE_JSP", currentLanguage, environmentId)%>");
					}else{
						alert("<%=mensajeDao.obtenerMensajePorCodigo("MSG_USUARIO_AUSENTE_HASTA_DIA_CON_MENSAJE_JSP", currentLanguage, environmentId)%>".replace('<DIA>',vec[4]).replace('<MENSAJE>',vec[2]));
						//alert("El usuario se encuentra ausente hasta el día: " + vec[4] + ".\nMensaje del usuario: " + vec[2]);
						//document.getElementById("textUsuarioDestino").value = vec[2];
					}
				}
				
				var cElems = document.getElementsByTagName('INPUT');
				var iNumElems = cElems.length;
				for (var i=1;i<iNumElems;i++) {
					if (cElems[i].id == "checkbox2"){
						cElems[i].checked=false;
					}
				}
				document.getElementById("textUsuarioDestino").value=""; 
			}else{
				//alert("El usuario no esta de licencia");
			}	
			//document.getElementById("imgFoto").width = 200;
			//document.getElementById("imgFoto").height = 200;				
			//document.getElementById("imgFoto").src=vec[0];			
			//ajustarIMG(document.getElementById("imgFoto"));								
		}
	}	
}


function funcionCallbackFoto(){
	// Comprobamos si la peticion se ha completado (estado 4)
	if( ajax2.readyState == 4 ){
		// Comprobamos si la respuesta ha sido correcta (resultado HTTP 200)
		if( ajax2.status == 200 ){
			// Escribimos el resultado en la pagina HTML mediante DHTML
			var result = ajax2.responseText;
						
			var vec = result.split("<%=Mensajes.EXP_SEPARADOR_PARAMETROS1%>");
			
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
	
	ajax.onreadystatechange = funcionCallbackAusente;
	// Enviamos la peticion		
	var URL = "<%=ConfigurationManager.getServerAddress(environmentId,currentLanguage) + Configuration.ROOT_PATH%>/expedientes/arbolDestino/cargarImg.jsp?usr=" + usr + "&op=1" + TAB_ID_REQUEST;
	//alert(URL);	
	ajax.open( "GET", URL, true );
	ajax.send( "" );	
	
	
	// Creamos el control XMLHttpRequest segun el navegador en el que estemos
	if( window.XMLHttpRequest )
		ajax2 = new XMLHttpRequest(); // No Internet Explorer
	else
		ajax2 = new ActiveXObject("Microsoft.XMLHTTP"); // Internet Explorer
		// Almacenamos en el control al funcion que se invocara cuando la peticion
		// cambie de estado
	
	ajax2.onreadystatechange = funcionCallbackFoto;
	// Enviamos la peticion		
	var URL2 = "<%=ConfigurationManager.getServerAddress(environmentId,currentLanguage) + Configuration.ROOT_PATH%>/expedientes/arbolDestino/cargarImg.jsp?usr=" + usr + "&op=2" + TAB_ID_REQUEST;
	//alert(URL);	
	ajax2.open( "GET", URL2, true );
	ajax2.send( "" );	
	
}
//-->
</script>


	<script LANGUAGE="javascript" SRC="toc.js"></script>
	<script LANGUAGE="javascript" SRC="<%=Parameters.ROOT_PATH%>/expedientes/scripts/image.js"></script>
	<link href="toc.css" type="text/css" rel="styleSheet">

<title>Seleccionar el destino del Pase - Grupos AD HOC</title>

<script>

var URL_ROOT_PATH	 	= "<%=Parameters.ROOT_PATH%>";
var URL_STYLE_PATH		= "<%=Parameters.ROOT_PATH%>/styles/<%= styleDirectory %>"

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
</script>
</HEAD>

<BODY onload="whenLoad()">
	<form name="frmMain" id="frmMain" method="post">
		
		<input id="tipPagina" type="hidden">
		<input id=textIdOficinaDestino name=textIdOficinaDestino type="hidden">
		<input id=textOficinaDestino name=textOficinaDestino type="hidden">
		<input id=textUsuarioDestino name=textUsuarioDestino type="hidden">
		<input id=textLstUsuarioDestino name=textLstUsuarioDestino type="hidden" value="" size=100>
		<input id=textNombOficinaDestino name=textNombOficinaDestino type="hidden" value="" size=100>
		<input id=textHayUsrOficina name=textHayUsrOficina type="hidden" value="">
		<input id=textSeparador1 name=textSeparador1 type="hidden" value="<%=Mensajes.EXP_SEPARADOR_PARAMETROS1%>">
		<input id=textSeparador2 name=textSeparador2 type="hidden" value="<%=Mensajes.EXP_SEPARADOR_PARAMETROS2%>">
		
		<input readonly id="waittoload" value="Espere un momento.." style="background-color:yellow;color:navy;position:absolute;top:120px;left:130px;display:none">
		
<table border=0>
<tr>
	<td>
		<div id="tree" onclick="treeClick(event)">	
		<fieldset id="treefield" name="treefield" style="display:none; HEIGHT: 287px; WIDTH: 379px">
			<legend><font style="FONT-FAMILY: verdana; FONT-SIZE: 8pt;">Seleccionar oficina:</font></legend>
			<BLOCKQUOTE CLASS="body">
				<DIV id="oTocDiv" style="BACKGROUND-COLOR: <%=Mensajes.com_st_apia_expedientes_style_arbol_destino%>; BORDER-BOTTOM: #505050 1px solid; BORDER-LEFT: #505050 1px solid; BORDER-RIGHT: #505050 1px solid; BORDER-TOP: #505050 1px solid; FONT-FAMILY: verdana; FONT-SIZE: 8pt; HEIGHT: 238px; OVERFLOW: auto; WIDTH: 341px">
				<br>
				<UL ID="oPrimaryTOC">   
				<% 																							
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
				
				%>
				</UL>
				<br>
				</DIV>
			</BLOCKQUOTE>
		</fieldset>
		</div>
</td>
<td>&nbsp;&nbsp;</td>
<td>


<fieldset id="treefieldusr" name="treefieldusr" style="HEIGHT: 287px; WIDTH: 229px">
			<legend><font style="FONT-FAMILY: verdana; FONT-SIZE: 8pt;">Usuario destino:</font></legend>
			<BLOCKQUOTE CLASS="body">
				<DIV id="oTocDivUsr" style="BACKGROUND-COLOR: <%=Mensajes.com_st_apia_expedientes_style_arbol_destino%>; BORDER-BOTTOM: #505050 1px solid; BORDER-LEFT: #505050 1px solid; BORDER-RIGHT: #505050 1px solid; BORDER-TOP: #505050 1px solid; FONT-FAMILY: verdana; FONT-SIZE: 8pt; HEIGHT: 238px; OVERFLOW: auto; WIDTH: 191px">
				<br>
				<UL ID="oPrimaryTOCUsr">   
				
				</UL>
				<br>
				</DIV>
			</BLOCKQUOTE>
</fieldset> 

</td>

<td>&nbsp;&nbsp;</td>
<td>


<fieldset id="usrImg" name="usrImg" style="HEIGHT: 287px; WIDTH: 219px">
			<legend><font style="FONT-FAMILY: verdana; FONT-SIZE: 8pt;">Foto:</font></legend>
			<BLOCKQUOTE CLASS="body">				
				<img onload="resizeImg(this, 150, 150)" id="imgFoto" name="imgFoto" src="<%=Parameters.ROOT_PATH%>/images/fotos/NoPicture.gif">
			</BLOCKQUOTE>
</fieldset> 

</td>
</tr>
<tr>
<td colspan=3 align="center">
	<div id="field2" >
		<button type="button" onclick="ok()" ID="btnOk" NAME="btnOk">Seleccionar</BUTTON>&nbsp;
		<button type="button" onclick="cancel();" id="btnCancel" name="btnCancel">Cancelar</BUTTON>
	</div>
</td>
</tr>		
</table>
	
	</form>
</BODY>


</HTML>