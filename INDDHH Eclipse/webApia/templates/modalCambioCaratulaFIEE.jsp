<%@ page import="uy.com.st.adoc.expedientes.arbolExpediente.obj.sql.Consultas"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.dogma.UserData"%>
<%@page import="com.dogma.controller.ThreadData"%>

<html>
	<head>
	
		<%
		UserData uData = ThreadData.getUserData();
		int envId = uData.getEnvironmentId();
		
		String asunto = request.getParameter("asunto");
		String prioridad = request.getParameter("prioridad");
		String acc_rest = request.getParameter("acc_rest");
		String elem_fisc = request.getParameter("elem_fisc");
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
				<td><label id="lbFirst"></label> Cambio caratula de FIEE </td>
				</tr>
				
			</tbody>
		</table>
	
	</body>
	
</html>