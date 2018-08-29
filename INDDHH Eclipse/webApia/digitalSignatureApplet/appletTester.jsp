<%@page import="com.st.util.labels.LabelManager"%><%@page import="com.dogma.UserData"%><%@page import="java.util.Iterator"%><%@page import="sun.misc.BASE64Encoder"%><%@page import="com.dogma.Parameters"%><%@page import="java.util.HashMap"%><html><head><script>
			function appletClose(result){
				alert("appletClose. result=" + result);
			}
			
			function appletConfirm(result){
				alert("appletConfirm. result=" + result);
			}
		</script></head><body><form method="post" action="appletTester.jsp"><%

String SIGN_SEARCH_ATTRIBUTES="ST";
String SIGN_ROOT_CAs="/RootCA/certnew.cer;/RootCA/CorreoUruguayoRootCA.crt";
boolean SIGN_CHECK_REVOKED = false;
boolean DIGITAL_SIGN_ALWAYS_BROWSE = false;
boolean DIGITAL_SIGN_NSS_ETOKEN = false;
String SIGN_CHECK_DATE = "false";
String certificateId = "77777777";


if(request.getParameter("SIGN_SEARCH_ATTRIBUTES")!=null){
	SIGN_SEARCH_ATTRIBUTES = request.getParameter("SIGN_SEARCH_ATTRIBUTES"); 
}
if(request.getParameter("SIGN_ROOT_CAs")!=null){
	SIGN_ROOT_CAs = request.getParameter("SIGN_ROOT_CAs"); 
}
if(request.getParameter("SIGN_CHECK_REVOKED")!=null){
	SIGN_CHECK_REVOKED = "true".equals(request.getParameter("SIGN_CHECK_REVOKED")); 
}
if(request.getParameter("DIGITAL_SIGN_ALWAYS_BROWSE")!=null){
	DIGITAL_SIGN_ALWAYS_BROWSE = "true".equals(request.getParameter("DIGITAL_SIGN_ALWAYS_BROWSE")); 
}
if(request.getParameter("DIGITAL_SIGN_NSS_ETOKEN")!=null){
	DIGITAL_SIGN_NSS_ETOKEN = "true".equals(request.getParameter("DIGITAL_SIGN_NSS_ETOKEN")); 
}
if(request.getParameter("SIGN_CHECK_DATE")!=null){
	SIGN_CHECK_DATE = request.getParameter("SIGN_CHECK_DATE"); 
}
if(request.getParameter("certificateId")!=null){
	certificateId = request.getParameter("certificateId"); 
}


%><table><tr><td>
			SIGN_SEARCH_ATTRIBUTES: <input type=text name="SIGN_SEARCH_ATTRIBUTES" value="<%=SIGN_SEARCH_ATTRIBUTES%>"></td><td>
			SIGN_ROOT_CAs: <input type=text name="SIGN_ROOT_CAs" value="<%=SIGN_ROOT_CAs%>"></td><td>
			SIGN_CHECK_REVOKED: <input type=text name="SIGN_CHECK_REVOKED" value="<%=SIGN_CHECK_REVOKED%>"></td></tr><tr><td>
			DIGITAL_SIGN_ALWAYS_BROWSE: <input type=text name="DIGITAL_SIGN_ALWAYS_BROWSE" value="<%=DIGITAL_SIGN_ALWAYS_BROWSE%>"></td><td>
			DIGITAL_SIGN_NSS_ETOKEN: <input type=text name="DIGITAL_SIGN_NSS_ETOKEN" value="<%=DIGITAL_SIGN_NSS_ETOKEN%>"></td><td>	
			SIGN_CHECK_DATE: <input type=text name="SIGN_CHECK_DATE" value="<%=SIGN_CHECK_DATE%>"></td></tr><tr><td colspan=3>
			certificateId: <input type=text name="certificateId" value="<%=certificateId%>"></td></tr><tr><td colspan=3><input type="submit"></td></tr></table><%

	StringBuffer strApplet = new StringBuffer();


	String labelSet = "0001"+String.valueOf(Parameters.DEFAULT_LABEL_SET);
	HashMap<String,String> data = new HashMap<String,String>();
	data.put("ID","VAL");
	if(data!=null && data.size() >0){ 
		
		strApplet.append("<!--[if !IE]> -->");
		strApplet.append("<object classid='java:com/apia/sign/Sign.class' "); 
		strApplet.append("type='application/x-java-applet' ");
		strApplet.append("archive='" + Parameters.ROOT_PATH + "/digitalSignatureApplet/signedAppletFirma.jar' "); 
		strApplet.append("height='190' width='400' >");
		strApplet.append("<param name='code' value='com/apia/sign/Sign.class' />");

		BASE64Encoder base64encoder = new BASE64Encoder(); ;
		int i=0;
		Iterator it = data.keySet().iterator();
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
		
		 
		strApplet.append("<param name='campoClave' value='"+SIGN_SEARCH_ATTRIBUTES+"'>");
		strApplet.append("<param name='rootCAs' value='"+SIGN_ROOT_CAs+"'>");
		if(SIGN_CHECK_REVOKED){
			strApplet.append("<param name='revListURL' value='/digitalSignatureApplet/checkRevList.jsp'>");
		}
		
		//---file chooser
		if(DIGITAL_SIGN_ALWAYS_BROWSE){
			strApplet.append("<param name='filePicker' value='true'>");
		}
		
		strApplet.append("<param name='NSSeToken' value='"+DIGITAL_SIGN_NSS_ETOKEN+"'>");
		strApplet.append("<param name='sessionId' value='"+session.getId()+"'>");
		
		strApplet.append("<param name='checkCertDate' value='"+SIGN_CHECK_DATE+"'>");
		strApplet.append("<param name='certificateId' value='"+certificateId+"'>");
		strApplet.append("<param name='apiaServer' value='"+Parameters.ROOT_PATH+"'>");
		strApplet.append("<param name='dataReceptor'  value='digitalSignatureApplet/saveSignature.jsp'>");
		strApplet.append("<param name='timeURL' value='/digitalSignatureApplet/getServerTime.jsp'>");
		strApplet.append("<param name='lblAppletSignOK'  value='");strApplet.append(LabelManager.getName(labelSet,"lblAppletSignOK"));strApplet.append("'>");
		strApplet.append("<param name='lblAppletSignErr'  value='");strApplet.append(LabelManager.getName(labelSet,"lblAppletSignErr"));strApplet.append("'>");
		strApplet.append("<param name='lblAppletCantSign'  value='");strApplet.append(LabelManager.getName(labelSet,"lblAppletCantSign"));strApplet.append("'>");
		strApplet.append("<param name='lblAppletCertNotCA'  value='");strApplet.append(LabelManager.getName(labelSet,"lblAppletCertNotCA"));strApplet.append("'>");
		strApplet.append("<param name='lblAppletCertNotFound'  value='");strApplet.append(LabelManager.getName(labelSet,"lblAppletCertNotFound"));strApplet.append("'>");
		strApplet.append("<param name='lblAppletSigning'  value='");strApplet.append(LabelManager.getName(labelSet,"lblAppletSigning"));strApplet.append("'>");
		strApplet.append("<param name='lblCompTask'  value='");strApplet.append(LabelManager.getName(labelSet,"btnCon"));strApplet.append("'>");
		strApplet.append("<param name='lblExit'  value='");strApplet.append(LabelManager.getName(labelSet,"btnCer"));strApplet.append("'>");
		strApplet.append("<param name='lblAppletPrepareSign' value='");strApplet.append(LabelManager.getName(labelSet,"lblAppletPrepareSign"));strApplet.append("'>");
		strApplet.append("<param name='lblContinue' value='");strApplet.append(LabelManager.getName(labelSet,"btnCont"));strApplet.append("'>");
		strApplet.append("<param name='lblCertPwd' value='");strApplet.append(LabelManager.getName(labelSet,"lblCertPwd"));strApplet.append("'>");
		strApplet.append("<param name='lblTitle' value='");strApplet.append(LabelManager.getName(labelSet,"lblAppletTitle"));strApplet.append("'>");
		strApplet.append("<param name='lblSelectCerts' value='");strApplet.append(LabelManager.getName(labelSet,"lblSelectCerts"));strApplet.append("'>");
		strApplet.append("<param name='lblAppletCertExpired' value='");strApplet.append(LabelManager.getName(labelSet,"lblAppletCertExpired"));strApplet.append("'>");
		strApplet.append("<param name='lblAppletCertNotYetValid' value='");strApplet.append(LabelManager.getName(labelSet,"lblAppletCertNotYetValid"));strApplet.append("'>");
		strApplet.append("<param name='lblAppletCertInvPwd' value='");strApplet.append(LabelManager.getName(labelSet,"lblAppletCertInvPwd"));strApplet.append("'>");
		strApplet.append("<param name='lblNoCerts' value='");strApplet.append(LabelManager.getName(labelSet,"lblNoCerts"));strApplet.append("'>");
		


		strApplet.append("<!-- For Konqueror -->");
		strApplet.append("<param name='archive' value='" + Parameters.ROOT_PATH + "/digitalSignatureApplet/signedAppletFirma.jar' />");
		strApplet.append("<param name='persistState' value='false' />");
		strApplet.append("<center>");
		strApplet.append("<p><strong>Apia requires Java 1.5 or higher, which your browser does not appear to have.</strong></p>");
		strApplet.append("<p><a href='http://www.java.com/en/download/index.jsp'>Get the latest Java Plug-in.</a></p>");
		strApplet.append("</center>");
		strApplet.append("</object>");
		strApplet.append("<!--<![endif]-->");
		strApplet.append("<!--[if IE]>");
		strApplet.append("<object classid='clsid:8AD9C840-044E-11D1-B3E9-00805F499D93' "); 
		strApplet.append("codebase='http://java.sun.com/products/plugin/autodl/jinstall-1_4-windows-i586.cab#Version=1,4,0,0' ");
		strApplet.append("height='190' width='400' >"); 
		strApplet.append("<param name='code' value='com/apia/sign/Sign.class' />");
		strApplet.append("<param name='archive' value='" + Parameters.ROOT_PATH + "/digitalSignatureApplet/signedAppletFirma.jar' />");
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
		
		
		
		strApplet.append("<param name='campoClave' value='"+SIGN_SEARCH_ATTRIBUTES+"'>");
		strApplet.append("<param name='rootCAs' value='"+SIGN_ROOT_CAs+"'>");
		if(SIGN_CHECK_REVOKED){
			strApplet.append("<param name='revListURL' value='/digitalSignatureApplet/checkRevList.jsp'>");
		}
		//---file chooser
		if(DIGITAL_SIGN_ALWAYS_BROWSE){
			strApplet.append("<param name='filePicker' value='true'>");
		}

		strApplet.append("<param name='NSSeToken' value='"+DIGITAL_SIGN_NSS_ETOKEN+"'>");
		strApplet.append("<param name='sessionId' value='"+session.getId()+"'>");
		
		
		strApplet.append("<param name='checkCertDate' value='"+SIGN_CHECK_DATE+"'>");
		strApplet.append("<param name='certificateId' value='" + certificateId + "'>");
		strApplet.append("<param name='apiaServer' value='"+Parameters.ROOT_PATH+"'>");
		strApplet.append("<param name='dataReceptor'  value='digitalSignatureApplet/saveSignature.jsp'>");
		strApplet.append("<param name='timeURL' value='/digitalSignatureApplet/getServerTime.jsp'>");
		strApplet.append("<param name='lblAppletSignOK'  value='");strApplet.append(LabelManager.getName(labelSet,"lblAppletSignOK"));strApplet.append("'>");
		strApplet.append("<param name='lblAppletSignErr'  value='");strApplet.append(LabelManager.getName(labelSet,"lblAppletSignErr"));strApplet.append("'>");
		strApplet.append("<param name='lblAppletCantSign'  value='");strApplet.append(LabelManager.getName(labelSet,"lblAppletCantSign"));strApplet.append("'>");
		strApplet.append("<param name='lblAppletCertNotCA'  value='");strApplet.append(LabelManager.getName(labelSet,"lblAppletCertNotCA"));strApplet.append("'>");
		strApplet.append("<param name='lblAppletCertNotFound'  value='");strApplet.append(LabelManager.getName(labelSet,"lblAppletCertNotFound"));strApplet.append("'>");
		strApplet.append("<param name='lblAppletSigning'  value='");strApplet.append(LabelManager.getName(labelSet,"lblAppletSigning"));strApplet.append("'>");
		strApplet.append("<param name='lblCompTask'  value='");strApplet.append(LabelManager.getName(labelSet,"btnCon"));strApplet.append("'>");
		strApplet.append("<param name='lblExit'  value='");strApplet.append(LabelManager.getName(labelSet,"btnCer"));strApplet.append("'>");
		strApplet.append("<param name='lblAppletPrepareSign' value='");strApplet.append(LabelManager.getName(labelSet,"lblAppletPrepareSign"));strApplet.append("'>");
		strApplet.append("<param name='lblContinue' value='");strApplet.append(LabelManager.getName(labelSet,"btnCont"));strApplet.append("'>");
		strApplet.append("<param name='lblCertPwd' value='");strApplet.append(LabelManager.getName(labelSet,"lblCertPwd"));strApplet.append("'>");
		strApplet.append("<param name='lblTitle' value='");strApplet.append(LabelManager.getName(labelSet,"lblAppletTitle"));strApplet.append("'>");
		strApplet.append("<param name='lblSelectCerts' value='");strApplet.append(LabelManager.getName(labelSet,"lblSelectCerts"));strApplet.append("'>");
		strApplet.append("<param name='lblAppletCertExpired' value='");strApplet.append(LabelManager.getName(labelSet,"lblAppletCertExpired"));strApplet.append("'>");
		strApplet.append("<param name='lblAppletCertNotYetValid' value='");strApplet.append(LabelManager.getName(labelSet,"lblAppletCertNotYetValid"));strApplet.append("'>");
		strApplet.append("<param name='lblAppletCertInvPwd' value='");strApplet.append(LabelManager.getName(labelSet,"lblAppletCertInvPwd"));strApplet.append("'>");
		strApplet.append("<param name='lblNoCerts' value='");strApplet.append(LabelManager.getName(labelSet,"lblNoCerts"));strApplet.append("'>");
		

		strApplet.append("<center>");
		strApplet.append("<p><strong>Apia requires Java 1.5 or higher, which your browser does not appear to have.</strong></p>");
		strApplet.append("<p><a href='http://www.java.com/en/download/index.jsp'>Get the latest Java Plug-in.</a></p>");
		strApplet.append("</center>");
		strApplet.append("</object>");
		strApplet.append("<![endif]-->");



out.print(strApplet.toString());
		
		
		
		
		
		
		

		 		
	
}
 %></form></body></html>
 