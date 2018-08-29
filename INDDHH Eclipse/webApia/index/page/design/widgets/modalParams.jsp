<%@include file="../../includes/startInc.jsp" %><html><head><%@include file="../../includes/headInclude.jsp" %><link href="<system:util show="context" />/css/<system:util show="currentStyle" />/generalAdm.css" rel="stylesheet" type="text/css" /><script type="text/javascript" src="<system:util show="context" />/page/design/widgets/modalParams.js"></script></head><script type="text/javascript">
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
	var MSG_PAR_NOT_VAL = '<system:label show="text" label="msgParBusClaNotVal" forHtml="true" forScript="true"/>';
	var MSG_WID_MST_SEL_PAR = '<system:label show="text" label="msgWidMustSelPar" forHtml="true" forScript="true"/>';
	
	window.addEvent('domready', function() {
		forObj = "<%=request.getParameter("for")%>";
		id = "<%=request.getParameter("id")%>";
		parValues = "<%=request.getParameter("parValues")%>";
		forZone = "true" == "<%=request.getParameter("forZone")%>"; //Indica si es para 
	});
	
</script><body><div class="header"></div><div class="body" id="bodyDiv"><form id="frmParamsDesign" name="frmParamsDesign"><div class="" style='width:98%; margin-bottom: 0; padding-left: 10px; padding-top: 0px; padding-bottom: 0px;'><div class="fieldGroup"><div class="title"><%if(request.getParameter("for").equals("busclass")){ %><system:label show="text" label="titPar" /><%}else if (request.getParameter("for").equals("queryFilters")){ %><system:label show="text" label="titQryFilters" /><%}else if (request.getParameter("for").equals("queryShowCols")){%><system:label show="text" label="titQryColumns" /><%} %></div><div id="paramGrid" class="gridBody gridHeader" style="background-image: none;"><table cellpadding="0" cellspacing="0" id="tblSeries" style="width:650px"><thead><tr class="header"><%if (request.getParameter("for").equals("busclass")){ %><th title="<system:label show="tooltip" label="lblNom" />" width="50px"><system:label show="text" label="lblNom" /></th><th title="<system:label show="tooltip" label="lblValue" />" width="20px"><system:label show="text" label="lblValue" /></th><th title="<system:label show="tooltip" label="lblTip" />" width="20px"><system:label show="text" label="lblTip" /></th><th title="<system:label show="tooltip" label="lblInOut" />" width="20px"><system:label show="text" label="lblInOut" /></th><%if (request.getParameter("forZone")!=null && request.getParameter("forZone").equals("true")){ %><th title="<system:label show="tooltip" label="lblWidgetValue" />" width="40px"><system:label show="text" label="lblWidgetValue" /></th><%}else{ %><th title="<system:label show="tooltip" label="lblWidParValue" />" width="40px"><system:label show="text" label="lblWidParValue" /></th><%} %><%}else if (request.getParameter("for").equals("queryFilters")){ %><th title="<system:label show="tooltip" label="lblQryColName" />" width="70px"><system:label show="text" label="lblQryColName" /></th><th title="<system:label show="tooltip" label="lblType" />" width="30px"><system:label show="text" label="lblType" /></th><th title="<system:label show="tooltip" label="lblValue" />" width="30px"><system:label show="text" label="lblValue" /></th><th title="<system:label show="tooltip" label="lblReq" />" width="40px"><system:label show="text" label="lblReq" /></th><%} else if (request.getParameter("for").equals("queryShowCols")){ %><th title="<system:label show="tooltip" label="lblQryColName" />" width="60px"><system:label show="text" label="lblQryColName" /></th><th title="<system:label show="tooltip" label="lblType" />" width="25px"><system:label show="text" label="lblType" /></th><th title="<system:label show="tooltip" label="lblHidden" />" width="15px"><system:label show="text" label="lblHidden" /></th><th title="<system:label show="tooltip" label="lblWidParValue" />" width="20px"><system:label show="text" label="lblWidParValue" /></th><%} %></tr></thead><tbody class="tableData" id="gridParams" style='min-height:200px'></tbody></table></div></div></div></form></div></body>

