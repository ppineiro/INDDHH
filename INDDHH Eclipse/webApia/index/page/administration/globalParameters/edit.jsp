<%@include file="../../includes/startInc.jsp" %><html><head><%@include file="../../includes/headInclude.jsp" %><link href="<system:util show="context" />/css/<system:util show="currentStyle" />/generalAdm.css" rel="stylesheet" type="text/css" ><script type="text/javascript" src="<system:util show="context" />/page/administration/globalParameters/edit.js"></script><script type="text/javascript" src="<system:util show="context" />/page/includes/adminActionsEdition.js"></script><script type="text/javascript" src="<system:util show="context" />/page/includes/adminFav.js"></script><script type="text/javascript" src="<system:util show="context" />/page/includes/campaigns.js"></script><script type="text/javascript">
		var URL_REQUEST_AJAX = '/apia.administration.GlobalParametersAction.run';
		
		var currentParamTab = '<system:edit show="value" from="theBean" field="confirmTab" />';
		var lastMemoryUpdate = '<system:edit show="value" from="theBean" field="lastMemoryUpdate" />';
		var lastDBUpdate = '<system:edit show="value" from="theBean" field="lastDBUpdate" />';
		var synchronizedParameters = <system:edit show="value" from="theBean" field="synchronizedParameters"/>;
		
		var LABEL_CONFIRM_UPDATE = '<system:label show="text" label="msgUpdateParameter" forHtml="true" forScript="true" />';
				
		function initParameterButtons() {
			<system:edit show="iteration" from="theBean" field="formatButtons" saveOn="parameter"><system:edit show="value" from="parameter" field="script" avoidHtmlConvert="true"/></system:edit><system:edit show="iteration" from="theBean" field="locButtons" saveOn="parameter"><system:edit show="value" from="parameter" field="script" avoidHtmlConvert="true"/></system:edit><system:edit show="iteration" from="theBean" field="logButtons" saveOn="parameter"><system:edit show="value" from="parameter" field="script" avoidHtmlConvert="true"/></system:edit><system:edit show="iteration" from="theBean" field="emailButtons" saveOn="parameter"><system:edit show="value" from="parameter" field="script" avoidHtmlConvert="true"/></system:edit><system:edit show="iteration" from="theBean" field="otherButtons" saveOn="parameter"><system:edit show="value" from="parameter" field="script" avoidHtmlConvert="true"/></system:edit><system:edit show="iteration" from="theBean" field="chatButtons" saveOn="parameter"><system:edit show="value" from="parameter" field="script" avoidHtmlConvert="true"/></system:edit><system:edit show="iteration" from="theBean" field="authenticationButtons" saveOn="parameter"><system:edit show="value" from="parameter" field="script" avoidHtmlConvert="true"/></system:edit><system:edit show="iteration" from="theBean" field="biButtons" saveOn="parameter"><system:edit show="value" from="parameter" field="script" avoidHtmlConvert="true"/></system:edit><system:edit show="iteration" from="theBean" field="formatParams" saveOn="parameter"><system:edit show="value" from="parameter" field="script" avoidHtmlConvert="true"/></system:edit><system:edit show="iteration" from="theBean" field="locParams" saveOn="parameter"><system:edit show="value" from="parameter" field="script" avoidHtmlConvert="true"/></system:edit><system:edit show="iteration" from="theBean" field="logParams" saveOn="parameter"><system:edit show="value" from="parameter" field="script" avoidHtmlConvert="true"/></system:edit><system:edit show="iteration" from="theBean" field="emailParams" saveOn="parameter"><system:edit show="value" from="parameter" field="script" avoidHtmlConvert="true"/></system:edit><system:edit show="iteration" from="theBean" field="otherParams" saveOn="parameter"><system:edit show="value" from="parameter" field="script" avoidHtmlConvert="true"/></system:edit><system:edit show="iteration" from="theBean" field="chatParams" saveOn="parameter"><system:edit show="value" from="parameter" field="script" avoidHtmlConvert="true"/></system:edit><system:edit show="iteration" from="theBean" field="authenticationParams" saveOn="parameter"><system:edit show="value" from="parameter" field="script" avoidHtmlConvert="true"/></system:edit><system:edit show="iteration" from="theBean" field="biParams" saveOn="parameter"><system:edit show="value" from="parameter" field="script" avoidHtmlConvert="true"/></system:edit>
		}
		
		
	</script></head><body><div id="exec-blocker"></div><div class="header"></div><div class="body" id="bodyDiv"><form id="frmData"><div class="optionsContainer"><system:campaign inLogin="false" inSplash="false" location="verticalUp" /><div class="fncPanel info"><div class="title"><system:label show="tooltip" label="mnuPar" /><%@include file="../../includes/adminFav.jsp" %></div><div class="content divFncDescription"><div class="fncDescriptionImage" src="<system:edit show="value" from="theBean" field="fncImage"/>"></div><div id="fncDescriptionText"><system:label show="text" label="dscFncAdmPar"/></div><div class="clear"></div></div></div><%@include file="../../includes/adminActionsEdition.jsp" %><div id="divAdminActEdit" class="fncPanel buttons"><div class="title"><system:label show="text" label="mnuOpc"/></div><div class="content"><div id="formatButtons" class="hidden"><system:edit show="iteration" from="theBean" field="formatButtons" saveOn="parameter"><system:edit show="value" from="parameter" field="html" avoidHtmlConvert="true"/></system:edit></div><div id="locButtons" class="hidden"><system:edit show="iteration" from="theBean" field="locButtons" saveOn="parameter"><system:edit show="value" from="parameter" field="html" avoidHtmlConvert="true"/></system:edit></div><div id="logButtons" class="hidden"><system:edit show="iteration" from="theBean" field="logButtons" saveOn="parameter"><system:edit show="value" from="parameter" field="html" avoidHtmlConvert="true"/></system:edit></div><div id="emailButtons" class="hidden"><system:edit show="iteration" from="theBean" field="emailButtons" saveOn="parameter"><system:edit show="value" from="parameter" field="html" avoidHtmlConvert="true"/></system:edit></div><div id="otherButtons" class="hidden"><system:edit show="iteration" from="theBean" field="otherButtons" saveOn="parameter"><system:edit show="value" from="parameter" field="html" avoidHtmlConvert="true"/></system:edit></div><div id="chatButtons" class="hidden"><system:edit show="iteration" from="theBean" field="chatButtons" saveOn="parameter"><system:edit show="value" from="parameter" field="html" avoidHtmlConvert="true"/></system:edit></div><div id="authenticationButtons" class="hidden"><system:edit show="iteration" from="theBean" field="authenticationButtons" saveOn="parameter"><system:edit show="value" from="parameter" field="html" avoidHtmlConvert="true"/></system:edit></div><div id="biButtons" class="hidden"><system:edit show="iteration" from="theBean" field="biButtons" saveOn="parameter"><system:edit show="value" from="parameter" field="html" avoidHtmlConvert="true"/></system:edit></div></div></div><div class="fncPanel options" id="panelInfo"><div class="title"><system:label show="text" label="mnuAddInfo"/></div><div class="content"><div id="btnReloadPars" class="button" title="<system:label show="tooltip" label="btnReloadPars" />"><system:label show="text" label="btnReloadPars" /></div><div class="filter"><span class="infoGenData"><b><system:label show="text" label="parMemDate"/>: </b></span><a id="lastMemoryUpdate"></a><span class="infoGenData"><b><system:label show="text" label="parDBDate"/>: </b></span><a id="lastDBUpdate"></a></div></div></div><system:campaign inLogin="false" inSplash="false" location="verticalDown" /></div><div class="dataContainer"><div class='tabComponent' id="tabComponent"><div class="aTabHeader"><system:campaign inLogin="false" inSplash="false" location="horizontalUp" /></div><div class="aTab"><div class="tab" id="formatTab"><system:label show="text" label="tabParForm" /></div><div class="contentTab"><div class="fieldGroup"><system:edit show="iteration" from="theBean" field="formatParams" saveOn="parameter"><system:edit show="value" from="parameter" field="html" avoidHtmlConvert="true"/></system:edit></div></div></div><div class="aTab"><div class="tab" id="locTab"><system:label show="text" label="tabParLoc" /></div><div class="contentTab"><div class="fieldGroup"><system:edit show="iteration" from="theBean" field="locParams" saveOn="parameter"><system:edit show="value" from="parameter" field="html" avoidHtmlConvert="true"/></system:edit></div></div></div><div class="aTab"><div class="tab" id="logTab"><system:label show="text" label="tabParLog" /></div><div class="contentTab"><div class="fieldGroup"><system:edit show="iteration" from="theBean" field="logParams" saveOn="parameter"><system:edit show="value" from="parameter" field="html" avoidHtmlConvert="true"/></system:edit></div></div></div><div class="aTab"><div class="tab" id="emailTab"><system:label show="text" label="tabParEMail" /></div><div class="contentTab"><div class="fieldGroup"><system:edit show="iteration" from="theBean" field="emailParams" saveOn="parameter"><system:edit show="value" from="parameter" field="html" avoidHtmlConvert="true"/></system:edit></div></div></div><div class="aTab"><div class="tab" id="otherTab"><system:label show="text" label="tabParOther" /></div><div class="contentTab"><div class="fieldGroup"><system:edit show="iteration" from="theBean" field="otherParams" saveOn="parameter"><system:edit show="value" from="parameter" field="html" avoidHtmlConvert="true"/></system:edit></div></div></div><div class="aTab"><div class="tab" id="chatTab"><system:label show="text" label="tabParCom" /></div><div class="contentTab"><div class="fieldGroup"><system:edit show="iteration" from="theBean" field="chatParams" saveOn="parameter"><system:edit show="value" from="parameter" field="html" avoidHtmlConvert="true"/></system:edit></div></div></div><div class="aTab"><div class="tab" id="authenticationTab"><system:label show="text" label="tabParAut" /></div><div class="contentTab"><div class="fieldGroup"><system:edit show="iteration" from="theBean" field="authenticationParams" saveOn="parameter"><system:edit show="value" from="parameter" field="html" avoidHtmlConvert="true"/></system:edit></div></div></div><div class="aTab"><div class="tab" id="biTab"><system:label show="text" label="tabDwQry" /></div><div class="contentTab"><div class="fieldGroup"><system:edit show="iteration" from="theBean" field="biParams" saveOn="parameter"><system:edit show="value" from="parameter" field="html" avoidHtmlConvert="true"/></system:edit></div></div></div></div><input type="hidden" id="currentParamTab" name="currentParamTab"></div></form></div></body></html>			