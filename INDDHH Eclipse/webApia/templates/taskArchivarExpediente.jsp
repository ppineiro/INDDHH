<%@ taglib uri='regions' prefix='region'%>
<%@include file="../page/includes/startInc.jsp" %>
<%@include file="../page/includes/headInclude.jsp" %>
<%@include file="../expedientes/jsp/CustomJSP-EXP-ELEC.jsp" %>

<html>
	<head>
		
		<region:render section='scripts_include' />
		
		<link href="<system:util show="context" />/css/documentum/execution/generalExecution.css" rel="stylesheet" type="text/css">
		<link href="<system:util show="context" />/css/documentum/common/modal.css" rel="stylesheet" type="text/css">
		<link href="<system:util show="context" />/templates/css/taskDocumentumTemplates.css" rel="stylesheet" type="text/css">
		<style type="text/css">
		
			/***** MENÚ DE ACCIONES *****/
			#buttonsActions{ position: absolute ; top: 37%; }
		
		</style>
		
		<script src="<system:util show="context" />/templates/js/taskDocumentumUtil.js" type="text/javascript"></script>
		
	</head>
	
	<body onLoad="loadDescargaArchivarExpediente()">
		<div id="exec-blocker"></div>
		<div class="header">
			
		</div>
		
		<div class="body" id="bodyDiv">
			<form id="frmData" action="" method="post">
				<span id="pinShow" class="pinShow" onClick="showMenu()"></span>
				<span id="pinHidden" class="pinHidden" onClick="hiddeMenu()"></span>
				
				<div id="menuContainer" class="optionsContainer menuContainer containerAE">
					
					<div id="taskInfoContainer" class="campaign taskInfoContainer infoContainerAE">
						<system:campaign inLogin="false" inSplash="false" location="verticalUp" />				
						<div style="border-bottom: 1px solid #CCCCCC; width: 310px; height: 20px;">
							<span class="title"><region:render section='title' /></span>		
						</div>
						
						<div id="taskContent" class="taskContent taskContentAE">
							<div id="imgTask" class="imgTask imgTaskAE"></div>
							<div id="descTask" class="descTask descTaskAE">Tarea en la cual se efectúa el archivado de un expediente.</div>
						</div>
										
					</div>	
					
					<div id="expedienteContainer" class="expedienteContainer expedienteContainerAE">
						<div class="title">
							<span id='ExpTitle'> </span>
						</div>
											
						<div id="dowloadContainer" class="dowloadContainer dowloadContainerAE">
							<label id="expSize"></label>							
							<label id="dowloadRef" class="dowloadRef"></label>
							<label id="downModalRef" class="downModalRef"></label>
							<label id="previewRef" class="previewRef"></label>
							<label id="arbolRef" class="arbolRef"></label>				
						</div>	
					</div>
					
					<div id="buttonsActions" class="buttonsActions">
						<region:render section='buttons' />
						
						<div class="fncPanel options">
							<region:render section='helpDocuments' />
						</div>
						
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