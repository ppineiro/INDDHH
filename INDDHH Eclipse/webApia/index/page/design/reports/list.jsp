<%@include file="../../includes/startInc.jsp" %><html><head><%@include file="../../includes/headInclude.jsp" %><link href="<system:util show="context" />/css/<system:util show="currentStyle" />/generalAdm.css" rel="stylesheet" type="text/css" /><script type="text/javascript" src="<system:util show="context" />/page/design/reports/list.js"></script><script type="text/javascript" src="<system:util show="context" />/page/includes/adminFav.js"></script><script type="text/javascript" src="<system:util show="context" />/page/includes/adminActions.js"></script><script type="text/javascript" src="<system:util show="context" />/page/includes/navButtons.js"></script><script type="text/javascript" src="<system:util show="context" />/page/includes/campaigns.js"></script><script type="text/javascript">
		var URL_REQUEST_AJAX = '/apia.design.ReportAction.run';
		var ADDITIONAL_INFO_IN_TABLE_DATA  = false;
	</script></head><body><div class="header"></div><div class="body" id="bodyDiv"><div class="optionsContainer"><system:campaign inLogin="false" inSplash="false" location="verticalUp" /><div class="fncPanel info"><div class="title"><system:label show="tooltip" label="mnuReports" /><%@include file="../../includes/adminFav.jsp" %></div><div class="content divFncDescription"><div class="fncDescriptionImage" src="<system:edit show="value" from="theBean" field="fncImage"/>"></div><div id="fncDescriptionText"><system:label show="text" label="dscFncAdmRep"/></div><div class="clear"></div></div></div><%@include file="../../includes/adminActions.jsp" %><system:campaign inLogin="false" inSplash="false" location="verticalDown" /></div><div class="gridContainer"><system:campaign inLogin="false" inSplash="false" location="horizontalUp" /><div class="gridHeader" id="gridHeader"><!-- Cabezal y filtros --><table cellpadding="0" cellspacing="0"><thead><tr id="trOrderBy" class="header"><th id="orderByPerm" title="<system:label show="tooltip" label="lblPerm" />"><div style="width: 20px">&nbsp;</div></th><th id="orderByName" class="allowSort sort<system:filter show="sortStyle" from="com.dogma.vo.filter.ReportFilterVo" field="ORDER_NAME"/>" sortBy="<system:edit show="constant" from="com.dogma.vo.filter.ReportFilterVo" field="ORDER_NAME"/>" title="<system:label show="tooltip" label="lblNom" />"><div style="width: 200px"><system:label show="text" label="lblNom"/></div></th><th id="orderByTitle" class="allowSort sort<system:filter show="sortStyle" from="com.dogma.vo.filter.ReportFilterVo" field="ORDER_TITLE"/>" sortBy="<system:edit show="constant" from="com.dogma.vo.filter.ReportFilterVo" field="ORDER_TITLE"/>" title="<system:label show="tooltip" label="lblTit" />"><div style="width: 200px"><system:label show="text" label="lblTit" /></div></th><th id="orderByDesc" class="allowSort sort<system:filter show="sortStyle" from="com.dogma.vo.filter.ReportFilterVo" field="ORDER_DESC"/>" sortBy="<system:edit show="constant" from="com.dogma.vo.filter.ReportFilterVo" field="ORDER_DESC"/>" title="<system:label show="tooltip" label="lblDesc" />"><div style="width: 200px"><system:label show="text" label="lblDesc" /></div></th><th id="orderByRegUser" class="allowSort sort<system:filter show="sortStyle" from="com.dogma.vo.filter.ReportFilterVo" field="ORDER_USER"/>" sortBy="<system:edit show="constant" from="com.dogma.vo.filter.ReportFilterVo" field="ORDER_USER"/>" title="<system:label show="tooltip" label="lblLastUsrName" />"><div style="width: 100px"><system:label show="text" label="lblLastUsrName" /></div></th><th id="orderByRegDate" class="allowSort sort<system:filter show="sortStyle" from="com.dogma.vo.filter.ReportFilterVo" field="ORDER_DATE"/>" sortBy="<system:edit show="constant" from="com.dogma.vo.filter.ReportFilterVo" field="ORDER_DATE"/>" title="<system:label show="tooltip" label="lblLastActDate" />"><div style="width: 100px"><system:label show="text" label="lblLastActDate" /></div></th></tr><tr class="filter"><th title="<system:label show="tooltip" label="lblPerm" />"><div style="width: 20px"></div></th><th title="<system:label show="tooltip" label="lblNom" />"><div style="width: 200px"><input id="nameFilter" type="text" value="<system:filter show="value" filter="0"></system:filter>"></div></th><th title="<system:label show="tooltip" label="lblTit" />"><div style="width: 200px"><input id="titleFilter" type="text" value="<system:filter show="value" filter="1"></system:filter>"></div></th><th title="<system:label show="tooltip" label="lblDesc" />"><div style="width: 200px"><input id="descFilter" type="text" value="<system:filter show="value" filter="2"></system:filter>"></div></th><th title="<system:label show="tooltip" label="lblLastUsrName" />"><div style="width: 100px"><input id="regUsrFilter" type="text" value="<system:filter show="value" filter="3"></system:filter>"></div></th><th title="<system:label show="tooltip" label="lblLastActDate" />"><div style="width: 100px"><input id="regDateFilter" type="text" class="datePicker filterInputDate" format="d/m/Y" value="<system:filter show="value" filter="4"></system:filter>"></div></th></tr></thead></table></div><div class="gridBody" id="gridBody"><!-- Cuerpo de la tabla --><table cellpadding="0" cellspacing="0"><thead><tr><th width="20px"></th><th width="200px"></th><th width="200px"></th><th width="200px"></th><th width="100px"></th><th width="100px"></th></tr></thead><tbody class="tableData" id="tableData"></tbody></table></div><div class="gridFooter"><%@include file="../../includes/navButtons.jsp" %></div><!-- MESSAGES --><div class="message hidden" id="messageContainer"></div><system:campaign inLogin="false" inSplash="false" location="horizontalDown" /></div></div><%@include file="../../includes/footer.jsp" %></body></html>
