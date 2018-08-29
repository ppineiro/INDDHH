<%@include file="../../includes/startInc.jsp" %><html><head><%@include file="../../includes/headInclude.jsp" %><link href="<system:util show="context" />/css/<system:util show="currentStyle" />/generalAdm.css" rel="stylesheet" type="text/css" ><script type="text/javascript" src="<system:util show="context" />/page/design/businessentities/merToEntities.js"></script><script type="text/javascript" src="<system:util show="context" />/page/includes/adminActionsEdition.js"></script><script type="text/javascript">
		var URL_REQUEST_AJAX = '/apia.design.BusinessEntitiesAction.run';
		var ADDITIONAL_INFO_IN_TABLE_DATA  = true;
		var LOAD_FROM_FILE = '<system:edit show="constant" from="biz.statum.apia.web.bean.design.BusEntitiesBean" field="LOAD_FROM_FILE" />';
		var LOAD_FROM_DB = '<system:edit show="constant" from="biz.statum.apia.web.bean.design.BusEntitiesBean" field="LOAD_FROM_DB" />';
		var GNR_PER_DAT_ING = '<system:label show="text" label="msgPerDatIng" forScript="true" />';
		var DB_SELECTED = '<system:edit show="value" from="theBean" field="dbConnId"/>';
	</script></head><body><div class="header"></div><div class="body" id="bodyDiv"><form id="frmData" method="post"><div class="optionsContainer"><system:campaign inLogin="false" inSplash="false" location="verticalUp" /><div class="fncPanel info"><div class="title"><system:label show="tooltip" label="titEntNeg" /></div><div class="content divFncDescription"><div class="fncDescriptionImage" src="<system:edit show="value" from="theBean" field="fncImage"/>"></div><div id="fncDescriptionText"><system:label show="text" label="dscFncAdmEnt"/></div><div class="clear"></div></div></div><div id="divAdminActEdit" class="fncPanel buttons"><div class="title"><system:label show="text" label="titActions"/></div><div class="content"><div id="btnCont" class="button submit validate['submit']" title="<system:label show="tooltip" label="btnCont" />"><system:label show="text" label="btnCont" /></div><div id="btnBackToList" class="button" title="<system:label show="tooltip" label="btnVol" />"><system:label show="text" label="btnVol" /></div></div></div><div class="fncPanel options" id="panelOptions" ><div class="title"><system:label show="tooltip" label="mnuOpc" /></div><div class="content"><div id="btnUploadEnt" class="button" <system:label show="tooltip" label="btnUpl" />><system:label show="text" label="btnUpl" /></div></div><div class="clear"></div></div><system:campaign inLogin="false" inSplash="false" location="verticalDown" /></div><div class="dataContainer"><system:campaign inLogin="false" inSplash="false" location="horizontalUp" /><div class="fieldGroup"><div class="title"><system:label show="text" label="tabDatEntNeg" /></div><div class="field"><label title="<system:label show="tooltip" label="lblLoadFrom" />"><system:label show="text" label="lblLoadFrom" />:&nbsp;</label><select name="<system:edit show="constant" from="biz.statum.apia.web.bean.design.BusEntitiesBean" field="PARAM_LOAD_FROM" />" id="<system:edit show="constant" from="biz.statum.apia.web.bean.design.BusEntitiesBean" field="PARAM_LOAD_FROM" />"><option value="<system:edit show="constant" from="biz.statum.apia.web.bean.design.BusEntitiesBean" field="LOAD_FROM_FILE" />" <system:edit show="ifValue" from="theBean" field="loadFrom" value="F">selected</system:edit>><system:label show="text" label="lblFile" /></option><option value="<system:edit show="constant" from="biz.statum.apia.web.bean.design.BusEntitiesBean" field="LOAD_FROM_DB" />" <system:edit show="ifValue" from="theBean" field="loadFrom" value="D">selected</system:edit>  ><system:label show="text" label="lblDb" /></option></select></div><div class="clearLeft"></div><div class="field required" id="divFile"><label title="<system:label show="tooltip" label="lblFile" />"><system:label show="text" label="lblFile" />:&nbsp;</label><input id="txtUpload" name="txtUpload" type="text"  class="validate['required']" readonly="readonly" /></div><div class="clearLeft"></div><div class="field" id="divSep" <system:edit show="ifValue" from="theBean" field="loadFrom" value="F" >style='display:'</system:edit>><label title="<system:label show="tooltip" label="lblSepSQL" />"><system:label show="text" label="lblSepSQL" />:</label><input type="text" name="txtSep" id="txtSep" value="<system:edit show="constant" from="biz.statum.apia.web.bean.design.BusEntitiesBean" field="PARAM_SEP_SQL" />"></div><div class="clearLeft"></div><div class="field required" id="divConn" <system:edit show="ifNotValue" from="theBean" field="loadFrom" value="D">style='display:none'</system:edit>><label title="<system:label show="tooltip" label="lblCon" />"><system:label show="text" label="lblCon" />:&nbsp;</label><select name="connectionsCombo" id="connectionsCombo" class="validate['required']"><option value="-1"><system:label show="text" label="lblLocalDbNom" /></option><system:util show="prepareConnectionsList" saveOn="conns" /><system:edit show="iteration" from="conns" saveOn="connection"><system:edit show="saveValue" from="connection" field="dbConId" saveOn="dbConId"/><option value="<system:edit show="value" from="connection" field="dbConId"/>" <system:edit show="ifValue" from="theBean" field="dbConnId" value="with:dbConId">selected</system:edit>><system:edit show="value" from="connection" field="dbConName"/></option></system:edit></select></div><div class="clearLeft"></div><div class="leftField extendedSize"><label title="<system:label show="tooltip" label="lblTipoAdm" />"><system:label show="text" label="lblTipoAdm" />:&nbsp;</label><div class="clearLeft"></div><select id="cmbTipAdmDef" name="cmbTipAdmDef"><option value="<system:edit show="constant" from="com.apia.erd.Table" field="ADMIN_FUNCT" />"><system:label show="text" label="lblTipAdmFun" /></option><option value="<system:edit show="constant" from="com.apia.erd.Table" field="ADMIN_PROCESS" />"><system:label show="text" label="lblTipAdmPro" /></option><option value="<system:edit show="constant" from="com.apia.erd.Table" field="ADMIN_BOTH" />" selected><system:label show="text" label="lblTipAdmAmb" /></option></select></div><div class="clearLeft"></div><div class="leftField extendedSize" ><label title="<system:label show="tooltip" label="lblEntProCre" />" for="chkAddCrePro" class="label"><system:label show="text" label="lblEntProCre" />:&nbsp;
						<input type="checkbox" id="chkAddCrePro" name="chkAddCrePro" /></label></div><div class="leftField" ><label title="<system:label show="tooltip" label="lblQry" />" for="chkAddQry" class="label"><system:label show="text" label="lblQry" />:&nbsp;
						<input type="checkbox" id="chkAddQry" name="chkAddQry" /></label></div><div class="clearLeft"></div><div class="leftField extendedSize"><label title="<system:label show="tooltip" label="lblEntProAlt" />" for="chkAddAltPro" class="label"><system:label show="text" label="lblEntProAlt" />:&nbsp;
						<input type="checkbox" id="chkAddAltPro" name="chkAddAltPro" /></label></div><div class="field"><label title="<system:label show="tooltip" label="lblSugModAtt" />"><system:label show="text" label="lblSugModAtt" />:</label><input type="text" name="txtAttPre" id="txtAttPre" value="<system:edit show="constant" from="biz.statum.apia.web.bean.design.BusEntitiesBean" field="NOM_NAME" />"></div><div class="clearLeft"></div><div class="leftField extendedSize"><label title="<system:label show="tooltip" label="lblTemEnt" />"><system:label show="text" label="lblTemEnt" />:&nbsp;</label><div class="clearLeft"></div><select name="txtTemEnt" id="txtTemEnt"><system:util show="showPrepareEntTemplates" saveOn="templates" /><system:edit show="iteration" from="templates" saveOn="template"><system:edit show="saveValue" from="template" field="name" saveOn="name"/><option value="<system:edit show="value" from="template" field="name"/>" ><system:edit show="value" from="template" field="location"/></option></system:edit></select></div><div class="field"><label title="<system:label show="tooltip" label="lblTemEnt" />"><system:label show="text" label="lblTemEnt" />:&nbsp;</label><select name="txtTemPro" id="txtTemPro"><system:util show="showPrepareProTemplates" saveOn="templates" /><system:edit show="iteration" from="templates" saveOn="template"><system:edit show="saveValue" from="template" field="name" saveOn="name"/><option value="<system:edit show="value" from="template" field="name"/>" ><system:edit show="value" from="template" field="location"/></option></system:edit></select></div><div class="clearLeft"></div><div class="field required extendedSize" ><label title="<system:label show="tooltip" label="lblNomTar" />"><system:label show="text" label="lblNomTar" />:</label><input type="text" name="txtNomTar" id="txtNomTar" value="<system:edit show="constant" from="biz.statum.apia.web.bean.design.BusEntitiesBean" field="DEFAULT_TASK" />" style='width:50%' class="validate['required']"></div><div class="field"><label title="<system:label show="tooltip" label="lblNomRol" />"><system:label show="text" label="lblNomRol" />:</label><input type="text" name="txtNomRol" id="txtNomRol" value="<system:edit show="constant" from="biz.statum.apia.web.bean.design.BusEntitiesBean" field="DEFAULT_ROLE" />"></div></div><system:campaign inLogin="false" inSplash="false" location="horizontalDown" /></div></form></div><jsp:include page="../../includes/footer.jsp" /></body></html>