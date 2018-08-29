<%@page import="com.dogma.vo.*"%><%@include file="../../components/scripts/server/startInc.jsp" %><HTML><head><%@include file="../../components/scripts/server/headInclude.jsp" %><% boolean onlyOne = request.getParameter("onlyOne") != null; %></head><body><TABLE class="pageTop"><COL class="col1"><COL class="col2"><TR><TD><%=LabelManager.getName(labelSet,"flaProPro")%></TD><TD></TD></TR></TABLE><DIV id="divContent" class="divContent"><form id="frmMain" name="frmMain" method="POST" onSubmit="return false"><DIV class="subTit"><%=LabelManager.getName(labelSet,"titProps")%></DIV><div type="grid" id="gridForms" style="height:190px" onselect="enableConfirm()" multiSelect="false"><table width="500px" cellpadding="0" cellspacing="0"><thead><tr><th style="width:0px;display:none;" title="<%=LabelManager.getToolTip(labelSet,"lblSel")%>"></th><th style="width:100%" title="<%=LabelManager.getToolTip(labelSet,"lblNom")%>"><%=LabelManager.getName(labelSet,"lblNom")%></th></tr></thead><tbody><tr><td style="width:0px;display:none;" prpName="<%=LabelManager.getName(labelSet,"lblStaFec")%>"><input type="hidden"/></td><td><%=LabelManager.getName(labelSet,"lblStaFec")%></td></tr><tr><td style="width:0px;display:none;" prpName="<%=LabelManager.getName(labelSet,"lblCantDaysInExecution")%>"><input type="hidden"/></td><td><%=LabelManager.getName(labelSet,"lblCantDaysInExecution")%></td></tr><tr><td style="width:0px;display:none;" prpName="<%=LabelManager.getName(labelSet,"lblCantDaysToEnd")%>"><input type="hidden"/></td><td><%=LabelManager.getName(labelSet,"lblCantDaysToEnd")%></td></tr><tr><td style="width:0px;display:none;" prpName="<%=LabelManager.getName(labelSet,"lblCantDaysToAlarm")%>"><input type="hidden"/></td><td><%=LabelManager.getName(labelSet,"lblCantDaysToAlarm")%></td></tr><tr><td style="width:0px;display:none;" prpName="<%=LabelManager.getName(labelSet,"lblCreGroup")%>"><input type="hidden"/></td><td><%=LabelManager.getName(labelSet,"lblCreGroup")%></td></tr><tr><td style="width:0px;display:none;" prpName="<%=LabelManager.getName(labelSet,"lblCreUser")%>"><input type="hidden"/></td><td><%=LabelManager.getName(labelSet,"lblCreUser")%></td></tr><tr><td style="width:0px;display:none;" prpName="<%=LabelManager.getName(labelSet,"lblAleStatus")%>"><input type="hidden"/></td><td><%=LabelManager.getName(labelSet,"lblAleStatus")%></td></tr><tr><td style="width:0px;display:none;" prpName="<%=LabelManager.getName(labelSet,"lblPriority")%>"><input type="hidden"/></td><td><%=LabelManager.getName(labelSet,"lblPriority")%></td></tr><tr><td style="width:0px;display:none;" prpName="<%=LabelManager.getName(labelSet,"lblSta")%>"><input type="hidden"/></td><td><%=LabelManager.getName(labelSet,"lblSta")%></td></tr></tbody></table></div></form></div><TABLE class="pageBottom"><COL class="col1"><COL class="col2"><COL class="col3"><TR><TD align="center" style="width:100%"><div id="moreData" style="display:none"><%=LabelManager.getName(labelSet,"lblMoreData")%></div><div id="noData" style="display:none"><%=LabelManager.getName(labelSet,"lblNoData")%></div></TD><TD align="rigth"><button type="button" disabled id="btnConf" onclick="btnConf_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnCon")%>" title="<%=LabelManager.getToolTip(labelSet,"btnCon")%>"><%=LabelManager.getNameWAccess(labelSet,"btnCon")%></button><button type="button" onclick="btnExit_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnSal")%>" title="<%=LabelManager.getToolTip(labelSet,"btnSal")%>"><%=LabelManager.getNameWAccess(labelSet,"btnSal")%></button></TD></TR></TABLE></body></html><%@include file="../../components/scripts/server/endInc.jsp" %><script language="javascript">
function btnConf_click() {
	window.returnValue=getSelected();
	window.close();
}	

function getSelected(){
	var oRows = document.getElementById("gridForms").selectedItems;
	if (oRows != null) {
		var result = new Array();
		for (i = 0; i < oRows.length; i++) {
			var oRow = oRows[i];
			var oTd = oRow.getElementsByTagName("TD")[0];
			arr = new Array();
			
			arr[0] = oRow.rowIndex;
			arr[1] = oRow.cells[0].getAttribute("prpName");
			result[i] = arr;
		}
		return result;
	} else {
		return null;
	}
}

function enableConfirm() {
	var oRows = document.getElementById("gridForms").selectedItems;
	document.getElementById("btnConf").disabled = (oRows == null) || (oRows.length == 0);
}

function btnExit_click() {
	window.returnValue=null;
	window.close();
}
</script>