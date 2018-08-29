<%@ taglib uri='regions' prefix='region'%>
<%@include file="../includes/startInc.jsp" %>
<html lang="<%=biz.statum.apia.web.bean.BasicBeanStatic.getUserDataStatic(request).getLangCode()%>">
<head>
	<%@include file="../includes/headInclude.jsp" %>
	<region:render section='scripts_include' />
</head>
<body>
	<div id="exec-blocker"></div>	
	<div class="body" id="bodyDiv">
		<form id="frmData" action="dummy" method="post">
		<div class="optionsContainer">
				<div class="fncPanel info">
					<div class="campaign"><system:campaign inLogin="false" inSplash="false" location="verticalUp" /></div>
					<div class="title">
						<span class="panelPinShow" id="panelPinShow">&nbsp;</span>
						<span class="panelPinHidde" id="panelPinHidde">&nbsp;</span>
						<span class="title"><region:render section='title' /></span>
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
						<div class='tab'><system:label show="text" label="tabEjeEnt"/></div>
						<div class='contentTab'>
							<region:render section='entityMain' />
							<region:render section='entityDocuments' />							
							<region:render section='entityVisibilities' />
							<region:render section='entityCategories' />							
						</div>
					</div>
					
					<div class='aTab'>
						<div class='tab'><system:label show="text" label="tabEjeFor"/></div>
						<div class='contentTab'>
							<region:render section='entityForms' />
						</div>
					</div>
					
					<div class='aTab'>
						<div class='tab' id="tabComments"><system:label show="text" label="tabEjeCom"/></div>
						<div class='contentTab'>
							<region:render section='entityComments' />
						</div>
					</div>
					
					<div class='aTab'>
						<div class='tab' id="tabAsociations"><system:label show="text" label="tabEjeAsoc"/></div>						
						<div class='contentTab'>
							<region:render section='entityAsociations' />
						</div>
					</div>
					
				</div>
				<system:campaign inLogin="false" inSplash="false" location="horizontalDown" />
			</div>
		</form>
	</div>
	<%@include file="../includes/footer.jsp" %>
	<%@include file="../modals/documents.jsp" %>
	<%@include file="../modals/entityInstances.jsp" %>
	<%@include file="../execution/includes/endInclude.jsp" %>
	
	<region:render section='signature' />
</body>

</html>