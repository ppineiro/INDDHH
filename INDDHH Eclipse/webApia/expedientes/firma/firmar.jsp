<%response.setCharacterEncoding(com.dogma.Parameters.APP_ENCODING);%>
<%@page import="java.util.HashMap"%>
<%@page import="com.dogma.UserData"%>
<%@page import="com.dogma.Parameters"%>
<%@page import="com.dogma.Configuration"%>
<%@page import="uy.com.st.adoc.expedientes.domain.Firma"%>
<%@page import="uy.com.st.adoc.expedientes.helper.Helper"%>
<%@page import="uy.com.st.adoc.expedientes.helper.HelperFirma"%>
<%@page import="uy.com.st.adoc.expedientes.conf.ConfigurationManager"%>
<%@page import="uy.com.st.adoc.expedientes.conf.ConfigurationApplet"%>
<%@page import="com.dogma.controller.ThreadData"%>
<%@page import="uy.com.st.adoc.mensajes.MensajeDAO"%>
<%@page import="uy.com.st.adoc.expedientes.constantes.Values"%>

<%
//no dejamos que la pagina se cache
response.setHeader("Pragma","no-cache");
response.setHeader("Cache-Control","no-store");
response.setDateHeader("Expires",-1); 
%>
<%
	UserData uData = ThreadData.getUserData();
	Integer environmentId = null;
	MensajeDAO mensajeDao = new MensajeDAO();
	int currentLanguage = 1;
	if (uData!=null) {
		environmentId = uData.getEnvironmentId();
		currentLanguage = uData.getLangId();
	}
	
	String token_linux = Helper.obtenerUsuarioFirmaConToken(uData.getUserId(),environmentId);
	String htmlInterface = Helper.obtenerUsuarioFirmaConInterfazHtml(uData.getUserId(),environmentId);	
	String nombreFormulario = "FRM_MAIN";	
	String ASUNTO = (String)uData.getUserAttributes().get("ASUNTO");
	String USUARIO = uData.getUserId();
	String APIA_SERVIDOR = Configuration.ROOT_PATH;
	String CI = (String)uData.getUserAttributes().get("CI");
	String maxFiles = "20";
	Integer maxFilesInt = 20;
	String TMP_DOCS_FIRMAR = "";
	
	String TMP_NRO_DOC_A_FIRMAR_STR = (String)uData.getUserAttributes().get("TMP_NRO_DOC_A_FIRMAR_STR"); 	
	String JEFATURA = (String)uData.getUserAttributes().get("JEFATURA");
	String carVersion	= (String) uData.getUserAttributes().get("VERSION_CARATULA_RELACIONADA");

	
	String tbIdRequest	= "&tabId=" + ThreadData.get("tabId").toString() + "&tokenId="+ ThreadData.getUserData().getTokenId().toString(); 
	String dataReceptor = "expedientes/firma/guardarFirma.jsp?envId=" + environmentId + tbIdRequest;
	
	if ( TMP_NRO_DOC_A_FIRMAR_STR != null)
			TMP_DOCS_FIRMAR = TMP_NRO_DOC_A_FIRMAR_STR.replace(";"," - ");
	
	if (TMP_DOCS_FIRMAR != null && TMP_DOCS_FIRMAR.length() > 40){
		TMP_DOCS_FIRMAR = TMP_DOCS_FIRMAR.substring(0, 40);
		TMP_DOCS_FIRMAR = TMP_DOCS_FIRMAR + "...";
	}		
		
	if (uData.getUserAttributes().get("MAX_FILES") != null){
		maxFiles = (String) uData.getUserAttributes().get("MAX_FILES");
		if (maxFiles != null && !maxFiles.isEmpty()){
			maxFilesInt = Integer.valueOf(maxFiles);
		}
	}
			
	StringBuffer strApplet = new StringBuffer("<center>");
	
	if(htmlInterface.equalsIgnoreCase("true")){			
		strApplet.append("<div id='div-applet' tabIndex='1' class='div-applet modalContent' style='display: none;'>");
		strApplet.append("<div class='header'></div>");
		strApplet.append("<div id='divContent' class='content'>");
		strApplet.append("<div id='divContentMsg'></div>");
		strApplet.append("</div>");
		strApplet.append("<div class='footer'>");
		strApplet.append("<button type='button' id='btnNext' disabled='true' style='display:none;' onclick='btnNext_click()' title='NextSign'>NextSign</button>");
		strApplet.append("<button type='button' id='btnConf' style='display:none;' onclick='btnConf_click()' title='Completar la firma electrónica'>Completar</button>");
		strApplet.append("<button type='button' id='btnExit' style='display:none;' onclick='btnExit_click()' title='Salir de la firma electrónica'>Salir</button>");
		strApplet.append("</div>");
		strApplet.append("</div>");	
	}	
	
	strApplet.append("<![if !IE]>");	
	strApplet.append("<object id='signApplet' classid='java:com/apia/sign/Sign.class' "); 
	strApplet.append("type='application/x-java-applet' ");
	strApplet.append("archive='" + Parameters.ROOT_PATH + "/digitalSignatureApplet/signedAppletFirma.jar, "	
	+ Parameters.ROOT_PATH + "/digitalSignatureApplet/bcprov-jdk15on-150.jar, " 
	+ Parameters.ROOT_PATH + "/digitalSignatureApplet/commons-io-1.3.2.jar, " 
	+ Parameters.ROOT_PATH + "/digitalSignatureApplet/swing-layout-1.0.4.jar, " 
	+ Parameters.ROOT_PATH + "/digitalSignatureApplet/bcprov-ext-jdk15on-150.jar, " 
	+ Parameters.ROOT_PATH + "/digitalSignatureApplet/bcpkix-jdk15on-150.jar, " 
	+ Parameters.ROOT_PATH + "/digitalSignatureApplet/commons-logging-1.1.jar, "
	+ Parameters.ROOT_PATH + "/digitalSignatureApplet/bcprov-jdk15-138.jar, " 
	+ Parameters.ROOT_PATH + "/digitalSignatureApplet/jss-4.jar, " 
	+ Parameters.ROOT_PATH + "/digitalSignatureApplet/itextpdf-5.4.3.jar, "
	+ Parameters.ROOT_PATH + "/digitalSignatureApplet/pdfbox-2.0.2.jar, " 
	+ Parameters.ROOT_PATH + "/digitalSignatureApplet/org.json-20120521.jar' ");			
	strApplet.append("height='190' width='400' >");
	strApplet.append("<param name='code' value='com/apia/sign/Sign.class' />");	
	strApplet.append("<![endif]>");
	
	strApplet.append("<!--[if IE]>");
	strApplet.append("<object id='signApplet' classid='clsid:8AD9C840-044E-11D1-B3E9-00805F499D93' "); 
	strApplet.append("codebase='http://java.sun.com/products/plugin/autodl/jinstall-1_4-windows-i586.cab#Version=1,4,0,0' ");
	strApplet.append("height='190' width='400' >"); 
	strApplet.append("<param name='code' value='com/apia/sign/Sign.class' />");
	strApplet.append("<param name='archive' value='" + Parameters.ROOT_PATH + "/digitalSignatureApplet/signedAppletFirma.jar, " 
	+ Parameters.ROOT_PATH + "/digitalSignatureApplet/bcprov-jdk15on-150.jar, " 
	+ Parameters.ROOT_PATH + "/digitalSignatureApplet/commons-io-1.3.2.jar, " 
	+ Parameters.ROOT_PATH + "/digitalSignatureApplet/swing-layout-1.0.4.jar, " 
	+ Parameters.ROOT_PATH + "/digitalSignatureApplet/bcprov-ext-jdk15on-150.jar, " 
	+ Parameters.ROOT_PATH + "/digitalSignatureApplet/bcpkix-jdk15on-150.jar, " 
	+ Parameters.ROOT_PATH + "/digitalSignatureApplet/commons-logging-1.1.jar, "
	+ Parameters.ROOT_PATH + "/digitalSignatureApplet/bcprov-jdk15-138.jar, " 
	+ Parameters.ROOT_PATH + "/digitalSignatureApplet/jss-4.jar, " 
	+ Parameters.ROOT_PATH + "/digitalSignatureApplet/itextpdf-5.4.3.jar, "
	+ Parameters.ROOT_PATH + "/digitalSignatureApplet/pdfbox-2.0.2.jar, " 
	+ Parameters.ROOT_PATH + "/digitalSignatureApplet/org.json-20120521.jar' ");
	
	strApplet.append("<param name='persistState' value='false' />");
	strApplet.append("<![endif]-->");
	
	
	String applet = strApplet.toString();
	applet += "<param name='maxFiles'  value='"+maxFiles +"'>";
	applet += "<param name='filePicker' value='" + ConfigurationManager.debeElegirUbicacionCertificado(environmentId,currentLanguage, false) + "'>" ;

	for(int i = 1 ; i < maxFilesInt; i++){
		if (uData.getUserAttributes().get("TMP_NOMBRE_ARCHIVO_A_FIRMAR_" + i + "_STR") != null && uData.getUserAttributes().get("TMP_ARCHIVO_A_FIRMAR_" + i + "_STR") != null) 
			applet += "<param name='obj_id_"+(i-1)+"' value='"+ (String)uData.getUserAttributes().get("TMP_NOMBRE_ARCHIVO_A_FIRMAR_" + i + "_STR") +"'> <param name='hash_data_"+(i-1)+"' value='"+ (String)uData.getUserAttributes().get("TMP_ARCHIVO_A_FIRMAR_" + i + "_STR") +"'>";
		else
			applet += "<param name='obj_id_"+(i-1)+"' value=''> <param name='hash_data_"+(i-1)+"' value=''>";
	}
	
	 applet += "<param name='campoClave' value='"+Parameters.SIGN_SEARCH_ATTRIBUTES+"'/>" + 
	"<param name='rootCAs' value='"+Parameters.SIGN_ROOT_CAs+"'/>";
	
	if(Parameters.SIGN_CHECK_REVOKED){
		applet +="<param name='revListURL' value='/digitalSignatureApplet/checkRevList.jsp'>";
	}
	
	applet +="<param name='checkCertDate' value='"+Parameters.SIGN_CHECK_DATE+"'>"+
	"<param name='certificateId' value='" + CI + "'>" +
	"<param name='apiaServer' value='"+ APIA_SERVIDOR+"'>"+ 
	"<param name='dataReceptor'  value='"+ dataReceptor +"'>"+
	"<param name='lblAppletSignOK'  value='"+ mensajeDao.obtenerMensajePorCodigo(Values.LBL_APPLET_SIGN_OK, currentLanguage,environmentId) +"'>" + //La firma se realizó correctamente'>"+
	"<param name='lblAppletSignErr'  value='"+ mensajeDao.obtenerMensajePorCodigo(Values.LBL_APPLET_SIGN_ERROR, currentLanguage,environmentId) +"'>" + //Ocurrió un error al realizar la firma'>"+
	"<param name='lblAppletCantSign'  value='"+ mensajeDao.obtenerMensajePorCodigo(Values.LBL_APPLET_CANT_SIGN, currentLanguage,environmentId) +"'>" + //No se pudo firmar'>"+
	"<param name='lblAppletCertNotCA'  value='"+ mensajeDao.obtenerMensajePorCodigo(Values.LBL_APPLET_CERT_NOT_CA, currentLanguage,environmentId) +"'>" + //El certificado no es reconocido por la entidad certificadora'>"+
	"<param name='lblAppletCertNotFound'  value='"+ mensajeDao.obtenerMensajePorCodigo(Values.LBL_APPLET_CERT_NOT_FOUND, currentLanguage,environmentId) +"'>" + //No se encontró el certificado de _USR_'>"+
	"<param name='lblAppletSigning'  value='"+ mensajeDao.obtenerMensajePorCodigo(Values.LBL_APPLET_SIGNING, currentLanguage,environmentId) +"'>" + //Firmando?'>"+
	"<param name='lblCompTask'  value='"+ mensajeDao.obtenerMensajePorCodigo(Values.LBL_APPLET_COMP_TASK, currentLanguage,environmentId) +"'>" + //Completar tarea'>"+
	"<param name='lblExit'  value='"+ mensajeDao.obtenerMensajePorCodigo(Values.LBL_APPLET_EXIT, currentLanguage,environmentId) +"'>" + //Salir'>"+
	"<param name='lblAppletPrepareSign' value='"+ mensajeDao.obtenerMensajePorCodigo(Values.LBL_APPLET_PREPARE_SIGN, currentLanguage,environmentId) +"'>" + //Preparando firma'>"+
	"<param name='lblContinue' value='"+ mensajeDao.obtenerMensajePorCodigo(Values.LBL_APPLET_CONTINUE, currentLanguage,environmentId) +"'>" + //Continuar'>"+
	"<param name='lblCertPwd' value='"+ mensajeDao.obtenerMensajePorCodigo(Values.LBL_APPLET_CERT_PWD, currentLanguage,environmentId) +"'>" + //Ingrese la contraseña del certificado'>"+
	"<param name='lblTitle' value='"+ mensajeDao.obtenerMensajePorCodigo(Values.LBL_APPLET_TITTLE, currentLanguage,environmentId) +"'>" + //Título'>"+
	"<param name='NSSeToken' value='"+ token_linux + "'>" + //NSSeToken'>"+
	
	"<param name='sessionId' value='"+ session.getId() + "'>" + 
	"<param name='sessionIdName' value='"+ ConfigurationManager.getSessionIdName(environmentId, currentLanguage, false) + "'>" + 
	"<param name='customTokenDriver' value='/usr/lib/ClassicClient/libgclib-1.8.0.so'>" + //Directorio de ubicacion del driver'>"+	
			
	"<param name='routeCookieValue' value='"+ session.getId() + "'>" + 
	"<param name='routeCookie' value='"+ ConfigurationManager.getSessionIdName(environmentId, currentLanguage, false) + "'>" + 	
	"<param name='algoritmo' value='SHA256withRSA'>"+		
	"<param name='key_factor' value='RSA'>"+		
	"<param name='digest' value='SHA-256'>"+	

	"<param name='lblSelectCerts' value='"+ mensajeDao.obtenerMensajePorCodigo(Values.LBL_APPLET_SELECT_CERTS, currentLanguage,environmentId) +"'>" + //Seleccione un certificado para firmar'>"+
	"<param name='getServerTimeForPKCS7' value='/digitalSignatureApplet/getServerTime.jsp'>" +
	"<param name='useHTMLInterface' value='"+ htmlInterface +"'>"+	
	"</object>"
	 + "</center> <iframe id='frmResultFirma' name='frmResultFirma' style='display:none'></iframe>";	
%>
<HTML>
	<HEAD>
		<script type="text/javascript" src="<%=Parameters.ROOT_PATH%>/js/mootools-core-1.4.5-full-compat.js"></script>
		<script type="text/javascript" src="<%=Parameters.ROOT_PATH%>/js/mootools-more-1.4.0.1-compat.js"></script>
		
	
	
		<script  language="javascript">
		var FORCE_SYNC = true;
		
			function Confirmar(){				
				//window.returnValue = "OK";
				//window.close();
			}
			
			function Cancelar(){		
				//window.returnValue = "";
				//window.close();
			}
			
			function habilitarConfirmar(){
				//setTimeout("habilitar()", 5000);
			}
			
			function habilitar(){
				//ApiaFunctions.disableActionButton(ActionButton.BTN_CONFIRM);
			}
			
			var modalResult = "NOK";
			
			function appletConfirm(result){
				if (result == "true"){
					modalResult = "OK";
					frameElement.fireEvent('confirmModal');
				}			
			}
			
			function appletClose(result){
				frameElement.fireEvent('confirmModal');
			}
			
			function getModalReturnValue(modal) {
				modal.setearResultado(modalResult);
				return true;
			}
			
			function changeAriaLabel(msg) {
	
			       var signApplet = document.getElementById("signApplet");
			       signApplet.setAttribute("aria-label", msg);
	
			       var event; // The custom event that will be created
	
			       if (document.createEvent) {
				       event = document.createEvent("HTMLEvents");
				       event.initEvent("mouseover", true, true);
			       } else {
				       event = document.createEventObject();
				       event.eventType = "mouseover";
			       }
	
			       event.eventName = "mouseover";

		}
			
			
		//++++++++++++++++++++nuevo+++++++++++++++++++
			
			function btnNext_click() {
				if(eTokenNext) {
					signApplet.startNoBinarySign(null, document.getElementById('certPass').value);
					return;
				}
				var f = document.getElementById('certFile');
				if(filereader_support) {
					var reader = new FileReader();
					if(f.value) {
						reader.onload = (function(theFile) {
					        return function(e) {
					        	signApplet.startBinarySign(e.target.result, document.getElementById('certPass').value);
					          };
					        })(f);
						reader.readAsDataURL(document.getElementById('certFile').files[0]);
					} else {
						//No se selecciono archivo
					}
				} else {
					if(f.value) {
						signApplet.startNoBinarySign(document.getElementById('certFile').value, document.getElementById('certPass').value);
					} else {
						//No se selecciono archivo
					}
				}
			}
	
			function btnConf_click() {
				signApplet.btnConf_click();
			}
	
			function btnExit_click() {
				signApplet.btnExit_click();
			}
	
			function changeContent(msg) {
				document.getElementById("divContentMsg").tabIndex = "1";
				setTimeout(function() {
					document.getElementById("divContentMsg").focus();
				}, 100);
				
				
				document.getElementById('divContentMsg').innerHTML = msg;
				
				var certPass = document.getElementById('certPass');
				if(certPass)
					document.getElementById('certPass').value = '';
				
				var btnNext = document.getElementById('btnNext');
				if(btnNext)
					btnNext.disabled = 'true';
				
				if(msg == lblSignOk) {
					certPass.style.display = 'none';
					document.getElementById('certPassLbl').style.display = 'none';
					
					var certFile = document.getElementById('certFile');
					if (certFile) {
						certFile.style.display = 'none';
						document.getElementById('certFileLbl').style.display = 'none';
					}
				}
			}
	
			function enableConfirm() {
				document.getElementById('btnConf').disabled = '';
			}
	
			function disableConfirm() {
				document.getElementById('btnConf').disabled = 'true';
			}
	
	
			function createAutoStartPanel() {
				var r = document.getElementById('btnNext');
				r.parentNode.removeChild(r);
				document.getElementById('btnConf').style.display = "";
				document.getElementById('btnExit').style.display = "";
			}
	
			var filereader_support = window.File && window.FileReader && window.FileList;
	
			function createBrowsePanel() {
	
				var divContent = document.getElementById('divContent');
				if (filereader_support) {
					
					divContent.innerHTML = "<br/><div id='divContentMsg'></div><label id='certFileLbl'><%="lblCert"%></label><br/><input id='certFile' type='file' accept='.p12,.pfx'/><br/><br/><label id='certPassLbl'><%="lblPwd"%></label><br/><input id='certPass' type='password' onkeyup='passKeyUp(this)'/>";
				} else {
					divContent.innerHTML = "<br/><div id='divContentMsg'></div><label id='certFileLbl'><%="lblCert"%></label><br/><input id='certFile' type='text'/><br/><br/><label id='certPassLbl'><%="lblPwd"%></label><br/><input id='certPass' type='password' onkeyup='passKeyUp(this)'/>";
				}
				
				document.getElementById('btnNext').style.display = "";
				document.getElementById('btnConf').style.display = "";
				document.getElementById('btnConf').disabled = 'true';
				document.getElementById('btnExit').style.display = "";
			}
			function writeMessage(msg){
			
			}
	
			function passKeyUp(target) {
				if(target.value == '')
					document.getElementById('btnNext').disabled = 'true';
				else
					document.getElementById('btnNext').disabled = '';
			}
	
			var eTokenNext = false;
	
			function createETokenPanel() {
				
				var divContent = document.getElementById('divContent');
				divContent.innerHTML = "<br/><div id='divContentMsg'></div><label id='certPassLbl'><%="lblPwd"%></label><br/><input id='certPass' type='password' onkeyup='passKeyUp(this)'/>";
				
				document.getElementById('btnNext').style.display = "";
				document.getElementById('btnNext').disabled = 'true';
				document.getElementById('btnConf').style.display = "";
				document.getElementById('btnConf').disabled = 'true';
				document.getElementById('btnExit').style.display = "";
				
				eTokenNext = true;
			}
	
			function initGUI() {
				document.getElementById("div-applet").style.display = "";
				//signApplet.style.display = "none";
			}
			
			//++++++++++++++++++++nuevo+++++++++++++++++++
			
		</script>
		
			<script type="text/javascript">
			var lblPwd = 'Contraseña';
			var lblCert = 'Certificado';
			var lblSignOk = 'Haga clic en Completar para firmar';
			var lblContinueSign = 'Continuar con la firma';
		</script>
		
		
		<style type="text/css">
			#div-applet {
			/* 	display: none; */
			}
			#divContent {
				height: 180px !important;
			}
			.footer{
		    	height: 20px !important;
			}
			.pageBottom {
				height: 27px;
			}
			#divContentMsg {
				text-align: center;
			}
			
			<%if(htmlInterface.equalsIgnoreCase("true")){%>		
				#signApplet {
		       		height: 0px;
				}
			<%System.out.println("Agregando estilo #signApplet para htmlInterface!");}%>
		</style>
		
		
	</HEAD>
	
	<BODY onload="habilitarConfirmar()">
		<script>
		setTimeout('appletClose("")',180000);
		</script>
		<form name="FRM_MAIN" id="FRM_MAIN" method="post">
			<TABLE  class='tblFormLayout' border=0 >  
			<!--<TR>
				  <TD  rowspan='1' title='Asunto' style='color:black'>Asunto:</TD>
				<TD  class='readOnly' rowspan='1' colspan='1' title='' name='frm_E_1129_1530_S_1_F' id='FIRMA_TMP_ASUNTO_STR'  value="<%=ASUNTO%>" style="color:black;">
					<%=ASUNTO%>
				</TD>
								
				<TD  rowspan='1' title='Nro Documento' style='color:black'><%= mensajeDao.obtenerMensajePorCodigo("MSG_LBL_NRO_EXPEDIENTE_HIST_JSP", currentLanguage, environmentId)%></TD>
				<TD  class='readOnly' rowspan='1' colspan='2' title='' name='frm_E_1129_1531_S_1_F' id='FIRMA_TMP_NRO_DOC_A_FIRMAR_STR'  value="<%=TMP_NRO_DOC_A_FIRMAR_STR%>" style="color:black;">
					<%=TMP_DOCS_FIRMAR%>
				</TD>
			</TR>--> 
			<TR>
				<TD colspan='4' title=''>
					<DIV style='color:black' class='subTit' id='tit_FIRMA_0' name='frm_tit_E_1129_0_8_F'>
						<%=applet%>
					</DIV>	
				</TD>
			</TR>
			</TABLE>		
		</form>	
	</BODY>
	
</HTML>