<%@include file="../../../components/scripts/server/startInc.jsp" %><jsp:useBean id="dBean" scope="session" class="com.dogma.bean.administration.BPMNBean"></jsp:useBean><HTML><head><%@include file="../../../components/scripts/server/headInclude.jsp" %></head><body><TABLE class="pageTop"><COL class="col1"><COL class="col2"><TR><TD><%=LabelManager.getName(labelSet,"titBPMN")%></TD><TD></TD></TR></TABLE><div id="divContent"><form id="frmMain" name="frmMain" method="POST"><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtDatPro")%></DIV><table class="tblFormLayout"><COL class="col1"><COL class="col2"><COL class="col3"><COL class="col4"><tr><td><%=LabelManager.getNameWAccess(labelSet,"lblNom")%>:</td><td><input name="txtName" p_required="true" maxlength="50" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblNom")%>" type="text" value="<%=dBean.fmtStr(request.getParameter("txtName"))%>"></td><td><input type="hidden" name="chkSel" value="<%=dBean.fmtStr(request.getParameter("toClone"))%>"></td><td><input type="text" name="h1" style="display:none"></td></tr><tr><td title="<%=LabelManager.getToolTip(labelSet,"lblCloneCube")%>"><%=LabelManager.getNameWAccess(labelSet,"lblCloneCube")%>:</td><td><input type="checkbox" name="chkCloneCbe" <%=(request.getParameter("cubeId")!=null && !"null".equals(request.getParameter("cubeId")) )?"":"disabled"%> ></input></td></tr><tr><input type="hidden" name="hidUsrCanWrite" value="<%=true%>"></tr></table></form></div><TABLE class="pageBottom"><COL class="col1"><COL class="col2"><TR><TD></TD><TD><button type="button" onclick="btnConfClo_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnCon")%>" title="<%=LabelManager.getToolTip(labelSet,"btnCon")%>"><%=LabelManager.getNameWAccess(labelSet,"btnCon")%></button><button type="button" onclick="btnBack_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnVol")%>" title="<%=LabelManager.getToolTip(labelSet,"btnVol")%>"><%=LabelManager.getNameWAccess(labelSet,"btnVol")%></button><button type="button" onclick="btnExit_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnSal")%>" title="<%=LabelManager.getToolTip(labelSet,"btnSal")%>"><%=LabelManager.getNameWAccess(labelSet,"btnSal")%></button></TD></TR></TABLE></body></html><%@include file="../../../components/scripts/server/endInc.jsp" %><script language='javascript' src='<%=Parameters.ROOT_PATH%>/programs/administration/bpmn/process.js'></script><script language="javascript">
	var dependencies=false;
	function btnBack_click() {
		var msg = confirm(GNR_PER_DAT_ING);
		if (msg) {
			document.getElementById("frmMain").action = "administration.BPMNAction.do?action=backToList";
			document.getElementById("frmMain").target = "_self";
			submitForm(document.getElementById("frmMain"));
		}
		return true;
	}
</script>