<%@page import="com.dogma.Parameters"%><%@page import="com.dogma.vo.*"%><%@page import="com.st.util.labels.LabelManager"%><%@page import="java.util.*"%><%@include file="../../../components/scripts/server/startInc.jsp" %><jsp:useBean id="bLogin" class="com.dogma.bean.security.LoginBean" scope="session"/><%@page import="java.io.File"%><%@page import="com.st.util.log.Log"%><%@page import="com.dogma.Configuration"%><HTML><head><meta http-equiv="X-UA-Compatible" content="IE=7" /><link href="<%=Parameters.ROOT_PATH%>/styles/<%= styleDirectory %>/css/topFrame.css" rel="styleSheet" type="text/css" media="screen"><script src="<%=Parameters.ROOT_PATH%>/scripts/events.js" language="Javascript"></script><script src="<%=Parameters.ROOT_PATH%>/scripts/util.js" language="Javascript"></script></HEAD><BODY onLoad="init()" onUnload="windowOnUnLoad(window);"><form name="frmLogin" id="frmLogin" method="post"><table width="100%" height="48px" cellpadding=0 cellspacing=0><tr><td class="degree1" width="320px" valign="top"><img src="<%=Parameters.ROOT_PATH%>/styles/<%= styleDirectory %>/images/apia_vivo.gif"></td><td valign="top" ><div><table width="100%" cellpadding=0 cellspacing=0><tr height="18px" class="degree2"><td align=right vAlign="bottom"></td></tr><tr><td align="right" ><table cellpadding="0" cellspacing="0"><tr><td valign="top"><img height="26px" src="<%=Parameters.ROOT_PATH%>/styles/<%= styleDirectory %>/images/userMenuLC.gif"></td><td><div class="userMenuCenter"><span class="spanLogged" 
								<% if (bLogin.getUserName(request) != null) { %>
									title = "<%= bLogin.fmtHTML(bLogin.getUserName(request))%>"
								<% } %>
								><%out.print(bLogin.getUserId(request));%></span><%if(!Configuration.NODE_NAME.equals(""))  {%><span class="spanName">| <%=Configuration.NODE_NAME %></span><%} %><span class="spanName">| <%= bLogin.fmtHTML(bLogin.getUserData(request).getEnvironmentName())%></span><span class="spanMenu"><a onclick="toggleMenu()" title="<%=LabelManager.getToolTip(labelSet,"lblTocButMen")%>">| <u style="CURSOR: pointer;cursor:hand"><%=LabelManager.getName(labelSet,"lblTocButMen")%></u></a></span><span class="spanLogout"><a onclick="closeSys()" title="<%=LabelManager.getToolTip(labelSet,"lblTocCloApp")%>" >| <u style="CURSOR: pointer;cursor:hand"><%=LabelManager.getName(labelSet,"lblTocCloApp")%></u></a></span><%@include file="../../../programs/chat/include/topframeHtml.jsp" %></div></td><td valign="top"><img height="26px" src="<%=Parameters.ROOT_PATH%>/styles/<%= styleDirectory %>/images/userMenuRC.gif"></td></tr></table></td><td>&nbsp;</td></tr></table></div></td></tr></table><input name="hidLang" id="hidLang" type=hidden value="<%=bLogin.getUserData(request).getLangId()%>"></form></BODY></HTML><%if(Parameters.CUSTOM_JSP.length()>0){
	File f = new File(Parameters.APP_PATH + Parameters.CUSTOM_JSP);
	if(f.exists()){%><iframe frameborder="0" id="iframeCustomJsp" src="<%=Parameters.ROOT_PATH + Parameters.CUSTOM_JSP%>" style="display:none;"></iframe><%}else{
		Log.debug("The jsp file setted in the parameter CUSTOM JSP with value: " + Parameters.CUSTOM_JSP + " was not found");
	}
}%><script language="javascript">

var dologout = true;

function closeSys(){
	var msg = confirm("<%=LabelManager.getName(labelSet,"msgDesSalApl")%>");
	if (msg) {
	
	//codigo para autoguardar tareas.... se llama siempre dado que el btnExit_click verifica el parametro
		try{
			window.parent.frames["workArea"].frames["frameContent2"].btnExit_click();
		}catch(e){
		}
		/*
		document.getElementById("frmLogin").action="security.LoginAction.do?action=logout";
		
		document.getElementById("frmLogin").submit();
		*/
		dologout = false;
		window.parent.frames["iframeLogout"].logoutFrame();
	}
}

function toggleMenu(){
	parent.toggleExplorer();
}

//session log-outers
function init(){
	<%@include file="../../../programs/chat/include/topframeInit.jsp" %>
	addListener(window,"unload",killSession);
}
function wait(){
		setTimeout("killSession",500);
	}
function killSession(){
	try{
		sendVars("security.LoginAction.do?action=logout","");
	}catch(e){}
}
function windowOnUnLoad(window) {
	try{
		if (dologout || window.screenTop > 9999){
			//codigo para autoguardar tareas.... se llama siempre dado que el btnExit_click verifica el parametro
			try{
				window.parent.frames["workArea"].frames["frameContent2"].btnExit_click();
			}catch(e){
			}
			location.href = "security.LoginAction.do?action=logout";

			try{
				document.getElementById("frmLogin").action="security.LoginAction.do?action=logout";
				document.getElementById("frmLogin").submit();
			}catch(e){}
			return 1;
		}
		return 0;
	} catch (e){}
}


	<%@include file="../../../programs/chat/include/topframeScript.jsp" %></script>
