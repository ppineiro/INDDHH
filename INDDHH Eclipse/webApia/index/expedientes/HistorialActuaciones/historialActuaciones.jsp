<%response.setCharacterEncoding(com.dogma.Parameters.APP_ENCODING);%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Iterator"%>
<%@page import="uy.com.st.adoc.expedientes.domain.Historial"%>
<%@page import="uy.com.st.adoc.expedientes.dao.HistorialActuacionDao"%>
<%@page import="com.dogma.Parameters"%>
<%@page import="com.dogma.UserData"%>
<%@page import="uy.com.st.adoc.mensajes.MensajeDAO"%>
<%@page import="uy.com.st.adoc.expedientes.conf.ConfigurationManager"%>
<%@page import="java.text.SimpleDateFormat" %>
<%@page import="java.util.Date" %>
<%@page import="com.dogma.controller.ThreadData"%>
<%
	response.setHeader("Pragma","no-cache");
	response.setHeader("Cache-Control","no-store");
	response.setDateHeader("Expires",-1); 
	
	Integer environmentId = null;
	MensajeDAO mensajeDao = new MensajeDAO();
	int currentLanguage = 1;
	String styleDirectory = "default";

	
	UserData uData = ThreadData.getUserData();
	if (uData!=null) {
		environmentId = uData.getEnvironmentId();
		currentLanguage = uData.getLangId();
		styleDirectory = uData.getUserStyle();//EnvParameters.getEnvParameter(environmentId,EnvParameters.ENV_STYLE);
	}
	
	String strNroExp = request.getParameter("NroExp");
	String strNroExpShow = strNroExp;
	
	try{
	
		if (strNroExp.contains("-Respaldo_")){
			String[] format = strNroExp.split("-Respaldo_");
			strNroExpShow = format[0];
			
			SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmssSSS");
			Date fecha = sdf.parse(format[1]);
			sdf.applyPattern("dd/MM/yyyy HH:mm:ss");
			strNroExpShow = strNroExpShow + " " + sdf.format(fecha);
				
		}
		
	}catch(Exception exc){
		exc.printStackTrace();
	}
	
	String strTabla = "";

	HistorialActuacionDao oHAD = new HistorialActuacionDao();
	
	ArrayList<Historial> arrHistorial = (ArrayList<Historial>) oHAD.obtenerHistorial(strNroExp,environmentId,currentLanguage);
	Iterator<Historial> ite = arrHistorial.iterator();
	
	strTabla = "";
	
	while(ite.hasNext()){
		Historial oHistorial = ite.next();
		strTabla = strTabla + "<tr class='selectableTR'>";
		strTabla = strTabla + "<td><div class='gridMinWidth' style='width: 144px'>" + oHistorial.getStrOficina() + "</div></td>";
		strTabla = strTabla + "<td><div class='gridMinWidth' style='width: 144px'>" + oHistorial.getStrTipoAct() + "</div></td>";
		strTabla = strTabla + "<td><div style='width: 62px; class='gridMinWidth'>" + oHistorial.getStrConfidencial() + "</div></td>";
		strTabla = strTabla + "<td><div class='gridMinWidth' style='width: 144px'>" + oHistorial.getStrNomFirmante() + "</div></td>";
		strTabla = strTabla + "<td><div class='gridMinWidth' style='width: 143px'>" + oHistorial.getStrFirmante() + "</div></td>";
		strTabla = strTabla + "<td><div class='gridMinWidth'>" + oHistorial.getStrFecha() + "</div></td>";
		strTabla = strTabla + "<td><div style='width: 61px; class='gridMinWidth'>" + oHistorial.getStrPaginaInicio() + " - " + oHistorial.getStrPaginaFin() + "</div></td>";
		strTabla = strTabla + "</tr>";
	}

	
		Boolean leyAcceso = Boolean.parseBoolean(ConfigurationManager.getLeyDeAcceso(environmentId,currentLanguage,false));
		
	
		String msgConf = "MSG_LBL_CONFIDENCIAL_ACT_HIST_JSP"; 
		String widthConf = "50px";
		if (leyAcceso){
			msgConf = "MSG_LBL_ACCESO_RESTRINGIDO_ACT_HIST_JSP";
			widthConf = "100px";
		}
%>
<HTML>
<HEAD>
	<title><%= mensajeDao.obtenerMensajePorCodigo("MSG_LBL_TITULO_HISTORIAL_ACTUACIONES_HIST_JSP", currentLanguage, environmentId)%><!--Historial de actuaciones--></title>
	<link href="<%=Parameters.ROOT_PATH%>/css/<%=styleDirectory%>/generalExecution.css" rel="styleSheet" type="text/css" media="screen">
	<link href="<%=Parameters.ROOT_PATH%>/css/<%=styleDirectory%>/dogmaErrorPage.css" rel="styleSheet" type="text/css" media="screen">
	
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
</HEAD>
<BODY>
<form id="frmData" action="post" method="post">
	<div class="dataContainer">
		<div class="tabComponent" id="tabComponent" style="padding-top: 22px;">
			<div class="aTab">
				<div class="contentTab active">
					<div class="tabContent" >
					<div class="formContainer fieldGroup">
					<div class="collapseForm"></div> <!-- Imagen de formulario cerrado -->
					<div class="title form-title">Historial de actuaciones: <%=strNroExpShow%></div>	
				
					<table style="table-layout: fixed; width: 100%;">
						<tbody>
							<tr>
								<td rowspan="3" colspan="4">
									<div class="field exec_field no-ie7 gridContainer" style="width: 942px;">
									
										<div class="gridHeader" style="width: 100%; overflow: hidden;">
											<table cellpadding="0" cellspacing="0" >
												<thead>
													<tr>
														<th><div class="gridMinWidth"><%= mensajeDao.obtenerMensajePorCodigo("MSG_LBL_OFICINA_ACTUANTE_ACT_HIST_JSP", currentLanguage, environmentId)%><!--Oficina actuante--></div></th>
														<th><div class="gridMinWidth"><%= mensajeDao.obtenerMensajePorCodigo("MSG_LBL_TIPO_ACTUACION_ACT_HIST_JSP", currentLanguage, environmentId)%><!--Tipo actuación--></div></th>
														<th><div style="width: 50px;" class="gridMinWidth"><%= mensajeDao.obtenerMensajePorCodigo(msgConf, currentLanguage, environmentId)%><!--Conf. o Acceso restringido--></div></th>
														<th><div class="gridMinWidth"><%= mensajeDao.obtenerMensajePorCodigo("MSG_LBL_NOMBRE_FIRMANTE_ACT_HIST_JSP", currentLanguage, environmentId)%><!--Nombre actuante--></div></th>
														<th><div class="gridMinWidth"><%= mensajeDao.obtenerMensajePorCodigo("MSG_LBL_FIRMANTE_ACT_HIST_JSP", currentLanguage, environmentId)%><!--Actuante--></div></th>
														<th><div class="gridMinWidth"><%= mensajeDao.obtenerMensajePorCodigo("MSG_LBL_FECHA_ACTUACION_ACT_HIST_JSP", currentLanguage, environmentId)%><!--Fecha actuación--></div></th>
														<th><div style="width: 50px;" class="gridMinWidth"><%= mensajeDao.obtenerMensajePorCodigo("MSG_LBL_FOLIOS_ACT_HIST_JSP", currentLanguage, environmentId) %><!--Folios--></div></th>
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
</BODY>
</HTML>
