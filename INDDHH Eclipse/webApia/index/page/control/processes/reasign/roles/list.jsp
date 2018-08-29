<%@include file="../../../../includes/startInc.jsp" %><html><head><%@include file="../../../../includes/headInclude.jsp" %><link href="<system:util show="context" />/css/<system:util show="currentStyle" />/generalAdm.css" rel="stylesheet" type="text/css" ><link href="<system:util show="context" />/css/<system:util show="currentStyle" />/autocompleter.css" rel="stylesheet" type="text/css" ><script type="text/javascript" src="<system:util show="context" />/page/control/processes/reasign/roles/list.js"></script><script type="text/javascript" src="<system:util show="context" />/page/control/processes/reasign/roles/reasign.js"></script><script type="text/javascript" src="<system:util show="context" />/page/includes/navButtons.js"></script><script type="text/javascript" src="<system:util show="context" />/page/includes/adminFav.js"></script><script type="text/javascript" src="<system:util show="context" />/page/includes/campaigns.js"></script><script type="text/javascript" src="<system:util show="context" />/js/autocomplete/autocompleter.js"></script><script type="text/javascript" src="<system:util show="context" />/js/autocomplete/autocompleter.request.js"></script><script type="text/javascript" src="<system:util show="context" />/js/autocomplete/observer.js"></script><script type="text/javascript">
		var URL_REQUEST_AJAX 				= '/apia.control.ReasignRolesAction.run';
		var ADDITIONAL_INFO_IN_TABLE_DATA	= true;
		var ENV_ID							= '<system:edit show="value" from="theBean" field="envId" />';
		var MSG_NO_UNIQUE_MAPPING			= '<system:label show="text" label="msgUniqRolMap" />'
			var PRIMARY_SEPARATOR		= new Element('div').set('html', '<system:edit show="constant" from="com.st.util.StringUtil" field="PRIMARY_SEPARATOR"/>').get('text');
	</script></head><body><div class="header"></div><div class="body" id="bodyDiv"><div class="optionsContainer"><system:campaign inLogin="false" inSplash="false" location="verticalUp" /><div class="fncPanel info"><div class="title"><system:label show="tooltip" label="mnuReaRol" /><%@include file="../../../../includes/adminFav.jsp" %></div><div class="content divFncDescription"><div class="fncDescriptionImage" src="<system:edit show="value" from="theBean" field="fncImage"/>"></div><div id="fncDescriptionText"><system:label show="text" label="dscFncReaRol"/></div><div class="clear"></div></div></div><div class="fncPanel buttons"><div class="title"><system:label show="text" label="titActions"/></div><div class="content"><div id="btnReaRol" class="button suggestedAction" title="<system:label show="text" label="lblTskRea" />"><system:label show="text" label="lblTskRea" /></div></div></div><div class="fncPanel options lastOptions"><div class="title" title="<system:label show="tooltip" label="titAdmAdtFilter"/>"><system:label show="text" label="titAdmAdtFilter"/></div><div class="content"><div class="filter"><span><system:label show="tooltip" label="lblMonInstProAct" />:</span><select name="activityFilter" id="activityFilter" onchange="setFilter();"><option></option><system:util show="prepareProcessActivity" saveOn="types" /><system:edit show="iteration" from="types" saveOn="type_save"><system:edit show="saveValue" from="type_save" field="type" saveOn="type"/><option value="<system:edit show="value" from="type_save" field="type"/>" <system:filter show="ifValue" filter="17" value="page:type">selected</system:filter>><system:edit show="value" from="type_save" field="typeName"/></option></system:edit></select></div><div class="filter"><span><system:label show="tooltip" label="lblMonProPriority" />:</span><select name="priorityFilter" id="priorityFilter" onchange="setFilter();" ><option></option><system:util show="prepareProcessPriority" saveOn="types" /><system:edit show="iteration" from="types" saveOn="type_save"><system:edit show="saveValue" from="type_save" field="type" saveOn="type"/><option value="<system:edit show="value" from="type_save" field="type"/>" <system:filter show="ifValue" filter="12" value="page:type">selected</system:filter>><system:edit show="value" from="type_save" field="typeName"/></option></system:edit></select></div><div class="filter"><span><system:label show="text" label="lblMonInstProCreDatEnt" />:</span><input id="createDateFilterStart" type="text" class="datePicker filterInputDate" format="d/m/Y" size="9" maxlength="10" value="<system:filter show="value" filter="4"></system:filter>"> 
						-
						<input id="createDateFilterEnd" type="text" class="datePicker filterInputDate" format="d/m/Y" size="9" maxlength="10" value="<system:filter show="value" filter="5"></system:filter>"></div><div class="filter"><span><system:label show="text" label="lblMonInstProWarnDatEnt" />:</span><input id="alertDateFilterStart" type="text" class="datePicker filterInputDate" format="d/m/Y" size="9" maxlength="10" value="<system:filter show="value" filter="13"></system:filter>"> 
						-
						<input id="alertDateFilterEnd" type="text" class="datePicker filterInputDate" format="d/m/Y" size="9" maxlength="10" value="<system:filter show="value" filter="14"></system:filter>"></div><div class="filter"><span><system:label show="text" label="lblMonInstProOverdueDatEnt" />:</span><input id="overdueDateFilterStart" type="text" class="datePicker filterInputDate" format="d/m/Y" size="9" maxlength="10" value="<system:filter show="value" filter="15"></system:filter>"> 
						-
						<input id="overdueDateFilterEnd" type="text" class="datePicker filterInputDate" format="d/m/Y" size="9" maxlength="10" value="<system:filter show="value" filter="16"></system:filter>"></div></div></div><system:campaign inLogin="false" inSplash="false" location="verticalDown" /></div><div class="gridContainer"><system:campaign inLogin="false" inSplash="false" location="horizontalUp" /><div class="gridHeader" id="gridHeader"><!-- Cabezal y filtros --><table cellpadding="0" cellspacing="0"><thead><tr id="trOrderBy" class="header"><th id="orderByProPiority" class="allowSort sort<system:filter show="sortStyle" from="com.dogma.vo.filter.MonitorProcessFilterVo" field="ORDER_PRO_PRIORITY"/>" sortBy="<system:edit show="constant" from="com.dogma.vo.filter.MonitorProcessFilterVo" field="ORDER_PRO_PRIORITY"/>" title="<system:label show="tooltip" label="lblMonInstProNroReg" />"><div style="width: 30px">&nbsp;</div></th><th id="orderByRegNumber" class="allowSort sort<system:filter show="sortStyle" from="com.dogma.vo.filter.MonitorProcessFilterVo" field="ORDER_PRO_NRO_REG"/>" sortBy="<system:edit show="constant" from="com.dogma.vo.filter.MonitorProcessFilterVo" field="ORDER_PRO_NRO_REG"/>" title="<system:label show="tooltip" label="lblMonInstProNroReg" />"><div style="width: 120px"><system:label show="text" label="lblMonInstProNroReg" /></div></th><th id="orderByTitle" class="allowSort sort<system:filter show="sortStyle" from="com.dogma.vo.filter.MonitorProcessFilterVo" field="ORDER_PRO_TITLE"/>" sortBy="<system:edit show="constant" from="com.dogma.vo.filter.MonitorProcessFilterVo" field="ORDER_PRO_TITLE"/>" title="<system:label show="tooltip" label="lblProTit" />"><div style="width: 250px"><system:label show="text" label="lblProTit" /></div></th><th id="orderByAction" class="allowSort sort<system:filter show="sortStyle" from="com.dogma.vo.filter.MonitorProcessFilterVo" field="ORDER_PRO_ACTION"/>" sortBy="<system:edit show="constant" from="com.dogma.vo.filter.MonitorProcessFilterVo" field="ORDER_PRO_ACTION"/>" title="<system:label show="tooltip" label="lblAccPro" />"><div style="width: 130px"><system:label show="text" label="lblAccPro" /></div></th><th id="orderByCreateUser" class="allowSort sort<system:filter show="sortStyle" from="com.dogma.vo.filter.MonitorProcessFilterVo" field="ORDER_PRO_CREATE_USER"/>" sortBy="<system:edit show="constant" from="com.dogma.vo.filter.MonitorProcessFilterVo" field="ORDER_PRO_CREATE_USER"/>" title="<system:label show="tooltip" label="lblProTit" />"><div style="width: 130px"><system:label show="text" label="lblMonInstProCreUsu" /></div></th><th id="orderByDateCreate" class="allowSort sort<system:filter show="sortStyle" from="com.dogma.vo.filter.MonitorProcessFilterVo" field="ORDER_PRO_CREATE_DATE"/>" sortBy="<system:edit show="constant" from="com.dogma.vo.filter.MonitorProcessFilterVo" field="ORDER_PRO_CREATE_DATE"/>" title="<system:label show="tooltip" label="lblProTit" />"><div style="width: 130px"><system:label show="text" label="lblMonInstProCreDat" /></div></th></tr><tr class="filter"><th><div style="width: 30px"></div></th><th title="<system:label show="tooltip" label="lblMonInstProNroReg" />"><div style="width: 120px"><input id="numRegFilter" type="text" value="<system:filter show="value" filter="18"></system:filter>"></div></th><th title="<system:label show="text" label="lblProTit" />"><div style="width: 250px"><select name="titleFilter" id="titleFilter" onchange="setFilter();"><option></option><system:util show="prepareProcessTitle" saveOn="processes" /><system:edit show="iteration" from="processes" saveOn="process"><system:edit show="saveValue" from="process" field="vTitle" saveOn="vTitle"/><option value="<system:edit show="value" from="process" field="vTitle"/>" <system:filter show="ifValue" filter="11" value="page:vTitle">selected</system:filter>><system:edit show="value" from="process" field="tTitleName"/></option></system:edit></select></div></th><th title="<system:label show="text" label="lblAccPro" />"><div style="width: 130px"><select name="actionFilter" id="actionFilter" onchange="setFilter();" ><option></option><system:util show="prepareProcessAction" saveOn="types" /><system:edit show="iteration" from="types" saveOn="type_save"><system:edit show="saveValue" from="type_save" field="type" saveOn="type"/><option value="<system:edit show="value" from="type_save" field="type"/>" <system:filter show="ifValue" filter="1" value="page:type">selected</system:filter>><system:edit show="value" from="type_save" field="typeName"/></option></system:edit></select></div></th><th><div style="width: 130px"><input id="userFilter" type="text" value="<system:filter show="value" filter="3"></system:filter>"></div></th><th><div style="width: 130px"></div></th></tr></thead></table></div><div class="gridBody" id="gridBody"><!-- Cuerpo de la tabla --><table cellpadding="0" cellspacing="0"><thead><tr><th width="30px"></th><th width="120px"></th><th width="250px"></th><th width="130px"></th><th width="130px"></th><th width="130px"></th></tr></thead><tbody class="tableData" id="tableData"></tbody></table></div><div class="gridFooter"><%@include file="../../../../includes/navButtons.jsp" %></div><system:campaign inLogin="false" inSplash="false" location="horizontalDown" /></div></div><%@include file="reasign.jsp" %><%@include file="../../../../includes/footer.jsp" %></body></html>
