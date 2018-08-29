<%response.setCharacterEncoding(com.dogma.Parameters.APP_ENCODING);%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Iterator"%>
<%@page import="uy.com.st.adoc.expedientes.elementosFisicos.UtilEleFisicos"%>
<%@page import="uy.com.st.adoc.expedientes.elementosFisicos.LineaGrdEleFisico"%>
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
	
	String strNroExpediente = request.getParameter("NroExp");
	System.out.println(strNroExpediente);
	String strTabla = "";

 	UtilEleFisicos uef = new UtilEleFisicos();	
	ArrayList<LineaGrdEleFisico> arrExp =  uef.cargarEleFisicoExpediente("", environmentId, strNroExpediente);

	strTabla = "";
	
	for(int i = 0; i < arrExp.size(); i++){
		LineaGrdEleFisico linea = arrExp.get(i);
		strTabla = strTabla + "<tr class='selectableTR'>";
			strTabla = strTabla + "<td><div class='gridMinWidth' style='width: 144px'>" + linea.getNroExpediente() + "</div></td>";
			strTabla = strTabla + "<td><div class='gridMinWidth' style='width: 144px'>" + linea.getAsunto() + "</div></td>";
			strTabla = strTabla + "<td><div class='gridMinWidth' style='width: 144px'>" + linea.getTipoDocFisica() + "</div></td>";
			strTabla = strTabla + "<td><div class='gridMinWidth' style='width: 144px'>" + linea.getDescDocFisica() + "</div></td>";
			strTabla = strTabla + "<td><div class='gridMinWidth' style='width: 144px'>"  + linea.getAcompaniaExpediente() + "</div></td>";
			strTabla = strTabla + "<td><div class='gridMinWidth' style='width: 131px'>" + linea.getUbicacionExpediente() + "</div></td>";
		strTabla = strTabla + "</TR>";
	}
%>

<HTML>
	<HEAD>
		<title><%= mensajeDao.obtenerMensajePorCodigo("MSG_LBL_TITULO_ELE_FISICOS_EXPEDIENTE_JSP", currentLanguage, environmentId)%><!--Historial de actuaciones--></title>

		<link href="<%=Parameters.ROOT_PATH%>/css/<%=styleDirectory%>/generalExecution.css" rel="styleSheet" type="text/css" media="screen">
		<link href="<%=Parameters.ROOT_PATH%>/css/<%=styleDirectory%>/dogmaErrorPage.css" rel="styleSheet" type="text/css" media="screen">
	
	</HEAD>
		
	<BODY>
		<form id="frmData" action="post" method="post"">
			<div class="dataContainer" >
				<div class="tabComponent" id="tabComponent" style="padding-top: 22px;">
					<div class="aTab">
						<div class="contentTab active">
							<div class="tabContent" >
								<div class="formContainer fieldGroup">
									
									<div class="collapseForm"></div> <!-- Imagen de formulario cerrado -->
									<div class="title form-title">
										<%= mensajeDao.obtenerMensajePorCodigo("MSG_LBL_SUBTITULO_TIPO_ELE_FISICO_JSP", currentLanguage, environmentId)%><!--Historial de Actuaciones del Expediente--> <%=strNroExpediente%>
									</div>
									
									<input type=hidden name='hidFrm1055Closed' id='hidFrm1055Closed' value='false' >
									
									<!---------------------------- START FORM ----------------------------> 
									<table style="table-layout: fixed; width: 100%;">
										<tbody>
											<tr>
												<td  rowspan="3" colspan="4">
													<div class="field exec_field no-ie7 gridContainer">
													
														<div class="gridHeader" style="width: 959px; overflow: hidden;">
															<table cellpadding="0" cellspacing="0" >
																<thead>
																	<tr>
																		<th> <div class="gridMinWidth"><%= mensajeDao.obtenerMensajePorCodigo("MSG_LBL_NRO_EXP_DOC_FISICA_EF_JSP", currentLanguage, environmentId)%></div> </th>
																		<th> <div class="gridMinWidth"><%= mensajeDao.obtenerMensajePorCodigo("MSG_LBL_ASUNTO_DOC_FISICA_EF_JSP", currentLanguage, environmentId)%></div></th>
																		<th> <div class="gridMinWidth"><%= mensajeDao.obtenerMensajePorCodigo("MSG_LBL_TIPO_DOC_FISICA_EF_JSP", currentLanguage, environmentId)%></div></th>
																		<th> <div class="gridMinWidth"><%= mensajeDao.obtenerMensajePorCodigo("MSG_LBL_DESC_DOC_FISICA_EF_JSP", currentLanguage, environmentId)%></div></th>
																		<th> <div class="gridMinWidth"><%= mensajeDao.obtenerMensajePorCodigo("MSG_LBL_ACOMPANIA_EF_JSP", currentLanguage, environmentId)%></div></th>
																		<th> <div class="gridMinWidth" style='width: 133px'><%= mensajeDao.obtenerMensajePorCodigo("MSG_LBL_UBICACION_DOC_FISICA_EF_JSP", currentLanguage, environmentId)%></div></th>
																	</tr>
																</thead>
															</table>														
														</div>
														
														<div class="gridBody" style="width: 959px; height: 270px; overflow: auto; ">
															<table cellpadding="0" cellspacing="0" >
																<tbody class="tableData">
																	<%=strTabla%>
																</tbody>
															</table>
														</div>
														
														<div class="gridFooter" style="width: 959px;"></div>
														
													</div>
												</td>
											</tr>
										</tbody>
									</table>
									
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</form>		
		
	</BODY>
		
</HTML>
