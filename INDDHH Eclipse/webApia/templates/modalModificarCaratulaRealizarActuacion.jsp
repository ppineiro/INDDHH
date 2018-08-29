<%@page import="uy.com.st.adoc.expedientes.arbolExpediente.obj.sql.Consultas"%>
<%@page import="uy.com.st.adoc.expedientes.conf.ConfigurationManager"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.dogma.UserData"%>
<%@page import="com.dogma.controller.ThreadData"%>

<html>
	<head>
	
		<%
			UserData uData = ThreadData.getUserData();
			int envId = uData.getEnvironmentId();
			int langId = uData.getLangId();
			
			boolean eDocsActivo = ConfigurationManager.getHabilitarEDOCS(envId, langId, false).equalsIgnoreCase("true");
			
			String asunto = request.getParameter("asunto");
			String prioridad = request.getParameter("prioridad");
			String acc_rest = request.getParameter("acc_rest");
			String elem_fisc = request.getParameter("elem_fisc");
			
			String debeRegenarCaratulaARTEE = (String) uData.getUserAttributes().get("DEBE_REGENERAR_CARATULA_ARTEE");
			boolean modificacionCaratulaARTEE = debeRegenarCaratulaARTEE != null && debeRegenarCaratulaARTEE.equalsIgnoreCase("true");
		
		%>
		
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>Insert title here</title>
		
		<script type="text/javascript">
		
			function getModalReturnValue(modal) {
				
				var action = "vacio";
				var oRadio = document.getElementsByName("rb_descarga");

				for (var i = 0; i < oRadio.length; i++) {
					if (oRadio[i].checked) {
						action = oRadio[i].value;
					}
				}				
				return action + "," + <%=envId%>;
			}			
			
			function cargarOpciones(){
				if("<%=asunto%>" == "false" && "<%=prioridad%>" == "false"){
					document.getElementById("trFirst").style.display = "none";
				}
				
				if("<%=elem_fisc%>" == "false"){
					document.getElementById("trSecond").style.display = "none";
				}
				
				if("<%=acc_rest%>" == "false"){
					document.getElementById("trThird").style.display = "none";
				}
				
				if( "<%=modificacionCaratulaARTEE%>" == "false" && "<%=asunto%>" == "false" && "<%=prioridad%>" == "false" && "<%=elem_fisc%>" == "false" && "<%=acc_rest%>" == "false"){
					document.getElementById("trEmpty").style.display = "block";
				}else{
					document.getElementById("trEmpty").style.display = "none";
				}
			}
			
		</script>
		
		<style type="text/css">
		
			#imgPdfDoc {
				background: url(../templates/img/pdfDocs.png);
				background-size: 22px;
				background-repeat: no-repeat;
				width: 22px;
				height: 24px;
			}
					
			tr{ display: block; height: 40px; }	
			td { font-family: Verdana,Arial,Tahoma !important; font-size: 8.5pt !important; }			
			td.size2{ position: relative; left: 107px; }
			td.size3{ position: relative; left: 52px; }
			
			input.radio{ width: 18px; height: 16px; }					
			#lbEmpty { position: absolute; top: 40%; left: 5%; color: rgb(101, 99, 99); font-style: italic; }			
			
			label {	font-family: Verdana,Arial,Tahoma !important; font-size: 8.5pt !important; }
		
		</style>
		
	</head>
	
	<body onLoad="cargarOpciones()">
		
		<table width="100%">
			<tbody>
				
				<tr id="trFirst">
				<td><input class="radio" type="radio" name="rb_descarga" value="3"></td>
				<td><label id="lbFirst"></label> Cambio de asunto, prioridad y/o titular </td>
				</tr>
				
				<%if (!modificacionCaratulaARTEE){%>
					<tr id="trSecond">
					<td><input class="radio" type="radio" name="rb_descarga" value="1"><br></td>
					<td><label id="lbSecond"> Cambio de elemento f&#237;sico </label></td>
					</tr>
					
					<tr id="trThird">
					<td><input class="radio" type="radio" name="rb_descarga" value="2"><br></td>
					<td><label id="lbThird"> Cambio de acceso restringido </label></td>
				<%}%>
				<tr id="trEmpty">
				<td><label id="lbEmpty"> No tiene permisos para modificar ning&#250;n campo de la car&#225;tula. </label></td>				
				</tr>
				<%if (eDocsActivo){%>
				<tr id="trWarning">
					<td><label id="lbWarning"> Recuerde que debe guardar los cambios en el expediente antes de realizar la siguiente acci&#243;n. </label></td>				
				</tr>
				<%}%>
			</tbody>
		</table>
	
	</body>
	
</html>