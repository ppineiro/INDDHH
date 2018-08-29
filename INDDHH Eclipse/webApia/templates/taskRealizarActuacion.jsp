<%@ taglib uri='regions' prefix='region'%>
<%@include file="../page/includes/startInc.jsp" %>
<%@include file="../page/includes/headInclude.jsp" %>
<%@include file="../expedientes/jsp/CustomJSP-EXP-ELEC.jsp" %>
<%@page import="com.dogma.UserData"%>
<%@page import="com.dogma.controller.ThreadData"%>
<%@page import="uy.com.st.adoc.expedientes.conf.ConfigurationManager"%>

 <%
 
	boolean hideAccesoRestringido = false;
	boolean hideAcordonados = false;
	boolean hideRelacionados = false;
	boolean hideIncorporados = false;
	
	int langId = uData.getLangId();
	
	String eDocsActivo = ConfigurationManager.getHabilitarEDOCS(envId, langId, false);
	boolean eDocsEsActivo = false;
	if (eDocsActivo != null && eDocsActivo.equalsIgnoreCase("true")){
		
		hideAccesoRestringido = ConfigurationManager.getOcultarTABAccesoRestringido(envId, langId, false);
		
		hideAcordonados = ConfigurationManager.getOcultarTABAcordonar(envId, langId, false);
				
		hideRelacionados = ConfigurationManager.getOcultarTABRelacionar(envId, langId, false);
				
		hideIncorporados = ConfigurationManager.getOcultarTABIncorporarParcial(envId, langId, false);
		
		eDocsEsActivo = true;
		
	}
	
	
	String debeRegenarCaratulaARTEE = (String) uData.getUserAttributes().get("DEBE_REGENERAR_CARATULA_ARTEE");

	
	String show_funct = "actuar;modf_cara;elem_fisc";
	
	if (!hideAccesoRestringido) {
		show_funct = show_funct + ";acc_rest";
	}
	
	show_funct = show_funct + ";hist";
		
	if (!hideAcordonados) {
		show_funct = show_funct + ";acords";
	}
	if (!hideRelacionados) {
		show_funct = show_funct + ";relads";
	}
	
	if (!hideIncorporados) {
		show_funct = show_funct + ";incorporados";
	}
	
	show_funct = show_funct + ";val_exhaustiva";
	show_funct = show_funct + ";hist_caratulas";
%>
<%
	//no dejamos que la pagina se cache
	response.setHeader("Pragma", "no-cache");
	response.setHeader("Cache-Control", "no-store");
	response.setDateHeader("Expires", -1);
%>
<html>
	<head>
	
		<region:render section='scripts_include' />

		<link href="<system:util show="context" />/css/documentum/execution/generalExecution.css" rel="stylesheet" type="text/css">
		<link href="<system:util show="context" />/css/documentum/common/modal.css" rel="stylesheet" type="text/css">
		<link href="<system:util show="context" />/templates/css/taskDocumentumTemplates.css" rel="stylesheet" type="text/css">					
		<style type="text/css">
		
			/***** MENÚ DE ACCIONES *****/
			#buttonsActions { position: absolute ; top: 65%; width: 310px; }
			div.options { position: absolute; top: 80%; }
			
			/***** ESTILOS DE ELEMENTOS *****/
			#area_E_1045_41_ifr { height: 150px !important; } /* TAMAÑO IFRAME DE ACTUACION */
			
		</style>
		
		<script src="<system:util show="context" />/templates/js/taskDocumentumUtil.js" type="text/javascript"></script>
		<script type="text/javascript">
			currentTab = <%=request.getParameter("currentTab") != null ? request.getParameter("currentTab") : "3"%>;
		</script>	

	</head>
	
	<body onLoad="loadDescargaRealizarActuacion('<%= eDocsActivo%>','<%=show_funct%>')">
		<div id="exec-blocker"></div>
		<div class="header">
			
		</div>
		
		<div class="body" id="bodyDiv">
			<form id="frmData" action="" method="post">
				<span id="pinShow" class="pinShow" onClick="showMenu()"></span>
				<span id="pinHidden" class="pinHidden" onClick="hiddeMenu()"></span>
				
				<div id="menuContainer" class="optionsContainer menuContainer containerRA">
						
					<div id="taskInfoContainer" class="campaign taskInfoContainer infoContainerRA">
						<system:campaign inLogin="false" inSplash="false" location="verticalUp" />				
						<div style="border-bottom: 1px solid #CCCCCC; width: 310px; height: 20px;">
							<span class="title"><region:render section='title' /></span>
									
						</div>
								
						<div id="taskContent" class="taskContent taskContentRA">
								<div id="imgTask" class="imgTask imgTaskRA"></div>	
								<%if (eDocsEsActivo){%>
								<div id="descTask" class="descTask descTaskRA">Adjuntar documentos del expediente.</div>
								<%}else{%>
								<div id="descTask" class="descTask descTaskRA">Tarea en la cual se trabaja con el expediente.</div>
								<%}%><div id="imgHelpVideo" class="imgHelpVideo" onClick="helpVideo()"></div>
								<%if (debeRegenarCaratulaARTEE != null && debeRegenarCaratulaARTEE.equalsIgnoreCase("true")){%>
									<div id="descModCar" class="descModCar"><b><font color="orange">Debe modificar la car&aacute;tula y completar los campos vac&iacute;os.</font></b></div>
								<%}%>
								<div id="imgFavorite" class="imgFavorite" onClick="favoritoAlterar()"></div>
						</div>										
					</div>
							
					<div id="expedienteContainer" class="expedienteContainer expedienteContainerRA">
						<div class="title">
							<span id='ExpTitle'> </span>
						</div>
											
						<div id="dowloadContainer" class="dowloadContainer dowloadContainerRA">
							<label id="expSize"></label>							
							<label id="dowloadRef" class="dowloadRef"></label>
							<label id="downModalRef" class="downModalRef"></label>
							<label id="previewRef" class="previewRef"></label>
							
<%-- 							<%if (!eDocsEsActivo){%> --%>
								<label id="arbolRef" class="arbolRef"></label>	
<%-- 							<%}%> --%>
										
						</div>	
					</div>						
							
					<div id="tabMenuContainer" class="tabMenuContainer">
								
						<div class="title">
							<span> Funcionalidades </span>
						</div>
								
						<div id="menuTabTable" class="content divFncDescription menuTabTable">
								
							<ul style="list-style-type: none;"> 
											
								<li>
								<div title="Actuar" class="actuar" onClick="actuar()">
								<div id="imgActuar" class="imgActuar"></div>
								<a href="javascript:actuar()"></a> <!-- AGREGADO PARA ACCESIBILIDAD -->
								<span class="actuar"> Actuar </span>
								</div>
								</li>
												
								<!--  
								<li>
								<div title="Modificar carátula" class="modf_cara" onClick="modf_cara()">
								<div id="imgModCar" class="imgModCar"></div>
								<a href="javascript:modf_cara()"></a>
								<span class="modf_cara1"> Modificar </span>
								<span class="modf_cara2"> carátula </span>
								</div>
								</li>
								-->
								
								<li>
								<div title="Modificar carátula" class="modf_cara" onClick="modf_cara_proceso()">
								<div id="imgModCar" class="imgModCar"></div>
								<a href="javascript:modf_cara_proceso()"></a>
								<span class="modf_cara1"> Modificar </span>
								<span class="modf_cara2"> carátula </span>
								</div>
								</li>
										 
								<li>
								<div title="Elementos físicos" class="elem_fisc" onClick="elem_fisc()">
								<div id="imgElemFisc" class="imgElemFisc"></div>
								<a href="javascript:elem_fisc()"></a> <!-- AGREGADO PARA ACCESIBILIDAD -->
								<span class="elem_fisc1"> Elementos </span>
								<span class="elem_fisc2"> físicos </span>
								</div>
								</li>
								
								<%if (!hideAccesoRestringido){%>
								<li>
								<div title="Acceso restringido" class="acc_rest" onClick="acc_rest()">
								<div id="imgAccRest" class="imgAccRest"></div>
								<a href="javascript:acc_rest()"></a> <!-- AGREGADO PARA ACCESIBILIDAD -->
								<span class="acc_rest1"> Acceso </span>
								<span class="acc_rest2"> restringido </span>
								</div>
								</li>
								<%}%>
												 
								<li>
								<div title="Historial de actuaciones" class="hist" onClick="hist()">
								<div id="imgHist" class="imgHist"></div>
								<a href="javascript:hist()"></a> <!-- AGREGADO PARA ACCESIBILIDAD -->
								<span class="hist1"> Historial de </span>
								<span class="hist2"> actuaciones </span>
								</div>
								</li>
													
									
								<%if (!hideAcordonados){%>			 
								<li>
								<div title="Acordonados" class="acords" onClick="acords()">
								<div id="imgAcord" class="imgAcord"></div>
								<a href="javascript:acords()"></a> <!-- AGREGADO PARA ACCESIBILIDAD -->
								<span class="acords"> Acordonar </span>
								</div>
								</li>
								<%}%>
									
								<%if (!hideRelacionados){%>			 
								<li>
								<div title="Relacionados" class="relads" onClick="relads()">
								<div id="imgRelac" class="imgRelac"></div>								
								<a href="javascript:relads()"></a> <!-- AGREGADO PARA ACCESIBILIDAD -->
								<span class="relads"> Relacionar </span>
								</div>
								</li>
								<%}%>
									
								<%if (!hideIncorporados){%>			 
								<li>
								<div title="Incorporación parcial" class="incorporados" onClick="incorporados()">
								<div id="imgIncPar" class="imgIncPar"></div>
								<a href="javascript:incorporados()"></a> <!-- AGREGADO PARA ACCESIBILIDAD -->
								<span class="incorporados1"> Incorporar </span>
								<span class="incorporados2"> Parcialmente </span>
								</div>
								</li>
								<%}%>										
								
								<li>
								<div title="Validación exhaustiva" class="val_exhaustiva" onClick="val_exhaustiva()">
								<div id="imgValEx" class="imgValEx"></div>
								<a href="javascript:val_exhaustiva('<%=envId%>')"></a> <!--AGREGADO PARA ACCESIBILIDAD-->
								<span class="val_ex1"> Validación </span>
								<span class="val_ex2"> exhaustiva </span>
								</div>
								</li>
								
								<li>
								<div title="Historial de carátulas" class="hist_caratulas" onClick="verHistCaratulas(getNroExpe())">
								<div id="imgHistCaratulas"></div>
								<a href="javascript:verHistCaratulas(getNroExpe())"></a> <!--AGREGADO PARA ACCESIBILIDAD-->
								<span class="hist_caratulas1"> Historial </span>
								<span class="hist_caratulas2"> carátulas </span>
								</div>
								</li>
		
							</ul>   
								
						</div>
					</div>				
						
					<div id="buttonsActions" class="buttonsActions">
						<region:render section='buttons' />
						<%if(!eDocsEsActivo){ %>	
							<div class="fncPanel options">
								<region:render section='helpDocuments' />
							</div>
						<%} %>
							
						<region:render section='apiaSocial' />
							
						<system:campaign inLogin="false" inSplash="false" location="verticalDown" />
					</div>
						
				</div>	
					
				<div class="dataContainer">
					<div class='tabComponent' id="tabComponent">
						<div class="aTabHeader"><system:campaign inLogin="false" inSplash="false" location="horizontalUp" /></div>
						<div class='aTab'>
							<div class='tab'  style="display:none"><system:label show="text" label="tabEjeFor"/></div>
							<div class='contentTab'>
								<region:render section='entityForms' />
								<region:render section='processForms' />
							</div>
						</div>
						<div class='aTab'>
							<div class='tab' id="tabComments"><system:label show="text" label="tabEjeObs"/></div>
							<div class='contentTab'>
								<region:render section='taskComments' />
							</div>
						</div>
						<div class='aTab'>
							<div class='tab' style="display:none" id="tabDocs"><system:label show="text" label="tabEjeDoc"/></div>
							<div class='contentTab'>
								<region:render section='entityDocuments' />
								<region:render section='processDocuments' />
							</div>
						</div>
					</div>
					<system:campaign inLogin="false" inSplash="false" location="horizontalDown" />

				</div>	
			 	
			</form>
		</div>
		
		<!-- ESTOS INCLUDES DEBEN IR EN ESTE LUGAR PARA QUE NO SALGA UN CARTEL CUANDO SE ESTA CARGANDO EL TEMPLATE EN CHROME -->
		<%@include file="../page/includes/footer.jsp" %>
		<%@include file="../page/modals/documents.jsp" %>
		<%@include file="../page/modals/calendarsView.jsp" %>
		<%@include file="../page/social/socialShareMdl.jsp" %>
		<%@include file="../page/social/socialReadChannelMdl.jsp" %>	
		<%@include file="../page/execution/includes/endInclude.jsp" %>
		
	</body>

</html>