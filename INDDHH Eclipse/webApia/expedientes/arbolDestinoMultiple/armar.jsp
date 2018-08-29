
<%response.setCharacterEncoding(com.dogma.Parameters.APP_ENCODING);%>
<%@page import="com.st.util.labels.LabelManager"%>
<%@page import="com.dogma.Parameters"%>
<%@page import="com.dogma.EnvParameters"%>
<%@page import="com.dogma.controller.ThreadData"%>
<%@page import="uy.com.st.adoc.expedientes.helper.Helper"%>
<%@page import="uy.com.st.adoc.expedientes.domain.Nodo"%>
<%@page import="uy.com.st.adoc.expedientes.constantes.Mensajes"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.dogma.UserData"%>
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
<script TYPE="text/javascript" LANGUAGE="javascript" SRC="toc.js"></script>
<link href="toc.css" type="text/css" rel="styleSheet">

<title><%=mensajeDao.obtenerMensajePorCodigo("VAL_TITULO_SELECCIONAR_DESTINO_PASE_JSP_TXT", currentLanguage, environmentId)%></title>
<SCRIPT LANGUAGE=javascript>

function whenLoad(){  
	document.getElementById("waittoload").style.display="none";
	document.getElementById("treefield").style.display="";		
}

function getModalReturnValue(modal) {
	var destino = "";

	destino = document.getElementById("textIdOficinaDestino").value +
				"<%=Mensajes.EXP_SEPARADOR_PARAMETROS1%>" + 
				document.getElementById("textCodOficinaDestino").value +
				"<%=Mensajes.EXP_SEPARADOR_PARAMETROS1%>" + 
				document.getElementById("textNameOficinaDestino").value;
	
	modal.setearDestino(destino);
	return true;	
}

</SCRIPT>

<script>
var FORCE_SYNC = true;
var MSIE = window.navigator.appVersion.indexOf("MSIE")>=0;
var URL_ROOT_PATH	 	= "<%=Parameters.ROOT_PATH%>";
var URL_STYLE_PATH		= "<%=Parameters.ROOT_PATH%>/styles/<%=styleDirectory%>";


	function fnFlash(oTitle) {
		oList = document.all[oTitle.sourceIndex + 1];
		if (oList.className == "tocItemHide") {
			oList.className = "tocItemShow";
			document.frmMain.tipPagina.value = oTitle.tipPag
		} else {
			oList.className = "tocItemHide";
			document.frmMain.tipPagina.value = oTitle.tipPag
		}

	}
</script>
</HEAD>

<BODY onLoad="whenLoad()">
	<form name="frmMain" id="frmMain" method="post">

		<input id="tipPagina" type="hidden"> <input
			id="textIdOficinaDestino" name="textIdOficinaDestino" type="hidden">
		<input id="textCodOficinaDestino" name="textCodOficinaDestino"
			type="hidden"> <input id="textNameOficinaDestino"
			name="textNameOficinaDestino" type="hidden"> <input
			id="textSeparador1" name="textSeparador1" type="hidden"
			value="<%=Mensajes.EXP_SEPARADOR_PARAMETROS1%>"> <input
			id="textSeparador2" name="textSeparador2" type="hidden"
			value="<%=Mensajes.EXP_SEPARADOR_PARAMETROS2%>"> <input
			readonly id="waittoload" value="Espere un momento.."
			style="background-color: yellow; color: navy; position: absolute; top: 120px; left: 130px; display: none">

		<table border=0>
			<tr>
				<td>
					<div id="tree" onclick="treeClick(event)">
						<fieldset id="treefield" name="treefield"
							style="display: none; HEIGHT: 287px; WIDTH: 650px">
							<legend>
								<font style="FONT-FAMILY: verdana; FONT-SIZE: 8pt;"><%=mensajeDao.obtenerMensajePorCodigo("VAL_LBL_SELECCIONAR_OFICINA_JSP_TXT", currentLanguage, environmentId)%></font>
							</legend>
							<BLOCKQUOTE CLASS="body">
								<DIV id="oTocDiv"
									style="BACKGROUND-COLOR: <%=Mensajes.com_st_apia_expedientes_style_arbol_destino%>; BORDER-BOTTOM: #505050 1px solid; BORDER-LEFT: #505050 1px solid; BORDER-RIGHT: #505050 1px solid; BORDER-TOP: #505050 1px solid; FONT-FAMILY: verdana; FONT-SIZE: 8pt; HEIGHT: 238px; OVERFLOW: auto; WIDTH: 600px">
									<br>
									<UL ID="oPrimaryTOC">
										<%
											LogDocumentum.debug("SESSION_ATTRIBUTE: " + uData);
																		
													if (uData!=null){
														//UserData uData = (UserData)session.getAttribute(Parameters.SESSION_ATTRIBUTE);
														if (uData.getUserAttributes().get("ESTRUCTURA_JERARQUICA")!=null){
															String htmlData = (String)uData.getUserAttributes().get("ESTRUCTURA_JERARQUICA");												
															out.print( htmlData );
														}else{
															LogDocumentum.debug( "NO HAY DATOS EN SESSION 1" );
														}
													}else{
														LogDocumentum.debug( "NO HAY DATOS EN SESSION 2 " );
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

			</tr>
			<!-- 
<tr>
<td colspan=3 align="center">
	<div id="field2" >
		<BUTTON onclick="ok()" ID=btnOk NAME=btnOk><%=mensajeDao.obtenerMensajePorCodigo("VAL_BTN_SELECCIONAR_JSP_TXT", currentLanguage, environmentId)%></BUTTON>&nbsp;
		<BUTTON onclick="cancel();" id=btnCancel name=btnCancel><%=mensajeDao.obtenerMensajePorCodigo("VAL_BTN_CANCELAR_JSP_TXT", currentLanguage, environmentId)%></BUTTON>
	</div>
</td>
</tr>
 -->
		</table>

	</form>
</BODY>
</HTML>

