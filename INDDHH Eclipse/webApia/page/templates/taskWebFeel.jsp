<%@ taglib uri='regions' prefix='region'%>
<%@include file="../includes/startInc.jsp" %>
<html lang="<%=biz.statum.apia.web.bean.BasicBeanStatic.getUserDataStatic(request).getLangCode()%>">
<head>
	<%@include file="../includes/headInclude.jsp" %>
	<region:render section='scripts_include' />
	
	<style type="text/css">
	
	div.tabComponent { margin-right: 0px !important; }
	div.tabHolder { margin-right: 0px !important; }
	.bottom { margin-right: 0px !important; }
	div.fieldGroup div.title { margin-left: 0px !important; }
		
	.tabHolder {
		/*display: none;*/
	}
	.collapseForm {
		display: none !important;
	}
	.float-right-buttons {
		float: right;
	}
	.titImage {
		display: inline;
	}
	.proTitle {
		display: inline;
		margin-left: 3px;
	}
	.taskTitle {
		display: inline;
	}
	.fncDescriptionImgSection {
		display: inline;
	}
	.descInfo {
		display: inline;
		position: absolute;
		top: 5px;
		margin-left: 10px;
	}
	.fncDescriptionText {
		margin-top: 5px;
	}
	#divAdminActEdit .title {
		display: none;
	}
	.grey-hr {
		border-bottom: 1px solid #CCC;
		margin-bottom: 10px;
	}
	</style>
	<script type="text/javascript">
		window.addEvent('load', function() {
			var tabs = $$('*.tab');
			if(tabs.length > 1) {
				try {
					tabs[1].fireEvent('click', new Event({
						type: 'click'
					}));
				} catch(error) { }
			}
		});
	</script>
</head>
<body>
	<div id="exec-blocker"></div>	
	<div class="body" id="bodyDiv">
		<form id="frmData" action="dummy" method="post">
		
			<div class="optionsContainer">
				<system:campaign inLogin="false" inSplash="false" location="verticalUp" />
				<system:campaign inLogin="false" inSplash="false" location="verticalDown" />
			</div>	
			
			<div class="dataContainer">
				<div class='tabComponent' id="tabComponent">
					<div class="aTabHeader"><system:campaign inLogin="false" inSplash="false" location="horizontalUp" /></div>				
					<div class="fncPanel info">
						<div class="content divFncDescription" style="position:relative;">
							<div class="fncDescriptionImgSection"><region:render section='taskImage' /></div>
							<div class="descInfo">
								<div class="title" style="font-weight:bold;">
									<region:render section='title' />
								</div>
								<div class="fncDescriptionText" id="fncDescriptionText"><region:render section='tskDescription' /></div>
							</div>
							<div class="clear"></div>
						</div>
					</div>
					<div class='aTab'>
						<div class='tab' style="display:none"><system:label show="text" label="tabEjeFor"/></div>
						<div class='contentTab'>
							<region:render section='entityForms' />
						</div>
					</div>					
				</div>
				<div class='bottom fncPanel' style="height: 120px">
					<div class="grey-hr"></div>
					<div class="float-right-buttons">
						<region:render section='buttons' />
					</div>
				</div>
				<system:campaign inLogin="false" inSplash="false" location="horizontalDown" />
		 	</div>
		</form>
	</div>
	<%@include file="../includes/footer.jsp" %>
	<%@include file="../modals/documents.jsp" %>
	<%@include file="../modals/calendarsView.jsp" %>
	<%@include file="../execution/includes/endInclude.jsp" %>
	
	<region:render section='signature' />
</body>

</html>
