<%@ taglib uri='regions' prefix='region'%>
<%@include file="../page/includes/startInc.jsp" %>
<html>
<head>
	<%@include file="../page/includes/headInclude.jsp" %>
	<link href="<system:util show="context" />/css/<system:util show="currentStyle" />/generalExecution.css" rel="stylesheet" type="text/css">
	<link href="<system:util show="context" />/css/<system:util show="currentStyle" />/modal.css" rel="stylesheet" type="text/css">
	<region:render section='scripts_include' />
	<script type="text/javascript">
		currentTab = <%=request.getParameter("currentTab") != null ? request.getParameter("currentTab") : "2"%>;
	</script>
	
	<style type="text/css">
		#taskContent { width: 300px; height: 110px; }
		#imgTask{ position: absolute; top: 12.5%; background: url(/Apia/templates/img/iniciar_expediente.png); background-size: 80px; background-repeat: no-repeat; width: 80px; height: 120px; }
		#fncDescriptionText { position: absolute; left: 40%; top: 20%; font-size: 12px; }		    
	</style>
	
</head>

<body>
	<div id="exec-blocker"></div>
	<div class="header">
		
	</div>
	
	<div class="body" id="bodyDiv">
		<form id="frmData" action="" method="post">
		
			<div class="optionsContainer">
				<div class="fncPanel info">
					<div class="campaign"><system:campaign inLogin="false" inSplash="false" location="verticalUp" /></div>
					<div class="title">
						<span class="title"><region:render section='title' /></span>
						<span class="panelPinShow" id="panelPinShow">&nbsp;</span>
					</div>
					<div id="taskContent" class="content divFncDescription">
						<div id="imgTask"></div>
						<div class="fncDescriptionText" id="fncDescriptionText"><region:render section='tskDescription' /></div>
						<div class="clear"></div>
					</div>
				</div>			
				
				<div class="buttonsActions">
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
						<div class='tab'  style="display:none;"><system:label show="text" label="tabEjeFor"/></div>
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

					</div> 
				</div>
				<system:campaign inLogin="false" inSplash="false" location="horizontalDown" />		 
						
		</form>
	</div>
	
	<!-- ESTOS INCLUDES DEBEN IR EN ESTE LUGAR PARA QUE NO SALGA UN CARTEL CUANDO SE ESTA CARGANDO EL TEMPLATE EN CHROME -->
	<%@include file="../page/includes/footer.jsp" %>
	<%@include file="../page/modals/documents.jsp" %>
	<%@include file="../page/modals/calendarsView.jsp" %>
	<%@include file="../page/social/socialShareMdl.jsp" %>
	<%@include file="../page/social/socialReadChannelMdl.jsp" %>	
	<%@include file="../page/execution/includes/endInclude.jsp" %>
	<%@include file="../expedientes/jsp/CustomJSP-EXP-ELEC.jsp" %>
	
</body>

</html>
