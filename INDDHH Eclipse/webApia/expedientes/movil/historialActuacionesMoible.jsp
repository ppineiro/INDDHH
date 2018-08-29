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
	String styleDirectory = "documentum";

	
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
	int contadorActuaciones = 0;
	while(ite.hasNext()){
		Historial oHistorial = ite.next();
		
		strTabla = strTabla + "<tr class='selectableTR'>";
		
		String tablaInfo = "<table><tr><th>Tipo de actuacion: </th><td>" + oHistorial.getStrTipoAct() + "</td></tr><tr><th>Firmantes: </th><td>" + oHistorial.getStrNomFirmante() + "</td></tr><tr><th>Fecha: </th><td>" + oHistorial.getStrFecha() + "</td></tr><tr><th>Folios: </th><td>" + oHistorial.getStrPaginaInicio() + "-" + oHistorial.getStrPaginaFin() + "</td></tr></table>";
		strTabla = strTabla + "<td><div class='gridMinWidth'><button type='button' class='accordion'>Act " + (contadorActuaciones + 1) + "</button><div class='panel'>" + tablaInfo + "</div></div></td>";
		strTabla = strTabla + "</tr>";
		
		contadorActuaciones++;
	}

	
		Boolean leyAcceso = Boolean.parseBoolean(ConfigurationManager.getLeyDeAcceso(environmentId,currentLanguage,false));
		
	
		String msgConf = "MSG_LBL_CONFIDENCIAL_ACT_HIST_JSP"; 
		String widthConf = "50px";
		if (leyAcceso){
			msgConf = "MSG_LBL_ACCESO_RESTRINGIDO_ACT_HIST_JSP";
			widthConf = "100px";
		}
		String tokenId = "";
		if (request.getParameter("tokenId")!=null){
			tokenId = request.getParameter("tokenId").toString();
		}
		String  tabId = "";
		if (request.getParameter("tabId")!=null){
			tabId = request.getParameter("tabId").toString();
		}
		String TAB_ID_REQUEST = "&tabId=" + tabId +"&tokenId=" + tokenId;
%>
<HTML>
<HEAD>
	<title><%= mensajeDao.obtenerMensajePorCodigo("MSG_LBL_TITULO_HISTORIAL_ACTUACIONES_HIST_JSP", currentLanguage, environmentId)%><!--Historial de actuaciones--></title>
<!-- 	<link href="<%=Parameters.ROOT_PATH%>/expedientes/movil/css/mobileExecution.css" rel="styleSheet" type="text/css" media="screen">  -->
<!--	<link href="<%=Parameters.ROOT_PATH%>/css/documentum/common/dogmaErrorPage.css" rel="styleSheet" type="text/css" media="screen"> -->
	<link href="<%=Parameters.ROOT_PATH%>/expedientes/movil/css/historial.css" rel="styleSheet" type="text/css"> 
	<link rel="stylesheet" href="<%= Parameters.ROOT_PATH %>/expedientes/movil/style.css">
    <link rel="stylesheet" href="<%= Parameters.ROOT_PATH %>/expedientes/movil/css/responsive.css">
 
		
	<script>
		var MOBILE = <%="true".equals(session.getAttribute("mobile")) ? "true" : "false"%>;
	
		function imprimir(){
			var originalContents = document.body.innerHTML;
			document.getElementsByClassName("gridBody")[0].style.overflow = "visible";
			document.getElementsByClassName("gridBody")[0].style.heith = "2000px";
			window.print();
			document.body.innerHTML = originalContents;
		}
		
		function getModalReturnValue() {
			imprimir();
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
					<div class="title form-title"><h4>Historial de actuaciones</h4></div>
					<div>Expediente: <%=strNroExpShow%></div>	
				
					<table style="table-layout: fixed; width: 100%;">
						<tbody>
							<tr>
								<td rowspan="3" colspan="4">
									<div class="field exec_field no-ie7 gridContainer" style="width: 100%;">
									
										<div class="gridHeader" style="width: 100%; overflow: hidden;">
											<table cellpadding="0" cellspacing="0" >
												<thead>
													<tr>
														<th><div>Actuaciones</div></th>
													</tr>
												</thead>
											</table>
										</div>
										
										<div class="gridBody" style="width: 100%; height: 270px; overflow-y: auto; overflow-x: hidden; ">
											<table class="tableData" cellpadding="0" cellspacing="0" >
												<tbody >
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
					<ul class="product-tab" role="tablist">
						<li role="presentation" class="active">
							
							<a href="index.jsp?p=0<%=TAB_ID_REQUEST%>">Volver</a>
							
						</li>
					</ul>
					</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</form>
</BODY>
<script>
	var acc = document.getElementsByClassName("accordion");
	var i;
	
	for (i = 0; i < acc.length; i++) {
	    acc[i].onclick = function(){
	        /* Toggle between adding and removing the "active" class,
	        to highlight the button that controls the panel */
	        this.classList.toggle("active");
	
	        /* Toggle between hiding and showing the active panel */
	        var panel = this.nextElementSibling;
	        if (panel.style.display === "block") {
	            panel.style.display = "none";
	        } else {
	            panel.style.display = "block";
	        }
	    }
	}
</script>
</HTML>
