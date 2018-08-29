<%@page import="com.st.util.labels.LabelManager"%><%@page import="biz.statum.apia.web.bean.BasicBeanStatic"%><%@ page isErrorPage="true" import="java.io.*"%><%@page import="com.dogma.Parameters"%><%@page import="com.dogma.EnvParameters"%><%@page import="com.dogma.DogmaException"%><script src="<%=Parameters.ROOT_PATH%>/scripts/common.js"></script><script src="<%=Parameters.ROOT_PATH%>/scripts/events.js"></script><script src="<%=Parameters.ROOT_PATH%>/scripts/winSizer.js"></script><script src="<%=Parameters.ROOT_PATH%>/scripts/util.js"></script><script src="<%=Parameters.ROOT_PATH%>/scripts/scriptBehaviors.js"<%if(request.getHeader("User-Agent").indexOf("MSIE")>=0){ %> defer="true"<%}%>></script><%

String rootPath = Parameters.ROOT_PATH;


	String labelSet = "0001"+String.valueOf(Parameters.DEFAULT_LABEL_SET);
	String styleDirectory = "default";
	boolean envUsesEntities = false;
	Integer environmentId = null;
	com.dogma.UserData uData = BasicBeanStatic.getUserDataStatic(request);
	Exception rootException = null;
	if (uData != null) {
		envUsesEntities = uData.isEnvUsesEntities();
		environmentId = uData.getEnvironmentId();
		labelSet = uData.getStrLabelSetId();
		styleDirectory = EnvParameters.getEnvParameter(environmentId,EnvParameters.ENV_STYLE);
	}
%><script language="javascript">
var windowId        = "";
</script><script defer="true">
	try {
		hideResultFrame();
	} catch (e) {} 
</script><HTML><head><link href="<%=Parameters.ROOT_PATH%>/styles/<%= styleDirectory %>/css/workArea.css" rel="styleSheet" type="text/css" media="screen"></head><body <% if (request.getParameter("mdlTarget") != null) {%> style="BORDER:2px groove white;" <% } %>><TABLE class="pageTop"><COL class="col1"><COL class="col2"><TR><TD>Error</TD><TD></TD></TR></TABLE><div class="divContent" id="divContent"><table width="98%" class="tblFormLayout"><COL class="col1"><COL class="col2"><COL class="col3"><COL class="col4"><tr></tr><tr><td colspan=4 style="height:80px"></td></tr><tr><td align="right"><img src="<%=Parameters.ROOT_PATH%>/images/dogmaErrorPage.gif" border=0></td><td colspan=2><DIV class="subTit"><%=LabelManager.getName(labelSet,"msgDogmaErrorPageText") %></DIV></td></tr><tr><td></td><td colspan=2 style="font-size:15px"><a href="#" onclick="goLogin()">Login</a></td></tr></table></div><TABLE class="pageBottom"><COL class="col1"><COL class="col2"><TR><TD></TD><TD align="right"><button type="button" accesskey="Sair" title="Sair" onclick="splash()">Salir</button></TD></TR></TABLE></body></html><script defer=true>
	try {
		hideResultFrame();
	} catch (e) {} 
</script><script language="javascript"><% if (request.getParameter("mdlTarget") != null) { %>
	window.parent.document.getElementById("iframeMessages").hideResultFrame();
	window.parent.document.getElementById("iframeResult").showResultFrame(window.parent.document.getElementById("iframeMessages").getBody());
	function splash() {
		window.parent.document.getElementById("iframeResult").hideResultFrame()
	}
	<% } %>

	function goLogin(){
		window.top.location.href= "<%=rootPath%>/programs/login/login.jsp";	
	}
</script>
