<%@page import="com.st.util.labels.LabelManager"%><%@include file="../../includes/startInc.jsp" %><html lang="<%=biz.statum.apia.web.bean.BasicBeanStatic.getUserDataStatic(request).getLangCode()%>"><head><%@include file="../../includes/headInclude.jsp" %><script type="text/javascript" src="<system:util show="context" />/page/monitor/processes/list.js"></script><script type="text/javascript" src="<system:util show="context" />/page/includes/navButtons.js"></script><script type="text/javascript" src="<system:util show="context" />/page/includes/adminFav.js"></script><script type="text/javascript" src="<system:util show="context" />/page/includes/campaigns.js"></script><script type="text/javascript">
		var URL_REQUEST_AJAX = '/apia.monitor.ProcessesAction.run';
		var ADDITIONAL_INFO_IN_TABLE_DATA  = true;		
		var BACK = '<system:edit show="value" from="theRequest" field="back" />';
		
		var MON_DOC_TAB_TITLE 				= '<system:label show="text" label="mnuMonDoc"/>';
		var URL_REQUEST_AJAX_MON_DOCUMENT 	= '/apia.monitor.MonitorDocumentAction.run';
		var PRIMARY_SEPARATOR		= new Element('div').set('html', '<system:edit show="constant" from="com.st.util.StringUtil" field="PRIMARY_SEPARATOR"/>').get('text');
		
		/*window.addEvent('load', function() {
			$('panelPinHidde').fireEvent('click');
		});*/
	</script></head><body><div class="body" id="bodyDiv"><div class="optionsContainer" id="optionsContainer"><system:campaign inLogin="false" inSplash="false" location="verticalUp" /><div class="fncPanel info"><div class="title"><span><system:label show="text" label="titMon" /></span><span class="panelPinShow" id="panelPinShow">&nbsp;</span><span class="panelPinHidde" id="panelPinHidde">&nbsp;</span><%@include file="../../includes/adminFav.jsp" %></div><div class="content divFncDescription"><div class="fncDescriptionImage" data-src="<system:edit show="value" from="theBean" field="fncImage"/>"></div><div id="fncDescriptionText"><system:label show="text" label="dscFncProcMon"/></div><div class="clear"></div></div></div><div class="fncPanel buttons"><div class="title"><system:label show="text" label="titActions"/></div><div class="content"><div id="btnTasks" class="button suggestedAction" title="<system:label show="tooltip" label="btnMonTsk" />"><system:label show="text" label="btnMonTsk" /></div><div id="btnDetails" class="button" title="<system:label show="tooltip" label="btnMonDet" />"><system:label show="text" label="btnMonDet" /></div><div id="btnDocuments" class="button" title="<system:label show="tooltip" label="btnViewDocs" />"><system:label show="text" label="btnViewDocs" /></div><div id="btnExport" class="button" title="<system:label show="tooltip" label="btnExport" />"><system:label show="text" label="btnExport" /></div><div id="btnCloseTab" class="button" title="<system:label show="tooltip" label="btnClose" />"><system:label show="text" label="btnClose" /></div></div></div><div class="fncPanel options lastOptions"><div class="title" title="<system:label show="tooltip" label="titAdmAdtFilter"/>"><system:label show="text" label="titAdmAdtFilter"/></div><div class="content"><div class="filter"><span><system:label show="text" label="lblMonInstProAct" />:</span><select name="activityFilter" id="activityFilter" onchange="setFilter()"><option label=" "></option><system:util show="prepareProcessActivity" saveOn="types" /><system:edit show="iteration" from="types" saveOn="type_save"><system:edit show="saveValue" from="type_save" field="type" saveOn="type"/><option value="<system:edit show="value" from="type_save" field="type"/>" <system:filter show="ifValue" filter="17" value="page:type">selected</system:filter>><system:edit show="value" from="type_save" field="typeName"/></option></system:edit></select></div><div class="filter"><span><system:label show="text" label="lblMonProAct" />:</span><select name="actionFilter" id="actionFilter" onchange="setFilter()" ><option label=" "></option><system:util show="prepareProcessAction" saveOn="types" /><system:edit show="iteration" from="types" saveOn="type_save"><system:edit show="saveValue" from="type_save" field="type" saveOn="type"/><option value="<system:edit show="value" from="type_save" field="type"/>" <system:filter show="ifValue" filter="1" value="page:type">selected</system:filter>><system:edit show="value" from="type_save" field="typeName"/></option></system:edit></select></div><div class="filter"><span><system:label show="text" label="lblMonInstProSta" />:</span><select name="statusFilter" id="statusFilter" onchange="setFilter()" ><option label=" "></option><system:util show="prepareProcessStatus" saveOn="types" /><system:edit show="iteration" from="types" saveOn="type_save"><system:edit show="saveValue" from="type_save" field="type" saveOn="type"/><option value="<system:edit show="value" from="type_save" field="type"/>" <system:filter show="ifValue" filter="2" value="page:type">selected</system:filter>><system:edit show="value" from="type_save" field="typeName"/></option></system:edit></select></div><div class="filter"><span><system:label show="text" label="lblMonProPriority" />:</span><select name="priorityFilter" id="priorityFilter" onchange="setFilter()" ><option label=" "></option><system:util show="prepareProcessPriority" saveOn="types" /><system:edit show="iteration" from="types" saveOn="type_save"><system:edit show="saveValue" from="type_save" field="type" saveOn="type"/><option value="<system:edit show="value" from="type_save" field="type"/>" <system:filter show="ifValue" filter="12" value="page:type">selected</system:filter>><system:edit show="value" from="type_save" field="typeName"/></option></system:edit></select></div><div class="filter"><span><system:label show="text" label="lblMonInstProCreDatEnt" />:</span><input id="createDateFilterStart" type="text" class="datePicker filterInputDate"  size="9" maxlength="10" value="<system:filter show="value" filter="4"></system:filter>"> 
						-
						<input id="createDateFilterEnd" type="text" class="datePicker filterInputDate"  size="9" maxlength="10" value="<system:filter show="value" filter="5"></system:filter>"></div><div class="filter"><span><system:label show="text" label="lblMonInstProEndDatEnt" />:</span><input id="endDateFilterStart" type="text" class="datePicker filterInputDate"  size="9" maxlength="10" value="<system:filter show="value" filter="6"></system:filter>"> 
						-
						<input id="endDateFilterEnd" type="text" class="datePicker filterInputDate"  size="9" maxlength="10" value="<system:filter show="value" filter="7"></system:filter>"></div><div class="filter"><span><system:label show="text" label="lblMonInstProWarnDatEnt" />:</span><input id="alertDateFilterStart" type="text" class="datePicker filterInputDate"  size="9" maxlength="10" value="<system:filter show="value" filter="13"></system:filter>"> 
						-
						<input id="alertDateFilterEnd" type="text" class="datePicker filterInputDate"  size="9" maxlength="10" value="<system:filter show="value" filter="14"></system:filter>"></div><div class="filter"><span><system:label show="text" label="lblMonInstProOverdueDatEnt" />:</span><input id="overdueDateFilterStart" type="text" class="datePicker filterInputDate"  size="9" maxlength="10" value="<system:filter show="value" filter="15"></system:filter>"> 
						-
						<input id="overdueDateFilterEnd" type="text" class="datePicker filterInputDate"  size="9" maxlength="10" value="<system:filter show="value" filter="16"></system:filter>"></div></div></div><system:campaign inLogin="false" inSplash="false" location="verticalDown" /></div><div class="gridContainer" id="gridContainer"><system:campaign inLogin="false" inSplash="false" location="horizontalUp" /><div class="gridHeader" id="gridHeader"><!-- Cabezal y filtros --><table><thead><tr id="trOrderBy" class="header"><th id="orderByProPiority" class="allowSort sort<system:filter show="sortStyle" from="com.dogma.vo.filter.MonitorProcessFilterVo" field="ORDER_PRO_PRIORITY"/>" data-sortBy="<system:edit show="constant" from="com.dogma.vo.filter.MonitorProcessFilterVo" field="ORDER_PRO_PRIORITY"/>" title="<system:label show="tooltip" label="lblMonInstProNroReg" />"><div style="width: 30px">&nbsp;</div></th><th id="orderByRegNumber" class="allowSort sort<system:filter show="sortStyle" from="com.dogma.vo.filter.MonitorProcessFilterVo" field="ORDER_PRO_NRO_REG"/>" data-sortBy="<system:edit show="constant" from="com.dogma.vo.filter.MonitorProcessFilterVo" field="ORDER_PRO_NRO_REG"/>" title="<system:label show="tooltip" label="lblMonInstProNroReg" />"><div style="width: 120px"><system:label show="text" label="lblMonInstProNroReg" /></div></th><th id="orderByTitle" class="allowSort sort<system:filter show="sortStyle" from="com.dogma.vo.filter.MonitorProcessFilterVo" field="ORDER_PRO_TITLE"/>" data-sortBy="<system:edit show="constant" from="com.dogma.vo.filter.MonitorProcessFilterVo" field="ORDER_PRO_TITLE"/>" title="<system:label show="tooltip" label="lblProTit" />"><div style="width: 250px"><system:label show="text" label="lblProTit" /></div></th><th id="orderByCreateUser" class="allowSort sort<system:filter show="sortStyle" from="com.dogma.vo.filter.MonitorProcessFilterVo" field="ORDER_PRO_CREATE_USER"/>" data-sortBy="<system:edit show="constant" from="com.dogma.vo.filter.MonitorProcessFilterVo" field="ORDER_PRO_CREATE_USER"/>" title="<system:label show="tooltip" label="lblMonInstProCreUsu" />"><div style="width: 130px"><system:label show="text" label="lblMonInstProCreUsu" /></div></th><th id="orderByDateCreate" class="allowSort sort<system:filter show="sortStyle" from="com.dogma.vo.filter.MonitorProcessFilterVo" field="ORDER_PRO_CREATE_DATE"/>" data-sortBy="<system:edit show="constant" from="com.dogma.vo.filter.MonitorProcessFilterVo" field="ORDER_PRO_CREATE_DATE"/>" title="<system:label show="tooltip" label="lblMonInstProCreDat" />"><div style="width: 130px"><system:label show="text" label="lblMonInstProCreDat" /></div></th><th id="orderByDateEnd" class="allowSort sort<system:filter show="sortStyle" from="com.dogma.vo.filter.MonitorProcessFilterVo" field="ORDER_PRO_END_DATE"/>" data-sortBy="<system:edit show="constant" from="com.dogma.vo.filter.MonitorProcessFilterVo" field="ORDER_PRO_END_DATE"/>" title="<system:label show="tooltip" label="lblMonInstProEndDat" />"><div style="width: 130px"><system:label show="text" label="lblMonInstProEndDat" /></div></th></tr><tr class="filter"><th><div style="width: 30px"></div></th><th title="<system:label show="tooltip" label="lblMonInstProNroReg" />"><div style="width: 120px"><input id="numRegFilter" autofocus type="text" value="<system:filter show="value" filter="18"></system:filter>"></div></th><th title="<system:label show="text" label="lblProTit" />"><div style="width: 250px"><select name="titleFilter" id="titleFilter" onchange="setFilter()"><option></option><system:util show="prepareProcessTitle" saveOn="processes" /><system:edit show="iteration" from="processes" saveOn="process"><system:edit show="saveValue" from="process" field="vTitle" saveOn="vTitle"/><option value="<system:edit show="value" from="process" field="additionalInfo2"/>" <system:filter show="ifValue" filter="11" value="page:vTitle">selected</system:filter>><system:edit show="value" from="process" field="tTitleName"/></option></system:edit></select></div></th><th><div style="width: 130px"><input id="userFilter" type="text" value="<system:filter show="value" filter="3"></system:filter>"></div></th><th><div style="width: 130px"></div></th><th><div style="width: 130px"></div></th></tr></thead></table></div><div class="gridBody" id="gridBody"><!-- Cuerpo de la tabla --><table><thead><tr><th style="width: 30px"></th><th style="width: 120px"></th><th style="width: 250px"></th><th style="width: 130px"></th><th style="width: 130px"></th><th style="width: 130px"></th></tr></thead><tbody class="tableData" id="tableData"></tbody></table></div><div class="gridFooter"><%@include file="../../includes/navButtons.jsp" %></div><system:campaign inLogin="false" inSplash="false" location="horizontalDown" /></div></div><%@include file="../../includes/footer.jsp" %></body></html>
