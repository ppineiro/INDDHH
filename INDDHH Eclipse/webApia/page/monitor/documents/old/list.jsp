<%@include file="../../../includes/startInc.jsp" %><html lang="<%=biz.statum.apia.web.bean.BasicBeanStatic.getUserDataStatic(request).getLangCode()%>"><head><%@include file="../../../includes/headInclude.jsp" %><script type="text/javascript" src="<system:util show="context" />/page/monitor/documents/old/list.js"></script><script type="text/javascript" src="<system:util show="context" />/page/includes/navButtons.js"></script><script type="text/javascript" src="<system:util show="context" />/page/includes/adminFav.js"></script><script type="text/javascript" src="<system:util show="context" />/page/includes/campaigns.js"></script><script type="text/javascript">
		var UNLOCK = <%=request.getParameter("unlock")%>;
		var FNC_DESCRIPTION;
		<%if (request.getParameter("unlock") == null) {%>
		var FNC_DESCRIPTION = '<system:label show="text" label="dscFncDocMon" forScript="true" />';
		<%} else { %>
		var FNC_DESCRIPTION = '<system:label show="text" label="dscFncUnDocCtrl" forScript="true" />';
		<%} %>
		var URL_REQUEST_AJAX = '/apia.monitor.old.MonitorDocumentsAction.run';
		var ADDITIONAL_INFO_IN_TABLE_DATA  = true;
		var DOC_INDEX = <%=com.dogma.Parameters.DOC_INDEX_ACTIVE%>;
		var INST_PROC = "<%=com.dogma.vo.DocumentVo.DOC_TYPE_PROCESS_INST%>"; 
		var INST_ENT = "<%=com.dogma.vo.DocumentVo.DOC_TYPE_BUS_ENT_INST%>";		
	</script></head><body><div class="body" id="bodyDiv"><div class="optionsContainer"><system:campaign inLogin="false" inSplash="false" location="verticalUp" /><div class="fncPanel info"><div class="title"><%if (request.getParameter("unlock") == null) {%><system:label show="tooltip" label="mnuMonDoc" /><%} else { %><system:label show="tooltip" label="mnuConUnDoc" /><%} %><%@include file="../../../includes/adminFav.jsp" %></div><div class="content divFncDescription"><div class="fncDescriptionImage" data-src="<system:edit show="value" from="theBean" field="fncImage"/>"></div><div id="fncDescriptionText"><system:label show="text" label="dscFncDocMon"/></div><div class="clear"></div></div></div><div class="fncPanel options"><div class="title"><system:label show="text" label="titActions"/></div><div class="content"><%if (request.getParameter("unlock") == null) {%><div id="btnInfo" class="button suggestedAction submit validate['submit']" title="<system:label show="tooltip" label="btnInfo" />"><system:label show="tooltip" label="btnInfo" /></div><div id="btnHist" class="button submit validate['submit']" title="<system:label show="tooltip" label="btnHis" />"><system:label show="tooltip" label="btnHis" /></div><div id="btnDown" class="button submit validate['submit']" title="<system:label show="tooltip" label="btnDow" />"><system:label show="tooltip" label="btnDow" /></div><%} else {%><div id="btnUnlock" class="button suggestedAction submit validate['submit']" title="<system:label show="tooltip" label="btnUnLock" />"><system:label show="tooltip" label="btnUnLock" /></div><%}%></div></div><div class="fncPanel options lastOptions"><div class="title" title="<system:label show="tooltip" label="titAdmAdtFilter"/>"><system:label show="text" label="titAdmAdtFilter"/></div><div class="content"><div class="filter"><span><system:label show="text" label="lblDes"/>:</span><input type="text" id="descFilter" name="descFilter"></div><div class="filter"><span><system:label show="text" label="docTit"/>:</span><input type="text" id="titleFilter" name="titleFilter"></div><div class="filter"><span><system:label show="text" label="lblMonInstProNroReg"/>:</span><input type="text" id="instFilter" name="instFilter"></div><div class="filter" id="divContent"><%if (com.dogma.Parameters.DOC_INDEX_ACTIVE) {%><span><system:label show="tooltip" label="lblContent" />:</span><%}%><input <%if (com.dogma.Parameters.DOC_INDEX_ACTIVE) {%>type="text"<%} else {%> type="hidden" <%}%> id="contentFilter" name="contentFilter"></div></div></div><system:campaign inLogin="false" inSplash="false" location="verticalDown" /></div><div class="gridContainer"><system:campaign inLogin="false" inSplash="false" location="horizontalUp" /><div class="gridHeader" id="gridHeader"><!-- Cabezal y filtros --><table><thead><tr id="trOrderBy" class="header"><th id="orderByName" class="allowSort sort<system:filter show="sortStyle" from="com.dogma.vo.filter.MonitorDocumentFilterVo" field="ORDER_NAME"/>" data-sortBy="<system:edit show="constant" from="com.dogma.vo.filter.MonitorDocumentFilterVo" field="ORDER_NAME"/>" title="<system:label show="tooltip" label="lblNom" />"><div style="width: 200px"><system:label show="text" label="lblNom" /></div></th><th id="orderBySize" class="allowSort sort<system:filter show="sortStyle" from="com.dogma.vo.filter.MonitorDocumentFilterVo" field="ORDER_SIZE"/>" data-sortBy="<system:edit show="constant" from="com.dogma.vo.filter.MonitorDocumentFilterVo" field="ORDER_SIZE"/>" title="<system:label show="tooltip" label="lblTam" />"><div style="width: 200px"><system:label show="text" label="lblTam"/></div></th><th id="orderByDocType" class="allowSort sort<system:filter show="sortStyle" from="com.dogma.vo.filter.MonitorDocumentFilterVo" field="ORDER_TYPE"/>" data-sortBy="<system:edit show="constant" from="com.dogma.vo.filter.MonitorDocumentFilterVo" field="ORDER_TYPE"/>" title="<system:label show="tooltip" label="lblFrom" />"><div style="width: 200px"><system:label show="text" label="lblFrom"/></div></th><th id="orderByRegUser" class="allowSort sort<system:filter show="sortStyle" from="com.dogma.vo.filter.MonitorDocumentFilterVo" field="ORDER_USER"/>" data-sortBy="<system:edit show="constant" from="com.dogma.vo.filter.MonitorDocumentFilterVo" field="ORDER_USER"/>" title="<system:label show="tooltip" label="lblLastUsrName" />"><div style="width: 100px"><system:label show="text" label="lblLastUsrName" /></div></th><th id="orderByRegDate" class="allowSort sort<system:filter show="sortStyle" from="com.dogma.vo.filter.MonitorDocumentFilterVo" field="ORDER_DATE"/>" data-sortBy="<system:edit show="constant" from="com.dogma.vo.filter.MonitorDocumentFilterVo" field="ORDER_DATE"/>" title="<system:label show="tooltip" label="lblLastActDate" />"><div style="width: 100px"><system:label show="text" label="lblLastActDate" /></div></th></tr><tr class="filter"><th title="<system:label show="tooltip" label="lblNom" />"><div style="width: 200px"><input id="nameFilter" type="text" value="<system:filter show="value" filter="0"></system:filter>"></div></th><th title="<system:label show="tooltip" label="lblTam" />"><div style="width: 200px"><input id="sizeMinFilter" size="5" style="width:40%" type="text" value="<system:filter show="value" filter="3"></system:filter>"> - <input id="sizeMaxFilter" size="5" style="width:40%" type="text" value="<system:filter show="value" filter="8"></system:filter>"></div></th><th title="<system:label show="tooltip" label="lblFrom" />"><div style="width: 200px"><select id="cmbDocType" onchange="enableDisableFilters(this);setFilter()" name="cmbDocType" value="<system:filter show="value" filter="4"></system:filter>"><option></option><system:util show="prepareDocumentsDocType" saveOn="docType" /><system:edit show="iteration" from="docType" saveOn="docType_save"><system:edit show="saveValue" from="docType_save" field="docType" saveOn="docType"/><option value="<system:edit show="value" from="docType_save" field="docType"/>"><system:edit show="value" from="docType_save" field="docTypeName"/></option></system:edit></select></div></th><th title="<system:label show="tooltip" label="lblLastUsrName" />"><div style="width: 100px"><input id="regUsrFilter" type="text" value="<system:filter show="value" filter="5"></system:filter>"></div></th><th title="<system:label show="tooltip" label="lblLastActDate" />"><div style="width: 100px"><input id="regDateFilter" type="text" class="datePicker filterInputDate"  value="<system:filter show="value" filter="6"></system:filter>"></div></th></tr></thead></table></div><div class="gridBody" id="gridBody"><!-- Cuerpo de la tabla --><table><thead><tr><th width="200px"></th><th width="200px"></th><th width="200px"></th><th width="100px"></th><th width="100px"></th></tr></thead><tbody class="tableData" id="tableData"></tbody></table></div><div class="gridFooter"><%@include file="../../../includes/navButtons.jsp" %></div><system:campaign inLogin="false" inSplash="false" location="horizontalDown" /></div></div><%@include file="../../../includes/footer.jsp" %></body></html>
