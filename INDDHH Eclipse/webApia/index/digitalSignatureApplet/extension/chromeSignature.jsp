<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Collection"%>
<%@page import="biz.statum.sdk.util.StringUtil"%>
<%@page import="com.dogma.Configuration"%>
<%@page import="biz.statum.apia.web.bean.BasicBeanStatic"%>
<%@ taglib prefix="system"	uri="/WEB-INF/system-tags.tld" %>
<%@page import="com.st.util.labels.LabelManager"%>
<%@page import="com.dogma.UserData"%>
<%@page import="java.util.Iterator"%>
<%@page import="sun.misc.BASE64Encoder"%>
<%@page import="com.dogma.Parameters"%>
<%@page import="java.util.HashMap"%>
<%response.setCharacterEncoding(com.dogma.Parameters.APP_ENCODING);%>
<html style="overflow: hidden;" >
<head>
<meta http-equiv="Content-Type" content="text/html; charset=<%=com.dogma.Parameters.APP_ENCODING%>">
<%
UserData uData = BasicBeanStatic.getUserDataStatic(request);
%>

<script type="text/javascript" src="<system:util show="context" />/js/mootools-core-1.4.5-full-compat.js"></script>
<script type="text/javascript" src="<system:util show="context" />/js/mootools-more-1.4.0.1-compat.js"></script>

<link href="<system:util show="context" />/css/<system:util show="currentStyle" />/modal.css" rel="stylesheet" type="text/css">
<link href="<system:util show="context" />/css/<system:util show="currentStyle" />/generalExecution.css" rel="stylesheet" type="text/css">

<script type="text/javascript">

var params = {
	campoClave: "<%=Parameters.SIGN_SEARCH_ATTRIBUTES%>",
	rootCAs: "<%=Parameters.SIGN_ROOT_CAs%>",
	NSSeToken: "<%=Parameters.DIGITAL_SIGN_NSS_ETOKEN%>",
	filePicker: "<%=Parameters.DIGITAL_SIGN_ALWAYS_BROWSE ? "true" : "false"%>",
	useHTMLInterface: "true",
	validateWithCAinServer: "<%=Parameters.DIGITAL_SIGN_VALIDATE_CA_IN_APIA%>",
	lblAppletCRLExpired: "<%=LabelManager.getName(uData, "lblAppletCRLExpired")%>",
	lblAppletCertRevoked: "<%=LabelManager.getName(uData, "lblAppletCertRevoked")%>",
	sessionId: "<%=session.getId()%>",
	appletToken: "true",
	checkCertDate: "<%=Parameters.SIGN_CHECK_DATE%>",
	certificateId: "<%=uData.getDigitalCertificateUserKey()%>",
	apiaServer: location.origin + "<%=Parameters.ROOT_PATH%>",
	dataReceptor: "digitalSignatureApplet/saveSignature.jsp",
	timeURL: "/digitalSignatureApplet/getServerTime.jsp",
	getServerTimeForPKCS7: "/digitalSignatureApplet/getServerTime.jsp",
	lblAppletSignOK: "<%=LabelManager.getName(uData,"lblAppletSignOK")%>",
	lblAppletSignErr: "<%=LabelManager.getName(uData,"lblAppletSignErr")%>",
	lblAppletCantSign: "<%=LabelManager.getName(uData,"lblAppletCantSign")%>",
	lblAppletCertNotCA: "<%=LabelManager.getName(uData,"lblAppletCertNotCA")%>",
	lblAppletCertNotFound: "<%=LabelManager.getName(uData,"lblAppletCertNotFound")%>",
	lblCompTask: "<%=LabelManager.getName(uData,"btnCon")%>",
	lblExit: "<%=LabelManager.getName(uData,"btnCer")%>",
	lblCompTaskTooltip: "<%=LabelManager.getToolTip(uData,"btnConfSign")%>",
	lblNoDataForSignFound: "<%=LabelManager.getName(uData,"msgNoDataForSignFound")%>",
	lblWaitForSign: "<%=LabelManager.getName(uData,"msgWaitForSign")%>",
	lblAppletPrepareSign: "<%=LabelManager.getName(uData,"lblAppletPrepareSign")%>",
	lblContinue: "<%=LabelManager.getName(uData,"btnCont")%>",
	lblCertPwd: "<%=LabelManager.getName(uData,"lblCertPwd")%>",
	lblTitle: "<%=LabelManager.getName(uData,"lblAppletTitle")%>",
	lblSelectCerts: "<%=LabelManager.getName(uData,"lblSelectCerts")%>",
	lblAppletCertExpired: "<%=LabelManager.getName(uData,"lblAppletCertExpired")%>",
	lblAppletCertNotYetValid: "<%=LabelManager.getName(uData,"lblAppletCertNotYetValid")%>",
	lblAppletCertInvPwd: "<%=LabelManager.getName(uData,"lblAppletCertInvPwd")%>",
	lblSignWrongVersion: "<%
		Collection<String> toks = new ArrayList<String>();
		toks.add("<a href='apiaDigitalSignatureInstaller.jar' download>");
		toks.add("</a>");
		out.write(LabelManager.getName(uData,"msgSignWrongVersion") + " " + StringUtil.parseMessage(LabelManager.getName(uData,"msgDownloadSignInst"), toks));
	%>" ,
	lblNoCerts: "<%=LabelManager.getName(uData,"lblNoCerts")%>",
	lblNoToken: "<%=LabelManager.getName(uData,"lblNoToken")%>",
	lblWrongPass: "<%=LabelManager.getName(uData,"lblWrongPass")%>",
	lblTokenRemoved: "<%=LabelManager.getName(uData,"lblTokenRemoved")%>",
	lblNativeAppNotFound: "<%	
		out.write(LabelManager.getName(uData,"msgNativeAppNotFound") + "<br/>");
		
		toks = new ArrayList<String>();
		toks.add("<a href='apiaDigitalSignatureInstaller.jar' download>");
		toks.add("</a>");
		
		out.write(StringUtil.parseMessage(LabelManager.getName(uData,"msgDownloadSignInst"), toks));
	%>",
	lblAppletSigning: "<%=LabelManager.getName(uData,"lblAppletSigning")%>",<%
	if(Parameters.SIGN_CHECK_REVOKED){
		out.write("revListURL: \"/digitalSignatureApplet/checkRevList.jsp\",");
	}%>
	dataToSign : [],
	signatureVersion: "9.5"
};

<%

HashMap<String, String> data = (HashMap<String,String>)request.getSession().getAttribute("HASH_TO_SIGN"); 
if(data != null && data.size() > 0) {
	BASE64Encoder base64encoder = new BASE64Encoder();
	Iterator<String> it = data.keySet().iterator();
	while(it.hasNext()) {
		String key = it.next();
		String value = (String)data.get(key);
		try {
			value = base64encoder.encodeBuffer(value.getBytes());
		} catch(Exception e) {
			System.out.println("........." + e.getMessage());
		}
		value = value.replace("\n","");
		value = value.replace("\r","");
		out.write("params.dataToSign.push({objId: '" + key + "', hashData: '" + value + "'});");
	}
}
%>

localStorage["dataToSign"] = JSON.stringify(params);

function cofirmTask() {
	window.parent.appletConfirmer(localStorage["result"], localStorage["appletTokenId"]);
}

function closeSign() {
	window.parent.appletCloser(localStorage["result"], localStorage["appletTokenId"]);
}

setTimeout(function() {
	if(!document.body.className.contains('extension-is-installed')) {
		//No se instaló la extensión
		var execBlocker = $('exec-blocker');
		if(execBlocker) {
			var fx = new Fx.Morph(execBlocker, {
				duration: 400
			});
			fx.start({
				opacity: 0
			}).chain(function() {
				execBlocker.destroy();
			});
		}
		frameElement.style.height = document.getElementById('div-applet').offsetHeight + "px";
		frameElement.style.width = document.getElementById('div-applet').offsetWidth + "px";
	}
}, 3000);

</script>

</head>
<body tabIndex=-1 onload="self.focus();">
<div id='div-applet' class='div-applet modalContent'>
	<div id="exec-blocker"></div>
	<div class='header'>
		<span><%=LabelManager.getName(uData,"lblAppletTitle")%></span>
	</div>
 	<div id='divContent' class='content'>
 		<%
 		toks = new ArrayList<String>();
 		toks.add("<em>");
 		toks.add("</em>");
 		 		
 		out.write(StringUtil.parseMessage(LabelManager.getName(uData,"msgNoSignExt"), toks) + "<br/>");
 		
 		toks = new ArrayList<String>();
 		toks.add("<a href=\"apiaDigitalSignatureInstaller.jar\" download>");
 		toks.add("</a>");
 		 		
 		out.write(StringUtil.parseMessage(LabelManager.getName(uData,"msgDownloadSignInst"), toks) + "<br/>");
 		
 		toks = new ArrayList<String>();
 		toks.add("<strong>chrome://extensions</strong>");
 		 		
 		out.write(StringUtil.parseMessage(LabelManager.getName(uData,"msgVerifyEnabExt"), toks) + "<br/>");
 		
 		toks = new ArrayList<String>();
 		toks.add("<a href=\"https://chrome.google.com/webstore/detail/apia-digital-signature-ex/lofgfkcbecnmhnkalgpbgafobgkodjpg\" target=\"_blank\">");
 		toks.add("</a>");
 			
 		out.write(StringUtil.parseMessage(LabelManager.getName(uData,"msgVerifyInstExt"), toks) + "<br/>");
 		
 		%>
 	</div>
 	<div class='footer'>
 		<div class='close' id='btnExit' onclick='closeSign();' title='<%=LabelManager.getToolTip(uData,"btnCer")%>'><%=LabelManager.getName(uData,"btnCer")%></div>
 	</div>
</div>
</body>
</html>
 