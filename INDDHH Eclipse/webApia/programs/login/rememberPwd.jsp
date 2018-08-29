<%response.setCharacterEncoding(com.dogma.Parameters.APP_ENCODING);%><%@page import="com.dogma.Parameters"%><%@page import="com.dogma.*"%><%@page import="com.st.util.labels.LabelManager"%><%@page import="com.dogma.bean.DogmaAbstractBean"%><%@page import="java.util.*"%><%@page import="com.dogma.vo.*"%><%@page import="com.dogma.busClass.userValidation.ApiaPasswordValidationException"%><jsp:useBean id="bLogin" scope="session" class="com.dogma.bean.security.LoginBean"></jsp:useBean><%

Integer langId = null; //Parameters.DEFAULT_LANG; utilizar primero el lenguaje del label set por defecto
Integer labelSet = Parameters.DEFAULT_LABEL_SET;
if (request.getParameter("langId") != null && !"null".equals(request.getParameter("langId"))) {
	langId = new Integer(request.getParameter("langId"));
} 

UserData uData = bLogin.getUserData(request);
String defaultEnviroment = EnvParameters.getEnvParameter(new Integer(1),EnvParameters.ENV_STYLE);

Collection languages = bLogin.getLabelSetLanguages(labelSet);
if (languages == null || languages.size() == 0) { //no se encontraron lenguajes en el label set, utilizar el lenguaje por defecto
	langId = Parameters.DEFAULT_LANG;
} else { //verificar que el lenguaje seleccionado esté en el label set
	Iterator iterator = languages.iterator();
	LanguageVo langVo = null;
	while (iterator.hasNext() && langVo == null) {
		langVo = (LanguageVo) iterator.next();
		if (langVo.getLangId().equals(langId)) {
			break;
		} else {
			langVo = null;
		}
	}
	
	if (langVo == null) { //no se encontró el lenguaje colocar el lenguaje por defecto del label set
		langId = bLogin.getLabelSetDefaultLanguage(labelSet);
	}
}

if (langId == null) { //no se encontró por ningún lado el lenguaje que se debe utilizar, quedarse por el default global
	langId = Parameters.DEFAULT_LANG;
}


%><html><head><link rel="shortcut icon" href="<%=Parameters.ROOT_PATH%>/images/favicon.ico"><meta http-equiv="Content-Type" content="text/html; charset=<%=com.dogma.Parameters.APP_ENCODING%>"><link href="<%=Parameters.ROOT_PATH%>/styles/<%=defaultEnviroment%>/css/login.css" rel="styleSheet" type="text/css" media="screen"></link><title><%=LabelManager.getName("0001"+Parameters.DEFAULT_LABEL_SET,"titSys")%></title><script language="javascript" src="<%=Parameters.ROOT_PATH%>/scripts/events.js"></script><script language="javascript"></script></head><body><form name="frmLogin" id="frmLogin" method="post"><table height="100%" width="100%" border=0><tr align="center" valign="middle"><td><table class="box" border="0" cellpadding="0" cellspacing="0"><tr><td colspan=2><img src="<%=Parameters.ROOT_PATH%>/styles/<%=defaultEnviroment%>/images/apiaHeader2.jpg"></td></tr><tr><td class="col3"><table class="lg" width="100%" id="tblLogin" border=0><col width="40%" align="right"><col width="60%"></col><tr height="10px"><td colspan="2">&nbsp;</td></tr><% if (Parameters.LOGIN_JSP_REQUEST_PWD == null || Parameters.LOGIN_JSP_REQUEST_PWD.length() == 0) { %><tr><td align="right" title="<%=LabelManager.getToolTip(labelSet,langId,"lblUsu")%>"><%=LabelManager.getNameWAccess(labelSet,langId,"lblUsu")%>:</td><td><input type="text" onkeyup="enableBtnOk(event)" onblur="setTimeout(function(){try{enableBtnOk(event)}catch(e){}},200)" name="txtUser" id="txtUser" size="15" maxlength="20" accesskey="<%= LabelManager.getAccessKey(labelSet,langId,"lblUsu") %>"></input></td></tr><tr><td align="right" title="<%=LabelManager.getToolTip(labelSet,langId,"lblEma")%>"><%=LabelManager.getNameWAccess(labelSet,langId,"lblEma")%>:</td><td><input type="text" onkeyup="enableBtnOk(event)" onblur="setTimeout(function(){try{enableBtnOk(event)}catch(e){}},200)" name="txtEmail" id="txtEmail" accesskey="<%= LabelManager.getAccessKey(labelSet,langId,"lblEma") %>" ></input></td></tr><tr height="20px"><td colspan="2">&nbsp;</td></tr><tr><td align="center" colspan="2"><button type="button" id="btnOK" style="width: 150px;" disabled onclick="btnConf()" accesskey="<%=LabelManager.getAccessKey(labelSet,langId,"btnRemPwd")%>" title="<%=LabelManager.getToolTip(labelSet,langId,"btnRemPwd")%>"><%=LabelManager.getNameWAccess(labelSet,langId,"btnRemPwd")%></button><button type="button" onclick="btnCanc()" accesskey="<%=LabelManager.getAccessKey(labelSet,langId,"btnCan")%>" title="<%=LabelManager.getToolTip(labelSet,langId,"btnCan")%>"><%=LabelManager.getNameWAccess(labelSet,langId,"btnCan")%></button></td></tr><% } else { %><tr><td align="center" colspan="2"><jsp:include page="<%= Parameters.LOGIN_JSP_REQUEST_PWD %>"/></td></tr><% } %><tr height="10px"><td colspan="2">&nbsp;</td></tr></table></td></tr></table></td></tr><tr><td class="copyrightTxt" valign="bottom"><%=com.dogma.DogmaConstants.COPYRIGHT_NOTICE%></td></tr></table><input type=hidden name="hidLangId" value="<%=langId%>"></form></body></html><script language="javascript" src='<%=Parameters.ROOT_PATH%>/scripts/common.js'></script><script language="javascript" DEFER src='<%=Parameters.ROOT_PATH%>/scripts/val.js'></script><script language="javascript" DEFER src='<%=Parameters.ROOT_PATH%>/scripts/util.js'></script><SCRIPT LANGUAGE=javascript DEFER>
GNR_REG_EXP_FAIL			= "<%=com.st.util.StringUtil.escapeScriptStr(LabelManager.getName(labelSet,langId,DogmaException.GNR_REG_EXP_FAIL))%>";

function btnConf(){
	if (checkData()){
		document.getElementById("frmLogin").action="security.LoginAction.do?action=confRemPassword";
		document.getElementById("frmLogin").submit();
	}
}

function enableBtnOk(evt){
		var element=evt.target;
		if(window.event){
			evt=window.event;
			element=evt.srcElement;
		}
		//Boton backSpace
		if (evt.keyCode==8 && element.value==""){
			document.getElementById('btnOK').disabled=true;
			return true;
		}
		
		//Boton suprimir
		if (evt.keyCode==46 && element.value==""){
			document.getElementById('btnOK').disabled=true;
			return true;
		}
		
		//Otras teclas menos enter
		if (evt.keyCode != 13){
			if (element.name == 'txtUser' && evt.keyCode != 9){
				if((document.getElementById('txtEmail').value != null) && (document.getElementById('txtEmail').value != "")){
	   				document.getElementById('btnOK').disabled=false;
	   			}
			}else if (element.name == 'txtEmail' && evt.keyCode!=9){
				if ((document.getElementById('txtUser').value != null) && (document.getElementById('txtUser').value != "")){
	   				if((document.getElementById('txtEmail').value != null) && (document.getElementById('txtEmail').value != "")){
	   					document.getElementById('btnOK').disabled=false;
	   				}
	  	 		}
			}
		}
		if (element.name == 'txtUser'){
			setTimeout("fireEvent(document.getElementById('txtEmail'),'keyup')",200);
		}
}

function btnCanc(){
	window.location.href="<%=Parameters.ROOT_PATH%>/programs/login/login.jsp";
}

function checkData() {
	if (document.getElementById("txtUser").value == "") {
		alert("<%=bLogin.fmtScriptStr(LabelManager.getName(labelSet,langId,"msgUsuVac"))%>");
		document.getElementById("txtUser").value="";
		document.getElementById("txtUser").focus();
		return false;
	} else if (document.getElementById("txtEmail").value == "") {
		alert("<%=bLogin.fmtScriptStr(LabelManager.getName(labelSet,langId,"msgEmailVac"))%>");
		document.getElementById("txtEmail").value="";
		document.getElementById("txtEmail").focus();
		return false;
	}
	return true;
}
window.onload=function(){
	if (document.getElementById("txtUser")) document.getElementById("txtUser").focus();
	setTimeout("fireEvent(document.getElementById('txtEmail'),'keyup')",200);
}
</SCRIPT><%
	int intErrors = 0;
	String errMessage = null;
	if (session.getAttribute("bLogin") != null) {
		DogmaAbstractBean tmpBean;
		tmpBean= (DogmaAbstractBean) session.getAttribute("bLogin");
		String strMessageShow = "";
		if (tmpBean.getMessages() != null) {
			Iterator it = tmpBean.getMessages().iterator();
			while(it.hasNext()){
				ErrMessageVo errMsg = (ErrMessageVo) it.next();
				String strAux = LabelManager.getName(labelSet,langId,errMsg.getMsg());
				strMessageShow += "(*) " + com.st.util.StringUtil.parseMessage(strAux,errMsg.getParams()) + "\n";
			}
			
		} 
		if (tmpBean.getDogmaException() != null) {
			if(tmpBean.getDogmaException().getCause() instanceof ApiaPasswordValidationException){
				strMessageShow += tmpBean.getDogmaException().getMessage();
			} else {
				strMessageShow += "Exception Info:" + tmpBean.getDogmaException().getCompleteStackTrace();
				com.dogma.bean.DogmaAbstractBean.logError(request, tmpBean.getDogmaException().getCompleteStackTrace());
			}
		}
		tmpBean.clearMessages();	
		if (!strMessageShow.equals("")) {
			out.print("<TEXTAREA id=errorText style='display:none'>"+ strMessageShow + "</TEXTAREA>");
			out.print("<SCRIPT language=javascript>");
			out.print("window.document.onreadystatechange=fnStartDocInit;");
			out.print("if (document.addEventListener) {    document.addEventListener('DOMContentLoaded', fnStartDocInit, false);}");
			%>function fnStartDocInit(){
				if (document.readyState=='complete' || (navigator.userAgent.indexOf("MSIE")<0)){
						try {
							alert(document.getElementById("errorText").value);
						} catch (e) {
							str = document.getElementById("errorText").value;
							alert(str);
						}
					}
				}<%
			out.print("</SCRIPT>");
		}	
	}
%>