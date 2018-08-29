<%@page import="com.dogma.Parameters"%><%@page import="com.dogma.vo.*"%><%@page import="com.st.util.labels.LabelManager"%><%@page import="java.util.*"%><%@include file="../../../components/scripts/server/startInc.jsp" %><jsp:useBean id="bLogin" class="com.dogma.bean.security.LoginBean" scope="session"/><%@page import="java.io.File"%><%@page import="com.st.util.log.Log"%><%@page import="com.dogma.Configuration"%><HTML><head><meta http-equiv="X-UA-Compatible" content="IE=7" /><link href="<%=Parameters.ROOT_PATH%>/styles/<%= styleDirectory %>/css/topFrame.css" rel="styleSheet" type="text/css" media="screen"><script src="<%=Parameters.ROOT_PATH%>/scripts/common.js" language="Javascript"></script><script src="<%=Parameters.ROOT_PATH%>/scripts/events.js" language="Javascript"></script><script src="<%=Parameters.ROOT_PATH%>/scripts/util.js" language="Javascript"></script></HEAD><BODY onLoad="init()" onUnload="windowOnUnLoad(window);"><form name="frmLogin" id="frmLogin" method="post"><table width="100%" height="30px" border=0 cellpadding=0 cellspacing=0><col width="5%"><col width="0%"><col width="95%"><tr><td style="vertical-align:top;"><img src="<%=Parameters.ROOT_PATH%>/styles/<%=styleDirectory%>/images/apialogo.gif"></td><td class="degree2"></td><td align=right class="degree2" style="vertical-align:middle;"><span class="spanLogged" 
				<% if (bLogin.getUserName(request) != null) { %>
					title = "<%= bLogin.fmtHTML(bLogin.getUserName(request))%>"
				<% } %>
				><%out.print(bLogin.getUserId(request));%></span><%if(!Configuration.NODE_NAME.equals(""))  {%><span class="spanName">| <%=Configuration.NODE_NAME %></span><%} %><span class="spanName">| <%= bLogin.fmtHTML(bLogin.getUserData(request).getEnvironmentName())%></span><span class="spanMenu"><a onclick="toggleMenu()" title="<%=LabelManager.getToolTip(labelSet,"lblTocButMen")%>">| <u style="cursor:hand;CURSOR:pointer;"><%=LabelManager.getName(labelSet,"lblTocButMen")%></u></a></span><span class="spanLogout"><a onclick="closeSys()" title="<%=LabelManager.getToolTip(labelSet,"lblTocCloApp")%>" >| <u style="cursor:hand;CURSOR:pointer;"><%=LabelManager.getName(labelSet,"lblTocCloApp")%></u></a></span><%@include file="../../../programs/chat/include/topframeHtml.jsp" %></td></tr></table><input id="hidLang" type=hidden value="<%=bLogin.getUserData(request).getLangId()%>"></form></BODY></HTML><%if(Parameters.CUSTOM_JSP.length()>0){
	File f = new File(Parameters.APP_PATH + Parameters.CUSTOM_JSP);
	if(f.exists()){%><iframe frameborder="0" id="iframeCustomJsp" src="<%=Parameters.ROOT_PATH + Parameters.CUSTOM_JSP%>" style="display:none;"></iframe><%}else{
		Log.debug("The jsp file setted in the parameter CUSTOM JSP with value: " + Parameters.CUSTOM_JSP + " was not found");
	}
}%><script language="javascript">
	
var dologout = true;
	
function closeSys(){
	var frmLogin=document.getElementById("frmLogin");
	var msg = confirm("<%=LabelManager.getName(labelSet,"msgDesSalApl")%>");
	if (msg) {
	
	//codigo para autoguardar tareas.... se llama siempre dado que el btnExit_click verifica el parametro
		try{
			window.parent.frames["workArea"].frames["frameContent2"].btnExit_click();
		}catch(e){
		}
		/*
		frmLogin.action="security.LoginAction.do?action=logout";
	
		frmLogin.submit();
		*/
		dologout = false;
		window.parent.frames["iframeLogout"].logoutFrame();
	}
}

function init(){
	<%@include file="../../../programs/chat/include/topframeInit.jsp" %>
}

function toggleMenu(){
	window.parent.toggleExplorer();
}
	
function windowOnUnLoad(window) {
	try{
	
	//codigo para autoguardar tareas.... se llama siempre dado que el btnExit_click verifica el parametro
	try{
		window.parent.frames["workArea"].frames["frameContent2"].btnExit_click();
	}catch(e){
	}
		//if (window.screenTop > 9999){
			//alert("<%=LabelManager.getName(labelSet,"msgLogoutClose")%>");
			try{
				document.getElementById("frmLogin").action="security.LoginAction.do?action=logout";
				document.getElementById("frmLogin").submit();
			}catch(e){}
			return 1;
		//}
		//return 0;
	} catch (e){}
}


	<%@include file="../../../programs/chat/include/topframeScript.jsp" %></script>
