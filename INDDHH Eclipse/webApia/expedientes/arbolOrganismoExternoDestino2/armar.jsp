<%@ page import="uy.com.st.adoc.expedientes.helper.Helper" %>
<%@page import="uy.com.st.adoc.expedientes.domain.Nodo"%>
<%@page import="uy.com.st.adoc.expedientes.constantes.Mensajes"%>
<%@page import="java.util.ArrayList"%>

<HTML>
<HEAD>
<SCRIPT LANGUAGE=javascript>
function cancel(){
	window.returnValue="cancel";
	window.close();
}

function whenLoad(){	

	var org = "<table>";
	org = org + "<tr><td><input type='radio' onclick='marcarOrganismo(this)' id='checkbox2' name='BPS' value='BPS'><font style='FONT-FAMILY: verdana; FONT-SIZE: 8pt;'><img src='images/folder_home.gif'>&nbsp;BPS</font></td></tr>";
	org = org + "<tr><td><input type='radio' onclick='marcarOrganismo(this)' id='checkbox2' name='BROU' value='BROU'><font style='FONT-FAMILY: verdana; FONT-SIZE: 8pt;'><img src='images/folder_home.gif'>&nbsp;BROU</font></td></tr>";
	org = org + "<tr><td><input type='radio' onclick='marcarOrganismo(this)' id='checkbox2' name='UTE' value='UTE'><font style='FONT-FAMILY: verdana; FONT-SIZE: 8pt;'><img src='images/folder_home.gif'>&nbsp;UTE</font></td></tr>";
	org = org + "<tr><td><input type='radio' onclick='marcarOrganismo(this)' id='checkbox2' name='ANTEL' value='ANTEL'><font style='FONT-FAMILY: verdana; FONT-SIZE: 8pt;'><img src='images/folder_home.gif'>&nbsp;ANTEL</font></td></tr>";
	org = org + "<tr><td><input type='radio' onclick='marcarOrganismo(this)' id='checkbox2' name='OSE' value='OSE'><font style='FONT-FAMILY: verdana; FONT-SIZE: 8pt;'><img src='images/folder_home.gif'>&nbsp;OSE</font></td></tr>";
	org = org + "<tr><td><input type='radio' onclick='marcarOrganismo(this)' id='checkbox2' name='CGN' value='CGN'><font style='FONT-FAMILY: verdana; FONT-SIZE: 8pt;'><img src='images/folder_home.gif'>&nbsp;CGN</font></td></tr>";
	org = org + "<table>";
	 
	document.getElementById("oPrimaryTOCUsr").innerHTML = org; 
}

function ok(){	
	var destino = ""; 
	if (document.getElementById("textTipoDestino").value!=""){
		if (document.getElementById("textTipoDestino").value=="ORGANISMO"){
			destino = document.getElementById("textNameDestino").value;
		}
		/*
		if (document.getElementById("textTipoDestino").value=="OFICINA"){
			destino = document.getElementById("textIdDestino").value;
		}
		*/
	}  
	
	if (destino == "" ){
		alert("Debe elegir un destino");
	}else{
		var truthBeTold = window.confirm("¿Realmente desea realizar el pase a: " + destino + "?");
		if (truthBeTold) {			
			window.returnValue = destino;
			window.close();
		}
	}  	
	
}
</SCRIPT>

	<script LANGUAGE="javascript" SRC="toc.js"></script>
	<link href="toc.css" type="text/css" rel="styleSheet">

<title>Seleccionar destino externo</title>

<script>
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
		<input id="tipPagina" type="hidden"><br>
		<input id=textIdDestino name=textIdDestino type="hidden"><br>
		<input id=textNameDestino name=textNameDestino type="hidden">
		<input id=textTipoDestino name=textTipoDestino type="hidden">
		<input id=textSeparador1 name=textSeparador1 type="hidden" value="<%=Mensajes.EXP_SEPARADOR_PARAMETROS1%>">
		<input id=textSeparador2 name=textSeparador2 type="hidden" value="<%=Mensajes.EXP_SEPARADOR_PARAMETROS2%>">
		
		<input readonly id="waittoload" value="Espere un momento.." style="background-color:yellow;color:navy;position:absolute;top:120px;left:130px;display:none">
		
<table border=0>
<tr>
<td>

<fieldset id="treefieldusr" name="treefieldusr" style="HEIGHT: 287px; WIDTH: 329px">
			<legend><font style="FONT-FAMILY: verdana; FONT-SIZE: 8pt;">Organismo externo:</font></legend>
			<BLOCKQUOTE CLASS="body">
				<DIV id="oTocDivUsr" style="BACKGROUND-COLOR: #b9d3ee; BORDER-BOTTOM: #505050 1px solid; BORDER-LEFT: #505050 1px solid; BORDER-RIGHT: #505050 1px solid; BORDER-TOP: #505050 1px solid; FONT-FAMILY: verdana; FONT-SIZE: 8pt; HEIGHT: 238px; OVERFLOW: auto; WIDTH: 291px">
				<br>
				<UL ID="oPrimaryTOCUsr">   
				
				</UL>
				<br>
				</DIV>
			</BLOCKQUOTE>
</fieldset> 

</td>
</tr>
<tr>
<td align="center">
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