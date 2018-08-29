<%@page import="com.dogma.controller.ThreadData"%>
<%@page import="st.access.BusquedaDao"%>
<%@page import="st.access.Busqueda"%>
<%@page import="st.access.conf.Conf"%>
<%@page import="java.util.ArrayList"%>
<%@page import="uy.com.st.adoc.expedientes.conf.ConfigurationManager"%>
<%@page import="uy.com.st.documentum.seguridad.Base64"%>
<%@page import="com.dogma.Parameters"%>
<%@page import="com.dogma.EnvParameters"%>
<%@page import="com.dogma.UserData"%>
<%@page import="com.dogma.Configuration"%>

<%
	response.setHeader("Pragma","no-cache");
	response.setHeader("Cache-Control","no-store");
	response.setDateHeader("Expires",-1);
	int environmentId = 1001;
	int currentLanguage = 1;
	UserData uData = ThreadData.getUserData();
	String usr = "";
	String usuario = "";
	
	if (uData!=null) {
		usuario = uData.getUserId() + "";
	}
	
	if(request.getParameter("usr")!=null){
		usr = request.getParameter("usr").toString();
	}
	
	if(usuario.equals("busClass")){
		usuario = usr;
	}
	
	String tokenId = "";
	if (request.getParameter("tokenId")!=null){
		tokenId = request.getParameter("tokenId").toString();
	}
	String  tabId = "";
	if (request.getParameter("tabId")!=null){
		tabId = request.getParameter("tabId").toString();
	}
	String TAB_ID_REQUEST = "&tabId=" + tabId +"&tokenId=" + tokenId + "&usr=" +usuario;
%>

<html class=" js" lang="es">
<head>
<title>Busqueda | Expedientes</title>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<!--meta http-equiv="X-UA-Compatible" content="IE=7"-->
<meta name="description" content="Busqueda de expedientes.">
<meta name="viewport" content="width=device-width,initial-scale=1.0">

<script type="text/javascript">

	var TAB_ID_REQUEST = "<%=TAB_ID_REQUEST%>";
	var CONTEXT = "<%=com.dogma.Parameters.ROOT_PATH%>";
	var BTN_CLOSE = 'Cerrar';
	
	var ajax;
	var ajaxT;
	var MSIE = window.navigator.appVersion.indexOf("MSIE")>=0;	

	function cargarInfoExtra(){		
		var index = 0;		
		var divT = "info-tamanio-" + index + "ee";
		//document.getElementById("search").value = divT;		
		setTimeout(function(){ cargarTamanioEE(index); }, (100));														
	}

	function funcionCallBackTamanioEE(index){

		//document.getElementById("search").value = "funcionCallBackTamanioEE(" + index + ")";		
		//document.getElementById("search").value = document.getElementById(divT).tamexp;
		// Escribimos el resultado en la pagina HTML mediante DHTML	
		var result = ajaxT.responseText;
		var divT = "info-tamanio-" + index + "ee";
		if (document.getElementById(divT)!=null){			
			if (result.trim().length < 100){
				document.getElementById(divT).innerHTML = result.trim();			
			}else{
				document.getElementById(divT).style.display='block';
			}
		}							
		if (index < 10){
			index = index +1;

			setTimeout(function(){ cargarTamanioEE(index); }, (100));
		}		
	}
	

	function cargarTamanioEE(index){
		//document.getElementById("search").value = "cargarTamanioEE(" + index + ")";		
		// Creamos el control XMLHttpRequest segun el navegador en el que estemos
		if( !MSIE ){
			ajaxT = new XMLHttpRequest(); // No Internet Explorer
			ajaxT.onload = function(){			
				funcionCallBackTamanioEE(index);
			}
		}else{	
			ajaxT = new ActiveXObject("Microsoft.XMLHTTP"); // Internet Explorer
			// Almacenamos en el control al funcion que se invocara cuando la peticion
			// cambie de estado		
			ajaxT.onreadystatechange = funcionCallBackTamanioEE(index);
		}

		// Enviamos la peticion		
		var divT = "info-tamanio-" + index + "ee";
		
		var nroEE = document.getElementById(divT).innerHTML;
		var URL = "/Apia/expedientes/buscador/cargarTamanioEE.jsp?nroEE=" + nroEE + "<%=TAB_ID_REQUEST%>";

		//alert(URL);		
		ajaxT.open( "POST", URL, false );	
		ajaxT.send( "" );	
	}
	
	function cargarCaratulaIMG(){
		//alert("ACA EN ESTA FUNCION - cargarCaratulaIMG");
	}
			
	function trabajarEE(valores){	
		if(valores != ""){	
				var res = valores.split("*");
				var proInstId = res[0];
				var proEleInstId = res[1];
				var tarea = res[2];
				// /Apia/
				var url = getUrlApp() + "/apia.execution.TaskAction.run?action=getTask&forceAcquire=true&proInstId="
							+proInstId+"&proEleInstId="+proEleInstId
							+"&tabId=<%=System.currentTimeMillis()%>&tokenId=<%=tokenId%>";
			parent.tabContainer.addNewTab(tarea, url);
		}
	}

	function solicitarEE(nroExp, ubAct, usrAct) {

		/*URL = getUrlApp() + "/expedientes/buscador/agregarSolicitado.jsp?nroExp=" 
		+ nroExp + "&nombreSol=" + tarea + TAB_ID_REQUEST;*/
		if (nroExp != "") {
			URL = getUrlApp()
					+ "/expedientes/buscador/agregarSolicitado.jsp?nroExp="
					+ nroExp 
					+ "&ubAct="+ ubAct 
					+ "&usrAct="+ usrAct +TAB_ID_REQUEST;

			if (window.XMLHttpRequest) {
				client = new XMLHttpRequest();
			} else {
				client = new ActiveXObject("Microsoft.XMLHTTP");
			}
			client.open("POST", URL, false);
			client.send();
		}
	}

	function favorito() {
		alert("soy fav");
		/*URL = getUrlApp()
				+ "/expedientes/buscador/agregarFavorito.jsp?nroExp="
				 TAB_ID_REQUEST;

		if (window.XMLHttpRequest) {
			client = new XMLHttpRequest();
		} else {
			client = new ActiveXObject("Microsoft.XMLHTTP");
		}
		client.open("POST", URL, false);
		client.send();*/
	}

	function funcionCallBackcargarDetalleEELoaded(event, nameDivFlotante) {

		// Escribimos el resultado en la pagina HTML mediante DHTML
		var result = ajax.responseText;

		var d = document.getElementById(nameDivFlotante);
		d.innerHTML = result;
		showdiv(event, nameDivFlotante);
	}

	//function cargarDetalleEE(event, nameDivFlotante, nroEE, indice){
	function cargarDetalleEE2() {

		alert("cargarDetalleEE2");
		/*
		// Creamos el control XMLHttpRequest segun el navegador en el que estemos
		if( !MSIE ){
		ajax = new XMLHttpRequest(); // No Internet Explorer
		ajax.onload = function(){			
			funcionCallBackcargarDetalleEELoaded(event, nameDivFlotante);
		}
		}else{		
		ajax = new ActiveXObject("Microsoft.XMLHTTP"); // Internet Explorer
		// Almacenamos en el control al funcion que se invocara cuando la peticion
		// cambie de estado		
		ajax.onreadystatechange = funcionCallBackcargarDetalleEELoaded(event, nameDivFlotante);
		}
		// Enviamos la peticion	
		var URL = "/Apia/expedientes/buscador/generarCaratulaEE.jsp?nroEE=" + nroEE + "&indice=" + indice;
		alert(URL);
		ajax.open( "POST", URL, false );	
		ajax.send( "" );	
		 */
	}

	function hidediv(event, nameDivFlotante) {
		document.getElementById(nameDivFlotante).style.display = 'none';
	}

	//Funcion que muestra el div en la posicion del mouse
	function showdiv(event, nameDivFlotante) {

		alert("showdiv");

		//determina un margen de pixels del div al raton
		var marginTop = -200;
		var marginLeft = 50;

		//La variable IE determina si estamos utilizando IE
		var IE = document.all ? true : false;
		//Si no utilizamos IE capturamos el evento del mouse
		if (!IE)
			document.captureEvents(Event.MOUSEMOVE)

		var tempX = 0;
		var tempY = 0;

		if (IE) { //para IE
			tempX = event.clientX + document.body.scrollLeft;
			tempY = event.clientY + document.body.scrollTop;
		} else { //para netscape
			tempX = event.pageX;
			tempY = event.pageY;
		}
		if (tempX < 0) {
			tempX = 0;
		}
		if (tempY < 0) {
			tempY = 0;
		}

		//modificamos el valor del id posicion para indicar la posicion del mouse
		//document.getElementById('posicion').innerHTML="PosX = "+tempX+" | PosY = "+tempY;

		document.getElementById(nameDivFlotante).style.top = (tempY + marginTop);
		document.getElementById(nameDivFlotante).style.left = (tempX + marginLeft);
		document.getElementById(nameDivFlotante).style.display = 'block';

		document.getElementById("search").value = (tempY + marginTop) + " - "
				+ (tempX + marginLeft());

		setTimeout(function() {
			hidediv(event, 'DetalleEE');
		}, 5000);

		return;
	}

	function ponerMayusculas(nombre, evnt) {

		var ev = (evnt) ? evnt : event;
		var code = (ev.which) ? ev.which : event.keyCode;

		if (!((code >= 48) & (code <= 57))) {
			nombre.value = nombre.value.toUpperCase();
		}
	}
</script>

<script type="text/javascript"
	src="<%=Parameters.ROOT_PATH%>/expedientes/js/CustomJS-EXP-ELEC.js"></script>
<script type="text/javascript"
	src="/Apia/js/mootools-core-1.4.5-full-compat.js"></script>
<script type="text/javascript"
	src="/Apia/js/mootools-more-1.4.0.1-compat.js"></script>

<script type="text/javascript"
	src="<%=Parameters.ROOT_PATH%>/js/generics.js"></script>
<script type="text/javascript"
	src="<%=Parameters.ROOT_PATH%>/js/modal.js"></script>

<!-- STYLES -->
<link href="<%=Parameters.ROOT_PATH%>/css/documentum/modal.css"
	rel="stylesheet" type="text/css">
<link href="/Apia/expedientes/buscador/css/categorias.css"
	rel="stylesheet" type="text/css">
<link href="/Apia/expedientes/buscador/css/estilos-resultado.css"
	rel="stylesheet" type="text/css">
<!-- STYLES -->
<style>
.modalContent .header {
	height: 30px;
}
</style>
<style>
.icon {
	background: url(/Apia/expedientes/iconos/fav_12.png) no-repeat;
	float: right;
	width: 12px;
	height: 12px;
}
</style>
</head>

<body onload="cargarInfoExtra()">

	<%
		String texto = "";
		String op = "1";
		String txt = "";
		String txtValue = "";
		if (request.getParameter("q") != null) {
			texto = request.getParameter("q");
			texto = texto.trim();
			txt = texto;
			txtValue = txt;
		} else {
			txt = "Buscar expediente...";
		}

		if (request.getParameter("op") != null) {
			op = request.getParameter("op");
		}
	%>

	<div class="box">
		<!-- style="background:red" -->
		<h3>¿Qué expediente desea buscar?</h3>
		<div class="buscador" id="buscador-grande">
			<form
				action="/Apia/expedientes/buscador/resultado.jsp?a=1<%=TAB_ID_REQUEST%>"
				class="form">
				<fieldset>
					<legend class="hidden">Buscador de Expedientes</legend>
					<label for="search" class="hidden">Buscar expediente:</label> <input
						type="search" class="search" id="search" name="q"
						placeholder="<%=txt%>" title="Buscar expediente"
						value='<%=txtValue%>'>
					<!--onkeyup="ponerMayusculas(this, event)"-->




					<input type="submit" class="submit" value="Buscar">
				</fieldset>

				<input type="hidden" id="tokenId" name="tokenId"
					value="<%=tokenId%>" /> <input type="hidden" id="tabId"
					name="tabId" value="<%=tabId%>" /> <input type="hidden"
					id="usuario" name="usuario" value="<%=usuario%>" /> <br>
				<p>
				<table>
					<tr>

						<td>&nbsp;&nbsp;<a class="<%=(op.equals("1") ? "one" : "two")%>"
							href="/Apia/expedientes/buscador/resultado.jsp?op=1&q=<%=txt%><%=TAB_ID_REQUEST%>">Asunto</a>&nbsp;&nbsp;
						</td>


						<td>&nbsp;&nbsp;<a class="<%=(op.equals("2") ? "one" : "two")%>"
							href="/Apia/expedientes/buscador/resultado.jsp?op=2&q=<%=txt%><%=TAB_ID_REQUEST%>">Nro
								Expediente</a>&nbsp;&nbsp;
						</td>



						<td>&nbsp;&nbsp;<a class="<%=(op.equals("3") ? "one" : "two")%>"
							href="/Apia/expedientes/buscador/resultado.jsp?op=3&q=<%=txt%><%=TAB_ID_REQUEST%>">Titular</a>&nbsp;&nbsp;
						</td>


						<td>&nbsp;&nbsp;<a class="<%=(op.equals("4") ? "one" : "two")%>"
							href="/Apia/expedientes/buscador/resultado.jsp?op=4&q=<%=txt%><%=TAB_ID_REQUEST%>">Otros
								datos</a>&nbsp;&nbsp;
						</td>


					</tr>
				</table>
				</p>
				<input type="hidden" id="op" name="op" value="<%=op%>">
			</form>



		</div>
		<p class="tip">Sugerencia: puede ingresar el numero o el asunto
			del expediente.</p>
	</div>

	<%
		ArrayList<Busqueda> arr = new ArrayList<Busqueda>();
		String pagina = "1";
		int CANTIDAD_REGISTROS = Conf.CANTIDAD_REGISTROS;
		int MINIMO_CARACTERES = Conf.MINIMO_CARACTERES;
		int PAGINA_ACTUAL = Integer.parseInt(pagina);
		BusquedaDao BDao = new BusquedaDao();

		boolean hayQueConsultar = true;

		if (request.getParameter("q") != null) {
			if (request.getParameter("pagina") != null) {
				pagina = request.getParameter("pagina");
				PAGINA_ACTUAL = Integer.parseInt(pagina);

				if (PAGINA_ACTUAL > 1) {
					if (session.getAttribute("arrExp") != null) {
						arr = (ArrayList<Busqueda>) session
								.getAttribute("arrExp");
						hayQueConsultar = false;
					}
				}
			}

			if (texto.length() <= MINIMO_CARACTERES) {
				hayQueConsultar = false;
			}

			if (hayQueConsultar) {
				if (op.equals("1")) {
					arr = BDao.busquedaOpcion1(texto, usuario,
							environmentId);
				}
				if (op.equals("2")) {
					arr = BDao.busquedaOpcion2(texto, environmentId);
				}
				if (op.equals("3")) {
					arr = BDao.busquedaOpcion3(texto, environmentId);
				}
				if (op.equals("4")) {
					arr = BDao.busquedaOpcion4(texto, environmentId);
				}
				session.setAttribute("arrExp", arr);
			}
		}
	%>
	<div class="contenedor buscadorResultados cfx">
		<!-- style="background:yellow;"  -->



		<div class="contenido cfx">
			<%
				if (texto.length() <= MINIMO_CARACTERES) {
			%>
			<%
				if (request.getParameter("q") != null) {
			%>


			<%@ include file="no-minimo.jsp"%>


			<%
				}
			%>
			<%
				} else {
			%>
			<%
				if ((arr == null || arr.size() == 0) && (!texto.equals(""))) {
			%>


			<%@ include file="no-encontrado.jsp"%>


			<%
				} else {
			%>


			<%@ include file="paginado.jsp"%>


			<div class="resultadosContenido slide">


				<div class="resultadosListado">

					<ul>
						<%
							for (int i = inicio; i <= fin; i++) {
										//if (i<CANTIDAD_REGISTROS){
										Busqueda t = arr.get(i);
						%>
						<li>
							<h4>
								<span><strong></strong></span>
								<%=BDao.getPrioridadIcono(t.getPrioridad())%>&nbsp;
								<%=t.getAbierto()%>&nbsp;
								<%=t.getDocFisicaIcono()%>&nbsp; <a
									href="/Apia/expedientes/buscador/generarDetalleEE.jsp?nroEE=<%=t.getNroExp()%>&indice=<%=i%><%=TAB_ID_REQUEST%>">

									<!-- event, 'DetalleEE', '<%=t.getNroExp()%>', '<%=i%>' --> <span
									id="posicion"></span> <strong><%=t.getNroExp()%>&nbsp;-&nbsp;<%=BDao.getTipoExpedientes(t.getTipoExpediente())%></strong>
								</a>
								<button id="fav" onclick="javascript:favorito('<%=t.getNroExp()%>','<%=BDao.getGrupo(t.getOficinaActual())%>')">
									<img src="/Apia/expedientes/iconos/fav_12.png"/>
								</button>								
								<!--<img src="/Apia/expedientes/iconos/fav_12.png" onclick="cambiarImgFavorito()">-->
							</h4>



							<p>
								<strong>Fecha creación: </strong><%=t.getFechaCreacion()%>&nbsp;-&nbsp;<strong>Asunto:
								</strong><%=t.getAsunto()%>...
							</p>

							<p>
								<strong>Estado: </strong><%=BDao.getEstados(t.getEstado())%></p>
							<p>
								<strong>Fecha pase: </strong><%=t.getFechaPase()%>&nbsp;-&nbsp;<strong>Oficina
									actual: </strong><%=BDao.getGrupo(t.getOficinaActual())%>&nbsp;-&nbsp;<strong>Usuario
									actual: </strong><%=BDao.getUsuario(t.getUsuarioActual())%></p>
							<p class="urlBusqueda">
								<span> <img src="/Apia/expedientes/iconos/pdf.gif">
									&nbsp;&nbsp; Expediente <%=t.getNroExp()%>.pdf&nbsp;&nbsp; <a
									href="javascript:verFoliado('<%=new Base64().encode(t.getNroExp())%>','TSKOtra')">Descargar</a>&nbsp;&nbsp;
									<span id="info-tamanio-<%=i%>ee"><%=t.getNroExp()%></span>


									&nbsp;-&nbsp; Cáratula <%=t.getNroExp()%>.pdf &nbsp;-&nbsp; <a
									href="javascript:verCaratula('<%=new Base64().encode(t.getNroExp())%>','TSKOtra')">Descargar</a>&nbsp;
									-&nbsp; <%
 	String valoresPro = t.getValoresProceso(environmentId,
 						usuario);
 %>

									<%
										if (valoresPro.equals("Solicitar")) {
									%><a
									href="javascript:solicitarEE('<%=t.getNroExp()%>','<%=BDao.getGrupo(t.getOficinaActual())%>','<%=t.getUsuarioActual()%>')">Solicitar</a>
									<%
										} else {
									%><a href="javascript:trabajarEE('<%=valoresPro%>')">Trabajar<%
										}
									%></a>
								</span>

							</p>
						</li>
						<br>
						<%
							//}
						%>
						<%
							}
						%>
					</ul>
					<br>
				</div>
			</div>
			<div class="caratula" id="DetalleEE" style="display: none;"></div>
			<%
				}
			%>
			<%
				}
			%>
		</div>

		<%
			//@ include file="footer.jsp"
		%>
	
</body>
</html>
