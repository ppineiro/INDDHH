<%@ taglib uri='regions' prefix='region'%>
<%@include file="../page/includes/startInc.jsp" %>
<%@include file="../page/includes/headInclude.jsp" %>
<%@include file="../expedientes/jsp/CustomJSP-EXP-ELEC.jsp" %>


<html>
	<head>
			
		<link href="<system:util show="context" />/css/documentum/execution/generalExecution.css" rel="stylesheet" type="text/css">
		<link href="<system:util show="context" />/css/documentum/common/modal.css" rel="stylesheet" type="text/css">
		<region:render section='scripts_include' />
		<script type="text/javascript" src="/Apia/expedientes/jsp/ITHitWebDAVClient.js" ></script>
		<script type="text/javascript">
			currentTab = <%=request.getParameter("currentTab") != null ? request.getParameter("currentTab") : "3"%>;
			
			//funciones para WebDav
			function editWebDav(nameFile) {	
				var sDocumentUrlBase = "http://erodriguez-nb:8880/Apia/WebDav/"; // this must be full path
				ITHit.WebDAV.Client.DocManager.EditDocument(sDocumentUrlBase + nameFile, "/", protocolInstallCallback);
			}
			// Called if protocol handler is not installed
			function protocolInstallCallback(message) {
				var installerFilePath = "http://erodriguez-nb:8880/Apia/tools/Plugins/" + ITHit.WebDAV.Client.DocManager.GetInstallFileName();
				if (confirm("This action requires a protocol installation. Select OK to download the protocol installer.")){
					window.open(installerFilePath);
				}
			}
			
			function showMenu(){
				document.getElementById("pinHidden").style.display = "block";
				document.getElementById("menuContainer").style.display = "block";
				document.getElementById("tabHolder").style.width = "auto";				
				document.getElementById("tabComponent").style.width = "100%";
				var tas = document.getElementsByTagName("textarea");
				document.getElementById("txtComment").style.width = "100%";			
			}
	
			function hiddeMenu(){
				document.getElementById("pinHidden").style.display = "none";
				document.getElementById("menuContainer").style.display = "none";
				document.getElementById("tabHolder").style.width = "96%";
				document.getElementById("tabComponent").style.width = "135%";
				
				var tas = document.getElementsByTagName("textarea");
				for (var i = 0; i < tas.length; i++) {
				    tas[i].style.width = "104%";
				}
				
				var ghs = document.getElementsByClassName("gridHeader");
				for (var i = 0; i < tas.length; i++) {
					ghs[i].style.width = "104%";
				}
				
				var gbs = document.getElementsByClassName("gridBody");
				for (var i = 0; i < tas.length; i++) {
					gbs[i].style.width = "104%";
				}
				
				var gfs = document.getElementsByClassName("gridFooter");
				for (var i = 0; i < tas.length; i++) {
					gfs[i].style.width = "104%";
				}
				
				document.getElementById("txtComment").style.width = "100%";	
			}
			
			function ocultarBotones(){
				document.getElementById("btnConf").style.display = "none";
				document.getElementById("btnSave").style.display = "none";
			}
		
		</script>
		<style type="text/css">
	
			/* Div General */
			#menuContainer { position: absolute; width: 310px; height: 600px; display: inline-block; float: right; right: 0px; z-index: 1; background-color: #FFF; }
						
			/* Panel de la tarea */	
			#taskInfoContainer { position: absolute; width: 310px; height: 125px; }
			#taskTitleContainer { position: absolute; top: 0%; }
			#taskContent { position: absolute; top:20%; width: 300px; height: 100px; }
			#imgTask { position: absolute; top: 15%; left: 5%; background: transparent url("templates/img/trabajo_colaborativo.png") no-repeat scroll 0% 0% / 45px auto; width: 42px; height: 42px; } 
			#descTask{ position: absolute; top: 13%; left: 28%; width: 200px; font-size: 12px; text-align: justify; }
			span.titImage{ display: none; }
			span.proTitle{ display: inline; font-weight: bold; font-size: 12px; }
			span.taskTitle{ display: inline; font-weight: bold; font-size: 12px; }
			
			/* Menu de botones */
			#buttonsActions{ position: absolute ; top: 17%; }
			
			/* Ocultar menu */
			#pinHidden { position: absolute; top: 0%; left: 98%; width: 20px; height: 20px; background-image: url("templates/img/pinHide.png"); background-repeat: no-repeat; background-position: 0% 0%; cursor:pointer; z-index: 2; }
			#pinShow { position: absolute; top: 0%; left: 98%; display: block; cursor: pointer; width: 20px; height: 20px; background-image: url("templates/img/pinShow.png"); background-repeat: no-repeat; background-position: 0% 0%; z-index: 2; }
			
			/* Otros */
			#area_E_3410_1_ifr { height: 150px !important; } 	/* TAMAÑO IFRAME DE ACTUACION DE PASE MASIVO */
			
		</style>
	</head>
	
	<body onLoad="ocultarBotones()">
		<div id="exec-blocker"></div>
		<div class="header">
			
		</div>
		
		<div class="body" id="bodyDiv">
			<form id="frmData" action="" method="post">
				<span id="pinShow" onClick="showMenu()"></span>
				<span id="pinHidden" onClick="hiddeMenu()"></span>
				
				<div id="menuContainer" class="optionsContainer">
					
					<div id="taskInfoContainer" class="campaign"><system:campaign inLogin="false" inSplash="false" location="verticalUp" />				
						<div style="border-bottom: 1px solid #CCCCCC; width: 310px; height: 20px;">
							<span class="title"><region:render section='title' /></span>		
						</div>
						
						<div id="taskContent">
							<div id="imgTask"></div>
							<div id="descTask">Tarea en la cual se colabora entre varios actuantes para realizar una actuación conjunta.</div>
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