<%@ taglib uri='regions' prefix='region'%>
<%@include file="../page/includes/startInc.jsp" %>
<%@include file="../page/includes/headInclude.jsp" %>
<%@include file="../expedientes/jsp/CustomJSP-EXP-ELEC.jsp" %>

<html>
<head>
	<% 	
	int langId = uData.getLangId();
// 	String eDocsActivo = ConfigurationManager.getHabilitarEDOCS(envId, langId, false);
	boolean eDocsEsActivo = ConfigurationManager.isEDOCS(envId, langId, false);
	%>
	<link href="<system:util show="context" />/css/documentum/execution/generalExecution.css" rel="stylesheet" type="text/css">
	<link href="<system:util show="context" />/css/documentum/common/modal.css" rel="stylesheet" type="text/css">
	<region:render section='scripts_include' />
	<script type="text/javascript">
		currentTab = <%=request.getParameter("currentTab") != null ? request.getParameter("currentTab") : "3"%>;
	</script>
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
						<span class="panelPinHidde" id="panelPinHidde">&nbsp;</span>
					</div>
					<div class="content divFncDescription">
						<div class="fncDescriptionImgSection"><region:render section='taskImage' /></div>
						<div class="fncDescriptionText" id="fncDescriptionText"><region:render section='tskDescription' /></div>
						<div class="clear"></div>
					</div>
				</div>			
				
				<div class="buttonsActions">
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
	
<%@include file="../page/includes/footer.jsp" %>
<%@include file="../page/modals/documents.jsp" %>
<%@include file="../page/modals/calendarsView.jsp" %>
<%@include file="../page/social/socialShareMdl.jsp" %>
<%@include file="../page/social/socialReadChannelMdl.jsp" %>	
<%@include file="../page/execution/includes/endInclude.jsp" %>
</body>

</html>