<%@page import="com.dogma.vo.*"%><%@include file="../../components/scripts/server/startInc.jsp" %><HTML><head><%@include file="../../components/scripts/server/headInclude.jsp" %><% String allMembName = request.getParameter("allMembName");%></head><body><TABLE class="pageTop"><COL class="col1"><COL class="col2"><TR><TD><%=LabelManager.getName(labelSet,"titProps")%></TD><TD></TD></TR></TABLE><DIV id="divContent" class="divContent"><form id="frmMain" name="frmMain" method="POST" onSubmit="return false"><table class="tblFormLayout"><tr><td title="<%=LabelManager.getToolTip(labelSet,"flaPropAllMemberName")%>"><%=LabelManager.getNameWAccess(labelSet,"flaPropAllMemberName")%>:</td><td><input name="txtAllMembName" id="txtAllMembName" maxlength="50" value="<%=allMembName%>"/></td></tr></table></form></div><TABLE class="pageBottom"><TR><TD align="right"><button type="button" id="btnConf" onclick="btnConf_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnCon")%>" title="<%=LabelManager.getToolTip(labelSet,"btnCon")%>"><%=LabelManager.getNameWAccess(labelSet,"btnCon")%></button><button type="button" onclick="btnExit_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnSal")%>" title="<%=LabelManager.getToolTip(labelSet,"btnSal")%>"><%=LabelManager.getNameWAccess(labelSet,"btnSal")%></button></TD></TR></TABLE></body></html><%@include file="../../components/scripts/server/endInc.jsp" %><script language="javascript">
function btnConf_click() {
	window.returnValue=document.getElementById("txtAllMembName").value;
	window.close();
}	

function btnExit_click() {
	window.returnValue=null;
	window.close();
}
</script>