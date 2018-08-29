<%@page import="com.dogma.vo.*"%><%@include file="../../components/scripts/server/startInc.jsp" %><HTML><head><%@include file="../../components/scripts/server/headInclude.jsp" %></head><body><TABLE class="pageTop"><COL class="col1"><COL class="col2"><TR><TD><%=LabelManager.getName(labelSet,"titIngFraSec")%></TD><TD></TD></TR></TABLE><DIV id="divContent" class="divContent"><form id="frmMain" name="frmMain" method="POST" onSubmit="return false"><DIV class="subTit"><%=LabelManager.getName(labelSet,"titIngFraSec")%></DIV><div type="grid" id="gridForms" style="height:80px"><table width="500px" cellpadding="0" cellspacing="0"><tbody><tr><td title="<%=LabelManager.getToolTip(labelSet,"lblCertPhrase")%>"><%=LabelManager.getName(labelSet,"lblCertPhrase")%></td><td><input type=password name="txtPhrase" id="txtPhrase" maxlength="250" p_required="true" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblCertPhrase")%>"></td></tr></tbody></table></div></form></div><TABLE class="pageBottom"><COL class="col1"><COL class="col2"><COL class="col3"><TR><TD align="rigth"><button type="button" id="btnConf" onclick="btnConf_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnSign")%>" title="<%=LabelManager.getToolTip(labelSet,"btnSign")%>"><%=LabelManager.getNameWAccess(labelSet,"btnSign")%></button><button type="button" onclick="btnExit_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnSal")%>" title="<%=LabelManager.getToolTip(labelSet,"btnSal")%>"><%=LabelManager.getNameWAccess(labelSet,"btnSal")%></button></TD></TR></TABLE></body></html><%@include file="../../components/scripts/server/endInc.jsp" %><script language="javascript">
function btnConf_click() {
	if (verifyRequiredObjects()) {
		window.returnValue=document.getElementById("txtPhrase").value;
		window.close();
	}
}	
 

function btnExit_click() {
	window.returnValue=null;
	window.close();
}
</script>
 