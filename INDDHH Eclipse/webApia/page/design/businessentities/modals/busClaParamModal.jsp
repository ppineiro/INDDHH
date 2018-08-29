<%@include file="../../../includes/startInc.jsp" %><html><head><%@include file="../../../includes/headInclude.jsp" %><script type="text/javascript" src="<system:util show="context" />/page/design/businessentities/modals/busClaParamModal.js"></script><script type="text/javascript" src="<system:util show="context" />/page/design/businessentities/tabEvents.js"></script><link href="<system:util show="context" />/page/design/forms/formsDesigner/designer.css" rel="stylesheet" type="text/css" ></head><style type="text/css">
.condition-title { margin-top:15px; margin-bottom:10px; font-weight: bold; font-size: 1.2em; }
.condition-info  { font-size: 1.1em; white-space: pre-line; line-height: 17px; }
</style><script type="text/javascript">
	var URL_REQUEST_AJAX = '/apia.design.BusinessEntitiesAction.run';
	var ATTRIBUTES_MODAL= '<system:util show="context"/>/page/design/forms/formsDesigner/modals/attModal.jsp';
	var FORM_IMG_PATH = '<system:util show="context" />/page/design/forms/formsDesigner/img/';

	var LBL_CLOSE = '<system:label show="text" label="lblCloseWindow" forScript="true" />';
	var LBL_YES	 = '<system:label show="text" label="lblYes" forScript="true" />';
	var LBL_NO	 = '<system:label show="text" label="lblNo" forScript="true" />';
	
	var LBL_VAL = '<system:label show="text" label="flaVal" forScript="true" />';
	var LBL_ENT_ATT = '<system:label show="text" label="lblBusEntAtt" forScript="true" />';
	var LBL_PRO_ATT = '<system:label show="text" label="lblProAtt" forScript="true" />';
</script><script type="text/javascript"></script><body><div class="body" id="bodyDiv" style="padding: 0 10px 0 10px; overflow: hidden; "><div style="width:100%;height:100%;float:left"><div class="fieldGroup" style="height: inherit;position: relative;"><div class="title" style="padding-top:5px;"><system:label show="text" label="lblObjDesBusClaParBinding" /></div><div class="gridContainer mdlTableContainer" id="gridContainerFormAtts"><div style="height: 100%;width:100%;margin-left:0px;position: relative;" ><div id="paramGridHeader" class="gridHeader" style="width: 100%;"><table><thead><tr class="header"><th width="10%"><system:label show="text" label="lblInOut" /></th><th width="10%"><system:label show="text" label="flaProTyp" /></th><th width="20%"><system:label show="text" label="flaProPar" /></th><th width="25%"><system:label show="text" label="lblDesc" /></th><th width="15%"><system:label show="text" label="flaValType" /></th><th width="20%"><system:label show="text" label="flaVal" /></th></tr></thead></table></div><div class="gridContainerWithFilter" style="position: absolute;padding:24px 0px 1px !important;"><div class="gridBody" style="height:100%; border-bottom: 1px solid #DDDDDD;"><table style="table-layout:fixed;"><thead><tr><th class="hidden-th" width="10%"></th><th class="hidden-th" width="10%"></th><th class="hidden-th" width="20%"></th><th class="hidden-th" width="25%"></th><th class="hidden-th" width="15%"></th><th class="hidden-th" width="20%"></th></tr></thead><tbody class="tableData" id="tableDataBCParams"></tbody></table></div></div></div></div></div></div></div></body>

