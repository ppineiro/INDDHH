<%@page import="com.dogma.vo.*"%><%@page import="com.st.util.XMLUtils"%><%@include file="../../../../components/scripts/server/startInc.jsp" %><HTML><head><%@include file="../../../../components/scripts/server/headInclude.jsp" %></head><body><jsp:useBean id="dBean" scope="session" class="com.dogma.bean.security.UserSubstituteBean"></jsp:useBean><%
//ProfileVo profVo = dBean.getProfVo();
Integer prfId = Integer.valueOf(request.getParameter("prfId"));
%><TABLE class="pageTop"><COL class="col1"><COL class="col2"><TR><TD><%=LabelManager.getName(labelSet,"titFun")%></TD><TD></TD></TR></TABLE><div id="divContent"><FORM id="frmMain" name="frmMain" method="POST" target="frmSubmit"><table><TR><td><div id="tblProfileTree" style="HEIGHT:380px;WIDTH:350px;overflow:auto"><% out.println(XMLUtils.transform(dBean.getEnvId(request),dBean.getProfileFunctionalitiesXML(prfId,request),"/programs/security/usersSubstitutes/modals/envFncTree.xsl"));%></div></td></TR></table><input type=hidden name=txtFuncts></form></div><TABLE class="pageBottom"><COL class="col1"><COL class="col2"><TR><TD></TD><TD><button type="button" onclick="btnExit_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnSal")%>" title="<%=LabelManager.getToolTip(labelSet,"btnSal")%>"><%=LabelManager.getNameWAccess(labelSet,"btnSal")%></button></TD></TR></TABLE><IFRAME id="frmSubmit" name="frmSubmit" style="display:none"></IFRAME><iframe name="iframeMessages" id="iframeMessages" src="<%=Parameters.ROOT_PATH%>/frames/feedBackWin.jsp" style="display:none"  class="feedBackFrame" frameborder="no"  ></iframe></body></html><%@include file="../../../../components/scripts/server/endInc.jsp" %><script language="javascript">


/*function checkAll(){
	var oChks = document.getElementsByTagName("INPUT");
	for(var a=0;a < oChks.length;a++){
		oChks[a].checked = true;
	}
}
function uncheckAll(){
var oChks = document.getElementsByTagName("INPUT");
	for(var a=0;a < oChks.length;a++){
		oChks[a].checked = false;
	}
}
*/
function btnExit_click(){
	window.returnValue=null;
	window.close();
}

function getTreeString() {
	var auxChkCol = document.getElementById("tblProfileTree").getElementsByTagName("INPUT");
	var strFuncts = "";
	for(i=0; i < auxChkCol.length; i++) {
		if (auxChkCol[i].checked == true) {
			if (strFuncts == "") {
				strFuncts = auxChkCol[i].getAttribute("nodo");
			} else {
				strFuncts = strFuncts + GNR_STRING_SEPARATOR + auxChkCol[i].getAttribute("nodo");
			}
		}
	}
	document.getElementById("txtFuncts").value = strFuncts;	
}

</script>