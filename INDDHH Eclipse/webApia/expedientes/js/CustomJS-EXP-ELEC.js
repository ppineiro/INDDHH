function resizeImg(which, w, h) {
	try{	
		elem = which;
		if (elem == undefined || elem == null) return false;

		var t;
		var wt = elem.width;
		var ht = elem.height;

		if (wt > w) {
			t = wt / w;
			wt = wt / t;
			ht = ht / t;
		}

		if (ht > h) {
			t = ht / h;
			ht = ht / h;
			wt = wt / h;
		}

		elem.width = wt;
		elem.height = ht;

		//alert("elem.width: " + wt + " - " + "elem.height: " + ht);
		//alert("elem.width: " + elem.width + " - " + "elem.height: " + elem.height);

	}catch(e){
		//alert(e);
	}		

}

function doAlert(s) {
	alert(s);
}

function apretarConfirmar() {	
	  document.getElementById("btnConf").disabled = false;
	  document.getElementById("btnConf").click();
}

	
function enviarDocumentoaParaFirmar(tipo) {	
	var url = getUrlApp() + "/expedientes/firma/EnviarDocumento.jsp?tipo=" + tipo + windowId;
	var w = xShowModalDialog(url,"Firma dss","dialogWidth:600px; dialogHeight:300px;status=no");
}


function setDataAppletToHTML(eName, eValue) {
	alert("setDataAppletToHTML");	
	alert(eName + ": " + eValue);

	var obj = document.getElementById(eName);
	if (obj!=null){
		obj.value = eValue;
	}
}

function mostrarAcordonados(nroExp){
	var URL = getUrlApp() + "/expedientes/vinculaciones/mostrarVinculaciones.jsp?nroExp=" + nroExp+"&tipoVinc=acor" + TAB_ID_REQUEST;	
	//window.open(URL);
	var w =  ModalController.openWinModal(URL, 900,450);
}

function mostrarRelacionados(nroExp){
	var URL = getUrlApp() + "/expedientes/vinculaciones/mostrarVinculaciones.jsp?nroExp=" + nroExp+"&tipoVinc=rel"+ TAB_ID_REQUEST;	
	//window.open(URL);
	var w =  ModalController.openWinModal(URL, 900,450);
}

function mostrarHistorial(nroExp) {	
	var URL = getUrlApp() + "/expedientes/HistorialActuaciones/historialActuaciones.jsp?NroExp=" + nroExp;
	var w =  ModalController.openWinModal(URL + TAB_ID_REQUEST, 1000, 505, null, null, null, false, false);
	w.setConfirmLabel('Imprimir');
}

function mostrarEleFisicos(nroExp) {	
	var URL = getUrlApp() + "/expedientes/eleFisico/mostrarEleFisicoExpediente.jsp?NroExp=" + nroExp;
	var w =  ModalController.openWinModal(URL + TAB_ID_REQUEST, 1020, 450, null, null, false, true, true);
	//FALTA SETEARLE EL TITULO AL MODAL "Historial"
}

//defino el alto y ancho de las ventanas que se usan para mostrar docuemtnos
var alto = 200//200;/** 20120407_PREVERSION **/
var ancho = 600//300;
var posX = 250;
var posY = 150;

function getUrlApp(){
	try{
		var obj = null;
		obj = getCustomJsp();
		return obj.document.getElementById("flag_url_app").value;
	}catch(e){
		//alert(e);
	}		
	return CONTEXT;
}

function calcularNivelAccesoElegido(nameForm,atributo){
	var valorNivelAcceso = getField(nameForm,atributo).value;
	return valorNivelAcceso;
}

var cantidadClicks = 0;
var token;

/**************************************** ACTUALMENTE UTILIZADOS CONFIRMADOS ****************************************/
function verFoliado(nroExp,tarea) {	

	if (typeof (tarea) == 'undefined') {
		nroExp = encodeBase64(nroExp);
		tarea = "TSKOtra"
	}
	
	var URL = getUrlApp() + "/expedientes/descarga/controlDescarga.jsp?tipo=FOLIADO&nroExp=" + nroExp + "&tarea=" + tarea + TAB_ID_REQUEST;
	
	var xmlHttp = getXmlHttp();		
	xmlHttp.onreadystatechange = function() {
		if (xmlHttp.readyState==4 && xmlHttp.status==200) {
			
			var respuestaTexto = xmlHttp.responseText;
			
			if(respuestaTexto.startsWith("no_borrados")) {
				showMessage("El expediente no tiene documentos en el sistema.");
			}else if(respuestaTexto.startsWith("no")) {			
				showMessage("Usted no tiene los permisos para ver este archivo");
			} else{
				// DESCARGO EL ARCHIVO
				URL = getUrlApp() + "/DownloadServlet?tipo=FOLIADO&nroExp=" + nroExp + "&tarea=" + tarea + TAB_ID_REQUEST;
				var anchorDownloader = new Element('a', {
					href: URL,
					download: 'true'
				}).setStyle('visibility', 'hidden').inject(document.body);
				anchorDownloader.click();					
			}
			
		}
	};	
	
	xmlHttp.open("POST" , URL , true);
	xmlHttp.send(null);
	
}

function verCaratula(nroExp,tarea) {

	if (typeof (tarea) == 'undefined') {
		nroExp = encodeBase64(nroExp);
	}
	
	var URL = getUrlApp() + "/expedientes/descarga/controlDescarga.jsp?tipo=CARATULA&nroExp=" + nroExp + "&tarea=" + tarea + TAB_ID_REQUEST;
	
	var xmlHttp = getXmlHttp();		
	xmlHttp.onreadystatechange = function() {
		if (xmlHttp.readyState==4 && xmlHttp.status==200) {
			
			var respuestaTexto = xmlHttp.responseText;
			
			if(respuestaTexto.startsWith("no_borrados")) {
				showMessage("El expediente no tiene documentos en el sistema.");
			}else{
	
	
				var URL = getUrlApp() + "/DownloadServlet?tipo=CARATULA&nroExp=" + nroExp +"&tarea=" + tarea + TAB_ID_REQUEST;
				
				// DESCARGO EL ARCHIVO
				var anchorDownloader = new Element('a', {
					href: URL,
					download: 'true'
				}).setStyle('visibility', 'hidden').inject(document.body);
				anchorDownloader.click();
			}
			
		}
	};	
	
	xmlHttp.open("POST" , URL , true);
	xmlHttp.send(null);

}

function verArchivo(nroExp, nameArchivo) {

	var URL = getUrlApp() + "/expedientes/descarga/controlDescarga.jsp?tipo=ARCHIVO&nroExp=" + nroExp + "&nameArchivo=" + nameArchivo + TAB_ID_REQUEST;
	
	var xmlHttp = getXmlHttp();		
	xmlHttp.onreadystatechange = function() {
		if (xmlHttp.readyState==4 && xmlHttp.status==200) {
			
			var respuestaTexto = xmlHttp.responseText;
			
			if(respuestaTexto.startsWith("no_borrados")) {
				showMessage("El expediente no tiene documentos en el sistema.");
			}else if (respuestaTexto.startsWith("no")){			
				showMessage("Usted no tiene los permisos para ver este archivo");
			} else{
				// DESCARGO EL ARCHIVO
				URL = getUrlApp() + "/DownloadServlet?tipo=ARCHIVO&nroExp=" + nroExp + "&nameArchivo=" + nameArchivo + TAB_ID_REQUEST;
				var anchorDownloader = new Element('a', {
					href: URL,
					download: 'true'
				}).setStyle('visibility', 'hidden').inject(document.body);
				anchorDownloader.click();					
			}
			
		}
	};	
	
	xmlHttp.open("POST" , URL , true);
	xmlHttp.send(null);
	
}

function verArchivo(nroExp, nameArchivo,tarea) {

	var URL = getUrlApp() + "/expedientes/descarga/controlDescarga.jsp?tipo=ARCHIVO&nroExp=" + nroExp + "&nameArchivo=" + nameArchivo+"&tarea="+tarea + TAB_ID_REQUEST;
	
	var xmlHttp = getXmlHttp();
	xmlHttp.onreadystatechange = function() {
		if (xmlHttp.readyState==4 && xmlHttp.status==200) {
			var respuestaTexto = xmlHttp.responseText;
			if(respuestaTexto.startsWith("no_borrados")) {
				showMessage("El expediente no tiene documentos en el sistema.");
			}else if (respuestaTexto.startsWith("no") && window.atob(nameArchivo).substring(0, 8) != "Caratula"){
				showMessage("Usted no tiene los permisos para ver este archivo");
			}else{
				// DESCARGO EL ARCHIVO
				URL = getUrlApp() + "/DownloadServlet?tipo=ARCHIVO&nroExp=" + nroExp + "&nameArchivo=" + nameArchivo+"&tarea="+tarea + TAB_ID_REQUEST;
				var anchorDownloader = new Element('a', {
					href: URL,
					download: 'true'
				}).setStyle('visibility', 'hidden').inject(document.body);
				anchorDownloader.click();					
			}
		}
	};
	
	xmlHttp.open("GET",URL,false);
	xmlHttp.send();
	
}

function verActuacion(nroExp, nameArchivo) {			
	// SE ARMA URL	
	var URL = getUrlApp() + "/DownloadServlet?tipo=VER_ACTUACION&nroExp=" + nroExp + "&nameArchivo=" + nameArchivo + TAB_ID_REQUEST;
	
	// DESCARGO EL ARCHIVO
	var anchorDownloader = new Element('a', {
		href: URL,
		download: 'true'
	}).setStyle('visibility', 'hidden').inject(document.body);
	anchorDownloader.click();	
}

function imprimirRemito(nroExp,ofiOrigen,asunto,ofiDestino,fecha,firmante) {
	// SE ARMA URL
	nroExp = encodeBase64(nroExp);
	var URL = getUrlApp() + "/DownloadServlet?tipo=REMITO&nroExp=" + nroExp + TAB_ID_REQUEST;
	
	// DESCARGO EL ARCHIVO
	var anchorDownloader = new Element('a', {
		href: URL,
		download: 'true'
	}).setStyle('visibility', 'hidden').inject(document.body);
	anchorDownloader.click();	
}

function verFoliadoLeyAcceso(nroExp,tarea,nivelAcceso) {
	// SE ARMA URL
	nroExp = encodeBase64(nroExp);
	var URL = getUrlApp() + "/DownloadServlet?tipo=FOLIADO&nroExp=" + nroExp+"&tarea=" + tarea+"&nivelAcceso=" + nivelAcceso + TAB_ID_REQUEST;
	
	// DESCARGO EL ARCHIVO	
	var anchorDownloader = new Element('a', {
		href: URL,
		download: 'true'
	}).setStyle('visibility', 'hidden').inject(document.body);
	anchorDownloader.click();	
}

function imprimirRemitoEmitirRemito(nroExp) {
	nroExp = encodeBase64(nroExp);
	var URL = getUrlApp() + "/DownloadServlet?tipo=REMITO&nroExp=" + nroExp  + TAB_ID_REQUEST;
	
	var anchorDownloader = new Element('a', {
		href: URL,
		download: 'true'
	}).setStyle('visibility', 'hidden').inject(document.body);
	anchorDownloader.click();	
}

function imprimirRemitoEmitirRemitoPaseMasivo(nroPM) {
	nroPM = encodeBase64(nroPM);
	var URL = getUrlApp() + "/DownloadServlet?tipo=REMITO_PASE_MASIVO&nroExp=" + nroPM  + TAB_ID_REQUEST;

	var anchorDownloader = new Element('a', {
		href: URL,
		download: 'true'
	}).setStyle('visibility', 'hidden').inject(document.body);
	anchorDownloader.click();	
}
/***************************************************************************************************************************************/

function verFoliadoFast(nroExp,tarea) {		
	var URL = getUrlApp() + "/DownloadServlet?tipo=FOLIADO&nroExp=" + nroExp+"&tarea=" + tarea + TAB_ID_REQUEST;
	
	var anchorDownloader = new Element('a', {
		href: URL,
		download: 'true'
	}).setStyle('visibility', 'hidden').inject(document.body);
	anchorDownloader.click();	
}

function searchSession() {	
	askAjax(URL_ROOT_PATH + "/expedientes/fileProgress.jsp?token=" + token, "", function(txt) {
		if(txt == "ok") {
			var current_parent = window.parent;
			while(current_parent != current_parent.parent && current_parent.document.getElementById("iframeMessages") == null) {
				current_parent = current_parent.parent;
			}
			
			var ifrmMessage = current_parent.document.getElementById("iframeMessages");
			
			if(ifrmMessage == null) {
				alert("Error al descargar el archivo. Contactese con el administrador.");
				return;
			}
			
			ifrmMessage.hideResultFrame();
		} else if(txt.indexOf("msg") >= 0){
			var msg = txt.split("--");
			alert(msg[1] + "\n" + msg[2]);
			
			var current_parent = window.parent;
			while(current_parent != current_parent.parent && current_parent.document.getElementById("iframeMessages") == null) {
				current_parent = current_parent.parent;
			}
			
			var ifrmMessage = current_parent.document.getElementById("iframeMessages");
			
			if(ifrmMessage == null) {
				alert("Error al descargar el archivo. Contactese con el administrador.");
				return;
			}
			
			ifrmMessage.hideResultFrame();
		} else {
			setTimeout(searchSession, 500);
		}
	} );
}

function verFoliadoHastaActuacion(nroExp,nroAct){
	var URL = getUrlApp() + "/expedientes/descarga/controlDescarga.jsp?tipo=FOLIADOACT&nroExp=" + nroExp + "&nroAct=" + nroAct + TAB_ID_REQUEST;
	
	if(window.XMLHttpRequest){
		client=new XMLHttpRequest();
	}
	else{
		client=new ActiveXObject("Microsoft.XMLHTTP");
	}			
	client.open("GET",URL,false);
	client.send();
	
	if (client.readyState==4 && client.status==200){
		if(client.responseText.startsWith("no")){			
			showMessage("Usted no tiene los permisos para ver este archivo");
		} 
		else{
			// DESCARGO EL ARCHIVO
			URL = getUrlApp() + "/DownloadServlet?tipo=FOLIADOACT&nroExp=" + nroExp + "&nroAct=" + nroAct + TAB_ID_REQUEST;
			var anchorDownloader = new Element('a', {
				href: URL,
				download: 'true'
			}).setStyle('visibility', 'hidden').inject(document.body);
			anchorDownloader.click();					
		}			    	
	}	
}

function verActuacionConsultaActuacion(nroExp,nroAct){
	var URL = getUrlApp() + "/DownloadServlet?tipo=VerActCa&nroExp=" + nroExp + "&nroAct=" + nroAct + TAB_ID_REQUEST;
			
	var anchorDownloader = new Element('a', {
		href: URL,
		download: 'true'
	}).setStyle('visibility', 'hidden').inject(document.body);
	anchorDownloader.click();	
}

function verHistCaratulas(nroExp) {
	nroExp = encodeBase64(nroExp);
	var URL = getUrlApp() + "/DownloadServlet?tipo=HIST_CARATULAS&nroExp=" + nroExp + TAB_ID_REQUEST;

	var anchorDownloader = new Element('a', {
		href: URL,
		download: 'true'
	}).setStyle('visibility', 'hidden').inject(document.body);
	anchorDownloader.click();	
}

function verArchivoRec(nroExp, nameArchivo,tarea) {	
	//var URL = getUrlApp() + "/DownloadServlet?tipo=PDFRECEPCION&nroExp=" + nroExp + "&nameArchivo=" + nameArchivo+"&tarea="+tarea + TAB_ID_REQUEST;
	
	/*
	window.status = URL;  	
	var w = window.open(URL,"Archivo","width=" + ancho + ",height=" + alto + ",top=" + posX + ",left=" + posY + ",scrollbars=YES,resizable=YES");
	w.focus();
	*/
	
	/*var anchorDownloader = new Element('a', {
		href: URL,
		download: 'true'
	}).setStyle('visibility', 'hidden').inject(document.body);
	anchorDownloader.click();	*/
	
	
	var URL = getUrlApp() + "/expedientes/descarga/controlDescarga.jsp?tipo=ARCHIVOREC&nroExp=" + nroExp + "&nameArchivo=" + nameArchivo + TAB_ID_REQUEST;
	
	var xmlHttp = getXmlHttp();		
	xmlHttp.onreadystatechange = function() {
		if (xmlHttp.readyState==4 && xmlHttp.status==200) {
			
			if(xmlHttp.responseText.startsWith("no")){			
				showMessage("Usted no tiene los permisos para ver este archivo");
			} else{
				
				// DESCARGO EL ARCHIVO
				URL = getUrlApp() + "/DownloadServlet?tipo=PDFRECEPCION&nroExp=" + nroExp + "&nameArchivo=" + nameArchivo+"&tarea="+tarea + TAB_ID_REQUEST;
				var anchorDownloader = new Element('a', {
					href: URL,
					download: 'true'
				}).setStyle('visibility', 'hidden').inject(document.body);
				anchorDownloader.click();					
			}
			
		}
	};	
	
	xmlHttp.open("POST" , URL , true);
	xmlHttp.send(null);
	
}

function verArchivoModCla(nameArchivo) {	
	var URL = getUrlApp() + "/DownloadServlet?tipo=MODCLA&nameArchivo=" + nameArchivo + TAB_ID_REQUEST;
	
	/*
	window.status = URL;  	
	var w = window.open(URL,"Archivo","width=" + ancho + ",height=" + alto + ",top=" + posX + ",left=" + posY + ",scrollbars=YES,resizable=YES");
	//w.focus();
	*/
	
	var anchorDownloader = new Element('a', {
		href: URL,
		download: 'true'
	}).setStyle('visibility', 'hidden').inject(document.body);
	anchorDownloader.click();	
}

function calcularPathAGModCla(){
	var valorNivelAcceso = getField("FIRMA_RECLASIFICACION","MOD_CLA_PDF_ACTUACION_TMP_STR").value;
	return valorNivelAcceso;
}

function calcularPathCaratulaModCla(){
	var valorNivelAcceso = getField("FIRMA_RECLASIFICACION","MOD_CLA_PDF_CARATULA_TMP_STR").value;
	return valorNivelAcceso;
}

function calcularPathAdjuntoModCla(){
	var valorNivelAcceso = getField("FIRMA_RECLASIFICACION","MOD_CLA_PDF_ADJUNTO_TMP_STR").value;
	return valorNivelAcceso;
}

/*Funciones para Resolucion*/
function verRepartido(nroExp, nameArchivo) {		
	var URL = getUrlApp() + "/DownloadServlet?tipo=REPARTIDO&nroExp=" + nroExp + "&nameArchivo=" + nameArchivo + TAB_ID_REQUEST;
	
	/*
	window.status = URL;  	
	var w = window.open(URL,"Repartido","width=" + ancho + ",height=" + alto + ",top=" + posX + ",left=" + posY + ",scrollbars=YES,resizable=YES");
	w.focus();
	*/
	
	var anchorDownloader = new Element('a', {
		href: URL,
		download: 'true'
	}).setStyle('visibility', 'hidden').inject(document.body);
	anchorDownloader.click();	
}

function verResolucion(nroExp, nameArchivo) {		
	var URL = getUrlApp() + "/DownloadServlet?tipo=RESOLUCION&nroExp=" + nroExp + "&nameArchivo=" + nameArchivo + TAB_ID_REQUEST;
	
	/*
	window.status = URL;  	
	var w = window.open(URL,"Resolucion","width=" + ancho + ",height=" + alto + ",top=" + posX + ",left=" + posY + ",scrollbars=YES,resizable=YES");
	w.focus();
	*/
	
	var anchorDownloader = new Element('a', {
		href: URL,
		download: 'true'
	}).setStyle('visibility', 'hidden').inject(document.body);
	anchorDownloader.click();	
}

function verResolucionConsulta(nroExp) {		
	var URL = getUrlApp() + "/DownloadServlet?tipo=RESOLUCION_CONSULTA&nroExp=" + nroExp + TAB_ID_REQUEST;
	window.status = URL;  	
	var w = window.open(URL,"Resolucion","width=" + ancho + ",height=" + alto + ",top=" + posX + ",left=" + posY + ",scrollbars=YES,resizable=YES");
	w.focus();
}

function verRegistroInfractores(nroExp, nameArchivo) {		
	var URL = getUrlApp() + "/DownloadServlet?tipo=REGISTROINFRACTORES&nroExp=" + nroExp + "&nameArchivo=" + nameArchivo + TAB_ID_REQUEST;
	window.status = URL;  	
	var w = window.open(URL,"RegistroInfractores","width=" + ancho + ",height=" + alto + ",top=" + posX + ",left=" + posY + ",scrollbars=YES,resizable=YES");
	w.focus();
}

function verDocumentoCreado(nroExp, nameArchivo) {		
	var URL = getUrlApp() + "/DownloadServlet?tipo=DOCUMENTOCREADO&nroExp=" + nroExp + "&nameArchivo=" + nameArchivo + TAB_ID_REQUEST;
	
	/*
	window.status = URL;  	
	var w = window.open(URL,"DocumentoCreado","width=" + ancho + ",height=" + alto + ",top=" + posX + ",left=" + posY + ",scrollbars=YES,resizable=YES");
	w.focus();
	*/
	
	var anchorDownloader = new Element('a', {
		href: URL,
		download: 'true'
	}).setStyle('visibility', 'hidden').inject(document.body);
	anchorDownloader.click();	
}

//Esta funcion se usa para ver la Memo en el proceso de Memos
function verMemo(nroMemo, nameArchivo) {		
	var URL = getUrlApp() + "/DownloadServlet?tipo=VER_MEMO&nroMemo=" + nroMemo + "&nameArchivo=" + nameArchivo + TAB_ID_REQUEST;
	
	/*
	window.status = URL;	
	var w = window.open(URL,"Memo","width=" + ancho + ",height=" + alto + ",top=" + posX + ",left=" + posY + ",scrollbars=YES,resizable=YES");
	w.focus();
	*/
	
	var anchorDownloader = new Element('a', {
		href: URL,
		download: 'true'
	}).setStyle('visibility', 'hidden').inject(document.body);
	anchorDownloader.click();	
}

//Esta funcion se usa para ver la Memo en la consulta de memos
function verMemo2(nroMemo, nameArchivo) {		
	var URL = getUrlApp() + "/DownloadServlet?tipo=VER_MEMO_2&nroMemo=" + nroMemo + "&nameArchivo=" + nameArchivo + TAB_ID_REQUEST;
	
	/*
	window.status = URL;	
	var w = window.open(URL,"Memo","width=" + ancho + ",height=" + alto + ",top=" + posX + ",left=" + posY + ",scrollbars=YES,resizable=YES");
	w.focus();
	*/
	
	var anchorDownloader = new Element('a', {
		href: URL,
		download: 'true'
	}).setStyle('visibility', 'hidden').inject(document.body);
	anchorDownloader.click();	
}

//Esta funcion se usa para ver la nota enviada en la tarea de firma
function verNotaEnviada(nroNotaEnv, nameArchivo) {		
	var URL = getUrlApp() + "/DownloadServlet?tipo=VER_NE&nroNotaEnv=" + nroNotaEnv + "&nameArchivo=" + nameArchivo + TAB_ID_REQUEST;
	/*
	window.status = URL;  	
	var w = window.open(URL,"Memo","width=" + ancho + ",height=" + alto + ",top=" + posX + ",left=" + posY + ",scrollbars=YES,resizable=YES");
	w.focus();
	*/
	var anchorDownloader = new Element('a', {
		href: URL,
		download: 'true'
	}).setStyle('visibility', 'hidden').inject(document.body);
	anchorDownloader.click();	
}

//Esta funcion se usa para ver la nota enviada en la consulta de notas enviada
function verNotaEnviada2(nroNotaEnv, nameArchivo) {		
	var URL = getUrlApp() + "/DownloadServlet?tipo=VER_NOTA_ENV&nroNotaEnv=" + nroNotaEnv + "&nameArchivo=" + nameArchivo + TAB_ID_REQUEST;
	
	/*
	window.status = URL;  	
	var w = window.open(URL,"Memo","width=" + ancho + ",height=" + alto + ",top=" + posX + ",left=" + posY + ",scrollbars=YES,resizable=YES");
	w.focus();
	*/
	
	var anchorDownloader = new Element('a', {
		href: URL,
		download: 'true'
	}).setStyle('visibility', 'hidden').inject(document.body);
	anchorDownloader.click();	
}

//Esta funcion se usa para ver la nota recibida en la consulta de notas recibida
function verNotaRecibida(nroNotaRec, nameArchivo) {	  
	var URL = getUrlApp() + "/DownloadServlet?tipo=VER_NOTA_REC&nroNotaRec=" + nroNotaRec + "&nameArchivo=" + nameArchivo + TAB_ID_REQUEST;
	
	/*
	window.status = URL;  	
	var w = window.open(URL,"Memo","width=" + ancho + ",height=" + alto + ",top=" + posX + ",left=" + posY + ",scrollbars=YES,resizable=YES");
	w.focus();
	*/
	
	var anchorDownloader = new Element('a', {
		href: URL,
		download: 'true'
	}).setStyle('visibility', 'hidden').inject(document.body);
	anchorDownloader.click();	
}

function verOficio(nroOficio, nameArchivo) {		
	var URL = getUrlApp() + "/DownloadServlet?tipo=VER_OFICIO&nroOficio=" + nroOficio + "&nameArchivo=" + nameArchivo + TAB_ID_REQUEST;
	
	/*
	window.status = URL;  	
	var w = window.open(URL,"Memo","width=" + ancho + ",height=" + alto + ",top=" + posX + ",left=" + posY + ",scrollbars=YES,resizable=YES");
	w.focus();
	*/
	
	var anchorDownloader = new Element('a', {
		href: URL,
		download: 'true'
	}).setStyle('visibility', 'hidden').inject(document.body);
	anchorDownloader.click();	
}


function verVistaPrevia(nroExp, nameArchivo) {		
	var URL = getUrlApp() + "/DownloadServlet?tipo=VISTA_PREVIA&nroExp=" + nroExp + "&nameArchivo=" + nameArchivo + "&nonInline=true" + TAB_ID_REQUEST;
	bajarPorIFrame(URL);
	//window.status = URL;  	
	//var w = window.open(URL,"VistaPrevia","width=" + ancho + ",height=" + alto + ",top=" + posX + ",left=" + posY + ",scrollbars=YES,resizable=YES");
	//w.focus();
}

function verArchivoArbolND(nameArchivo) {		
	var URL = getUrlApp() + "/DownloadServlet?tipo=VER_ARBOL_ND&nroExp=&nameArchivo=" + nameArchivo + TAB_ID_REQUEST;
	
	/*
	window.status = URL;  	
	var w = window.open(URL,"ArbolND","width=" + ancho + ",height=" + alto + ",top=" + posX + ",left=" + posY + ",scrollbars=YES,resizable=YES");
	w.focus();
	*/
	
	var anchorDownloader = new Element('a', {
		href: URL,
		download: 'true'
	}).setStyle('visibility', 'hidden').inject(document.body);
	anchorDownloader.click();	
}

function verArchivoOrganigramaUO(nameArchivo) {		
	var URL = getUrlApp() + "/DownloadServlet?tipo=verArchivoOrganigramaUO&nroExp=&nameArchivo=" + nameArchivo + TAB_ID_REQUEST;
	
	/*
	window.status = URL;  	
	var w = window.open(URL,"OrganigramaUO","width=" + ancho + ",height=" + alto + ",top=" + posX + ",left=" + posY + ",scrollbars=YES,resizable=YES");
	w.focus();
	*/
	
	var anchorDownloader = new Element('a', {
		href: URL,
		download: 'true'
	}).setStyle('visibility', 'hidden').inject(document.body);
	anchorDownloader.click();	
}

function verArchivoNotificacion(nroExp, nameArchivo) {	
	var URL = getUrlApp() + "/DownloadServlet?tipo=NOTIFICACION&nameArchivo=" + nameArchivo + "&nroExp=" + nroExp + TAB_ID_REQUEST;
	
	/*
	window.status = URL;  	
	var w = window.open(URL,"Notificacion","width=" + ancho + ",height=" + alto + ",top=" + posX + ",left=" + posY + ",scrollbars=YES,resizable=YES");
	w.focus();
	*/
	
	var anchorDownloader = new Element('a', {
		href: URL,
		download: 'true'
	}).setStyle('visibility', 'hidden').inject(document.body);
	anchorDownloader.click();	
}

function verArchivoNotificacion(nroExp, nameArchivo) {	
	var URL = getUrlApp() + "/DownloadServlet?tipo=VISTA_PREVIA_NOTIFICACION&nameArchivo=" + nameArchivo + "&nroExp=" + nroExp + TAB_ID_REQUEST;
	
	/*
	window.status = URL;  		
	var w = window.open(URL,"Notificacion","width=" + ancho + ",height=" + alto + ",top=" + posX + ",left=" + posY + ",scrollbars=YES,resizable=YES");
	w.focus();
	*/
	
	var anchorDownloader = new Element('a', {
		href: URL,
		download: 'true'
	}).setStyle('visibility', 'hidden').inject(document.body);
	anchorDownloader.click();	
}

function verActuacionNumerada(nroExp, nameArchivo) {	
//	var nroExp = nameArchivo;
//	nroExp = replaceSubstring(nroExp,'.pdf','');
//	var vec = nroExp.split("-");
//	nroExp = vec[2] + "/" + vec[3];	

	var URL = getUrlApp() + "/DownloadServlet?tipo=VER_ACTUACION&nroExp=" + nroExp + "&nameArchivo=" + nameArchivo + TAB_ID_REQUEST;

	/*
	window.status = URL;  	
	var w = window.open(URL,"Actuacion","width=" + ancho + ",height=" + alto + ",top=" + posX + ",left=" + posY + ",scrollbars=YES,resizable=YES");
	w.focus();
	*/
	
	var anchorDownloader = new Element('a', {
		href: URL,
		download: 'true'
	}).setStyle('visibility', 'hidden').inject(document.body);
	anchorDownloader.click();	
}

function bajarPorIFrame(URL){
	var iFrame = document.getElementById("sebasto");
	if(iFrame == null){
		iFrame = document.createElement("IFRAME");
		iFrame.id="sebasto";
		iFrame.name="sebasto";
		document.body.appendChild(iFrame);
		iFrame.style.width="1px";
		iFrame.style.height="1px";
	}
	iFrame.src=URL;
}

function desHabilitarConfirmar() {
	try{
		if (document.getElementById("btnConf")!=null){
			document.getElementById("btnConf").disabled = true;
		}
	}catch(e){
		//alert(e);
	}			
}

function habilitarConfirmarConRetardo() {
	try{

		if (document.getElementById("btnConf")!=null){
			if (document.getElementById("btnConf").disabled == true){
				document.getElementById("btnConf").disabled = false;							
			}			
		}	

	}catch(e){
		alert(e);
	}				
}

var nombreArchivo = "";

function habilitarConfirmar() {		
	try{

		if (document.getElementById("btnConf")!=null){
			if (document.getElementById("btnConf").disabled == true){
				document.getElementById("btnConf").disabled = false;							
			}			
		}	

	}catch(e){
		alert(e);
	}	
}



function getIndex(evtSource){
	var vIndex = getEvtSourceRowIndex(evtSource); /*evtSource.parentNode.parentNode.rowIndex;

	if(vIndex != null){
		vIndex = vIndex - 2;
		if(vIndex < 0){
			alert("Error al obtener el �ndice");
			vIndex = "0";
		}
	}else{
		vIndex = "0";
	}*/

	return vIndex;
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

function sacarSeperadorDeLosExtremos(tmp, sep2){
	//sacamos el primer caracter si es un separador
	if (tmp.indexOf(sep2)==0){		
		tmp = tmp.substring(1, (tmp.length))
	}

	//sacamos el ultimo caracter si es un separador
	if (tmp.lastIndexOf(sep2)== (tmp.length - 1)){		
		tmp = tmp.substring(0, (tmp.length - 1))
	}

	return tmp;		
}	

function replaceSubstring(inputString, fromString, toString) {
	// Goes through the inputString and replaces every occurrence of fromString with toString
	var temp = inputString;
	if (fromString == "") {
		return inputString;
	}
	if (toString.indexOf(fromString) == -1) { // If the string being replaced is not a part of the replacement string (normal situation)
		while (temp.indexOf(fromString) != -1) {
			var toTheLeft = temp.substring(0, temp.indexOf(fromString));
			var toTheRight = temp.substring(temp.indexOf(fromString)+fromString.length, temp.length);
			temp = toTheLeft + toString + toTheRight;
		}
	} else { // String being replaced is part of replacement string (like "+" being replaced with "++") - prevent an infinite loop
		var midStrings = new Array("~", "`", "_", "^", "#");
		var midStringLen = 1;
		var midString = "";
		// Find a string that doesn't exist in the inputString to be used
		// as an "inbetween" string
		while (midString == "") {
			for (var i=0; i < midStrings.length; i++) {
				var tempMidString = "";
				for (var j=0; j < midStringLen; j++) { tempMidString += midStrings[i]; }
				if (fromString.indexOf(tempMidString) == -1) {
					midString = tempMidString;
					i = midStrings.length + 1;
				}
			}
		} // Keep on going until we build an "inbetween" string that doesn't exist
		// Now go through and do two replaces - first, replace the "fromString" with the "inbetween" string
		while (temp.indexOf(fromString) != -1) {
			var toTheLeft = temp.substring(0, temp.indexOf(fromString));
			var toTheRight = temp.substring(temp.indexOf(fromString)+fromString.length, temp.length);
			temp = toTheLeft + midString + toTheRight;
		}
		// Next, replace the "inbetween" string with the "toString"
		while (temp.indexOf(midString) != -1) {
			var toTheLeft = temp.substring(0, temp.indexOf(midString));
			var toTheRight = temp.substring(temp.indexOf(midString)+midString.length, temp.length);
			temp = toTheLeft + toString + toTheRight;
		}
	} // Ends the check to see if the string being replaced is part of the replacement string or not
	return temp; // Send the updated string back to the user
} // Ends the "replaceSubstring" function
//---

var ajaxChkFirma;
function funcionCallbackChkFirma(){	

	//alert("funcionCallbackChkFirma");	
	// Comprobamos si la peticion se ha completado (estado 4)
	if( ajaxChkFirma.readyState == 4 ){
		// Comprobamos si la respuesta ha sido correcta (resultado HTTP 200)
		if( ajaxChkFirma.status == 200 ){
			// Escribimos el resultado en la pagina HTML mediante DHTML
			var result = ajaxChkFirma.responseText;
			//alert("result: " + result);	
			if (result.length>0){
				habilitarConfirmar();
			}
		}
	}		
}

function chkFirma(nombreArchivo){
	if (nombreArchivo!=""){
		//alert("chkFirma");	

		// Creamos el control XMLHttpRequest segun el navegador en el que estemos
		if( window.XMLHttpRequest )
			ajaxChkFirma = new XMLHttpRequest(); // No Internet Explorer
		else
			ajaxChkFirma = new ActiveXObject("Microsoft.XMLHTTP"); // Internet Explorer
		// Almacenamos en el control al funcion que se invocara cuando la peticion
		// cambie de estado

		ajaxChkFirma.onreadystatechange = funcionCallbackChkFirma;

		// Enviamos la peticion
		var URL = getUrlApp() + "/expedientes/firma/chkFirma.jsp?nombre=" + nombreArchivo;
		//alert("URL: " + URL);			
		window.status = URL;
		ajaxChkFirma.open( "POST", URL, true );	
		ajaxChkFirma.send( "" );		
	}
}

function creaAjax(){
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
function FAjax (url,valores,metodo){
	alert(url);
	alert(valores);
	alert(metodo);

	ajaxChkFirma=creaAjax();
	//var ajaxChkFirma=creaAjax();
	//var capaContenedora = document.getElementById(capa);

	/*Creamos y ejecutamos la instancia si el metodo elegido es POST*/
	if(metodo.toUpperCase()=='POST'){
		ajaxChkFirma.open ('POST', url, true);
		ajaxChkFirma.onreadystatechange = funcionCallbackChkFirma;
		ajaxChkFirma.setRequestHeader('Content-Type','application/x-www-form-urlencoded');
		ajaxChkFirma.send(valores);
		//return;
	}
	/*Creamos y ejecutamos la instancia si el metodo elegido es GET*/
	if (metodo.toUpperCase()=='GET'){	
		ajaxChkFirma.open ('GET', url, true);
		ajaxChkFirma.onreadystatechange = funcionCallbackChkFirma;
		ajaxChkFirma.setRequestHeader('Content-Type','application/x-www-form-urlencoded');
		ajaxChkFirma.send(null);
		//return;
	}
}


//------------------------------------------------------

function guardarExpediente(){
	if (document.getElementById("btnSave")!=null){
		if (document.getElementById("btnSave").disabled == false) {
			var flag = false;
			var msg = "";
			if (document.getElementById("ACTUACIONES_EXP_ACTUACION_STR")!=null){
				if (document.getElementById("ACTUACIONES_EXP_PAGINA_CARGADA_STR")!=null){
					if (document.getElementById("ACTUACIONES_EXP_PAGINA_CARGADA_STR").value=="OK"){
						msg = "Tiene una actuaci�n sin guardar! \n    �Desea guardarla?";
						if (confirm(msg)) {					
							if (document.getElementById("btnSave")!=null){
								if (document.getElementById("btnSave").disabled == false) {
									document.getElementById("btnSave").onclick();
								}
								flag = true;												
							}
						}
					}
				}		
			}
			if (document.getElementById("CONTENIDO_MEMO_MEM_CONTENIDO_STR")!=null){
				msg = "Tiene un memo sin guardar! \n    �Desea guardarlo?";
				if (confirm(msg)) {					
					if (document.getElementById("btnSave")!=null){
						if (document.getElementById("btnSave").disabled == false) {
							document.getElementById("btnSave").onclick();
						}
						flag = true;												
					}
				}	
			}
			if (flag){
				alert("�Documento guardado!");		
			}	
		}
	}
}

window.onbeforeunload=function(){
	try{	

		if (document.getElementById("ACTUACIONES_EXP_ACTUACION_STR")!=null || document.getElementById("CONTENIDO_MEMO_MEM_CONTENIDO_STR")!=null){

			var obj = getCustomJsp();

			if (obj != null){			
				if (obj.document.getElementById("flag_auto_guardar_exp") != null){					
					if (obj.document.getElementById("flag_auto_guardar_exp").value == 'true'){						
						if (obj.document.getElementById("flag_session_activa") != null){							
							if (obj.document.getElementById("flag_session_activa").value == 'true'){								
								//alert(obj.document.getElementById("flag_save_actuacion").value);								
								if (obj.document.getElementById("flag_save_actuacion").value == 'true'){
									obj.document.getElementById("flag_auto_guardar_exp").value = 'false';
									obj.document.getElementById("flag_save_actuacion").value = 'false';	
									guardarExpediente();
								}
							}
						}
					}
				}
			}
		}

	}catch(e){
		//alert(e);
	}	
	flagAutoGaurdar = true;
}


function desactivarFlag(){ 
	if (document.getElementById("ACTUACIONES_EXP_ACTUACION_STR")!=null){
		var obj = parent.parent.frames["topFrame"];	
		obj.document.getElementById("flag_auto_guardar_exp").value = 'false'; 
	}
}

function getCustomJsp(){
	var obj = null;
	if (parent.parent.frames["topFrame"]!=null){
		obj = parent.parent.frames["topFrame"];			
	}			
	if (parent.frames["topFrame"]!=null){
		obj = parent.frames["topFrame"];			
	}

	if (obj != null){				
		if (obj.document.getElementById("iframeCustomJsp")!=null){
			obj = obj.document.getElementById("iframeCustomJsp").contentWindow;

			if (obj != null){
			}
		}
	}

	return obj;				
}

function obtenerMensajeMultilenguajeSegunCodigo(codigo,currentLanguage){
	//return top.topFrame.document.getElementById("iframeCustomJsp").contentWindow.obtenerMensajeSegunCodigo(codigo,currentLanguage);
	return obtenerMensajeSegunCodigo(codigo,currentLanguage);
}

function showMessageCustom(text, title, additionalClass, fncClose){
		var panel = SYS_PANELS.newPanel([]);
	
		if (title) panel.header.innerHTML = title;
		if (additionalClass) panel.addClass(additionalClass);
		
		panel.content.innerHTML = text;
		SYS_PANELS.addClose(panel, undefined, fncClose);
		SYS_PANELS.adjustVisual();
		
		if(window.frameElement && $(window.frameElement).hasClass('modal-content')) {
			$(window.frameElement).fireEvent('block');
		}
		
		return panel;
}

function encodeBase64(input){
	var output = btoa(input);
	return output;
}

function decodeBase64(input){
	var output = atob(input);
	return output;
}

function consultar_firmantes(url){
	getTabContainerController().addNewTab("Estado de expedientes a firmar", url);
}

function stars(e, codPregunta){
	
	var URL = getUrlApp() + "/expedientes/stars/starsGetProEntIds.jsp?" + parent.TAB_ID_REQUEST;
	
	var xmlHttp = getXmlHttp();		
	xmlHttp.onreadystatechange = function() {
		if (xmlHttp.readyState==4 && xmlHttp.status==200) {
			
			var ids = xmlHttp.responseText;
			var pro_id = ids.split(";")[0];
			var ent_id = ids.split(";")[1];
			
			var url_tab =  getUrlApp() + "/apia.execution.TaskAction.run?action=startCreationProcess&busEntId=" + ent_id + "&proId=" + pro_id + parent.TAB_ID_REQUEST + "&E_ENC_USU_PREGUNTA_STR=" + codPregunta;	   
			var title = "Ay\u00fadenos a mejorar";	
			ApiaFunctions.openTab(title, url_tab);
			e.style.display = 'none';
			
		}
	};	
	
	xmlHttp.open("POST" , URL , true);
	xmlHttp.send(null);
	
}

function getXmlHttp() {
	
	var xmlHttp = null;
	if (window.XMLHttpRequest) {
		xmlHttp = new XMLHttpRequest();
	} else {
		xmlHttp = new ActiveXObject("Microsoft.XMLHTTP");
	}
	return xmlHttp;
	
}
