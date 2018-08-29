<%@include file="../../includes/startInc.jsp" %><html><head><%@include file="../../includes/headInclude.jsp" %><link href="<system:util show="context" />/css/<system:util show="currentStyle" />/generalAdm.css" rel="stylesheet" type="text/css" /><script type="text/javascript" src="<system:util show="context" />/page/design/widgets/edit.js"></script><script type="text/javascript" src="<system:util show="context" />/page/includes/adminActionsEdition.js"></script><script type="text/javascript" src="<system:util show="context" />/page/includes/campaigns.js"></script><script type="text/javascript" src="<system:util show="context" />/page/includes/adminFav.js"></script><script type="text/javascript" src="<system:util show="context" />/page/includes/navButtons.js"></script><script type="text/javascript" src="<system:util show="context" />/page/design/widgets/tabGenData.js"></script><script type="text/javascript" src="<system:util show="context" />/page/design/widgets/tabHistoric.js"></script><script type="text/javascript" src="<system:util show="context" />/page/design/widgets/tabOthData.js"></script><script type="text/javascript" src="<system:util show="context" />/page/design/widgets/tabPerms.js"></script><script type="text/javascript" src="<system:util show="context" />/page/design/widgets/tabActions.js"></script><script type="text/javascript" src="<system:util show="context" />/page/design/widgets/tabSrcData.js"></script><script type="text/javascript" src="<system:util show="context" />/page/design/widgets/tabUpdate.js"></script><script type="text/javascript" src="<system:util show="context" />/page/modals/busClasses.js"></script><script type="text/javascript" src="<system:util show="context" />/page/modals/processes.js"></script><script type="text/javascript" src="<system:util show="context" />/page/modals/attributes.js"></script><script type="text/javascript" src="<system:util show="context" />/page/modals/pools.js"></script><script type="text/javascript" src="<system:util show="context" />/js/modalController.js"></script><script type="text/javascript">
		var DEFAULT_COLOR = '#3378CC'; //color por defecto de los color pickers
		var URL_REQUEST_AJAX = '/apia.design.WidgetAction.run';
		var isAllEnvs = "true";
		var isGlobal = "true";
		var LBL_ALL_ENVS = '<system:label show="text" label="lblTodAmb" forScript="true" />';
		var ADDITIONAL_INFO_IN_TABLE_DATA = false;
		var INSERT_MODE = "insert";
		var UPDATE_MODE = "update";
		
		var MSG_MUST_SEL_BUS_CLA_FIRST = '<system:label show="text" label="msgMustSelBusClaFirst" forScript="true" />';
		var MSG_MUST_SEL_QUERY_FIRST = '<system:label show="text" label="msgMustSelQueryFirst" forScript="true" />';
		
		var WIDGET_TYPE_KPI_ID = "<system:edit show="constant" from="com.dogma.vo.WidgetVo" field="WIDGET_TYPE_KPI_ID" />";
		var WIDGET_TYPE_CUBE_ID = "<system:edit show="constant" from="com.dogma.vo.WidgetVo" field="WIDGET_TYPE_CUBE_ID" />";
		var WIDGET_TYPE_QUERY_ID = "<system:edit show="constant" from="com.dogma.vo.WidgetVo" field="WIDGET_TYPE_QUERY_ID" />";
		var WIDGET_TYPE_CUSTOM_ID = "<system:edit show="constant" from="com.dogma.vo.WidgetVo" field="WIDGET_TYPE_CUSTOM_ID" />";
		
		var WIDGET_CBE_VIEW_CHART = "<system:edit show="constant" from="com.dogma.vo.WidgetVo" field="WIDGET_CBE_VIEW_CHART" />";
		var WIDGET_CBE_VIEW_TABLE = "<system:edit show="constant" from="com.dogma.vo.WidgetVo" field="WIDGET_CBE_VIEW_TABLE" />";
		
		var WIDGET_CUBE_SRC_IMAGE = "<system:edit show="constant" from="com.dogma.vo.WidgetVo" field="WIDGET_CUBE_SRC_IMAGE" />"; 
		var WIDGET_CUBE_TABLE_SRC_IMAGE = "<system:edit show="constant" from="com.dogma.vo.WidgetVo" field="WIDGET_CUBE_TABLE_SRC_IMAGE" />";
		var WIDGET_QUERY_CHART_SRC_IMAGE = "<system:edit show="constant" from="com.dogma.vo.WidgetVo" field="WIDGET_QUERY_SRC_IMAGE" />";	
		var WIDGET_QUERY_TABLE_SRC_IMAGE = "<system:edit show="constant" from="com.dogma.vo.WidgetVo" field="WIDGET_QUERY_TABLE_SRC_IMAGE" />";
		
		var WIDGET_QRY_VIEW_CHART = "<system:edit show="constant" from="com.dogma.vo.WidgetVo" field="WIDGET_QRY_VIEW_CHART" />";
		var WIDGET_QRY_VIEW_TABLE = "<system:edit show="constant" from="com.dogma.vo.WidgetVo" field="WIDGET_QRY_VIEW_TABLE" />";
		var WIDGET_QRY_VIEW_BOTH = "<system:edit show="constant" from="com.dogma.vo.WidgetVo" field="WIDGET_QRY_VIEW_BOTH" />";
		
		var WIDGET_SRC_TYPE_CUBE_VIEW_ID = "<system:edit show="constant" from="com.dogma.vo.WidgetVo" field="WIDGET_SRC_TYPE_CUBE_VIEW_ID" />";
		var WIDGET_SRC_TYPE_BUS_CLASS_ID = "<system:edit show="constant" from="com.dogma.vo.WidgetVo" field="WIDGET_SRC_TYPE_BUS_CLASS_ID" />";
		var WIDGET_SRC_TYPE_QUERY_ID = "<system:edit show="constant" from="com.dogma.vo.WidgetVo" field="WIDGET_SRC_TYPE_QUERY_ID" />";
		var WIDGET_SRC_TYPE_CUST_ID = "<system:edit show="constant" from="com.dogma.vo.WidgetVo" field="WIDGET_SRC_TYPE_CUST_ID" />";
		var WIDGET_SRC_TYPE_URL_ID = "<system:edit show="constant" from="com.dogma.vo.WidgetVo" field="WIDGET_SRC_TYPE_URL_ID" />";
		var WIDGET_SRC_TYPE_QUERY_SQL_ID = "<system:edit show="constant" from="com.dogma.vo.WidgetVo" field="WIDGET_SRC_TYPE_QUERY_SQL_ID" />";
	
		var WIDGET_SRC_TYPE_BUS_CLASS_NAME = "<system:edit show="constant" from="com.dogma.vo.WidgetVo" field="WIDGET_SRC_TYPE_BUS_CLASS_NAME" />";
		var WIDGET_SRC_TYPE_CUBE_VIEW_NAME = "<system:edit show="constant" from="com.dogma.vo.WidgetVo" field="WIDGET_SRC_TYPE_CUBE_VIEW_NAME" />";
		var WIDGET_SRC_TYPE_QUERY_NAME = "<system:edit show="constant" from="com.dogma.vo.WidgetVo" field="WIDGET_SRC_TYPE_QUERY_NAME" />";
		var WIDGET_SRC_TYPE_QUERY_SQL_NAME = "<system:edit show="constant" from="com.dogma.vo.WidgetVo" field="WIDGET_SRC_TYPE_QUERY_SQL_NAME" />";
		
		var WIDGET_REF_TIME_SEC = "<system:edit show="constant" from="com.dogma.vo.WidgetVo" field="WIDGET_REF_TIME_SEC" />";
		var WIDGET_REF_TIME_MIN = "<system:edit show="constant" from="com.dogma.vo.WidgetVo" field="WIDGET_REF_TIME_MIN" />";
		var WIDGET_REF_TIME_HOR = "<system:edit show="constant" from="com.dogma.vo.WidgetVo" field="WIDGET_REF_TIME_HOR" />";
		var refTimeSelected = "<system:edit show="value" from="theEdition" field="widRefType"/>";
		
		var PERIODICITY_EVERY_MINUTE = "<system:edit show="constant" from="com.dogma.vo.SchBusClaActivityVo" field="PERIODICITY_EVERY_MINUTE" />";
		var PERIODICITY_EVERY_QUARTER = "<system:edit show="constant" from="com.dogma.vo.SchBusClaActivityVo" field="PERIODICITY_EVERY_QUARTER" />";
		var PERIODICITY_EVERY_HALF_HOUR	= "<system:edit show="constant" from="com.dogma.vo.SchBusClaActivityVo" field="PERIODICITY_EVERY_HALF_HOUR" />";
		var PERIODICITY_EVERY_HOUR	= "<system:edit show="constant" from="com.dogma.vo.SchBusClaActivityVo" field="PERIODICITY_EVERY_HOUR" />";
		var nodeName = "<system:edit show="value" from="theEdition" field="executionNode"/>";
		
		var HTML_COD_EXAMPLE = "<!-------  Example Weather in Montevideo, Uruguay by Weather Channel ---------><script type='text/javascript' src='http://voap.weather.com/weather/oap/UYXX0006?template=EVNTH&par=3000000007&unit=1&key=twciweatherwidget'>";
		var LBL_DIR_URL = '<system:label show="text" label="lblDirUrl" forHtml="true" forScript="true" />';
		var LBL_ENT_COD_URL = '<system:label show="text" label="lblEntCodUrl" forHtml="true" forScript="true" />';
		var LBL_ENT_COD_HTML = '<system:label show="text" label="lblEntCodHtml" forHtml="true" forScript="true" />';
		var LBL_COD_HTML = '<system:label show="text" label="lblCodHtml" forHtml="true" forScript="true" />';
		var LBL_TST_SQL = '<system:label show="tooltip" label="btnTestQry" forHtml="true" forScript="true" />';
		var LBL_TST_HTML = '<system:label show="tooltip" label="lblTestHtml" forHtml="true" forScript="true" />';
		var LBL_TST_URL = '<system:label show="tooltip" label="lblTstUrl" forHtml="true" forScript="true" />';
		var LBL_DEL_SQL = '<system:label show="tooltip" label="lblDelSQL" forHtml="true" forScript="true" />';
		var LBL_DEL_HTML = '<system:label show="tooltip" label="lblDelHtml" forHtml="true" forScript="true" />';
		var LBL_DEL_URL = '<system:label show="tooltip" label="lblDelUrl" forHtml="true" forScript="true" />';
		var LBL_ADD = '<system:label show="text" label="btnAgr" forHtml="true" forScript="true" />';
		var VALID_HR = '<system:label show="text" label="lblValidHr" forScript="true" />';
		var LBL_RESULT = '<system:label show="tooltip" label="sbtRes" forHtml="true" forScript="true" />';
		var MSG_INS_VAL_POSITIVE = '<system:label show="text" label="msgInsValPositive" forHtml="true" forScript="true" />';
		var LBL_TITLE = '<system:label show="text" label="lblTit" forScript="true" />';
		
		var widType = "<system:edit show="value" from="theEdition" field="widType"/>";
		var widSrcType = "<system:edit show="value" from="theEdition" field="widSrcType"/>";
		var widParId = "<system:edit show="value" from="theEdition" field="widParId"/>";
		var histColNumber = "<system:edit show="value" from="theEdition" field="widHisChrtColor"/>";
		var metaColNumber = "<system:edit show="value" from="theEdition" field="widHisMetaColor"/>";
		var HIST_COL_DEFAULT = "#0044EB";
		var META_COL_DEFAULT = "#FF0000";
		var viewMeta = "<system:edit show="value" from="theEdition" field="widViewMeta"/>";
		var isMetaByYear = "<system:edit show="value" from="theEdition" field="metaByYear"/>";
		var isMetaByMonth = "<system:edit show="value" from="theEdition" field="metaByMonth"/>";
		var isMetaByDay = "<system:edit show="value" from="theEdition" field="metaByDay"/>";
		
		var MSG_MUST_COMP_MAX_ZNES = '<system:label show="text" label="msgWidMustCompMaxZones" forHtml="true" forScript="true" />';
		var MSG_CANT_ADD_NEW_ZNE = '<system:label show="text" label="msgWidCantAddNewZone" forHtml="true" forScript="true" />';
		var MSG_NO_ZNE_DEFINED = '<system:label show="text" label="msgNoZneDefined" forHtml="true" forScript="true" />';
		var MSG_KPI_SCALE_NO_ZONES = '<system:label show="text" label="msgKPIScaleNoZones" forHtml="true" forScript="true" />';
		var MSG_KPI_THERM_THREE_ZONES = '<system:label show="text" label="msgKPIThermThreeZones" forHtml="true" forScript="true" />';
		var MSG_KPI_THERM_MOR_THAN_THREE_ZONES = '<system:label show="text" label="msgKPIThermMorThanThreeZones" forHtml="true" forScript="true" />';
		var MSG_KPI_MAX_ZONES_REACHED = '<system:label show="text" label="msgKPIMaxZonesReached" forHtml="true" forScript="true" />';
		var MSG_KPI_THERM_NEED_THREE_ZONES = '<system:label show="text" label="msgKPIThermNeedThreeZones" forHtml="true" forScript="true" />';
		var MSG_WID_ACT_NO_ALWAYS = '<system:label show="text" label="msgWidActNoAlways" forHtml="true" forScript="true" />';
		var MSG_WID_ACT_TIME = '<system:label show="text" label="msgWrngRefTime" forHtml="true" forScript="true" />';
		
		var WID_KPI_ACTION_BUS_CLASS_EXECUTION = "<system:edit show="constant" from="com.dogma.vo.WidKpiZoneVo" field="WID_KPI_ACTION_BUS_CLASS_EXECUTION" />";
		var WID_KPI_ACTION_START_PROCESS = "<system:edit show="constant" from="com.dogma.vo.WidKpiZoneVo" field="WID_KPI_ACTION_START_PROCESS" />";
		var WID_KPI_ACTION_SEND_EMAIL = "<system:edit show="constant" from="com.dogma.vo.WidKpiZoneVo" field="WID_KPI_ACTION_SEND_EMAIL" />";
		var WID_KPI_ACTION_SEND_NOTIFICATION = "<system:edit show="constant" from="com.dogma.vo.WidKpiZoneVo" field="WID_KPI_ACTION_SEND_NOTIFICATION" />";
		var WID_KPI_ACTION_SEND_CHAT_MSG = "<system:edit show="constant" from="com.dogma.vo.WidKpiZoneVo" field="WID_KPI_ACTION_SEND_CHAT_MSG" />";
		
		var WID_KPI_ACTION_PROCESS_BUS_CLA_ID = "<system:edit show="constant" from="com.dogma.vo.WidKpiZoneVo" field="WID_KPI_ACTION_PROCESS_BUS_CLA_ID" />";
		
		var LBL_EXE_BUS_CLASS = '<system:label show="text" label="lblExeBusClass" forHtml="true" forScript="true" />';
		var LBL_START_PROCESS = '<system:label show="text" label="lblStartProcess" forHtml="true" forScript="true" />';
		var LBL_SEND_EMAIL = '<system:label show="text" label="lblSendEmail" forHtml="true" forScript="true" />';
		var LBL_SEND_NOTIFICATION = '<system:label show="text" label="lblSendNotification" forHtml="true" forScript="true" />';
		var LBL_SEL_BUS_CLASS = '<system:label show="text" label="lblSelBusClass" forHtml="true" forScript="true" />';
		var LBL_SEL_BUS_CLASS_PARAMS = '<system:label show="text" label="lblSelBusClaParameters" forHtml="true" forScript="true" />';
		var LBL_TIMES = " " + "<system:label show="text" label="lblTimes" forHtml="true" forScript="true" />" + " ";
		var LBL_SEL_PROCESS = '<system:label show="text" label="lblSelProcess" forHtml="true" forScript="true" />';
		var LBL_SEL_ATT_WID_VALUE = '<system:label show="text" label="lblSelAttWidValue" forHtml="true" forScript="true" />';
		var LBL_SEL_ATT_WID_NAME =  "<system:label show="text" label="lblSelAttWidName" forHtml="true" forScript="true" />";
		var LBL_SEL_ATT_WID_ZNE_NAME  = '<system:label show="text" label="lblSelAttWidZneName" forHtml="true" forScript="true" />';
		var LBL_SUBJECT = '<system:label show="text" label="lblSelSubject" forHtml="true" forScript="true" />';
		var LBL_MESSAGE = '<system:label show="text" label="lblSelMessage" forHtml="true" forScript="true" />';
		var LBL_MESSAGE_NOT = '<system:label show="text" label="lblSelNotMessage" forHtml="true" forScript="true" />';
		var LBL_POOLS_TOOLTIP = '<system:label show="text" label="lblSelPoolNot" forHtml="true" forScript="true" />';
		var WID_KPI_BUS_CLA_SEND_EMAIL_ID = "<system:edit show="constant" from="com.dogma.vo.WidKpiZoneVo" field="WID_KPI_ACTION_SEND_EMAIL_BUS_CLA_ID" />";
		var WID_KPI_BUS_CLA_SEND_NOT_ID = "<system:edit show="constant" from="com.dogma.vo.WidKpiZoneVo" field="WID_KPI_ACTION_SEND_NOTIFICATION_BUS_CLA_ID" />";
		
		var LBL_NO_TRANSP = '<system:label show="text" label="lblNoTransp" forHtml="true" forScript="true" />';
		var LBL_LOW_TRANSP = '<system:label show="text" label="lblLowTransp" forHtml="true" forScript="true" />';
		var LBL_MED_TRANSP = '<system:label show="text" label="lblMediumTransp" forHtml="true" forScript="true" />';
		var LBL_HIGH_TRANSP = '<system:label show="text" label="lblHighTransp" forHtml="true" forScript="true" />';
		var LBL_TOTAL_TRANSP = '<system:label show="text" label="lblTotalTransp" forHtml="true" forScript="true" />';
		
		var othInfoLastUpdate = "<system:edit show="value" from="theBean" field="othInfoLastUpdateIsChecked"/>";
		var othInfoDataSource = "<system:edit show="value" from="theBean" field="othInfoDataSourceIsChecked"/>";
		
		var btnParsRed = "<system:util show="context" />/css/<system:util show="currentStyle" />/img/btn_mod_red.gif";
		var btnParsBlue = "<system:util show="context" />/css/<system:util show="currentStyle" />/img/btn_mod.gif";
		var PALETTE = "<system:util show="context" />/css/<system:util show="currentStyle" />/img/palette.gif";
		
		var WIDGET_KPI_TYPE_GAUGE_VELOCIMETER_ID = "<system:edit show="constant" from="com.dogma.vo.WidgetVo" field="WIDGET_KPI_TYPE_GAUGE_VELOCIMETER_ID" />";
		var WIDGET_KPI_TYPE_GAUGE_VELOCIMETER_NAME = "<system:edit show="constant" from="com.dogma.vo.WidgetVo" field="WIDGET_KPI_TYPE_GAUGE_VELOCIMETER_NAME" />";

		var WIDGET_KPI_TYPE_GAUGE_OXFORD_ID = "<system:edit show="constant" from="com.dogma.vo.WidgetVo" field="WIDGET_KPI_TYPE_GAUGE_OXFORD_ID" />";
		var WIDGET_KPI_TYPE_GAUGE_OXFORD_NAME = "<system:edit show="constant" from="com.dogma.vo.WidgetVo" field="WIDGET_KPI_TYPE_GAUGE_OXFORD_NAME" />";
		
		var WIDGET_KPI_TYPE_COUNTER_ID = "<system:edit show="constant" from="com.dogma.vo.WidgetVo" field="WIDGET_KPI_TYPE_COUNTER_ID" />";
		var WIDGET_KPI_TYPE_COUNTER_NAME = "<system:edit show="constant" from="com.dogma.vo.WidgetVo" field="WIDGET_KPI_TYPE_COUNTER_NAME" />";
		
		var WIDGET_KPI_TYPE_TRAFFIC_LIGHT_ID = "<system:edit show="constant" from="com.dogma.vo.WidgetVo" field="WIDGET_KPI_TYPE_TRAFFIC_LIGHT_ID" />";
		var WIDGET_KPI_TYPE_TRAFFIC_LIGHT_NAME = "<system:edit show="constant" from="com.dogma.vo.WidgetVo" field="WIDGET_KPI_TYPE_TRAFFIC_LIGHT_NAME" />";
		
		var WIDGET_KPI_TYPE_THERMOMETER_ID = "<system:edit show="constant" from="com.dogma.vo.WidgetVo" field="WIDGET_KPI_TYPE_THERMOMETER_ID" />";
		var WIDGET_KPI_TYPE_THERMOMETER_NAME = "<system:edit show="constant" from="com.dogma.vo.WidgetVo" field="WIDGET_KPI_TYPE_THERMOMETER_NAME" />";
		
		var WIDGET_KPI_TYPE_SCALE_ID = "<system:edit show="constant" from="com.dogma.vo.WidgetVo" field="WIDGET_KPI_TYPE_SCALE_ID" />";
		var WIDGET_KPI_TYPE_SCALE_NAME = "<system:edit show="constant" from="com.dogma.vo.WidgetVo" field="WIDGET_KPI_TYPE_SCALE_NAME" />";
		
		var WIDGET_PRP_BTN_COMMENTS = "<system:edit show="constant" from="com.dogma.vo.WidgetVo" field="WIDGET_PRP_BTN_COMMENTS" />";
		var WIDGET_PRP_BTN_CHILDS = "<system:edit show="constant" from="com.dogma.vo.WidgetVo" field="WIDGET_PRP_BTN_CHILDS" />";
		var WIDGET_PRP_BTN_HIST = "<system:edit show="constant" from="com.dogma.vo.WidgetVo" field="WIDGET_PRP_BTN_HIST" />";
		var WIDGET_PRP_BTN_INFO = "<system:edit show="constant" from="com.dogma.vo.WidgetVo" field="WIDGET_PRP_BTN_INFO" />";
		var WIDGET_PRP_BTN_UPDATE = "<system:edit show="constant" from="com.dogma.vo.WidgetVo" field="WIDGET_PRP_BTN_UPDATE" />";
		var WIDGET_PRP_BTN_OPEN_QRY = "<system:edit show="constant" from="com.dogma.vo.WidgetVo" field="WIDGET_PRP_BTN_OPEN_QRY" />";
		var WIDGET_PRP_BTN_OPEN_CBE = "<system:edit show="constant" from="com.dogma.vo.WidgetVo" field="WIDGET_PRP_BTN_OPEN_CBE" />";
		
		var WIDGET_PRP_CUSTOMIZED = "<system:edit show="constant" from="com.dogma.vo.WidgetVo" field="WIDGET_PRP_CUSTOMIZED" />";
		var WIDGET_PRP_VAL_FONT_SIZE = "<system:edit show="constant" from="com.dogma.vo.WidgetVo" field="WIDGET_PRP_VAL_FONT_SIZE" />";
		var WIDGET_PRP_SCALE_FONT_SIZE = "<system:edit show="constant" from="com.dogma.vo.WidgetVo" field="WIDGET_PRP_SCALE_FONT_SIZE" />";
		var WIDGET_PRP_BACKGROUND_COLOR = "<system:edit show="constant" from="com.dogma.vo.WidgetVo" field="WIDGET_PRP_BACKGROUND_COLOR" />";
		var WIDGET_PRP_BACKGROUND_COLOR_HEX = "<system:edit show="constant" from="com.dogma.vo.WidgetVo" field="WIDGET_PRP_BACKGROUND_COLOR_HEX" />";
		var WIDGET_PRP_POINTER_COLOR = "<system:edit show="constant" from="com.dogma.vo.WidgetVo" field="WIDGET_PRP_POINTER_COLOR" />";
		var WIDGET_PRP_POINTER_COLOR_HEX = "<system:edit show="constant" from="com.dogma.vo.WidgetVo" field="WIDGET_PRP_POINTER_COLOR_HEX" />";
		var WIDGET_PRP_VAL_COLOR = "<system:edit show="constant" from="com.dogma.vo.WidgetVo" field="WIDGET_PRP_VAL_COLOR" />";
		var WIDGET_PRP_VAL_COLOR_HEX = "<system:edit show="constant" from="com.dogma.vo.WidgetVo" field="WIDGET_PRP_VAL_COLOR_HEX" />";
		var WIDGET_PRP_VAL_TYPE = "<system:edit show="constant" from="com.dogma.vo.WidgetVo" field="WIDGET_PRP_VAL_TYPE" />";
		var WIDGET_PRP_VAL_DECIMALS = "<system:edit show="constant" from="com.dogma.vo.WidgetVo" field="WIDGET_PRP_VAL_DECIMALS" />";
		var WIDGET_PRP_BORDER = "<system:edit show="constant" from="com.dogma.vo.WidgetVo" field="WIDGET_PRP_BORDER" />";
		var WIDGET_PRP_QRY_VIEW_TYPE = "<system:edit show="constant" from="com.dogma.vo.WidgetVo" field="WIDGET_PRP_QRY_VIEW_TYPE" />";
		var WIDGET_PRP_QRY_CHART_SELECTED = "<system:edit show="constant" from="com.dogma.vo.WidgetVo" field="WIDGET_PRP_QRY_CHART_ID" />";
		
		var WIDGET_PROP_VIEW_NAME = "<system:edit show="constant" from="com.dogma.vo.WidgetVo" field="WIDGET_PROP_VIEW_NAME" />";
		var WIDGET_PROP_VIEW_DESC = "<system:edit show="constant" from="com.dogma.vo.WidgetVo" field="WIDGET_PROP_VIEW_DESC" />";
		var WIDGET_PROP_VIEW_BORDER = "<system:edit show="constant" from="com.dogma.vo.WidgetVo" field="WIDGET_PROP_VIEW_BORDER" />";
		var WIDGET_PROP_VIEW_TIMER = "<system:edit show="constant" from="com.dogma.vo.WidgetVo" field="WIDGET_PROP_VIEW_TIMER" />";
		var WIDGET_PROP_VIEW_BTN_CHILDS = "<system:edit show="constant" from="com.dogma.vo.WidgetVo" field="WIDGET_PROP_VIEW_BTN_CHILDS" />";
		var WIDGET_PROP_VIEW_BTN_HISTORY = "<system:edit show="constant" from="com.dogma.vo.WidgetVo" field="WIDGET_PROP_VIEW_BTN_HISTORY" />";
		var WIDGET_PROP_VIEW_BTN_REFRESH = "<system:edit show="constant" from="com.dogma.vo.WidgetVo" field="WIDGET_PROP_VIEW_BTN_REFRESH" />";
		var WIDGET_PROP_VIEW_BTN_COMMENTS = "<system:edit show="constant" from="com.dogma.vo.WidgetVo" field="WIDGET_PROP_VIEW_BTN_COMMENTS" />";
		var WIDGET_PROP_VIEW_BTN_INFO = "<system:edit show="constant" from="com.dogma.vo.WidgetVo" field="WIDGET_PROP_VIEW_BTN_INFO" />";
		var WIDGET_PROP_ORDER = "<system:edit show="constant" from="com.dogma.vo.WidgetVo" field="WIDGET_PROP_ORDER" />";
		var WIDGET_PROP_WIDTH = "<system:edit show="constant" from="com.dogma.vo.WidgetVo" field="WIDGET_PROP_WIDTH" />";
		var WIDGET_PROP_HEIGHT = "<system:edit show="constant" from="com.dogma.vo.WidgetVo" field="WIDGET_PROP_HEIGHT" />";
		var WIDGET_PROP_X = "<system:edit show="constant" from="com.dogma.vo.WidgetVo" field="WIDGET_PROP_X" />";
		var WIDGET_PROP_Y = "<system:edit show="constant" from="com.dogma.vo.WidgetVo" field="WIDGET_PROP_Y" />";
		var WIDGET_CUBE_VIEW_MODE = "<system:edit show="constant" from="com.dogma.vo.WidgetVo" field="WIDGET_CUBE_VIEW_MODE" />";
		
		var WIDGET_PRP_NAME = "<system:edit show="constant" from="com.dogma.vo.WidgetVo" field="WIDGET_PRP_NAME" />";
		var WIDGET_PRP_VALUE = "<system:edit show="constant" from="com.dogma.vo.WidgetVo" field="WIDGET_PRP_VALUE" />";
		
		//COLORES
		var WHITE_RGB = 'rgb(255,255,255)';
		var WHITE_HEX = '#FFFFFF';
		
		var BLUE_RGB = 'rgb(64,148,171)';
		var BLUE_HEX = '#4094AB';
		
		var GRAY_RGB = 'rgb(102,102,102)';
		var GRAY_HEX = '#666666';
		
		var RED_RGB = 'rgb(176,72,70)';
		var RED_HEX = '#B04846';
		
		var BLACK_RGB = 'rgb(0,0,0)';
		var BLACK_HEX = '#000000';
		
		var ORANGE_RGB = 'rgb(255,158,2)';
		var ORANGE_HEX = '#FF9E02';
		
		var COUNTER_DEFAULT_VALUE_FONT_SIZE = "<system:edit show="constant" from="biz.statum.apia.utils.charts.indicatorcharts.countercharts.CounterChart" field="COUNTER_VALUE_FONT_SIZE" />";
		var TRAFFIC_LIGHT_DEFAULT_VALUE_FONT_SIZE = "<system:edit show="constant" from="biz.statum.apia.utils.charts.indicatorcharts.countercharts.CounterChart" field="COUNTER_TRAFFICLIGHT1_VALUE_FONT_SIZE" />";
		var GAUGE_VELOCIMETER_DEFAULT_VALUE_FONT_SIZE = "<system:edit show="constant" from="biz.statum.apia.utils.charts.indicatorcharts.dialcharts.DialChartVelocimeter" field="DIAL_CHART_VELOCIMETER_VALUE_FONT_SIZE" />";
		var GAUGE_VELOCIMETER_DEFAULT_SCALE_FONT_SIZE = "<system:edit show="constant" from="biz.statum.apia.utils.charts.indicatorcharts.dialcharts.DialChartVelocimeter" field="DIAL_CHART_VELOCIMETER_SCALE_TICKS_FONT_SIZE" />";
		var GAUGE_OXFORD_DEFAULT_VALUE_FONT_SIZE = "<system:edit show="constant" from="biz.statum.apia.utils.charts.indicatorcharts.dialcharts.DialChartOxford" field="DIAL_CHART_OXFORD_VALUE_FONT_SIZE" />";
		var THERMOMETER_DEFAULT_VALUE_FONT_SIZE = "<system:edit show="constant" from="biz.statum.apia.utils.charts.indicatorcharts.thermometercharts.ThermometerChart" field="THERMOMETER_VALUE_FONT_SIZE" />";
		var SCALE_DEFAULT_VALUE_FONT_SIZE = "<system:edit show="constant" from="biz.statum.apia.utils.charts.indicatorcharts.dialcharts.DialChartScale" field="DIAL_CHART_SCALE_VALUE_FONT_SIZE" />";
		var SCALE_DEFAULT_SCALE_FONT_SIZE = "<system:edit show="constant" from="biz.statum.apia.utils.charts.indicatorcharts.dialcharts.DialChartScale" field="DIAL_CHART_SCALE_TICKS_FONT_SIZE" />";
	</script></head><body><div id="exec-blocker"></div><div class="header"></div><div class="body" id="bodyDiv"><form id="frmData"><div class="optionsContainer"><div class="fncPanel info"><system:campaign inLogin="false" inSplash="false" location="verticalUp" /><div class="title"><system:label show="tooltip" label="mnuWidgets" /><%@include file="../../includes/adminFav.jsp" %></div><div class="content divFncDescription"><div class="fncDescriptionImage" src="<system:edit show="value" from="theBean" field="fncImage"/>"></div><div id="fncDescriptionText"><system:label show="text" label="dscFncAdmWid" /></div><div class="clear"></div></div></div><%@include file="../../includes/adminActionsEdition.jsp" %><div class="fncPanel options" id="panelOptions" style="display:none"><div class="title"><system:label show="tooltip" label="mnuOpc" /></div><div class="content"><div id="btnTest" class="button" title="<system:label show="tooltip" label="btnTestQry" />"><system:label show="text" label="btnTestQry" /></div><div id="btnDelete" class="button" title="<system:label show="tooltip" label="lblDelHtml" />"><system:label show="text" label="lblDelHtml" /></div></div></div><system:campaign inLogin="false" inSplash="false" location="verticalDown" /></div><div class="dataContainer"><div class='tabComponent' id="tabComponent"><div class="aTabHeader"><system:campaign inLogin="false" inSplash="false" location="horizontalUp" /></div><%@include file="tabGenData.jsp" %><!-- TAB DE DATOS GENERALES --><%@include file="tabSrcData.jsp" %><!-- TAB DE FUENTE DE DATOS --><%@include file="tabActions.jsp" %><!-- TAB DE ZONAS --><%@include file="tabUpdate.jsp" %><!-- TAB DE ACTUALIZACION --><%@include file="tabHistoric.jsp" %><!-- TAB DE HISTORICO --><%@include file="tabOthData.jsp" %><!-- TAB DE INFO ADICIONAL --><%@include file="tabPerms.jsp" %><!-- TAB DE PERMISOS --></div><system:campaign inLogin="false" inSplash="false" location="horizontalDown" /></div></form></div><!-- MODALS --><%@include file="../../modals/busClasses.jsp" %><%@include file="../../modals/processes.jsp" %><%@include file="../../modals/attributes.jsp" %><%@include file="../../modals/pools.jsp" %><%@include file="../../includes/footer.jsp" %></body></html>

