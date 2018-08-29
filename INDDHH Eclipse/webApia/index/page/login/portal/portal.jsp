<%@page import="java.util.Enumeration"%>
<%@page import="biz.statum.sdk.util.StringUtil"%>
<%@page import="com.dogma.controller.ThreadData"%>
<%@page import="biz.statum.apia.web.action.portal.PortalAction"%>
<%@page import="biz.statum.apia.web.bean.portal.PortalBean"%>
<%@page import="biz.statum.sdk.util.HttpServletRequestResponse"%>
<%@include file="../../includes/startInc.jsp" %>

<%	
	HttpServletRequestResponse http = new HttpServletRequestResponse(request, response);
	PortalBean bean = PortalAction.staticRetrieveBean(http,true);
%>

<html>
<head>
	<title>Apia</title>
	<link rel="shortcut icon" href="<system:util show="context" />/css/<system:util show="defaultStyle" />/favicon.ico">
	
	<link href="<system:util show="context" />/css/<system:util show="defaultStyle" />/portal.css" rel="stylesheet" type="text/css" />
	<link href="<system:util show="context" />/css/<system:util show="defaultStyle" />/splashLayout.css" rel="stylesheet" type="text/css" />
	<link href="<system:util show="context" />/css/<system:util show="defaultStyle" />/portalLayout.css" rel="stylesheet" type="text/css" />
	<link href="<system:util show="context" />/css/<system:util show="defaultStyle" />/spinner.css" rel="stylesheet" type="text/css" />
	<link href="<system:util show="context" />/css/<system:util show="defaultStyle" />/messages.css" rel="stylesheet" type="text/css" />
	<link href="<system:util show="context" />/css/<system:util show="defaultStyle" />/modal.css" rel="stylesheet" type="text/css" />
	<link href="<system:util show="context" />/css/<system:util show="defaultStyle" />/login.css" rel="stylesheet" type="text/css" />

	<link rel="stylesheet" href="<system:util show="context" />/js/formcheck/theme/classic/formcheck.css" type="text/css" media="screen" />
	<link rel="stylesheet" href="<system:util show="context" />/js/tooltips/js/sexy-tooltips/blue.css" type="text/css" media="all" id="theme"/>
	
	<script type="text/javascript" src="<system:util show="context" />/js/modernizr.custom.js"></script>
	
	<script type="text/javascript" src="<system:util show="context" />/js/mootools-core-1.4.5-full-compat.js"></script>
	<script type="text/javascript" src="<system:util show="context" />/js/mootools-more-1.4.0.1-compat.js"></script>
	
	<script type="text/javascript" src="<system:util show="context" />/js/modal.js"></script>
	<script type="text/javascript" src="<system:util show="context" />/js/generics.js"> </script>
	<script type="text/javascript" src="<system:util show="context" />/js/Zoomer.js"></script>

	<script type="text/javascript" src="<system:util show="context" />/js/formcheck/lang/es.js"> </script>
	<script type="text/javascript" src="<system:util show="context" />/js/formcheck/formcheck.js"> </script>
	
	<script type="text/javascript" src="<system:util show="context" />/js/tooltips/js/sexy-tooltips.v1.2.mootools.js"></script>
	
	<script type="text/javascript" src="<system:util show="context" />/page/includes/campaigns.js"></script>
	<script type="text/javascript" src="<system:util show="context" />/page/login/portal/portal.js"></script>	
	
	<script type="text/javascript" src="<system:util show="context" />/js/modalController.js"> </script> 
	<script type="text/javascript" src="<system:util show="context" />/js/scroller.js"></script>
	
	<base target="_new">
	
	<script type="text/javascript">
		var	sp;
		var TAB_CONTAINER;
		var CONTEXT					= "<system:util show='context' />";
		var STYLE					= "<system:util show='defaultStyle' />";
		var TAB_ID					= "<%=request.getParameter("tabId")%>";
		var TAB_ID_REQUEST			= "&tabId=<%=request.getParameter("tabId")%>&tokenId=<%=request.getParameter("tokenId")%>";
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
		var MSIE 					= window.navigator.appVersion.indexOf("MSIE")>=0;
		var MSG_LOADING				= '<system:label show="text" label="msgLoading" forHtml="true" forScript="true" />';
		
		var MSG_INVALID_REG_EXP		= '<system:label show="text" label="msgExpRegFal" forHtml="true" forScript="true"/>';
		var ERR_UNEXPECTED			= '<system:label show="text" label="errUnexpected" forHtml="true" forScript="true"/>';
		var ERR_NOTHING_TO_LOAD		= '<system:label show="text" label="errNothingToLoad" forHtml="true" forScript="true"/>';
		var ERR_OPEN_URL			= '<system:label show="text" label="errOpenUrl" forHtml="true" forScript="true"/>';
		
		var CURRENT_PORTAL_TOKEN_ID = "<%=request.getParameter("tokenId")%>";
		
		window.addEvent('resize', function() {
			resizeImages();
		});
		
		window.addEvent('load', function() {
			window.addEvent('keyup', Generic.showSearch);
			window.addEvent('keydown', Generic.preventBackNavigation);
			
			initPage();
			
			<%= bean.writeJS(http, true) %>
			
			resizeImages();
		});
		
		var URL_PORTAL_PANEL_REFRESH	= CONTEXT + "/apia.portal.PortalAction.run?action=panelRefresh" + TAB_ID_REQUEST;
		var URL_PORTAL_PANEL_ACTION		= CONTEXT + "/apia.portal.PortalAction.run?action=panelAction" + TAB_ID_REQUEST;
		
		<%= bean.writeJS(http, false) %>
	</script>
	
	<style type="text/css">
		<%= bean.writeCSS(http) %>
	</style>
</head>

<body id="body">
	<div class="body splash splashLayout" id="bodyController">
		<%= bean.drawHTML(http) %>		
	</div>	
</body>

</html>	