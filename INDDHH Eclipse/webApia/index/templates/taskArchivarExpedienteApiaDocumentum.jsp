<%@ taglib uri='regions' prefix='region'%>
<%@include file="../page/includes/startInc.jsp" %>
<%@include file="../page/includes/headInclude.jsp" %>
<%@include file="../expedientes/jsp/CustomJSP-EXP-ELEC.jsp" %>


<html>
	<head>
			
		<link href="<system:util show="context" />/css/<system:util show="currentStyle" />/generalExecution.css" rel="stylesheet" type="text/css">
		<link href="<system:util show="context" />/css/<system:util show="currentStyle" />/modal.css" rel="stylesheet" type="text/css">
		<region:render section='scripts_include' />
		
		
	
		<style type="text/css">
		
			/* Div General */
			#menuContainer { position: absolute; width: 310px; height: 600px; display: inline-block; float: right; right: 0px; z-index: 1; background-color: #FFF; }
			
			/* Panel de la tarea */	
			#taskInfoContainer { position: absolute; width: 310px; height: 125px; }
			#taskTitleContainer { position: absolute; top: 0%; }
			#taskContent { position: absolute; top:20%; width: 300px; height: 100px; }
			#imgTask { position: absolute; top: 10%; background: url(/Apia/templates/img/archivar_expediente.png); background-size: 80px; background-repeat: no-repeat; width: 80px; height: 100px; } 
			#descTask{ position: absolute; top: 55%; left: 40%; width: 130px; font-size: 12px; }
			div.titImage{ display: inline; }
			div.proTitle{ display: inline; font-weight: bold; font-size: 12px; }
			div.taskTitle{ display: inline; font-weight: bold; font-size: 12px; }		
			
			/* Menu de botones */
			#buttonsActions{ position: absolute ; top: 25%; }
			
			/* Estilo de elementos */			
			div#hmenu ul { list-style: none; margin: 5; padding: 0; list-style-type: none; }			
			div#hmenu ul li { margin: 0; padding: 0; display: inline; }			
			div#hmenu ul a:link{ margin: 0; padding: .3em .4em .3em .4em; text-decoration: none; font-weight: bold; font-size: medium; } 
			div#hmenu ul a:visited{ margin: 0; padding: .3em .4em .3em .4em; text-decoration: none; font-weight: bold; font-size: medium; } 
			div#hmenu ul a:active{ margin: 0; padding: .3em .4em .3em .4em; text-decoration: none; font-weight: bold; font-size: medium; } 
			div#hmenu ul a:hover{ margin: 0; padding: .3em .4em .3em .4em; text-decoration: none; font-weight: bold; font-size: medium; }
			
		</style>
	</head>
	
	<body>
		<div id="exec-blocker"></div>
		<div class="header">
			
		</div>
		
		<div class="body" id="bodyDiv">
			<form id="frmData" action="" method="post">
			
				<div id="menuContainer" class="optionsContainer">
					
						<div id="taskInfoContainer" class="campaign"><system:campaign inLogin="false" inSplash="false" location="verticalUp" />				
							<div style="border-bottom: 1px solid #CCCCCC; width: 310px; height: 20px;">
								<span class="title"><region:render section='title' /></span>		
							</div>
							
							<div id="taskContent">
									<div id="imgTask"></div>
									<div id="descTask">Archivar expediente.</div>
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