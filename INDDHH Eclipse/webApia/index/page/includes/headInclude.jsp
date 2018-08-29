<%@page import="com.dogma.Configuration"%><%@page import="biz.statum.apia.web.bean.BasicBeanStatic"%><%@page import="java.util.ArrayList"%><%@page import="java.util.Collection"%><%@page import="com.dogma.Parameters"%><%@page import="com.dogma.EnvParameters"%><%@page import="com.st.util.StringUtil"%><title></title><meta http-equiv="Content-Type" content="text/html; charset=<%=com.dogma.Parameters.APP_ENCODING%>"><!--meta http-equiv="X-UA-Compatible" content="IE=7"--><%if(Parameters.CUSTOM_JS.length()>0){
	java.io.File f = new java.io.File(Parameters.APP_PATH + Parameters.CUSTOM_JS);
	if(f.exists()){%><script language="javascript" src="<%=Parameters.ROOT_PATH + Parameters.CUSTOM_JS%>"></script><%}else{
	//	Log.debug("The javascript file setted in the parameter CUSTOM JAVASCRIPT with value: " + Parameters.CUSTOM_JS + " was not found");
	}
}

Integer envId = null;
com.dogma.UserData uData = BasicBeanStatic.getUserDataStatic(request);
if (uData != null) {
	envId = uData.getEnvironmentId();
} else {
	envId = new Integer(1);
}
%><link href="<system:util show="context" />/css/<system:util show="currentStyle" />/spinner.css" rel="stylesheet" type="text/css"><link href="<system:util show="context" />/css/<system:util show="currentStyle" />/messages.css" rel="stylesheet" type="text/css"><link href="<system:util show="context" />/css/<system:util show="currentStyle" />/modal.css" rel="stylesheet" type="text/css"><link href="<system:util show="context" />/css/<system:util show="currentStyle" />/tabs.css" rel="stylesheet" type="text/css"><script type="text/javascript" src="<system:util show="context" />/js/modernizr.custom.js"></script><!-- MOOTOOLS --><script type="text/javascript" src="<system:util show="context" />/js/mootools-core-1.4.5-full-compat.js"></script><script type="text/javascript" src="<system:util show="context" />/js/mootools-more-1.4.0.1-compat.js"></script><!-- MOBILE --><script type="text/javascript" src="<system:util show="context" />/js/mobile/swipe.js"></script><!-- FORMCHECK PARA VALIDAR FORMS--><%
	com.dogma.UserData uDataAux = biz.statum.apia.web.bean.BasicBeanStatic.getUserDataStatic(request);
	Integer langIdAux = 3;
	if (uDataAux!=null) langIdAux = uDataAux.getLangId();
		
	if(langIdAux == 1) {%><script type="text/javascript" src="<system:util show="context" />/js/formcheck/lang/es.js"></script><%} else if(langIdAux == 2) {%><script type="text/javascript" src="<system:util show="context" />/js/formcheck/lang/pt.js"></script><%} else {%><script type="text/javascript" src="<system:util show="context" />/js/formcheck/lang/en.js"></script><%}%><script type="text/javascript" src="<system:util show="context" />/js/formcheck/formcheck.js"></script><!-- CONTROLADOR DE MODALS --><script type="text/javascript" src="<system:util show="context" />/js/modalController.js"></script><script type="text/javascript" src="<system:util show="context" />/js/scroller.js"></script><script type="text/javascript" src="<system:util show="context" />/js/tabs.js"></script><script type="text/javascript" src="<system:util show="context" />/js/modal.js"></script><script type="text/javascript" src="<system:util show="context" />/js/generics.js"></script><script type="text/javascript" src="<system:util show="context" />/js/numeric.js"></script><script type="text/javascript" src="<system:util show="context" />/js/tabs.js"></script><link rel="stylesheet" href="<system:util show="context" />/css/<system:util show="currentStyle" />/tabs.css" type="text/css" media="screen"><link rel="stylesheet" href="<system:util show="context" />/js/formcheck/theme/classic/formcheck.css" type="text/css" media="screen"><script type="text/javascript" src="<system:util show="context" />/js/datepicker/datepicker.js"></script><link rel="stylesheet" href="<system:util show="context" />/css/<system:util show="currentStyle" />/datepicker/datepicker.css" type="text/css" media="screen"><script type="text/javascript" src="<system:util show="context" />/js/tooltips/js/sexy-tooltips.v1.2.mootools.js"></script><link rel="stylesheet" href="<system:util show="context" />/js/tooltips/js/sexy-tooltips/blue.css" type="text/css" media="all" id="theme"><link rel="shortcut icon" href="<system:util show="context" />/css/<system:util show="currentStyle" />/favicon.ico"><script type="text/javascript" src="<system:util show="context" />/js/colorpicker/mooRainbow.js"></script><link rel="stylesheet" href="<system:util show="context" />/js/colorpicker/mooRainbow.css" type="text/css" media="all"><script type="text/javascript" src="<system:util show="context" />/page/includes/campaigns.js"></script><script type="text/javascript" src="<system:util show="context" />/page/externalAccess/postmessage.js"></script><script type="text/javascript">
		var CURRENT_USER_LOGIN 		= "<system:util show="currentLogin" />";
		var CURRENT_ENVIRONMENT		= "<%=envId%>";
		var	sp;
		var CONTEXT					= "<system:util show="context" />";
		var STYLE					= "<system:util show="currentStyle" />";
		var TAB_ID					= "<system:util show="tabId"  />";
		var TAB_ID_REQUEST			= "<system:util show="tabIdRequest"  />";
		var WAIT_A_SECOND			= '<system:label show="text" label="lblEspUnMom" forHtml="true" forScript="true" />';
		var GNR_TIT_WARNING 		= '<system:label show="text" label="titMsgWarning" forHtml="true" forScript="true" />';
		var GNR_CHK_ONLY_ONE 		= '<system:label show="text" label="msgDebSelSolUno" forHtml="true" forScript="true" />';
		var GNR_CHK_AT_LEAST_ONE 	= '<system:label show="text" label="msgDebSelUno" forHtml="true" forScript="true" />';
		var GNR_MORE_RECORDS		= '<system:label show="text" label="lblNoRet" forHtml="true" forScript="true" />';
		var GNR_TOT_RECORDS			= '<system:label show="text" label="lblTotReg" forHtml="true" forScript="true" />';
		var GNR_TOT_RECORDS_REACHED	= '<system:label show="text" label="msgTotRegReached" forHtml="true" forScript="true" />';
		
		var GNR_NAV_FIRST			= '<system:label show="text" label="btnNavFirst" forHtml="true" forScript="true" />';
		var GNR_NAV_PREV			= '<system:label show="text" label="btnNavPrev" forHtml="true" forScript="true" />';
		var GNR_NAV_NEXT			= '<system:label show="text" label="btnNavNext" forHtml="true" forScript="true" />';
		var GNR_NAV_LAST			= '<system:label show="text" label="btnNavLast" forHtml="true" forScript="true" />';
		var GNR_NAV_REFRESH			= '<system:label show="text" label="btnRef" forHtml="true" forScript="true" />';
		 
		
		var GNR_NAV_ADM_CEATE		= '<system:label show="text" label="btnCre" forHtml="true" forScript="true" />';
		var GNR_NAV_ADM_UPDATE		= '<system:label show="text" label="btnMod" forHtml="true" forScript="true" />';
		var GNR_NAV_ADM_CLONE		= '<system:label show="text" label="btnClo" forHtml="true" forScript="true" />';
		var GNR_NAV_ADM_DELETE		= '<system:label show="text" label="btnEli" forHtml="true" forScript="true" />';
		var GNR_NAV_ADM_DEPENDENCIES= '<system:label show="text" label="btnDep" forHtml="true" forScript="true" />';
		var GNR_NAV_ADM_CLOSE		= '<system:label show="text" label="btnClose" forHtml="true" forScript="true" />';
		
		var BTN_CONFIRM				= '<system:label show="text" label="btnCon" forHtml="true" forScript="true"/>';
		var BTN_CANCEL				= '<system:label show="text" label="btnCan" forHtml="true" forScript="true"/>';
		
		var BTN_CLOSE				= '<system:label show="text" label="btnCer" forHtml="true" forScript="true"/>';
		
		var GRID_BTN_UP				= '<system:label show="text" label="btnUp" forHtml="true" forScript="true"/>';
		var GRID_BTN_DOWN			= '<system:label show="text" label="btnDown" forHtml="true" forScript="true"/>';
		var GRID_BTN_ADD			= '<system:label show="text" label="btnAgr" forHtml="true" forScript="true"/>';
		var GRID_BTN_DELETE			= '<system:label show="text" label="btnEli" forHtml="true" forScript="true"/>';
		var GRID_MSG_SEL_ROW		= '<system:label show="text" label="msgMustSelOneRowAtLeast" forHtml="true" forScript="true"/>';
		
		var GNR_INVALID_NAME 		= '<system:label show="text" label="msgNomInv" forHtml="true" forScript="true" />';
		
		var MSG_FEC_FIN_MAY_FEC_INI	= '<system:label show="text" label="msgFecFinMayFecIni" forHtml="true" forScript="true"/>';
		var MSG_FEC_INI_MEN_TODAY	= '<system:label show="text" label="msgDesAntHoy" forHtml="true" forScript="true"/>';
		var MSG_FEC_FIN_MEN_TODAY	= '<system:label show="text" label="msgHasAntHoy" forHtml="true" forScript="true"/>';
		
		var GNR_ORDER_BY			= "Ordenar por:";
		var GNR_TITILE_MESSAGES		= "Messages";
		var GNR_TITILE_EXCEPTIONS	= "Exceptions";
		
		var CONFIRM_ELEMENT_DELETE	= '<system:label show="text" label="lblDelSel" forHtml="true" forScript="true"/>';
		var CONFIRM_ELEMENT_INIT	= '<system:label show="text" label="msgIniRec" forHtml="true" forScript="true"/>';
		var CONFIRM_FNC_DELETE		= '<system:label show="text" label="msgDelFol" forHtml="true" forScript="true"/>';
		
		var MSG_ELE_ONLY_READ		= '<system:label show="text" label="msgEleOnlyRead" forHtml="true" forScript="true"/>';
		var MSG_ELE_CANT_DELETE		= '<system:label show="text" label="msgEleCantDelete" forHtml="true" forScript="true"/>';
		var MSG_ELE_CANT_CLONE		= '<system:label show="text" label="msgEleCantClone" forHtml="true" forScript="true"/>';
		
		var COMPLETE_OK				= '<system:label show="text" label="msgOpOk" forHtml="true" forScript="true"/>';
		
		var DOWNLOADING				= '<system:label show="text" label="lblDownloadingFile" forHtml="true" forScript="true"/>';
		
		var BTN_MARK_FRM_TO_SIGN	= '<system:label show="text" label="btnMarkFrmToSign" forHtml="true" forScript="true"/>';
		var BTN_VERIFY_FRM_SIGN		= '<system:label show="text" label="btnVerifyFrmSign" forHtml="true" forScript="true"/>';
		
		var MSG_PERMISSIONS_ERROR 	= '<system:label show="text" label="msgPermError" forHtml="true" forScript="true" />';
		var MSG_USE_PROY_PERMS 		= '<system:label show="text" label="msgUseProyPerms" forHtml="true" forScript="true" />';
		var MSG_PERM_WILL_BE_LOST	= '<system:label show="text" label="msgPermReadModWillBeLost" forHtml="true" forScript="true" />';
		
		var MSG_DOC_LOCKED_BY_USR	= '<system:label show="text" label="msgDocLocOthUsr" forHtml="true" forScript="true" />';
		var MSG_DOC_MUST_BE_LOCKED	= '<system:label show="text" label="msgDocMusBeLocForUpd" forHtml="true" forScript="true" />';
		
		var MSG_LOADING				= '<system:label show="text" label="msgLoading" forHtml="true" forScript="true" />';
		
		var BTN_PRINT				= '<system:label show="text" label="btnStaPri" forHtml="true" forScript="true" />';			
		
		var MSG_INVALID_REG_EXP		= '<system:label show="text" label="msgExpRegFal" forHtml="true" forScript="true"/>';
		var ERR_UNEXPECTED			= '<system:label show="text" label="errUnexpected" forHtml="true" forScript="true"/>';
		var ERR_NOTHING_TO_LOAD		= '<system:label show="text" label="errNothingToLoad" forHtml="true" forScript="true"/>';
		var ERR_OPEN_URL			= '<system:label show="text" label="errOpenUrl" forHtml="true" forScript="true"/>';
		
		//var MSIE = window.navigator.appVersion.indexOf("MSIE")>=0;
		var MSIE	= window.navigator.userAgent.indexOf("MSIE") >= 0;
		var OPERA	= window.navigator.userAgent.indexOf("Opera") >= 0;
		var FIREFOX	= window.navigator.userAgent.indexOf("Firefox") >= 0;
		var CHROME	= window.navigator.userAgent.indexOf("Chrome") >= 0;
		var SAFARI	= window.navigator.userAgent.indexOf("Safari") >= 0 && !CHROME;
		
		var ADMIN_SPINNER = null;
		
		var GNR_NUMERIC				= '<system:label show="text" label="msgMustBeNumTOK" forHtml="true" forScript="true"/>';
		
		var LBL_CAN_UPDATE			= '<system:label show="text" label="lblCanUpdate" forHtml="true" forScript="true"/>';
		
		<%
		String env_date_format = EnvParameters.getEnvParameter(envId, EnvParameters.FMT_DATE);
		String date_format = "";
		if(env_date_format.charAt(0) == 'y') {
			date_format += "Y/";
			if(env_date_format.charAt(5) == 'M')
				date_format += "m/d";
			else
				date_format += "d/m";
		} else if (env_date_format.charAt(0) == 'd') {
			date_format += "d/";
			if(env_date_format.charAt(3) == 'M')
				date_format += "m/Y";
			else
				date_format += "Y/m";
		} else {
			date_format += "m/";
			if(env_date_format.charAt(3) == 'd')
				date_format += "d/Y";
			else
				date_format += "Y/d";
		}
		%>
		
		var DATE_FORMAT = '<%=date_format%>';
		var HOUR_SEPARATOR = '<%=Parameters.TIME_SEPARATOR%>';
		if	(HOUR_SEPARATOR == null || HOUR_SEPARATOR.length != 1){ HOUR_SEPARATOR = ":"; }
		
		var charThousSeparator	= '<%=StringUtil.escapeScriptStr(EnvParameters.getEnvParameter(envId, EnvParameters.FMT_THOUS_SEP))%>';
		var charDecimalSeparator = '<%=StringUtil.escapeScriptStr(EnvParameters.getEnvParameter(envId,EnvParameters.FMT_DECIMAL_SEP))%>';
		var addThousandSeparator = <%="true".equals(EnvParameters.getEnvParameter(envId,EnvParameters.FMT_SEPARATE_THOU))%>;
		var amountDecimalSeparator = '<%=StringUtil.escapeScriptStr(EnvParameters.getEnvParameter(envId,EnvParameters.FMT_DECIMALS))%>';
		var amountDecimalZeros = '<%=StringUtil.escapeScriptStr(EnvParameters.getEnvParameter(envId,EnvParameters.FMT_ZERO_DECIMALS))%>';
		
		/*
		var charThousSeparator	= '<%=StringUtil.escapeScriptStr(EnvParameters.getEnvParameter(envId, EnvParameters.FMT_THOUS_SEP))%>';
		var charDecimalSeparator = '<%=StringUtil.escapeScriptStr(EnvParameters.getEnvParameter(envId,EnvParameters.FMT_DECIMAL_SEP))%>';
		var addThousandSeparator = <%="true".equals(EnvParameters.getEnvParameter(envId,EnvParameters.FMT_SEPARATE_THOU))%>;
		var amountDecimalSeparator = '<%=StringUtil.escapeScriptStr(EnvParameters.getEnvParameter(envId,EnvParameters.FMT_DECIMALS))%>';
		var amountDecimalZeros = '<%=StringUtil.escapeScriptStr(EnvParameters.getEnvParameter(envId,EnvParameters.FMT_ZERO_DECIMALS))%>';
		var strDateFormat = "<%=StringUtil.escapeScriptStr(EnvParameters.getEnvParameter(envId,EnvParameters.FMT_DATE))%>";
		
		
		//var objNumRegExp 			=  /^-?\d{1,3}(,\d{3})*\.\d{1,3}$|^-?\d{1,3}(,\d{3})*$|^-?\d{1,}\.\d{1,3}$|^-?\d{1,}$/;
		var objNumRegExp;
		if(addThousandSeparator) {
			objNumRegExp =  /^-?\d{1,3}(\<%=StringUtil.escapeScriptStr(EnvParameters.getEnvParameter(envId, EnvParameters.FMT_THOUS_SEP))%>\d{3})*\<%=StringUtil.escapeScriptStr(EnvParameters.getEnvParameter(envId,EnvParameters.FMT_DECIMAL_SEP))%>\d{<%
				int cant_decimals_1 = Integer.parseInt(StringUtil.escapeScriptStr(EnvParameters.getEnvParameter(envId,EnvParameters.FMT_DECIMALS)));
				int cant_zero_decimals_1 = Integer.parseInt(StringUtil.escapeScriptStr(EnvParameters.getEnvParameter(envId,EnvParameters.FMT_ZERO_DECIMALS)));
				cant_decimals_1 = Math.max(cant_decimals_1, cant_zero_decimals_1);
				if (0 == cant_decimals_1)
					out.print("0,0");
				else
					out.print("1," + cant_decimals_1);
			%>}$|^-?\d{1,3}(\<%=StringUtil.escapeScriptStr(EnvParameters.getEnvParameter(envId, EnvParameters.FMT_THOUS_SEP))%>\d{3})*$/;
		} else {
			objNumRegExp =	/^-?\d{1,}\<%=StringUtil.escapeScriptStr(EnvParameters.getEnvParameter(envId,EnvParameters.FMT_DECIMAL_SEP))%>\d{<%
				int cant_decimals_2 = Integer.parseInt(StringUtil.escapeScriptStr(EnvParameters.getEnvParameter(envId,EnvParameters.FMT_DECIMALS)));
				int cant_zero_decimals_2 = Integer.parseInt(StringUtil.escapeScriptStr(EnvParameters.getEnvParameter(envId,EnvParameters.FMT_ZERO_DECIMALS)));
				cant_decimals_2 = Math.max(cant_decimals_2, cant_zero_decimals_2);
				if (0 == cant_decimals_2)
					out.print("0,0");
				else
					out.print("1," + cant_decimals_2);
			%>}$|^-?\d{1,}$/;
		}
		*/
		
		var objNumRegExp = <%=EnvParameters.getEnvParameter(envId, EnvParameters.FMT_NUM_REG_EXP)%>;
		
		var LBL_DAYS = ['<system:label show="text" label="lblDomingo" forHtml="true" forScript="true"/>', 
		                '<system:label show="text" label="lblLunes" forHtml="true" forScript="true"/>', 
		                '<system:label show="text" label="lblMartes" forHtml="true" forScript="true"/>', 
		                '<system:label show="text" label="lblMiercoles" forHtml="true" forScript="true"/>', 
		                '<system:label show="text" label="lblJueves" forHtml="true" forScript="true"/>', 
		                '<system:label show="text" label="lblViernes" forHtml="true" forScript="true"/>', 
		                '<system:label show="text" label="lblSabado" forHtml="true" forScript="true"/>'];
		
		var LBL_MONTHS = ['<system:label show="text" label="lblEnero" forHtml="true" forScript="true"/>', 
		                '<system:label show="text" label="lblFebrero" forHtml="true" forScript="true"/>', 
		                '<system:label show="text" label="lblMarzo" forHtml="true" forScript="true"/>', 
		                '<system:label show="text" label="lblAbril" forHtml="true" forScript="true"/>', 
		                '<system:label show="text" label="lblMayo" forHtml="true" forScript="true"/>', 
		                '<system:label show="text" label="lblJunio" forHtml="true" forScript="true"/>', 
		                '<system:label show="text" label="lblJulio" forHtml="true" forScript="true"/>', 
		                '<system:label show="text" label="lblAgosto" forHtml="true" forScript="true"/>', 
		                '<system:label show="text" label="lblSetiembre" forHtml="true" forScript="true"/>', 
		                '<system:label show="text" label="lblOctubre" forHtml="true" forScript="true"/>', 
		                '<system:label show="text" label="lblNoviembre" forHtml="true" forScript="true"/>', 
		                '<system:label show="text" label="lblDiciembre" forHtml="true" forScript="true"/>'];
		
		var PRIMARY_SEPARATOR_IN_BODY = <%= Configuration.PRIMARY_SEPARATOR_IN_BODY %>;
		
		window.addEvent('load', function() {
			
			document.addEvent('keyup', Generic.showSearch);
			document.addEvent('keydown', Generic.preventBackNavigation);
			
			initTabs();
			
			//llama al init page de cada jsp... todos deben tener uno, aunque no se haga nada en el
			if(initPage)
				initPage();
			else if(console.log)
				console.log('initPage no definido en el frame actual');
			
			//Setear datepicker
			$$("input.datePicker").each(setAdmDatePicker);			
			
			//Setear datepicker
			$$("div.button").each(Generic.setButton);
			
			//Setear numeric
			$$('input.numeric').each(Numeric.setNumeric);
			
			//Setear botones de grillas
			$$("div.navButton").each(Generic.setAdmGridBtnWidth);
			
			$$('div.tabComponent').each(function(container) {
				container.setStyle("padding-top", container.getPrevious().getHeight());
			});
			
			window.addEvent("resize", function() {
				$$('div.tabComponent').each(function(container) {
					container.setStyle("padding-top", container.getPrevious().getHeight());
				});
			})
			
			<%if(Parameters.REQUIRED_ASTERISK_POSITION.equals(Parameters.REQUIRED_ASTERISK_POSITION_AFTER)) {%>
				$(window.document.html).addClass("req-after");
			<%} else {%>
				$(window.document.html).addClass("req-before");
			<%}%>
			
			var execBlocker = $('exec-blocker');
			if(execBlocker) {
				var fx = new Fx.Morph(execBlocker, {
					duration: 400
				});
				fx.start({
					opacity: 0
				}).chain(function() {
					execBlocker.destroy();
				});
			}
		});
	</script><style type="text/css">
		/***Requieren full path***/
		.no-cssgradients .exec_field button.genericBtn {
			background-image: none;
			filter: progid:DXImageTransform.Microsoft.AlphaImageLoader(src='<system:util show="context" />/css/<system:util show="currentStyle" />/img/button/back_button_normal.gif', sizingMethod='scale');
		}
		.no-cssgradients .exec_field button.genericBtn:hover {
			background-image: none;
			filter: progid:DXImageTransform.Microsoft.AlphaImageLoader(src='<system:util show="context" />/css/<system:util show="currentStyle" />/img/button/back_button_hover.gif', sizingMethod='scale');
		}
	</style>