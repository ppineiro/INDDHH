<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import="com.dogma.Parameters"%>
 <!-- LOGIN CLASICO -->
	
<html>
<%
// 		String ambiente = "AD";
		String ambiente = "eDOCS";
		
		String txt1 = "";
		if(ambiente=="AD"){
			txt1="login2.css";
		}else if(ambiente=="eDOCS"){
			txt1="login3.css";

		}
		%>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	<title>Apia</title>
	
	<link href="<%=Parameters.ROOT_PATH%>/css/documentum/login/login.css" rel="stylesheet" type="text/css" >
	<link href="<%=Parameters.ROOT_PATH%>/css/documentum/login/<%=txt1%>" rel="stylesheet" type="text/css" >	
	<link href="<%=Parameters.ROOT_PATH%>/css/documentum/login/spinner.css" rel="stylesheet" type="text/css" >	
	<link rel="stylesheet" href="<%=Parameters.ROOT_PATH%>/css/documentum/login/formcheck.css" type="text/css" media="screen" >
	
	<link rel="shortcut icon" href="<%=Parameters.ROOT_PATH%>/css/documentum/favicon.ico">
	
		<script type="text/javascript" src="<%=Parameters.ROOT_PATH%>/js/modernizr.custom.js"></script>
		<script type="text/javascript" src="<%=Parameters.ROOT_PATH%>/js/mootools-core-1.4.5-full-compat.js"></script>
		<script type="text/javascript" src="<%=Parameters.ROOT_PATH%>/js/mootools-more-1.4.0.1-compat.js"></script>
		<script type="text/javascript" src="<%=Parameters.ROOT_PATH%>/js/generics.js"></script>
		
		
			<script type="text/javascript" src="<%=Parameters.ROOT_PATH%>/js/formcheck/lang/es.js"> </script>
		
		
		<script type="text/javascript" src="<%=Parameters.ROOT_PATH%>/js/formcheck/formcheck.js"> </script>
		<script type="text/javascript" src="<%=Parameters.ROOT_PATH%>/js/tooltips/js/sexy-tooltips.v1.2.mootools.js"></script>
		<script type="text/javascript" src="<%=Parameters.ROOT_PATH%>/css/documentum/login/login.js"></script>
		<script type="text/javascript" src="<%=Parameters.ROOT_PATH%>/page/includes/campaigns.js"></script>
	
	
	<script type="text/javascript">
		
		var CONTEXT					= "<%=Parameters.ROOT_PATH%>";
		var LOGIN_OK				= "0";
		var LOGIN_ERROR				= "1";
		var LOGIN_CHANGE_PWD		= "2";
		var LOGIN_USER_EXPIRED		= "3";
		var LOGIN_USER_BLOCKED		= "4";
		var CAPS_TITLE				= "Tiene el Bloq May&#250;s activado, puede causarle problemas.";
		var LOGIN_REMEMBER_TITLE	= 'Generar una nueva contrase&#241;a y enviarla por e-mail';
		var WAIT_A_SECOND			= 'Espere un momento';
		var REMEMBER_MAIL_SENDED	= "Se ha enviado el e-mail a su casilla de correo.";
		var DO_LOGIN				= 'Ingresar';
		var SHOW_ENV_COMBO			= "true";
		var USER_LANGUAGE_SELECION	= '1';
		<!-- external access section -->
		var IS_EXTERNAL = "";
		var EXTERNAL_TYPE = "";
		var LANG_ID = "";
		var FROM_OPEN_URL = "";
		var LOG_FROM_SESSION = "";
		var TYPE = "";
		var ENT_CODE = "";
		var PRO_CODE = "";
		var PRO_CANCEL_CODE = "";
		var SESSION_ATTS = "";
		var ON_FINISH = "";
		var ATT_PARAMS = "";
		var QRY_ID = "" != "null" ? "" : "";
		var ENV_ID = "";
		var NOM_TASK = "";
		var NUM_INST = "";
		
		var TAB_ID = "1450376558990";
		var TOKEN_ID = TAB_ID;
		
		var isAuthenticated = false;
		
		var filters = "";
		<!-- end external access section -->
	
		
		
	</script>

	<style type="text/css">
		
		
	
	</style>
</head>

<body>
	<div class="header">
		<div class="logo"><img border="0" id="logo" title="ApiaDocumentum" alt="Deloitte" src="<%=Parameters.ROOT_PATH%>/css/documentum/img/login/ad-cabezal-chico.jpg"></div>
		<div class="languages">
			
		<div class="languages">
			
			
			
			
				<label class="language">
					
					Espa&#241;ol
					
				</label>
			
				<label class="language">
					<a href="<%=Parameters.ROOT_PATH%>/apia.security.LoginAction.run?action=language&langId=2">
					Portugu&#234;s
					</a>
				</label>
			
				<label class="language">
					<a href="<%=Parameters.ROOT_PATH%>/apia.security.LoginAction.run?action=language&langId=3">
					English
					</a>
				</label>
			
		</div>
	
		</div>
	</div>
	
	<div class="wraper">
		<div style="width: 65%;" class="container">
			<div class="row">
				<div style="width: 50%; float: left" class="container">
					<div class="boxWrapper">
						<div class="client box"><img border="0" id="client" name="ApiaDocumentum" title="ApiaDocumentum" alt="ApiaDocumentum" src="<%=Parameters.ROOT_PATH%>/css/documentum/img/login/logo-agesic.jpg"></div>
						<!-- <div class="client box"><img style="position:relative;top: 15%;width: 50%;" border="0" id="client" name="ApiaDocumentum" title="ApiaDocumentum" alt="ApiaDocumentum" src="<%=Parameters.ROOT_PATH%>/css/documentum/img/login/logoBCRP.png"></div> -->
					</div>
				</div>
				<div style="width: 50%; float: left;" class="container">
					<div class="boxWrapper">
						<div class="box">
							
		<!-- LOGIN FORM -->
		
			<form id="loginForm" action="" style="position: relative; top: 15%; left: 10%;">
				<div class="section">
					<div class="field required">
						<label title="Usuario" style="width: 85px; display: -webkit-inline-box;">Usuario:</label>
								<input type="text" id="loginUsr" class="validate['required']" >
							
					</div>						
							<div class="field required">
								<label title="Contrase&#241;a" style="width: 85px; display: -webkit-inline-box;">Contrase&#241;a:</label>
								<input type="password" autocomplete="off" id="loginPassword" class="validate['required']">
							</div>
					
				</div>
				<div class="section" style="display: none;">
					<div class="field required">
						<label title="Ambiente">Ambiente</label>
						
							<select id="loginEnvironment" style="width: 100%">								
								
									<option value="1001">FORMAS_DOCUMENTALES</option>
																
							</select>
						
						
					</div>
				</div>
				<div class="section">	
					<div class="field">
						<br/>
						<div id="login" title="Ingresar al sistema" class='validate["submit"]'>
							Ingresar
						</div>
					</div>
				</div>
				<!-- 
					<div class="section  loginRemember">
						<a href="#" id="loginRemember" title="Generar una nueva contrase&#241;a y enviarla por e-mail">Generar nueva contrase&#241;a</a>
					</div>
				-->
			</form>
		
		<!-- CHANGE PASSWORD FORM -->
		
			<form id="passwordForm" class="hidden" action="">
				<div class="section">
					<div class="field required">
						<label title="Contrase&#241;a">Contrase&#241;a actual:</label>
						<input type="password" autocomplete="off" id="currentPassword" class="validate['required']">
					</div>
					<div class="field required">
						<label title="Nueva contrase&#241;a">Nueva contrase&#241;a:</label>
						<input type="password" autocomplete="off" id="newPassword" name="newPassword" class="validate['required','~fieldRegExp']" regExp="^[a-zA-Z0-9_.]*$" regExpMessage="mensaje de exp regular" title="Confirmar contrase&#241;a" >
					</div>
					<div class="field required">
						<label title="Confirmar nueva contrase&#241;a">Confirmar contrase&#241;a:</label>
						<input type="password" autocomplete="off" id="newPasswordConf" class="validate['required','confirm:newPassword']">
					</div>
				</div>
				<div class="section">
					<div class="field">
						<br>
						<div class="validate['submit']" id="changePwd" title="Ingresar al sistema"><div class="genericDivBtn " tabindex="0"><span class="">Ingresar</span></div></div>
					</div>
					<div class="field">
						<br>
						<div class="validate['submit']" id="cancelChangePwd" title="Cancelar"><div class="genericDivBtn " tabindex="0"><span class="">Cancelar</span></div></div>
					</div>
				</div>
			</form>
		
		
		<!-- REQUEST PASSWORD FORM -->
		
			<form id="requestForm" class="hidden" action="">
				<div class="section">
					<div class="field required">
						<label title="Usuario">Usuario:</label>
						<input type="text" id="rememberUser" class="validate['required']">
					</div>
					<div class="field required">
						<label title="E-mail">E-mail:</label>
						<input type="text" id="rememberEmail" class="validate['required']">
					</div>
				</div>
				<div class="section">
					<div class="field">
						<br>
						<div class="validate['submit']" id="rememberBtn"><div class="genericDivBtn " tabindex="0"><span class="">Generar nueva contrase&#241;a</span></div></div>
					</div>
				</div>
				<div class="section loginRemember">
					<a title="" id="doLogin" href="#">Ingresar</a>
				</div>
			</form>
		
		
	
							
		<div class="message hidden" id="messageContainer">
			
		</div>
		
	
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div  class="container" style="width: 100%;">
					<div class="boxWrapper">
						<div class="summary box">
											
											
<table>	
<tr>
<td>
							<img border="0" id="solution" name="ApiaDocumentum" title="ApiaDocumentum" alt="ApiaDocumentum" src="<%=Parameters.ROOT_PATH%>/css/documentum/img/login/logo_expediente.jpg">
</td>		
<td>				
							<br>
							<p>La Plataforma de Expediente Electrónico es una herramienta que gestiona los expedientes de forma electrónica al tiempo que mejora la eficiencia y transparencia de los procedimientos administrativos.  Esta herramienta permite optimizar los tiempos de proceso y de respuesta, además de potenciar el acceso a la información, estableciendo un nuevo relacionamiento más cómodo entre el ciudadano y los distintos organismos del Estado.</p>
</td>		
</tr>	
<tr>
<td colspan=2>
<br>				 
							<p>El Expediente Electrónico permite realizar un seguimiento de cualquier expediente que se encuentre en los organismos, así como el intercambio de expedientes entre los mismos.</p>
</td>		
</tr>							
											</table>					
						</div>
					</div>
				</div>
			</div>
		</div>
		
		
		<div style="width: 33%" class="container">
			<div class="row">
				<div  class="container" style="width: 100%;">
					<div class="boxWrapper">
						<div class="box ApiaDocumentum">
						<br><br><br><br>
						    <!-- <img border="0" id="solution" name="ApiaDocumentum" title="ApiaDocumentum" alt="ApiaDocumentum" src="<%=Parameters.ROOT_PATH%>/css/documentum/img/login/CotizacionesBCRP.png" style="width: 82%;position: relative;top: -15%;height: 85%;left: -2%;"> -->
							<img border="0" id="solution" name="ApiaDocumentum" title="ApiaDocumentum" alt="ApiaDocumentum" src="<%=Parameters.ROOT_PATH%>/css/documentum/img/login/logoCASMU.png" style="width: 45%; position: relative; top: 15%;">
							<!--  <img border="0" id="solution" name="ApiaDocumentum" title="ApiaDocumentum" alt="ApiaDocumentum" src="<%=Parameters.ROOT_PATH%>/css/documentum/img/login/logoBPS.png" style="width: 45%;"> -->
							<!--  <img border="0" id="solution" name="ApiaDocumentum" title="ApiaDocumentum" alt="ApiaDocumentum" src="<%=Parameters.ROOT_PATH%>/css/documentum/img/login/logoApiaTEST.png" style="width: 45%;"> -->
						</div>
					</div>
				</div>
			</div>
			<div class="row">
				<div  class="container" style="width: 100%;">
					<div class="boxWrapper">
						<div class="box campaing"><br><br><br>
							
								Área prevista para noticias.
							

						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	
	
		<div class="theFotterPrev"></div><div class="theFooter"><div class="version">apia_dsv_ctr | Apia 3.1.0.2 (2015.10.28.13.00) &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&copy;2008 STATUM, All rights reserved.</div></div>
	
</body>

</html>
