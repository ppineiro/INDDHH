<%@page import="com.st.util.XMLUtils"%><%@page import="com.dogma.DogmaException"%><%@page import="com.dogma.Parameters"%><%response.setCharacterEncoding(com.dogma.Parameters.APP_ENCODING);%><%@page import="com.dogma.EnvParameters"%><%@page import="com.st.util.StringUtil"%><jsp:useBean id="bLogin" scope="session" class="com.dogma.bean.security.LoginBean"></jsp:useBean><%@include file="../components/scripts/server/startInc.jsp" %><%
XMLUtils xmlUtils = new XMLUtils();
out.clear();
%><!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd"><html><head><meta http-equiv="Content-Type" content="text/html; charset=<%=com.dogma.Parameters.APP_ENCODING%>"><link href="<%=Parameters.ROOT_PATH%>/styles/<%= styleDirectory %>/css/toc.css" rel="styleSheet" type="text/css" media="screen" /><script language="javascript" src="<%=Parameters.ROOT_PATH%>/styles/<%= styleDirectory %>/treeMenu.js"></script><script src="<%=Parameters.ROOT_PATH%>/scripts/common.js" language="Javascript"></script><script src="<%=Parameters.ROOT_PATH%>/scripts/events.js" language="Javascript"></script><script language=javascript>
	var URL_APIA			= "<%=Parameters.ROOT_PATH%>";
	var URL_STYLE_PATH		= "<%=Parameters.ROOT_PATH%>/styles/<%= styleDirectory %>";
	var GNR_WAIT_A_MOMENT 	= "<%=StringUtil.escapeScriptStr(LabelManager.getName(labelSet,DogmaException.GNR_WAIT_A_MOMENT))%>";
	var MUST_OPEN_MENU		= "<%=Parameters.MUST_OPEN_MENU%>";
	var DATAWARE_ACTION		= "DatawareAction";
	var LOAD_CUBE			= "loadCube";
	var LOAD_VIEW			= "loadView";
	var LOAD_CARD			= "loadCard";
	var EXPAND_ON_MOUSEOVER	= "<%=Parameters.EXPAND_MENU_ON_MOUSE_OVER%>";
	
	function logout(url) {
		document.getElementById("externalLogout").src = url;
	}
	
	function doLogoutDataware() {
	}
	function doLogoutScoreCard() {
	}
		
	</script><script language="javascript" defer="true">
		function sizeMe(){
			try{
				document.getElementById("tocContainer").style.height=(window.parent.document.getElementById("tocArea").clientHeight-5)+"px";
			}
			catch(e){}
		}
		if (document.addEventListener) {
		    document.addEventListener("DOMContentLoaded", sizeMe, false);
		}else{
			sizeMe();
		}
		//----------------------------------------------------------------------------
	</script></head><%
String strXml = bLogin.getUserTreeView(request);
System.out.println(strXml);
out.println(XMLUtils.transform(bLogin.getEnvId(request),strXml,"/styles/" + styleDirectory +"/toc.xsl"));
%></html>