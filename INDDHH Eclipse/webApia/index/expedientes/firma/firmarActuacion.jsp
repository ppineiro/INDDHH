<%response.setCharacterEncoding(com.dogma.Parameters.APP_ENCODING);%>
<%@page import="com.dogma.Parameters"%>
<%@page import="com.dogma.UserData"%>
<%@page import="com.dogma.controller.ThreadData"%>
<%@page import="uy.com.st.adoc.expedientes.helper.Helper"%>
<%
//no dejamos que la pagina se cache
response.setHeader("Pragma","no-cache");
response.setHeader("Cache-Control","no-store");
response.setDateHeader("Expires",-1); 
%>

<% 		
	String htmlData = "";
	UserData uData = ThreadData.getUserData();	
	if (uData!=null){	
		if (uData.getUserAttributes().get("APPLET_SRC")!=null){
			htmlData = (String)uData.getUserAttributes().get("APPLET_SRC");			
			System.out.println( "APPLET_SRC: " + htmlData ); 			
		}else{
			System.out.println( "NO HAY DATOS EN SESSION 1" );
		}
	}else{
		System.out.println( "NO HAY DATOS EN SESSION 2 " );
	}
	System.out.println("FIN");
	
	
	Integer environmentId = null;
	if (uData!=null) {
		environmentId = uData.getEnvironmentId();
	}
	
	String htmlInterface = Helper.obtenerUsuarioFirmaConInterfazHtml(uData.getUserId(),environmentId);

%>
 	
<HTML>
<HEAD>	
	<script type="text/javascript" src="<%=Parameters.ROOT_PATH%>/js/mootools-core-1.4.5-full-compat.js"></script>
	<script type="text/javascript" src="<%=Parameters.ROOT_PATH%>/js/mootools-more-1.4.0.1-compat.js"></script>
	
	<script  language="javascript">
		
		
		function habilitarConfirmar(){
			//setTimeout("habilitar()", 5000);			
		}
		
		function habilitar(){
			//document.getElementById("btnConfirmar").disabled = false;
		}
		
		function writeMessage(msg){
		alert("llamo a la funcion con este mensaje "+msg);
			document.getElementById("appletMessage").innerHTML=msg;
		}
		
		var modalResult = "NOK";
		
		function appletConfirm(result){
			if (result == "true"){
				modalResult = "OK";
				//frameElement.fireEvent('confirmModal');
				frameElement.fireEvent('confirmTask', new Event({type: 'click'}));
			}
		}

		function appletClose(result){
			// frameElement.fireEvent('closeModal');
			/* 
			Esto se debe a que el evento del closeModal no permite agregar
			comportamiento como los otros (res{}) que es deseado al momento
			de cancelar la firma.
			*/
			frameElement.fireEvent('confirmModal');
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

		       if (document.createEvent) {
		             signApplet.dispatchEvent(event);
		       } else {
		             signApplet.fireEvent("on" + event.eventType, event);
		       }

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
		var FORCE_SYNC = true;
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
		<% System.out.println("Agregando estilo #signApplet para htmlInterface!");}%>
	</style>
	
	
	
</HEAD>

<BODY onload="habilitarConfirmar()">
	
	<script>
		setTimeout('appletClose("")',180000);
	</script>
	
	<form name="FRM_MAIN" id="FRM_MAIN" method="post">
		<TABLE  class='tblFormLayout' border=0 >  
			<COL class='col1'>
			<COL class='col2'>
			<COL class='col3'>
			<COL class='col4'> 
			
			<TR>
				<TD></TD><TD></TD><TD></TD><TD></TD>
			</TR>
			
			<TR>
				<TD colspan='4' title=''>
					<DIV class='subTit' id='tit_FIRMA_0' name='frm_tit_E_1129_0_8_F'>
						<%String tbIdRequest = "expedientes/firma/guardarFirma.jsp?tabId=" + request.getParameter("tabId").toString() +"&tokenId="+ request.getParameter("tokenId").toString();%>
						<%htmlData = htmlData.replace("expedientes/firma/guardarFirma.jsp?",tbIdRequest);%>
						<%=htmlData%>
					</DIV>	
				</TD>
			</TR>			
		</TABLE>	
	</form>	
	
</BODY>	
</HTML>

