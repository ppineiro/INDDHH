<%response.setCharacterEncoding(com.dogma.Parameters.APP_ENCODING);%>
<%@page import="com.st.util.labels.LabelManager"%>
<%@page import="com.dogma.Parameters"%>
<%@page import="com.dogma.EnvParameters"%>
<%@page import="uy.com.st.adoc.expedientes.helper.Helper" %>
<%@page import="uy.com.st.adoc.expedientes.domain.Nodo"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.dogma.UserData"%>
<%@page import="uy.com.st.adoc.expedientes.constantes.Mensajes"%>
<%@page import="com.dogma.controller.ThreadData"%>
<%
response.setHeader("Pragma","no-cache");
response.setHeader("Cache-Control","no-store");
response.setDateHeader("Expires",-1); 

//**************THIS IS USED TO GET THE LABEL SET OF THE USER***************//
String styleDirectory = "default";
Integer environmentId = null;
//com.dogma.UserData uData = (com.dogma.UserData)session.getAttribute("sessionAttribute");
UserData uData = ThreadData.getUserData();
if (uData!=null) {
	environmentId = uData.getEnvironmentId();
	styleDirectory = EnvParameters.getEnvParameter(environmentId,EnvParameters.ENV_STYLE);
}
%>

<HTML>
<HEAD>
	<script TYPE="text/javascript" LANGUAGE="javascript" SRC="toc.js"></script>
	<script TYPE="text/javascript" LANGUAGE="javascript" SRC="<%=Parameters.ROOT_PATH%>/expedientes/scripts/image.js"></script>	
	<link href="toc.css" type="text/css" rel="styleSheet">

<title>Seleccionar el destino del Pase</title>

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

<BODY onLoad="whenLoad()">
	<form name="frmMain" id="frmMain" method="post">
			
		<input id="tipPagina" type="hidden">
		<input id=textIdOficinaDestino name=textIdOficinaDestino type="hidden">		
		<input id=textOficinaDestino name=textOficinaDestino type="hidden">
		<input id=textUsuarioDestino name=textUsuarioDestino type="hidden">
		<input id=textNombOficinaDestino name=textNombOficinaDestino type="hidden">
		<input id=textHayUsrOficina name=textHayUsrOficina type="hidden">
		<input id=textSeparador1 name=textSeparador1 type="hidden" value="<%=Mensajes.EXP_SEPARADOR_PARAMETROS1%>">
		<input id=textSeparador2 name=textSeparador2 type="hidden" value="<%=Mensajes.EXP_SEPARADOR_PARAMETROS2%>">
		<input readonly id="waittoload" value="Espere un momento.." style="background-color:yellow;color:navy;position:absolute;top:120px;left:130px;display:none">
		
		
<table border=0>
<tr>
	<td>
		<div id="tree" onclick="treeClick(event)">
		<fieldset id="treefield" name="treefield" style="display:none; HEIGHT: 287px; WIDTH: 650px">
			<legend><font style="FONT-FAMILY: verdana; FONT-SIZE: 8pt;">Seleccionar oficina:</font></legend>
			<BLOCKQUOTE CLASS="body">
				<DIV id="oTocDiv" style="BACKGROUND-COLOR: <%=Mensajes.com_st_apia_expedientes_style_arbol_destino%>; BORDER-BOTTOM: #505050 1px solid; BORDER-LEFT: #505050 1px solid; BORDER-RIGHT: #505050 1px solid; BORDER-TOP: #505050 1px solid; FONT-FAMILY: verdana; FONT-SIZE: 8pt; HEIGHT: 238px; OVERFLOW: auto; WIDTH: 600px">
				<br>
				<UL ID="oPrimaryTOC">   
				<% 									
					//System.out.println("SESSION_ATTRIBUTE: " + Parameters.SESSION_ATTRIBUTE);
										
					if (uData!=null){
						//UserData uData = (UserData)session.getAttribute(Parameters.SESSION_ATTRIBUTE);
						if (uData.getUserAttributes().get("RUT_EST_ESTRUCTURA_JERARQUICA_GT")!=null){
							String htmlData = (String)uData.getUserAttributes().get("RUT_EST_ESTRUCTURA_JERARQUICA_GT");												
							out.print( htmlData );
						}else{
							System.out.println( "NO HAY DATOS EN SESSION 1" );
						}
					}else{
						System.out.println( "NO HAY DATOS EN SESSION 2 " );
					}
					System.out.println("FIN");
				
				%>
				</UL>
				<br>
				</DIV>
			</BLOCKQUOTE>
		</fieldset> 
		</div>
</td>

</tr>
<tr>
<td colspan=3 align="center">
	<div id="field2" >
		<BUTTON type="button" onclick="ok()" ID=btnOk NAME=btnOk>Seleccionar</BUTTON>&nbsp;
		<BUTTON type="button" onclick="cancel();" id=btnCancel name=btnCancel>Cancelar</BUTTON>
	</div>
</td>
</tr>		
</table>
	
	</form>
</BODY>

<SCRIPT LANGUAGE=javascript>
var sep1;

function cancel(){
	window.returnValue="cancel";
	window.close();
}

function whenLoad(){  	
	document.all.item("waittoload").style.display="none";
	document.all.item("treefield").style.display="";
	sep1 = document.getElementById("textSeparador1").value;	
}

function ok(){	
	var destino = "";
	
	destino = document.getElementById("textOficinaDestino").value 
		+ sep1 + document.getElementById("textNombOficinaDestino").value
		+ sep1 + document.getElementById("textUsuarioDestino").value;

	
	if (destino == "" ){
		
		alert("Debe elegir un destino");
	}else{
		
		if (document.getElementById("textHayUsrOficina").value == "0"){

			
			destino = "";
			alert("La oficina que eligio no tiene integrantes!");
		}else{
			//var truthBeTold = window.confirm("¿Realmente desea realizar el pase?");
			//if (truthBeTold) {			
				window.returnValue = destino;
				window.close();
			//}
		}
	}  	
	
}
</SCRIPT>
</HTML>
