<%@page import="com.dogma.EnvParameters"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Collection"%>
<%@page import="biz.statum.sdk.util.StringUtil"%>
<%@page import="com.dogma.Configuration"%>
<%@page import="com.st.util.labels.LabelManager"%>
<%@page import="com.dogma.UserData"%>
<%@page import="java.util.Iterator"%>
<%@page import="sun.misc.BASE64Encoder"%>
<%@page import="com.dogma.Parameters"%>
<%@page import="java.util.HashMap"%>
<%@page import="com.dogma.controller.ThreadData"%>

<%response.setCharacterEncoding(com.dogma.Parameters.APP_ENCODING);%>
<html style="overflow: hidden;" >
<head>
<meta http-equiv="Content-Type" content="text/html; charset=<%=com.dogma.Parameters.APP_ENCODING%>">

<script type="text/javascript" src="../../programs/chat/mootools-1.2.4-core.js"></script>
<script type="text/javascript" src="../../programs/chat/mootools-1.2.4.4-more.js"></script>

<%
UserData ud = ThreadData.getUserData();
Integer environmentId = null;
int currentLanguage = 1;
String labelSet = ud.getStrLabelSetId();
String styleDirectory = "default";

if (ud!=null) {
	environmentId = ud.getEnvironmentId();
	currentLanguage = ud.getLangId();
	styleDirectory = EnvParameters.getEnvParameter(ud.getEnvironmentId(), EnvParameters.ENV_STYLE);
}
%>

<link href="<%=Parameters.ROOT_PATH%>/styles/<%= styleDirectory %>/css/workArea.css" rel="styleSheet" type="text/css" media="screen">
<%-- <link href="<system:util show="context" />/css/<system:util show="currentStyle" />/modal.css" rel="stylesheet" type="text/css"> --%>
<%-- <link href="<system:util show="context" />/css/<system:util show="currentStyle" />/generalExecution.css" rel="stylesheet" type="text/css"> --%>


<script type="text/javascript">

var params = {
	campoClave: "<%=Parameters.SIGN_SEARCH_ATTRIBUTES%>",
	rootCAs: "<%=Parameters.SIGN_ROOT_CAs%>",
	NSSeToken: "<%=Parameters.DIGITAL_SIGN_NSS_ETOKEN%>",
	filePicker: "<%=Parameters.DIGITAL_SIGN_ALWAYS_BROWSE ? "true" : "false"%>",
	useHTMLInterface: "true",
	lblAppletCRLExpired: "<%=LabelManager.getName(labelSet,"lblAppletCRLExpired")%>",
	lblAppletCertRevoked: "<%=LabelManager.getName(labelSet,"lblAppletCertRevoked")%>",
	sessionId: "<%=session.getId()%>",
	appletToken: "true",
	checkCertDate: "<%=Parameters.SIGN_CHECK_DATE%>",
	certificateId: "<%=ud.getDigitalCertificateUserKey()%>",
	apiaServer: location.origin + "<%=Parameters.ROOT_PATH%>",
	dataReceptor: "expedientes/firma/guardarFirma.jsp",
	timeURL: "/digitalSignatureApplet/getServerTime.jsp",
	getServerTimeForPKCS7: "/digitalSignatureApplet/getServerTime.jsp",
	lblAppletSignOK: "<%=LabelManager.getName(labelSet,"lblAppletSignOK")%>",
	lblAppletSignErr: "<%=LabelManager.getName(labelSet,"lblAppletSignErr")%>",
	lblAppletCantSign: "<%=LabelManager.getName(labelSet,"lblAppletCantSign")%>",
	lblAppletCertNotCA: "<%=LabelManager.getName(labelSet,"lblAppletCertNotCA")%>",
	lblAppletCertNotFound: "<%=LabelManager.getName(labelSet,"lblAppletCertNotFound")%>",
	lblCompTask: "<%=LabelManager.getName(labelSet,"btnCon")%>",
	lblExit: "<%=LabelManager.getName(labelSet,"btnCer")%>",
	lblCompTaskTooltip: "<%=LabelManager.getToolTip(labelSet,"btnConfSign")%>",
	lblNoDataForSignFound: "<%=LabelManager.getName(labelSet,"msgNoDataForSignFound")%>",
	lblWaitForSign: "<%=LabelManager.getName(labelSet,"msgWaitForSign")%>",
	lblAppletPrepareSign: "<%=LabelManager.getName(labelSet,"lblAppletPrepareSign")%>",
	lblContinue: "<%=LabelManager.getName(labelSet,"btnCont")%>",
	lblCertPwd: "<%=LabelManager.getName(labelSet,"lblCertPwd")%>",
	lblTitle: "<%=LabelManager.getName(labelSet,"lblAppletTitle")%>",
	lblSelectCerts: "<%=LabelManager.getName(labelSet,"lblSelectCerts")%>",
	lblAppletCertExpired: "<%=LabelManager.getName(labelSet,"lblAppletCertExpired")%>",
	lblAppletCertNotYetValid: "<%=LabelManager.getName(labelSet,"lblAppletCertNotYetValid")%>",
	lblAppletCertInvPwd: "<%=LabelManager.getName(labelSet,"lblAppletCertInvPwd")%>",
	lblSignWrongVersion: "<%
		Collection<String> toks = new ArrayList<String>();
		toks.add("<a href='apiaDigitalSignatureInstaller.jar' download>");
		toks.add("</a>");
		out.write(LabelManager.getName(labelSet,"msgSignWrongVersion") + " " + StringUtil.parseMessage(LabelManager.getName(labelSet,"msgDownloadSignInst"), toks));
	%>" ,
	lblNoCerts: "<%=LabelManager.getName(labelSet,"lblNoCerts")%>",
	lblNoToken: "<%=LabelManager.getName(labelSet,"lblNoToken")%>",
	lblWrongPass: "<%=LabelManager.getName(labelSet,"lblWrongPass")%>",
	lblTokenRemoved: "<%=LabelManager.getName(labelSet,"lblTokenRemoved")%>",
	lblNativeAppNotFound: "<%	
		out.write(LabelManager.getName(labelSet,"msgNativeAppNotFound") + "<br/>");
		
		toks = new ArrayList<String>();
		toks.add("<a href='apiaDigitalSignatureInstaller.jar' download>");
		toks.add("</a>");
		
		out.write(StringUtil.parseMessage(LabelManager.getName(labelSet,"msgDownloadSignInst"), toks));
	%>",
	lblAppletSigning: "<%=LabelManager.getName(labelSet,"lblAppletSigning")%>",<%
	if(Parameters.SIGN_CHECK_REVOKED){
		out.write("revListURL: \"/digitalSignatureApplet/checkRevList.jsp\",");
	}%>
	dataToSign : [],
	signatureVersion: "9.5",
	apiaVersion: 2,
	headerHTML: "<div id='div-applet' class='div-applet' tabindex='1'><table class='pageTop'><colgroup><col class='1'></col></colgroup><tbody><tr><td><%=LabelManager.getName(labelSet,"lblAppletTitle")%></td></tr></tbody></table>",
	contentHTML_prev: "<div id='divContent' class='divContent' style='overflow:hidden; height: 190px; width: 420px;'><br/><div id='divContentMsg' tabindex='1'>",
	contentHTML_post: "</div></div>",
	footerHTML1: "<table class='pageBottom'><colgroup><col class='col1'></col><col class='col2'></col><col class='col3'></col></colgroup><tbody><tr><td></td><td style='width: 100%; text-align: right;' align='right'></td><td align='right'><button type='button' id='btnConf' onclick='cofirmTask();' title='Completar la firma electrónica'>Completar</button><button type='button' id='btnExit' onclick='closeSign();' title='Salir de la firma electrónica'>Salir</button></td></tr></tbody></table>",
	footerHTML2: "<table class='pageBottom'><colgroup><col class='col1'></col><col class='col2'></col><col class='col3'></col></colgroup><tbody><tr><td></td><td style='width: 100%; text-align: right;' align='right'></td><td align='right'><button type='button' id='btnExit' onclick='closeSign();' title='Salir de la firma electrónica'>Salir</button></td></tr></tbody></table>"};
<%

String maxFiles = "20";
Integer maxFilesInt = 20;

if (ud.getUserAttributes().get("MAX_FILES") != null){
	maxFiles = (String) ud.getUserAttributes().get("MAX_FILES");
	if (maxFiles != null && !maxFiles.isEmpty()){
		maxFilesInt = Integer.valueOf(maxFiles);
	}
}

for(int i = 1 ; i < maxFilesInt; i++){
	//applet += "<param name='obj_id_"+i+"' value=''> <param name='hash_data_"+i+"' value=''>";
	if (ud.getUserAttributes().get("TMP_NOMBRE_ARCHIVO_A_FIRMAR_" + i + "_STR") != null && ud.getUserAttributes().get("TMP_ARCHIVO_A_FIRMAR_" + i + "_STR") != null) 
		out.write("params.dataToSign.push({objId: '" + (String)ud.getUserAttributes().get("TMP_NOMBRE_ARCHIVO_A_FIRMAR_" + i + "_STR") + "', hashData: '" + (String)ud.getUserAttributes().get("TMP_ARCHIVO_A_FIRMAR_" + i + "_STR") + "'});");
	else
		out.write("params.dataToSign.push({objId: '', hashData: ''});");
}
%>

localStorage["dataToSign"] = JSON.stringify(params);

function cofirmTask() {
	if (localStorage["result"] == "true"){
		window.returnValue = "OK";
		setTimeout(function(){
			window.close();
			},200);
	}
}

function closeSign() {
	document.body.innerHTML="";
	window.returnValue = "";
	setTimeout(function(){
		window.close();
	},200);
}

setTimeout(function() {
	if(!document.body.className.contains('extension-is-installed')) {
		//No se instaló la extensión
		var execBlocker = document.getElementById('exec-blocker');
		execBlocker.parentNode.removeChild(execBlocker);
		frameElement.style.height = document.getElementById('div-applet').offsetHeight + "px";
		frameElement.style.width = document.getElementById('div-applet').offsetWidth + "px";
	}
}, 3000);

</script>

<style>
	#exec-blocker {
		position: absolute;
		top: 0px;
		left: 0px;
		width: 100%;
		height: 100%;
		background-color: white;
	}
	
	#divContentMsg {
	    text-align: center;
	}
</style>
</head>
<body tabIndex=-1 onload="self.focus(); frameElement.style.height = document.getElementById('div-applet').offsetHeight + 'px'; frameElement.style.width = document.getElementById('div-applet').offsetWidth + 'px';" style="padding: 0px; background-color: #efefef;">
<div id='div-applet' class='div-applet modalContent'>
	<div id="exec-blocker"></div>
	<table class='pageTop'>
		<colgroup>
			<col class="col1"/>
		</colgroup>
		<tbody>
			<tr>
			<td><%=LabelManager.getName(labelSet,"lblAppletTitle")%></td>
			</tr>
		</tbody>
	</table>
 	<div id='divContent' class='divContent' style='overflow: hidden; height: 199px; width: 420px;'>
 		<br/>
 		<br/>
 		<div id='divContentMsg' tabindex='1'><%
 		toks = new ArrayList<String>();
 		toks.add("<em>");
 		toks.add("</em>");
 		
 		out.write(StringUtil.parseMessage(LabelManager.getName(labelSet,"msgNoSignExt"), toks) + "<br/>");
 		
 		toks = new ArrayList<String>();
 		toks.add("<a href=\"apiaDigitalSignatureInstaller.jar\" download>");
 		toks.add("</a>");
 		 		
 		out.write(StringUtil.parseMessage(LabelManager.getName(labelSet,"msgDownloadSignInst"), toks) + "<br/>");
 		
 		toks = new ArrayList<String>();
 		toks.add("<strong>chrome://extensions</strong>");
 		 		
 		out.write(StringUtil.parseMessage(LabelManager.getName(labelSet,"msgVerifyEnabExt"), toks) + "<br/>");
 		
 		toks = new ArrayList<String>();
 		toks.add("<a href=\"https://chrome.google.com/webstore/detail/apia-digital-signature-ex/lofgfkcbecnmhnkalgpbgafobgkodjpg\" target=\"_blank\">");
 		toks.add("</a>");
 			
 		out.write(StringUtil.parseMessage(LabelManager.getName(labelSet,"msgVerifyInstExt"), toks) + "<br/>");
 		
 		%></div>
 	</div>
 	<table class='pageBottom'>
	 	<colgroup>
			<col class="col1"/>
			<col class="col2"/>
			<col class="col3"/>
		</colgroup>
		<tbody>
			<tr><td></td></tr>
			<tr><td align='right' style='width: 100%; text-align: right;'></td></tr>
			<tr><td align='right'><button type='button' id='btnExit' onclick='closeSign();' title='<%=LabelManager.getToolTip(labelSet,"btnCer")%>'><%=LabelManager.getName(labelSet,"btnCer")%></button></td></tr>
 		</tbody>
 	</table>
</div>
</body>
</html>
 