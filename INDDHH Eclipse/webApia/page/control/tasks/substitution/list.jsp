<%@include file="../../../includes/startInc.jsp" %><html lang="<%=biz.statum.apia.web.bean.BasicBeanStatic.getUserDataStatic(request).getLangCode()%>"><head><%@include file="../../../includes/headInclude.jsp" %><script type="text/javascript" src="<system:util show="context" />/page/control/tasks/substitution/list.js"></script><script type="text/javascript" src="<system:util show="context" />/page/includes/adminFav.js"></script><script type="text/javascript" src="<system:util show="context" />/page/includes/adminActions.js"></script><script type="text/javascript" src="<system:util show="context" />/page/includes/navButtons.js"></script><script type="text/javascript" src="<system:util show="context" />/page/includes/campaigns.js"></script><script type="text/javascript">
		var HIERARCHY = <%=request.getParameter("hierarchy")%>;
		var URL_REQUEST_AJAX = '/apia.control.UsersSubstituteAction.run';
		var ADDITIONAL_INFO_IN_TABLE_DATA  = false;				
	</script></head><body><div class="body" id="bodyDiv"><div class="optionsContainer"><system:campaign inLogin="false" inSplash="false" location="verticalUp" /><div class="fncPanel info"><div class="title"><system:label show="text" label="titLeave" /><%@include file="../../../includes/adminFav.jsp" %></div><div class="content divFncDescription"><div class="fncDescriptionImage" data-src="<system:edit show="value" from="theBean" field="fncImage"/>"></div><div id="fncDescriptionText"><system:label show="text" label="dscFncAdmLeave"/></div><div class="clear"></div></div></div><div class="fncPanel options lastOptions"><div class="title"><system:label show="text" label="titActions"/></div><div class="content"><div id="btnCre" class="button suggestedAction" title="<system:label show="tooltip" label="btnCre" />"><system:label show="text" label="btnCre" /></div><div id="btnMod" class="button" title="<system:label show="tooltip" label="btnMod" />"><system:label show="text" label="btnMod" /></div><div id="btnDel" class="button" title="<system:label show="tooltip" label="btnEli" />"><system:label show="text" label="btnEli" /></div><div id="btnHis" class="button" title="<system:label show="tooltip" label="btnHis" />"><system:label show="text" label="btnHis" /></div></div><div class="clear"></div></div><system:campaign inLogin="false" inSplash="false" location="verticalDown" /></div><div class="gridContainer"><system:campaign inLogin="false" inSplash="false" location="horizontalUp" /><div class="gridHeader" id="gridHeader"><!-- Cabezal y filtros --><table><thead><tr id="trOrderBy" class="header"><th id="orderByUser" class="allowSort sort<system:filter show="sortStyle" from="com.dogma.vo.filter.UserSubstituteFilterVo" field="ORDER_LOGIN"/>" data-sortBy="<system:edit show="constant" from="com.dogma.vo.filter.UserSubstituteFilterVo" field="ORDER_LOGIN"/>" title="<system:label show="tooltip" label="lblLog" />"><div style="width: 100px"><system:label show="text" label="lblLog" /></div></th><th id="orderByStartDate" class="allowSort sort<system:filter show="sortStyle" from="com.dogma.vo.filter.UserSubstituteFilterVo" field="ORDER_DTE_FROM"/>" data-sortBy="<system:edit show="constant" from="com.dogma.vo.filter.UserSubstituteFilterVo" field="ORDER_DTE_FROM"/>" title="<system:label show="tooltip" label="lblDteFrom" />"><div style="width: 120px"><system:label show="text" label="lblDteFrom" /></div></th><th id="orderByEndDate" class="allowSort sort<system:filter show="sortStyle" from="com.dogma.vo.filter.UserSubstituteFilterVo" field="ORDER_DTE_TO"/>" data-sortBy="<system:edit show="constant" from="com.dogma.vo.filter.UserSubstituteFilterVo" field="ORDER_DTE_TO"/>" title="<system:label show="tooltip" label="lblDteTo" />"><div style="width: 120px"><system:label show="text" label="lblDteTo" /></div></th><th id="orderByStatus" class="allowSort sort<system:filter show="sortStyle" from="com.dogma.vo.filter.UserSubstituteFilterVo" field="ORDER_STATUS"/>" data-sortBy="<system:edit show="constant" from="com.dogma.vo.filter.UserSubstituteFilterVo" field="ORDER_STATUS"/>" title="<system:label show="tooltip" label="lblSta" />"><div style="width: 100px"><system:label show="text" label="lblSta"/></div></th><th id="orderByRegUser" class="allowSort sort<system:filter show="sortStyle" from="com.dogma.vo.filter.UserSubstituteFilterVo" field="ORDER_USER"/>" data-sortBy="<system:edit show="constant" from="com.dogma.vo.filter.UserSubstituteFilterVo" field="ORDER_USER"/>" title="<system:label show="tooltip" label="lblLastUsrName" />"><div style="width: 100px"><system:label show="text" label="lblLastUsrName" /></div></th><th id="orderByRegDate" class="allowSort sort<system:filter show="sortStyle" from="com.dogma.vo.filter.UserSubstituteFilterVo" field="ORDER_DATE"/>" data-sortBy="<system:edit show="constant" from="com.dogma.vo.filter.UserSubstituteFilterVo" field="ORDER_DATE"/>" title="<system:label show="tooltip" label="lblLastActDate" />"><div style="width: 100px"><system:label show="text" label="lblLastActDate" /></div></th></tr><tr class="filter"><th title="<system:label show="tooltip" label="lblLog" />"><div style="width: 100px"><input id="userFilter" type="text" value="<system:filter show="value" filter="0"></system:filter>"></div></th><th title="<system:label show="tooltip" label="lblDteFrom" />"><div style="width: 120px"><input id="startDateFilter" type="text" class="datePicker filterInputDate"  value="<system:filter show="value" filter="1"></system:filter>"></div></th><th title="<system:label show="tooltip" label="lblDteTo" />"><div style="width: 120px"><input id="endDateFilter" type="text" class="datePicker filterInputDate"  value="<system:filter show="value" filter="2"></system:filter>"></div></th><th title="<system:label show="tooltip" label="lblSta" />"><div style="width: 100px"><select id="cmbStatusFilter" onchange="setFilter()" name="cmbStatusFilter" value="<system:filter show="value" filter="5"></system:filter>"><option></option><system:util show="prepareSubstitutesStatus" saveOn="subStatus" /><system:edit show="iteration" from="subStatus" saveOn="subStatus_save"><system:edit show="saveValue" from="subStatus_save" field="status" saveOn="status"/><option value="<system:edit show="value" from="subStatus_save" field="status"/>"><system:edit show="value" from="subStatus_save" field="statusName"/></option></system:edit></select></div></th><th title="<system:label show="tooltip" label="lblLastUsrName" />"><div style="width: 100px"><input id="regUsrFilter" type="text" value="<system:filter show="value" filter="3"></system:filter>"></div></th><th title="<system:label show="tooltip" label="lblLastActDate" />"><div style="width: 100px"><input id="regDateFilter" type="text" class="datePicker filterInputDate" value="<system:filter show="value" filter="4"></system:filter>"></div></th></tr></thead></table></div><div class="gridBody" id="gridBody"><!-- Cuerpo de la tabla --><table><thead><tr><th width="100px"></th><th width="120px"></th><th width="120px"></th><th width="100px"></th><th width="100px"></th><th width="100px"></th></tr></thead><tbody class="tableData" id="tableData"></tbody></table></div><div class="gridFooter"><%@include file="../../../includes/navButtons.jsp" %></div><!-- MESSAGES --><div class="message hidden" id="messageContainer"></div><system:campaign inLogin="false" inSplash="false" location="horizontalDown" /></div></div><%@include file="../../../includes/footer.jsp" %></body></html>
