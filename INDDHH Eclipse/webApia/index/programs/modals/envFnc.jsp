<%@page import="com.dogma.vo.*"%><%@page import="com.st.util.XMLUtils"%><%@include file="../../components/scripts/server/startInc.jsp" %><HTML><head><%@include file="../../components/scripts/server/headInclude.jsp" %></head><body><jsp:useBean id="dBean" scope="session" class="com.dogma.bean.security.ProfileBean"></jsp:useBean><%
ProfileVo profVo = dBean.getProfVo();
String curEnv = request.getParameter("envId");
%><TABLE class="pageTop"><COL class="col1"><COL class="col2"><TR><TD><%=LabelManager.getName(labelSet,"titFun")%></TD><TD></TD></TR></TABLE><div id="divContent" win_resize="false"><FORM id="frmMain" name="frmMain" method="POST" target="frmSubmit"><table><TR><td><div id="tblProfileTree" style="height:100%; width:100%; overflow:auto"><%if(profVo!=null && profVo.getPrfId()!=null) {
								out.println(XMLUtils.transform(dBean.getEnvId(request),dBean.getProfileFunctionalitiesXML(profVo.getPrfId(),request,curEnv),"/programs/modals/envFncTree.xsl"));
							} else {
								out.println(XMLUtils.transform(dBean.getEnvId(request),dBean.getProfileFunctionalitiesXML(null,request,curEnv),"/programs/modals/envFncTree.xsl"));	
							}%></div></td></TR></table><input type=hidden name=txtFuncts></form></div><TABLE class="pageBottom"><COL class="col1"><COL class="col2"><TR><TD><button type="button"  onclick="checkAll()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnSelAll")%>" title="<%=LabelManager.getToolTip(labelSet,"btnSelAll")%>"><%=LabelManager.getNameWAccess(labelSet,"btnSelAll")%></button><button type="button"  onclick="uncheckAll()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnSelNone")%>" title="<%=LabelManager.getToolTip(labelSet,"btnSelNone")%>"><%=LabelManager.getNameWAccess(labelSet,"btnSelNone")%></button></TD><TD><button type="button" id="btnConf" onclick="btnConf_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnCon")%>" title="<%=LabelManager.getToolTip(labelSet,"btnCon")%>"><%=LabelManager.getNameWAccess(labelSet,"btnCon")%></button><button type="button" onclick="btnExit_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnSal")%>" title="<%=LabelManager.getToolTip(labelSet,"btnSal")%>"><%=LabelManager.getNameWAccess(labelSet,"btnSal")%></button></TD></TR></TABLE><IFRAME id="frmSubmit" name="frmSubmit" style="display:none"></IFRAME><iframe name="iframeMessages" id="iframeMessages" src="<%=Parameters.ROOT_PATH%>/frames/feedBackWin.jsp" style="display:none"  class="feedBackFrame" frameborder="no"  ></iframe></body></html><%@include file="../../components/scripts/server/endInc.jsp" %><script language="javascript">


function checkAll(){
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

function btnExit_click(){
	window.returnValue=null;
	window.close();
}

function btnConf_click() {
	getTreeString();
	document.getElementById("frmMain").action = "security.ProfilesAction.do?action=addFnc&envId=" + <%=curEnv%>;
	submitFormModal(document.getElementById("frmMain"));
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