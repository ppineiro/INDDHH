<%@page import="com.st.util.translator.TranslationManager"%><%@include file="../../includes/startInc.jsp" %><html lang="<%=biz.statum.apia.web.bean.BasicBeanStatic.getUserDataStatic(request).getLangCode()%>"><head><%@include file="../../includes/headInclude.jsp" %><script type="text/javascript" src="<system:util show="context" />/page/design/translations/list.js"></script><script type="text/javascript" src="<system:util show="context" />/page/includes/adminFav.js"></script><script type="text/javascript" src="<system:util show="context" />/page/includes/navButtons.js"></script><script type="text/javascript" src="<system:util show="context" />/page/includes/campaigns.js"></script><script type="text/javascript">
		var URL_REQUEST_AJAX = '/apia.design.TranslationsAction.run';
		var ADDITIONAL_INFO_IN_TABLE_DATA  = false;
	</script></head><body><div class="body" id="bodyDiv"><div class="optionsContainer"><system:campaign inLogin="false" inSplash="false" location="verticalUp" /><div class="fncPanel info"><div class="title"><system:label show="text" label="mnuTrans" /><%@include file="../../includes/adminFav.jsp" %></div><div class="content divFncDescription"><div class="fncDescriptionImage" data-src="<system:edit show="value" from="theBean" field="fncImage"/>"></div><div id="fncDescriptionText"><system:label show="text" label="dscFncAdmTrans"/></div><div class="clear"></div></div></div><div class="fncPanel buttons"><div class="title"><system:label show="text" label="titActions"/></div><div class="content"><div id="btnTrans" class="button suggestedAction" title="<system:label show="tooltip" label="btnTrans" />"><system:label show="text" label="btnTrans" /></div></div></div><div class="fncPanel options"><div class="title"><system:label show="text" label="mnuOpc" /></div><div class="content"><div id="optionUpload" class="button" title="<system:label show="tooltip" label="btnUpl"/>"><system:label show="text" label="btnUpl"/></div><div id="optionDownload" class="button" title="<system:label show="tooltip" label="btnDow"/>"><system:label show="text" label="btnDow"/></div><div class="clear"></div><% if (TranslationManager.isRecording()){ %><div id="btnStopTraRec" class="button extendedSize" title="<system:label show="tooltip" label="btnStopTraRec" />"><system:label show="text" label="btnStopTraRec" /></div><% } else { %><div id="btnStartTraRec" class="button extendedSize" title="<system:label show="tooltip" label="btnStartTraRec" />"><system:label show="text" label="btnStartTraRec" /></div><% } %></div><div class="clear"></div></div><div class="fncPanel options lastOptions"><div class="title"><system:label show="text" label="mnuLeyends" /></div><div class="content"><div class="priority2"><system:label show="text" label="lblTranslateComplete"/></div><div class="priority1"><system:label show="text" label="lblTranslateIncomplete"/></div><div class="priority3"><system:label show="text" label="lblTranslateNotDone"/></div><div class="clear"></div></div><div class="clear"></div></div><system:campaign inLogin="false" inSplash="false" location="verticalDown" /></div><div class="gridContainer"><system:campaign inLogin="false" inSplash="false" location="horizontalUp" /><div class="gridHeader" id="gridHeader"><!-- Cabezal y filtros --><table><thead><tr id="trOrderBy" class="header"><th id="orderByType"  title="<system:label show="tooltip" label="lblTraType" />"><div style="width: 200px"><system:label show="text" label="lblTraType"/></div></th><th id="orderById" class="allowSort sort<system:filter show="sortStyle" from="com.dogma.vo.filter.TranslationFilter" field="ORDER_OBJECT_ID"/>" data-sortBy="<system:edit show="constant" from="com.dogma.vo.filter.TranslationFilter" field="ORDER_OBJECT_ID"/>" title="<system:label show="tooltip" label="lblTraObjId" />"><div style="width: 200px"><system:label show="text" label="lblTraObjId" /></div></th><th id="orderByName" class="allowSort sort<system:filter show="sortStyle" from="com.dogma.vo.filter.TranslationFilter" field="ORDER_NAME"/>" data-sortBy="<system:edit show="constant" from="com.dogma.vo.filter.TranslationFilter" field="ORDER_NAME"/>" title="<system:label show="tooltip" label="lblTraObjName" />"><div style="width: 200px"><system:label show="text" label="lblTraObjName" /></div></th><th id="orderByStatus" class="allowSort sort<system:filter show="sortStyle" from="com.dogma.vo.filter.TranslationFilter" field="ORDER_STATUS"/>" data-sortBy="<system:edit show="constant" from="com.dogma.vo.filter.TranslationFilter" field="ORDER_STATUS"/>" title="<system:label show="tooltip" label="lblTraStatus" />"><div style="width: 100px"><system:label show="text" label="lblTraStatus" /></div></th></tr><tr class="filter"><th title="<system:label show="tooltip" label="lblTraType" />"><div style="width: 200px"><select name="typeFilter" id="typeFilter" onchange="setFilter()" ><option></option><system:util show="prepareTranslationTypes" saveOn="types" /><system:edit show="iteration" from="types" saveOn="type_save"><system:edit show="saveValue" from="type_save" field="value" saveOn="type"/><option value="<system:edit show="value" from="type_save" field="value"/>" <system:filter show="ifValue" filter="2" value="page:type">selected</system:filter>><system:edit show="value" from="type_save" field="text"/></option></system:edit></select></div></th><th title="<system:label show="tooltip" label="lblTraObjId" />"><div style="width: 200px"><input id="idFilter" type="text" value="<system:filter show="value" filter="1"></system:filter>"></div></th><th title="<system:label show="tooltip" label="lblTraObjName" />"><div style="width: 200px"><input id="objNameFilter" type="text" value="<system:filter show="value" filter="3"></system:filter>"></div></th><th title="<system:label show="tooltip" label="lblTraStatus" />"><div style="width: 100px"></div></th></tr></thead></table></div><div class="gridBody" id="gridBody"><!-- Cuerpo de la tabla --><table><thead><tr><th width="200px"></th><th width="200px"></th><th width="200px"></th><th width="100px"></th></tr></thead><tbody class="tableData" id="tableData"></tbody></table></div><div class="gridFooter"><%@include file="../../includes/navButtons.jsp" %></div><!-- MESSAGES --><div class="message hidden" id="messageContainer"></div><system:campaign inLogin="false" inSplash="false" location="horizontalDown" /></div></div><%@include file="../../includes/footer.jsp" %></body></html>
