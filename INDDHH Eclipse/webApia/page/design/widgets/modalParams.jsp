<%@include file="../../includes/startInc.jsp" %><html lang="<%=biz.statum.apia.web.bean.BasicBeanStatic.getUserDataStatic(request).getLangCode()%>"><head><%@include file="../../includes/headInclude.jsp" %><script type="text/javascript" src="<system:util show="context" />/page/design/widgets/modalParams.js"></script></head><script type="text/javascript">
	var forObj; //busclass, query
	var id;
	var parValues;
	var forZone = false;
	
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
	
	var MSG_MUST_SEL_COL_VALUE = '<system:label show="text" label="msgMusEntColValue" forHtml="true" forScript="true"/>';
	var MSG_WID_BUS_CLA_ERR = '<system:label show="text" label="msgWidBusClaErr" forHtml="true" forScript="true"/>'.replace("\"","\\\"");
	var MSG_WID_QRY_ERR = '<system:label show="text" label="msgWidQryErr" forHtml="true" forScript="true"/>';
	var MSG_WID_QRY_COL_ERR = '<system:label show="text" label="msgWidQryColErr" forHtml="true" forScript="true"/>';
	var MSG_PAR_NOT_VAL = '<system:label show="text" label="msgParBusClaNotVal" forHtml="true" forScript="true"/>';
	var MSG_WID_MST_SEL_PAR = '<system:label show="text" label="msgWidMustSelPar" forHtml="true" forScript="true"/>';
	
	window.addEvent('domready', function() {
		forObj = "<%=request.getParameter("for")%>";
		id = "<%=request.getParameter("id")%>";
		parValues = "<%=request.getParameter("parValues")%>";
		forZone = "true" == "<%=request.getParameter("forZone")%>"; //Indica si es para 
	});
</script><body><div class="body" id="bodyDiv" style="padding: 0 10px 0 10px; overflow: hidden; "><form id="frmParamsDesign" name="frmParamsDesign"><div class="fieldGroup"><div class="title"><%if(request.getParameter("for").equals("busclass")){ %><system:label show="text" label="titPar" /><%}else if (request.getParameter("for").equals("queryFilters")){ %><system:label show="text" label="titQryFilters" /><%}else if (request.getParameter("for").equals("queryShowCols")){%><system:label show="text" label="titQryColumns" /><%} %></div><div class="gridHeader"><table style="table-layout: fixed;"><thead id="gridParamsHeader" ><tr class="header"><%if (request.getParameter("for").equals("busclass")){ %><th style="width:175px" title="<system:label show="tooltip" label="lblNom" />"><system:label show="text" label="lblNom" /></th><th style="width:175px" title="<system:label show="tooltip" label="lblValue" />"><system:label show="text" label="lblValue" /></th><th style="width:115px" title="<system:label show="tooltip" label="lblTip" />"><system:label show="text" label="lblTip" /></th><th style="width:95px" title="<system:label show="tooltip" label="lblInOut" />"><system:label show="text" label="lblInOut" /></th><%if (request.getParameter("forZone")!=null && request.getParameter("forZone").equals("true")){ %><th style="width:105px" title="<system:label show="tooltip" label="lblWidgetValue" />"><system:label show="text" label="lblWidgetValue" /></th><%}else{ %><th style="width:105px" title="<system:label show="tooltip" label="lblWidParValue" />"><system:label show="text" label="lblWidParValue" /></th><%} %><%}else if (request.getParameter("for").equals("queryFilters")){ %><th style="width: 215px;" title="<system:label show="tooltip" label="lblQryColName" />"><system:label show="text" label="lblQryColName" /></th><th style="width: 250px;" title="<system:label show="tooltip" label="lblValue" />"><system:label show="text" label="lblValue" /></th><th style="width: 95px;" title="<system:label show="tooltip" label="lblType" />"><system:label show="text" label="lblType" /></th><th style="width: 105px;" title="<system:label show="tooltip" label="lblReq" />"><system:label show="text" label="lblReq" /></th><%} else if (request.getParameter("for").equals("queryShowCols")){ %><th style="width: 300px;" title="<system:label show="tooltip" label="lblQryColName" />"><system:label show="text" label="lblQryColName" /></th><th style="width: 135px;" title="<system:label show="tooltip" label="lblType" />"><system:label show="text" label="lblType" /></th><th style="width: 115px;" title="<system:label show="tooltip" label="lblHidden" />"><system:label show="text" label="lblHidden" /></th><th style="width: 115px;" title="<system:label show="tooltip" label="lblWidParValue" />"><system:label show="text" label="lblWidParValue" /></th><%} %></tr></thead></table></div><div id="paramGrid" class="gridBody"><table id="tblSeries" style="table-layout: fixed;"><tbody class="tableData" id="gridParams" ></tbody></table></div></div></form></div></body>

