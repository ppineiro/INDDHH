<%response.setCharacterEncoding(com.dogma.Parameters.APP_ENCODING);%>
<%@page import="java.util.Hashtable"%>
<%@page import="java.util.Set"%>
<%@page import="java.util.Iterator"%>
<%@page import="uy.com.st.adoc.expedientes.constantes.Mensajes"%>
<%@page import="uy.com.st.adoc.expedientes.conf.ConfigurationManager"%>
<%@page import="com.dogma.Configuration"%>
<%@page import="uy.com.st.adoc.expedientes.helper.Helper"%>
<%@page import="uy.com.st.adoc.expedientes.domain.Usr"%>
<%@page import="com.dogma.Parameters"%>
<%@page import="com.st.util.labels.LabelManager"%>
<%@page import="uy.com.st.adoc.mensajes.MensajeDAO"%>
<%@page import="com.dogma.controller.ThreadData"%>

<jsp:useBean id="bLogin" class="com.dogma.bean.security.LoginBean" scope="session"/>

<HTML>
<HEAD>
</HEAD>
<BODY>

<%

//com.dogma.UserData uData = (com.dogma.UserData)session.getAttribute("sessionAttribute");
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
<input type=hidden value="" id="flag_auto_guardar_exp">
<input type=hidden value="" id="flag_save_actuacion">
<input type=hidden value="<%=u.isUsrLicencia()%>" id="flag_usr_licencia">
<input type=hidden value="" id="flag_fecha_hora">
<input type=hidden value="" id="flag_fecha_hora_actual">
<input type=hidden value="true" id="flag_session_activa">

<input type=hidden value="" id="flag_url_app">
<script language="javascript">

function obtenerMensajeSegunCodigo(codigo,langId){
	return arrayMensajes[codigo];
}
</script>
</BODY>

<script language="javascript">

//---- guardado del nombre del servidor en variables de sesion
var fields =  window.location.href.split("/");
var serverName = fields[0]+"//"+fields[2];

var toCall = serverName+"/"+fields[3]+"/expedientes/setParameter.jsp?" + TAB_ID_REQUEST;
document.getElementById("flag_url_app").value = serverName+"/"+fields[3];
FAjax1(toCall,"serverName="+serverName,"POST");

var ajaxServerName;

//paso los mensajes cargados al arrayList de javascript
var arrayMensajes = {};
<% 

Hashtable<String,String> tempArrayList = new MensajeDAO().obtenerMensajesJS(currentLanguage,environmentId);

Set<String> keys = tempArrayList.keySet();
String temp = null;
Iterator<String> iterKeys = keys.iterator();

while(iterKeys.hasNext()){
	temp = iterKeys.next();%>
	arrayMensajes['<%=temp%>'] = '<%=(String)tempArrayList.get(temp)%>';
<%
}
%>


function funcionAjaxCallback(){	
		
	//alert("funcionCallbackChkFirma");	
	// Comprobamos si la peticion se ha completado (estado 4)
	if( ajaxServerName.readyState == 4 ){
		// Comprobamos si la respuesta ha sido correcta (resultado HTTP 200)
		if( ajaxServerName.status == 200 ){
			// Escribimos el resultado en la pagina HTML mediante DHTML
			var result = ajaxServerName.responseText;
			//alert("result: " + result);	
		}
	}		
}

function creaAjax1(){
	var objetoAjax=false;
	try {
		/*Para navegadores distintos a internet explorer*/
		objetoAjax = new ActiveXObject("Msxml2.XMLHTTP");
	} catch (e) {
		try {
	    	/*Para explorer*/
	        objetoAjax = new ActiveXObject("Microsoft.XMLHTTP");
		}catch (E) {
			objetoAjax = false;
		}
	}
	
	if (!objetoAjax && typeof XMLHttpRequest!='undefined') {
		objetoAjax = new XMLHttpRequest();
	}
	return objetoAjax;
}

//function FAjax (url,capa,valores,metodo){
function FAjax1 (url,valores,metodo){
	
	ajaxServerName=creaAjax1();
	//var ajaxChkFirma=creaAjax();
    //var capaContenedora = document.getElementById(capa);

	/*Creamos y ejecutamos la instancia si el metodo elegido es POST*/
	if(metodo.toUpperCase()=='POST'){
		ajaxServerName.open ('POST', url, true);
		ajaxServerName.onreadystatechange = funcionAjaxCallback;
		ajaxServerName.setRequestHeader('Content-Type','application/x-www-form-urlencoded');
		ajaxServerName.send(valores);
	    //return;
	}
	/*Creamos y ejecutamos la instancia si el metodo elegido es GET*/
	if (metodo.toUpperCase()=='GET'){	
		ajaxServerName.open ('GET', url, true);
		ajaxServerName.onreadystatechange = funcionAjaxCallback;
		ajaxServerName.setRequestHeader('Content-Type','application/x-www-form-urlencoded');
		ajaxServerName.send(null);
	    //return;
	}
}


//------------------------------------------------------

//agregado para expedientes
var timeAutoGuardar = parseInt('<%=Mensajes.TIME_AUTO_GUARDADO%>');
var timeCheckAutoGuardar = parseInt('<%=Mensajes.TIME_CHECK_AUTO_GUARDADO%>');		
var currentLanguage = <%= currentLanguage %> ;
var LOGGED_USER = "<%= usr %>" ;

function paginaCargada(){
	//preguntarLicencia();
}

function autoGuardar() {
	try{
		
		//alert("autoGuardar");
		
		//showWinMessage(getFecha());		
				
		if (document.getElementById("flag_auto_guardar_exp").value == 'true'){	 
			document.getElementById("flag_fecha_hora").value = getCurrentTime();
						
			var inicio = document.getElementById("flag_fecha_hora_actual").value;
			var actual = document.getElementById("flag_fecha_hora").value;
			
			inicio = parseInt(inicio); 
			actual = parseInt(actual);
			
			window.status = getFecha() + " - " + Math.round((actual - inicio)/60) + "";
						
			//cada 10 minutos
			if ((actual - inicio) > timeAutoGuardar){
				
				//alert(actual - inicio);
				//alert(timeAutoGuardar);
				//alert((actual - inicio) > timeAutoGuardar);
				
				var obj = null;
				
				obj = getFrame1();
							
				if (obj == null){
					obj = getFrame2();					
				}				
			
				if (obj == null){
					obj = getFrame3();
				}
				
				if (obj != null){
					if (obj.document.getElementById("ACTUACIONES_EXP_ACTUACION_STR")!=null){
						if (obj.document.getElementById("ACTUACIONES_EXP_PAGINA_CARGADA_STR")!=null){
							if (obj.document.getElementById("ACTUACIONES_EXP_PAGINA_CARGADA_STR").value=="OK"){
								if (obj.document.getElementById("btnSave")!=null){
									if (document.getElementById("btnSave").disabled == false) {
										document.getElementById("btnSave").onclick();
									}							
									document.getElementById("flag_auto_guardar_exp").value = "";
									document.getElementById("flag_fecha_hora_actual").value = "";
								}
							}
						}
					}
					if (obj.document.getElementById("CONTENIDO_MEMO_MEM_CONTENIDO_STR")!=null){
					
						if (obj.document.getElementById("btnSave")!=null){
							if (document.getElementById("btnSave").disabled == false) {
								document.getElementById("btnSave").onclick();
							}
							document.getElementById("flag_auto_guardar_exp").value = "";
							document.getElementById("flag_fecha_hora_actual").value = "";
						}
					}						
				}
								
			}
		}	
	
	}catch(e){
		//alert(e);
	}
}

function getFrame1(){
	try{
	
		var obj = null;
		var framePadre = parent.parent.frames["workArea"];
						
		if (framePadre.document!=null){						
			if (framePadre.document.getElementById("ACTUACIONES_EXP_ACTUACION_STR")!=null){						
				obj = framePadre;			
			}
			if (framePadre.document.getElementById("CONTENIDO_MEMO_MEM_CONTENIDO_STR")!=null){									
				obj = framePadre;			
			}
		}
		
		return obj;
		
	}catch(e){
		return null;
	}
}

function getFrame2(){
	try{
	
		var obj = null;
		var framePadre = parent.parent.frames["workArea"];
						
		if (obj == null){
			if (framePadre.frames(1)!=null){						
				if (framePadre.frames(1).document.getElementById("ACTUACIONES_EXP_ACTUACION_STR")!=null){							
					obj = framePadre.frames(1);			
				}
				if (framePadre.frames(1).document.getElementById("CONTENIDO_MEMO_MEM_CONTENIDO_STR")!=null){							
					obj = framePadre.frames(1);		
				}
			}
		}		
		
		return obj;
		
	}catch(e){
		return null;
	}
}

function getFrame3(){
	try{
	
		var obj = null;
		var framePadre = parent.parent.frames["workArea"];
						
		if (obj == null){
			if (framePadre.frames(2)!=null){						
				if (framePadre.frames(2).document.getElementById("ACTUACIONES_EXP_ACTUACION_STR")!=null){							
					obj = framePadre.frames(2);			
				}
				if (framePadre.frames(2).document.getElementById("CONTENIDO_MEMO_MEM_CONTENIDO_STR")!=null){							
					obj = framePadre.frames(2);			
				}
			}
		}
		
		return obj;
		
	}catch(e){
		return null;
	}
}

function preguntarLicencia(){
	
	//window.status = getFecha();
	
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

function preguntarLicenciaBackUp(){
	
	window.status = getFecha();
	
	if (document.getElementById("flag_usr_licencia").value=='true'){
		var msg = confirm("<%= mensajeDao.obtenerMensajePorCodigo("MSG_DESACTIVAR_MARCA_JSP", currentLanguage, environmentId)%>"); //"Actualmente usted se encuentra marcado como fuera de oficina.\n\t¿Desea desactivar ésta marca?");	
		if (msg) {
			desactivarFueraOficina();	
		}
	}
		
	setInterval("autoGuardar()",timeCheckAutoGuardar);			
	//setInterval("chkSession()",timeCheckAutoGuardar);
	//setInterval("chkNotifUsr()",timeCheckAutoGuardar);
	
}

function getCurrentTime() {
	try{
		var fObj = new Date();
		 		 
		var horas = fObj.getHours(); 
		var minutos = fObj.getMinutes(); 
		var segundos = fObj.getSeconds();
				
		if (horas <= 9) 
			horas = "0" + horas; 
		if (minutos <= 9) 
			minutos = "0" + minutos; 
		if (segundos <= 9) 
			segundos = "0" + segundos; 
		
		horas = parseInt(horas); 
		minutos = parseInt(minutos); 
		segundos = parseInt(segundos);			

		var t1 = (horas * 60 * 60) + (minutos * 60) + segundos;
		return t1;
		
	}catch(e){
		alert(e);
	}	
}

function getFecha() {
	try{
		var fObj = new Date();
		
		var anio = fObj.getYear();
		var mes = fObj.getMonth();
		var dia = fObj.getDate(); 
 		 
		var horas = fObj.getHours(); 
		var minutos = fObj.getMinutes(); 
		var segundos = fObj.getSeconds();
		
		if (dia <= 9) 
			dia = "0" + dia; 
		mes = (mes + 1) 
		if (mes <= 9) 
			mes = "0" + mes; 
		
		if (horas <= 9) 
			horas = "0" + horas; 
		if (minutos <= 9) 
			minutos = "0" + minutos; 
		if (segundos <= 9) 
			segundos = "0" + segundos; 
		
		var fecha = dia + "/" + mes + "/" + anio + " " + horas + ":" + minutos + ":" + segundos;
		return fecha ;
		
	}catch(e){
		alert(e);
	}	
}

var ajaxFO;

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
	var URL = document.getElementById("flag_url_app").value + "/expedientes/desactivarLicenica/dasactivar.jsp?usr=<%=strUsr%>&time=" + d.getTime()  + TAB_ID_REQUEST;	
	//alert(URL);
	ajaxFO.open( "GET", URL, true );	
	ajaxFO.send( "" );	
}

var ajaxSession;

function funcionCallbackChkSession(){	
	
	document.getElementById("flag_session_activa").value = "false";	
	// Comprobamos si la peticion se ha completado (estado 4)
	if( ajaxSession.readyState == 4 ){		
		// Comprobamos si la respuesta ha sido correcta (resultado HTTP 200)			
		if( ajaxSession.status == 200 ){						
			// Escribimos el resultado en la pagina HTML mediante DHTML
			var result = ajaxSession.responseText;						
			//alert(result.length);					
			if (result.length > 4){			
				document.getElementById("flag_session_activa").value = "true";					
			}else{
				document.getElementById("flag_session_activa").value = "false";
			}					
		}
	}		
}

function chkSession(){	
	
	window.status = getFecha();
	
	// Creamos el control XMLHttpRequest segun el navegador en el que estemos
	if( window.XMLHttpRequest )
		ajaxSession = new XMLHttpRequest(); // No Internet Explorer
	else
		ajaxSession = new ActiveXObject("Microsoft.XMLHTTP"); // Internet Explorer
		// Almacenamos en el control al funcion que se invocara cuando la peticion
		// cambie de estado
	
	ajaxSession.onreadystatechange = funcionCallbackChkSession;
		
	// Enviamos la peticion
	var URL = document.getElementById("flag_url_app").value + "/expedientes/chkSession.jsp"  + TAB_ID_REQUEST;	
	//alert(URL);
	ajaxSession.open( "GET", URL, true );	
	ajaxSession.send( "" );		
}


function showWinMessage(str){
	var win=window;
	while(!win.document.getElementById("iframeMessages") ){
		win=win.parent;
	}
	setTimeout(function(){win.document.getElementById("iframeMessages").showMessage(str, document.body);},100);
}

var ajaxNotifUsr;

function funcionCallbackChkNotifUsr(){	
		
	// Comprobamos si la peticion se ha completado (estado 4)
	if( ajaxNotifUsr.readyState == 4 ){
		// Comprobamos si la respuesta ha sido correcta (resultado HTTP 200)
		if( ajaxNotifUsr.status == 200 ){
			// Escribimos el resultado en la pagina HTML mediante DHTML
			var result = ajaxNotifUsr.responseText;		
			if (trim(result).length > 0){	
				showWinMessage(result);
			}
		}
	}		
}

function trim(s) 
{ 
	var trimmed = "";
	var i = 0;
    while(i+1 < s.length )  { 
		var charo = s.substring(i,i+1);
		if(charo!=" " && charo!="\t" && charo!="\n" && charo!="\r"){
			trimmed = trimmed + charo;
		}
		i++;
    } 
    return trimmed;
} 


function chkNotifUsr(){
	//alert("chkNotifUsr");	
	
	// Creamos el control XMLHttpRequest segun el navegador en el que estemos
	if( window.XMLHttpRequest )
		ajaxNotifUsr = new XMLHttpRequest(); // No Internet Explorer
	else
		ajaxNotifUsr = new ActiveXObject("Microsoft.XMLHTTP"); // Internet Explorer
		// Almacenamos en el control al funcion que se invocara cuando la peticion
		// cambie de estado
	
	ajaxNotifUsr.onreadystatechange = funcionCallbackChkNotifUsr;
		
	// Enviamos la peticion
	var URL = document.getElementById("flag_url_app").value + "/expedientes/chkNotificacionesUsuario.jsp?param=<%=strUsr%>"  + TAB_ID_REQUEST;	
	//alert(URL);
	ajaxNotifUsr.open( "GET", URL, true );	
	ajaxNotifUsr.send( "" );		
}
</script>
</HTML>
