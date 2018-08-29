<%@include file="../../../components/scripts/server/startInc.jsp" %><HTML><head><%@include file="../../../components/scripts/server/headInclude.jsp" %></head><body><jsp:useBean id="dBean" scope="session" class="com.dogma.bean.security.DigitalCertificatesBean"></jsp:useBean><TABLE class="pageTop"><COL class="col1"><COL class="col2"><TR><TD><%=LabelManager.getName(labelSet,"titCertDig")%></TD><TD></TD></TR></TABLE><div id="divContent"><form id="frmMain" name="frmMain" method="POST"><%if(dBean.isHasActiveCertificate()){ %><!--  REVOKE CERTIFICATE --><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtRevCert")%></DIV><table class="tblFormLayout"><COL class="col1"><COL class="col2"><COL class="col3"><COL class="col4"><tr><td  title="<%=LabelManager.getToolTip(labelSet,"lblRevokeCert")%>"><%=LabelManager.getNameWAccess(labelSet,"lblRevokeCert")%>:</td><td><input type="checkbox" id="chkRevoke" onclick="enableDisableButton()" name="chkRevoke" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblRevokeCert")%>" ></td><td></td><td></td></tr></table><%} else {%><!--  ASK NEW CERTIFICATE --><DIV class="subTit"><%=LabelManager.getName(labelSet,"sbtAskNewCert")%></DIV><table class="tblFormLayout"><COL class="col1"><COL class="col2"><COL class="col3"><COL class="col4"><tr><td  title="<%=LabelManager.getToolTip(labelSet,"lblCertPhrase")%>"><%=LabelManager.getNameWAccess(labelSet,"lblCertPhrase")%>:</td><td><input type=password id="txtCertPhrase" name="txtCertPhrase" p_required="true" maxlength="255" accesskey="<%=LabelManager.getAccessKey(labelSet,"lblCertPhrase")%>" ></td><td></td><td></td></tr></table><%} %></form></div><TABLE class="pageBottom"><COL class="col1"><COL class="col2"><TR><TD></TD><TD><button type="button" id="btnConfirm" <%if(dBean.isHasActiveCertificate()){ %> disabled <%}%> onclick="btnConf_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnCon")%>" title="<%=LabelManager.getToolTip(labelSet,"btnCon")%>"><%=LabelManager.getNameWAccess(labelSet,"btnCon")%></button><button type="button" onclick="btnExit_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnSal")%>" title="<%=LabelManager.getToolTip(labelSet,"btnSal")%>"><%=LabelManager.getNameWAccess(labelSet,"btnSal")%></button></TD></TR></TABLE></body></html><%@include file="../../../components/scripts/server/endInc.jsp" %><script language="javascript">
	function btnConf_click(){
		if (verifyRequiredObjects()) {
			document.getElementById("frmMain").action = "security.DigitalCertificatesAction.do?action=ask";
			submitForm(document.getElementById("frmMain"));
		}
	}
	
	function btnExit_click(){
		var msg = confirm(GNR_PER_DAT_ING);
		if (msg) {
			splash();
		}
	}
	<%if(dBean.isHasActiveCertificate()){ %>
		 
		function enableDisableButton(){
			if(document.getElementById("chkRevoke").checked){
				document.getElementById("btnConfirm").disabled = false;
			} else {
				document.getElementById("btnConfirm").disabled = true;
			}
		}
	<%}%></script>