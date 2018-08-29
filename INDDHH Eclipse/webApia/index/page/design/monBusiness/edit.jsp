<%@include file="../../includes/startInc.jsp" %><html><head><%@include file="../../includes/headInclude.jsp" %><link href="<system:util show="context" />/css/<system:util show="currentStyle" />/generalAdm.css" rel="stylesheet" type="text/css" /><link href="<system:util show="context" />/css/<system:util show="currentStyle" />/autocompleter.css" rel="stylesheet" type="text/css" /><script type="text/javascript" src="<system:util show="context" />/page/design/monBusiness/edit.js"></script><script type="text/javascript" src="<system:util show="context" />/page/includes/adminActionsEdition.js"></script><script type="text/javascript" src="<system:util show="context" />/page/includes/adminFav.js"></script><script type="text/javascript" src="<system:util show="context" />/page/includes/navButtons.js"></script><script type="text/javascript" src="<system:util show="context" />/page/generic/permissions.js"></script><script type="text/javascript" src="<system:util show="context" />/page/includes/campaigns.js"></script><script type="text/javascript" src="<system:util show="context" />/page/modals/environments.js"></script><script type="text/javascript" src="<system:util show="context" />/page/modals/pools.js"></script><script type="text/javascript" src="<system:util show="context" />/page/modals/profiles.js"></script><script type="text/javascript" src="<system:util show="context" />/page/modals/processes.js"></script><script type="text/javascript" src="<system:util show="context" />/page/modals/projects.js"></script><script type="text/javascript" src="<system:util show="context" />/page/modals/entities.js"></script><script type="text/javascript" src="<system:util show="context" />/js/autocomplete/autocompleter.js"></script><script type="text/javascript" src="<system:util show="context" />/js/autocomplete/autocompleter.request.js"></script><script type="text/javascript" src="<system:util show="context" />/js/autocomplete/observer.js"></script><script type="text/javascript">
		var URL_REQUEST_AJAX = '/apia.design.MonitorBusinessAction.run';
		var ADDITIONAL_INFO_IN_TABLE_DATA = false;
		
		var MSG_USE_PROY_PERMS = '<system:label show="text" label="msgUseProyPerms" forScript="true" />';
		var MSG_PERM_WILL_BE_LOST = '<system:label show="text" label="msgPermDefWillBeLost" forScript="true" />';
		
		var LBL_TYPE_STRING = '<system:label show="text" label="lblStr" forScript="true" />';
		var LBL_TYPE_NUMERIC = '<system:label show="text" label="lblNum" forHtml="true" forScript="true" />';
		var LBL_TYPE_DATE = '<system:label show="text" label="lblFec" forScript="true" />';
		var LBL_YES = '<system:label show="text" label="lblYes" forHtml="true" forScript="true" />';
		var LBL_NO = '<system:label show="text" label="lblNo" forScript="true" />';
		
		var TYPE_BUS_ENTITY_DESC = '<system:label show="text" label="lblEleBusEntity" forScript="true" />';
		var TYPE_PROCESS_DESC = '<system:label show="text" label="lblEleProcess" forScript="true" />';
		
	</script></head><body><div id="exec-blocker"></div><div class="header"></div><div class="body" id="bodyDiv"><form id="frmData"><div class="optionsContainer"><system:campaign inLogin="false" inSplash="false" location="verticalUp" /><div class="fncPanel info"><div class="title"><system:label show="tooltip" label="mnuMonBusiness" /><%@include file="../../includes/adminFav.jsp" %></div><div class="content divFncDescription"><div class="fncDescriptionImage" src="<system:edit show="value" from="theBean" field="fncImage"/>"></div><div id="fncDescriptionText"><system:label show="text" label="dscFncAdmnMonBus" /></div><div class="clear"></div></div></div><%@include file="../../includes/adminActionsEdition.jsp" %><system:campaign inLogin="false" inSplash="false" location="verticalDown" /></div><div class="dataContainer"><div class='tabComponent' id="tabComponent"><div class="aTabHeader"><system:campaign inLogin="false" inSplash="false" location="horizontalUp" /></div><div class="aTab"><div class="tab"><system:label show="text" label="tabDatGen" /></div><div class="contentTab"><div class="fieldGroup"><div class="field fieldTwoFifths required"><label title="<system:label show="tooltip" label="lblNom" />"><system:label show="text" label="lblNom" />:</label><input type="text" name="monBusName" id="monBusName" class="validate['required','~validName']"  value="<system:edit show="value" from="theEdition" field="monBusName"/>"></div><div class="field fieldTwoFifths required"><label title="<system:label show="tooltip" label="lblTitle" />"><system:label show="text" label="lblTitle" />:</label><input type="text" name="monBusTitle" id="monBusTitle" class="validate['required']"  value="<system:edit show="value" from="theEdition" field="monBusTitle"/>"></div><div class="field fieldOneFifths fieldLast"><label title="<system:label show="tooltip" label="titPrj" />"><system:label show="text" label="titPrj" />:</label><select name="monBusProject" id="cmbProject" ><option></option><system:util show="prepareProjects" saveOn="projects" /><system:edit show="iteration" from="projects" saveOn="project"><system:edit show="saveValue" from="project" field="prjId" saveOn="prjId"/><option value="<system:edit show="value" from="project" field="prjId"/>" <system:edit show="ifValue" from="theEdition" field="prjId" value="with:prjId">selected</system:edit>><system:edit show="value" from="project" field="prjName"/></option></system:edit></select></div><div class="field fieldFull"><label title="<system:label show="tooltip" label="lblDesc" />"><system:label show="text" label="lblDesc" />:</label><textarea type="text" name="monBusDesc" id="monBusDesc" maxlength="255" cols=80 rows=3><system:edit show="value" from="theEdition" field="monBusDescription"/></textarea></div></div><div class="fieldGroup"><div class="field fieldOneThird"><label title="<system:label show="tooltip" label="lblSecEle" />"><system:label show="text" label="lblSecEle" />:</label><select name="selAllowEle"><option value="true" <system:edit show="ifFlag" from="theEdition" field="0" >selected</system:edit>><system:label show="text" label="lblSecAllowAll" /></option><option value="false" <system:edit show="ifNotFlag" from="theEdition" field="0" >selected</system:edit>><system:label show="text" label="lblSecNegAll" /></option></select></div><div class="field fieldOneThird"><label title="<system:label show="tooltip" label="lblSecInsEnt" />"><system:label show="text" label="lblSecInsEnt" />:</label><select name="selAllowEntInst"><option value="true" <system:edit show="ifFlag" from="theEdition" field="1" >selected</system:edit>><system:label show="text" label="lblSecAllowAll" /></option><option value="false" <system:edit show="ifNotFlag" from="theEdition" field="1" >selected</system:edit>><system:label show="text" label="lblSecNegAll" /></option></select></div><div class="field fieldOneThird"><label title="<system:label show="tooltip" label="lblSecInsPro" />"><system:label show="text" label="lblSecInsPro" />:</label><select name="selAllowProInst"><option value="true" <system:edit show="ifFlag" from="theEdition" field="2" >selected</system:edit>><system:label show="text" label="lblSecAllowAll" /></option><option value="false" <system:edit show="ifNotFlag" from="theEdition" field="2" >selected</system:edit>><system:label show="text" label="lblSecNegAll" /></option></select></div></div><br/><br/><div class="fieldGroup"><div class="field fieldFull"><div class="subtitle"><system:label show="text" label="sbtMonBusExceptEle" /></div><div class="modalOptionsContainer" id="projectsContainter"><div class="element" id="addProject" helper="true"><div class="option optionAdd"><system:label show="text" label="btnAgrPrj" /></div></div></div><div class="clear"></div><div class="modalOptionsContainer" id="entitiesContainter"><div class="element" id="addEntitiy" helper="true"><div class="option optionAdd"><system:label show="text" label="btnAgrEnt" /></div></div></div><div class="clear"></div><div class="modalOptionsContainer" id="processesContainter"><div class="element" id="addProcess" helper="true"><div class="option optionAdd"><system:label show="text" label="btnAgrPro" /></div></div></div><div class="clear"></div></div></div><br/><br/><div class="fieldGroup"><div class="field fieldHalf"><div class="subtitle"><system:label show="text" label="sbtMonBusExceptEntInst" /></div><div class="modalOptionsContainer" id="busEntInstancesContainter"><div class="element" id="addBusEntInstance" helper="true"><div class="option optionAdd"><system:label show="text" label="btnAgr" /></div></div></div></div><div class="field fieldHalf fieldLast"><div class="subtitle"><system:label show="text" label="sbtMonBusExceptProInst" /></div><div class="modalOptionsContainer" id="proInstancesContainter"><div class="element" id="addProInstance" helper="true"><div class="option optionAdd"><system:label show="text" label="btnAgr" /></div></div></div></div></div></div></div><div class="aTab"><div class="tab" id="tabQuery"><system:label show="text" label="sbtMonBusQryEle" /></div><div class="contentTab"><%@include file="editQuery.jsp" %></div></div><div class="aTab"><div class="tab" id="tabInitFilter"><system:label show="text" label="sbtMonBusInitFilters" /></div><div class="contentTab"><%@include file="editInitFilters.jsp" %></div></div><div class="aTab"><div class="tab"><system:label show="text" label="sbtMonBusPerVis" /></div><div class="contentTab"><%@include file="editVisualization.jsp" %></div></div><div class="aTab"><div class="tab"><system:label show="text" label="tabClaPer" /></div><div class="contentTab"><%@include file="../../generic/permissions.jsp" %></div></div></div><system:campaign inLogin="false" inSplash="false" location="horizontalDown" /></div></form></div><!-- MODALS --><%@include file="../../modals/permissions.jsp" %><%@include file="../../modals/processes.jsp" %><%@include file="../../modals/projects.jsp" %><%@include file="../../modals/entities.jsp" %><%@include file="../../includes/footer.jsp" %></body></html>

