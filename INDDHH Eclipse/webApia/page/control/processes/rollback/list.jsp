<%@page import="com.st.util.labels.LabelManager"%><%@page import="com.dogma.vo.ProInstanceVo"%><%@include file="../../../includes/startInc.jsp" %><html lang="<%=biz.statum.apia.web.bean.BasicBeanStatic.getUserDataStatic(request).getLangCode()%>"><head><%@include file="../../../includes/headInclude.jsp" %><script type="text/javascript" src="<system:util show="context" />/page/control/processes/rollback/list.js"></script><script type="text/javascript" src="<system:util show="context" />/page/includes/adminFav.js"></script><script type="text/javascript" src="<system:util show="context" />/page/includes/navButtons.js"></script><script type="text/javascript" src="<system:util show="context" />/page/includes/campaigns.js"></script><script type="text/javascript">
		var URL_REQUEST_AJAX = '/apia.control.ProcessesRollbackAction.run';
		var ADDITIONAL_INFO_IN_TABLE_DATA  = true;		
		var STATUS_R = '<system:edit show="constant" from="com.dogma.vo.IProcess" field="PROC_STATUS_RUNNING" />';
		var NO_RESULT = '<system:label show="text" label="lblNoRet" forScript="true" />';
		var RESET = '<system:edit show="value" from="theRequest" field="reset" />';
	</script></head><body><div class="body" id="bodyDiv"><div class="optionsContainer"><system:campaign inLogin="false" inSplash="false" location="verticalUp" /><div class="fncPanel info"><div class="title"><system:label show="text" label="titProRol" /><%@include file="../../../includes/adminFav.jsp" %></div><div class="content divFncDescription"><div class="fncDescriptionImage" data-src="<system:edit show="value" from="theBean" field="fncImage"/>"></div><div id="fncDescriptionText"><system:label show="text" label="dscFncCtrlProcRoll"/></div><div class="clear"></div></div></div><div class="fncPanel buttons"><div class="title"><system:label show="text" label="titActions"/></div><div class="content"><div id="btnTasks" class="button suggestedAction"><system:label show="text" label="btnMonTsk" /></div></div></div><div class="fncPanel options lastOptions"><div class="title" title="<system:label show="tooltip" label="titAdmAdtFilter"/>"><system:label show="text" label="titAdmAdtFilter"/></div><div class="content"><div class="filter"><span><system:label show="text" label="lblMonInstProAct" />:</span><select name="activityFilter" id="activityFilter" onchange="setFilter()" ><option></option><system:util show="prepareProcessActivity" saveOn="types" /><system:edit show="iteration" from="types" saveOn="type_save"><system:edit show="saveValue" from="type_save" field="type" saveOn="type"/><option value="<system:edit show="value" from="type_save" field="type"/>" <system:filter show="ifValue" filter="17" value="page:type">selected</system:filter>><system:edit show="value" from="type_save" field="typeName"/></option></system:edit></select></div><div class="filter"><span><system:label show="text" label="lblMonInstProCreDatEnt" />:</span><input id="createDateFilterStart" type="text" class="datePicker filterInputDate"   size="9" maxlength="10" value="<system:filter show="value" filter="4"></system:filter>"> 
						-
						<input id="createDateFilterEnd" type="text" class="datePicker filterInputDate"   size="9" maxlength="10" value="<system:filter show="value" filter="5"></system:filter>"></div></div></div><system:campaign inLogin="false" inSplash="false" location="verticalDown" /></div><div class="gridContainer"><system:campaign inLogin="false" inSplash="false" location="horizontalUp" /><div class="gridHeader" id="gridHeader"><!-- Cabezal y filtros --><table><thead><tr id="trOrderBy" class="header"><th id="orderByRegNumber" class="allowSort sort<system:filter show="sortStyle" from="com.dogma.vo.filter.MonitorProcessFilterVo" field="ORDER_PRO_NRO_REG"/>" data-sortBy="<system:edit show="constant" from="com.dogma.vo.filter.MonitorProcessFilterVo" field="ORDER_PRO_NRO_REG"/>" title="<system:label show="tooltip" label="lblMonInstProNroReg" />"><div style="width: 150px"><system:label show="text" label="lblMonInstProNroReg" /></div></th><th id="orderByTitle" class="allowSort sort<system:filter show="sortStyle" from="com.dogma.vo.filter.MonitorProcessFilterVo" field="ORDER_PRO_TITLE"/> required" data-sortBy="<system:edit show="constant" from="com.dogma.vo.filter.MonitorProcessFilterVo" field="ORDER_PRO_TITLE"/>" title="<system:label show="tooltip" label="lblProTit" />"><div style="width: 200px"><system:label show="text" label="lblProTit" /></div></th><th id="orderByAction" class="allowSort sort<system:filter show="sortStyle" from="com.dogma.vo.filter.MonitorProcessFilterVo" field="ORDER_PRO_ACTION"/> required" data-sortBy="<system:edit show="constant" from="com.dogma.vo.filter.MonitorProcessFilterVo" field="ORDER_PRO_ACTION"/>" title="<system:label show="tooltip" label="lblMonProAct" />"><div style="width: 140px"><system:label show="text" label="lblMonProAct" /></div></th><th id="orderByUser" class="allowSort sort<system:filter show="sortStyle" from="com.dogma.vo.filter.MonitorProcessFilterVo" field="ORDER_PRO_CREATE_USER"/>" data-sortBy="<system:edit show="constant" from="com.dogma.vo.filter.MonitorProcessFilterVo" field="ORDER_PRO_CREATE_USER"/>" title="<system:label show="tooltip" label="lblMonInstProCreUsu" />"><div style="width: 140px"><system:label show="text" label="lblMonInstProCreUsu" /></div></th></tr><tr class="filter"><th title="<system:label show="tooltip" label="lblMonInstProNroReg" />"><div style="width: 150px"><input id="numRegFilter" type="text" value="<system:filter show="value" filter="18"></system:filter>"></div></th><th title="<system:label show="tooltip" label="lblProTit" />"><div style="width: 200px"><select id="titleFilter" onchange="setFilter()" name="titleFilter" value="<system:filter show="value" filter="11"></system:filter>" style="width: 200px;"><option></option><system:util show="prepareProcessTitle" saveOn="proTitle" /><system:edit show="iteration" from="proTitle" saveOn="proTitle_save"><system:edit show="saveValue" from="proTitle_save" field="vTitle" saveOn="vTitle"/><option value="<system:edit show="value" from="proTitle_save" field="vTitle"/>" <system:filter show="ifValue" filter="11" value="page:vTitle">selected</system:filter> ><system:edit show="value" from="proTitle_save" field="tTitleName"/></option></system:edit></select></div></th><th title="<system:label show="text" label="lblMonProAct" />"><div style="width: 140px"><select name="actionFilter" id="actionFilter" onchange="setFilter()" ><option></option><system:util show="prepareProcessAction" saveOn="types" /><system:edit show="iteration" from="types" saveOn="type_save"><system:edit show="saveValue" from="type_save" field="type" saveOn="type"/><option value="<system:edit show="value" from="type_save" field="type"/>" <system:filter show="ifValue" filter="1" value="page:type">selected</system:filter> ><system:edit show="value" from="type_save" field="typeName"/></option></system:edit></select></div></th><th title="<system:label show="text" label="lblMonInstProCreUsu" />"><div style="width: 140px"><input id="userFilter" type="text" value="<system:filter show="value" filter="3"></system:filter>"></div></th></tr></thead></table></div><div class="gridBody" id="gridBody"><!-- Cuerpo de la tabla --><table><thead><tr><th width="150px"></th><th width="200px"></th><th width="140px"></th><th width="140px"></th></tr></thead><tbody class="tableData" id="tableData"></tbody></table></div><div class="gridFooter"><%@include file="../../../includes/navButtons.jsp" %></div><!-- MESSAGES --><div class="message hidden" id="messageContainer"></div><system:campaign inLogin="false" inSplash="false" location="horizontalDown" /></div></div><%@include file="../../../includes/footer.jsp" %></body></html>
