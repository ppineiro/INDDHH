<%@page import="com.dogma.vo.custom.TrioDataVo"%><%@page import="com.dogma.vo.custom.CmbDataVo"%><%@page import="java.util.HashMap"%><%@page import="biz.statum.apia.web.bean.query.UserBean"%><%@page import="biz.statum.sdk.util.HttpServletRequestResponse"%><%@page import="biz.statum.apia.web.action.query.UserAction"%><%@include file="../../includes/startInc.jsp" %><html><head><%@include file="../../includes/headInclude.jsp" %><link href="<system:util show="context" />/css/<system:util show="currentStyle" />/generalAdm.css" rel="stylesheet" type="text/css" /><script type="text/javascript" src="<system:util show="context" />/js/Zoomer.js"></script><script type="text/javascript" src="<system:util show="context" />/page/query/user/list.js"></script><script type="text/javascript" src="<system:util show="context" />/page/query/common/queryButtons.js"></script><script type="text/javascript" src="<system:util show="context" />/page/includes/adminFav.js"></script><script type="text/javascript" src="<system:util show="context" />/page/includes/campaigns.js"></script><script type="text/javascript" src="<system:util show="context" />/page/includes/navButtons.js"></script><script type="text/javascript" src="<system:util show="context" />/js/print.js"></script><script type="text/javascript">
		var URL_REQUEST_AJAX = '/apia.query.UserAction.run';
		var ADDITIONAL_INFO_IN_TABLE_DATA  = false;
		
		var MON_DOC_TAB_TITLE 				= '<system:label show="text" label="mnuMonDoc"/>';
		var URL_REQUEST_AJAX_MON_DOCUMENT 	= '/apia.monitor.MonitorDocumentAction.run';
		
		var QUERY_TITLE	= '<system:query show="value" from="theBean" field="queryTitle" />';
		var QUERY_RESULTS = '<system:label show="tooltip" label="sbtRes"/>' + ': <TOK_1> ' + '<system:label show="tooltip" label="lblResRegEnc"/>'; 
		var QUERY_MORE_DATA = '<system:label show="tooltip" label="lblMoreData"/>';
		
		<%
		HttpServletRequestResponse http = new HttpServletRequestResponse(request,response);
		UserBean bean = UserAction.staticRetrieveBean(http, false);
		%>
		var FROM_MINISITE = <%=bean.getUserData(http).isFromMinisite()%>;
	</script></head><body><div id="exec-blocker"></div><div class="header"></div><div class="body" id="bodyDiv"><form id="queryForm" action="<system:util show="context" />/apia.query.UserAction.run?<system:util show="tabIdRequest" />" method="post"><input type="hidden" name="action" value="" id="queryFormAction"><div class="optionsContainer" id="optionsContainer" style="position: absolute;"><system:campaign inLogin="false" inSplash="false" location="verticalUp" /><%@include file="../common/panelInfo.jsp" %><div class="fncPanel options"><div class="title"><system:label show="text" label="titActions"/></div><div class="content"><system:query show="ifValue" from="theBean" field="hasFilters" value="true"><div id="btnSearch" class="button suggestedAction" title="<system:label show="tooltip" label="btnSearch" />"><system:label show="text" label="btnSearch" /></div></system:query><%
						Collection<TrioDataVo> actions = bean.getActions(http);
						for(TrioDataVo a : actions) {
							out.write("<div id=\"" + a.getValue() + "\" class=\"button actionBtn\" title=\"" + a.getDesc() + "\">" + a.getText() + "</div>");
						}
						%><system:query show="ifValue" from="theBean" field="mustShowGoBack" value="true"><div id="btnGoBack" class="button" title="<system:label show="tooltip" label="btnAnt" />"><system:label show="text" label="btnAnt" /></div></system:query><div id="btnCloseTab" class="button" title="<system:label show="tooltip" label="btnClose" />"><system:label show="text" label="btnClose" /></div><%
						Collection<CmbDataVo> actionQuerys = bean.getActionQuerys(http);
						for(CmbDataVo a : actionQuerys) {
							out.write("<div id=\"" + a.getValue() + "\" class=\"button extendedSize actionBtn\">" + a.getText() + "</div>");
						}
						%></div></div><div class="fncPanel options"><div class="title"><system:label show="tooltip" label="titOptions"/></div><div class="content"><system:query show="ifFlag" from="theQuery" field="0" defaultValue="qryButtons"><div id="btnExport" class="button" title="<system:label show="tooltip" label="btnExport" />"><system:label show="text" label="btnExport" /></div></system:query><system:query show="ifFlag" from="theQuery" field="1" defaultValue="qryButtons"><div id="btnPrint" class="button" title="<system:label show="tooltip" label="btnPrint" />"><system:label show="text" label="btnPrint" /></div></system:query><system:query show="ifValue" from="theBean" field="hasColumnsForMonDocuments" value="true"><div id="btnDocuments" class="button" title="<system:label show="tooltip" label="btnViewDocs" />" style="display: inline-block;"><system:label show="text" label="btnViewDocs" /></div></system:query><system:query show="ifNotFlag" from="theQuery" field="21"><system:query show="ifValue" from="theBean" field="hasFiltersWithType" value="true"><div id="btnFilterType" class="button large"><system:label show="text" label="btnFilterType" /></div></system:query></system:query><system:query show="ifValue" from="theBean" field="isPaged" value="false"><div class="filter"><span><system:label show="text" label="lblNavShow"/>:</span><select name="showRegs" id="showRegs"><system:query show="iteration" from="theBean" field="pagesGroup" saveOn="pageGroup"><option value="<system:query show="value" from="pageGroup" field="amount" />" <system:query show="ifValue" from="pageGroup" field="selected" value="true">selected</system:query>><system:query show="value" from="pageGroup" field="amount" /></option></system:query></select></div></system:query></div></div><%@include file="../common/additionalFilters.jsp" %><%@include file="chartButtons.jsp" %><system:campaign inLogin="false" inSplash="false" location="verticalDown" /></div><div class="gridContainer" id="gridContainer"><system:campaign inLogin="false" inSplash="false" location="horizontalUp" /><%@include file="listTabsStart.jsp" %><%@include file="../common/columnsHeader.jsp" %><%@include file="../common/columnsValue.jsp" %><%@include file="../common/navButtons.jsp" %><%@include file="listTabChart.jsp" %><%@include file="listTabsEnd.jsp" %><system:campaign inLogin="false" inSplash="false" location="horizontalDown" /></div></form></div><form style="display:none;" id="frmBtnActions" action="/apia.query.UserAction.run?action=doAction&tabId=<%=bean.getTabId(http) %>" method="POST"><input id="frmBtnActionsNavTo" name="navTo"><input id="frmBtnActionsId" name="id"></form><%@include file="../../includes/footer.jsp" %></body></html>
