<%@page import="com.dogma.EnvParameters"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Collection"%>
<%@page import="biz.statum.sdk.util.StringUtil"%>
<%@page import="com.dogma.Configuration"%>
<%@page import="biz.statum.apia.web.bean.BasicBeanStatic"%>
<%@page import="com.st.util.labels.LabelManager"%>
<%@page import="com.dogma.UserData"%>
<%@page import="java.util.Iterator"%>
<%@page import="sun.misc.BASE64Encoder"%>
<%@page import="com.dogma.Parameters"%>
<%@page import="java.util.HashMap"%>
<%@page import="com.dogma.controller.ThreadData"%>
<%@page import="uy.com.st.adoc.mensajes.MensajeDAO"%>
<%@page import="uy.com.st.adoc.expedientes.constantes.Values"%>
<%@page import="uy.com.st.adoc.expedientes.helper.Helper"%>
<%@page import="uy.com.st.adoc.expedientes.conf.ConfigurationManager"%>
<%@page import="java.net.URLEncoder"%>
<%response.setCharacterEncoding(com.dogma.Parameters.APP_ENCODING);%>

<html style="overflow: hidden;" >
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=<%=com.dogma.Parameters.APP_ENCODING%>">
	<%
	UserData uData = BasicBeanStatic.getUserDataStatic(request);
	
	MensajeDAO mensajeDao = new MensajeDAO();
	
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
	
	String htmlData = "";
	if (ud.getUserAttributes() !=null){	
 		if (ud.getUserAttributes().get("APPLET_SRC_CHROME")!=null){
			htmlData = (String)ud.getUserAttributes().get("APPLET_SRC_CHROME");			
			System.out.println( "APPLET_SRC_CHROME: " + htmlData ); 			
		}else{
			System.out.println( "NO HAY DATOS EN SESSION 1" );
		}
	}else{
		System.out.println( "NO HAY DATOS EN SESSION 2 " );
	}
	System.out.println("FIN FAC");
	
	String token_linux = Helper.obtenerUsuarioFirmaConToken(ud.getUserId(),environmentId);	
	
	String esMC = request.getParameter("esMC").toString();
	%>
	
	<link href="../../css/documentum/common/modal.css" rel="stylesheet" type="text/css">
	<link href="../../css/documentum/execution/generalExecution.css" rel="stylesheet" type="text/css">
		
	<script type="text/javascript" src="../../js/mootools-core-1.4.5-full-compat.js"></script>
	<script type="text/javascript" src="../../js/mootools-more-1.4.0.1-compat.js"></script>	
	<script type="text/javascript">
		
		var buttonTask = "";	
		var buttonClose = "";
		
		if ("<%= esMC%>" == "true"){
			buttonTask =	"<div class='button' id='btnConf' onclick='nextStep();' style='margin-left: 12px;' title='Confirmar firma'>Completar</div>";
			buttonClose =	"<div class=\"close\" id=\"btnExit\" title=\"Cancelar\">Cancelar</div>";
		}else{
			buttonTask = "<%=mensajeDao.obtenerMensajePorCodigo(Values.LBL_APPLET_COMP_TASK, 1,environmentId)%>";
			buttonClose = "<%=mensajeDao.obtenerMensajePorCodigo(Values.LBL_APPLET_EXIT, 1,environmentId)%>";
		}
	
		var params = {
				campoClave: "<%=Parameters.SIGN_SEARCH_ATTRIBUTES%>",
				rootCAs: "<%=Parameters.SIGN_ROOT_CAs%>",
				NSSeToken: "<%=token_linux%>",
				filePicker: "<%=ConfigurationManager.debeElegirUbicacionCertificado(environmentId,1, false)%>",
				useHTMLInterface: "true",
				lblAppletCRLExpired: "<%=LabelManager.getName(labelSet,"lblAppletCRLExpired")%>",
				lblAppletCertRevoked: "<%=LabelManager.getName(labelSet,"lblAppletCertRevoked")%>",
				sessionId: "<%=session.getId()%>",
				sessionIdName: "<%=ConfigurationManager.getSessionIdName(environmentId, 1, false)%>",
				routeCookieValue: "<%=session.getId()%>",
				routeCookie: "ROUTEID",
				algoritmo: "SHA256withRSA",
				key_factor: "RSA",
				digest: "SHA-256",
				
				appletToken: "true",
				checkCertDate: "<%=Parameters.SIGN_CHECK_DATE%>",
				
				dataReceptor: "expedientes/firma/guardarFirmaChrome.jsp?<%				
					out.write("TMP_NRO_DOC_A_FIRMAR_STR=" + URLEncoder.encode((String)uData.getUserAttributes().get("TMP_NRO_DOC_A_FIRMAR_STR"),"UTF-8"));
					out.write("&ENV_NAME=" + uData.getUserAttributes().get("ENV_NAME"));
					out.write("&VERSION_CARATULA_RELACIONADA=" + uData.getUserAttributes().get("VERSION_CARATULA_RELACIONADA"));
					out.write("&JEFATURA=" + uData.getUserAttributes().get("JEFATURA"));
					out.write("&envId=" + uData.getEnvironmentId());
					out.write("&userId=" + uData.getUserId());					
				%>" + parent.TAB_ID_REQUEST  + "&",
				
				timeURL: "/digitalSignatureApplet/getServerTime.jsp",
				getServerTimeForPKCS7: "/digitalSignatureApplet/getServerTime.jsp",
				lblAppletSignOK: getMsgPostFirma(),
				lblAppletSignErr: "<%=mensajeDao.obtenerMensajePorCodigo(Values.LBL_APPLET_SIGN_ERROR, 1,environmentId)%>",
				lblAppletCantSign: "<%=mensajeDao.obtenerMensajePorCodigo(Values.LBL_APPLET_CANT_SIGN, 1,environmentId)%>",
				lblAppletCertNotCA: "<%=mensajeDao.obtenerMensajePorCodigo(Values.LBL_APPLET_CERT_NOT_CA, 1,environmentId)%>",
				lblAppletCertNotFound: "<%=mensajeDao.obtenerMensajePorCodigo(Values.LBL_APPLET_CERT_NOT_FOUND, 1,environmentId)%>",
				
				lblCompTask: buttonTask,				
				lblExit: buttonClose,
				
				
				lblCompTaskTooltip: "<%=LabelManager.getToolTip(labelSet,"btnConfSign")%>",
				lblNoDataForSignFound: "<%=LabelManager.getName(labelSet,"msgNoDataForSignFound")%>",
				
				lblWaitForSign: getSpinnerFirma(),
				lblAppletPrepareSign: "<%=mensajeDao.obtenerMensajePorCodigo(Values.LBL_APPLET_PREPARE_SIGN, 1,environmentId)%>",
				lblContinue: "<%=mensajeDao.obtenerMensajePorCodigo(Values.LBL_APPLET_CONTINUE, 1,environmentId)%>",
				lblCertPwd: "<%=mensajeDao.obtenerMensajePorCodigo(Values.LBL_APPLET_CERT_PWD, 1,environmentId)%>",
				lblTitle: "<%=mensajeDao.obtenerMensajePorCodigo(Values.LBL_APPLET_TITTLE, 1,environmentId)%>",
				lblSelectCerts: "<%=mensajeDao.obtenerMensajePorCodigo(Values.LBL_APPLET_SELECT_CERTS, 1,environmentId)%>",
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
				lblAppletSigning: "<%=mensajeDao.obtenerMensajePorCodigo(Values.LBL_APPLET_SIGNING, 1,environmentId) %>",<%
				if(Parameters.SIGN_CHECK_REVOKED){
					out.write("revListURL: \"/digitalSignatureApplet/checkRevList.jsp\",");
				}%>
				dataToSign : [],
				signatureVersion: "9.14",
				apiaVersion: 2,
			};
			
		<%=htmlData%>

		localStorage["dataToSign"] = JSON.stringify(params);
		
		function nextStep(){			
			window.parent.appletNextStepConfirmer(localStorage["result"], localStorage["appletTokenId"]);
			frameElement.fireEvent('closeModal');
		}
		
		function cofirmTask() {
			window.parent.appletConfirmer(localStorage["result"], localStorage["appletTokenId"]);
			frameElement.fireEvent('closeModal');//saca el modal de firma
		}
		
		function closeSign() {
			window.parent.appletCloser(localStorage["result"], localStorage["appletTokenId"]);
			frameElement.fireEvent('closeModal');	
		}
		
		setTimeout(function() {
			if(!document.body.className.match('extension-is-installed')) {
				// NO SE INSTALO LA EXTENSION
				var execBlocker = document.getElementById('exec-blocker');
				execBlocker.parentNode.removeChild(execBlocker);
				frameElement.style.height = document.getElementById('div-applet').offsetHeight + "px";
				frameElement.style.width = document.getElementById('div-applet').offsetWidth + "px";
			}
		}, 3000);
	
		function getSpinnerFirma(){
			var html =
			"<div style='position: absolute; left: 38%; top: 27%;'>" +
				"<img name='spinnerFirma' id='spinnerFirma' src='../../css/documentum/img/signature/spinnerChromeJava.gif'>" +
			"</div>"
			;
			return html;
		}
		
		function getMsgPostFirma(){
			var html =
				"<div style='position: absolute; width:200; left: 25% ; top: 45%;'>" +
					"Firma realizada con éxito, haga clic en Completar para finalizar." +
				"</div>"
			;
			return html;
		}
		
	</script>
	
	<style>
		#exec-blocker { 	position: absolute; top: 0px; left: 25px; width: 410px; height: 225px; background-color: white; }
		#divContentMsg { text-align: center; }
		#divContent{ overflow: hidden; padding: 8px; max-height: 300px; height: 127px; text-align: justify; /* maxHeight is defined by code in modal.js */ }
		#div-applet{ width: 418px; }		
	</style>

</head>

<body tabIndex=-1 onload="self.focus(); frameElement.style.height = document.getElementById('div-applet').offsetHeight + 'px'; frameElement.style.width = document.getElementById('div-applet').offsetWidth + 'px';"   style="padding: 0px; background-color: #efefef;">
	<div id='div-applet' class='div-applet modalContent'>
		<div id="exec-blocker"></div>
		
		<div class='header'>
			<span><%=LabelManager.getName(uData,"lblAppletTitle")%></span>
		</div>	
		
	 	<div id='divContent'>
	 		<% 	System.out.println("FAC htmlData " + htmlData);

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
	 		<div class='close' id='btnExit' onclick='closeSign()' title='<%=LabelManager.getToolTip(uData,"btnCer")%>'><%=LabelManager.getName(uData,"btnCer")%></div>	 		
	 	</div>
	</div>
</body>
</html>
 