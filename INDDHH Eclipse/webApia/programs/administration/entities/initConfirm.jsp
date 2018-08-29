<%@page import="com.dogma.vo.*"%><%@page import="java.util.*"%><%@include file="../../../components/scripts/server/startInc.jsp" %><HTML><head><%@include file="../../../components/scripts/server/headInclude.jsp" %></head><body><jsp:useBean id="dBean" scope="session" class="com.dogma.bean.administration.EntitiesBean"></jsp:useBean><TABLE class="pageTop"><COL class="col1"><COL class="col2"><TR><TD><%=LabelManager.getName(labelSet,"titEntNeg")%></TD><TD></TD></TR></TABLE><DIV id="divContent" class="divContent"><form id="frmMain" name="frmMain" method="POST"><table class="tblFormLayout"><COL class="col1"><COL class="col2"><COL class="col3"><COL class="col4"><tr><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td></tr><tr><td><%=LabelManager.getName(labelSet,"lblBusEnt")%>:</td><td><b><%=dBean.fmtHTML(dBean.getBusinessEntityVo().getBusEntName())%></b></td><td>&nbsp;</td><td>&nbsp;</td></tr><tr><td><%=LabelManager.getName(labelSet,"lblBusEntInitInstCount")%>:</td><td><b><%=dBean.fmtHTML(dBean.getBusinessEntityVo().getBusEntInstCount())%></b></td><td>&nbsp;</td><td>&nbsp;</td></tr><tr><td><%=LabelManager.getName(labelSet,"lblBusEntInitInstRelCount")%>:</td><td><b><%=dBean.fmtHTML(dBean.getBusinessEntityVo().getBusEntInstRelCount())%></b></td><td>&nbsp;</td><td>&nbsp;</td></tr></table></FORM></DIV><TABLE class="pageBottom"><COL class="col1"><COL class="col2"><TR><TD></TD><TD><button type="button" onclick="btnConfirm_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnCon")%>" title="<%=LabelManager.getToolTip(labelSet,"btnCon")%>"><%=LabelManager.getNameWAccess(labelSet,"btnCon")%></button><button type="button" onclick="btnBack_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnVol")%>" title="<%=LabelManager.getToolTip(labelSet,"btnVol")%>"><%=LabelManager.getNameWAccess(labelSet,"btnVol")%></button><button type="button" onclick="splash()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnSal")%>" title="<%=LabelManager.getToolTip(labelSet,"btnSal")%>"><%=LabelManager.getNameWAccess(labelSet,"btnSal")%></button></TD></TR></TABLE></body></html><%@include file="../../../components/scripts/server/endInc.jsp" %><script language="javascript">
function btnExit_click(){
	splash();
}
function btnBack_click() {
	document.getElementById("frmMain").action = "administration.EntitiesAction.do?action=backToList";
	submitForm(document.getElementById("frmMain"));
}
function btnConfirm_click() {
	if (confirm("<%=LabelManager.getName(labelSet,"lblBusEntInitConf2")%>")) {
		document.getElementById("frmMain").action = "administration.EntitiesAction.do?action=initEntConf";
		submitForm(document.getElementById("frmMain"));
	}
}
</script>