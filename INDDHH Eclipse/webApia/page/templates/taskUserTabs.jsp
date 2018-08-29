<%@ taglib uri='regions' prefix='region'%>
<%@include file="../includes/startInc.jsp" %>
<html lang="<%=biz.statum.apia.web.bean.BasicBeanStatic.getUserDataStatic(request).getLangCode()%>">
<head>
	<%@include file="../includes/headInclude.jsp" %>
	<region:render section='scripts_include' />
	<script type="text/javascript">
		currentTab = <%=request.getParameter("currentTab") != null ? request.getParameter("currentTab") : "3"%>;
	</script>
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
						<div class="fncDescriptionImgSection"><region:render section='taskImage' /></div>
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
					<div class='aTab'>
						<div class='tab' id="tabDocs"><system:label show="text" label="tabEjeDoc"/></div>
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
	<%@include file="../includes/footer.jsp" %>
	<%@include file="../modals/documents.jsp" %>
	<%@include file="../modals/calendarsView.jsp" %>
	<%@include file="../social/socialShareMdl.jsp" %>
	<%@include file="../social/socialReadChannelMdl.jsp" %>	
	<%@include file="../execution/includes/endInclude.jsp" %>
	
	<region:render section='signature' />
</body>

</html>
