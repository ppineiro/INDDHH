<%@ taglib uri='regions' prefix='region'%>
<%@include file="../page/includes/startInc.jsp" %>
<html>
<head>
	<%@include file="../page/includes/headInclude.jsp" %>
	<link href="<system:util show="context" />/css/<system:util show="currentStyle" />/execution/generalExecution.css" rel="stylesheet" type="text/css">
	<link href="<system:util show="context" />/css/<system:util show="currentStyle" />/common/modal.css" rel="stylesheet" type="text/css">
	<region:render section='scripts_include' />
	<script type="text/javascript" src="/Apia/expedientes/jsp/ITHitWebDAVClient.js" ></script>
	
</head>

<body>
	<script type="text/javascript">
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
	</script>


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
						<span class="panelPinHidde" id="panelPinHidde">&nbsp;</span>
					</div>
					<div class="content divFncDescription">
						<div class="fncDescriptionImgSection"><region:render section='entImage' /></div>
						<div id="fncDescriptionText"><region:render section='entDescription' /></div>
						<div class="clear"></div>
					</div>
				</div>			
				
				<div class="buttonsActions">
					<region:render section='buttons' />
					
					<div class="fncPanel options">
						<region:render section='helpDocuments' />
					</div>
					
					<system:campaign inLogin="false" inSplash="false" location="verticalDown" />
				</div>
			</div>	
			
			<div class="dataContainer">
			 	<div class='tabComponent' id="tabComponent">
			 		<div class="aTabHeader"><system:campaign inLogin="false" inSplash="false" location="horizontalUp" /></div>
					<div class='aTab'>
						<div class='tab'><system:label show="text" label="tabEjeFor"/></div>						
						<div class='contentTab'>
							<region:render section='entityForms' />
						</div>
					</div>
					<div class='aTab'>
						<div class='tab'  style="display:none;"><system:label show="text" label="tabEjeFor"/></div>
						<div class='contentTab'>
							<region:render section='entityMain' />
							<region:render section='entityDocuments' />
						</div>
					</div>
					
				</div>
				<system:campaign inLogin="false" inSplash="false" location="horizontalDown" />
			</div>
		</form>
	</div>
	<%@include file="../page/includes/footer.jsp" %>	
	<%@include file="../page/modals/documents.jsp" %>
	<%@include file="../page/execution/includes/endInclude.jsp" %>
	<%@include file="../expedientes/jsp/CustomJSP-EXP-ELEC.jsp" %>
</body>

</html>