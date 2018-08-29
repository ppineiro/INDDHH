<%@page import="com.dogma.Parameters"%><%@page import="com.dogma.vo.*"%><%@page import="com.st.util.labels.LabelManager"%><%@page import="java.util.*"%><%@include file="../../../components/scripts/server/startInc.jsp" %><jsp:useBean id="bLogin" class="com.dogma.bean.security.LoginBean" scope="session"/><%@page import="java.io.File"%><%@page import="com.st.util.log.Log"%><%@page import="com.dogma.Configuration"%><HTML><head><meta http-equiv="X-UA-Compatible" content="IE=7" /><link href="<%=Parameters.ROOT_PATH%>/styles/<%= styleDirectory %>/css/topFrame.css" rel="styleSheet" type="text/css" media="screen"><script src="<%=Parameters.ROOT_PATH%>/scripts/common.js" language="Javascript"></script><script src="<%=Parameters.ROOT_PATH%>/scripts/events.js" language="Javascript"></script><script src="<%=Parameters.ROOT_PATH%>/scripts/util.js" language="Javascript"></script></HEAD><BODY onLoad="init()" onUnload="windowOnUnLoad(window);"><form name="frmLogin" id="frmLogin" method="post"><table width="100%" height="48px" cellpadding=0 cellspacing=0><tr><td class="degree1" width="320px" valign="top"><img src="<%=Parameters.ROOT_PATH%>/styles/<%= styleDirectory %>/images/apia_header.gif"></td><td valign="top" ><div><table width="100%" cellpadding=0 cellspacing=0><tr height="30px"><td class="degree"></td><td align=right vAlign="bottom" class="degree2"><span class="spanLogged" 
						<% if (bLogin.getUserName(request) != null) { %>
							title = "<%= bLogin.fmtHTML(bLogin.getUserName(request))%>"
						<% } %>
						><%out.print(bLogin.getUserId(request));%></span><%if(!Configuration.NODE_NAME.equals(""))  {%><span class="spanName">| <%=Configuration.NODE_NAME %></span><%} %><span class="spanName">| <%= bLogin.fmtHTML(bLogin.getUserData(request).getEnvironmentName())%></span><span class="spanMenu"><a onclick="toggleMenu()" title="<%=LabelManager.getToolTip(labelSet,"lblTocButMen")%>">| <u style="cursor:hand;CURSOR:pointer;"><%=LabelManager.getName(labelSet,"lblTocButMen")%></u></a></span><span class="spanLogout"><a onclick="closeSys()" title="<%=LabelManager.getToolTip(labelSet,"lblTocCloApp")%>" >| <u style="cursor:hand;CURSOR:pointer;"><%=LabelManager.getName(labelSet,"lblTocCloApp")%></u></a></span><%@include file="../../../programs/chat/include/topframeHtml.jsp" %></td></tr><tr><td></td><td align="right" ></td></tr></table></div></td></tr></table><input name="hidLang" id="hidLang" type=hidden value="<%=bLogin.getUserData(request).getLangId()%>"></form></BODY></HTML><%if(Parameters.CUSTOM_JSP.length()>0){
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
	//window.parent.document.getElementById("iframeMessages").hideResulFrame();
    //window.parent.document.getElementById("iframeResult").showResultFrame(window.parent.document.getElementById("iframeMessages").getBody());
	parent.toggleExplorer();
}

//session log-outers
function init(){
	addListener(window,"unload",killSession);
	<%@include file="../../../programs/chat/include/topframeInit.jsp" %>
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
			//location.href = "security.LoginAction.do?action=logout";
			
						//codigo para autoguardar tareas.... se llama siempre dado que el btnExit_click verifica el parametro
			try{
				window.parent.frames["workArea"].frames["frameContent2"].btnExit_click();
			}catch(e){}
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
