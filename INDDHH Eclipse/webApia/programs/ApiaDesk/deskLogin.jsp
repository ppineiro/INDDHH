<%@page import="com.dogma.Parameters"%><%@page import="com.dogma.*"%><%@page import="com.st.util.labels.LabelManager"%><%@page import="com.dogma.bean.DogmaAbstractBean"%><%@page import="java.util.*"%><%@page import="com.dogma.vo.*"%><jsp:useBean id="bLogin" scope="session" class="com.dogma.bean.security.LoginBean"></jsp:useBean><%!
public boolean containsForbiden(String envName){
	if(Configuration.FORBIDDEN_ENVIRONMENTS!=null){
		for(int i=0;i<Configuration.FORBIDDEN_ENVIRONMENTS.length;i++){
			if(envName.equalsIgnoreCase(Configuration.FORBIDDEN_ENVIRONMENTS[i])){
				return true;
			}
		}
	}
	return false;
}
%><%

String userAgent=request.getHeader("User-Agent");
boolean MSIE=userAgent.indexOf("MSIE")>=0;
boolean MSIE6=userAgent.indexOf("MSIE 6")>=0;
boolean MSIE7=userAgent.indexOf("MSIE 7.0")>=0;
boolean MSIE8=userAgent.indexOf("MSIE 8.0")>=0;
boolean FIREFOX=userAgent.indexOf("Firefox/")>=0;
boolean FIREFOX2=userAgent.indexOf("Firefox/2")>=0;
boolean FIREFOX3=userAgent.indexOf("Firefox/3")>=0;
boolean FIREFOX4=userAgent.indexOf("Firefox/4")>=0;
boolean FIREFOX5=userAgent.indexOf("Firefox/5")>=0;
boolean FIREFOX6=userAgent.indexOf("Firefox/6")>=0;
boolean FIREFOX7=userAgent.indexOf("Firefox/7")>=0;
boolean FIREFOX8=userAgent.indexOf("Firefox/8")>=0;
boolean FIREFOX9=userAgent.indexOf("Firefox/9")>=0;
boolean FIREFOX10=userAgent.indexOf("Firefox/10")>=0;
boolean CHROME=userAgent.indexOf("Chrome")>=0;
boolean OPERA=userAgent.toLowerCase().indexOf("opera")>=0;

Integer langId = Parameters.DEFAULT_LANG;
Integer labelSet = Parameters.DEFAULT_LABEL_SET;
if (request.getParameter("langId") != null && !"null".equals(request.getParameter("langId"))) {
	try{
		langId = new Integer(request.getParameter("langId"));
	}catch(NumberFormatException e){
		langId = Parameters.DEFAULT_LANG; 
	}
} 

UserData uData = bLogin.getUserData(request);

Collection languages = bLogin.getLabelSetLanguages(labelSet);
if (languages == null || languages.size() == 0) {
	langId = Parameters.DEFAULT_LANG;
} else {
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
	
	if (langVo == null) {
		langId = Parameters.DEFAULT_LANG;
	} else if (uData != null) {
		uData.setLabelSetId(labelSet);
		uData.setLangId(langId);
	}
}
String defaultEnviroment=EnvParameters.getEnvParameter(new Integer(1),EnvParameters.ENV_STYLE);
boolean deskEnabled = Parameters.DESKTOP_LOGIN_ENABLED || (! Parameters.CLASSIC_LOGIN_ENABLED && ! Parameters.DESKTOP_LOGIN_ENABLED);

%><!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd"><html><head><link href="<%=Parameters.ROOT_PATH%>/programs/ApiaDesk/styles/classic/css/deskLogin.css" rel="styleSheet" type="text/css" media="screen"></link><title><%=LabelManager.getName("0001"+Parameters.DEFAULT_LABEL_SET,"titSys")%></title><%@include file="jsps/scriptaculousInclude.jsp" %><script language="javascript" src="winCommon.js"></script><script language="javascript" src="<%=Parameters.ROOT_PATH%>/scripts/events.js"></script><script language="javascript">
	
	function checkCapsLock(e) {
			var code=e.which;
			var left=getStageWidth();
			var top=getStageHeight();
			e=getEventObject(e);
			var element=getEventSource(e);
			code=e.keyCode;
		
			if (e.keyCode == 13 && document.getElementById('txtPwd').value != null &&
   				document.getElementById('txtPwd').value != "" && document.getElementById('txtUser').value != null &&
   				document.getElementById('txtUser').value != "") {
				btnConf();
				return true;
			}
			
			var content='<table style="background-color:#FFFFE1;" width="150" border="0" cellpadding="0"><tr><td align="center" style="font-family:Tahoma; color:#FF0000; font-size:10px;">Atencion!</td></tr><tr><td align="center" style="font-family:Tahoma; color:#000000; font-size:10px;">Tiene el Bloq Mayus Activado, puede causarle problemas.</td></tr></table>';
			var div=document.createElement("DIV");
			div.style.position="absolute";
			div.style.width="150px";
			div.style.border="1px solid #000000";
			div.align="center";
			div.id="capsMessage";
			div.innerHTML=content;
			//div.style.top=((top/2)-25)+"px";
			//div.style.left=((left/2)+60)+"px";
			if ( ( code >= 65 && code <= 90 ) && !e.shiftKey ) {
				if(!document.getElementById("capsMessage")){
					div.style.left=(300)+"px";
					document.getElementById("loginWindow").appendChild(div);
					div.style.top=(300-div.offsetHeight)+"px";
				}
			} else if ( ( code >= 97 && code <= 122 ) && e.shiftKey ) {
				if(!document.getElementById("capsMessage")){
					div.style.left=(300)+"px";
					document.getElementById("loginWindow").appendChild(div);
					div.style.top=(300-div.offsetHeight)+"px";
				}
			}else{
				var toDelete=document.getElementById("capsMessage");
				if(toDelete!=null){
					toDelete.parentNode.removeChild(toDelete);
				}
			}
			//if(code==13){
			//	btnConf();
			//}
		
	}
	
	</script></head><body style="overflow:hidden;"><div style="width:100%"></div><div style="width:451px; height:300px; position:relative; top:-350px;" id="loginWindow"><div style="position:relative; width:100%; height:42px;" id="loginHandle"></div><div style="position:relative; width:100%; height:237px;" id="loginContent"><div class="loginText">Login</div><div class="keychain"></div><div id="content" style="width:300px;position:absolute;left:150px;top:30px;"><form name="frmLogin" id="frmLogin" method="post"><input type="hidden" name="apiaDesk" value="true"><table height="100%" width="100%" border=0><tr align="center" valign="middle"><td><table class="box" border="0" cellpadding="0" cellspacing="0"><tr><td class="col3"><table class="lg" width="100%" id="tblLogin" border=0><col width="40%" align="right"><col width="60%"></col><%if(!deskEnabled) {%><tr><td align="center" colspan="2"><font color="#FF0000"><b><%= LabelManager.getName(labelSet, langId, "msgDskNotEnbl") %></b></font></td></tr><%} else {%><tr><td align="center" colspan="2"><% if ((!"[ApiaVersion]".equals(DogmaConstants.APIA_VERSION)) && ! DogmaConstants.APIA_VERSION.equals(Parameters.CURRENT_APIA_VERSION)) { %><font color="#FF0000"><b>ERROR IN DATABASE VERSION (<%= Parameters.CURRENT_APIA_VERSION %>) <br>AND CODE VERSION (<%= DogmaConstants.APIA_VERSION %>)</b><br>
											Please contact the administrator</font><% } %><%if(request.getParameter("changePwd")!=null){%><font color="#FF0000"><%=LabelManager.getName(labelSet,langId,"msgMustChangePassword")%></font><% } %></td></tr><%if(request.getParameter("Pwd")==null){%><tr><td align="right" title="<%=LabelManager.getToolTip(labelSet,langId,"lblUsu")%>"><%=LabelManager.getNameWAccess(labelSet,langId,"lblUsu")%>:</td><td align="left"><input type="text" onkeyup="enableBtnOk(event)"      onKeyPress="checkCapsLock(event)" name="txtUser" id="txtUser" size="15" accesskey="<%= LabelManager.getAccessKey(labelSet,langId,"lblUsu") %>" <%if(request.getParameter("txtUser")!=null){ out.print(" value='" + bLogin.fmtHTML( bLogin.fmtStr( request.getParameter("txtUser") ) ) + "' "); }%> ></input></td></tr><%}%><tr><td align="right" title="<%=LabelManager.getToolTip(labelSet,langId,"lblPwd")%>"><%=LabelManager.getNameWAccess(labelSet,langId,"lblPwd")%>:</td><td align="left"><input onKeyPress="checkCapsLock(event)" onkeyup="enableBtnOk(event)" type="password" name="txtPwd" id="txtPwd" size="15" maxlength="50" accesskey="<%= LabelManager.getAccessKey(labelSet,langId,"lblPwd") %>" <%if(request.getParameter("changePwd")!=null && Parameters.PWD_REG_EXP!=null){out.print("sRegExp =\""+Parameters.PWD_REG_EXP+"\" onchange='testRegExpPassword(this)'");}%>></input></td></tr><%if(request.getParameter("changePwd")!=null){%><tr><td align="right" title="<%=LabelManager.getToolTip(labelSet,langId,"lblConPwd")%>"><%=LabelManager.getNameWAccess(labelSet,langId,"lblConPwd")%>:</td><td align="left"><input onKeyPress="checkCapsLock(event)" onkeyup="enableBtnOk(event)" type="password" name="txtConfPwd" id="txtConfPwd" size="15" maxlength="50" accesskey="<%= LabelManager.getAccessKey(labelSet,langId,"lblConPwd") %>" <%if(request.getParameter("changePwd")!=null && Parameters.PWD_REG_EXP!=null){out.print("sRegExp =\""+Parameters.PWD_REG_EXP+"\" onchange='testRegExpPassword(this)'");}%>></input></td></tr><%}%><%if(request.getParameter("changePwd")==null){%><%if(request.getParameter("envId")==null){%><%Collection col = bLogin.getAllEnvs();%><tr <%if(col!=null && col.size() == 1){out.print(" style=\"display:none\" ");}%>><td align="right" title="<%=LabelManager.getToolTip(labelSet,langId,"lblAmb")%>"><%=LabelManager.getNameWAccess(labelSet,langId,"lblAmb")%>:</td><td align="left"><% 
	          							if (Parameters.LOGIN_SHOW_ENV_COMBO){
		          							if(col!=null && col.size() == 1) { 
		          								Iterator it = col.iterator();
		          								EnvironmentVo eVo = (EnvironmentVo) it.next(); %><input type="hidden" name="cmbEnv" value="<%= eVo.getEnvId() %>"><%
		          							} else { %><select id="cmbEnv" name="cmbEnv" onKeyPress="checkCapsLock(event)" accesskey="<%= LabelManager.getAccessKey(labelSet,langId,"lblAmb") %>"><%
			          								if (col != null) {
														Iterator it = col.iterator();
														EnvironmentVo eVo = null;
														while (it.hasNext()) {
															eVo = (EnvironmentVo)it.next();
															if(!containsForbiden(eVo.getEnvName())){
																%><option value="<%=eVo.getEnvId()%>"  <%if(eVo.getEnvId().toString().equals(request.getParameter("cmbEnv"))){ out.print(" selected "); }%>><%=bLogin.fmtHTML(eVo.getEnvName())%></option><%
															}
														}
													} %></select><%
			          						} 
			          					} else {
		          							if(col!=null && col.size() == 1) { 
		          								Iterator it = col.iterator();
		          								EnvironmentVo eVo = (EnvironmentVo) it.next(); %><input type="hidden" id="cmbEnv" name="cmbEnv" value="<%= eVo.getEnvId() %>"><%
		          							} else { %><input type="text" name="txtEnv" id="txtEnv" onkeyup="enableBtnOk(event)" size="15" maxlength="50" accesskey="<%= LabelManager.getAccessKey(labelSet,langId,"lblAmb")%>" <%if(request.getParameter("txtEnv")!=null){ out.print(" value='" + request.getParameter("txtEnv") + "' "); }%>><%}%><%}%></td></tr><%} else {%><input type="hidden" name="cmbEnv" value="<%=request.getParameter("envId")%>"><%}%><% } 
	if(!MSIE6&&!MSIE7&&!MSIE8&&!FIREFOX2&&!FIREFOX3&&!FIREFOX4&&!FIREFOX5&&!FIREFOX6&&!FIREFOX7&&!FIREFOX8&&!FIREFOX9&&!FIREFOX10){
      		%><tr height="10px"><td align="center" colspan="2"><%=LabelManager.getName(labelSet,langId,"msgBrwsNotSupported")%></td></tr><%}%><tr height="15px"><td colspan="2">&nbsp;</td></tr><tr><td align="center" colspan="2"><button type="button" id="btnOK" disabled onclick="btnConf()" accesskey="<%=LabelManager.getAccessKey(labelSet,langId,"btnLog")%>" title="<%=LabelManager.getToolTip(labelSet,langId,"btnLog")%>"><%=LabelManager.getNameWAccess(labelSet,langId,"btnLog")%></button><button type="button" onclick="btnCanc()" accesskey="<%=LabelManager.getAccessKey(labelSet,langId,"btnCan")%>" title="<%=LabelManager.getToolTip(labelSet,langId,"btnCan")%>"><%=LabelManager.getNameWAccess(labelSet,langId,"btnCan")%></button></td></tr><% if (Parameters.LOGIN_SHOW_GEN_PWD) { %><tr><td align="center" colspan="2"><a href="#" class="remember" onclick="btnRemPwd()" title="<%=LabelManager.getToolTip(labelSet,langId,"btnRemPwd")%>"><%=LabelManager.getName(labelSet,langId,"btnRemPwd")%></a></td></tr><% } %><%} %></table></td></tr></table></td></tr></table><input type=hidden name="hidLangId" value="<%=langId%>"></form></div><div class="apiaLogo"></div></div><div style="position:relative; width:100%; height:21px;" id="loginBottom"></div></div><div id="copyright" class="copyrightTxt" style="position:absolute;top:-90px;" valign="bottom"><%=com.dogma.DogmaConstants.COPYRIGHT_NOTICE%></div></body></html><script language="javascript" DEFER src='<%=Parameters.ROOT_PATH%>/scripts/val.js'></script><script src="<%=Parameters.ROOT_PATH%>/scripts/common.js" language="Javascript"></script><script language="javascript" DEFER src='<%=Parameters.ROOT_PATH%>/scripts/util.js'></script><script language="javascript" src="common.js"></script><SCRIPT LANGUAGE=javascript DEFER>
GNR_REG_EXP_FAIL			= "<%=com.st.util.StringUtil.escapeScriptStr(LabelManager.getName(labelSet,langId,DogmaException.GNR_REG_EXP_FAIL))%>";

function btnConf(){
<%if(request.getParameter("changePwd")==null){%>
	if (checkData()){
		document.getElementById('btnOK').disabled=true;
		document.getElementById("frmLogin").action="security.LoginAction.do?action=login&apiaDesk=true";
		initLoader(function(){document.getElementById("frmLogin").submit()});
	}
<%} else {%>
	if(document.getElementById("txtPwd").value == document.getElementById("txtConfPwd").value){
		document.getElementById("frmLogin").action="security.LoginAction.do?action=pwdChange";			
		initLoader(function(){document.getElementById("frmLogin").submit()});
	} else { 
		alert("<%=LabelManager.getName(labelSet,langId,"msgUsuPwdDif")%>");				
	}
<%}%>
}

function enableBtnOk(evt){
		evt=getEventObject(evt);
		element=getEventSource(evt);
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
				if((document.getElementById('txtPwd').value != null) &&
   					(document.getElementById('txtPwd').value != "") &&
   					((document.getElementById('txtEnv') && document.getElementById('txtEnv').value!="")||(!document.getElementById('txtEnv')))
   					<%if(request.getParameter("changePwd")!=null){%>
		   			&& (document.getElementById('txtConfPwd').value != "")
		   			<%}%>
   					){
	   				document.getElementById('btnOK').disabled=false;
	   			}
			}else if (element.name == 'txtPwd' && evt.keyCode!=9){
				if ((document.getElementById('txtUser').value != null) && 
	   			(document.getElementById('txtUser').value != "") &&
   				((document.getElementById('txtEnv') && document.getElementById('txtEnv').value!="")||(!document.getElementById('txtEnv')))
	   			<%if(request.getParameter("changePwd")!=null){%>
	   			&& (document.getElementById('txtConfPwd').value != "")
	   			<%}%>
	   			){
	   				document.getElementById('btnOK').disabled=false;
	  	 		}
			}else if (element.name == 'txtConfPwd' && evt.keyCode!=9){
				if ((document.getElementById('txtUser').value != null) && 
	   			(document.getElementById('txtUser').value != "") &&
				((document.getElementById('txtEnv') && document.getElementById('txtEnv').value!="")||(!document.getElementById('txtEnv')))
	   			<%if(request.getParameter("changePwd")!=null){%>
	   			&& (document.getElementById('txtConfPwd').value != "")
	   			<%}%>
	   			){
	   				document.getElementById('btnOK').disabled=false;
	  	 		}
			}else if (element.name == 'txtEnv' && evt.keyCode!=9){
				if ((document.getElementById('txtUser').value != null) && 
	   			(document.getElementById('txtUser').value != "") &&
				((document.getElementById('txtEnv') && document.getElementById('txtEnv').value!="")||(!document.getElementById('txtEnv')))
	   			<%if(request.getParameter("changePwd")!=null){%>
	   			&& (document.getElementById('txtConfPwd').value != "")
	   			<%}%>
	   			){
	   				document.getElementById('btnOK').disabled=false;
	  	 		}
			}
		}
}

function btnCanc(){
	<%if(request.getParameter("changePwd")!=null){%>	
		window.location.href="<%=Parameters.ROOT_PATH%>/programs/ApiaDesk/deskLogin.jsp";
	<%}%>
	document.getElementById("frmLogin").reset();
	document.getElementById("txtUser").value="";
	document.getElementById("txtPwd").value="";
	document.getElementById('btnOK').disabled=true;
	document.getElementById("txtUser").focus();
}

function checkData() {
	if (document.getElementById("txtUser").value == "") {
		alert("<%=bLogin.fmtScriptStr(LabelManager.getName(labelSet,langId,"msgUsuVac"))%>");
		document.getElementById("txtUser").value="";
		document.getElementById("txtUser").focus();
		return false;
	} else if (document.getElementById("txtPwd").value == "") {
		alert("<%=bLogin.fmtScriptStr(LabelManager.getName(labelSet,langId,"msgPwdVac"))%>");
		document.getElementById("txtPwd").value="";
		document.getElementById("txtPwd").focus();
		return false;
	}
	 <% if (!Parameters.LOGIN_SHOW_ENV_COMBO){%>
		 else 
		 	{ try {
			 	if (document.getElementById("txtEnv").value == "") {
				alert("<%=bLogin.fmtScriptStr(LabelManager.getName(labelSet,langId,"msgEnvVac"))%>");
				document.getElementById("txtEnv").value="";
				document.getElementById("txtEnv").focus();
				return false;
				}
			} catch (e) {}
	}
	<%}%>		
	return true;
}
window.onload=function(){
	
	if(document.getElementById("cmbEnv")){
		if(document.getElementById("cmbEnv") && document.getElementById("cmbEnv").clientWidth > 200 ){
			document.getElementById("cmbEnv").style.width="200px";
		}
	}
	if(document.getElementById("txtUser")){
		document.getElementById("txtUser").focus();
	}
	initLogin();
	
	<%if(!deskEnabled) {%>
		return;
	<%}%>
	setTimeout("fireEvent(document.getElementById('txtPwd'),'keyup')",200);
}
</SCRIPT><script language="javascript">
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
		document.getElementById("frmLogin").action="security.LoginAction.do?action=remPassword";			
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
			strMessageShow += "Exception Info:" + tmpBean.getDogmaException().getCompleteStackTrace();
			com.dogma.bean.DogmaAbstractBean.logError(request, tmpBean.getDogmaException().getCompleteStackTrace());
		}
		tmpBean.clearMessages();	
		if (!strMessageShow.equals("")) {
			out.print("<TEXTAREA id=errorText style='display:none'>"+ strMessageShow + "</TEXTAREA>");
			out.print("<SCRIPT language=javascript>");
			out.print("if (document.addEventListener) {    document.addEventListener('DOMContentLoaded', fnStartDocInit, false);}");
			out.print("else{window.document.onreadystatechange=fnStartDocInit;}");
			%>function fnStartDocInit(){
				if (document.readyState=='complete' || !MSIE){
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