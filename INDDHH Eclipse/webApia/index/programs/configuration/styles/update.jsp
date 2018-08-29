<%@include file="../../../components/scripts/server/startInc.jsp" %><HTML><head><%@include file="../../../components/scripts/server/headInclude.jsp" %><script><%
String style=request.getParameter("style");
String replaceMsg=request.getParameter("replace");
%><%
if(replaceMsg!=null){
%>
	window.onload=function(){
		var msg = confirm("<%=LabelManager.getName(labelSet,"msgDesSobSty")%>");//label quiere sobreescribir
		if (msg) {
			document.getElementById("frmMain").action = "configuration.StylesAction.do?action=replace";
			submitForm(document.getElementById("frmMain"));
		}
	}
	<%
}
%></script></head><body><jsp:useBean id="dBean" scope="session" class="com.dogma.bean.configuration.StylesBean"></jsp:useBean><TABLE class="pageTop"><COL class="col1"><COL class="col2"><TR><TD><%=LabelManager.getName(labelSet,"titSty")%></TD><TD></TD></TR></TABLE><div id="divContent"><form id="frmMain" name="frmMain" method="POST" enctype="multipart/form-data"><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtSty")%></DIV><table class="tblFormLayout"><tr><td><%=LabelManager.getNameWAccess(labelSet,"lblNom")%>:</td><td><input name="style" id="style" p_required="true" maxlength="50" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblNom")%>" type="text" <%if(style!=null) {%>value="<%=style%>"<%}%>></td></tr><tr><td><%=LabelManager.getNameWAccess(labelSet,"lblOriArc")%>:</td><td colspan=3><input type="FILE" length="150" accesskey="<%=LabelManager.getToolTip(labelSet,"lblNueDoc")%>" p_required="true" name="fileName" size="45" ></td></tr></table></form></div><TABLE class="pageBottom"><COL class="col1"><COL class="col2"><TR><TD></TD><TD><button type="button" onclick="btnConf_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnCon")%>" title="<%=LabelManager.getToolTip(labelSet,"btnCon")%>"><%=LabelManager.getNameWAccess(labelSet,"btnCon")%></button><button type="button" onclick="btnBack_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnVol")%>" title="<%=LabelManager.getToolTip(labelSet,"btnVol")%>"><%=LabelManager.getNameWAccess(labelSet,"btnVol")%></button><button type="button" onclick="btnExit_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnSal")%>" title="<%=LabelManager.getToolTip(labelSet,"btnSal")%>"><%=LabelManager.getNameWAccess(labelSet,"btnSal")%></button></TD></TR></TABLE></body></html><%@include file="../../../components/scripts/server/endInc.jsp" %><script language="javascript" src='<%=Parameters.ROOT_PATH%>/programs/configuration/styles/update.js'></script>