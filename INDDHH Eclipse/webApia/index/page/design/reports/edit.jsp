<%@page import="com.dogma.vo.RepParameterVo"%><%@include file="../../includes/startInc.jsp" %><html><head><%@include file="../../includes/headInclude.jsp" %><link href="<system:util show="context" />/css/<system:util show="currentStyle" />/generalAdm.css" rel="stylesheet" type="text/css" /><script type="text/javascript" src="<system:util show="context" />/page/design/reports/edit.js"></script><script type="text/javascript" src="<system:util show="context" />/page/includes/adminActionsEdition.js"></script><script type="text/javascript" src="<system:util show="context" />/page/includes/campaigns.js"></script><script type="text/javascript" src="<system:util show="context" />/page/includes/adminFav.js"></script><script type="text/javascript" src="<system:util show="context" />/page/includes/navButtons.js"></script><script type="text/javascript" src="<system:util show="context" />/page/modals/pools.js"></script><script type="text/javascript">
		var URL_REQUEST_AJAX = '/apia.design.ReportAction.run';
		var isAllEnvs = "true";
		var isGlobal = "true";
		var LBL_ALL_ENVS = '<system:label show="text" label="lblTodAmb" forScript="true" />';
		var ADDITIONAL_INFO_IN_TABLE_DATA = false;
		
		var MSG_USE_PROY_PERMS = '<system:label show="text" label="msgUseProyPerms" forScript="true" />';
		var MSG_PERM_WILL_BE_LOST = '<system:label show="text" label="msgPermDefWillBeLost" forScript="true" />';
		
		var LBL_NAME = '<system:label show="text" label="lblNom" forScript="true" />';
		var LBL_DESC = '<system:label show="text" label="lblDes" forScript="true" />';
		var LBL_TYPE = '<system:label show="text" label="lblTipDat" forScript="true" />';
		var LBL_DEF_VAL = '<system:label show="text" label="lblDefValue" forScript="true" />';
		var LBL_REQ = '<system:label show="text" label="lblReq" forScript="true" />';
		var LBL_NUMERIC = '<system:label show="text" label="lblNum" forHtml="true" forScript="true" />';
		var LBL_STRING = '<system:label show="text" label="lblStr" forScript="true" />';
		var LBL_FECHA = '<system:label show="text" label="lblFec" forScript="true" />';
		var LBL_INTEGER = '<system:label show="text" label="lblInt" forScript="true" />';
		
		var MSG_SCH_PRIV_ERROR = '<system:label show="text" label="msgSchPrivError" forScript="true" />';
		var LBL_SEL_DEF_VALUE = '<system:label show="text" label="lblSelDefValue" forScript="true" />';
		var LBL_ENT_DEF_VALUE = '<system:label show="text" label="lblEntDefValue" forScript="true" />';
		var LBL_USER_ID = '<system:label show="text" label="lblRepUserId" forScript="true" />';
		var LBL_USER_NAME = '<system:label show="text" label="lblRepUserName" forScript="true" />';
		var LBL_ENV_ID = '<system:label show="text" label="lblRepEnvId" forScript="true"  />';
		var LBL_ENV_NAME = '<system:label show="text" label="lblRepEnvName" forScript="true" />';
		var LBL_REP_QRY_TST_PARAMS = '<system:label show="text" label="lblRepQryTstParams" forScript="true" />';
		
		var MSG_FILE_NOT_FOUND = '<system:label show="text" label="msgFileNotFound" forScript="true" />';
		var MSG_MUST_HAVE_FILE = '<system:label show="text" label="msgRepMustHaveFile" forScript="true" />';
		var MSG_WRONG_FORMAT_FILE = '<system:label show="text" label="msgBadFileFormat" forScript="true" />';
		var MSG_QUERY_WITH_ERRORS = '<system:label show="text" label="msgRepQryWithErrors" forScript="true" />';
		var MSG_REP_PRIV_ERRORS = '<system:label show="text" label="msgRepPrivError" forScript="true" />';
		var MSG_REP_PARAM_NAME_REQ = '<system:label show="text" label="msgRepParamNameRequired" forScript="true" />';
		
		var MSG_SRV_CONN_LOST = '<system:label show="text" label="msgSrvConnectionLost" forHtml="true" forScript="true"/>';
		
		var paramsAdded=0;
		
		var REP_DEF_VALUE_TYPE_VARIABLE		= <%=RepParameterVo.REP_DEF_VALUE_TYPE_VARIABLE%>;
		var REP_DEF_VALUE_TYPE_FIXED 		= <%=RepParameterVo.REP_DEF_VALUE_TYPE_FIXED%>;
		var REP_DEF_VALUE_TYPE_USER_ID 		= <%=RepParameterVo.REP_DEF_VALUE_TYPE_USER_ID%>;
		var REP_DEF_VALUE_TYPE_USER_NAME 	= <%=RepParameterVo.REP_DEF_VALUE_TYPE_USER_NAME%>;
		var REP_DEF_VALUE_TYPE_ENV_ID		= <%=RepParameterVo.REP_DEF_VALUE_TYPE_ENV_ID%>;
		var REP_DEF_VALUE_TYPE_ENV_NAME		= <%=RepParameterVo.REP_DEF_VALUE_TYPE_ENV_NAME%>;
		
		var SRC_PENTAHO		= '<system:edit show="constant" from="com.dogma.vo.ReportVo" field="REP_SRC_PENTAHO" />';
		var SRC_BUS_CLASS	= '<system:edit show="constant" from="com.dogma.vo.ReportVo" field="REP_SRC_BUS_CLASS" />';
		
		var MSG_ADD_EXEC	= '<system:label show="text" label="msgAddExec" forScript="true" />';
		var MSG_EXEC_EXIST	= '<system:label show="text" label="msgExecExist" forScript="true" />';
	</script></head><body><div id="exec-blocker"></div><div class="header"></div><div class="body" id="bodyDiv"><form id="frmData"><div class="optionsContainer"><system:campaign inLogin="false" inSplash="false" location="verticalUp" /><div class="fncPanel info"><div class="title"><system:label show="tooltip" label="mnuReports" /><%@include file="../../includes/adminFav.jsp" %></div><div class="content divFncDescription"><div class="fncDescriptionImage" src="<system:edit show="value" from="theBean" field="fncImage"/>"></div><div id="fncDescriptionText"><system:label show="text" label="dscFncAdmRep" /></div><div class="clear"></div></div></div><%@include file="../../includes/adminActionsEdition.jsp" %><div class="fncPanel options"><div class="title"><system:label show="tooltip" label="mnuOpc" /></div><div class="content"><div id="btnUpdateCons" class="button" title="<system:label show="tooltip" label="btnActConn" />"><system:label show="text" label="btnActConn" /></div><div id="btnTest" class="button" title="<system:label show="tooltip" label="btnTestQry" />"><system:label show="text" label="btnTestQry" /></div><div id="optionUpload" class="button" title="<system:label show="tooltip" label="lblUploadFile" />"><system:label show="text" label="lblUploadFile" /></div><a style="text-decoration: none;" download="true" href="apia.design.ReportAction.run?action=downloadFile<system:util show="tabIdRequest" />"><div id="optionDownload" class="button extendedSize" title="<system:label show="tooltip" label="lblDownFile" />"><system:label show="text" label="lblDownFile" /></div></a><div class="clear"></div></div><div class="clear"></div></div><system:campaign inLogin="false" inSplash="false" location="verticalDown" /></div><div class="dataContainer"><div class='tabComponent' id="tabComponent"><div class="aTabHeader"><system:campaign inLogin="false" inSplash="false" location="horizontalUp" /></div><div class="aTab"><div class="tab"><system:label show="text" label="tabDatGen" /></div><div class="contentTab"><div class="fieldGroup"><div class="title"><system:label show="tooltip" label="sbtDatReport" /></div><div class="field fieldTwoFifths required"><label title="<system:label show="tooltip" label="lblNom" />"><system:label show="text" label="lblNom" />:</label><input type="text" name="repName" id="repName" class="validate['required','~validName']"  value="<system:edit show="value" from="theEdition" field="repName"/>"></div><div class="field fieldTwoFifths required"><label title="<system:label show="tooltip" label="lblTit" />"><system:label show="text" label="lblTit" />:</label><input type="text" name="repTitle" id="repTitle" class="validate['required']" value="<system:edit show="value" from="theEdition" field="repTitle"/>"></div><div class="field fieldFull"><label title="<system:label show="tooltip" label="lblDesc" />"><system:label show="text" label="lblDesc" />:</label><textarea name="repDesc" id="repDesc" maxlength="255" cols=80 rows=3><system:edit show="value" from="theEdition" field="repDesc"/></textarea></div></div><div class="fieldGroup" id="divFileName"><div class="field fieldTwoFifths required" ><label title="<system:label show="tooltip" label="lblReport" />"><system:label show="text" label="lblReport" />:</label><input type="text" id="fileName" name="fileName" class="validate['required'] readonly" value="<system:edit show="value" from="theEdition" field="fileName"/>" disabled></div></div><div class="fieldGroup"><div class="title"><system:label show="tooltip" label="titRepSource" /></div><div class="field fieldOneFifths required"><label title="<system:label show="text" label="lblQrySource" />"><system:label show="text" label="lblQrySource" />:</label><select id="cmbSrc" name="cmbSrc" class="validate['required']" onchange="onChangeCmbSrc(this);"><option value='<system:edit show="constant" from="com.dogma.vo.ReportVo" field="REP_SRC_PENTAHO" />'>Pentaho</option><option value='<system:edit show="constant" from="com.dogma.vo.ReportVo" field="REP_SRC_BUS_CLASS" />' <system:edit show="ifValue" from="theEdition" field="dbConId" value="-2">selected</system:edit> ><system:label show="text" label="lblCla"/></option></select></div><div class="field fieldTwoFifths required" id="divSelConn"><label title="<system:label show="tooltip" label="lblQryDbNom" />"><system:label show="text" label="lblQryDbNom" />:</label><select name="selConn" id="selConn" ><option value="-1" <system:edit show="ifValue" from="theEdition" field="dbConId" value="-1">selected</system:edit>><system:label show="text" label="lblLocalDbNom" /></option><option value="0" <system:edit show="ifValue" from="theEdition" field="dbConId" value="0">selected</system:edit>><system:label show="text" label="lblConNatReport" /></option><system:util show="prepareConnectionsList" saveOn="connections" /><system:edit show="iteration" from="connections" saveOn="connection"><system:edit show="saveValue" from="connection" field="dbConId" saveOn="dbConId"/><option value="<system:edit show="value" from="connection" field="dbConId"/>" <system:edit show="ifValue" from="theEdition" field="dbConId" value="with:dbConId">selected</system:edit>><system:edit show="value" from="connection" field="dbConName"/></option></system:edit></select></div><div class="field fieldTwoFifths fieldLast required" id="divQryNom"><label title="<system:label show="tooltip" label="lblQueryName" />"><system:label show="text" label="lblQueryName" />:</label><input type="text" name="repQryName" id="repQryName" class="validate['required','~validName']"  value="<system:edit show="value" from="theEdition" field="queryName"/>"></div><div class="field fieldTwoFifths required" id="divRepBusClaExec"><label title="<system:label show="tooltip" label="lblEje" />"><system:label show="text" label="lblEje" />:</label><input type="text" name="repBusClaExec" id="repBusClaExec" class="validate['required','~validName']"  value="<system:edit show="value" from="theEdition" field="repExecutable"/>"></div></div><div class="fieldGroup" id=""><div class="required" id="divQuery"><label style="display: inline-block;" title="<system:label show="tooltip" label="lblRepQuery" />"><system:label show="text" label="lblRepQuery" />:&nbsp;</label><textarea style="width:100%"name="repQuery" id="repQuery" maxlength="255" rows=3 class="validate['required']"><system:edit show="value" from="theEdition" field="repQuery"/></textarea></div></div><div class="fieldGroup" id="divParameters"><div class="title"><system:label show="tooltip" label="sbtRepFromPar" /></div><div id="measuresTable" class="gridContainer" style="margin: 0px;"><div class="gridHeader"><!-- Cabezal y filtros --><table cellpadding="0" cellspacing="0" id="gridHeaderHeader"><thead><tr class="header"><th title="<system:label show="tooltip" label="lblNom" />"><div style="width: 150px"><system:label show="text" label="lblNom" /></div></th><th title="<system:label show="tooltip" label="lblDes" />"><div style="width: 200px"><system:label show="text" label="lblDes" /></div></th><th title="<system:label show="tooltip" label="lblTipDat" />"><div style="width: 80px"><system:label show="text" label="lblTipDat" /></div></th><th title="<system:label show="tooltip" label="lblDefValue" />"><div style="width: 321px"><system:label show="text" label="lblDefValue" /></div></th><th title="<system:label show="tooltip" label="lblReq" />"><div style="width: 60px"><system:label show="text" label="lblReq" /></div></th></tr></thead></table></div><div class="gridBody" id="gridBodyParams"><!-- Cuerpo de la tabla --><table style="width: 800px; height: 1px;" cellpadding="0" cellspacing="0"><thead><tr><th width="148px"></th><th width="198px"></th><th width="78px"></th><th width="319px"></th><th width="58px"></th></tr></thead><tbody class="tableData" id="gridParams"></tbody></table></div><div class="gridFooter"><div class="listActionButtons" id="gridFooter"><div class="listAddDelRight" id="buttonsParam"><div class="btnAdd navButton" id="btnAddParam"><system:label show="text" label="btnAgr" /></div><div class="actSeparator">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</div><div class="btnDelete navButton" id="btnDeleteParam"><system:label show="text" label="btnEli" /></div></div></div></div></div></div></div></div><div class="aTab"><div class="tab"><system:label show="text" label="tabClaPer" /></div><div class="contentTab"><div class="fieldGroup"><div class="field extendedSize " ><label title="<system:label show="tooltip" label="sbtPerAccRep" />"><system:label show="text" label="sbtPerAccRep" />:</label><div id="prmPoolContainter" class="modalOptionsContainer"><div helper="true" id="prmAddPool" class="element docAddDocument"><div class="option optionAdd"><system:label show="text" label="btnAgr" /></div><input type="hidden" name="paramCount" id="paramCount" value="0"></div></div></div><div class="clear"></div></div><%@include file="../../modals/pools.jsp" %></div></div></div><system:campaign inLogin="false" inSplash="false" location="horizontalDown" /></div></form></div><%@include file="../../includes/footer.jsp" %></body></html>

