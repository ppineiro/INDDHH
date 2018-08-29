<%@page import="biz.statum.apia.web.bean.splash.SplashBean"%>
<%@page import="biz.statum.sdk.util.HttpServletRequestResponse"%>
<%@page import="biz.statum.apia.web.action.splash.SplashAction"%>
<%@include file="../includes/startInc.jsp" %><%

HttpServletRequestResponse http = new HttpServletRequestResponse(request, response);
SplashBean bean = SplashAction.staticRetrieveBean(http);
		
%><html><head><link rel="shortcut icon" href="<system:util show="context" />/css/<system:util show="currentStyle" />/favicon.ico"><link href="<system:util show="context" />/css/<system:util show="currentStyle" />/splash.css" rel="stylesheet" type="text/css" /><link href="<system:util show="context" />/css/<system:util show="currentStyle" />/splashLayout.css" rel="stylesheet" type="text/css" /><link href="<system:util show="context" />/css/<system:util show="currentStyle" />/spinner.css" rel="stylesheet" type="text/css" /><link href="<system:util show="context" />/css/<system:util show="currentStyle" />/messages.css" rel="stylesheet" type="text/css" /><link href="<system:util show="context" />/css/<system:util show="currentStyle" />/modal.css" rel="stylesheet" type="text/css" /><link href="<system:util show="context" />/css/<system:util show="currentStyle" />/generalAdm.css" rel="stylesheet" type="text/css" /><link rel="stylesheet" href="<system:util show="context" />/js/formcheck/theme/classic/formcheck.css" type="text/css" media="screen" /><link rel="stylesheet" href="<system:util show="context" />/js/tooltips/js/sexy-tooltips/blue.css" type="text/css" media="all" id="theme"/><script type="text/javascript" src="<system:util show="context" />/js/modernizr.custom.js"></script><script type="text/javascript" src="<system:util show="context" />/js/mootools-core-1.4.5-full-compat.js"></script><script type="text/javascript" src="<system:util show="context" />/js/mootools-more-1.4.0.1-compat.js"></script><script type="text/javascript" src="<system:util show="context" />/js/modal.js"></script><script type="text/javascript" src="<system:util show="context" />/js/generics.js"></script><script type="text/javascript" src="<system:util show="context" />/js/Zoomer.js"></script><script type="text/javascript" src="<system:util show="context" />/js/formcheck/lang/es.js"></script><script type="text/javascript" src="<system:util show="context" />/js/formcheck/formcheck.js"></script><script type="text/javascript" src="<system:util show="context" />/js/tooltips/js/sexy-tooltips.v1.2.mootools.js"></script><script type="text/javascript" src="<system:util show="context" />/page/includes/campaigns.js"></script><script type="text/javascript" src="<system:util show="context" />/page/splash/splash.js"></script><script type="text/javascript" src="<system:util show="context" />/js/modalController.js"></script><script type="text/javascript" src="<system:util show="context" />/js/scroller.js"></script><script type="text/javascript">
	    var Timeline_ajax_url= '<system:util show="host" /><system:util show="context" />/js/timeline/simile-ajax-api.js';
        var Timeline_urlPrefix='<system:util show="host" /><system:util show="context" />/js/timeline/';       
        var Timeline_parameters='bundle=true';       
    </script><script type="text/javascript" src="<system:util show="context" />/js/timeline/timeline-api.js"></script><script type="text/javascript" src="<system:util show="context" />/js/dropMenu/MooDropMenu.js"></script><link href="<system:util show="context" />/js/dropMenu/css/MooDropMenu.css" rel="stylesheet" type="text/css" media="screen" /><script type="text/javascript" src="<%=Parameters.ROOT_PATH%>/page/includes/navButtons.js"></script><base target="_new"><script type="text/javascript">
		var	sp;
		var TAB_CONTAINER;
		var CONTEXT					= "<system:util show="context" />";
		var STYLE					= "<system:util show="currentStyle" />";
		var TAB_ID					= "<system:util show="tabId" />";
		var TAB_ID_REQUEST			= "<system:util show="tabIdRequest" />";
		var WAIT_A_SECOND			= '<system:label show="text" label="lblEspUnMom" forScript="true" />';
		var GNR_TIT_WARNING 		= '<system:label show="text" label="titMsgWarning" forScript="true" />';
		var GNR_CHK_ONLY_ONE 		= '<system:label show="text" label="msgDebSelSolUno" forScript="true" />';
		var GNR_CHK_AT_LEAST_ONE 	= '<system:label show="text" label="msgDebSelUno" forScript="true" />';
		var GNR_MORE_RECORDS		= '<system:label show="text" label="lblNoRet" forScript="true" />';
		var GNR_TOT_RECORDS			= '<system:label show="text" label="lblTotReg" forScript="true" />';
		var GNR_TITILE_EXCEPTIONS	= "Exceptions";
		var GNR_TITILE_MESSAGES		= "Messages";
		var BTN_CONFIRM				= '<system:label show="text" label="btnCon" forHtml="true" forScript="true"/>';
		var BTN_CANCEL				= '<system:label show="text" label="btnCan" forHtml="true" forScript="true"/>';
		var BTN_CLOSE				= '<system:label show="text" label="btnCer" forHtml="true" forScript="true"/>';
		var MSIE = window.navigator.appVersion.indexOf("MSIE")>=0;
				
		var MSG_LOADING			= '<system:label show="text" label="msgLoading" forHtml="true" forScript="true" />';
		
		var ERR_OPEN_URL			= '<system:label show="text" label="errOpenUrl" forHtml="true" forScript="true"/>';
		
		window.addEvent('resize', function() {
			resizeImages();
		});
		
		window.addEvent('load', function() {
			
			if(Browser.ie && Browser.version <= 8) {
				document.documentElement.className = document.documentElement.className + ' ie8';
			}
			
			window.addEvent('keyup', Generic.showSearch);
			window.addEvent('keydown', Generic.preventBackNavigation);
			
			//llama al init page de cada jsp... todos deben tener uno, aunque no se haga nada en el
			initPage();
			
			<%= bean.writeJS(http, true) %>
			
			resizeImages();
		});
		
		var URL_SPLASH_PANEL_EDIT		= CONTEXT + "/apia.splash.SplashAction.run?action=panelEdit" + TAB_ID_REQUEST;
		var URL_SPLASH_PANEL_REFRESH	= CONTEXT + "/apia.splash.SplashAction.run?action=panelRefresh" + TAB_ID_REQUEST;
		var URL_SPLASH_PANEL_ACTION		= CONTEXT + "/apia.splash.SplashAction.run?action=panelAction" + TAB_ID_REQUEST;
		var URL_SPLASH_PANEL_MOVE		= CONTEXT + "/apia.splash.SplashAction.run?action=panelMove" + TAB_ID_REQUEST;
		
		<%= bean.writeJS(http, false) %></script><style type="text/css"><%= bean.writeCSS(http) %></style></head><body id="body"><div class="header"></div><%=bean.hasKBItemPanel() ? "<div id=\"exec-blocker\"></div>" : "" %><div class="splash-campaign-right"><system:campaign inLogin="false" inSplash="true" location="verticalUp" /></div><div class="splash-campaign-left"><system:campaign inLogin="false" inSplash="true" location="horizontalUp" /></div><div class="body splash splashLayout" id="bodyController"><%= bean.drawHTML(http) %></div><div class="splash-campaign-right"><system:campaign inLogin="false" inSplash="true" location="verticalDown" /></div><div class="splash-campaign-left"><system:campaign inLogin="false" inSplash="true" location="horizontalDown" /></div><jsp:include page="../includes/footerSplash.jsp?includeLicence=true" /></body></html>