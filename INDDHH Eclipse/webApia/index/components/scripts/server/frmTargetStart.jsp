<%@page import="com.st.util.labels.LabelManager"%><%@page import="com.dogma.Parameters"%><%@page import="com.dogma.EnvParameters"%><%
//**************THIS IS USED TO GET THE LABEL SET OF THE USER***************//
Integer labelSet = Parameters.DEFAULT_LABEL_SET;
Integer langId = Parameters.DEFAULT_LANG;
String styleDirectory = "default";
Integer environmentId = null;
boolean envUsesEntities = false;
com.dogma.UserData uData = BasicBeanStatic.getUserDataStatic(request);
if (uData!=null) {
	envUsesEntities = uData.isEnvUsesEntities();
	environmentId = uData.getEnvironmentId();
	labelSet = uData.getLabelSetId();
	langId = uData.getLangId();
	styleDirectory = EnvParameters.getEnvParameter(uData.getEnvironmentId(),EnvParameters.ENV_STYLE);
}

try {
%><html><head><meta http-equiv="Content-Type" content="text/html; charset=<%=com.dogma.Parameters.APP_ENCODING%>"><!-- frmtargetstart --><link href="<%=Parameters.ROOT_PATH%>/styles/<%= styleDirectory %>/css/feedBack.css" rel="styleSheet" type="text/css" media="screen"><script language="javascript">
var autoClose;
<%if(request.getParameter("windowId")!=null){ %>
var windowId        = "&windowId=<%=request.getParameter("windowId")%>";
<%}else{%>
var windowId        = "";
<%}%>


function initDocLayout(){
	if (document.readyState=='complete' || (window.navigator.appVersion.indexOf("MSIE")<0)){
			document.getElementById("divMsg").style.display="block";
			var divContent=document.getElementById("divContent");
			divContent.style.width=(window.parent.document.getElementById(window.name).clientWidth-7)+"px";
			
			var oBtnBar=document.getElementById("btnsBar");
			//divContent display off by default by workarea.css
			divContent.style.display="block";
			if(window.navigator.appVersion.indexOf("MSIE")>0){
				oBtnBar.style.display="block";
			}else{
				oBtnBar.style.display="table";
			}
			if (oBtnBar!=null){
				//Button Bar display off by default by workarea.css
				if(document.body.clientHeight!=0){
					divContent.style.height=((document.body.clientHeight-(52)))+"px";
				}
			}else{
				if(document.body.clientHeight!=0){
					divContent.style.height=(document.body.clientHeight-29)+"px";
				}
			}
			if(window.navigator.appVersion.indexOf("MSIE")>0){
				document.recalc();
			}
			//createWaitMsg();
		}
}

function createWaitMsg(msgText){
	var oMsgWaitBar = window.document.createElement("DIV");
	var waitMsg=document.uniqueID;
	oMsgWaitBar.id=waitMsg;
	oMsgWaitBar.innerText="Aguarde um momento...";
	oMsgWaitBar.className="waitMsg";
	oMsgWaitBar.style.top="3px";
	oMsgWaitBar.style.left="200px";
	oMsgWaitBar.width="100px";
	oMsgWaitBar.height="50px";
	document.body.appendChild(oMsgWaitBar);
}


function showWaitMsg(){
	document.getElementById("waitMsg").style.display="block";
	return true;
}

function hideWaitMsg(){
	document.getElementById("waitMsg").style.display="none";
	return true;
}

<%if(request.getParameter("windowId")!=null){ %>
var windowId        = "&windowId=<%=request.getParameter("windowId")%>";
<%}else{%>
var windowId        = "";
<%}%></script></head><script src="<%=Parameters.ROOT_PATH%>/scripts/util.js" defer=true></script><script src="<%=Parameters.ROOT_PATH%>/scripts/common.js"></script><BODY onload="initDocLayout()"><!----------------------------START TITLE BAR----------------->

