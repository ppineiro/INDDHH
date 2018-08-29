<%@include file="../includes/startInc.jsp" %><html lang="<%=biz.statum.apia.web.bean.BasicBeanStatic.getUserDataStatic(request).getLangCode()%>"><head><%@include file="../includes/headInclude.jsp" %><script type="text/javascript" src="<system:util show="context" />/page/modals/jpivotToolbarPerms.js"></script></head><script type="text/javascript">
	var forObj; //busclass, query
	var id;
	var parValues;
	var forZone = false;
	
	var VIEW_ID = <%=request.getParameter("viewId")%>;
	var USER_ID = "<%=request.getParameter("userId")%>";
	
	var URL_REQUEST_AJAX = '/apia.design.WidgetAction.run';
	var LBL_NUMERIC = '<system:label show="text" label="lblNum" forHtml="true" forScript="true"/>';
	var LBL_STRING = '<system:label show="text" label="lblStr" forScript="true" />';
	var LBL_DATE = '<system:label show="text" label="lblFec" forScript="true" />';
	var LBL_INT = '<system:label show="text" label="lblInt" forScript="true" />';
	var LBL_YES = '<system:label show="text" label="lblYes" forScript="true" />';
	var LBL_NO = '<system:label show="text" label="lblNo" forScript="true" />';
	var LBL_IN = '<system:label show="text" label="lblIn" forScript="true" />';
	var LBL_OUT = '<system:label show="text" label="lblOut" forScript="true" />';
	var LBL_IN_OUT = '<system:label show="text" label="lblInOut" forScript="true" />';
		
	var TYPE_NUMERIC = "<system:edit show="constant" from="com.dogma.vo.AttributeVo" field="TYPE_NUMERIC" />";
	var TYPE_STRING = "<system:edit show="constant" from="com.dogma.vo.AttributeVo" field="TYPE_STRING" />";
	var TYPE_DATE = "<system:edit show="constant" from="com.dogma.vo.AttributeVo" field="TYPE_DATE" />";
	var TYPE_INT = "<system:edit show="constant" from="com.dogma.vo.AttributeVo" field="TYPE_INT" />";
	
	var BTN_OLAP_NAVIGATOR = "<system:edit show="constant" from="com.dogma.vo.VwPropertiesVo" field="BTN_OLAP_NAVIGATOR" />";
	var BTN_SHOW_MDX_EDITOR = "<system:edit show="constant" from="com.dogma.vo.VwPropertiesVo" field="BTN_SHOW_MDX_EDITOR" />";
	var BTN_CONFIG_OLAP_TABLE = "<system:edit show="constant" from="com.dogma.vo.VwPropertiesVo" field="BTN_CONFIG_OLAP_TABLE" />";
	var BTN_SHOW_PARENT_MEMBERS = "<system:edit show="constant" from="com.dogma.vo.VwPropertiesVo" field="BTN_SHOW_PARENT_MEMBERS" />";
	var BTN_HIDE_SPANS = "<system:edit show="constant" from="com.dogma.vo.VwPropertiesVo" field="BTN_HIDE_SPANS" />";
	var BTN_SUPRESS_EMPTY_ROWS = "<system:edit show="constant" from="com.dogma.vo.VwPropertiesVo" field="BTN_SUPRESS_EMPTY_ROWS" />";
	var BTN_SWAP_AXES = "<system:edit show="constant" from="com.dogma.vo.VwPropertiesVo" field="BTN_SWAP_AXES" />";
	var BTN_DRILL_MEMBER = "<system:edit show="constant" from="com.dogma.vo.VwPropertiesVo" field="BTN_DRILL_MEMBER" />";
	var BTN_DRILL_POSITION = "<system:edit show="constant" from="com.dogma.vo.VwPropertiesVo" field="BTN_DRILL_POSITION" />";
	var BTN_DRILL_REPLACE = "<system:edit show="constant" from="com.dogma.vo.VwPropertiesVo" field="BTN_DRILL_REPLACE" />";
	var BTN_DRILL_THROUGH = "<system:edit show="constant" from="com.dogma.vo.VwPropertiesVo" field="BTN_DRILL_THROUGH" />";
	var BTN_SHOW_CHART = "<system:edit show="constant" from="com.dogma.vo.VwPropertiesVo" field="BTN_SHOW_CHART" />";
	var BTN_CHART_CONFIG = "<system:edit show="constant" from="com.dogma.vo.VwPropertiesVo" field="BTN_CHART_CONFIG" />";
	var BTN_PRINT_CONFIG = "<system:edit show="constant" from="com.dogma.vo.VwPropertiesVo" field="BTN_PRINT_CONFIG" />";
	var BTN_PRINT_PDF = "<system:edit show="constant" from="com.dogma.vo.VwPropertiesVo" field="BTN_PRINT_PDF" />";
	var BTN_PRINT_EXCEL = "<system:edit show="constant" from="com.dogma.vo.VwPropertiesVo" field="BTN_PRINT_EXCEL" />";
	
	var MSG_MUST_SEL_COL_VALUE = '<system:label show="text" label="msgMusEntColValue" forHtml="true" forScript="true"/>';
	var MSG_WID_BUS_CLA_ERR = '<system:label show="text" label="msgWidBusClaErr" forHtml="true" forScript="true"/>'.replace("\"","\\\"");
	var MSG_WID_QRY_ERR = '<system:label show="text" label="msgWidQryErr" forHtml="true" forScript="true"/>';
	var MSG_PAR_NOT_VAL = '<system:label show="text" label="msgParBusClaNotVal" forHtml="true" forScript="true"/>';
	var MSG_WID_MST_SEL_PAR = '<system:label show="text" label="msgWidMustSelPar" forHtml="true" forScript="true"/>';
	
	window.addEvent('domready', function() {
		forObj = "<%=request.getParameter("for")%>";
		id = "<%=request.getParameter("id")%>";
		parValues = "<%=request.getParameter("parValues")%>";
		forZone = "true" == "<%=request.getParameter("forZone")%>"; //Indica si es para 
	});
</script><body><div class="body" id="bodyDiv"><div class="dataContainer" style='width:98%; margin-bottom: 0; padding-left: 10px'><div class="fieldGroup"><div class="title"><system:label show="text" label="titPermAcc" /></div><DIV id="divContent" class="divContent"><form id="frmMain" name="frmMain" method="POST" onSubmit="return false"><DIV class="subTit"><system:label show="text" label="sbtToolbar" /></DIV><table class="tblFormLayout"><tr></tr><tr><td title="<system:label show="tooltip" label="lblNavOlap" />"><input type=checkbox name="chkNavOlap" id="chkNavOlap"><system:label show="text" label="lblNavOlap" /></td><td title="<system:label show="tooltip" label="lblBIMdxQryEditor" />"><input type=checkbox name="chkMDX" id="chkMDX"><system:label show="text" label="lblBIMdxQryEditor" /></td><td title="<system:label show="tooltip" label="lblConfTabOlap" />"><input type=checkbox name="chkCnfOlapTable" id="chkCnfOlapTable"><system:label show="text" label="lblConfTabOlap" /></td><td></td></tr><tr><td title="<system:label show="tooltip" label="lblShowParents" />"><input type=checkbox name="chkShowParents" id="chkShowParents"><system:label show="text" label="lblShowParents" /></td><td title="<system:label show="tooltip" label="lblHidRepeat" />"><input type=checkbox name="chkHidRepeat" id="chkHidRepeat"><system:label show="text" label="lblHidRepeat" /></td><td title="<system:label show="tooltip" label="lblSupEmpRows" />"><input type=checkbox name="chkSupEmpRows" id="chkSupEmpRows"><system:label show="text" label="lblSupEmpRows" /></td><td title="<system:label show="tooltip" label="lblExcAxes" />"><input type=checkbox name="chkExcAxes" id="chkExcAxes"><system:label show="text" label="lblExcAxes" /></td></tr><tr><td title="<system:label show="tooltip" label="lblMemDetail" />"><input type=checkbox name="chkMemDatail" id="chkMemDatail"><system:label show="text" label="lblMemDetail" /></td><td title="<system:label show="tooltip" label="lblOpeDetail" />"><input type=checkbox name="chkOpeDetail" id="chkOpeDetail"><system:label show="text" label="lblOpeDetail" /></td><td title="<system:label show="tooltip" label="lblEntDetail" />"><input type=checkbox name="chkEntDetail" id="chkEntDetail"><system:label show="text" label="lblEntDetail" /></td><td title="<system:label show="tooltip" label="lblShowOriData" />"><input type=checkbox name="chkShowOriData" id="chkShowOriData"><system:label show="text" label="lblShowOriData" /></td></tr><tr><td title="<system:label show="tooltip" label="lblShowChart" />"><input type=checkbox name="chkShowChart" id="chkShowChart"><system:label show="text" label="lblShowChart" /></td><td title="<system:label show="tooltip" label="lblConfChart" />"><input type=checkbox name="chkConfChart" id="chkConfChart"><system:label show="text" label="lblConfChart" /></td><td></td><td></td></tr><tr><td title="<system:label show="tooltip" label="lblConfPrint" />"><input type=checkbox name="chkConfPrint" id="chkConfPrint"><system:label show="text" label="lblConfPrint" /></td><td title="<system:label show="tooltip" label="lblPDFExport" />"><input type=checkbox name="chkPdfExport" id="chkPdfExport"><system:label show="text" label="lblPDFExport" /></td><td title="<system:label show="tooltip" label="lblExcExport" />"><input type=checkbox name="chkExcExport" id="chkExcExport"><system:label show="text" label="lblExcExport" /></td><td></td></tr></table><iframe name="toolbarSubmit" style="height:1px;width:1px;visibility:hidden;"></iframe></form></div></div></div></body>

