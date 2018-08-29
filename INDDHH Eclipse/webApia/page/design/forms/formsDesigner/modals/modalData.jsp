<%@page import="com.dogma.vo.BusEntityVo"%><%@page import="com.dogma.vo.IProperty"%><%@include file="../../../../includes/startInc.jsp" %><html><head><%@include file="../../../../includes/headInclude.jsp" %><script type="text/javascript" src="<system:util show="context" />/page/design/forms/formsDesigner/modals/modalData.js"></script><script type="text/javascript" src="<system:util show="context" />/page/includes/navButtons.js"></script><link href="<system:util show="context" />/page/design/forms/formsDesigner/designer.css" rel="stylesheet" type="text/css" ></head><script type="text/javascript">
	var URL_REQUEST_AJAX = '/apia.design.FormsAction.run';
	var ADDITIONAL_INFO_IN_TABLE_DATA = false;	
	var MDL_TYPE = '<%= request.getParameter("mdlType") %>';
	var FLAG_PARAM = <%= request.getParameter("flagParam") %>;
	var LBL_NAME = '<system:label show="text" label="lblNom" forScript="true" />';
	var LBL_TITLE = '<system:label show="text" label="lblTit" forScript="true" />';
	var LBL_LABEL = '<system:label show="text" label="flaEti" forScript="true" />';
	var LBL_MODALS = '<system:label show="text" label="flaModals" forScript="true" />';
	var LBL_ENTS = '<system:label show="text" label="titEnt" forScript="true" />';
	var LBL_IMGS = '<system:label show="text" label="lblImage" forScript="true" />';
	var LBL_DOCS = '<system:label show="text" label="lblDocType" forScript="true" />';
	var LBL_QRY = '<system:label show="text" label="mnuCons" forScript="true" />';
	var LBL_FORMS = '<system:label show="text" label="titFor" forScript="true" />';
	var FLAG_PAGING = <%= request.getParameter("flagPaging") %>;
</script><body><div class="body" id="bodyDiv" style="padding: 0 10px 0 10px; overflow: hidden; "><div style="width:100%;height:100%;float:left"><div class="fieldGroup" style="height: inherit;position: relative;"><div id="mdlTitle" class="title"></div><div class="gridContainer mdlTableContainer" id="gridContainerMdlData"><div id="attributes" style="position: relative;height: 100%;"><div id="paramGridHeader" class="gridHeader" style="position: absolute;width: 100%;"><table><thead><tr class="header"><th width="40%"></th><th width="60%"></th></tr><tr class="filter"><th width="40%"><div style=""><input id="nameFilter" type="text"></div></th><th width="60%"><div style=""><input id="titleFilter" type="text"></div></th></tr></thead></table></div><div class="gridContainerWithFilter"><div class="gridBody" style="height:100%; border-bottom: 1px solid #DDDDDD;"><table style="table-layout: fixed; width: 100%"><thead><tr class="header"><th class="hidden-th" width="40%"></th><th class="hidden-th" width="60%"></th></tr></thead><tbody class="tableData" id="tableData"></tbody></table></div></div><div class="gridFooter" style="position: absolute;bottom: 0px;width: 100%;"><% if ("true".equals(request.getParameter("flagPaging"))){ %><%@include file="../../../../includes/navButtons.jsp" %><% } else { %><div class="navButtonsOptions"><div class="navButton navButtonRemoveFilters" tabindex="0" id="clearFilters"><system:label show="text" label="btnClearFilter" /></div></div><% } %></div></div></div></div></div></div></body>

