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


%><!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd"><html><head><link href="<%=Parameters.ROOT_PATH%>/programs/ApiaDesk/styles/classic/css/deskLogin.css" rel="styleSheet" type="text/css" media="screen"></link><title><%=LabelManager.getName("0001"+Parameters.DEFAULT_LABEL_SET,"titSys")%></title><%@include file="jsps/scriptaculousInclude.jsp" %><script language="javascript" src="winCommon.js"></script><script language="javascript" src="<%=Parameters.ROOT_PATH%>/scripts/events.js"></script></head><body style="overflow:hidden;"><div style="width:100%"></div><div style="width:451px; height:300px; position:relative; top:-350px;" id="loginWindow"><div style="position:relative; width:100%; height:42px;" id="loginHandle"></div><div style="position:relative; width:100%; height:237px;" id="loginContent"><div class="loginText">Login</div><div class="keychain"></div><div id="content" style="width:300px;position:absolute;left:150px;top:30px;"><form name="frmLogin" id="frmLogin" method="post"><input type="hidden" name="apiaDesk" value="true"><table height="100%" width="100%" border=0><tr align="center" valign="middle"><td><table class="box" border="0" cellpadding="0" cellspacing="0"><tr><td class="col3"><table class="lg" width="100%" id="tblLogin" border=0><col width="40%" align="right"><col width="60%"></col><tr><td align="right" title="<%=LabelManager.getToolTip(labelSet,langId,"lblUsu")%>"><%=LabelManager.getNameWAccess(labelSet,langId,"lblUsu")%>:</td><td><input type="text" onkeyup="enableBtnOk(event)" onblur="setTimeout(function(){try{enableBtnOk(event)}catch(e){}},200)" name="txtUser" id="txtUser" size="15" maxlength="20" accesskey="<%= LabelManager.getAccessKey(labelSet,langId,"lblUsu") %>"></input></td></tr><tr><td align="right" title="<%=LabelManager.getToolTip(labelSet,langId,"lblEma")%>"><%=LabelManager.getNameWAccess(labelSet,langId,"lblEma")%>:</td><td><input type="text" onkeyup="enableBtnOk(event)" onblur="setTimeout(function(){try{enableBtnOk(event)}catch(e){}},200)" name="txtEmail" id="txtEmail" accesskey="<%= LabelManager.getAccessKey(labelSet,langId,"lblEma") %>" ></input></td></tr><tr height="20px"><td colspan="2">&nbsp;</td></tr><tr><td align="center" colspan="2"><button type="button" style="width: 150px;" id="btnOK" disabled onclick="btnConf()" accesskey="<%=LabelManager.getAccessKey(labelSet,langId,"btnRemPwd")%>" title="<%=LabelManager.getToolTip(labelSet,langId,"btnRemPwd")%>"><%=LabelManager.getNameWAccess(labelSet,langId,"btnRemPwd")%></button><button type="button" onclick="btnCanc()" accesskey="<%=LabelManager.getAccessKey(labelSet,langId,"btnCan")%>" title="<%=LabelManager.getToolTip(labelSet,langId,"btnCan")%>"><%=LabelManager.getNameWAccess(labelSet,langId,"btnCan")%></button></td></tr><tr height="10px"><td colspan="2">&nbsp;</td></tr></table></td></tr></table></td></tr></table><input type=hidden name="hidLangId" value="<%=langId%>"></form></div><div class="apiaLogo"></div></div><div style="position:relative; width:100%; height:21px;" id="loginBottom"></div></div><div id="copyright" class="copyrightTxt" style="position:absolute;top:-90px;" valign="bottom"><%=com.dogma.DogmaConstants.COPYRIGHT_NOTICE%></div></body></html><script language="javascript" src='<%=Parameters.ROOT_PATH%>/scripts/common.js'></script><script language="javascript" DEFER src='<%=Parameters.ROOT_PATH%>/scripts/val.js'></script><script language="javascript" DEFER src='<%=Parameters.ROOT_PATH%>/scripts/util.js'></script><SCRIPT LANGUAGE=javascript DEFER>
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
	window.location.href="<%=Parameters.ROOT_PATH%>/programs/ApiaDesk/deskLogin.jsp";
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
	initLogin();
}
	function initLogin(){
		new Effect.Opacity("loginWindow", {duration:0,to:0});
		new Effect.Opacity("copyright", {duration:1.5,from:0, to:1,afterUpdate:moveCopyRight});
		new Effect.Opacity("loginWindow", {duration:1.5,from:0, to:1, afterUpdate:moveLogin});
		new Draggable("loginWindow", {revert:false,handle:document.getElementById("loginHandle")});
		//moveCopyRight();
		window.onresize=function(){
			var height = screen.availHeight;
			var width = screen.availWidth;
			window.width=width+"px";
			window.height=width+"px";
			try{
				window.resizeTo(width,height);
				window.moveTo(0,0);
			}catch(e){}
		}
	}
	function initLoader(func){
		var hide=document.createElement("DIV");
		var height = getStageHeight();
		var width = getStageWidth();
		hide.style.position="absolute"
		hide.style.height=height+"px"
		hide.style.width=width+"px"
		hide.style.zIndex=999999;
		document.body.appendChild(hide);
		showLoadingIcon(hide);
		new Effect.Opacity("copyright", {duration:1.5,from:1, to:0});
		new Effect.Opacity("loginWindow", {duration:1.5,from:1, to:0});
		new Effect.Opacity(hide, {duration:1.5,from:0, to:1,afterFinish:func});
		hide.style.top="0px"
		hide.style.left="0px"
	}
	
	function showLoadingIcon(div){
		if(!div.loadingIcon){
			var loadingIcon=document.createElement("DIV");
			loadingIcon.innerHTML='<object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=6,0,29,0" width="50" height="50"><param name="movie" value="flash/loading.swf"><param name="wmode" value="transparent"><param name="flashvars" value=""><param name="quality" value="high"><embed src="flash/loading.swf" quality="high" pluginspage="http://www.macromedia.com/go/getflashplayer" type="application/x-shockwave-flash" width="50" height="50" wmode="transparent" flashvars=""></embed></object>';
			loadingIcon.style.position="relative"
			loadingIcon.style.height="50px";
			loadingIcon.style.width="50px";
			div.appendChild(loadingIcon);
			div.loadingIcon=loadingIcon;
			div.align="center";
			loadingIcon.style.top="100px";
		}
	}

	function moveLogin(){
		document.getElementById("loginWindow").style.top=((getStageHeight()-300)/2)+"px";
		document.getElementById("loginWindow").style.left=((getStageWidth()-450)/2)+"px";
	}
	function moveCopyRight(){
		var copyright=document.getElementById("copyright");
		copyright.style.top=(getStageHeight()-(copyright.offsetHeight+5))+"px";
		copyright.style.left=(getStageWidth()-copyright.offsetWidth)+"px";
	}
	function btnRemPwd() {
		document.getElementById("frmLogin").action="security.LoginAction.do?action=remPassword&desk=true";			
		document.getElementById("frmLogin").submit();
	}
</script><%
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
			out.print("if (document.addEventListener) {    document.addEventListener('DOMContentLoaded', fnStartDocInit, false);}");
			out.print("else{window.document.onreadystatechange=fnStartDocInit;}");
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