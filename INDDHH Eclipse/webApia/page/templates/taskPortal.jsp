<%@page import="com.dogma.vo.LanguageVo"%>
<%@ taglib uri='regions' prefix='region'%>
<%@include file="../includes/startInc.jsp" %>
<html lang="<%=biz.statum.apia.web.bean.BasicBeanStatic.getUserDataStatic(request).getLangCode()%>">
<head>
	<%@include file="../includes/headInclude.jsp" %>
	<region:render section='scripts_include' />
	
	<style type="text/css">	
	div.optionsContainer {
		display: none;
	}
	
	.mobileNonExec div.optionsContainer {
 		display: block;
	}
	
	div.dataContainer {
		padding-left: 0px;
		padding-right: 0px;
	}	
	div.bottom {
		margin-right: 15px;
	}	
	#divAdminActEdit div.content {
		height: auto !important;
		min-height: 30px;
		max-height: 200px;
	}
	.tabHolder {
		display: none;
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
	
	
	/********COLOCADO PARA FORMATEAR FORMULARIO*****************/
	.formContainer{
		border: 1px solid #59595C;
/*     	padding: 20px 45px 30px 45px; */
    	margin-top: 30px;
	}
	
	div.fieldGroup div.title, div.fieldGroup div.field label, input[type=text], input[type=password], select, textarea, div.fieldGroup div.field {
		color: #141414;
	}
	
	div.fieldGroup div.field, input, select {
		font-size: 13px !important;
	}
	
	div.fieldGroup div.field label {
		font-family: Arial, Helvetica, sans-serif;
		width: 220px;
	    text-align: right;
	    display: inline-block;
	    margin-right: 12px;
	}
	
	div.fieldGroup div.title{
		font-family:Arial, Helvetica, sans-serif;
		font-size:16.5px;
		font-weight: normal;
		display: inline-block;
	    margin-top: -30px;
	    background-color: white;
	    padding-left: 5px;
	    padding-right: 5px;
	    border: none;
	}
	
	div.formContainer > table > tbody > tr > td {
		display: block;
		padding: 0px;
	}
	
	div.formContainer > table > tbody > tr > td > div.exec_field {
		padding-top: 10px;
		padding-bottom: 10px;
		margin-bottom: 7px;
	}
	
	@media screen and (min-width: 641px) {
	
		.formContainer{
			padding: 20px 45px 30px 45px;
		}
		
		div.fieldGroup div.field > input, div.fieldGroup div.field select {
			width: 33%;
		}
		.exec_field textarea, div.monitor-area {
			width: 33% !important;
		}
		
		ol.tree.first-parent, div.monitor-tree {
			width: 33%;
		}
		
		div.monitor-multiple {
			width: 33%;
		}
	}
	
/* 	div.fieldGroup div.field > input, div.fieldGroup div.field select { */
/* 		width: 33%; */
/* 	} */
	
	div.exec_field input[type=text], div.exec_field input[type=password] {
		padding: 5px 10px;
		height: 32px;
		box-sizing: border-box;
	}
	
	div.gridMinWidth input[type=text], div.gridMinWidth input[type=password] {
		padding: 5px 0px;
	}
	
	div.gridMinWidth input[type=password] {
		width: 100%;
	}
	
	div.exec_field select {
		padding: 5px 10px;
		height: 32px;
	}
	
	div.exec_field select[multiple] {
		height: auto;
		vertical-align: top;
	}
	
	div.exec_field textarea {
		vertical-align: top;
/* 		width: 33% !important; */
		font-size: 13px !important;
		padding: 5px 10px;
	}
	
	br + input[type=radio] {
		margin-left: 237px;
	}
	
	.exec_field .document {
		display: inline-block;
		vertical-align: top;
	}
	
	#btnPanel > div {
		width: 100%;
	}
	
	#btnPanel .button.suggestedAction {
		float: right;
	}
	
	.mobileNonExec .optionsContainer, .mobileNonExec .optionsContainer > div {
		width: 100%;
	}
	
	.mobileNonExec .optionsContainer .button.suggestedAction {
		float: right;
	}
	
	.mobileNonExec .optionsContainer {
		position: static;
	}
	.mobileNonExec .dataContainer {
		position: static;
	} 
	
	.notSuggestedAction > button {
	    background: none !important;
	    border: none;
	    width: auto;
	    height: auto;
	    padding: 0px;
	    font-weight: normal !important;
	    text-decoration: underline;
	    color: #003dc6;
	    font-size: 14px;
	}
	
	.notSuggestedAction {
		margin-left: 25px;
	}
	
	.notSuggestedAction > button:hover {
		background: none !important;
	}
	
	input[disabled] {
		background-color: #f5f5f5;
    	border-color: #e6e6e6;
	}
	
	div.fieldGroup div.field input.dateInput {
		width: 90px;
	}
	
	ol.tree.first-parent {
	    display: inline-block;
	    vertical-align: top;
	}
	
	.exec_field.fc-field-error {
		background: #ffeded;
	    border: 1px solid #e3c4c4;
	    margin-top: 10px;
	    padding-bottom: 40px !important;
	}
	
	input.fc-field-error {
		border-color: #a94442;
	}
	
	div.fc-error {
		border: 0px;
	    background: none;
	    color: #BF2026;
	    position: absolute;
	}
	
	div.fc-error > p {
		margin-left: 237px;
	}
	
	.exec_field_label > label {
		width: 100% !important;
	}
	
	.field_disabled > label {
		color: #CCC !important;
	}
	
	div.fieldGroup > table {
		margin-bottom: 0px;
	}
	
	#divAdminActSteps {
		padding-left: 10px;
	    padding-right: 2px;
    }
	
	#stepsGraph {
	    display: table !important;
	    width: 100%;
	    table-layout: fixed;
	    border: 1px solid #d9d8d8;
	    padding: 0px;
	    margin-bottom: 40px;
	    
	    height: 40px;
	}
	
/* 	div.fncPanel div.stepElement { */
	#stepsGraph > div {
		float: none !important;
		display: table-cell !important;
		background-image: none !important;
		background: #F5F5F5;
		position: relative;
		padding: 10px 0px 10px 60px;
		text-align: left;
		font-size: 14px;
		color: #231F20;
	}
	
	div.fncPanel div.stepElement:first-child {
		padding-left: 25px;
		padding-right: 35px;
	}
	
	div.fncPanel div.selected {
		background: #e2e9ef !important;
		color: #1A2F5A;
		font-weight: bold;
	}
	
	body.mobileNonExec #divAdminActSteps {
		padding-left: 0px;
	}
	
	div.fncPanel div.stepElement:before {
	    content: " ";
	    display: block;
	    width: 0;
	    height: 0;
	    border-top: 20px solid transparent;
	    border-bottom: 20px solid transparent;
	    border-left: 12px solid #DCDCDC;
	    position: absolute;
	    top: 50%;
	    margin-top: -20px;
	    margin-left: 1px;
	    left: 100%;
	    z-index: 1;
	}
	
	div.fncPanel div.stepElement:after {
	    content: " ";
	    display: block;
	    width: 0;
	    height: 0;
	    border-top: 20px solid transparent;
	    border-bottom: 20px solid transparent;
	    border-left: 12px solid #F5F5F5;
	    position: absolute;
	    top: 50%;
	    margin-top: -20px;
	    left: 100%;
	    z-index: 2;
	}
	
	div.fncPanel div.stepElement:last-child:after {
		display: none;
	}
	
	div.fncPanel div.stepElement:last-child:before {
		display: none;
	}
	
	div.fncPanel div.selected:after {
	    border-left: 12px solid #e2e9ef;
	}
	
	#divAdminActSteps > div.title {
		display: none;
	}
	
	/*TABLA*/
	div.gridHeader, div.gridBody, div.gridFooter {
		width: 100% !important;
	}
	
	div.gridContainer div.gridHeader table thead tr th {
		font-size: 13px;
		color: #141414;
	}
	
	div.gridContainer div.gridHeader {
		background: none !important;
		background-color: #f4f4f5 !important;
	}
	
	div.gridContainer div.gridFooter {
		height: 30px;
		background: none !important;
		background-color: #f4f4f5 !important;
	}
	
	@media screen and (max-width: 640px) {
	
		.formContainer{
			padding: 20px 30px 30px 30px;
		}
		
	    div.fieldGroup div.field label {
	        text-align: left;
	        width: 100%;
	    }
	    
	    br + input[type=radio] {
	    	margin-left: 5px;
	    }
	    
/* 	   	div.exec_field  input, div.exec_field select { */
/* 	   		width: 100%; */
/* 	   	} */
	   	
	   	div.fieldGroup div.field > input, div.fieldGroup div.field select {
			width: 100%;
		}
		
		.exec_field textarea, div.monitor-area {
			width: 100% !important;
		}
		
		ol.tree.first-parent, div.monitor-tree {
			width: 100%;
		}
		
		div.monitor-multiple {
			width: 100%;
		}
		
		div.fc-error > p {
			margin-left: 0px;
		}
	}
	
	div.monitor-area {
		display: inline-block;
		vertical-align: top;
	}
	
	div.monitor-tree {
		display: inline-block;
		vertical-align: top;
	}
	
	div.monitor-multiple {
		display: inline-block;
		vertical-align: top;
	}
	
	.notSuggestedAction.extendedSize button.genericBtn {
		width: auto !important;
		height: auto !important;
		display: inline-block !important;
	}
	
	div.dataContainer > div {
		max-width: 980px;
    	margin: 0px auto;
	}
	
	@media screen and (min-width: 1200px) {
		div.dataContainer > div {
			max-width: 1100px;
		}
	}
	
	@media screen and (min-width: 1600px) {
		div.dataContainer > div {
			max-width: 1350px;
		}
	}
	
	</style>
	<script type="text/javascript">
	
	
	<%
	
	Collection<LanguageVo> langs = null;
	Object tskLangs = request.getAttribute("tskTradLang");
	if(tskLangs != null)
		langs = (Collection<LanguageVo>)tskLangs;
	
	out.write("var DOC_LANGS		= {");
	if(langs != null) {
		String str_langs = "";
		for(LanguageVo lang : langs) {
			if(str_langs.length() > 0)
				str_langs += ", " + lang.getLangId() + ": '" + lang.getLangName() + "'";
			else
				str_langs += lang.getLangId() + ": '" + lang.getLangName() + "'";
		}
		out.write(str_langs + "};");
	} else {
		out.write("};");
	}
	%>
	
		var frmCheckerDisplay = {
			addClassErrorToField: 1,
			errorsLocation: 3
		}
		
		var addStepsName = true;
				
		window.addEvent('load', function() {
			var tabs = $$('*.tab');
			if(tabs.length > 1) {
				try {
					tabs[1].fireEvent('click', new Event({
						type: 'click'
					}));
				} catch(error) { }
			}
			
			$('btnPanel').getElements('button.genericBtn').each(function(btn) {
				if(!btn.hasClass('suggestedAction'))
					btn.getParent().addClass('notSuggestedAction');
			});

			var steps = $('divAdminActSteps');
			if(steps) {
				steps.inject($('tabHolder'), 'before');
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
					<div class="fncPanel info" style='display:none'>
						
						<div class="title">
							<span class="title"><region:render section='title' /></span>
						</div>
						
						<div class="content divFncDescription" style="position:relative;">
							<div class="fncDescriptionImgSection"><region:render section='taskImage' /></div>
							<div class="descInfo">
								<div class="title" style="font-weight:bold;">
									 
								</div>
								<div class="fncDescriptionText" id="fncDescriptionText"> </div>
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
				<div class='bottom fncPanel' id="btnPanel">
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

	<region:render section='signature' />
</body>

</html>
