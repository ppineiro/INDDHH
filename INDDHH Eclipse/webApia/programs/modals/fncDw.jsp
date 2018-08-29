<%@page import="com.dogma.vo.*"%><%@page import="com.dogma.bean.analitic.DatawareBean"%><%@include file="../../components/scripts/server/startInc.jsp" %><HTML><head><%@include file="../../components/scripts/server/headInclude.jsp" %><jsp:useBean id="gBean" scope="session" class="com.dogma.bean.GenericBean"/><% boolean onlyOne = request.getParameter("onlyOne") != null; %></head><body><TABLE class="pageTop"><COL class="col1"><COL class="col2"><TR><TD><%=LabelManager.getName(labelSet,"titDwFnc")%></TD><TD></TD></TR></TABLE><DIV id="divContent" class="divContent"><form id="frmMain" name="frmMain" method="POST" onSubmit="return false"><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtFncs")%></DIV><div type="grid" id="gridForms" style="height:144px" onselect="enableConfirm()"><table width="500px" cellpadding="0" cellspacing="0"><thead><tr><th style="width:0px;display:none;" title="<%=LabelManager.getToolTip(labelSet,"lblSel")%>"></th><th style="width:100%" title="<%=LabelManager.getToolTip(labelSet,"lblVis")%>"><%=LabelManager.getName(labelSet,"lblVis")%></th></tr></thead><tbody ><%
				   		Collection views = DatawareBean.getCubesViewsScoreCards(gBean,request);
				   		if (views != null) {
				   			Iterator iterator = views.iterator();
				   			String view = null;
				   			String[] dataView = null;
				   			String url = null;
				   			while (iterator.hasNext()) {
				   				view = (String) iterator.next(); 
				   				dataView = view.split("·"); %><tr><td fncName="<%= dataView[1] + ((dataView.length == 3)?(" - " + dataView[2]):"")%>" fncDesc="<%= view %>"><input type='hidden' name='chk' <% if (onlyOne) { %>onclick='selectOneChk(this); enableConfirm();'<% } %>></td><td><%= dataView[1] + ((dataView.length == 3)?(" - " + dataView[2]):"")%></td></tr><%
				   			}
				   		} %></tbody></table></div></form></div><TABLE class="pageBottom"><COL class="col1"><COL class="col2"><COL class="col3"><TR><TD></TD><TD align="center" style="width:100%"></TD><TD align="rigth"><button type="button" disabled id="btnConf" onclick="btnConf_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnCon")%>" title="<%=LabelManager.getToolTip(labelSet,"btnCon")%>"><%=LabelManager.getNameWAccess(labelSet,"btnCon")%></button><button type="button" onclick="btnExit_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnSal")%>" title="<%=LabelManager.getToolTip(labelSet,"btnSal")%>"><%=LabelManager.getNameWAccess(labelSet,"btnSal")%></button></TD></TR></TABLE></body></html><%@include file="../../components/scripts/server/endModalInc.jsp" %><script language="javascript">
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
			var oTd = oRow.cells[0];
			arr = new Array();
			
			arr[0] = oTd.fncName;
			arr[1] = oTd.fncDesc;
			
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