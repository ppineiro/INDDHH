<%@include file="../../includes/startInc.jsp" %><html><head><%@include file="../../includes/headInclude.jsp" %><link href="<system:util show="context" />/css/<system:util show="currentStyle" />/generalAdm.css" rel="stylesheet" type="text/css" /><script type="text/javascript" src="<system:util show="context" />/page/query/offline/list.js"></script><script type="text/javascript" src="<system:util show="context" />/page/includes/adminFav.js"></script><script type="text/javascript" src="<system:util show="context" />/page/includes/campaigns.js"></script><script type="text/javascript">
		var URL_REQUEST_AJAX = '/apia.query.OffLineAction.run';
		var ADDITIONAL_INFO_IN_TABLE_DATA  = false;
		var MSG_NO_DOWNLOAD = '<system:label show="text" label="msgGenRegNoDown" />';
		var MSG_NO_VIEW = '<system:label show="text" label="msgGenRegNoView" />';
	</script></head><body><div class="header"></div><div class="body" id="bodyDiv"><div class="optionsContainer" id="optionsContainer"><system:campaign inLogin="false" inSplash="false" location="verticalUp" /><%@include file="../common/panelInfo.jsp" %><div class="fncPanel options lastOptions"><div class="title"><system:label show="tooltip" label="mnuOpc" /></div><div class="content"><div id="optionDownload" class="button suggestedAction" title="<system:label show="tooltip" label="btnDow"/>" style="display: none;"><system:label show="text" label="btnDow"/></div><div id="optionView" class="button" title="<system:label show="tooltip" label="btnView"/>" style="display: none;"><system:label show="text" label="btnView"/></div></div><div class="clear"></div></div><system:campaign inLogin="false" inSplash="false" location="verticalDown" /></div><div class="gridContainer" id="gridContainer"><system:campaign inLogin="false" inSplash="false" location="horizontalUp" /><div class="gridHeader" id="gridHeader"><!-- Cabezal y filtros --><table cellpadding="0" cellspacing="0"><thead><tr id="trOrderBy" class="header"><th title="<system:label show="tooltip" label="lblFec" />"><div style="width: 150px"><system:label show="text" label="lblFec" /></div></th><th title="<system:label show="tooltip" label="lblType" />"><div style="width: 300px"><system:label show="text" label="lblType" /></div></th></tr></thead></table></div><div class="gridBody" id="gridBody"><!-- Cuerpo de la tabla --><table cellpadding="0" cellspacing="0"><thead><tr><th width="150px"></th><th width="300px"></th></tr></thead><tbody class="tableData" id="tableData"></tbody></table></div><div class="gridFooter"><div class="navButtons"><div class="pGroup"><div id="navRefresh" class="pButton btnRefresh"></div></div></div></div><system:campaign inLogin="false" inSplash="false" location="horizontalDown" /></div></div><%@include file="../../includes/footer.jsp" %></body></html>
