<%@include file="../../includes/startInc.jsp" %><html lang="<%=biz.statum.apia.web.bean.BasicBeanStatic.getUserDataStatic(request).getLangCode()%>"><head><%@include file="../../includes/headInclude.jsp" %><script type="text/javascript" src="<system:util show="context" />/page/administration/environments/list.js"></script><script type="text/javascript" src="<system:util show="context" />/page/includes/adminFav.js"></script><script type="text/javascript" src="<system:util show="context" />/page/includes/adminActions.js"></script><script type="text/javascript" src="<system:util show="context" />/page/includes/navButtons.js"></script><script type="text/javascript" src="<system:util show="context" />/page/includes/campaigns.js"></script><script type="text/javascript">
		var URL_REQUEST_AJAX = '/apia.administration.EnvironmentsAction.run';
		var ADDITIONAL_INFO_IN_TABLE_DATA  = false;
		var TITLE_TAB = '<system:label show="text" label="mnuEnvPar" forScript="true" />';
		var URL_REQUEST_AJAX_ENV_PARAMS = '/apia.administration.EnvironmentParametersAction.run';
	</script></head><body><div class="body" id="bodyDiv"><div class="optionsContainer"><system:campaign inLogin="false" inSplash="false" location="verticalUp" /><div class="fncPanel info"><div class="title"><system:label show="text" label="mnuAmb" /><%@include file="../../includes/adminFav.jsp" %></div><div class="content divFncDescription"><div class="fncDescriptionImage" data-src="<system:edit show="value" from="theBean" field="fncImage"/>"></div><div id="fncDescriptionText"><system:label show="text" label="dscFncAdmEnv"/></div><div class="clear"></div></div></div><%@include file="../../includes/adminActions.jsp" %><div class="fncPanel buttons"><table><tr><td><div class="title"><system:label show="text" label="mnuOpc" /></div></td></tr><tr><td><div class="content"><div id="btnInit" class="button submit validate['submit']" title="<system:label show="tooltip" label="btnIni" />"><system:label show="text" label="btnIni" /></div><div id="btnParam" class="button submit validate['submit']" title="<system:label show="tooltip" label="btnParams" />"><system:label show="text" label="btnParams" /></div></div></td></tr><tr><td class="foot"></td></tr></table></div><system:campaign inLogin="false" inSplash="false" location="verticalDown" /></div><div class="gridContainer"><system:campaign inLogin="false" inSplash="false" location="horizontalUp" /><div class="gridHeader" id="gridHeader"><!-- Cabezal y filtros --><table><thead><tr id="trOrderBy" class="header"><th id="orderByName" class="allowSort sort<system:filter show="sortStyle" from="com.dogma.vo.filter.EnvironmentFilterVo" field="ORDER_NAME"/>" data-sortBy="<system:edit show="constant" from="com.dogma.vo.filter.EnvironmentFilterVo" field="ORDER_NAME"/>" title="<system:label show="tooltip" label="lblNom" />"><div style="width: 150px"><system:label show="text" label="lblNom"/></div></th><th id="orderByTitle" class="allowSort sort<system:filter show="sortStyle" from="com.dogma.vo.filter.EnvironmentFilterVo" field="ORDER_TITLE"/>" data-sortBy="<system:edit show="constant" from="com.dogma.vo.filter.EnvironmentFilterVo" field="ORDER_TITLE"/>" title="<system:label show="tooltip" label="lblTit" />"><div style="width: 150px"><system:label show="text" label="lblTit"/></div></th><th id="orderByDesc" class="allowSort sort<system:filter show="sortStyle" from="com.dogma.vo.filter.EnvironmentFilterVo" field="ORDER_DESC"/>" data-sortBy="<system:edit show="constant" from="com.dogma.vo.filter.EnvironmentFilterVo" field="ORDER_DESC"/>" title="<system:label show="tooltip" label="lblDesc" />"><div style="width: 200px"><system:label show="text" label="lblDesc" /></div></th><th id="orderByLabel" class="allowSort sort<system:filter show="sortStyle" from="com.dogma.vo.filter.EnvironmentFilterVo" field="ORDER_LBL_SET"/>" data-sortBy="<system:edit show="constant" from="com.dogma.vo.filter.EnvironmentFilterVo" field="ORDER_LBL_SET"/>" title="<system:label show="tooltip" label="lblEti" />"><div style="width: 100px"><system:label show="text" label="lblEti" /></div></th><th id="orderByRegUser" class="allowSort sort<system:filter show="sortStyle" from="com.dogma.vo.filter.EnvironmentFilterVo" field="ORDER_USER"/>" data-sortBy="<system:edit show="constant" from="com.dogma.vo.filter.EnvironmentFilterVo" field="ORDER_USER"/>" title="<system:label show="tooltip" label="lblLastUsrName" />"><div style="width: 100px"><system:label show="text" label="lblLastUsrName" /></div></th><th id="orderByRegDate" class="allowSort sort<system:filter show="sortStyle" from="com.dogma.vo.filter.EnvironmentFilterVo" field="ORDER_DATE"/>" data-sortBy="<system:edit show="constant" from="com.dogma.vo.filter.EnvironmentFilterVo" field="ORDER_DATE"/>" title="<system:label show="tooltip" label="lblLastActDate" />"><div style="width: 100px"><system:label show="text" label="lblLastActDate" /></div></th></tr><tr class="filter"><th title="<system:label show="tooltip" label="lblNom" />"><div style="width: 150px"><input id="nameFilter" type="text" value="<system:filter show="value" filter="0"></system:filter>"></div></th><th title="<system:label show="tooltip" label="lblTit" />"><div style="width: 150px"><input id="titleFilter" type="text" value="<system:filter show="value" filter="5"></system:filter>"></div></th><th title="<system:label show="tooltip" label="lblDesc" />"><div style="width: 200px"><input id="descFilter" type="text" value="<system:filter show="value" filter="1"></system:filter>"></div></th><th title="<system:label show="tooltip" label="lblTipDat" />"><div style="width: 100px"><select name="labelFilter" id="labelFilter" onchange="setFilter()"><option value="" selected></option><system:util show="prepareLabelSet" saveOn="labels" /><system:edit show="iteration" from="labels" saveOn="label"><option value="<system:edit show="value" from="label" field="lblSetId"/>"><system:edit show="value" from="label" field="lblSetName"/></option></system:edit></select></div></th><th title="<system:label show="tooltip" label="lblLastUsrName" />"><div style="width: 100px"><input id="regUsrFilter" type="text" value="<system:filter show="value" filter="3"></system:filter>"></div></th><th title="<system:label show="tooltip" label="lblLastActDate" />"><div style="width: 100px"><input id="regDateFilter" type="text" class="datePicker filterInputDate" value="<system:filter show="value" filter="4"></system:filter>"></div></th></tr></thead></table></div><div class="gridBody" id="gridBody"><!-- Cuerpo de la tabla --><table><thead><tr><th width="150px"></th><th width="150px"></th><th width="200px"></th><th width="100px"></th><th width="100px"></th><th width="100px"></th></tr></thead><tbody class="tableData" id="tableData"></tbody></table></div><div class="gridFooter"><%@include file="../../includes/navButtons.jsp" %></div><!-- MESSAGES --><div class="message hidden" id="messageContainer"></div><system:campaign inLogin="false" inSplash="false" location="horizontalDown" /></div></div><%@include file="../../includes/footer.jsp" %></body></html>
