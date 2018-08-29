<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Iterator"%>
<%@page import="com.dogma.UserData"%>
<%@page import="com.dogma.controller.ThreadData"%>
<%@page import="com.dogma.Parameters"%>
<%@page import="uy.com.st.adoc.mensajes.MensajeDAO"%>
<%@page import="uy.com.st.adoc.expedientes.domain.Vinculados"%>
<%@page import="uy.com.st.adoc.expedientes.dao.VinculacionDao"%>

<%

response.setHeader("Pragma","no-cache");
response.setHeader("Cache-Control","no-store");
response.setDateHeader("Expires",-1); 

Integer envId = null;
MensajeDAO mensajeDao = new MensajeDAO();
int currentLanguage = 1;
String styleDirectory = "default"; 

UserData uData = ThreadData.getUserData();
if (uData!=null) {
	envId = uData.getEnvironmentId();
	currentLanguage = uData.getLangId();
	styleDirectory = uData.getUserStyle();
}

String strNroExp = request.getParameter("nroExp");
String tipoVinc = request.getParameter("tipoVinc");

String title = "";
String columna1= "";
String columna2= "";


if(tipoVinc.equals("rel")){
	title = "Relacionados";
	tipoVinc = "1";
	columna1 = "Expediente 1";
	columna2 = "Expediente 2";
} else if(tipoVinc.equals("acor")){
	title = "Acordonados";
	tipoVinc = "2";
	columna1 = mensajeDao.obtenerMensajePorCodigo("MSG_EXP_PADRE", currentLanguage, envId);
	columna2 = mensajeDao.obtenerMensajePorCodigo("MSG_EXP_HIJO", currentLanguage, envId);	
}

VinculacionDao oVD = new VinculacionDao();

ArrayList<Vinculados> arrVinculaciones = (ArrayList<Vinculados>) oVD.obtenerVinculados(strNroExp, tipoVinc, envId);
Iterator<Vinculados> ite = arrVinculaciones.iterator();
String strTabla = "";

while(ite.hasNext()){
	Vinculados oVinculado = ite.next();
	strTabla = strTabla + "<tr class='selectableTR'>";
	strTabla = strTabla + "<td><div class='gridMinWidth' style='width: 144px'>" + oVinculado.getNroPadre() + "</div></td>";
	strTabla = strTabla + "<td><div class='gridMinWidth' style='width: 144px'>" + oVinculado.getNroHijo() + "</div></td>";	
	strTabla = strTabla + "<td><div class='gridMinWidth' style='width: 144px'>" + oVinculado.getFechaVinc() + "</div></td>";	
	strTabla = strTabla + "</tr>";
}

%>
<html>
<head>
<title><%=title%></title>
	<link href="<%=Parameters.ROOT_PATH%>/css/<%=styleDirectory%>/execution/generalExecution.css" rel="styleSheet" type="text/css" media="screen">
	<link href="<%=Parameters.ROOT_PATH%>/css/<%=styleDirectory%>/common/dogmaErrorPage.css" rel="styleSheet" type="text/css" media="screen">

<style type="text/css">
#printBtn {
	position: absolute;
	transform: translate(500%,0%);
	
	background: -webkit-gradient(linear, 0 0, 0 100%, from(#0063b6)to(#315390));
	background: -webkit-linear-gradient(#0063b6, #315390);
	background: -moz-linear-gradient(#0063b6, #315390);
	background: -ms-linear-gradient(#0063b6, #315390);
	background: -o-linear-gradient(#0063b6, #315390);
	background: linear-gradient(#0063b6, #315390);
	color: #ffffff;
	border: 1px;
	border-color: #244f9d;
	border-radius: 3px 3px 3px 3px;
	width: 90px;
	height: 30px;
	
}

#printBtn:hover {
	background: -webkit-gradient(linear, 0 0, 0 100%, from(#315390)to(#2b497e));
	background: -webkit-linear-gradient(#315390, #2b497e);
	background: -moz-linear-gradient(#315390, #2b497e);
	background: -ms-linear-gradient(#315390, #2b497e);
	background: -o-linear-gradient(#315390, #2b497e);
	background: linear-gradient(#315390, #2b497e);
}
</style>
	
	<script>
		function imprimir(){
			var originalContents = document.body.innerHTML;
			document.getElementsByClassName("gridBody")[0].style.overflow = "visible";
			document.getElementsByClassName("gridBody")[0].style.heith = "2000px";
			document.getElementById("printBtn").style.display = "none"; 
			window.print();
			document.body.innerHTML = originalContents;
		}
		
	</script>
</head>
<body>
<form id="frmData" action="post" method="post">
	<div class="dataContainer">
		<div class="tabComponent" id="tabComponent" style="padding-top: 22px;">
			<div class="aTab">
				<div class="contentTab active">
					<div class="tabContent" >
					<div class="formContainer fieldGroup">
					<div class="collapseForm"></div> <!-- Imagen de formulario cerrado -->
					<div class="title form-title"><%=title%>: <%=strNroExp%></div>	
				
					<table style="table-layout: fixed; width: 100%;">
						<tbody>
							<tr>
								<td rowspan="3" colspan="4">
									<div class="field exec_field no-ie7 gridContainer" style="width: 485px;">
									
										<div class="gridHeader" style="width: 100%; overflow: hidden;">
											<table cellpadding="0" cellspacing="0" >
												<thead>
													<tr>
														<th><div class="gridMinWidth"><%=columna1%><!--Oficina actuante--></div></th>
														<th><div class="gridMinWidth"><%=columna2%><!--Tipo actuación--></div></th>																																									
														<th><div class="gridMinWidth">Fecha Vinculación<!--Fecha actuación--></div></th>														
													</tr>
												</thead>
											</table>
										</div>
										
										<div class="gridBody" style="width: 100%; height: 270px; overflow-y: auto; overflow-x: hidden; ">
											<table cellpadding="0" cellspacing="0" >
												<tbody class="tableData">
													<%=strTabla%>
												</tbody>
											</table>
										</div>
										
										<div class="gridFooter" style="width: 100%;"></div>
										
									</div>
								</td>
							</tr>
						</tbody>
					</table>
					
					<button id="printBtn" type="button" onclick="imprimir()"> Imprimir </button>
					
					</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</form>
</body>
</html>