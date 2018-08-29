<%@include file="../../includes/startInc.jsp" %><html><head><%@include file="../../includes/headInclude.jsp" %><link href="<system:util show="context" />/css/<system:util show="currentStyle" />/generalAdm.css" rel="stylesheet" type="text/css" ><script type="text/javascript" src="<system:util show="context" />/page/design/cubes/edit.js"></script><script type="text/javascript" src="<system:util show="context" />/page/includes/adminActionsEdition.js"></script><script type="text/javascript" src="<system:util show="context" />/page/includes/adminFav.js"></script><script type="text/javascript" src="<system:util show="context" />/page/includes/navButtons.js"></script><script type="text/javascript" src="<system:util show="context" />/page/design/cubes/tabGenData.js"></script><script type="text/javascript" src="<system:util show="context" />/page/design/cubes/tabDataSource.js"></script><script type="text/javascript" src="<system:util show="context" />/page/design/cubes/tabMeasures.js"></script><script type="text/javascript" src="<system:util show="context" />/page/design/cubes/tabDims.js"></script><script type="text/javascript" src="<system:util show="context" />/page/design/cubes/tabPerms.js"></script><script type="text/javascript" src="<system:util show="context" />/page/modals/pools.js"></script><script type="text/javascript" src="<system:util show="context" />/page/modals/profiles.js"></script><script type="text/javascript" src="<system:util show="context" />/page/includes/campaigns.js"></script><script type="text/javascript">
		var URL_REQUEST_AJAX = '/apia.design.CubeAction.run';
		var isAllEnvs = "true";
		var isGlobal = "true";
		var LBL_ALL_ENVS = '<system:label show="text" label="lblTodAmb" forScript="true" />';
		var ADDITIONAL_INFO_IN_TABLE_DATA = false;
		var INSERT_MODE = "insert";
		var UPDATE_MODE = "update";
		
		var LBL_NAME = '<system:label show="text" label="lblNom" forHtml="true" forScript="true"/>';
		var LBL_DESC = '<system:label show="text" label="lblDes" forHtml="true" forScript="true"/>';
		var LBL_TYPE = '<system:label show="text" label="lblTipDat" forHtml="true" forScript="true"/>';
		var LBL_CON = '<system:label show="text" label="btnCon" forHtml="true" forScript="true"/>';
		
		var LBL_MEAS_CALCULATED = '<system:label show="text" label="lblMeasCalculated" forHtml="true" forScript="true"/>';	
		var LBL_MEAS_STANDARD = '<system:label show="text" label="lblMeasStandard" forHtml="true" forScript="true"/>';
		
		var MSG_ERROR_IN_SQL_VIEW_WITH_COMS = '<system:label show="text" label="msgErrSqlVwWithComs" forHtml="true" forScript="true"/>';
		var MSG_ERROR_IN_SQL_VIEW_WITH_MINOR_CHAR = '<system:label show="text" label="msgInvVWChar" forHtml="true" forScript="true"/>';
		var MSG_ERROR_IN_SQL_VIEW_WITH_ORDER_BY = '<system:label show="text" label="msgInvVWClause" forHtml="true" forScript="true"/>';
		var MSG_MUST_ENT_ONE_MEAS = '<system:label show="text" label="msgMustEntOneMeasure" forHtml="true" forScript="true"/>';
		var MSG_WRG_MEA_NAME = '<system:label show="text" label="msgWrgMeaName" forHtml="true" forScript="true"/>';
		var MSG_MEAS_INV_NAME = '<system:label show="text" label="msgMeasNomInv" forHtml="true" forScript="true"/>';
		var MSG_INV_NAME = '<system:label show="text" label="msgInvName" forHtml="true" forScript="true"/>';
		var MSG_MEAS_INV_CAP = '<system:label show="text" label="msgMeasCapInv" forHtml="true" forScript="true"/>';
		var MSG_MUST_ENTER_FORMULA = '<system:label show="text" label="msgMustEntFormula" forHtml="true" forScript="true"/>';
		var MSG_MIS_MEA_ATT = '<system:label show="text" label="msgMisMeaAttribute" forHtml="true" forScript="true"/>';
		var MSG_WRG_MEA_CAP = '<system:label show="text" label="msgWrgMeaCap" forHtml="true" forScript="true"/>';
		var MSG_MEAS_CANT_AUTOREF = '<system:label show="text" label="msgMeasCantAutoref" forHtml="true" forScript="true"/>';
		var MSG_MEAS_OP1_NAME_INVALID = '<system:label show="text" label="msgMeasOp1NameInvalid" forHtml="true" forScript="true"/>';
		var MSG_MEAS_OP2_NAME_INVALID = '<system:label show="text" label="msgMeasOp2NameInvalid" forHtml="true" forScript="true"/>';
		var MSG_OP_INVALID = '<system:label show="text" label="msgOpInvalid" forHtml="true" forScript="true"/>';
		var MSG_ATLEAST_ONE_MEAS_VISIBLE = '<system:label show="text" label="msgAtLeastOneMeasVisible" forHtml="true" forScript="true"/>';
		var MSG_CUBE_PRIV_ERRORS = '<system:label show="text" label="msgCbePrivError" forScript="true" />';
		var MSG_ERROR_IN_SQL = '<system:label show="text" label="msgErrorSql" forScript="true" />';
		var MSG_FACT_TABLE_NOT_FOUND = '<system:label show="text" label="msgCbeFactTableNotFound" forHtml="true" forScript="true"/>';
		var MSG_CANT_BE_TWO_MEAS_WITH_SAME_NAME = '<system:label show="text" label="msgMeasureNameUnique" forHtml="true" forScript="true"/>';
		var MSG_ALIAS_NOT_FOUND = '<system:label show="text" label="msgCbeAliasNotFound" forHtml="true" forScript="true"/>';
		var MSG_VIEW_NOT_FOUND = '<system:label show="text" label="msgCbeViewNotFound" forHtml="true" forScript="true"/>';
		var MSG_ERR_LOADING_DIM_DEF = '<system:label show="text" label="msgErrLoadingDimDef" forHtml="true" forScript="true"/>';
		var MSG_ERR_LOADING_HIER_DEF = '<system:label show="text" label="msgErrLoadingHierDef" forHtml="true" forScript="true"/>';
		var MSG_SRV_CONN_LOST = '<system:label show="text" label="msgSrvConnectionLost" forHtml="true" forScript="true"/>';
		var xml_dim = '<system:edit show="valueAsIs" from="theBean" field="cubeXML"/>';
		var def_xml_str = '<system:edit show="valueAsIs" from="theBean" field="cubeProperties"/>';
		
		var ERR_SAVING_COLUMNS = '<system:label show="text" label="errCubeSaveCols" forHtml="true" forScript="true"/>';
		
	</script></head><body><div id="exec-blocker"></div><div class="header"></div><div class="body" id="bodyDiv"><form id="frmData"><div class="optionsContainer"><system:campaign inLogin="false" inSplash="false" location="verticalUp" /><div class="fncPanel info"><div class="title"><system:label show="tooltip" label="mnuCubes" /><%@include file="../../includes/adminFav.jsp" %></div><div class="content divFncDescription"><div class="fncDescriptionImage" src="<system:edit show="value" from="theBean" field="fncImage"/>"></div><div id="fncDescriptionText"><system:label show="text" label="dscFncAdmCbe" /></div><div class="clear"></div></div></div><div class="fncPanel options" id="panelOptions" style="display:none"><div class="title"><system:label show="tooltip" label="mnuOpc" /></div><div class="content"><div id="btnTest" class="button"  title='<system:label show="tooltip" label="btnTestSql" />'><system:label show="text" label="btnTestSql" /></div><div class="clear"></div></div><div class="clear"></div></div><%@include file="../../includes/adminActionsEdition.jsp" %><system:campaign inLogin="false" inSplash="false" location="verticalDown" /></div><div class="dataContainer"><div class='tabComponent' id="tabComponent"><div class="aTabHeader"><system:campaign inLogin="false" inSplash="false" location="horizontalUp" /></div><%@include file="tabGenData.jsp" %><!-- TAB DE DATOS GENERALES --><%@include file="tabDataSource.jsp" %><!-- TAB DE ORIGEN DE DATOS --><%@include file="tabMeasures.jsp" %><!-- TAB DE MEDIDAS --><%@include file="tabDims.jsp" %><!-- TAB DE DIMENSIONES --><%@include file="tabPerms.jsp" %><!-- TAB DE PERMISOS --></div><system:campaign inLogin="false" inSplash="false" location="horizontalDown" /></div></form></div><!-- MODALS --><%@include file="../../modals/profiles.jsp" %><%@include file="../../modals/pools.jsp" %><%@include file="../../includes/footer.jsp" %></body></html>

