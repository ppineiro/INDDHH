<%System.out.print("INICIO EL JSP: resultado");%>

<%@ page errorPage="Error.jsp" %>

<%@page import="uy.com.st.adoc.expedientes.solr.Solr"%>
<%@page import="com.dogma.busClass.BusClassException"%>
<%@page import="com.dogma.controller.ThreadData"%>
<%@page import="st.access.BusquedaDao"%>
<%@page import="st.access.Busqueda"%>
<%@page import="st.access.Estados"%>
<%@page import="st.access.Oficinas"%>
<%@page import="st.access.TipoExpediente"%>
<%@page import="st.access.conf.Buscador"%>
<%@page import="st.access.conf.CORRECTOR_ORTOGRAFICO"%>
<%@page import="st.access.conf.FRASES_DE_ACCESO_RAPIDO"%>
<%@page import="java.util.ArrayList"%>
<%@page import="uy.com.st.adoc.expedientes.conf.ConfigurationManager"%>
<%@page import="uy.com.st.documentum.seguridad.Base64"%>
<%@page import="com.dogma.Parameters"%>
<%@page import="com.dogma.EnvParameters"%>
<%@page import="com.dogma.UserData"%>
<%@page import="com.dogma.Configuration"%>
<%@page import="com.st.util.StringUtil"%>
<%@page import="uy.com.st.adoc.expedientes.static_values.StaticProIds"%>
<%@page import="uy.com.st.adoc.expedientes.static_values.StaticEntIds"%>

<html class=" js" lang="es">

	<head>
	
		<%
			response.setHeader("Pragma","no-cache");
			response.setHeader("Cache-Control","no-store");
			response.setDateHeader("Expires",-1);
		
			UserData uData = ThreadData.getUserData();
			String usuario = "";
			if (uData!=null) {
				usuario = uData.getUserId() + "";	
			}
			
			String CAMPO_ORDEN_RESULTADO = st.access.conf.Buscador.CAMPO_ORDEN_RESULTADO;
			String TIPO_ORDEN_RESULTADO = st.access.conf.Buscador.TIPO_ORDEN_RESULTADO;
			BusquedaDao BDao = new BusquedaDao();
			String ROOT_PATH = Parameters.ROOT_PATH;
		
			int environmentId = uData.getEnvironmentId();
			int currentLanguage = uData.getLangId();
			
			String usr = "";
					
			boolean estaApagadoSolr = (ConfigurationManager.isSolrActivo(environmentId, currentLanguage, true)).equals("false");
			String styleDirectory = "default";
			
			if (uData!=null) {
				usuario = uData.getUserId() + "";
				styleDirectory = uData.getUserStyle();
			}
			
			if(request.getParameter("usr")!=null){
				usr = request.getParameter("usr").toString();
			}
			
			if(usuario.equals("busClass")){
				usuario = usr;
			}
			
			String tokenId = "";
			if (request.getParameter("tokenId")!=null){
				tokenId = request.getParameter("tokenId").toString();
			}
			String  tabId = "";
			if (request.getParameter("tabId")!=null){
				tabId = request.getParameter("tabId").toString();
			}
			String TAB_ID_REQUEST = "&tabId=" + tabId +"&tokenId=" + tokenId + "&usr=" +usuario;
			
			String pro_name = "PREGUNTAS_A_USUARIOS";
			String ent_name = "PREGUNTAS_A_USUARIOS";
			Integer pro_id = StaticProIds.getProId(pro_name);
			Integer ent_id = StaticEntIds.getEntId(ent_name);
			
			String pro_name_sol = "SOLICITUDES";
			String ent_name_sol = "SOLICITUD";
			Integer pro_id_sol = StaticProIds.getProId(pro_name_sol);
			Integer ent_id_sol = StaticEntIds.getEntId(ent_name_sol);
			
		%>
		
		<%
			// ------------------------- ETIQUETAS -------------------------
			
			String LBL_TITLE_SEARCH            = BDao.convertTextToHTMLEncoding("¿Qué expediente desea buscar?");
			String LBL_SEARCHER_EXP            = BDao.convertTextToHTMLEncoding("Buscador de Expedientes");
			String LBL_SEARCH_EXP_DP           = BDao.convertTextToHTMLEncoding("Buscar expediente: ");
			String LBL_SATISFACCION            = BDao.convertTextToHTMLEncoding("Ayúdanos a mejorar");
			String LBL_NUMERACION_EXTERNA      = BDao.convertTextToHTMLEncoding("Incluir numeración externa: ");
			String LBL_CLEAN                   = BDao.convertTextToHTMLEncoding("Limpiar");
			String LBL_SUGGESTION              = BDao.convertTextToHTMLEncoding("Sugerencia: puede ingresar el numero o el asunto del expediente.");
			
			String LBL_ORDEN                   = BDao.convertTextToHTMLEncoding("Orden: ");
			String LBL_ORDEN_DESC              = BDao.convertTextToHTMLEncoding("Descendente");
			String LBL_ORDEN_ASC               = BDao.convertTextToHTMLEncoding("Ascendente");
			
			String LBL_NRO_EXPEDIENTE          = BDao.convertTextToHTMLEncoding("Nro Expediente");
			String LBL_ASUNTO                  = BDao.convertTextToHTMLEncoding("Asunto");
			String LBL_ASUNTO_DP               = BDao.convertTextToHTMLEncoding("Asunto: ");
			String LBL_TITULAR                 = BDao.convertTextToHTMLEncoding("Titular");
			String LBL_CONTENIDO               = BDao.convertTextToHTMLEncoding("Contenido");
			String LBL_ADVANCE_SEARCH          = BDao.convertTextToHTMLEncoding("Búsqueda avanzada");
			String LBL_FECHA_CREACION_DP       = BDao.convertTextToHTMLEncoding("Fecha creación: ");
			String LBL_FECHA_CREACION_DESDE_DP = BDao.convertTextToHTMLEncoding("Fecha de creación desde: ");
			String LBL_FECHA_ULTIMO_PASE       = BDao.convertTextToHTMLEncoding("Fecha de último pase");
			String LBL_FECHA_ULTIMO_PASE_DP    = BDao.convertTextToHTMLEncoding("Fecha de último pase: ");
			String LBL_FECHA_PASE_DP           = BDao.convertTextToHTMLEncoding("Fecha pase: ");
			String LBL_TIPO_EXPEDIENTE         = BDao.convertTextToHTMLEncoding("Tipo de expediente");
			String LBL_TIPO_EXPEDIENTE_DP      = BDao.convertTextToHTMLEncoding("Tipo de expediente: ");
			String LBL_OFICINA_ACTUAL          = BDao.convertTextToHTMLEncoding("Oficina Actual");
			String LBL_OFICINA_ACTUAL_DP       = BDao.convertTextToHTMLEncoding("Oficina Actual: ");
			String LBL_USUARIO_ACTUAL_DP       = BDao.convertTextToHTMLEncoding("Usuario actual: ");
			String LBL_ESTADO_DP               = BDao.convertTextToHTMLEncoding("Estado: ");
			String LBL_ACCESO_RESTRINGIDO_DP   = BDao.convertTextToHTMLEncoding("Acceso restringido: ");
			String LBL_ELEMENTO_FISICO_DP      = BDao.convertTextToHTMLEncoding("Elemento físico: ");
			
			String LBL_CLASIFICACION_DP        = BDao.convertTextToHTMLEncoding("Clasificación: ");
			String LBL_CLA_PUBLICO             = BDao.convertTextToHTMLEncoding("Público");
			String LBL_CLA_RESERVADO           = BDao.convertTextToHTMLEncoding("Reservado");
			String LBL_CLA_CONFIDENCIAL        = BDao.convertTextToHTMLEncoding("Confidencial");
			String LBL_CLA_SECRETO             = BDao.convertTextToHTMLEncoding("Secreto");
			
			String VAL_SI                      = BDao.convertTextToHTMLEncoding("Si");
			String VAL_NO                      = BDao.convertTextToHTMLEncoding("No");
			
			String LBL_CARATULA                = BDao.convertTextToHTMLEncoding("Cáratula ");
			String LBL_DESCARGAR               = BDao.convertTextToHTMLEncoding("Descargar");
			String LBL_SOLICITAR               = BDao.convertTextToHTMLEncoding("Solicitar");
			String LBL_TRABAJAR                = BDao.convertTextToHTMLEncoding("Trabajar");
		%>
	
	
		<title>Busqueda | Expedientes</title>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<meta name="description" content="Busqueda de expedientes.">
		<meta name="viewport" content="width=device-width,initial-scale=1.0">
		
		<!-- STYLES -->
		<link rel="stylesheet" href="<%=ROOT_PATH%>/css/documentum/datepicker/datepicker.css" type="text/css" media="screen">
		<link href="<%=ROOT_PATH%>/css/documentum/common/modal.css" rel="stylesheet" type="text/css">
		<link href="<%=ROOT_PATH%>/expedientes/buscador/css/categorias.css" rel="stylesheet" type="text/css">
		<link href="<%=ROOT_PATH%>/expedientes/buscador/css/estilos-resultado.css" rel="stylesheet" type="text/css">
		<!-- STYLES -->
		
		<!-- SCRIPTS -->
		<script type="text/javascript">
		
			var TAB_ID_REQUEST        = "<%=TAB_ID_REQUEST%>";
			var CONTEXT               = "<%=ROOT_PATH%>";
			var STYLE                 = "documentum";
			var DATE_FORMAT           = "d/m/Y";
			var BTN_CONFIRM           = "Confirmar";
			var BTN_CLOSE             = "Cerrar";
			var BTN_CANCEL            = "Cancelar";
			var textoActual           = "";
			var isSolrOff             = <%=estaApagadoSolr%>;
			var MOBILE                = <%="true".equals(session.getAttribute("mobile")) ? "true" : "false"%>;
			var MSIE                  = window.navigator.appVersion.indexOf("MSIE")>=0;
			var LBL_DAYS              = ['Domingo', 'Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado'];
			var LBL_MONTHS            = ['Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio', 'Julio', 'Agosto', 'Setiembre', 'Octubre', 'Noviembre', 'Diciembre'];
			var CAMPO_ORDEN_RESULTADO = "<%=CAMPO_ORDEN_RESULTADO%>";
			var TIPO_ORDEN_RESULTADO  = "<%=TIPO_ORDEN_RESULTADO%>";
			var pro_id                = "<%=pro_id%>";
			var ent_id                = "<%=ent_id%>";
			var pro_id_sol            = "<%=pro_id_sol%>";
			var ent_id_sol            = "<%=ent_id_sol%>";
			
		</script>
		
		<script type="text/javascript" src="<%=ROOT_PATH%>/expedientes/buscador/js/buscador.js"></script>
		<script type="text/javascript" src="<%=ROOT_PATH%>/expedientes/js/CustomJS-EXP-ELEC.js"></script>
		<script type="text/javascript" src="<%=ROOT_PATH%>/js/mootools-core-1.4.5-full-compat.js"></script>
		<script type="text/javascript" src="<%=ROOT_PATH%>/js/mootools-more-1.4.0.1-compat.js"></script>
		<script type="text/javascript" src="<%=ROOT_PATH%>/js/generics.js"></script>
		<script type="text/javascript" src="<%=ROOT_PATH%>/js/modal.js"></script>
		<script type="text/javascript" src="<%=ROOT_PATH%>/js/datepicker/datepicker.js"></script>
		<script src="<%=ROOT_PATH%>/js/modalController.js" type="text/javascript"></script>
		<!-- SCRIPTS -->
		
	</head>
	
	<body onload="cargarInfoExtra()">
	
		<%
			String texto = "";
			String op = "1";
			String txt = "";
			String txtValue = "";		
			if (request.getParameter("q")!=null){
				texto = request.getParameter("q");
				texto = texto.trim();
				txt = texto;
				txtValue = txt; 
			}else{
				txt = Buscador.TEXTO_POR_DEFECTO; 
			}
	
			if (request.getParameter("op") != null) {
				op = request.getParameter("op");
			}
		%>
	
		<div class="box">
			<!-- style="background:red" -->
			<h3><%=LBL_TITLE_SEARCH%></h3>
			<div class="buscador" id="buscador-grande">
				<form action="<%=ROOT_PATH%>/expedientes/buscador/resultado.jsp?a=1<%=TAB_ID_REQUEST%>" method="post" class="form" id="frmMain" name="frmMain">
					<fieldset>
						<legend class="hidden"><%=LBL_SEARCHER_EXP%></legend>
						<label for="search" class="hidden"><%=LBL_SEARCH_EXP_DP%></label> 
						<input type="search" class="search" id="search" name="q" maxlength="60" placeholder="<%=txt%>" list="sugerencias" title="<%=txt%>" value='<%=txtValue%>' onChange="javascript:sugerir()" onkeypress="this.onchange();" oninput="this.onchange();" autocomplete="off">					
						 <!--onkeyup="ponerMayusculas(this, event)"-->
						 <div id="searchDiv"></div>
						 <input type="submit" class="submit" value="Buscar">
					</fieldset>
					<input type="hidden" id="op" name="op" value="<%=op%>">
					<input type="hidden" id="tokenId" name="tokenId" value="<%=tokenId%>" />
					<input type="hidden" id="tabId" name="tabId" value="<%=tabId%>" />				
					<input type="hidden" id="usuario" name="usuario" value="<%=usuario%>" />
					<br>
	
					<table width="100%">
						<tr>						
							<td>&nbsp;&nbsp;<a class="<%=(op.equals("2") ? "one" : "two")%>" href="javaScript:cambiar(2);"><%=LBL_NRO_EXPEDIENTE%></a>&nbsp;&nbsp; </td>
							<td>&nbsp;&nbsp;<a class="<%=(op.equals("1") ? "one" : "two")%>" href="javaScript:cambiar(1);"><%=LBL_ASUNTO%></a>&nbsp;&nbsp; </td>
							<td>&nbsp;&nbsp;<a class="<%=(op.equals("3") ? "one" : "two")%>" href="javaScript:cambiar(3);"><%=LBL_TITULAR%></a>&nbsp;&nbsp; </td>
							<td>&nbsp;&nbsp;<a class="<%=(op.equals("0") ? "one" : "two")%>" href="javaScript:cambiar(0);"><%=LBL_CONTENIDO%></a>&nbsp;&nbsp; </td>
							<!-- <td>&nbsp;&nbsp;<a class="<%=(op.equals("4") ? "one" : "two")%>" href="javaScript:cambiar(4);">Otros datos</a>&nbsp;&nbsp;</td>-->
							<td style="width: 220px;">
							&nbsp;&nbsp;<a class="<%=(op.equals("5") ? "one" : "two")%>" href="javaScript:mostrar();"><%=LBL_ADVANCE_SEARCH%></a>&nbsp;&nbsp;
							<div id="busqueda_avanzada_img" class="busqueda_avanzada_img" ></div>
							</td>
							<td width="25%" align="right">
								<%
									String rdoOperador = "";
									if (request.getParameter("rdoOperador") != null) {
										rdoOperador = request.getParameter("rdoOperador").toString().trim();
									}
									if (rdoOperador.equals("")){
										rdoOperador = "AND";
									}
								%>																
								<input type="radio" id="rdoOperador" name="rdoOperador" value="AND" <%=rdoOperador.equals("AND") ? "checked" : ""%>> <%=BDao.convertTextToHTMLEncoding("Todas las palabras")%>
								<input type="radio" id="rdoOperador" name="rdoOperador" value="OR" <%=rdoOperador.equals("OR") ? "checked" : ""%>> <%=BDao.convertTextToHTMLEncoding("Al menos una")%>
							</td>								
							<td width="15%" align="right">
								<table style="border-collapse:collapse;float:right;margin:auto">
									<tr>
										<td>
											<span style="align: left; float: left;">
												<a align='center' href='#' onclick='showStars(this, 2);'><%=LBL_SATISFACCION%></a>
											</span>
										</td>
									</tr>
								</table>
							</td>
							<td width="5%">&nbsp;&nbsp;&nbsp;&nbsp;</td>
						</tr>
					</table>
	
					<div id='oculto' style="display:none;">
						<table class="tabBA">
							<tr><td>&nbsp;</td></tr>
							
							<tr>
								<td>&nbsp;</td>
								<td>&nbsp;<%=LBL_FECHA_CREACION_DESDE_DP%>&nbsp;</td>
								<td class="filtros">
								<!--  
				    			<input fld_id="E_1042_57" type="text" maxlength="10" class="datePicker dateInput" empty_mask="__/__/____" unmasked_value="17/11/2015" hasdatepicker="true" style="display: inline-block;" id="E_1042_57_d">
				    			<img src="<%=ROOT_PATH%>/css/documentum/img/calendar.png" class="datepickerSelector" style="cursor: pointer;">
				    			--> 
				    			&nbsp;			    			
				    			<input maxlength=30 size="30" id="fch_crea_desde" name="fch_crea_desde" title="DD/MM/YYYY" value="<%=(request.getParameter("fch_crea_desde") != null) ? request.getParameter("fch_crea_desde") : ""%>">&nbsp;hasta:&nbsp;
								<input maxlength=30 size="30" id="fch_crea_hasta" name="fch_crea_hasta" title="DD/MM/YYYY" value="<%=(request.getParameter("fch_crea_hasta") != null) ? request.getParameter("fch_crea_hasta") : ""%>">								
								</td>
								<td>&nbsp;</td>
							</tr>
							
							<tr><td>&nbsp;</td></tr>
							
							<tr>
								<td>&nbsp;</td>
								<td>&nbsp;<%=LBL_FECHA_ULTIMO_PASE_DP%>&nbsp;</td>
								<td>&nbsp;
									<input maxlength=30 size="30" id="fch_pase_desde" name="fch_pase_desde" title="DD/MM/YYYY" value="<%=(request.getParameter("fch_pase_desde") != null) ? request.getParameter("fch_pase_desde") : ""%>">&nbsp;hasta:&nbsp;
									<input maxlength=30 size="30" id="fch_pase_hasta" name="fch_pase_hasta" title="DD/MM/YYYY" value="<%=(request.getParameter("fch_pase_hasta") != null) ? request.getParameter("fch_pase_hasta") : ""%>">								
								</td>
								<td>&nbsp;</td>
							</tr>
							
							<tr><td>&nbsp;</td></tr>
							
							<tr>
								<td>&nbsp;</td>
								<td>&nbsp;<%=LBL_TIPO_EXPEDIENTE_DP%>&nbsp;</td>
								<td>&nbsp;
								<select style="width: 250px;" id="cmbTipoExpedientes" name="cmbTipoExpedientes">
										<option value=""></option>
										<%
											String selected = "";
											ArrayList<TipoExpediente> arrTipoExpedientes = BDao.getArrTipoExpedientes();
											for (int i = 0; i < arrTipoExpedientes.size(); i++) {
	
												if (request.getParameter("cmbTipoExpedientes") != null) {
													if (request.getParameter("cmbTipoExpedientes").toString().equals(arrTipoExpedientes.get(i).getNum())) {
														selected = "selected";
													} else {
														selected = "";
													}
												}
												%>
												<option value="<%=arrTipoExpedientes.get(i).getNum()%>" <%=selected%>>
												<%=BDao.convertTextToHTMLEncoding(arrTipoExpedientes.get(i).getTipo())%>
												</option>
												<%
											}
										%>
								</select>
								</td>
								<td>&nbsp;</td>
							</tr>
							
							<tr><td>&nbsp;</td></tr>
							
							<tr>
								<td>&nbsp;</td>
								<td>&nbsp;<%=LBL_OFICINA_ACTUAL_DP%>&nbsp;</td>
								<td>&nbsp;
								<select style="width: 250px;" id="cmbOficinaActual" name="cmbOficinaActual">
										<option value=""></option>
										<%
											ArrayList<Oficinas> arrOficinas = BDao.getArrOficinas();
											selected = "";
											for (int i = 0; i < arrOficinas.size(); i++) {
												if (request.getParameter("cmbOficinaActual") != null) {
													if (request.getParameter("cmbOficinaActual").toString().equals(arrOficinas.get(i).getNum())) {
														selected = "selected";
													} else {
														selected = "";
													}
												}
												%>
												<option value="<%=arrOficinas.get(i).getNum()%>" <%=selected%>>
												<%=BDao.convertTextToHTMLEncoding(arrOficinas.get(i).getTipo())%>
												</option>
												<%
											}
										%>
								</select>
								</td>
								<td>&nbsp;</td>
							</tr>
							
							<tr><td>&nbsp;</td></tr>
							
							<tr>
								<td>&nbsp;</td>
								<td>&nbsp;<%=LBL_ESTADO_DP%>&nbsp;</td>
								<td>&nbsp;
								<select style="width: 250px;" id="cmbEstado" name="cmbEstado">
										<option value=""></option>
										<%
											ArrayList<Estados> arrEstados = BDao.getArrEstados();
											selected = "";
											for (int i = 0; i < arrEstados.size(); i++) {
												if (request.getParameter("cmbEstado") != null) {
													if (request.getParameter("cmbEstado").toString().equals(arrEstados.get(i).getNum())) {
														selected = "selected";
													} else {
														selected = "";
													}
												}
												%>
												<option value="<%=arrEstados.get(i).getNum()%>" <%=selected%>>
												<%=BDao.convertTextToHTMLEncoding(arrEstados.get(i).getTipo())%>
												</option>
												<%
											}
										%>
								</select>
								</td>
								<td>&nbsp;</td>
							</tr>
							
							<tr><td>&nbsp;</td></tr>
							
							<tr>
								<td>&nbsp;</td>
								<td>&nbsp;<%=LBL_ACCESO_RESTRINGIDO_DP%>&nbsp;</td>
								<td>&nbsp;
								<select style="width: 250px;" id="cmbAccesoRestringido" name="cmbAccesoRestringido">
										<%
											selected = "";
											if (request.getParameter("cmbAccesoRestringido") != null) {
												selected = request.getParameter("cmbAccesoRestringido").toString().trim();
											}
										%>
										<option value=""></option>
										<option value="2" <%=selected.equals("2") ? "selected" : ""%>><%=VAL_SI%></option>
										<option value="1" <%=selected.equals("1") ? "selected" : ""%>><%=VAL_NO%></option>
								</select>
								</td>
								<td>&nbsp;</td>
							</tr>
							
							<tr><td>&nbsp;</td></tr>
							
							<tr>
								<td>&nbsp;</td>
								<td>&nbsp;<%=LBL_ELEMENTO_FISICO_DP%>&nbsp;</td>
								<td>&nbsp;
								<select style="width: 250px;" id="cmbElemFisc" name="cmbElemFisc">
										<%
											selected = "";
											if (request.getParameter("cmbElemFisc") != null) {
												selected = request.getParameter("cmbElemFisc").toString().trim();
											}
										%>
										<option value=""></option>
										<option value="2" <%=selected.equals("2") ? "selected" : ""%>><%=VAL_SI%></option>
										<option value="1" <%=selected.equals("1") ? "selected" : ""%>><%=VAL_NO%></option>
								</select>
								</td>
								<td>&nbsp;</td>
							</tr>
							
							<tr><td>&nbsp;</td></tr>
							
							<tr>
								<td>&nbsp;</td>
								<td>&nbsp;<%=LBL_CLASIFICACION_DP%>&nbsp;</td>
								<td>&nbsp;
								<select style="width: 250px;" id="cmbClasificacion" name="cmbClasificacion">
										<%
											selected = "";
											if (request.getParameter("cmbClasificacion") != null) {
												selected = request.getParameter("cmbClasificacion").toString().trim();
											}
										%>
										<option value=""></option>
										<option value="1" <%=selected.equals("1") ? "selected" : ""%>><%=LBL_CLA_PUBLICO%></option>
										<option value="2" <%=selected.equals("2") ? "selected" : ""%>><%=LBL_CLA_RESERVADO%></option>
										<option value="3" <%=selected.equals("3") ? "selected" : ""%>><%=LBL_CLA_CONFIDENCIAL%></option>
										<option value="4" <%=selected.equals("4") ? "selected" : ""%>><%=LBL_CLA_SECRETO%></option>
								</select>
								</td>
								<td>&nbsp;</td>
							</tr>
							
							<tr><td>&nbsp;</td></tr>
							
							<tr>
								<td>&nbsp;</td>
								<td>&nbsp;<%=LBL_NUMERACION_EXTERNA%>&nbsp;</td>
								<td>&nbsp; <input type="checkbox" id="chkIncNumExt" name="chkIncNumExt" <%=(request.getParameter("chkIncNumExt") != null) ? "checked" : ""%>></input> &nbsp;</td>
								<td>&nbsp;&nbsp;</td>
							</tr>
							
							<tr><td>&nbsp;</td></tr>
							
							<tr>
								<td>&nbsp;</td>
								<td>&nbsp;<%=LBL_ORDEN%>&nbsp;</td>
								<td>&nbsp;
								<select style="width: 120px;" id="cmbCampoOrden" name="cmbCampoOrden">
										<%
											selected = "";
											if (request.getParameter("cmbCampoOrden") != null) {
												selected = request.getParameter("cmbCampoOrden").toString().trim();
											}								
										%>									
										<option value="ATT_VALUE_1" <%=selected.equals("ATT_VALUE_1") ? "selected" : ""%>><%=LBL_NRO_EXPEDIENTE%></option>
										<option value="ATT_VALUE_2" <%=selected.equals("ATT_VALUE_2") ? "selected" : ""%>><%=LBL_ASUNTO%></option>
										<option value="OFICINA_ACTUAL" <%=selected.equals("OFICINA_ACTUAL") ? "selected" : ""%>><%=LBL_OFICINA_ACTUAL%></option>
										<option value="TIPO_EXPEDIENTE" <%=selected.equals("TIPO_EXPEDIENTE") ? "selected" : ""%>><%=LBL_TIPO_EXPEDIENTE%></option>
										<option value="ATT_VALUE_DTE_2" <%=selected.equals("ATT_VALUE_DTE_2") ? "selected" : ""%>><%=LBL_FECHA_ULTIMO_PASE%></option>
									</select>
									&nbsp;
									<select style="width: 120px;" id="cmbOrden" name="cmbOrden">
										<%
											selected = "";
											if (request.getParameter("cmbOrden") != null) {
												selected = request.getParameter("cmbOrden").toString().trim();
											}								
										%>				
										<option value="DESC" <%=selected.equals("DESC") ? "selected" : ""%>><%=LBL_ORDEN_DESC%></option>					
										<option value="ASC" <%=selected.equals("ASC") ? "selected" : ""%>><%=LBL_ORDEN_ASC%></option>
																				
									</select>
								</td>
								<td>&nbsp;<a class="" href="javaScript:limpiar();"><%=LBL_CLEAN%></a>&nbsp;</td>
							</tr>
	  
						</table>
					</div>			
				</form>
	
			</div>
			<p class="tip"><%=LBL_SUGGESTION%></p>
		</div>
	
		<%
			ArrayList<Busqueda> arr = new ArrayList<Busqueda>();
			String pagina = "1";
			int CANTIDAD_REGISTROS_POR_PAGINA = Buscador.CANTIDAD_REGISTROS_POR_PAGINA;
			int CANT_MINIMA_CARACTERES = Buscador.CANT_MINIMA_CARACTERES;
			int PAGINA_ACTUAL = Integer.parseInt(pagina);		
	
			boolean hayQueConsultar = true;
	
			if (request.getParameter("q") != null) {
				if (request.getParameter("pagina") != null) {
					pagina = request.getParameter("pagina");
					PAGINA_ACTUAL = Integer.parseInt(pagina);
					
					if (PAGINA_ACTUAL > 0) {
						if (session.getAttribute("arrExp") != null) {
							arr = (ArrayList<Busqueda>) session.getAttribute("arrExp");
							hayQueConsultar = false;
						}
					}
				}
	
				if (texto.length() < CANT_MINIMA_CARACTERES) {
					hayQueConsultar = false;
				}
	
				if (hayQueConsultar){
	
					BDao.cargarFiltros(request.getParameter("fch_crea_desde"),
							request.getParameter("fch_crea_hasta"),
							request.getParameter("fch_pase_desde"),
							request.getParameter("fch_pase_hasta"),
							request.getParameter("cmbTipoExpedientes"),
							request.getParameter("cmbOficinaActual"),
							request.getParameter("cmbEstado"),
							request.getParameter("cmbAccesoRestringido"),
							request.getParameter("cmbElemFisc"),
							request.getParameter("cmbClasificacion"),
							request.getParameter("chkIncNumExt"),
							request.getParameter("rdoOperador"),
							request.getParameter("cmbCampoOrden"),
							request.getParameter("cmbOrden")						
							);
					
						if (op.equals("0")) {
							//POR CONTENIDO
							if (Solr.isSolrOn()) {
								arr = BDao.busquedaOpcion0(texto, PAGINA_ACTUAL - 1, usuario, environmentId);
							} else {
								op = "1";
							}
						}
						if (op.equals("1")) {
							//POR ASUNTO
							arr = BDao.busquedaOpcion1(texto, usuario, environmentId);
						}
						if (op.equals("2")) {
							//POR NRO DE EE
							arr = BDao.busquedaOpcion2(texto, environmentId);
						}
						if (op.equals("3")) {
							//POR TITULAR				
							arr = BDao.busquedaOpcion3(texto, environmentId);
						}
						if (op.equals("4")) {
							//POR OTROS DATOS					
							arr = BDao.busquedaOpcion4(texto, environmentId);
						}
						session.setAttribute("arrExp", arr);
						session.setAttribute("tiempoEjec", BDao.getTiempoEjecucionEnSeg());
					}
			}
		%>
		<div class="contenedor buscadorResultados cfx">
			<!-- style="background:yellow;"  -->
			
			<div class="contenido cfx">
			<%if (texto.length() < CANT_MINIMA_CARACTERES) {%>
				<%if (request.getParameter("q") != null) {%>
					<%@ include file="no-minimo.jsp"%>
				<%}%>
			<%} else {%>
			
			<%if ((arr == null || arr.size() == 0) && (!texto.equals(""))) {%>
				<%@ include file="no-encontrado.jsp"%>
			<%} else {%>
	
				<%@ include file="paginado.jsp"%>
							
				<div class="resultadosContenido slide">
					<div class="resultadosListado">
						<ul>
							<%for (int i = inicio; i <= fin; i++) {										
									Busqueda t = arr.get(i);%>
							<li>
								<h4>
									<%=BDao.getPrioridadIcono(t.getPrioridad())%>
									<%=t.getAbierto()%>
									<%=t.getClasificacionIcono(t.getClasificacion())%>
									<%=t.getDocFisicaIcono(t.getDocFisica())%>
									<%=t.getConfidencialidadIcono(t.getConfidencialidad())%>								
									<%=t.setearIconosRelacionado(t.getNroExp(), environmentId)%>
									<%=t.setearIconosAcordonado(t.getNroExp(), environmentId)%>
									
									<%if(t.getTieneTitulares()){%>
										<button title="TITULARES" id="b_tit" style= 'background:transparent; outline: none; cursor: pointer' onmouseover="javascript:showdiv(this , '<%=environmentId%>' , '<%=t.getNroExp()%>');return false;">
											<img style="width: 24px; height: 24px; position: relative; top: 5px;" src="<%=ROOT_PATH%>/expedientes/buscador/img/titulares.png"/>
										</button>
									<% } %>
										
									<a href='javascript:redirectArbol("<%=t.getNroExp()%>")'>									
										<span id="posicion"></span>
										<strong><%=t.getNroExp()%>&nbsp;-&nbsp;<%=BDao.convertTextToHTMLEncoding(BDao.getTipoExpedientes(t.getTipoExpediente()))%></strong>
									</a>
										
									&nbsp;
									<button id="fav" style= 'background:transparent; outline: none; cursor: pointer' onclick="javascript:favorito('<%=t.getNroExp()%>','<%=BDao.getGrupo(t.getOficinaActual())%>',this)">
										<%if(t.obtenerEstadoFavorito(usuario, environmentId)){ %> <img src="<%=ROOT_PATH%>/expedientes/iconos/fav_12.png"/>
										<%} else {%> <img src="<%=ROOT_PATH%>/expedientes/iconos/favOn_12.png"/> <% } %>
									</button>
									&nbsp;
									<button id="fav" style= 'background:transparent; outline: none; cursor: pointer' onclick="javascript:mostrarHistorialResultado('<%=t.getNroExp()%>')">
										<img style="width: 12px; height: 12px" src="<%=ROOT_PATH%>/expedientes/iconos/tabsbuttons/history.png"/>							
									</button>
																
								</h4>
	
								<p>
									<strong><%=LBL_FECHA_CREACION_DP%></strong><%=t.getFechaCreacion()%>&nbsp;-&nbsp;
									<strong><%=LBL_ESTADO_DP%></strong><%=BDao.convertTextToHTMLEncoding(t.getEstadoDesc(environmentId))%>								
								</p>
	
								<p><strong><%=LBL_ASUNTO_DP%></strong>
								<%=BDao.convertTextToHTMLEncoding(t.getAsunto())%>...</p>
								
								<p>
									<strong><%=LBL_FECHA_PASE_DP%></strong>
									<%=t.getFechaPase()%>&nbsp;-&nbsp;								
									<%
									String ubicacion = t.getOficinaActual();								
									 if (t.getEstado().equals("EN_ORGANISMO_EXTERNO")){
										 ubicacion = BDao.getGrupo(t.getOrganismoExterno(environmentId, t.getNroExp()));
									 }
									 if (t.getEstado().equals("ARCHIVADO")){
										 ubicacion = BDao.getGrupo(t.getNodoArchivador(environmentId, t.getNroExp()));
									 }
									%>
									<strong><%=LBL_OFICINA_ACTUAL_DP%></strong><%=BDao.convertTextToHTMLEncoding(ubicacion)%>&nbsp;-&nbsp;
									<strong><%=LBL_USUARIO_ACTUAL_DP%></strong><%=BDao.convertTextToHTMLEncoding(BDao.getUsuario(t.getUsuarioActual()))%>
								</p>
								
								<p class="urlBusqueda">
									<span> <img src="<%=ROOT_PATH%>/expedientes/iconos/pdf.gif">
										&nbsp;&nbsp; Expediente <%=t.getNroExp()%>.pdf&nbsp;&nbsp;
										<a href="javascript:verFoliado('<%=new Base64().encode(t.getNroExp())%>','TSKOtra')"><%=LBL_DESCARGAR%></a>&nbsp;&nbsp;
										<span id="info-tamanio-<%=i%>ee"><%=t.getNroExp()%></span>
	
	
										&nbsp;-&nbsp; <%=LBL_CARATULA%><%=t.getNroExp()%>.pdf &nbsp;-&nbsp;
										<a href="javascript:verCaratula('<%=new Base64().encode(t.getNroExp())%>','TSKOtra')"><%=LBL_DESCARGAR%></a>
										
										<% String valoresPro = t.getValoresProceso(environmentId, usuario); %>
	
										<%
											boolean estaAcordonado = !t.setearIconosAcordonado(t.getNroExp(), environmentId).equals("");
											boolean esHijo = false;
										
											if (estaAcordonado){
												esHijo = t.esHijo(t.getNroExp());
											}										
										
											if (valoresPro.equals("Solicitar") && (!t.getEstado().equals("TRABAJO_COLABORATIVO") && !esHijo)) {
												%>
												&nbsp;-&nbsp;<a href="javascript:solicitarEEFromProcess('<%=t.getNroExp()%>','<%=t.getOficinaActual()%>','<%=t.getUsuarioActual()%>','<%=BDao.getUsuario(t.getUsuarioActual()).replace("'","/cc/")%>')"><%=LBL_SOLICITAR%></a>
												<%
											} else {
												if (!t.getEstado().equals("ARCHIVADO") && !t.getEstado().equals("TRABAJO_COLABORATIVO") && !esHijo){
													%>
													&nbsp;-&nbsp;<a href="javascript:trabajarEE('<%=valoresPro%>')"><%=LBL_TRABAJAR%></a>
													<%
												}
											}
										%>
									</span>
	
								</p>
							</li>
							<br>
							<%}	%>
						</ul>
						<br>
					</div>
				</div>
				<div class="caratula" id="DetalleEE" style="display: none;"></div>
				<div class="titulares_div" id="titulares_div" style="display: none;position:absolute;top:0;right:0;border-style: solid;border-color: #155E92;width: 450px;height: 200px; background: white; box-shadow: 0px 4px 23px 3px #a8a"></div>
				
				</div>
				<%}%>
			<%}%>
			</div>

	</body>
	
</html>
