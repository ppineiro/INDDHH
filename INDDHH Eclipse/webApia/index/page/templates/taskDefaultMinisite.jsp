<%@ taglib uri='regions' prefix='region'%>
<%@include file="../includes/startInc.jsp" %>
<html>
<head>
	<%@include file="../includes/headInclude.jsp" %>
	<link href="<system:util show="context" />/css/<system:util show="currentStyle" />/generalExecution.css" rel="stylesheet" type="text/css">
	<link href="<system:util show="context" />/css/<system:util show="currentStyle" />/generalExecutionMobile.css" rel="stylesheet" type="text/css">
	<link href="<system:util show="context" />/css/<system:util show="currentStyle" />/modal.css" rel="stylesheet" type="text/css">
	<region:render section='scripts_include' />
	
	<style type="text/css">
	
	.tabHolder {
		/*display: none;*/
	}
	.collapseForm {
		display: none !important;
	}
	.float-left-buttons {
		float: left;
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
	.bottom {
		margin-right: 355px;
	}
	
	.optionsContainer{}
	.dataContainer{}
	div.tabComponent {
		margin:0px;
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
	<div class="header">
		
	</div>
	
	<div class="body" id="bodyDiv">
		<form id="frmData" action="" method="post">
		
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
						
						<region:render section='apiaSocial' />
					</div>
					<div class='aTab'>
						<div class='tab' style="display:none"><system:label show="text" label="tabEjeFor"/></div>
						<div class='contentTab'>
							<region:render section='entityForms' />
							<region:render section='processForms' />
						</div>
					</div>					
				</div>
				<div class='bottom fncPanel' style="height: 120px">
					<div class="grey-hr"></div>
					<div class="float-left-buttons">
						<region:render section='buttons' />
					</div>
				</div>
				<system:campaign inLogin="false" inSplash="false" location="horizontalDown" />
		 	</div>
		</form>
	</div>
	
	<%@include file="../modals/documents.jsp" %>
	<%@include file="../modals/calendarsView.jsp" %>
	<%@include file="../social/socialShareMdl.jsp" %>
	<%@include file="../social/socialReadChannelMdl.jsp" %>
	<%@include file="../execution/includes/endInclude.jsp" %>

</body>

</html>
