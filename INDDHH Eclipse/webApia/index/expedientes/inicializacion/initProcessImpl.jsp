<%response.setCharacterEncoding(com.dogma.Parameters.APP_ENCODING);%>
<%@page import="com.dogma.Parameters"%>
<%@page import="com.dogma.controller.ThreadData"%>
<%@page import="com.dogma.EnvParameters" %>
<%@page import="com.st.util.labels.LabelManager"%>
<%@page import="uy.com.st.adoc.mensajes.MensajeDAO"%>
<%@page import="uy.com.st.adoc.expedientes.generic.ControlSesionesUsuario"%>
<%@page import="com.dogma.UserData"%>
<%@page import="java.util.Date"%>
<%@page import="uy.com.st.adoc.mensajes.MensajeDAO"%>
<%@page import="com.dogma.controller.ThreadData"%>
<%@include file="../../page/includes/startInc.jsp" %>
<%@page import="uy.com.st.adoc.expedientes.helper.Helper"%>
<%@page import="uy.com.st.adoc.expedientes.domain.Usr"%>

<jsp:useBean id="bLogin" class="com.dogma.bean.security.LoginBean" scope="session"/>

<html>
<head>
	<%@include file="../../page/includes/headInclude.jsp" %>
		
</head>
<body onLoad="continueLogin()">
<%

com.dogma.UserData uData2 = ThreadData.getUserData();
int currentLanguage = uData2.getLangId();
Integer environmentId = uData2.getEnvironmentId();
MensajeDAO mensajeDao = new MensajeDAO();
String usr = uData2.getUserId();

//agregado para expedientes
String strUsr = "";
Usr u = new Usr();
try {
	Helper h = new Helper();
	strUsr = bLogin.getUserId(request);
	u = h.getUsuarioLicencia(strUsr,environmentId);
} catch (Exception e) {
	System.out.println("ERROR: " + e.getMessage());
}	

%>
<input type=hidden value="<%=u.isUsrLicencia()%>" id="flag_usr_licencia">
	
	<div class="header"></div>
	
	<div class="body" id="bodyDiv">
		
		
	   <div class="gridContainer">
			<form id="frmMain" name="frmMain" method="POST">
				<!-- <button type="button" onclick="continueLogin()"  title="Continuar">Continuar</button> -->
			</FORM>
		</div>
		
		
	</div>	
	
	<script type="text/javascript">
	function continueLogin(){			
		preguntarLicencia();
		document.getElementById("frmMain").action="apia.splash.MenuAction.run?x=x" + TAB_ID_REQUEST;
		document.getElementById("frmMain").submit();			
	}	
	
	function preguntarLicencia(){
		window.status = getFecha();		
		if (document.getElementById("flag_usr_licencia").value=='true'){
			var msg = confirm("<%= mensajeDao.obtenerMensajePorCodigo("MSG_DESACTIVAR_MARCA_JSP", currentLanguage, environmentId)%>"); //"Actualmente usted se encuentra marcado como fuera de oficina.\n\t¿Desea desactivar ésta marca?");	
			if (msg) {
				desactivarFueraOficina();	
			}
		}
			
		setInterval("getCurrentTime()",1000);
		//setInterval("autoGuardar()",timeCheckAutoGuardar);			
		//setInterval("chkSession()",timeCheckAutoGuardar);
		//setInterval("chkNotifUsr()",timeCheckAutoGuardar);
		
	}
	
	function desactivarFueraOficina(){	
		// Creamos el control XMLHttpRequest segun el navegador en el que estemos
		if( window.XMLHttpRequest )
			ajaxFO = new XMLHttpRequest(); // No Internet Explorer
		else
			ajaxFO = new ActiveXObject("Microsoft.XMLHTTP"); // Internet Explorer
			// Almacenamos en el control al funcion que se invocara cuando la peticion
			// cambie de estado
		
		ajaxFO.onreadystatechange = funcionCallbackFO;
			
		// Enviamos la peticion
		var d=new Date();
		var URL = getUrlApp() + "/expedientes/desactivarLicenica/dasactivar.jsp?usr=<%=strUsr%>&time=" + d.getTime()  + TAB_ID_REQUEST;	
		//alert(URL);
		ajaxFO.open( "GET", URL, true );	
		ajaxFO.send( "" );	
	}
		
	function funcionCallbackFO(){	
		// Comprobamos si la peticion se ha completado (estado 4)
		if( ajaxFO.readyState == 4 ){
			// Comprobamos si la respuesta ha sido correcta (resultado HTTP 200)
			if( ajaxFO.status == 200 ){
				// Escribimos el resultado en la pagina HTML mediante DHTML
				var result = ajaxFO.responseText;			
				alert(result);
			}
		}	
	}

	function initPage(){
		
	}
	</script>
	 
</body>

</html>

<%

Boolean cargo = MensajeDAO.cargarMensajesEstaticos(1001, 1);


%>



