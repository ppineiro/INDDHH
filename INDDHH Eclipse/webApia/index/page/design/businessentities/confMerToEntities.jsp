<%@include file="../../includes/startInc.jsp" %><html><head><%@include file="../../includes/headInclude.jsp" %><link href="<system:util show="context" />/css/<system:util show="currentStyle" />/generalAdm.css" rel="stylesheet" type="text/css" ><script type="text/javascript" src="<system:util show="context" />/page/design/businessentities/confMerToEntities.js"></script><script type="text/javascript" src="<system:util show="context" />/page/includes/adminActionsEdition.js"></script><script type="text/javascript" src="<system:util show="context" />/page/includes/campaigns.js"></script><script type="text/javascript">
		var URL_REQUEST_AJAX = '/apia.design.BusinessEntitiesAction.run';
		var ADDITIONAL_INFO_IN_TABLE_DATA  = false;
		var LBL_BIND = '<system:label show="text" label="lblBind" forScript="true" />';
		var LBL_NOMREL = '<system:label show="text" label="lblNomRel" forScript="true" />';
		var LBL_ADM = '<system:label show="text" label="lblAdm" forScript="true" />';
		var LBL_EDIT = '<system:label show="text" label="lblEdi" forScript="true" />';
		var LBL_EDIT_TOOLTIP = '<system:label show="tooltip" label="lblEdi" forScript="true" />';
		var LBL_PARENT = '<system:label show="text" label="lblPadres" forScript="true" />';
		var LBL_SON = '<system:label show="text" label="lblHijos" forScript="true" />';
		var LBL_SAVE = '<system:label show="text" label="btnGua" forScript="true" />';
		var LBL_SAVE_STATE = '<system:label show="text" label="btnSaveState" forScript="true" />';		
	</script></head><body><div class="header"></div><div class="body" id="bodyDiv"><form id="frmData" method="post"><div class="optionsContainer"><system:campaign inLogin="false" inSplash="false" location="verticalUp" /><div class="fncPanel info"><div class="title"><system:label show="tooltip" label="titEntNeg" /></div><div class="content divFncDescription"><div class="fncDescriptionImage" src="<system:edit show="value" from="theBean" field="fncImage"/>"></div><div id="fncDescriptionText"><system:label show="text" label="dscFncAdmEnt"/></div><div class="clear"></div></div></div><div id="divAdminActEdit" class="fncPanel buttons"><div class="title"><system:label show="text" label="titActions"/></div><div class="content"><div id="btnLoadState" class="button" title="<system:label show="tooltip" label="btnLoadState" />"><system:label show="text" label="btnLoadState" /></div><div id="btnEdit" class="button" title="<system:label show="tooltip" label="lblEdi" />"><system:label show="text" label="lblEdi" /></div><div id="btnConfirm" class="button" title="<system:label show="tooltip" label="btnCon" />"><system:label show="text" label="btnCon" /></div><div id="btnBack" class="button" title="<system:label show="tooltip" label="btnVol" />"><system:label show="text" label="btnVol" /></div></div></div><system:campaign inLogin="false" inSplash="false" location="verticalDown" /></div><div class="dataContainer"><system:campaign inLogin="false" inSplash="false" location="horizontalUp" /><div class="fieldGroup"><div class="field extendedSize required"><label title="<system:label show="tooltip" label="lblPoolForTask" />"><system:label show="text" label="lblPoolForTask" />:</label><input type="text" value="<system:edit show="constant" from="biz.statum.apia.web.bean.design.BusEntitiesBean" field="POOL_DEFAULT_NAME" />" class="validate['required']" id="txtPoolName" name="txtPoolName"></div><div class="title"><system:label show="text" label="tabDatEntNeg" /></div></div></div><div class="gridContainer"><div class="gridHeader"><!-- Cabezal y filtros --><table cellpadding="0" cellspacing="0"><thead><tr id="trOrderBy" class="header"><th width="200px" title="<system:label show="tooltip" label="titEnt" />"><system:label show="text" label="titEnt" /></th><th width="200px" title="<system:label show="tooltip" label="titNomEnt" />"><system:label show="text" label="titNomEnt" /></th><th width="160px" title="<system:label show="tooltip" label="lblPrefix" />"><system:label show="text" label="lblPrefix" /></th><th width="160px" title="<system:label show="tooltip" label="lblTipoAdm" />"><system:label show="text" label="lblTipoAdm" /></th></tr></thead></table></div><div class="gridBody" id="gridBody"><!-- Cuerpo de la tabla --><table cellpadding="0" cellspacing="0"><thead><tr><th width="200px"></th><th width="200px"></th><th width="160px"></th><th width="160px"></th></tr></thead><tbody class="tableData" id="tableData"></tbody></table></div><div><system:label show="tooltip" label="msgEntImpMEREditSaveStat" /></div><!-- MESSAGES --><div class="message hidden" id="messageContainer"></div><system:campaign inLogin="false" inSplash="false" location="horizontalDown" /></div></form></div><%@include file="../../includes/footer.jsp" %></body></html>
