<%@page import="com.dogma.Parameters"%>
<%@page import="com.dogma.vo.*"%>
<%@page import="com.st.util.labels.LabelManager"%>
<%@page import="java.util.*"%>
<%@include file="../../../components/scripts/server/startInc.jsp" %>
<jsp:useBean id="bLogin" class="com.dogma.bean.security.LoginBean" scope="session"/>


<%@page import="java.io.File"%>
<%@page import="com.st.util.log.Log"%>
<%@page import="com.dogma.Configuration"%><HTML>
<head><meta http-equiv="X-UA-Compatible" content="IE=7" />
<link href="<%=Parameters.ROOT_PATH%>/styles/<%= styleDirectory %>/css/topFrame.css" rel="styleSheet" type="text/css" media="screen">

<script src="<%=Parameters.ROOT_PATH%>/scripts/common.js" language="Javascript"></script>
<script src="<%=Parameters.ROOT_PATH%>/scripts/events.js" language="Javascript"></script>
<script src="<%=Parameters.ROOT_PATH%>/scripts/util.js" language="Javascript"></script>
</HEAD>
<BODY onLoad="init()"  onUnload="windowOnUnLoad(window);">
<form name="frmLogin" id="frmLogin" method="post">
	<table width="100%" height="100%" cellpadding=0 cellspacing=0>
		<col width="5%"><col width="95%">
		<tr>
			<td class="degree1" style="padding-left: 5px"><img src="<%=Parameters.ROOT_PATH%>/styles/<%= styleDirectory %>/images/apia_logo_top.jpg"></td>
			<td valign="top" >
			<div>
			<table width="100%" height="45px" cellpadding=0 cellspacing=0><tr>
			<td class="degree"></td>
			<td align=right vAlign="center" class="degree2">
				<span class="spanLogged" 
				<% if (bLogin.getUserName(request) != null) { %>
					title = "<%= bLogin.fmtHTML(bLogin.getUserName(request))%>"
				<% } %>
				><%out.print(bLogin.getUserId(request));%></span>
				<%if(!Configuration.NODE_NAME.equals(""))  {%>
				<span class="spanName">| <%=Configuration.NODE_NAME %></span>
				<%} %>
				<span class="spanName">| <%= bLogin.fmtHTML(bLogin.getUserData(request).getEnvironmentName())%></span>
				<span class="spanMenu">
					<a onclick="toggleMenu()" title="<%=LabelManager.getToolTip(labelSet,"lblTocButMen")%>">| <u style="cursor:hand;CURSOR:pointer;"><%=LabelManager.getName(labelSet,"lblTocButMen")%></u>	</a>
				</span>
				<span class="spanLogout">
					<a onclick="closeSys()" title="<%=LabelManager.getToolTip(labelSet,"lblTocCloApp")%>" >| <u style="cursor:hand;CURSOR:pointer;"><%=LabelManager.getName(labelSet,"lblTocCloApp")%></u></a>
				</span>
				<%@include file="../../../programs/chat/include/topframeHtml.jsp" %>
			</td>
			</tr></table>			</div></td>
		</tr>
	</table>
	
	 <% long uniqueId = System.currentTimeMillis();
		session.setAttribute("uniqueId", String.valueOf(uniqueId)); %>
	<input id="hidUniqueId" type=hidden value="<%=uniqueId%>">
    
    
</form>
</BODY>
</HTML>

<%if(Parameters.CUSTOM_JSP.length()>0){
	File f = new File(Parameters.APP_PATH + Parameters.CUSTOM_JSP);
	if(f.exists()){%>
		<iframe id="iframeCustomJsp" src="<%=Parameters.ROOT_PATH + Parameters.CUSTOM_JSP%>"></iframe>
	<%}else{
		Log.debug("The jsp file setted in the parameter CUSTOM JSP with value: " + Parameters.CUSTOM_JSP + " was not found");
	}
}%>

<script language="javascript">
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
		window.parent.frames["iframeLogout"].logoutFrame();
	}
}

function toggleMenu(){
	parent.toggleExplorer();
}

//session log-outers
function init(){
	addListener(window,"unload",killSession);
	checkUniqueId();
	<%@include file="../../../programs/chat/include/topframeInit.jsp" %>
}

var killSession = true;
var checkUniqueSessionIdEvery = 15000; //tiempo en milisegundos
var checkUniqueSessionIdMessage = "Se ha detectado un acceso desde otra ventana. Su sesión ha sido invalidada. Por favor ingrese nuevamente al sistema."; //mensaje que se debe mostrar
function checkUniqueId(){
	var http_request = null; //ir al servidor
	if (window.XMLHttpRequest) { // browser has native support for XMLHttpRequest object
		http_request = new XMLHttpRequest();
	} else if (window.ActiveXObject) {
		try { // try XMLHTTP ActiveX (Internet Explorer) version
			http_request = new ActiveXObject("Msxml2.XMLHTTP");
		} catch (e1) {
			try {
				http_request = new ActiveXObject("Microsoft.XMLHTTP");
			} catch (e2) {
				http_request = null;
			}
		}
	}
	http_request.open("post", "<%=Parameters.ROOT_PATH%>/checkUniqueId.jsp?uniqueId=" + document.getElementById("hidUniqueId").value, false);
	http_request.setRequestHeader("content-type","application/x-www-form-urlencoded");
	http_request.send();
	if (http_request.readyState == 4) {
        if (http_request.status == 200) {
        	if(http_request.responseText != "OK"){
        		killSession = false;
            	alert(checkUniqueSessionIdMessage);
				window.parent.location.href = '<%=Parameters.ROOT_PATH%>/programs/login/login.jsp';
            } 
        }
    }
	setTimeout(checkUniqueId,checkUniqueSessionIdEvery);
}


function wait(){
		setTimeout("killSession",500);
	}
function killSession(){
   if(!killSession){ return; }
   
	try{
		sendVars("security.LoginAction.do?action=logout","");
	}catch(e){}
}
function windowOnUnLoad(window) {
	try{
	
		//codigo para autoguardar tareas.... se llama siempre dado que el btnExit_click verifica el parametro
		try{
			window.parent.frames["workArea"].frames["frameContent2"].btnExit_click();
		}catch(e){
		}
		try{
			document.getElementById("frmLogin").action="security.LoginAction.do?action=logout";
			document.getElementById("frmLogin").submit();
		}catch(e){}
		return 1;

	} catch (e){}
}


	<%@include file="../../../programs/chat/include/topframeScript.jsp" %>
</script>
