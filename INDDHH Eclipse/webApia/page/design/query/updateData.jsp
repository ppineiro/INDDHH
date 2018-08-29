<%@include file="../../includes/startInc.jsp" %><html lang="<%=biz.statum.apia.web.bean.BasicBeanStatic.getUserDataStatic(request).getLangCode()%>"><head><%@include file="../../includes/headInclude.jsp" %><link href="<system:util show="context" />/css/base/pages/query/main.css" rel="stylesheet" type="text/css" /><script type="text/javascript" src="<system:util show="context" />/page/design/query/updateData.js"></script><script type="text/javascript" src="<system:util show="context" />/page/design/query/updateActionQuery.js"></script><script type="text/javascript" src="<system:util show="context" />/page/design/query/updateWhereColumns.js"></script><script type="text/javascript" src="<system:util show="context" />/page/design/query/updateWhereUserColumns.js"></script><script type="text/javascript" src="<system:util show="context" />/page/design/query/tableaddcolumn.js"></script><script type="text/javascript" src="<system:util show="context" />/page/includes/adminFav.js"></script><script type="text/javascript" src="<system:util show="context" />/page/includes/campaigns.js"></script><script type="text/javascript" src="<system:util show="context" />/page/modals/images.js"></script><script type="text/javascript" src="<system:util show="context" />/page/modals/columns.js"></script><script type="text/javascript" src="<system:util show="context" />/page/modals/pools.js"></script><script type="text/javascript" src="<system:util show="context" />/page/modals/querys.js"></script><script type="text/javascript" src="<system:util show="context" />/page/modals/busClassParams.js"></script><script type="text/javascript" src="<system:util show="context" />/page/includes/navButtons.js"></script><script type="text/javascript" src="<system:util show="context" />/page/modals/attributes.js"></script><script type="text/javascript" src="<system:util show="context" />/page/generic/permissions.js"></script><script type="text/javascript" src="<system:util show="context" />/page/includes/adminActionsEdition.js"></script><script type="text/javascript">
		var URL_REQUEST_AJAX = '/apia.design.QueryAction.run';
		var ADDITIONAL_INFO_IN_TABLE_DATA = false;
		var SITE_ESCAPE_AJAX = false; 
// 		var GNR_PER_DAT_ING 	= '<system:label show="text" label="msgPerDatIng" forScript="true" />';	
		var QRY_DB_VIEW_NAME 	= '<system:edit show="value" from="theEdition" field="qryViewName" />';
		var ID 					= '<system:edit show="value" from="theEdition" field="dbConId" />';
		var QRY_DB_TYPE_COL   	= '<system:edit show="constant" from="com.dogma.vo.QryColumnVo" field="DB_TYPE_COLUMN" />';
		var QRT_DB_TYPE_NONE    = '<system:edit show="constant" from="com.dogma.vo.QryColumnVo" field="DB_TYPE_NONE" />';
		var QRY_ALLOW_ATT	  	= toBoolean('<system:edit show="flagValue" from="theEdition" field="5"  />');
		var attInsert 			= '<system:edit show="value" from="theEdition" field="attColumnsSize" />';
		var notAllowed = new Array(<system:edit show="valueAsIs" from="theBean" field="notAllowedColumns" />);
		var QRY_FREE_SQL_MODE	= toBoolean('<system:edit show="value" from="theEdition" field="freeSQL" />');
		var QRY_TYPE_ENTITY_MODAL	= '<system:edit show="constant" from="com.dogma.vo.IQuery" field="TYPE_ENTITY_MODAL" />';
		var BUS_CLA_ID 			= '<system:edit show="value" from="theBean" field="busClaId" />';
		var COLUMN_DATA_STRING = '<system:edit show="constant" from="com.dogma.vo.QryColumnVo" field="COLUMN_DATA_STRING" />'
		var COLUMN_DATA_NUMBER = '<system:edit show="constant" from="com.dogma.vo.QryColumnVo" field="COLUMN_DATA_NUMBER" />'
		var COLUMN_DATA_DATE   = '<system:edit show="constant" from="com.dogma.vo.QryColumnVo" field="COLUMN_DATA_DATE" />';
		var LBL_DATA_TYPE_STR = '<system:label show="text" label="lblStr" forScript="true" forHtml="true" />';
		var LBL_DATA_TYPE_NUM = '<system:label show="text" label="lblNum" forScript="true" forHtml="true" />';
		var LBL_DATA_TYPE_FEC = '<system:label show="text" label="lblFec" forScript="true" forHtml="true" />';

		var COLUMN_ORDER_ASC  = '<system:edit show="constant" from="com.dogma.vo.QryColumnVo" field="COLUMN_ORDER_ASC" />'
		var COLUMN_ORDER_DESC = '<system:edit show="constant" from="com.dogma.vo.QryColumnVo" field="COLUMN_ORDER_DESC" />';
		var lblQryColOrdAsc   = '<system:label show="text" label="lblQryColOrdAsc" forScript="true" />';
		var lblQryColOrdDesc = '<system:label show="text" label="lblQryColOrdDesc" forScript="true" />';
		var lblYes 			 = '<system:label show="text" label="lblYes" forScript="true" forHtml="true" />';
		var lblNo 			 = '<system:label show="text" label="lblNo" forScript="true" forHtml="true" />';
		var lblListbox		 = '<system:label show="text" label="lblListbox" forScript="true" forHtml="true" />';
		var lblBoth 			 = '<system:label show="text" label="lblBoth" forScript="true" forHtml="true" />';
		var lblNone 			 = '<system:label show="text" label="lblNone" forScript="true" forHtml="true" />';
		var lblDteFrom 			 = '<system:label show="text" label="lblDteFrom" forScript="true" forHtml="true" />';
		var lblDteTo 			 = '<system:label show="text" label="lblDteTo" forScript="true" forHtml="true" />';
		
		var lblQryAttFromEnt = '<system:label show="text" label="lblQryAttFromEnt" forScript="true" />';
		var lblQryAttFromPro = '<system:label show="text" label="lblQryAttFromPro" forScript="true" />';
		
		var ADD_AVOID_AUTO_FILTER = toBoolean('<system:edit show="ifValue" from="theEdition" field="qryType" value="Q" >true</system:edit>');
		var FLAG_TO_VIEW	  	= toBoolean('<system:edit show="flagValue" from="theEdition" field="2"  />');
		var addEntAttOpt = toBoolean('<system:edit show="flagValue" from="theEdition" field="0"  />');
		var addProAttOpt = toBoolean('<system:edit show="flagValue" from="theEdition" field="1"  />');
		var ADD_DONT_EXPORT = !(toBoolean('<system:edit show="ifValue" from="theEdition" field="qryType" value="M" >true</system:edit>')||toBoolean('<system:edit show="ifValue" from="theEdition" field="qryType" value="A" >true</system:edit>')||toBoolean('<system:edit show="ifValue" from="theEdition" field="qryType" value="O" >true</system:edit>'));
		var OPTIONS_BUS_ENTITY_COMBO_ARR = new Array(<system:edit show="valueAsIs" from="theBean" field="busEntityCombo" />);
		var isQuery 	 = toBoolean('<system:edit show="ifValue" from="theEdition" field="qryType" value="Q">true</system:edit>');
		var SOURCE_CONNECTION = toBoolean('<system:edit show="ifValue" from="theEdition" field="source" value="C">true</system:edit>');
		var QRY_TYPE_MODAL = '<system:edit show="constant" from="com.dogma.vo.IQuery" field="TYPE_MODAL" />';
		var QRY_TO_PROCEDURE		= toBoolean('<system:edit show="flagValue" from="theEdition" field="3"  />');	
		var QRY_TO_VIEW		= toBoolean('<system:edit show="flagValue" from="theEdition" field="2"  />');
		var TYPE_MON_ENTITY = toBoolean('<system:edit show="ifValue" from="theEdition" field="qryType" value="5" >true</system:edit>');
		var MSG_QRR_REQ_COL_SEL_MOD = '<system:label show="text" label="lblQryModReqColSel" forScript="true" />';
		var msgWsShowCols   = '<system:label show="text" label="msgWsShowCols" forScript="true" />';
		var cmbShoHid = '<system:edit show="value" from="theBean" field="cmbShoHid" />';
		
		var MSG_COL_NOT_ALLOW 	= '<system:label show="text" label="lblQryColNotAllow" forScript="true" />';
		var MSG_COL_NOT_ALLOW_S	= '<system:label show="text" label="msgQryColNotAllows" forScript="true" />';
		var MSG_SCH_COL_SELECTED = '<system:label show="text" label="msgSchColors" forScript="true" />';
		
		var COLUMN_FILTER_LESS 		 = '<system:edit show="constant" from="com.dogma.vo.QryColumnVo" field="COLUMN_FILTER_LESS" />';
		var COLUMN_FILTER_EQUAL 	 = '<system:edit show="constant" from="com.dogma.vo.QryColumnVo" field="COLUMN_FILTER_EQUAL" />';
		var COLUMN_FILTER_MORE 		 = '<system:edit show="constant" from="com.dogma.vo.QryColumnVo" field="COLUMN_FILTER_MORE" />';
		var COLUMN_FILTER_DISTINCT   = '<system:edit show="constant" from="com.dogma.vo.QryColumnVo" field="COLUMN_FILTER_DISTINCT" />';
		var COLUMN_FILTER_NULL 	  	 = '<system:edit show="constant" from="com.dogma.vo.QryColumnVo" field="COLUMN_FILTER_NULL" />';
		var COLUMN_FILTER_NOT_NULL   = '<system:edit show="constant" from="com.dogma.vo.QryColumnVo" field="COLUMN_FILTER_NOT_NULL" />';
		var COLUMN_FILTER_LESS_EQUAL = '<system:edit show="constant" from="com.dogma.vo.QryColumnVo" field="COLUMN_FILTER_LESS_EQUAL" />';
		var COLUMN_FILTER_MORE_EQUAL = '<system:edit show="constant" from="com.dogma.vo.QryColumnVo" field="COLUMN_FILTER_MORE_EQUAL" />';
		var COLUMN_FILTER_LIKE 		 = '<system:edit show="constant" from="com.dogma.vo.QryColumnVo" field="COLUMN_FILTER_LIKE" />';
		var COLUMN_FILTER_NOT_LIKE	 = '<system:edit show="constant" from="com.dogma.vo.QryColumnVo" field="COLUMN_FILTER_NOT_LIKE" />';
		var COLUMN_FILTER_START_WITH = '<system:edit show="constant" from="com.dogma.vo.QryColumnVo" field="COLUMN_FILTER_START_WITH" />';
		
		var lblQryFilEqual 	 = '<system:label show="text" label="lblQryFilEqual" forScript="true" />';
		var lblQryFilDis 	 = '<system:label show="text" label="lblQryFilDis" forScript="true" />';
		var lblQryFilLess 	 = '<system:label show="text" label="lblQryFilLess" forScript="true" />';
		var lblQryFilMore 	 = '<system:label show="text" label="lblQryFilMore" forScript="true" />';
		var lblQryFilMoreE 	 = '<system:label show="text" label="lblQryFilMoreE" forScript="true" />';
		var lblQryFilLessE 	 = '<system:label show="text" label="lblQryFilLessE" forScript="true" />';
		var lblQryFilLike 	 = '<system:label show="text" label="lblQryFilLike" forScript="true" />';
		var lblQryFilNotLike  = '<system:label show="text" label="lblQryFilNotLike" forScript="true" />';
		var lblQryFilStartWith  = '<system:label show="text" label="lblQryFilStartWith" forScript="true" />';
		var lblQryFilNull    = '<system:label show="text" label="lblQryFilNull" forScript="true" />';
		var lblQryFilNotNull = '<system:label show="text" label="lblQryFilNotNull" forScript="true" />';
		var lblEncFilter 	 = '<system:label show="text" label="lblEncFilter" forScript="true" />';
		var msgConfColChng   = '<system:label show="text" label="msgConfColChng" forScript="true" />';
		
		var COLUMN_TYPE_FILTER 	 = '<system:edit show="constant" from="com.dogma.vo.QryColumnVo" field="COLUMN_TYPE_FILTER" />';
		var COLUMN_TYPE_FUNCTION = '<system:edit show="constant" from="com.dogma.vo.QryColumnVo" field="COLUMN_TYPE_FUNCTION" />';		
		lblQryVal  = '<system:label show="text" label="lblQryValue" forScript="true" />';
		var lblQryFunc = '<system:label show="text" label="lblQryFunc" forScript="true" forHtml="true"/>';
		var lblQryFunc2 = '<system:label show="text" label="lblQryFunc" forScript="true" forHtml="true" />';
		
		var FUNCTION_NONE		= '<system:edit show="constant" from="com.dogma.vo.QryColumnVo" field="FUNCTION_NONE" />';
		var FUNCTION_DATE_EQUAL = '<system:edit show="constant" from="com.dogma.vo.QryColumnVo" field="FUNCTION_CURRENT_DATE" />';
		var FUNCTION_ENV_ID		= '<system:edit show="constant" from="com.dogma.vo.QryColumnVo" field="FUNCTION_ENV_ID" />';
		var FUNCTION_ENV_NAME	= '<system:edit show="constant" from="com.dogma.vo.QryColumnVo" field="FUNCTION_ENV_NAME" />';
		var FUNCTION_USER 		= '<system:edit show="constant" from="com.dogma.vo.QryColumnVo" field="FUNCTION_USER" />';
		
		var lblQryFunDteEqu  = '<system:label show="text" label="lblQryFunDteEqu" forScript="true" />';
		var lblQryFunEnvId 	 = '<system:label show="text" label="lblQryFunEnvId" forScript="true" />';
		var lblQryFunEnvName = '<system:label show="text" label="lblQryFunEnvName" forScript="true" />';
		var lblQryFunUser	 = '<system:label show="text" label="lblQryFunUser" forScript="true" />';
		
		var showAttFrom  = addEntAttOpt&&addProAttOpt;
		
		var NUMBER_TYPE_EQUAL			= '<system:edit show="constant" from="com.dogma.vo.filter.IQueryFilter" field="NUMBER_TYPE_EQUAL" />';
		var NUMBER_TYPE_LESS			= '<system:edit show="constant" from="com.dogma.vo.filter.IQueryFilter" field="NUMBER_TYPE_LESS" />';
		var NUMBER_TYPE_MORE			= '<system:edit show="constant" from="com.dogma.vo.filter.IQueryFilter" field="NUMBER_TYPE_MORE" />';
		var NUMBER_TYPE_DISTINCT		= '<system:edit show="constant" from="com.dogma.vo.filter.IQueryFilter" field="NUMBER_TYPE_DISTINCT" />';
		var NUMBER_TYPE_LESS_OR_EQUAL	= '<system:edit show="constant" from="com.dogma.vo.filter.IQueryFilter" field="NUMBER_TYPE_LESS_OR_EQUAL" />';
		var NUMBER_TYPE_MORE_OR_EQUAL	= '<system:edit show="constant" from="com.dogma.vo.filter.IQueryFilter" field="NUMBER_TYPE_MORE_OR_EQUAL" />';

		var LBL_NUMBER_TYPE_EQUAL 		= '<system:label show="text" label="lblFilEqu" forScript="true" />';
		var LBL_NUMBER_TYPE_LESS 		= '<system:label show="text" label="lblFilLes" forScript="true" />';
		var LBL_NUMBER_TYPE_MORE 		= '<system:label show="text" label="lblFilMor" forScript="true" />';
		var LBL_NUMBER_TYPE_DISTINCT 	= '<system:label show="text" label="lblFilDis" forScript="true" />';
		var LBL_NUMBER_TYPE_LESS_OR_EQUAL = '<system:label show="text" label="lblFilLesE" forScript="true" />';
		var LBL_NUMBER_TYPE_MORE_OR_EQUAL = '<system:label show="text" label="lblFilMorE" forScript="true" />';
		
		var STRING_TYPE_EQUAL			= '<system:edit show="constant" from="com.dogma.vo.filter.IQueryFilter" field="STRING_TYPE_EQUAL" />';
		var STRING_TYPE_STARTS_WITH		= '<system:edit show="constant" from="com.dogma.vo.filter.IQueryFilter" field="STRING_TYPE_STARTS_WITH" />';
		var STRING_TYPE_ENDS_WITH		= '<system:edit show="constant" from="com.dogma.vo.filter.IQueryFilter" field="STRING_TYPE_ENDS_WITH" />';
		var STRING_TYPE_LIKE			= '<system:edit show="constant" from="com.dogma.vo.filter.IQueryFilter" field="STRING_TYPE_LIKE" />';
		var STRING_TYPE_NOT_EQUAL		= '<system:edit show="constant" from="com.dogma.vo.filter.IQueryFilter" field="STRING_TYPE_NOT_EQUAL" />';
		var STRING_TYPE_NOT_STARTS_WITH	= '<system:edit show="constant" from="com.dogma.vo.filter.IQueryFilter" field="STRING_TYPE_NOT_STARTS_WITH" />';
		var STRING_TYPE_NOT_ENDS_WITH	= '<system:edit show="constant" from="com.dogma.vo.filter.IQueryFilter" field="STRING_TYPE_NOT_ENDS_WITH" />';
		var STRING_TYPE_NOT_LIKE		= '<system:edit show="constant" from="com.dogma.vo.filter.IQueryFilter" field="STRING_TYPE_NOT_LIKE" />';

		LBL_STRING_TYPE_EQUAL 			= '<system:label show="text" label="lblFilEqu" forScript="true" />';
		LBL_STRING_TYPE_STARTS_WITH 	= '<system:label show="text" label="lblFilLikRig" forScript="true" />';
		LBL_STRING_TYPE_ENDS_WITH 		= '<system:label show="text" label="lblFilLikLef" forScript="true" />';
		LBL_STRING_TYPE_LIKE 			= '<system:label show="text" label="lblFilLik" forScript="true" />';
		LBL_STRING_TYPE_NOT_EQUAL 		= '<system:label show="text" label="lblFilNotEqu" forScript="true" />';
		LBL_STRING_TYPE_NOT_STARTS_WITH = '<system:label show="text" label="lblFilNotLikRig" forScript="true" />';
		LBL_STRING_TYPE_NOT_ENDS_WITH 	= '<system:label show="text" label="lblFilNotLikLef" forScript="true" />';
		LBL_STRING_TYPE_NOT_LIKE 		= '<system:label show="text" label="lblFilNotLik" forScript="true" />';
		
		var IS_QUERY_TYPE_OFFLINE          = toBoolean('<system:edit show="ifValue" from="theEdition" field="qryType" value="O">true</system:edit>');
		
		var requiereActVieEntCol = [<system:edit show="valueAsIs" from="theBean" field="requiereActVieEntCol" />];
		var requiereActVieProCol = [<system:edit show="valueAsIs" from="theBean" field="requiereActVieProCol" />];
		var requiereActVieTasCol = [<system:edit show="valueAsIs" from="theBean" field="requiereActVieTasCol" />];
		var requiereActWorEntCol = [<system:edit show="valueAsIs" from="theBean" field="requiereActWorEntCol" />];
		var requiereActWorTasCol = [<system:edit show="valueAsIs" from="theBean" field="requiereActWorTasCol" />];
		var requiereActAcqTasCol = [<system:edit show="valueAsIs" from="theBean" field="requiereActAcqTasCol" />];
		var requiereActComTasCol = [<system:edit show="valueAsIs" from="theBean" field="requiereActComTasCol" />];
		
		var requieredEntAttCols	 = [<system:edit show="valueAsIs" from="theBean" field="requieredEntityAttributeColumns" />];
		var requieredProAttCols	 = [<system:edit show="valueAsIs" from="theBean" field="requieredProcessAttributeColumns" />];
		
		//Definicion de tipos
		var BAR_HOR_TYPE 		= '<system:label show="text" label="txtBarHorType" forScript="true" />';
		var BAR_VER_TYPE		= '<system:label show="text" label="txtBarVerType" forScript="true" />';
		var LIN_TYPE			= '<system:label show="text" label="txtLineType" forScript="true" />';
		var WFALL_TYPE			= '<system:label show="text" label="txtWFallType" forScript="true" />';
		var PIE_TYPE			= '<system:label show="text" label="txtPieType" forScript="true" />';
		var MSG_NO_SERIE		= '<system:label show="text" label="msgNoSeries" forScript="true" />';
		
		var BAR_VER_TYPE_ID		= '<system:edit show="constant" from="com.dogma.vo.QryChartVo" field="TYPEBARVERT" />';
		var BAR_HOR_TYPE_ID		= '<system:edit show="constant" from="com.dogma.vo.QryChartVo" field="TYPEBARHOR" />';
		var LINE_TYPE_ID		= '<system:edit show="constant" from="com.dogma.vo.QryChartVo" field="TYPELINES" />';
		var WFALL_TYPE_ID		= '<system:edit show="constant" from="com.dogma.vo.QryChartVo" field="TYPEWATERFALL" />';
		var PIE_TYPE_ID			= '<system:edit show="constant" from="com.dogma.vo.QryChartVo" field="PIE" />';

		//Definicion de subtipos
		var b2D_SUBTYPE			= '<system:label show="text" label="txt2DSubType" forScript="true" />';
		var b3D_SUBTYPE			= '<system:label show="text" label="txt3DSubType" forScript="true" />';
		
		var b2D_SUBTYPE_ID		= '<system:edit show="constant" from="com.dogma.vo.QryChartVo" field="SUBTYPE2D" />';
		var b3D_SUBTYPE_ID		= '<system:edit show="constant" from="com.dogma.vo.QryChartVo" field="SUBTYPE3D" />';
		
		var CHART_CATEGORY		= '<system:label show="text" label="lblCateg" forScript="true" />';
		var CHART_LABELX             = '<system:label show="text" label="lblEjeX" forScript="true" />';
		
		//Definicion de ejemplos de graficas
		var barsVert2d          = CONTEXT+"/styles/"+STYLE+"/images/vertical2d.jpg";
		var barsHor2d			= CONTEXT+"/styles/"+STYLE+"/images/horizontal2d.jpg";
		var barsVert3d			= CONTEXT+"/styles/"+STYLE+"/images/vertical3d.jpg";
		var barsHor3d 			= CONTEXT+"/styles/"+STYLE+"/images/horizontal3d.jpg";
		var lines2d				= CONTEXT+"/styles/"+STYLE+"/images/lines.jpg";
		var waterFall2d			= CONTEXT+"/styles/"+STYLE+"/images/waterfall.jpg";
		var pie2d				= CONTEXT+"/styles/"+STYLE+"/images/pie2d.jpg";
		var pie3d				= CONTEXT+"/styles/"+STYLE+"/images/pie3d.jpg";
		
		//Definicion de arrays con tipos y subtipos
		var typSubtype1 = new Array(BAR_VER_TYPE,b2D_SUBTYPE,b3D_SUBTYPE);
		var typSubtype2 = new Array(BAR_HOR_TYPE,b2D_SUBTYPE,b3D_SUBTYPE);
		var typSubtype3 = new Array(LIN_TYPE,b2D_SUBTYPE);
		var typSubtype4 = new Array(WFALL_TYPE,b2D_SUBTYPE);
		var typSubtype5 = new Array(PIE_TYPE,b2D_SUBTYPE,b3D_SUBTYPE);
		
		//Definicion del array que contiene los arrays con tipo y subtipos
		var typSubtypes = new Array(typSubtype1,typSubtype2,typSubtype3,typSubtype4,typSubtype5);
		
		//Definicion de array con samples de graficas
		var typSample1  = new Array(BAR_VER_TYPE,barsVert2d,barsVert3d);
		var typSample2  = new Array(BAR_HOR_TYPE,barsHor2d,barsHor3d);
		var typSample3  = new Array(LIN_TYPE,lines2d);
		var typSample4  = new Array(WFALL_TYPE,waterFall2d);
		var typSample5  = new Array(PIE_TYPE,pie2d,pie3d);
		
		//Definicion del array con los tipos y sus graficas de ejemplo
		var typSamples  = new Array(typSample1,typSample2,typSample3,typSample4,typSample5);
		
		var LBL_DESIGN = '<system:label show="text" label="lblQryChtDesign" forScript="true" />';
		var LBL_PROPERTIES = '<system:label show="text" label="lblQryChtProps" forScript="true" />';
		var ERR_NOT_VALID_FILTER	= '<system:label show="text" label="lblQryNotValFilter" forScript="true" />';

		var MSG_PERM_WILL_BE_LOST = '<system:label show="text" label="msgPermDefWillBeLost" forScript="true" />';
		
		var TIME_SEPARATOR			= '<system:edit show="value" from="theBean" field="timeSeparator"/>';
		var VALID_HR				= '<system:label show="text" label="lblValidHr" forScript="true" />';
		
		var PATH_IMG				= '<system:edit show="constant" from="com.dogma.vo.ImagesVo" field="IMAGES_UPLOADED" />';
		var DEFAULT_IMG				= '<system:edit show="constant" from="com.dogma.vo.ImagesVo" field="DEFAULT_IMG_QRY_QUERY" />';
		
		//COLUMNAS COMO FILTRO DE USUARIO
		var LBL_USE_AS_FILTER		= '<system:label show="text" label="titUseAsFilter" forScript="true" />';
		var MSG_USE_AS_FILTER_1		= '<system:label show="text" label="msgUseAsFilter1" forScript="true" />';
		var MSG_USE_AS_FILTER_2		= '<system:label show="text" label="msgUseAsFilter2" forScript="true" />';
		
		var MSG_CANT_DEL_COL_CHART	= '<system:label show="text" label="msgCantDelColChart" forScript="true" />';
		var PRIMARY_SEPARATOR		= new Element('div').set('html', '<system:edit show="constant" from="com.st.util.StringUtil" field="PRIMARY_SEPARATOR"/>').get('text');
	
		var ONLY_VIEW	= toBoolean('<system:edit show="value" from="theBean" field="onlyView" />');
		
		var CAN_HAVE_PANEL	= toBoolean('<system:edit show="value" from="theBean" field="canHavePanel" />');
				
		var STEP_DB_CONN_MODIFIED	= toBoolean('<%= "true".equals(request.getParameter("stepDbConnMod")) %>');
	</script></head><body><div id="exec-blocker"></div><div class="body" id="bodyDiv"><form id="frmData"><div class="optionsContainer"><system:campaign inLogin="false" inSplash="false" location="verticalUp" /><div class="fncPanel info"><div class="title"><system:label show="text" label="mnuQry" /><%@include file="../../includes/adminFav.jsp" %></div><div class="content divFncDescription"><div class="fncDescriptionImage" data-src="<system:edit show="value" from="theBean" field="fncImage"/>"></div><div id="fncDescriptionText"><system:label show="text" label="dscFncAdmQry" /></div><div class="clear"></div></div></div><div id="divAdminActEdit" class="fncPanel buttons"><div class="title"><system:label show="text" label="titActions"/></div><div class="content"><system:edit show="ifValue" from="theBean" field="onlyView" value="false"><div id="btnConf" class="button suggestedAction" title="<system:label show="tooltip" label="btnCon" />"><system:label show="text" label="btnCon" /></div></system:edit><system:edit show="ifNotValue" from="theBean" field="entityModalOrAutomatic" value="true"><div id="btnAnt" class="button" title="<system:label show="tooltip" label="btnAnt" />"><system:label show="text" label="btnAnt" /></div></system:edit><system:edit show="ifValue" from="theEdition" field="freeSQL" value="true"><div id="btnTest" class="button" title="<system:label show="tooltip" label="btnTest" />"><system:label show="text" label="btnTest" /></div></system:edit><div id="btnBackToList" class="button" title="<system:label show="tooltip" label="btnVol" />"><system:label show="text" label="btnVol" /></div></div></div><div class="fncPanel buttons"><div class="title"><system:label show="text" label="mnuOpc" /></div><system:edit show="ifValue" from="theBean" field="queryHasFunctionality" value="true"><div class="content"><div id="btnResetImg" class="button extendedSize" title="<system:label show="text" label="btnResetImg" />"><system:label show="text" label="btnResetImg" /></div></div></system:edit><div class="content" style="display: none;" id="contentUseAsFilter"><div id="btnUseAsFilter" class="button extendedSize" title="<system:label show="tooltip" label="btnUseAsFilter" />"><system:label show="text" label="btnUseAsFilter" /></div></div></div><system:campaign inLogin="false" inSplash="false" location="verticalDown" /></div><div class="dataContainer"><div class='tabComponent' id="tabComponent"><div class="aTabHeader"><system:campaign inLogin="false" inSplash="false" location="horizontalUp" /></div><div class="aTab"><div class="tab" title="<system:label show="tooltip" label="tabDatGen" />"><system:label show="text" label="tabDatGen" /></div><div class="contentTab"><div class="gridContainer" style="margin: 0px"><div class="fieldGroup"><div class="title"><system:label show="text" label="sbtQryData" /></div><div class="field fieldTwoFifths required"><label title="<system:label show="tooltip" label="lblNom" />"><system:label show="text" label="lblNom" />:&nbsp;</label><input type="text" name="txtName" id="txtName" maxlength="50" class="validate['required','~validName']" value="<system:edit show="value" from="theEdition" field="qryName"/>"></div><div class="field fieldTwoFifths required"><label title="<system:label show="tooltip" label="lblTit" />"><system:label show="text" label="lblTit" />:&nbsp;</label><input type="text" name="txtTitle" id="txtTitle" maxlength="255" class="validate['required']" value="<system:edit show="value" from="theEdition" field="qryTitle"/>"></div><div class="field fieldOneFifths fieldLast"><label title="<system:label show="tooltip" label="titPrj" />"><system:label show="text" label="titPrj" />:&nbsp;</label><select name="selPrj" id="cmbProject"  ><option value="0"></option><system:util show="prepareProjects" saveOn="projects" /><system:edit show="iteration" from="projects" saveOn="project"><system:edit show="saveValue" from="project" field="prjId" saveOn="prjId"/><option value="<system:edit show="value" from="project" field="prjId"/>" <system:edit show="ifValue" from="theEdition" field="prjId" value="with:prjId">selected</system:edit>><system:edit show="value" from="project" field="prjTitle"/></option></system:edit></select></div><div class="field fieldFull"><label title="<system:label show="tooltip" label="lblDes" />"><system:label show="text" label="lblDes" />:&nbsp;</label><textarea name="txtDesc" id="txtDesc" maxlength="255" cols=80 rows=3><system:edit show="value" from="theEdition" field="qryDesc"/></textarea></div><div class="field fieldOneThird"><system:edit show="ifValue" from="theEdition" field="source" value="B"><label title="<system:label show="tooltip" label="lblBusClass" />"><system:label show="text" label="lblBusClass" />:&nbsp;</label></system:edit><system:edit show="ifValue" from="theEdition" field="source" value="C"><label title="<system:label show="tooltip" label="lblQryView" />"><system:label show="text" label="lblQryView" />:&nbsp;</label></system:edit><system:edit show="ifValue" from="theBean" field="viewClassName" value="freesql" >FREE SQL SENTENCE</system:edit><system:edit show="ifNotValue" from="theBean" field="viewClassName" value="freesql" ><system:edit show="value" from="theBean" field="viewClassName" /></system:edit></div><div class="field fieldOneThird"><label title="<system:label show="tooltip" label="lblQryType" />"><system:label show="text" label="lblQryType" />:&nbsp;</label><system:edit show="value" from="theBean" field="queryType" /><input id="selQryTyp" name="selQryTyp" type="hidden" value="<system:edit show="value" from="theEdition" field="qryType" />" /></div><system:edit show="ifValue" from="theBean" field="showExternalUrl" value="true"><div class="clearLeft sep"></div><div class="field fieldFull"><label title="<system:label show="tooltip" label="lblExternalUrlAccess" />"><system:label show="text" label="lblExternalUrlAccess" />:&nbsp;</label><system:edit show="value" from="theBean" field="generateQueryUrl" /></div></system:edit><system:edit show="ifValue" from="theBean" field="queryHasFunctionality" value="true"><div class="fieldGroup splitOneThirdImg"><div class="field" ><label title="<system:label show="tooltip" label="prpImg" />" class="label"><system:label show="text" label="prpImg" />:&nbsp;</label></div><div class="field fieldImg"><div class="imagePicker" style="background-image:url(<system:edit show="value" from="theBean" field="imgFullPath" />)" id="changeImg"><input type="hidden" name="txtImgPath" id="txtImgPath" value="<system:edit show="value" from="theEdition" field="imgPath" />" ></div></div></div></system:edit><div class="clearLeft sep"></div><!-- PANEL --><system:edit show="ifValue" from="theBean" field="canHavePanel" value="true"><div class="title"><system:label show="text" label="titPnls" /></div><div class="field extendedSize inOneLine"><label title="<system:label show="tooltip" label="lblMonDocGenPnl" />"><system:label show="text" label="lblMonDocGenPnl" />:&nbsp;</label><input type="checkbox" name="flagGenPanel" id="flagGenPanel" <system:edit show="ifFlag" from="theEdition" field="20">checked="true"</system:edit><system:edit show="ifValue" from="theBean" field="panelUsed" value="true">disabled="true"</system:edit>></div></system:edit><div class="title"><system:label show="text" label="sbtQryShow" /></div><%@include file="updateDataShow.jsp" %></div></div></div></div><div class="aTab"><div class="tab" title="<system:label show="tooltip" label="tabQryWhere" />" id="tabQryWhere"><system:label show="text" label="tabQryWhere" /></div><div class="contentTab"><div class="gridContainer" style="margin: 0px"><div class="fieldGroup"><div class="title"><system:label show="text" label="sbtQryData" /></div><div class="field fieldOneThird"><system:edit show="ifValue" from="theEdition" field="source" value="B"><label title="<system:label show="tooltip" label="lblBusClass" />"><system:label show="text" label="lblBusClass" />:&nbsp;</label></system:edit><system:edit show="ifValue" from="theEdition" field="source" value="C"><label title="<system:label show="tooltip" label="lblQryView" />"><system:label show="text" label="lblQryView" />:&nbsp;</label></system:edit><system:edit show="ifValue" from="theBean" field="viewClassName" value="freesql" >FREE SQL SENTENCE</system:edit><system:edit show="ifNotValue" from="theBean" field="viewClassName" value="freesql" ><system:edit show="value" from="theBean" field="viewClassName" /></system:edit></div><div class="field fieldOneThird"><label title="<system:label show="tooltip" label="lblQryType" />"><system:label show="text" label="lblQryType" />:&nbsp;</label><system:edit show="value" from="theBean" field="queryType" /></div><div class="clearLeft sep"></div><div class="title"><system:label show="text" label="sbtQryWhere" /></div><system:edit show="ifValue" from="theEdition" field="freeSQL" value="false" ><%@include file="updateDataWhere.jsp" %><div class="clearLeft sep"></div><div class="clearLeft sep"></div><div class="title"><system:label show="text" label="sbtPreView" /></div><div id="previewWhere" class="fieldTreeQuarter"></div></system:edit><system:edit show="ifValue" from="theEdition" field="freeSQL" value="true" ><div class="field"><label title="<system:label show="tooltip" label="lblQrySqlWhere" />" for="chkAddFilterWhere" class="label"><system:label show="text" label="lblQrySqlWhere" />:&nbsp;</label><input type="checkbox" id="chkAddFilterWhere" name="chkAddFilterWhere" <system:edit show="ifFlag" from="theEdition" field="19" >checked</system:edit> /></div><div class="hrDiv"></div><div class="clearLeft sep"></div><div class="field fieldTreeQuarter"><label title="<system:label show="tooltip" label="lblQrySql" />" for="qryFreeSQL" class="label"><system:label show="text" label="lblQrySql" />:&nbsp;</label><textarea rows="10" cols="80" name="qryFreeSQL" id="qryFreeSQL"><system:edit show="value" from="theEdition" field="sql"/></textarea></div></system:edit></div></div></div></div><system:edit show="ifNotValue" from="theEdition" field="qryType" value="O"><div class="aTab"><div class="tab" title="<system:label show="tooltip" label="tabQryWhereUser" />" id="tabQryWhereUser"><system:label show="text" label="tabQryWhereUser" /></div><div class="contentTab"><div class="gridContainer" style="margin: 0px"><div class="fieldGroup"><div class="title"><system:label show="text" label="sbtQryData" /></div><div class="field inOneLine fieldOneThird"><system:edit show="ifValue" from="theEdition" field="source" value="B"><label title="<system:label show="tooltip" label="lblBusClass" />"><system:label show="text" label="lblBusClass" />:&nbsp;</label></system:edit><system:edit show="ifValue" from="theEdition" field="source" value="C"><label title="<system:label show="tooltip" label="lblQryView" />"><system:label show="text" label="lblQryView" />:&nbsp;</label></system:edit><system:edit show="ifValue" from="theBean" field="viewClassName" value="freesql" >FREE SQL SENTENCE</system:edit><system:edit show="ifNotValue" from="theBean" field="viewClassName" value="freesql" ><system:edit show="value" from="theBean" field="viewClassName" /></system:edit></div><div class="field inOneLine fieldOneThird"><label title="<system:label show="tooltip" label="lblQryType" />"><system:label show="text" label="lblQryType" />:&nbsp;</label><system:edit show="value" from="theBean" field="queryType" /></div><div class="clearLeft sep"></div><div class="title"><system:label show="text" label="sbtQryWhereUsu" /></div><%@include file="updateDataWhereUser.jsp" %></div></div></div></div></system:edit><system:edit show="ifValue" from="theEdition" field="qryType" value="O"><div class="aTab"><div class="tab" title="<system:label show="tooltip" label="tabQrySch" />"><system:label show="text" label="tabQrySch" /></div><div class="contentTab"><div class="gridContainer" style="margin: 0px"><%@include file="updateDataScheduler.jsp" %></div></div></div></system:edit><system:edit show="ifNotValue" from="theEdition" field="qryType" value="O"><system:edit show="ifNotValue" from="theEdition" field="qryType" value="A"><system:edit show="ifNotValue" from="theEdition" field="qryType" value="M"><system:edit show="ifNotValue" from="theEdition" field="qryType" value="1"><system:edit show="ifNotValue" from="theEdition" field="qryType" value="2"><system:edit show="ifNotValue" from="theEdition" field="qryType" value="3"><system:edit show="ifNotValue" from="theEdition" field="qryType" value="4"><system:edit show="ifNotValue" from="theEdition" field="qryType" value="5"><div class="aTab"><div class="tab" title="<system:label show="tooltip" label="tabQryBut" />"><system:label show="text" label="tabQryBut" /></div><div class="contentTab"><div class="gridContainer" style="margin: 0px"><div class="fieldGroup"><div class="title"><system:label show="text" label="sbtQryBut" /></div><%@include file="updateDataButtons.jsp" %></div></div></div></div></system:edit></system:edit></system:edit></system:edit></system:edit></system:edit></system:edit></system:edit><system:edit show="ifValue" from="theEdition" field="qryType" value="Q"><div class="aTab"><div class="tab" title="<system:label show="tooltip" label="tabQryAct" />" id="tabActions"><system:label show="text" label="tabQryAct" /></div><div class="contentTab"><div class="gridContainer" style="margin: 0px"><div class="fieldGroup"><div class="title"><system:label show="text" label="sbtQryAct" /></div><%@include file="updateDataActions.jsp" %></div></div></div></div></system:edit><system:edit show="ifNotValue" from="theEdition" field="qryType" value="O"><div class="aTab"><div class="tab" title="<system:label show="tooltip" label="tabQryEvent" />"><system:label show="text" label="tabQryEvent" /></div><div class="contentTab"><div class="gridContainer" style="margin: 0px"><div class="fieldGroup"><div class="title"><system:label show="text" label="sbtEvent" /></div><%@include file="updateDataEvents.jsp" %></div></div></div></div></system:edit><system:edit show="ifValue" from="theEdition" field="qryType" value="Q"><div class="aTab"><div class="tab" title="<system:label show="tooltip" label="tabQryWs" />"><system:label show="text" label="tabQryWs" /></div><div class="contentTab"><div class="gridContainer" style="margin: 0px"><div class="fieldGroup"><div class="title"><system:label show="text" label="sbtQryWs" /></div><%@include file="updateDataWebService.jsp" %></div></div></div></div></system:edit><system:edit show="ifValue" from="theEdition" field="qryType" value="5"><div class="aTab"><div class="tab" title="<system:label show="tooltip" label="tabQryAttRemap" />" id="tabQryAttRemap"><system:label show="text" label="tabQryAttRemap" /></div><div class="contentTab"><div class="gridContainer" style="margin: 0px"><div class="fieldGroup"><div class="title"><system:label show="text" label="sbtQryAttRemp" /></div><%@include file="updateDataAttRemaping.jsp" %></div></div></div></div></system:edit><system:edit show="ifValue" from="theEdition" field="qryType" value="Q"><div class="aTab"><div class="tab" title="<system:label show="tooltip" label="tabCharts" />"><system:label show="text" label="tabCharts" /></div><div class="contentTab"><div class="gridContainer" style="margin: 0px"><div class="fieldGroup"><%@include file="updateDataCharts.jsp" %></div></div></div></div></system:edit><div class="aTab"><div class="tab" title="<system:label show="tooltip" label="tabBusClaPer" />"><system:label show="text" label="tabBusClaPer" /></div><div class="contentTab"><div class="gridContainer" style="margin: 0px"><div class="fieldGroup"><div class="title"><system:label show="text" label="sbtPerAccQry" /></div><%@include file="../../generic/permissions.jsp" %></div></div></div></div></div><system:campaign inLogin="false" inSplash="false" location="horizontalDown" /></div></form></div><!-- MODALS --><%@include file="../../modals/permissions.jsp" %><%@include file="../../modals/columns.jsp" %><%@include file="../../modals/attributes.jsp" %><%@include file="../../modals/querys.jsp" %><%@include file="../../modals/busClassParams.jsp" %><%@include file="../../modals/images.jsp" %><%@include file="../../includes/footer.jsp" %></body></html>