<%@page import="com.dogma.vo.BusClassVo"%><%@page import="com.st.util.labels.LabelManager"%><%@page import="com.dogma.vo.AttributeVo"%><%@include file="../../includes/startInc.jsp" %><html lang="<%=biz.statum.apia.web.bean.BasicBeanStatic.getUserDataStatic(request).getLangCode()%>"><head><%@include file="../../includes/headInclude.jsp" %><script type="text/javascript" src="<system:util show="context" />/page/design/businessclasses/list.js"></script><script type="text/javascript" src="<system:util show="context" />/page/includes/adminFav.js"></script><script type="text/javascript" src="<system:util show="context" />/page/includes/adminActions.js"></script><script type="text/javascript" src="<system:util show="context" />/page/includes/navButtons.js"></script><script type="text/javascript" src="<system:util show="context" />/page/includes/campaigns.js"></script><script type="text/javascript">
		var URL_REQUEST_AJAX = '/apia.design.BusinessClassesAction.run';
		var ADDITIONAL_INFO_IN_TABLE_DATA  = true;
		var MSG_NO_UPDATE_WS_PUB	= '<system:label show="text" label="msgNoUpBusClaWsPub" />';
	</script></head><body><div class="body" id="bodyDiv"><div class="optionsContainer"><system:campaign inLogin="false" inSplash="false" location="verticalUp" /><div class="fncPanel info"><div class="title"><system:label show="text" label="mnuClaNeg" /><%@include file="../../includes/adminFav.jsp" %></div><div class="content divFncDescription"><div class="fncDescriptionImage" data-src="<system:edit show="value" from="theBean" field="fncImage"/>"></div><div id="fncDescriptionText"><system:label show="text" label="dscFncAdmBusCla"/></div><div class="clear"></div></div></div><%@include file="../../includes/adminActions.jsp" %><div class="fncPanel buttons"><div class="title"><system:label show="text" label="mnuOpc" /></div><div class="content"><div id="btnEnaDis" class="button extendedSize" title="<system:label show="tooltip" label="btnEnaDis" />"><system:label show="text" label="btnEnaDis" /></div><div id="btnTest" class="button extendedSize" title="<system:label show="tooltip" label="btnTestAllClass" />"><system:label show="text" label="btnTestAllClass" /></div><div id="btnUpCre" class="button extendedSize" title="<system:label show="tooltip" label="btnUpl" />"><system:label show="text" label="btnUpl" /></div></div></div><div class="fncPanel options lastOptions"><div class="title" title="<system:label show="tooltip" label="titAdmAdtFilter"/>"><system:label show="text" label="titAdmAdtFilter"/></div><div class="content"><div class="filter"><span><system:label show="text" label="titPrj" />:</span><select name="projectFilter" id="projectFilter" onchange="setFilter()" value="<system:filter show="value" filter="7"></system:filter>" ><option></option><system:util show="prepareProjects" saveOn="projects" /><system:edit show="iteration" from="projects" saveOn="project"><system:edit show="saveValue" from="project" field="prjId" saveOn="projectsave"/><option value="<system:edit show="value" from="project" field="prjId"/>" <system:filter show="ifValue" filter="7" value="with:prjId">selected</system:filter>><system:edit show="value" from="project" field="prjTitle"/></option></system:edit></select></div><div class="filter"><span><system:label show="text" label="lblTipCla" />:</span><select name="typeFilter" id="typeFilter" onchange="setFilter()"><option></option><system:util show="prepareTypeBusinessClasses" saveOn="types" /><system:edit show="iteration" from="types" saveOn="type_save"><system:edit show="saveValue" from="type_save" field="type" saveOn="type"/><option value="<system:edit show="value" from="type_save" field="type"/>" <system:filter show="ifValue" filter="2" value="page:type">selected</system:filter> ><system:edit show="value" from="type_save" field="typeName"/></option></system:edit></select></div></div></div><system:campaign inLogin="false" inSplash="false" location="verticalDown" /></div><div class="gridContainer"><system:campaign inLogin="false" inSplash="false" location="horizontalUp" /><div class="gridHeader" id="gridHeader"><!-- Cabezal y filtros --><table><thead><tr id="trOrderBy" class="header"><th id="orderByPerm" title="<system:label show="tooltip" label="lblPerm" />"><div style="width: 30px">&nbsp;</div></th><th id="orderByName" class="allowSort sort<system:filter show="sortStyle" from="com.dogma.vo.filter.BusClassFilterVo" field="ORDER_NAME"/>" data-sortBy="<system:edit show="constant" from="com.dogma.vo.filter.BusClassFilterVo" field="ORDER_NAME"/>" title="<system:label show="tooltip" label="lblNom" />"><div style="width: 200px"><system:label show="text" label="lblNom"/></div></th><th id="orderByDesc" class="allowSort sort<system:filter show="sortStyle" from="com.dogma.vo.filter.BusClassFilterVo" field="ORDER_DESC"/>" data-sortBy="<system:edit show="constant" from="com.dogma.vo.filter.BusClassFilterVo" field="ORDER_DESC"/>" title="<system:label show="tooltip" label="lblDesc" />"><div style="width: 200px"><system:label show="text" label="lblDesc" /></div></th><th id="orderByExecutable" class="allowSort sort<system:filter show="sortStyle" from="com.dogma.vo.filter.BusClassFilterVo" field="ORDER_EXECUTABLE"/>" data-sortBy="<system:edit show="constant" from="com.dogma.vo.filter.BusClassFilterVo" field="ORDER_EXECUTABLE"/>" title="<system:label show="tooltip" label="lblEje" />"><div style="width: 200px"><system:label show="text" label="lblEje" /></div></th><th id="orderByRegUser" class="allowSort sort<system:filter show="sortStyle" from="com.dogma.vo.filter.BusClassFilterVo" field="ORDER_USER"/>" data-sortBy="<system:edit show="constant" from="com.dogma.vo.filter.BusClassFilterVo" field="ORDER_USER"/>" title="<system:label show="tooltip" label="lblLastUsrName" />"><div style="width: 100px"><system:label show="text" label="lblLastUsrName" /></div></th><th id="orderByRegDate" class="allowSort sort<system:filter show="sortStyle" from="com.dogma.vo.filter.BusClassFilterVo" field="ORDER_DATE"/>" data-sortBy="<system:edit show="constant" from="com.dogma.vo.filter.BusClassFilterVo" field="ORDER_DATE"/>" title="<system:label show="tooltip" label="lblLastActDate" />"><div style="width: 100px"><system:label show="text" label="lblLastActDate" /></div></th></tr><tr class="filter"><th title="<system:label show="tooltip" label="lblPerm" />"><div style="width: 30px"></div></th><th title="<system:label show="tooltip" label="lblNom" />"><div style="width: 200px"><input id="nameFilter" type="text" value="<system:filter show="value" filter="0"></system:filter>"></div></th><th title="<system:label show="tooltip" label="lblDesc" />"><div style="width: 200px"><input id="descFilter" type="text" value="<system:filter show="value" filter="1"></system:filter>"></div></th><th title="<system:label show="tooltip" label="lblEje" />"><div style="width: 200px"><input id="execFilter" type="text" value="<system:filter show="value" filter="5"></system:filter>"></div></th><th title="<system:label show="tooltip" label="lblLastUsrName" />"><div style="width: 100px"><input id="regUsrFilter" type="text" value="<system:filter show="value" filter="3"></system:filter>"></div></th><th title="<system:label show="tooltip" label="lblLastActDate" />"><div style="width: 100px"><input id="regDateFilter" type="text" class="datePicker filterInputDate" value="<system:filter show="value" filter="4"></system:filter>"></div></th></tr></thead></table></div><div class="gridBody" id="gridBody"><!-- Cuerpo de la tabla --><table><thead><tr><th width="30px"></th><th width="200px"></th><th width="200px"></th><th width="200px"></th><th width="100px"></th><th width="100px"></th></tr></thead><tbody class="tableData" id="tableData"></tbody></table></div><div class="gridFooter"><%@include file="../../includes/navButtons.jsp" %></div><system:campaign inLogin="false" inSplash="false" location="horizontalDown" /></div></div><%@include file="../../includes/footer.jsp" %></body></html>
