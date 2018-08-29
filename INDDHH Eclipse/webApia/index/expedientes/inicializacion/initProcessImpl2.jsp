<%response.setCharacterEncoding(com.dogma.Parameters.APP_ENCODING);%>
<%@page import="com.dogma.Parameters"%>
<%@page import="com.dogma.controller.ThreadData"%>
<%@page import="com.dogma.EnvParameters" %>
<%@page import="com.st.util.labels.LabelManager"%>
<%@page import="uy.com.st.adoc.mensajes.MensajeDAO"%>
<%@page import="uy.com.st.adoc.expedientes.generic.ControlSesionesUsuario"%>
<%@page import="com.dogma.UserData"%>
<%@page import="java.util.Date"%>
<%

Boolean cargo = MensajeDAO.cargarMensajesEstaticos(1001, 1);

UserData uData = ThreadData.getUserData();
String usrClave = "";
String tokenId ="";
String sessionId ="";
String strDate = ControlSesionesUsuario.getCurrentTimeStamp();    
Date fechaActual = ControlSesionesUsuario.parseCurrentTime_Date(strDate);	    

if (uData!=null) {
	usrClave = uData.getUserId();
	tokenId = uData.getTokenId();
	sessionId = uData.getSessionId();		
	ControlSesionesUsuario.controlarTokenId(usrClave, tokenId, sessionId, fechaActual);
}else{
	System.out.println("el uData es nulo!");
}

%>
<HTML>
<HEAD>
<HTML> 
	<head>
		<%String defaultEnviroment=EnvParameters.getEnvParameter(new Integer(1),EnvParameters.ENV_STYLE);%>
		<link href="<%=Parameters.ROOT_PATH%>/styles/<%=defaultEnviroment%>/css/index.css" rel="styleSheet" type="text/css" media="screen">
		<script type="text/javascript">
		function continueLogin(){
			//document.getElementById("frmMain").action="security.LoginAction.do?action=continueLogin";
			//document.getElementById("frmMain").submit();
			document.getElementById("frmMain").submit();
		}
		</script>
	</head>
<body onload="continueLogin()">
<table height="100%" width="100%" border="0">
<!--<form id="frmMain" name="frmMain" method="POST"></form>-->

<form id="frmMain" name="frmMain" method="POST" action="apia.security.LoginAction.run">
 <input type="hidden" value="continueLogin" id="action" name="action">
</form> 

  <tr align="center" valign="middle">
    <td>
	  <table class="box" border="0" cellpadding="0" cellspacing="0"  style="background-color:#EDEEF3">
		<tr>
		<td class="sysLogo" valign="top" colspan=2 height="124" style="background-repeat:no-repeat;color:#666666" background="documentum.png"><%=LabelManager.getName("titSys")%></td>
		</tr>
		<tr>
		<td style="color:#666666">
		Bienvenido
		</td>
		
		</tr>
	  </table>
	  </td>
  </tr>
  <tr><td class="copyrightTxt" valign="bottom"><%=com.dogma.DogmaConstants.COPYRIGHT_NOTICE%></td></tr>
</table>
</body>
</html>


