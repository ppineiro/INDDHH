<%@page import="com.dogma.util.DogmaUtil"%><%@page import="com.dogma.vo.*"%><%@include file="../../../../components/scripts/server/startInc.jsp" %><HTML><head><%@include file="../../../../components/scripts/server/headInclude.jsp" %><script language="javascript">

	function openDetailsModal(type,id){
		alert(type+" "+id);
		var rets = openModal("/query.MonitorBusinessAction.do?action=details",640,480);
	}
	
	function openTasksModal(type,id){
		alert(type+" "+id);
		var rets = openModal("/query.MonitorBusinessAction.do?action=tasks",640,480);
	}

</script></head><body><jsp:useBean id="dBean" scope="session" class="com.dogma.bean.query.MonitorBusinessBean"></jsp:useBean><TABLE class="pageTop"><COL class="col1"><COL class="col2"><TR><TD><%=LabelManager.getName(labelSet,"titMonBusiness")%>: <%= dBean.getMonitorBusinessName() %></TD><TD></TD></TR></TABLE><div id="divContent"><form id="frmMain" name="frmMain" method="POST"><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtDatMonBusiness")%></DIV><table class="tblFormLayout"><COL class="col1"><COL class="col2"><COL class="col3"><COL class="col4"><%
				for (Iterator it = dBean.getInitFilters().iterator(); it.hasNext(); ) { 
					MonBusFilterVo vo = (MonBusFilterVo) it.next(); %><tr><td><%= vo.getMonBusFilTitle() %>:</td><td colspan="3"><input type="text" name="fil_<%= vo.getMonBusFilName() %>" value="<%= dBean.fmtHTMLObject(vo.getExecutionFilterValue()) %>" <%= vo.getFlagValue(MonBusFilterVo.FLAG_REQUIRED) ? "p_required=true" : "" %><%= MonBusFilterVo.TYPE_NUMERIC.equals(vo.getMonBusFilType()) ? "p_numeric=\"true\" " : "" %><%= MonBusFilterVo.TYPE_DATE.equals(vo.getMonBusFilType()) ? "class=\"txtDate\" size=\"10\" p_calendar=\"true\" p_mask=\"" + DogmaUtil.getHTMLDateMask(vo.getEnvId()) + "\"" : "" %>></td></tr><%
				} %></table></form></div><TABLE class="pageBottom"><COL class="col1"><COL class="col2"><TR><td></td><td><button type="button" onclick="btnConf_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnCon")%>" title="<%=LabelManager.getToolTip(labelSet,"btnCon")%>"><%=LabelManager.getNameWAccess(labelSet,"btnCon")%></button><button type="button" onclick="splash()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnSal")%>" title="<%=LabelManager.getToolTip(labelSet,"btnSal")%>"><%=LabelManager.getNameWAccess(labelSet,"btnSal")%></button></TD></TR></TABLE></body></html><script language="javascript" type="text/javascript">
function btnConf_click() {
	if (verifyRequiredObjects()) {
		document.getElementById("frmMain").action = "query.MonitorBusinessAction.do?action=setFilters";
		submitForm(document.getElementById("frmMain"));
	}
}
</script><%@include file="../../../../components/scripts/server/endInc.jsp" %>

