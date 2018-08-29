<%@page import="com.dogma.vo.*"%><%@include file="../../../components/scripts/server/startInc.jsp" %><HTML><head><%@include file="../../../components/scripts/server/headInclude.jsp" %></head><body><jsp:useBean id="dBean" scope="session" class="com.dogma.bean.security.UserBean"></jsp:useBean><%
UserVo userVo = dBean.getUserVo();
if(userVo.getUsrLastUsrLogin()==null){
	userVo.setUsrLastUsrLogin(new java.util.Date());
}
%><TABLE class="pageTop"><COL class="col1"><COL class="col2"><TR><TD><%=LabelManager.getName(labelSet,dBean.isModeGlobal()?"titUsu":"titUsuEnv")%></TD><TD></TD></TR></TABLE><div id="divContent"><form id="frmMain" name="frmMain" method="POST"><div type ="tabElement" id="samplesTab" ontabswitched="tabSwitch()"<%=(request.getParameter("defaultTab")!=null?(" defaultTab='"+request.getParameter("defaultTab").toString()+"'"):"" )%>><%@include file="step1Generic.jsp" %><%@include file="step1Preferences.jsp" %><%@include file="step1Simulation.jsp" %></div></form></div><TABLE class="pageBottom"><COL class="col1"><COL class="col2"><TR><TD></TD><TD><button type="button" onclick="btnNext_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnSig")%>" title="<%=LabelManager.getToolTip(labelSet,"btnSig")%>"><%=LabelManager.getNameWAccess(labelSet,"btnSig")%></button><button type="button" onclick="btnBack_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnVol")%>" title="<%=LabelManager.getToolTip(labelSet,"btnVol")%>"><%=LabelManager.getNameWAccess(labelSet,"btnVol")%></button><button type="button" onclick="btnExit_click()" accesskey="<%=LabelManager.getAccessKey(labelSet,"btnSal")%>" title="<%=LabelManager.getToolTip(labelSet,"btnSal")%>"><%=LabelManager.getNameWAccess(labelSet,"btnSal")%></button></TD></TR></TABLE></body></html><%@include file="../../../components/scripts/server/endInc.jsp" %><script language="javascript" src='<%=Parameters.ROOT_PATH%>/programs/security/users/update.js'></script><SCRIPT DEFER>
var isGlobal 			= <%=dBean.isModeGlobal()%>;
var envId 				= <%=dBean.getEnvId(request)%>;
var MSG_PWD_DIF			= "<%=LabelManager.getName(labelSet,"msgUsuPwdDif")%>";
var MSG_USU_MUS_HAV_ENV	= "<%=LabelManager.getName(labelSet,"msgUsuMusHavEnv")%>";
var inHierarchy         = <%=dBean.isInHierarchy()%>;
var MSG_IN_HIERARCHY    = "<%=LabelManager.getName(labelSet,"msgUsuInHierarchy")%>";
var LDAP_AUTH 			= "<%=(Parameters.AUTHENTICATION_LDAP.equals(Parameters.AUTHENTICATION_METHOD))%>";
function tabSwitch(){
}

function init(){
	if(document.getElementById('chkNotAct').checked != null && document.getElementById('chkNotAct').checked == true){
		document.getElementById('txtBlockDesc').className='';
		setRequiredField(document.getElementById('txtBlockDesc'));
	} else {
		document.getElementById('txtBlockDesc').className='txtReadOnly';
		unsetRequiredField(document.getElementById('txtBlockDesc'));
	} 

	//if (document.addEventListener) {
	 //   document.addEventListener("DOMContentLoaded", chkAllEnvClick, false);
	//}else{
	<%if (dBean.isModeGlobal()) { %>
		chkAllEnvClick();
	<%}%>
	//}
}

if (document.addEventListener) {
    document.addEventListener("DOMContentLoaded", init, false);
}else{
	init();
}


</SCRIPT>