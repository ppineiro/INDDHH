<%@include file="../../includes/startInc.jsp" %><html><head><%@include file="../../includes/headInclude.jsp" %><link href="<system:util show="context" />/css/<system:util show="currentStyle" />/generalAdm.css" rel="stylesheet" type="text/css" ><script type="text/javascript" src="<system:util show="context" />/page/design/connections/edit.js"></script><script type="text/javascript" src="<system:util show="context" />/page/includes/adminActionsEdition.js"></script><script type="text/javascript" src="<system:util show="context" />/page/modals/environments.js"></script><script type="text/javascript" src="<system:util show="context" />/page/modals/pools.js"></script><script type="text/javascript" src="<system:util show="context" />/page/modals/profiles.js"></script><script type="text/javascript" src="<system:util show="context" />/page/includes/adminFav.js"></script><script type="text/javascript" src="<system:util show="context" />/page/includes/navButtons.js"></script><script type="text/javascript" src="<system:util show="context" />/page/generic/permissions.js"></script><script type="text/javascript" src="<system:util show="context" />/page/includes/campaigns.js"></script><script type="text/javascript">
		var URL_REQUEST_AJAX = '/apia.design.ConnectionsAction.run';
		var MSG_USE_PROY_PERMS = '<system:label show="text" label="msgUseProyPerms" forScript="true" />';
		var MSG_PERM_WILL_BE_LOST = '<system:label show="text" label="msgPermDefWillBeLost" forScript="true" />';
	</script></head><body><div id="exec-blocker"></div><div class="header"></div><div class="body" id="bodyDiv"><form id="frmData"><div class="optionsContainer"><system:campaign inLogin="false" inSplash="false" location="verticalUp" /><div class="fncPanel info"><div class="title"><system:label show="tooltip" label="mnuConex" /><%@include file="../../includes/adminFav.jsp" %></div><div class="content divFncDescription"><div class="fncDescriptionImage" src="<system:edit show="value" from="theBean" field="fncImage"/>"></div><div id="fncDescriptionText"><system:label show="text" label="dscFncAdmConex"/></div><div class="clear"></div></div></div><%@include file="../../includes/adminActionsEdition.jsp" %><div id="divAdminActEdit" class="fncPanel buttons"><div class="title"><system:label show="tooltip" label="mnuOpc" /></div><div class="content"><div id="testConn" class="button extendedSize submit validate['submit']" title="<system:label show="tooltip" label="btnTestDB" />"><system:label show="tooltip" label="btnTestDB" /></div></div></div><system:campaign inLogin="false" inSplash="false" location="verticalDown" /></div><div class="dataContainer"><div class='tabComponent' id="tabComponent"><div class="aTabHeader"><system:campaign inLogin="false" inSplash="false" location="horizontalUp" /></div><div class="aTab"><div class="tab"><system:label show="text" label="tabDatGen" /></div><div class="contentTab"><div class="fieldGroup"><div class="field required fieldTwoFifths"><label title="<system:label show="tooltip" label="lblNom" />"><system:label show="text" label="lblNom" />:</label><input type="text" name="connName" id="connName" class="validate['required','~validName']" value="<system:edit show="value" from="theEdition" field="dbConName"/>"></div><div class="field fieldOneFifths fieldLast"><label title="<system:label show="tooltip" label="titPrj" />"><system:label show="text" label="titPrj" />:</label><select name="connProject" id="cmbProject" ><option></option><system:util show="prepareProjects" saveOn="projects" /><system:edit show="iteration" from="projects" saveOn="project"><system:edit show="saveValue" from="project" field="prjId" saveOn="prjId"/><option value="<system:edit show="value" from="project" field="prjId"/>"<system:edit show="ifValue" from="theEdition" field="prjId" value="with:prjId">selected</system:edit>><system:edit show="value" from="project" field="prjName"/></option></system:edit></select></div><div class="field fieldFull"><label title="<system:label show="tooltip" label="lblDes" />"><system:label show="text" label="lblDes" />:</label><textarea name="connDesc" id="connDesc" maxlength="255" cols=80 rows=3><system:edit show="value" from="theEdition" field="dbConDesc"/></textarea></div><br/><br/><div class="field required fieldOneThird"><label title="<system:label show="tooltip" label="lblTipCon" />"><system:label show="text" label="lblTipCon" />:</label><select name="connType" id="connType" onchange="setConnStr(this);" class="validate['required']"><option></option><system:util show="prepareTypeConnections" saveOn="types" /><system:edit show="iteration" from="types" saveOn="type_save"><system:edit show="saveValue" from="type_save" field="type" saveOn="type"/><option value="<system:edit show="value" from="type_save" field="type"/>" <system:edit show="ifValue" from="theEdition" field="dbConType" value="with:type">selected</system:edit>><system:edit show="value" from="type_save" field="typeName"/></option></system:edit></select></div><div class="field required fieldTwoThird"><label title="<system:label show="tooltip" label="lblConStr" />"><system:label show="text" label="lblConStr" />:</label><input type="text" name="connStr" id="connStr" class="validate['required']" value="<system:edit show="value" from="theEdition" field="dbConString"/>"></div><br/><div class="field required"><label title="<system:label show="tooltip" label="lblConUsu" />"><system:label show="text" label="lblConUsu" />:</label><input type="text" name="connUsr" id="connUsr" class="validate['required']" value="<system:edit show="value" from="theEdition" field="dbConUser"/>"></div><div class="field required"><label title="<system:label show="tooltip" label="lblConPas" />"><system:label show="text" label="lblConPas" />:</label><input type="password" name="connPass" id="connPass" class="validate['required']" value="<system:edit show="value" from="theEdition" field="dbConPassword"/>"></div><br/><br/><div class="field required"><label title="<system:label show="tooltip" label="lblMinCanCon" />"><system:label show="text" label="lblMinCanCon" />:</label><input type="text" name="connMinCon" id="connMinCon" class="validate['required']" value="<system:edit show="value" from="theEdition" field="dbConMinCon"/>"></div><div class="field required"><label title="<system:label show="tooltip" label="lblMaxCanCon" />"><system:label show="text" label="lblMaxCanCon" />:</label><input type="text" name="connMaxCon" id="connMaxCon" class="validate['required']" value="<system:edit show="value" from="theEdition" field="dbConMaxCon"/>"></div><div class="field required"><label title="<system:label show="tooltip" label="lblConnMaxIdle" />"><system:label show="text" label="lblConnMaxIdle" />:</label><input type="text" name="connMaxConIdle" id="connMaxConIdle" class="validate['required']" value="<system:edit show="value" from="theEdition" field="dbConIdleCon"/>"></div><div class="field required"><label title="<system:label show="tooltip" label="lblConnMaxWait" />"><system:label show="text" label="lblConnMaxWait" />:</label><input type="text" name="connMaxConWait" id="connMaxConWait" class="validate['required']" value="<system:edit show="value" from="theEdition" field="dbConWaitCon"/>"></div></div></div></div><div class="aTab"><div class="tab"><system:label show="text" label="tabClaPer" /></div><div class="contentTab"><%@include file="../../generic/permissions.jsp" %></div></div></div><system:campaign inLogin="false" inSplash="false" location="horizontalDown" /></div></form></div><%@include file="../../modals/permissions.jsp" %><%@include file="../../includes/footer.jsp" %></body></html>

