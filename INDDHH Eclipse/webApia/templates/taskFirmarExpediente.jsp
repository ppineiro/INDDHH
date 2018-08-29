<%@ taglib uri='regions' prefix='region'%>
<%@include file="../page/includes/startInc.jsp" %>
<%@include file="../page/includes/headInclude.jsp" %>
<%@include file="../expedientes/jsp/CustomJSP-EXP-ELEC.jsp" %>
<%@page import="com.dogma.UserData"%>
<%@page import="com.dogma.controller.ThreadData"%>
<%@page import="uy.com.st.adoc.expedientes.conf.ConfigurationManager"%>

<%
	int langId = uData.getLangId();
	String eDocsActivo = ConfigurationManager.getHabilitarEDOCS(envId, langId, false);
	boolean eDocsEsActivo = ConfigurationManager.isEDOCS(envId, langId, false);
%>

<html>
	<head>
		
		<region:render section='scripts_include' />
		
		<link href="<system:util show="context" />/css/documentum/execution/generalExecution.css" rel="stylesheet" type="text/css">
		<link href="<system:util show="context" />/css/documentum/common/modal.css" rel="stylesheet" type="text/css">
		<link href="<system:util show="context" />/templates/css/taskDocumentumTemplates.css" rel="stylesheet" type="text/css">
		<style type="text/css">
		
			/***** MENÚ DE ACCIONES *****/
			#buttonsActions { position: absolute ; top: 90%; }
		
			/***** ESTILOS DE ELEMENTOS *****/
			.content { width: 310px; }
			
		</style>
		
		<script src="<system:util show="context" />/templates/js/taskDocumentumUtil.js" type="text/javascript"></script>
		
	</head>
	
	<body onLoad="loadDescargaFirmarExpediente('<%= eDocsActivo%>')">
		<div id="exec-blocker"></div>
		<div class="header">
			
		</div>
		
		<div class="body" id="bodyDiv">
			<form id="frmData" action="" method="post">
				<span id="pinShow" class="pinShow" onClick="showMenu()"></span>
				<span id="pinHidden" class="pinHidden" onClick="hiddeMenu()"></span>
				
				<div id="menuContainer" class="optionsContainer menuContainer containerFE">
									
					<div id="taskInfoContainer" class="campaign taskInfoContainer infoContainerFE">
						<system:campaign inLogin="false" inSplash="false" location="verticalUp" />
						<div style="border-bottom: 1px solid #CCCCCC; width: 320px; height: 20px;">
							<span class="title"><region:render section='title' /></span>		
						</div>
						
						<div id="taskContent" class="taskContent taskContentFE">
							<div id="imgTask" class="imgTask imgTaskFE"></div>
							<div id="descTask" class="descTask descTaskFE">Tarea en la cual se efectúa la firma.</div>
						</div>
										
						</div>	
					
					<div id="expedienteContainer" class="expedienteContainer expedienteContainerFE">
						<div class="title">
							<span id='ExpTitle'> </span>
						</div>
											
						<div id="dowloadContainer" class="dowloadContainer dowloadContainerFE">
							<label id="expSize"></label>							
							<label id="dowloadRef" class="dowloadRef"></label>
							<label id="downModalRef" class="downModalRef"></label>
							<label id="previewRef" class="previewRef"></label>
							
							<%if (!eDocsEsActivo){%>
								<label id="arbolRef" class="arbolRef"></label>	
							<%}%>
											
						</div>	
					</div>
					
					<div id="buttonsActions" class="buttonsActions">
						<region:render section='buttons' />
						
						<%if (!eDocsEsActivo){%>			
							<div class="fncPanel options">
								<region:render section='helpDocuments' />
							</div>
						<%}%>
						
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