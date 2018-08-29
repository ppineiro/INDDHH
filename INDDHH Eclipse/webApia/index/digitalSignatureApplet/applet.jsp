<%@page import="biz.statum.apia.web.bean.BasicBeanStatic"%><%@ taglib prefix="system"	uri="/WEB-INF/system-tags.tld" %><%@page import="com.st.util.labels.LabelManager"%><%@page import="com.dogma.UserData"%><%@page import="java.util.Iterator"%><%@page import="sun.misc.BASE64Encoder"%><%@page import="com.dogma.Parameters"%><%@page import="java.util.HashMap"%><html style="overflow: hidden;" ><head><%
String labelSet = "0001"+String.valueOf(Parameters.DEFAULT_LABEL_SET);

UserData uData = BasicBeanStatic.getUserDataStatic(request);
if (uData!=null) {
	labelSet = uData.getStrLabelSetId();
}	
%><script type="text/javascript">
	var lblPwd = '<%=LabelManager.getName(uData,"lblPwd")%>';
	var lblCert = '<%=LabelManager.getName(uData,"lblCert")%>';
	var lblSignOk = '<%=LabelManager.getName(uData,"lblAppletSignOK")%>';
	var lblContinueSign = '<%=LabelManager.getName(uData,"lblContinueSign")%>';
</script><script type="text/javascript" src="<system:util show="context" />/digitalSignatureApplet/applet.js"></script><script type="text/javascript" src="<system:util show="context" />/js/mootools-core-1.4.5-full-compat.js"></script><script type="text/javascript" src="<system:util show="context" />/js/mootools-more-1.4.0.1-compat.js"></script><link href="<system:util show="context" />/css/<system:util show="currentStyle" />/modal.css" rel="stylesheet" type="text/css"><link href="<system:util show="context" />/css/<system:util show="currentStyle" />/generalExecution.css" rel="stylesheet" type="text/css"><style type="text/css">
.div-applet {
	width: auto !important;
}
#divContent {
	height: 134px;
}

#signApplet {
	height: 0px;
}

</style></head><body style="background-color: #EFEFEF; overflow: hidden;" tabIndex=-1 onload="self.focus();"><%
	StringBuffer strApplet = new StringBuffer();


	
	HashMap<String,String> data = (HashMap<String,String>)request.getSession().getAttribute("HASH_TO_SIGN"); 
	if(data!=null && data.size() >0){ 
		
		
		strApplet.append("<div id='div-applet' class='div-applet modalContent' style='display: none;'>" +
				"<div class='header'><span>" + LabelManager.getName(uData,"lblAppletTitl") + "</span></div>" +
				"<div id='divContent' class='content'><div id='divContentMsg'></div></div>" +
				"<div class='footer'>" +
// 					"<button type='button' id='btnNext' disabled='true' style='display:none;' onclick='btnNext_click()' title='" + LabelManager.getToolTip(labelSet,"btnNextSign") + "'>" + LabelManager.getName(uData,"btnNextSign") + "</button>" +
					"<div tabIndex='2' class='button' id='btnNext' disabled='true' style='display:none;' title='" + LabelManager.getToolTip(labelSet,"btnNextSign") + "'>" + LabelManager.getName(uData,"btnNextSign") + "</div>" +
					"<div tabIndex='3' class='button' id='btnConf' style='display:none; margin-left: 12px;' title='" + LabelManager.getToolTip(labelSet,"btnConfSign") + "'>" + LabelManager.getName(uData,"btnConfSign") + "</div>" +
					"<div tabIndex='4' class='close' id='btnExit' style='display:none;' title='" + LabelManager.getToolTip(labelSet,"btnExitSign") + "'>" + LabelManager.getName(uData,"btnExitSign") + "</div>" +
				"</div>" +
		"</div>");
		
		
		strApplet.append("<!--[if !IE]> -->");
		strApplet.append("<object id='signApplet' classid='java:com/apia/sign/Sign.class' "); 
		strApplet.append("type='application/x-java-applet' ");
		strApplet.append("archive='" + Parameters.ROOT_PATH + "/digitalSignatureApplet/signedAppletFirma.jar, " + Parameters.ROOT_PATH + "/digitalSignatureApplet/bcprov-jdk15on-150.jar, " + Parameters.ROOT_PATH + "/digitalSignatureApplet/commons-io-1.3.2.jar, " + Parameters.ROOT_PATH + "/digitalSignatureApplet/swing-layout-1.0.4.jar, " + Parameters.ROOT_PATH + "/digitalSignatureApplet/bcprov-ext-jdk15on-150.jar, " + Parameters.ROOT_PATH + "/digitalSignatureApplet/bcpkix-jdk15on-150.jar, " + Parameters.ROOT_PATH + "/digitalSignatureApplet/itextpdf-5.4.3.jar' "); 
		strApplet.append("height='190' width='400' >");
		strApplet.append("<param name='code' value='com/apia/sign/Sign.class' />");

		BASE64Encoder base64encoder = new BASE64Encoder(); ;
		int i=0;
		Iterator<String> it = data.keySet().iterator();
		while(it.hasNext()){
			String key = it.next();
			String value = (String)data.get(key);
				try{
					value = base64encoder.encodeBuffer(value.getBytes());
					
				}catch(Exception e){
					System.out.println("........."+e.getMessage());
				}
			value = value.replace("\n","");
			value = value.replace("\r","");
			strApplet.append("<param name='obj_id_" + i + "' value='" + key + "'>");
			strApplet.append("<param name='hash_data_" + i + "' value='" + value + "'>");
			i++;
		}
		
		UserData ud = BasicBeanStatic.getUserDataStatic(request);
		
		strApplet.append("<param name='campoClave' value='"+Parameters.SIGN_SEARCH_ATTRIBUTES+"'>");
		strApplet.append("<param name='rootCAs' value='"+Parameters.SIGN_ROOT_CAs+"'>");
		if(Parameters.SIGN_CHECK_REVOKED){
			strApplet.append("<param name='revListURL' value='/digitalSignatureApplet/checkRevList.jsp'>");
		}
		
		//---file chooser
		if(Parameters.DIGITAL_SIGN_ALWAYS_BROWSE){
			strApplet.append("<param name='filePicker' value='true'>");
		}
		strApplet.append("<param name='NSSeToken' value='"+Parameters.DIGITAL_SIGN_NSS_ETOKEN+"'>");
		strApplet.append("<param name='useHTMLInterface' value='true'>");
		
		strApplet.append("<param name='validateWithCAinServer' value='"+Parameters.DIGITAL_SIGN_VALIDATE_CA_IN_APIA+"'>");
		strApplet.append("<param name='lblAppletCRLExpired'  value='");strApplet.append(LabelManager.getName(uData,"lblAppletCRLExpired"));strApplet.append("'>");
		strApplet.append("<param name='lblAppletCertRevoked'  value='");strApplet.append(LabelManager.getName(uData,"lblAppletCertRevoked"));strApplet.append("'>");
		
		strApplet.append("<param name='sessionId' value='"+session.getId()+"'>");
		
		strApplet.append("<param name='appletToken' value='true'>");
		strApplet.append("<param name='checkCertDate' value='"+Parameters.SIGN_CHECK_DATE+"'>");
		strApplet.append("<param name='certificateId' value='" + ud.getDigitalCertificateUserKey() + "'>");
		strApplet.append("<param name='apiaServer' value='"+Parameters.ROOT_PATH+"'>");
		strApplet.append("<param name='dataReceptor'  value='digitalSignatureApplet/saveSignature.jsp'>");
		strApplet.append("<param name='timeURL' value='/digitalSignatureApplet/getServerTime.jsp'>");
		strApplet.append("<param name='getServerTimeForPKCS7' value='/digitalSignatureApplet/getServerTime.jsp'>");
		strApplet.append("<param name='lblAppletSignOK'  value='");strApplet.append(LabelManager.getName(uData,"lblAppletSignOK"));strApplet.append("'>");
		strApplet.append("<param name='lblAppletSignErr'  value='");strApplet.append(LabelManager.getName(uData,"lblAppletSignErr"));strApplet.append("'>");
		strApplet.append("<param name='lblAppletCantSign'  value='");strApplet.append(LabelManager.getName(uData,"lblAppletCantSign"));strApplet.append("'>");
		strApplet.append("<param name='lblAppletCertNotCA'  value='");strApplet.append(LabelManager.getName(uData,"lblAppletCertNotCA"));strApplet.append("'>");
		strApplet.append("<param name='lblAppletCertNotFound'  value='");strApplet.append(LabelManager.getName(uData,"lblAppletCertNotFound"));strApplet.append("'>");
		strApplet.append("<param name='lblAppletSigning'  value='");strApplet.append(LabelManager.getName(uData,"lblAppletSigning"));strApplet.append("'>");
		strApplet.append("<param name='lblCompTask'  value='");strApplet.append(LabelManager.getName(uData,"btnCon"));strApplet.append("'>");
		strApplet.append("<param name='lblExit'  value='");strApplet.append(LabelManager.getName(uData,"btnCer"));strApplet.append("'>");
		strApplet.append("<param name='lblAppletPrepareSign' value='");strApplet.append(LabelManager.getName(uData,"lblAppletPrepareSign"));strApplet.append("'>");
		strApplet.append("<param name='lblContinue' value='");strApplet.append(LabelManager.getName(uData,"btnCont"));strApplet.append("'>");
		strApplet.append("<param name='lblCertPwd' value='");strApplet.append(LabelManager.getName(uData,"lblCertPwd"));strApplet.append("'>");
		strApplet.append("<param name='lblTitle' value='");strApplet.append(LabelManager.getName(uData,"lblAppletTitle"));strApplet.append("'>");
		strApplet.append("<param name='lblSelectCerts' value='");strApplet.append(LabelManager.getName(uData,"lblSelectCerts"));strApplet.append("'>");
		strApplet.append("<param name='lblAppletCertExpired' value='");strApplet.append(LabelManager.getName(uData,"lblAppletCertExpired"));strApplet.append("'>");
		strApplet.append("<param name='lblAppletCertNotYetValid' value='");strApplet.append(LabelManager.getName(uData,"lblAppletCertNotYetValid"));strApplet.append("'>");
		strApplet.append("<param name='lblAppletCertInvPwd' value='");strApplet.append(LabelManager.getName(uData,"lblAppletCertInvPwd"));strApplet.append("'>");
		strApplet.append("<param name='lblNoCerts' value='");strApplet.append(LabelManager.getName(uData,"lblNoCerts"));strApplet.append("'>");
		
		strApplet.append("<param name='lblNoToken' value='");strApplet.append(LabelManager.getName(uData,"lblNoToken"));strApplet.append("'>");
		strApplet.append("<param name='lblWrongPass' value='");strApplet.append(LabelManager.getName(uData,"lblWrongPass"));strApplet.append("'>");
		strApplet.append("<param name='lblTokenRemoved' value='");strApplet.append(LabelManager.getName(uData,"lblTokenRemoved"));strApplet.append("'>");
		
		//Test para linux
		strApplet.append("<param name='mayscript' value='true' />");

		strApplet.append("<!-- For Konqueror -->");
		strApplet.append("<param name='archive' value='" + Parameters.ROOT_PATH + "/digitalSignatureApplet/signedAppletFirma.jar, " + Parameters.ROOT_PATH + "/digitalSignatureApplet/bcprov-jdk15on-150.jar, " + Parameters.ROOT_PATH + "/digitalSignatureApplet/commons-io-1.3.2.jar, " + Parameters.ROOT_PATH + "/digitalSignatureApplet/swing-layout-1.0.4.jar, " + Parameters.ROOT_PATH + "/digitalSignatureApplet/bcprov-ext-jdk15on-150.jar, " + Parameters.ROOT_PATH + "/digitalSignatureApplet/bcpkix-jdk15on-150.jar, " + Parameters.ROOT_PATH + "/digitalSignatureApplet/itextpdf-5.4.3.jar' />");
		strApplet.append("<param name='persistState' value='false' />");
		strApplet.append("<center>");
		strApplet.append("<p><strong>Apia requires Java 1.5 or higher, which your browser does not appear to have.</strong></p>");
		strApplet.append("<p><a href='http://www.java.com/en/download/index.jsp'>Get the latest Java Plug-in.</a></p>");
		strApplet.append("</center>");
		strApplet.append("</object>");
		strApplet.append("<!--<![endif]-->");
		strApplet.append("<!--[if IE]>");
		strApplet.append("<object id='signApplet' classid='clsid:8AD9C840-044E-11D1-B3E9-00805F499D93' "); 
		strApplet.append("codebase='http://java.sun.com/products/plugin/autodl/jinstall-1_4-windows-i586.cab#Version=1,4,0,0' ");
		strApplet.append("height='190' width='400' >"); 
		strApplet.append("<param name='code' value='com/apia/sign/Sign.class' />");
		strApplet.append("<param name='archive' value='" + Parameters.ROOT_PATH + "/digitalSignatureApplet/signedAppletFirma.jar, " + Parameters.ROOT_PATH + "/digitalSignatureApplet/bcprov-jdk15on-150.jar, " + Parameters.ROOT_PATH + "/digitalSignatureApplet/commons-io-1.3.2.jar, " + Parameters.ROOT_PATH + "/digitalSignatureApplet/swing-layout-1.0.4.jar, " + Parameters.ROOT_PATH + "/digitalSignatureApplet/bcprov-ext-jdk15on-150.jar, " + Parameters.ROOT_PATH + "/digitalSignatureApplet/bcpkix-jdk15on-150.jar, " + Parameters.ROOT_PATH + "/digitalSignatureApplet/itextpdf-5.4.3.jar' />");
		strApplet.append("<param name='persistState' value='false' />");

		base64encoder = new BASE64Encoder(); ;
		i=0;
		it = data.keySet().iterator();
		while(it.hasNext()){
			String key = (String)it.next();
			String value = (String)data.get(key);
				try{
					value = base64encoder.encodeBuffer(value.getBytes());
					
				}catch(Exception e){
					System.out.println("........."+e.getMessage());
				}
			value = value.replace("\n","");
			value = value.replace("\r","");
			strApplet.append("<param name='obj_id_" + i + "' value='" + key + "'>");
			strApplet.append("<param name='hash_data_" + i + "' value='" + value + "'>");
			i++;
		}
		
		ud = BasicBeanStatic.getUserDataStatic(request);
		
		strApplet.append("<param name='campoClave' value='"+Parameters.SIGN_SEARCH_ATTRIBUTES+"'>");
		strApplet.append("<param name='rootCAs' value='"+Parameters.SIGN_ROOT_CAs+"'>");
		if(Parameters.SIGN_CHECK_REVOKED){
			strApplet.append("<param name='revListURL' value='/digitalSignatureApplet/checkRevList.jsp'>");
		}
		//---file chooser
		if(Parameters.DIGITAL_SIGN_ALWAYS_BROWSE){
			strApplet.append("<param name='filePicker' value='true'>");
		}
		strApplet.append("<param name='NSSeToken' value='"+Parameters.DIGITAL_SIGN_NSS_ETOKEN+"'>");
		strApplet.append("<param name='useHTMLInterface' value='true'>");
		strApplet.append("<param name='validateWithCAinServer' value='"+Parameters.DIGITAL_SIGN_VALIDATE_CA_IN_APIA+"'>");
		
		strApplet.append("<param name='lblAppletCRLExpired'  value='");strApplet.append(LabelManager.getName(uData,"lblAppletCRLExpired"));strApplet.append("'>");
		strApplet.append("<param name='lblAppletCertRevoked'  value='");strApplet.append(LabelManager.getName(uData,"lblAppletCertRevoked"));strApplet.append("'>");
		
		strApplet.append("<param name='sessionId' value='"+session.getId()+"'>");
		
		strApplet.append("<param name='appletToken' value='true'>");
		strApplet.append("<param name='checkCertDate' value='"+Parameters.SIGN_CHECK_DATE+"'>");
		strApplet.append("<param name='certificateId' value='" + ud.getDigitalCertificateUserKey() + "'>");
		strApplet.append("<param name='apiaServer' value='"+Parameters.ROOT_PATH+"'>");
		strApplet.append("<param name='dataReceptor'  value='digitalSignatureApplet/saveSignature.jsp'>");
		strApplet.append("<param name='timeURL' value='/digitalSignatureApplet/getServerTime.jsp'>");
		strApplet.append("<param name='getServerTimeForPKCS7' value='/digitalSignatureApplet/getServerTime.jsp'>");
		strApplet.append("<param name='lblAppletSignOK'  value='");strApplet.append(LabelManager.getName(uData,"lblAppletSignOK"));strApplet.append("'>");
		strApplet.append("<param name='lblAppletSignErr'  value='");strApplet.append(LabelManager.getName(uData,"lblAppletSignErr"));strApplet.append("'>");
		strApplet.append("<param name='lblAppletCantSign'  value='");strApplet.append(LabelManager.getName(uData,"lblAppletCantSign"));strApplet.append("'>");
		strApplet.append("<param name='lblAppletCertNotCA'  value='");strApplet.append(LabelManager.getName(uData,"lblAppletCertNotCA"));strApplet.append("'>");
		strApplet.append("<param name='lblAppletCertNotFound'  value='");strApplet.append(LabelManager.getName(uData,"lblAppletCertNotFound"));strApplet.append("'>");
		strApplet.append("<param name='lblAppletSigning'  value='");strApplet.append(LabelManager.getName(uData,"lblAppletSigning"));strApplet.append("'>");
		strApplet.append("<param name='lblCompTask'  value='");strApplet.append(LabelManager.getName(uData,"btnCon"));strApplet.append("'>");
		strApplet.append("<param name='lblExit'  value='");strApplet.append(LabelManager.getName(uData,"btnCer"));strApplet.append("'>");
		strApplet.append("<param name='lblAppletPrepareSign' value='");strApplet.append(LabelManager.getName(uData,"lblAppletPrepareSign"));strApplet.append("'>");
		strApplet.append("<param name='lblContinue' value='");strApplet.append(LabelManager.getName(uData,"btnCont"));strApplet.append("'>");
		strApplet.append("<param name='lblCertPwd' value='");strApplet.append(LabelManager.getName(uData,"lblCertPwd"));strApplet.append("'>");
		strApplet.append("<param name='lblTitle' value='");strApplet.append(LabelManager.getName(uData,"lblAppletTitle"));strApplet.append("'>");
		strApplet.append("<param name='lblSelectCerts' value='");strApplet.append(LabelManager.getName(uData,"lblSelectCerts"));strApplet.append("'>");
		strApplet.append("<param name='lblAppletCertExpired' value='");strApplet.append(LabelManager.getName(uData,"lblAppletCertExpired"));strApplet.append("'>");
		strApplet.append("<param name='lblAppletCertNotYetValid' value='");strApplet.append(LabelManager.getName(uData,"lblAppletCertNotYetValid"));strApplet.append("'>");
		strApplet.append("<param name='lblAppletCertInvPwd' value='");strApplet.append(LabelManager.getName(uData,"lblAppletCertInvPwd"));strApplet.append("'>");
		strApplet.append("<param name='lblNoCerts' value='");strApplet.append(LabelManager.getName(uData,"lblNoCerts"));strApplet.append("'>");
		
		//Test para linux
		strApplet.append("<param name='mayscript' value='true' />");
		
		strApplet.append("<center>");
		strApplet.append("<p><strong>Apia requires Java 1.5 or higher, which your browser does not appear to have.</strong></p>");
		strApplet.append("<p><a href='http://www.java.com/en/download/index.jsp'>Get the latest Java Plug-in.</a></p>");
		strApplet.append("</center>");
		strApplet.append("</object>");
		strApplet.append("<![endif]-->");


		out.print(strApplet.toString());
		 		
	
}
 %></body></html>
 