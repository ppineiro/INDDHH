<%@page import="biz.statum.apia.web.bean.BasicBeanStatic"%><%@ page import="com.dogma.Parameters"%><%@ page import="com.dogma.EnvParameters"%><%@page import="com.st.util.labels.LabelManager"%><% 

Integer labelSet = Parameters.DEFAULT_LABEL_SET;
Integer langId = Parameters.DEFAULT_LANG;
String styleDirectory = "default";
com.dogma.UserData uData = BasicBeanStatic.getUserDataStatic(request);
if (uData!=null) {
	labelSet = uData.getLabelSetId();
	langId = uData.getLangId();
	styleDirectory = EnvParameters.getEnvParameter(uData.getEnvironmentId(),EnvParameters.ENV_STYLE);
}
%><html><head><link href="<%=Parameters.ROOT_PATH%>/styles/<%= styleDirectory %>/css/feedBack.css" rel="styleSheet" type="text/css" media="screen"><script language="javascript" src="../scripts/util.js"></script><script>
		function logoutFrame() {
			//document.getElementById("frmLogin").action="security.LoginAction.do?action=logout";
			document.getElementById("frmLogout").action="security.LoginAction.do?action=logout";
			
			//document.getElementById("frmLogin").submit();
			document.getElementById("frmLogout").submit();
		}	
	</script></head><!-- feedback win --><BODY><form name="frmLogout" id="frmLogout" method="post"></form></body></html>

