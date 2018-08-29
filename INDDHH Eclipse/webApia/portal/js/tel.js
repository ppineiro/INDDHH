/***************** VERSION 3.1.0.6 ******************/
var showErrorFnc = true;
var btnAction = "";
var contador = 0;
var objVolverFoco = "sin definir";
var indexError = 0;
var maxError = 0;
var errorActual = 0;
var div_err;
var tarea;
var cerrarDivError = false;
var hayQueRemoveErrors = true;

var frmCheckerDisplay = {
	addClassErrorToField : 1,
	errorsLocation : 3,
	listErrorsAtTop : true,
	// keepFocusOnError : 2,
	indicateErrors : 2,
	scrollToFirst : false
}

var addStepsName = true;

var posX;
var posY;
function raton(e) { 
  posX = e.clientX; 
  posY = e.clientY; 
}

window.addEvent('load', function() {
	var tabs = $$('*.tab');
	if (tabs.length > 1) {
		try {
			tabs[1].fireEvent('click', new Event({
				type : 'click'
			}));
		} catch (error) {
		}
	}

	var tabHolder = $('tabHolder');
	if (tabHolder) {
		var childsTabs = tabHolder.getChildren();
		if (childsTabs.length == 1
				&& childsTabs[0].getStyle('display') == 'none')
			tabHolder.setStyle('display', 'none');
	}

	$('btnPanel').getElements('button.genericBtn').each(function(btn) {
		if (!btn.hasClass('suggestedAction'))
			btn.getParent().addClass('notSuggestedAction');
	});

	var steps = $('divAdminActSteps');
	if (steps) {
		steps.inject($('tabHolder'), 'before');
	}

	if (EXTERNAL_ACCESS == "true") {
		fixFrameHeight();
		setInterval(fixFrameHeight, 1000);
		setTimeout(showFrmMail, 1000);
	}
	
	//setInterval(loadMsgError, 1000);
	
	//AQUÍ INICIA EL CAMBIO QUE PERMITE NO PERDER EL FOCO TRAS HACER RELOAD.
	
	//Localstorage es una estructura que te permite guardar información en el navegador sin necesidad de usar cookies. Y guarda pares del estilo (key, value).
	if (localStorage.length != 0 ) { // Si el localStorage no está vacío...
		if (document.querySelector('[data-fld_id=' + localStorage.getItem('data-fld_id') + ']')!= null ) {
			document.querySelector('[data-fld_id=' + localStorage.getItem('data-fld_id') + ']').focus();//...Tomo el atributo que tiene guardado el localstorage y le hago focus.
		}
		localStorage.clear();// Limpio el localstorage.
	}
	
	var allElems = document.querySelectorAll('[data-fld_id]');//Tomo todos los elementos de los formularios que posean atributos.
	for (i = 0; i < allElems.length; i++) {//Recorro la lista de elementos
		var elem = allElems[i];
		if(elem) {//Si existe el elemento
			elem.addEvent('change', function(e) {//Le agrego el evento onChange al elemento
				if (e) e.stop();
				localStorage.setItem('data-fld_id', this.getAttribute('data-fld_id'));//cargo el atributo de dicho elemento en el localstorage
			});
		}
	}
	//AQUÍ FINALIZA EL CAMBIO QUE PERMITE NO PERDER EL FOCO TRAS HACER RELOAD.
	
	//AQUÍ COMIENZA EL CAMBIO PARA AGREGAR EVENTO A LOS FILEINPUTS
	var allFiles = document.querySelectorAll('div.docUploadIcon');
	for (i = 0; i < allFiles.length; i++) {
		var fileInput = allFiles[i];
		fileInput.addEventListener('mouseout', function (evt) {
		    var abuelo = this.getParent().getParent();
		    if (abuelo.hasClass('fc-field-error'))  {
		    	abuelo.removeClass('fc-field-error');
		    }
		});
	}
});

String.prototype.replaceAll = function(str1, str2, ignore) {
	return this.replace(new RegExp(str1.replace(
			/([\/\,\!\\\^\$\{\}\[\]\(\)\.\*\+\?\|\<\>\-\&])/g, "\\$&"),
			(ignore ? "gi" : "g")), (typeof (str2) == "string") ? str2.replace(
			/\$/g, "$$$$") : str2);
}

function loadTitle() {
	
	var x = document.getElementsByClassName("gridMinWidth");
	if (x != null) {
		var i;
		for (i = 0; i < x.length; i++) {
			// for (i = 0; i < 1; i++) {
			if (x[i].innerHTML=="Eliminar") {
				x[i].title="Eliminar";
			}
		}
	}
	
	
	ajustarAnchoColumna();
	
	tarea = ApiaFunctions.getCurrentTaskName();
	
	//alert(tarea);
	
	var step = 0;

	if (!isMonitor) {
		step = ApiaFunctions.getCurrentStep();
	}

	var entro = false;
	var form = ApiaFunctions.getForm("TRM_TITULO");
	if (form != null) {
		var title = form.getField("TRM_NOMBRE_STR").getValue();
		var logo = CONTEXT + "/images/" + NOMBRE_LOGO;
		
//		var t = "<table title='"+title+"' style='width: 100%;'><tr><td style='text-align: left; width: 70%;'><div id='titleTramite2' class='titleTramite2'>" + title + "</div></td><td style='text-align: right; width: 30%;'><img src='" + logo + "' alt='Organismo'></td></tr></table>";
		debugger;
		var presidencia = CONTEXT + "/images/presidenciaTramite.png";
		var t = "";
		try{
			var nome = CURRENT_USER_NAME;
			t = "<table style='width: 100%;'><caption class='hide-read'>&nbsp;</caption><tr><td style='text-align: left; width: 180px;'><img id='img-organismo' src='" + logo + "' alt='Organismo'></td><td style='text-align: left; width: auto;'><div id='titleTramite2' class='titleTramite2'> | " + title + "</div></td><td style='text-align: right; width: auto;'><img src='" + presidencia + "' alt='Logo_Presidencia'></td></tr> <tr><td></td><td></td><td style='text-align: right; font-family: Time New Romans; font-size: 13.5px !important'><span id='btnSalir2'>Bienvenido, " + nome +" (<button type='button' class='css-ver-como-link' onclick='salirTramite();return false;'>Salir</button>)</span></td></tr></table>";	
		}catch(err){
			t = "<table style='width: 100%;'><caption class='hide-read'>&nbsp;</caption><tr><td style='text-align: left; width: 180px;'><img id='img-organismo' src='" + logo + "' alt='Organismo'></td><td style='text-align: left; width: auto;'><div id='titleTramite2' class='titleTramite2'> | " + title + "</div></td><td style='text-align: right; width: auto;'><img src='" + presidencia + "' alt='Logo_Presidencia'></td></tr></table>";
		}
		
		document.getElementById("titleTramite").innerHTML = t;
		
		if (EXTERNAL_ACCESS == "true") {
			try {
				top.document.title = title;
			} catch (e) {
			}
		}
		if (window.CURRENT_PROCESS_NAME == undefined
				|| CURRENT_PROCESS_NAME == "TRAMITE_PORTAL"
				|| CURRENT_PROCESS_NAME == "COMUNICACIONES"	) {

			var w = window.innerWidth;
			var h = window.innerHeight;
			var wTotal = window.top.innerWidth;
			var porcent = parseInt((w * 100) / wTotal);
			var limite = parseInt("85");

			var anchoBtnLast = "0%";
			var anchoBtnSalir = "0%";
			var anhoBtnDescartar = "0%";
			var anchoBtnSave = "0%";

			if (tarea == "SELECCIONAR_TRAMITE" ) {
				document.getElementById("btnLast").style.display = "none";
				document.getElementById("btnSalir").style.display = "none";
				if (document.getElementById("btnSalir2") != null) {
					document.getElementById("btnSalir2").style.display = "none";
				}
				document.getElementById("btnDescartar").style.display = "none";
				document.getElementById("btnSave").style.display = "none";
				document.getElementById("btnNext").style.display = "none";
				document.getElementById("btnConf").innerHTML = "Continuar al paso siguiente &gt;&gt;";
			}

			if (tarea == "CARGA_DATOS_TRAMITE"  || tarea == "RETOMA_CARGA_DATOS" ) {
				if (porcent > limite) {
					if (step == "1") {
						anchoBtnSalir = "36%";
						anhoBtnDescartar = "38%";
						anchoBtnSave = "40%";
					} else {
						anchoBtnSalir = "20%";
						anhoBtnDescartar = "22%";
						anchoBtnSave = "24%";
					}
				} else {
					if (step == "1") {
						anchoBtnSalir = "28%";
						anhoBtnDescartar = "30%";
						anchoBtnSave = "32%";
					} else {
						anchoBtnSalir = "10%";
						anhoBtnDescartar = "12%";
						anchoBtnSave = "14%";
					}
				}
				if (step == "1") {
					document.getElementById("btnLast").style.display = "none";
				}
				if (step == "10") {
					document.getElementById("btnNext").style.display = "none";
				} else {
					document.getElementById("btnConf").style.display = "none";
				}
			}
			
			if (tarea == "RESULTADO") {
				document.getElementById("btnLast").style.display = "none";
				document.getElementById("btnSalir").style.display = "none";
				document.getElementById("btnDescartar").style.display = "none";
				document.getElementById("btnSave").style.display = "none";
				document.getElementById("btnNext").style.display = "none";
			}
			if (tarea == "SELECCIONAR_MEDIO_PAGO") {

				document.getElementById("btnLast").style.display = "none";
				document.getElementById("btnDescartar").style.display = "none";
				if (porcent > limite) {
					anchoBtnSalir = "36%";
					anhoBtnDescartar = "38%";
					anchoBtnSave = "40%";
				} else {
					anchoBtnSalir = "28%";
					anhoBtnDescartar = "30%";
					anchoBtnSave = "32%";
				}				
				if (step == "1") {
					document.getElementById("btnConf").style.display = "none";
				} else {
					document.getElementById("btnNext").style.display = "none";
				}

			}
			if (tarea == "AGENDAR_TRAMITE") {
				document.getElementById("btnLast").style.display = "none";
				document.getElementById("btnNext").style.display = "none";
			}
		}
		if (tarea == "FIRMA" || tarea == "MULTIPLES_FIRMAS" ) {
			document.getElementById("btnLast").style.display = "none";
			document.getElementById("btnNext").style.display = "none";
			if ( tarea == "MULTIPLES_FIRMAS" ) {
				document.getElementById("btnDescartar").style.display = "none";
			}
		}

		entro = true;
	}
	var form = ApiaFunctions.getForm("CMN_TITULO");
	if (form != null) {
		var title = form.getField("CMN_NOMBRE_STR").getValue();
		document.getElementById("titleTramite2").innerHTML = title;

		if (window.CURRENT_PROCESS_NAME == undefined
				|| CURRENT_PROCESS_NAME == "COMUNICACIONES"	) {

			var w = window.innerWidth;
			var h = window.innerHeight;
			var wTotal = window.top.innerWidth;
			var porcent = parseInt((w * 100) / wTotal);
			var limite = parseInt("85");

			var anchoBtnLast = "0%";
			var anchoBtnSalir = "0%";
			var anhoBtnDescartar = "0%";
			var anchoBtnSave = "0%";
			if (tarea == "CARGA_DATOS_COMUNICACION" ) {
				if (porcent > limite) {
					if (step == "1") {
						anchoBtnSalir = "36%";
						anhoBtnDescartar = "38%";
						anchoBtnSave = "40%";
					} else {
						anchoBtnSalir = "20%";
						anhoBtnDescartar = "22%";
						anchoBtnSave = "24%";
					}
				} else {
					if (step == "1") {
						anchoBtnSalir = "28%";
						anhoBtnDescartar = "30%";
						anchoBtnSave = "32%";
					} else {
						anchoBtnSalir = "10%";
						anhoBtnDescartar = "12%";
						anchoBtnSave = "14%";
					}
				}
				if (step == "1") {
					document.getElementById("btnLast").style.display = "none";
				}
				if (step == "10") {
					document.getElementById("btnNext").style.display = "none";
				} else {
					document.getElementById("btnConf").style.display = "none";
				}
				document.getElementById("btnDescartar").style.display = "none";
			}
			if (tarea == "ENCUESTA") {
				document.getElementById("btnLast").style.display = "none";
				document.getElementById("btnSalir").style.display = "none";
				document.getElementById("btnDescartar").style.display = "none";
				document.getElementById("btnSave").style.display = "none";
				document.getElementById("btnNext").style.display = "none";
			}

		}
		
	}
	
	if (tarea == "TAREA_DUMMY" ) {
		document.getElementById("btnLast").style.display = "none";
		document.getElementById("btnSalir").style.display = "none";
		document.getElementById("btnDescartar").style.display = "none";
		document.getElementById("btnSave").style.display = "none";
		document.getElementById("btnNext").style.display = "none";
		document.getElementById("btnConf").innerHTML = "Continuar al paso siguiente &gt;&gt;";
	}

	if (tarea == "AGENDAR_TRAMITE") {
		document.getElementById("btnLast").style.display = "none";
		//document.getElementById("btnSalir").style.display = "none";
		//document.getElementById("btnSalir2").style.display = "none";
		document.getElementById("btnDescartar").style.display = "none";
		//document.getElementById("btnSave").style.display = "none";
		document.getElementById("btnNext").style.display = "none";
	}			
	
	if (tarea == "RETOMAR_TRAMITE") {
		if (step == "1") {
			document.getElementById("btnLast").style.display = "none";
			document.getElementById("btnSalir").style.display = "none";
			document.getElementById("btnDescartar").style.display = "none";
			document.getElementById("btnSave").style.display = "none";
			document.getElementById("btnConf").style.display = "none";
			document.getElementById("btnNext").innerHTML = "Retomar >>";
		}
		if (step == "2") {
			document.getElementById("btnSalir").style.display = "none";
			document.getElementById("btnDescartar").style.display = "none";
			document.getElementById("btnSave").style.display = "none";
			document.getElementById("btnNext").style.display = "none";
			document.getElementById("btnConf").style.display = "none";
		}

	}

	if (tarea == "PEDIR_ACLARACIONES" || tarea == "COMPLETAR_INFORMACION_BARCO" || tarea == "DAR_RESPUESTA") {
		document.getElementById("btnLast").style.display = "none";
		document.getElementById("btnDescartar").style.display = "none";
		document.getElementById("btnNext").style.display = "none";
	}
	
	if (tarea == "CONSULTAR_EXPEDIENTE") {
		if (step == "1") {
			document.getElementById("btnLast").style.display = "none";
			document.getElementById("btnSalir").style.display = "none";
			document.getElementById("btnDescartar").style.display = "none";
			document.getElementById("btnSave").style.display = "none";
			document.getElementById("btnConf").style.display = "none";
			document.getElementById("btnNext").innerHTML = "Consultar >>";
		}
		if (step == "2") {
			document.getElementById("btnSalir").style.display = "none";
			document.getElementById("btnDescartar").style.display = "none";
			document.getElementById("btnSave").style.display = "none";
			document.getElementById("btnNext").style.display = "none";
			document.getElementById("btnConf").style.display = "none";
		}
	}

	var form = ApiaFunctions.getForm("SELECCIONAR_EXPEDIENTE_WS");
	if (form != null) {
		document.getElementById("titleTramite").innerHTML = "<h2>Consultar expediente</h2>";
		entro = true;
	}
	var form = ApiaFunctions.getForm("DATOS_EXPEDIENTE_WS");
	if (form != null) {
		document.getElementById("titleTramite").innerHTML = "<h2>Consultar expediente</h2>";
		entro = true;
	}
	var form = ApiaFunctions.getForm("RET_TRM_DATOS_RETOMA");
	if (form != null) {
		document.getElementById("titleTramite").innerHTML = "<h2>Retomar Trámite</h2>";
		entro = true;
	}
	var form = ApiaFunctions.getForm("RET_TRM_DATOS_RETOMA_2");
	if (form != null) {
		document.getElementById("titleTramite").innerHTML = "<h2>Retomar Trámite</h2>";
		entro = true;
	}
	if (!entro) {
		// document.getElementById("titleTramite").innerHTML = "No se encontró el expediente <br><br>";
		document.getElementById("titleTramite").innerHTML = "";
	}

	if (isMonitor) {
		document.getElementById("btnLast").style.display = "none";
		document.getElementById("btnSalir").style.display = "none";
		if (document.getElementById("btnSalir2") != null) {
			document.getElementById("btnSalir2").style.display = "none";
		}
		document.getElementById("btnDescartar").style.display = "none";
		document.getElementById("btnSave").style.display = "none";
		document.getElementById("btnConf").style.display = "none";
		document.getElementById("btnNext").style.display = "none";
	} else {
		document.getElementById("btnBack").style.display = "none";
	}
	
	if (tarea == "SELECCIONAR_TRAMITE"){
		showFrmMail(); 
		//hideFrmMail();
	}
		
	if (tarea == "RETOMAR_TRAMITE"){
		hideFrmMail();
	}

	ponerNombrBotones();
	
	//----------------		
	//PONER ALT EN LA IMAGENES DEL CAPTCHA

	var x = document.getElementsByClassName("reloadCaptcha");
	if (x != null) {
		var i;
		for (i = 0; i < x.length; i++) {
			x[i].alt = "Recargar captcha";
		}
	}
	
	var x = document.getElementsByClassName("audioCaptcha");
	if (x != null) {
		var i;
		for (i = 0; i < x.length; i++) {
			x[i].alt = "Audio captcha";
		}
	}
	
	var x = document.getElementsByClassName("captcha-container");
	if (x != null) {
		var i;
		for (i = 0; i < x.length; i++) {			
			x[i].children[0].alt = "Captcha";							
		}
	}
	
	var x = document.getElementsByClassName("captcha_input");
	if (x != null) {
		var i;
		for (i = 0; i < x.length; i++) {			
			x[i].children[0].children[0].children[2].title = "Código de verificación"; 	
		}
	}
/*	
	var x = document.getElementsByClassName("LBL_TITULO");
	if (x != null) {
		var i;
		for (i = 0; i < x.length; i++) {
			var aClassName = "hide-read";
			var who = new Element("caption", {'class': aClassName, tabIndex: '', });
			who.innerText = "&nbsp;";			
			var pa = x[i].parentNode.parentNode.parentNode;						 
			if(pa.firstChild) pa.insertBefore(who,pa.firstChild);
			else pa.appendChild(who);
		}
	}
	
	debugger;
	var x = document.getElementById("tblE_1361");
	if (x != null) {	
		var aClassName = "hide-read";
		var who = new Element("caption", {'class': aClassName, tabIndex: '', });
		who.innerText = "&nbsp;";		
		var pa = x;					 
		if(pa.firstChild) pa.insertBefore(who,pa.firstChild);
		else pa.appendChild(who);		
	}
		
	debugger;
	var x = document.getElementsByTagName("table");
	if (x != null) {
		var i;
		for (i = 0; i < x.length; i++) {			
			if (x[i].innerHTML.indexOf("caption")==-1){
				var aClassName = "hide-read";
				var who = new Element("caption", {'class': aClassName, tabIndex: '', });
				who.innerText = "&nbsp;";
				
				var pa = x[i];
							 
				if(pa.firstChild) pa.insertBefore(who,pa.firstChild);
				else pa.appendChild(who);
			}
		}
	}
	*/
	//---------------------------
	
	//--
	setInterval(loadMsgError, 2000);
	//--
}

function loadAttributes() {

	document.onkeypress = function(e) {
		
		var saltar = true;
		try{
			/*if (e.path[0].id == "btnSalir"){
				saltar = false;
			}
			if (e.path[0].id == "btnDescartar"){
				saltar = false;
			}
			if (e.path[0].id == "btnSave"){
				saltar = false;
			}
			if (e.path[0].id == "btnNext"){
				saltar = false;
			}
			if (e.path[0].id == "btnConf"){
				saltar = false;
			}		
			if (e.path[0].id == "btnLast"){
				saltar = false;
			}*/
			if (e.path[0].tagName == "SELECT"){
				saltar = false;
			}	
			if (e.path[0].tagName == "BUTTON"){
				saltar = false;
			}
		} catch (e) {
		}
		if (e.keyCode == 13) {
			if (saltar){
				return false;
			}
		}
	}

	loadTitle();

}

function showMsgConfirm(type, message, fncName){
	
	var aClassName = "dialog-box dialog-info";
	var newDiv = new Element("div", {'class': aClassName, tabIndex: ''});
	
	var w = ((window.innerWidth / 2) - 250)+ 'px';
	var h = ((window.innerHeight / 2) - 50) + 'px';
	
	newDiv.setStyle('width', '500px');
	newDiv.setStyle('height', '125px');
	newDiv.setStyle('position', 'fixed');
	//newDiv.setStyle('top', '300px');
	var altura = window.top.getScrollTop() + (window.top.innerHeight/2) - 60;
	var alturapx = altura +"px";
	console.log(alturapx);
	newDiv.setStyle('top', alturapx);
	newDiv.setStyle('left', w);
	
	newDiv.setStyle('zIndex', '9999');
	
	aClassName = "fancybox-close";
	var newDivCerrar = new Element("div", {'class': aClassName, tabIndex: ''});
	newDivCerrar.innerHTML = "<img title='Cerrar ventana' src='images/fancybox-custom-close.png' onclick='setFocoObj()'></img>"
	newDiv.appendChild(newDivCerrar);
	
	aClassName = "dialog-icon";
	var newDiv2 = new Element("div", {'class': aClassName, tabIndex: ''});
	
	aClassName = "icn icn-circle-" + type + "-lg";
	var newSpan = new Element("span", {'class': aClassName, tabIndex: ''});
	
	newDiv2.appendChild(newSpan);
	newDiv.appendChild(newDiv2);
	
	//var image = "<img src='images/icn-warning-lg.png'></img>"
	
	aClassName = "dialog-data";
	var newDiv3 = new Element("div", {'class': aClassName, tabIndex: ''});
	
	aClassName = "dialog-title";
	var newSpan2 = new Element("span", {'class': aClassName, tabIndex: ''});
	
	newSpan2.innerHTML = message;
	
	newDiv3.appendChild(newSpan2);
	newDiv.appendChild(newDiv3);
	
	aClassName = "";
	var newDiv4 = new Element("div", {'class': aClassName, tabIndex: ''});
	
	newDiv4.setStyle('position', 'relative');
	newDiv4.setStyle('top', '0px');
	newDiv4.setStyle('left', '200px');	
		
	var links = "<button id='boton-confirmar-msg' class='btn-lg btn-primario-modal' onclick='" + fncName + "()'>Confirmar</button>"; 
	//"<a class='fancybox-close'href='#' onclick='fncRemoveMsg()'>No</a>";
	
	aClassName = "fancybox-close";
	var newA = new Element("a", {'class': aClassName, tabIndex: ''});
	newDiv.appendChild(newA);
	
	if (fncName!=""){
		newDiv4.innerHTML = links;
	}
	 
	newDiv.appendChild(newDiv4);
			
	document.getElementById('tabla-msg-confirm').appendChild(newDiv);	
	document.getElementById('tabla-msg-confirm-block').style.display = "block";
//	document.getElementsByClassName
	
//	newDiv.focus();
//	window.location.
}

function modalMsgError(type, message, fncName) {

	SYS_PANELS.closeAll();
	
	var aClassName = "dialog-box dialog-info";
	var newDiv = new Element("div", {'class' : aClassName,tabIndex : ''});

	var w = ((window.innerWidth / 2) - 250) + 'px';
	var h = ((window.innerHeight / 2) - 50) + 'px';

	newDiv.setStyle('width', '500px');
	//newDiv.setStyle('height', '125px');
	newDiv.setStyle('position', 'fixed');
	newDiv.setStyle('top', '300px');
	//var altura = window.top.getScrollTop() + (window.top.innerHeight/2);
	//var alturapx = altura +"px";
	//newDiv.setStyle('top', alturapx);
	newDiv.setStyle('left', w);

	newDiv.setStyle('zIndex', '9999');
	//newDiv.focus();
	aClassName = "fancybox-close";
	var newDivCerrar = new Element("div", {	'class' : aClassName,tabIndex : ''});
	newDivCerrar.innerHTML = "<img title='Cerrar ventana' src='images/fancybox-custom-close.png' onclick='setFocoObj()'></img>"
	newDiv.appendChild(newDivCerrar);

	aClassName = "dialog-icon";
	var newDiv2 = new Element("div", {'class' : aClassName,	tabIndex : ''});

	aClassName = "icn icn-circle-" + type + "-lg";
	var newSpan = new Element("span", {	'class' : aClassName,tabIndex : ''});

	newDiv2.appendChild(newSpan);
	newDiv.appendChild(newDiv2);

	// var image = "<img src='images/icn-warning-lg.png'></img>"

	aClassName = "dialog-data";
	var newDiv3 = new Element("div", {'class' : aClassName,	tabIndex : ''});

	aClassName = "dialog-title";
	var newSpan2 = new Element("span", {'class' : aClassName,tabIndex : ''});

	newSpan2.innerHTML = message;

	newDiv3.appendChild(newSpan2);
	newDiv.appendChild(newDiv3);

	aClassName = "";
	var newDiv4 = new Element("div", {'class' : aClassName,	tabIndex : ''});

	newDiv4.setStyle('position', 'relative');
	newDiv4.setStyle('top', '0px');
	newDiv4.setStyle('left', '200px');

	aClassName = "fancybox-close";
	var newA = new Element("a", {'class' : aClassName,tabIndex : ''});
	newDiv.appendChild(newA);

	//var links = "<button class='btn-lg btn-primario-modal' onclick='" + fncName	+ "()'>Confirmar</button>";
	// "<a class='fancybox-close'href='#' onclick='fncRemoveMsg()'>No</a>";
	//if (fncName != "") {
	//	newDiv4.innerHTML = links;
	//}

	//newDiv.appendChild(newDiv4);

	document.getElementById('tabla-msg-confirm').appendChild(newDiv);
	document.getElementById('tabla-msg-confirm-block').style.display = "block";

	window.location.href = '#';
}
	
	
function descartarTramite() {	
	showMsgConfirm("warning", "¿Confirma la cancelación del trámite?", "fncDescartarTramite");
}

function fncDescartarTramite() {
	ApiaFunctions.getForm("TRM_TITULO").getField("DESCARTAR_TRAMITE").fireClickEvent();	
}

function fncRemoveMsg() {
	var tablaElementos = document.getElementById('tabla-msg-confirm');
	
	while (tablaElementos.firstChild) {
		tablaElementos.removeChild(tablaElementos.firstChild);
	}
	
	document.getElementById('tabla-msg-confirm-block').style.display = "none";
			
	return false;
}

function salirTramite() {
	showMsgConfirm("warning", "¿Confirma que desea salir del trámite?", "frmSalirTramite");	
}

function frmSalirTramite() {	
	window.top.location = CONTEXT + "/portal/redirectSLO.jsp?url="+URL_RETORNO + TAB_ID_REQUEST;
}

function fncSalir() {
	window.top.location = URL_RETORNO;	
}

/** Invocada por Apia* */
function customEndInitPage() {

	/*$$('input').set('autocapitalize', 'off');*/

	if (!$(window.parent.frameElement)) {
		return;
	}
	if (window.parent.location.href.contains("externalAccess/open.jsp")) {
		var scrollY = $(window.parent.frameElement).get('scrollTo');
		// if(!scrollY) {
		window.parent.parent.scrollTo(0, scrollY);
		// }

		var frmData = $('frmData');
		frmData.addEvent('submit', function(e) {
			if (window.preventScroll) {
				$(window.parent.frameElement).set('scrollTo', 0);
			} else {
				if (window.getScrollTop) {
					$(window.parent.frameElement).set('scrollTo',
							window.parent.parent.getScrollTop());
				} else {
					$(window.parent.frameElement).set('scrollTo',
							window.parent.parent.window.scrollY);
				}
			}
		});
	}
}

function fixFrameHeight() {

	// alert("fixFrameHeight - INICIO: " + limpiarErrorFnc);

	var new_height = $('frmData').getElement('div.dataContainer').getHeight();
	new_height += 30;
	if (window.MOBILE) {
		new_height += 60;
		// alert("window.MOBILE: " + new_height);
	}
	if (frameElement) {

		frameElement.setStyle('height', new_height);
		// $('paginaPortal').setStyle('height',new_height);
		$('paginaPortal').setStyle('overflow', 'hidden');
		$('paginaPortal').setStyle('height', new_height);
		// frameElement.style.height=new_height+90+'px'
		frameElement.style.height = new_height + 'px'
		// alert("frameElement: " + new_height);
		// this.document.body.style.height=frameElement.style.height;
	}
	if (parent.frameElement) {
		// if(Browser.ie) {
		new_height += 5;
		// }
		parent.frameElement.setStyle('height', new_height);
		// this.document.body.style.height=frameElement.style.height
	}

	ponerLinkEnListaDeErrores();

/*	
	try {
		if (objError != null) {

			var cantError = objError.childElementCount;
			cantError = (cantError - 1);

			var strError = objError.children[0].innerHTML;

			var msg = "";

			if (cantError == 1) {
				msg = "Hay <b>" + cantError + " error</b> en el formulario";
			} else {
				msg = "Hay <b>" + cantError + " errores</b> en el formulario";
			}

			objError.children[0].innerHTML = msg;
			objError.children[0].style.display = "";

			setaerErrorDosColumnas("numero_documento");
			setaerErrorDosColumnas("tipo_documento");
			setaerErrorDosColumnas("campoConAyuda");
			setaerErrorDosColumnas("primera_parte");
			setaerErrorDosColumnas("segunda_parte");
			
		}
	} catch (e) {
	}
*/	
	//loadMsgError();
}

function setaerErrorDosColumnas(nameClass) {
	debugger;
	var x = document.getElementsByClassName(nameClass);
	if (x != null) {
		var i;
		for (i = 0; i < x.length; i++) {
			// for (i = 0; i < 1; i++) {
			var oError2Col = x[i].parentNode;
			var tError = oError2Col.innerHTML;
			var n = tError.indexOf("fc-error");
			if (n > -1) {
				oError2Col.className = "error-col2";				
				oError2Col.childNodes[0].childNodes[0].style.border = "none";
				oError2Col.childNodes[1].childNodes[0].style.border = "none";
			}
		}
		addTrErrorAux(oError2Col);
	}
}

function limpiarErroresFnc() {
	
	showErrorFnc = true;
	contador = 0;
	
	var x = document.getElementsByClassName("fc-errorFnc");
	if (x != null) {
		var i;
		for (i = 0; i < x.length; i++) {
			var oErrorFnc = x[i];
			
			var objTR = oErrorFnc.parentNode.parentNode;
			var objTable = oErrorFnc.parentNode.parentNode.parentNode;			
			objTable.removeChild(objTR);
			/*
			oErrorFnc.innerHTML = "";
			oErrorFnc.className = "";
			*/
		}
	}

	removeClass("error-col2");
	removeClass("error-col2-f1");
	removeClass("error-col2-f2");	
}

function showMsgError(par_frm, par_atr, par_msg, element) {
	try {	
		limpiarErroresFnc();
		
		if (element){
			field = element;
		} else {
			var form = ApiaFunctions.getForm(par_frm);
			var field = null;
			if (form!=null){
				field = form.getFieldTel(par_atr);
			}
		}
		
		if (field!=null){
			var eleErr = document.getElementById(field);			
							
			eleErr.classList.remove("fc-field-error");
			
			if (eleErr.childNodes[1]!=null){
				eleErr.childNodes[1].innerHTML = "";
			}
			
			var tag = eleErr.innerHTML;
			eleErr = eleErr.parentNode;
	
			par_msg = "<p>" + par_msg + "</p>";
			
			var tError = eleErr.innerHTML;
			var n = tError.indexOf("fc-errorFnc");
			
			if (n == -1) {
				
				var obj = new Element('div', {
					'class' : 'fc-errorFnc',
					'html' : par_msg
				});

				var objTR = new Element('TR', {
					'class' : 'error-col2'
				});
				var objTD = new Element('TD', {
					'colspan' : '4'
				});

				objTD.appendChild(obj);
				objTR.appendChild(objTD);

				eleErr = eleErr.parentNode;
				eleErr = eleErr.parentNode;
				
				var i=0;
				while (i < eleErr.childNodes.length){
					if (eleErr.childNodes[i].innerHTML.indexOf(tag)!=-1){
						eleErr.insertBefore(objTR, eleErr.childNodes[i].nextSibling);
						 break;
					}
					i = i+1;
				}
				
				eleErr.childNodes[i].addClass("error-col2");
				eleErr.childNodes[i].addClass("error-col2-f1");
				
				objTR.addClass("error-col2-f2");


			}else{
			}		
			
			var o = document.getElementById(field);				
			setFocus(o);
		}
	} catch (e) {
	}
return false;
}


function showMsgError2(par_frm, par_atr, par_msg, par_radio) {
	try {
		limpiarErroresFnc();

		var form = ApiaFunctions.getForm(par_frm);
		var field = null;
		if (form != null) {
			field = form.getFieldTel(par_atr);
		}


		if (field != null) {
			var eleErr = document.getElementById(field);

			eleErr.classList.remove("fc-field-error");


			if (par_radio != "true") {
				if (eleErr.childNodes[1] != null) {
					eleErr.childNodes[1].innerHTML = "";
				}
			}

			var tag = eleErr.innerHTML;
			eleErr = eleErr.parentNode;

			par_msg = "<p>" + par_msg + "</p>";

			var tError = eleErr.innerHTML;
			var n = tError.indexOf("fc-errorFnc");

			if (n == -1) {

				var obj = new Element('div', {
					'class' : 'fc-errorFnc',
					'html' : par_msg
				});

				var objTR = new Element('TR', {
					'class' : 'error-col2'
				});
				var objTD = new Element('TD', {
					'colspan' : '4'
				});

				objTD.appendChild(obj);
				objTR.appendChild(objTD);


				eleErr = eleErr.parentNode;
				eleErr = eleErr.parentNode;

				var i = 0;
				while (i < 10) {
					if (eleErr.childNodes[i].innerHTML.indexOf(tag) != -1) {
						eleErr.insertBefore(objTR,
								eleErr.childNodes[i].nextSibling);
						break;
					}
					i = i + 1;
				}

				eleErr.childNodes[i].addClass("error-col2");
				eleErr.childNodes[i].addClass("error-col2-f1");

				objTR.addClass("error-col2-f2");

				/*
				 * //eleErr.appendChild(obj); /* eleErr = eleErr.parentNode;
				 * 
				 * eleErr.className = "error-col2"; if
				 * ((eleErr.childNodes[0]!=null) &&
				 * (eleErr.childNodes[0].childNodes[0]!=null)){
				 * eleErr.childNodes[0].childNodes[0].style.border = "none"; }
				 * if ((eleErr.childNodes[1]!=null) &&
				 * (eleErr.childNodes[1].childNodes[0]!=null)){
				 * eleErr.childNodes[1].childNodes[0].style.border = "none"; }
				 * 
				 * addTrErrorAux(eleErr);
				 */
			} else {
				/*
				 * if ((eleErr.childNodes[0]!=null) &&
				 * (eleErr.childNodes[0].childNodes[0]!=null)){
				 * eleErr.childNodes[0].childNodes[0].innerHTML = par_msg; }
				 */
				/*
				 * if ((eleErr.childNodes[1]!=null) &&
				 * (eleErr.childNodes[1].childNodes[0]!=null)){
				 * eleErr.childNodes[1].childNodes[0].innerHTML = par_msg; }
				 */
			}

			var o = document.getElementById(field);
			setFocus(o);
		}
	} catch (e) {
	}
	return false;
}








function hideMsgError(par_frm, par_atr, par_msg) {
	try {	
		
		limpiarErroresFnc();
		
		var form = ApiaFunctions.getForm(par_frm);
		var field = null;
		if (form!=null){
			field = form.getFieldTel(par_atr);
		}
		
		if (field!=null){
			
			/*
			eleErr.remoClasse();
			
			
			var x = document.getElementsByClassName(className);
			if (x != null) {
				var i = 0;
				var max = x.length;
				while (i < max) {
					x = document.getElementsByClassName(className);
					var oErrorFnc = x[0];
					alert(oErrorFnc.parentNode.parentNode.nodeName + " - " + oErrorFnc.parentNode.parentNode.innerHTML);
					oErrorFnc.classList.remove(className);
					i++;		
				}
			}
			
			
			
			/*
			eleErr.parentNode.parentNode.removeClass("error-col2");
			eleErr.parentNode.parentNode.removeClass("error-col2-f1");
			
			if(eleErr.parentNode.childNodes[1].innerHTML!=""){
				eleErr.parentNode.childNodes[1].remove();
			}
					
			var nTR = eleErr.parentNode.parentNode;
			
			if (nTR.hasClass("error-col2")){
				nTR.removeClass("error-col2");				
			}
			*/					
		}
	
	} catch (e) {
	}	
}

function addTrErrorAux(eleErr) {
	var oTabla = eleErr.parentNode;
	var y = oTabla.childNodes;
	var tError = oTabla.innerHTML;
	var n = tError.indexOf("fc-errorAux");
	if (n == -1) {
		for (i = 0; i < y.length; i++) {
			// for (i = 0; i < 1; i++) {
			var tr = oTabla.childNodes[i];
			if(tr.className=="error-col2"){
				var trN = oTabla.insertRow(i+1);
				var obj = new Element('div', {
					'html' : '<p></p>'
				});
				var td = new Element('td', {
					'class' : 'fc-errorAux'
				});
				td.appendChild(obj);
				trN.appendChild(td);
			}
		}
	}
}

function loadMsgError() {
	
if (contador < 10){
	
	//getHora();
	//console.info("INICIO - loadMsgError() - showErrorFnc: " + showErrorFnc);
	
	//if (showErrorFnc){
		
		// Creamos el control XMLHttpRequest segun el navegador en el que estemos
		var MSIE = window.navigator.appVersion.indexOf("MSIE") >= 0;
		if (!MSIE) {
			ajax = new XMLHttpRequest(); // No Internet Explorer
			ajax.onload = function() {
				funcionCallBackLoadMsgError();
			}
		} else {
			ajax = new ActiveXObject("Microsoft.XMLHTTP"); // Internet Explorer
			// Almacenamos en el control al funcion que se invocara cuando la peticion cambie de estado
			ajax.onreadystatechange = funcionCallBackLoadMsgError;
		}
		
		contador = contador + 1;		
		//console.info("contador: " + contador);		
		if (contador > 10) {
			//showErrorFnc = false;
		}
		
		// Enviamos la peticion
		var URL = CONTEXT + "/portal/cargarMsgError.jsp?a=1" + TAB_ID_REQUEST;
	
		// alert(URL);
		ajax.open("GET", URL, false);
		ajax.send("");
				
	//}	
	
	//console.info("FIN - loadMsgError() - showErrorFnc: " + showErrorFnc);
}
}

function funcionCallBackLoadMsgError() {
	
	//console.info("INICIO - funcionCallBackLoadMsgError() - showErrorFnc: " + showErrorFnc);
	
	
	// Escribimos el resultado en la pagina HTML mediante DHTML
	var result = ajax.responseText;
	// alert(result);
	
	//console.info("result: " + result);
	
	if (result.indexOf("OK") != -1) {
		var arr = result.split(";");
		showMsgError(arr[1], arr[2], arr[3]);
	}
	
	//console.info("FIN - funcionCallBackLoadMsgError() - showErrorFnc: " + showErrorFnc);
}

function showFrmMail(){
	
	tarea = ApiaFunctions.getCurrentTaskName();
	
	if (tarea == "RETOMAR_TRAMITE"){
				
		var objFrm = null;
		var objFrm2 = null;
		var x = document.getElementsByClassName("RET_TRM_DATOS_RETOMA");
		if (x != null) {
			var i;
			for (i = 0; i < x.length; i++) {
				objFrm = x[i];			
			}
			
			if (objFrm!=null){
				objFrm.style.visibility = "visible";
			}
		}
		
		objFrm = null;
		objFrm2 = null;
		x = document.getElementsByClassName("RET_TRM_DATOS_RETOMA_2");
		if (x != null) {
			var i;
			for (i = 0; i < x.length; i++) {
				objFrm = x[i];			
			}
			
			if (objFrm!=null){
				objFrm.style.visibility = "visible";
			}
		}
		
		//document.getElementById("btnConf").style.visibility = "visible";
		document.getElementById("titleTramite").style.visibility = "visible";
	}
		
	
	if (tarea == "SELECCIONAR_TRAMITE"){
	
		var objFrm = null;
		var objFrm2 = null;
		var x = document.getElementsByClassName("TRM_FRM_EMAIL_USUARIO");
		if (x != null) {
			var i;
			for (i = 0; i < x.length; i++) {
				objFrm = x[i];			
			}
		}
		
		x = document.getElementsByClassName("TRM_FRM_EMAIL_USUARIO_CON_CAPTCHA");	
		if (x != null) {
			var i;
			for (i = 0; i < x.length; i++) {
				objFrm2 = x[i];			
			}
		}
		var myForm = ApiaFunctions.getForm("TRM_TITULO");
		var field = myForm.getField('TRM_COD_TRAMITE_STR');
		var codTramite = field.getValue();
	
		var field = myForm.getField('TRM_VISIBILIDAD_STR');
		var visibilidad = field.getValue();
	
		var modoAut= myForm.getField("TRM_MODO_AUTENTICACION_STR").getValue();
	
		var mostrar = true;
		if (visibilidad != '1') {
		  if (CURRENT_USER_LOGIN == 'guest' ) {	    
			  mostrar = false;
		  }    
		}
		
		if (mostrar){
			if (objFrm!=null){
				objFrm.style.visibility = "visible";
			}
			if (objFrm2!=null){
				objFrm2.style.visibility = "visible";
			}
			
			document.getElementById("btnConf").style.visibility = "visible";
			document.getElementById("titleTramite").style.visibility = "visible";
		} else {
			if (objFrm!=null){
				objFrm.style.visibility = "hidden";
				document.getElementById("btnConf").style.visibility = "hidden";
				document.getElementById("btnNext").style.visibility = "hidden";
			}
			if (objFrm2!=null){
				objFrm2.style.visibility = "hidden";
				document.getElementById("btnConf").style.visibility = "hidden";
				document.getElementById("btnNext").style.visibility = "hidden";
			}
		}
	}
}

function hideFrmMail(){
	
	var title = document.getElementById("titleTramite").innerHTML;
	
	var obtFrm = null;
	var x = document.getElementsByClassName("RET_TRM_DATOS_RETOMA_2");
	if (x != null) {
		var i;
		for (i = 0; i < x.length; i++) {
			objFrm = x[i];
			objFrm.style.visibility = "hidden";			
		}
	}
		
	var eMail = getUsrEmail();
		
	if (eMail != ""){	
		var obtFrm = null;
		var x = document.getElementsByClassName("TRM_FRM_EMAIL_USUARIO");
		if (x != null) {
			var i;
			for (i = 0; i < x.length; i++) {
				objFrm = x[i];
				objFrm.style.visibility = "hidden";			
			}
		}
		var obtFrm = null;
		var x = document.getElementsByClassName("TRM_FRM_EMAIL_USUARIO_CON_CAPTCHA");
		if (x != null) {
			var i;
			for (i = 0; i < x.length; i++) {
				objFrm = x[i];
				objFrm.style.visibility = "hidden";			
			}
		}

		document.getElementById("btnConf").style.visibility = "hidden";
		document.getElementById("titleTramite").style.visibility = "hidden";
	}	
}

function setFocus(o){
	
	try{
		for(var i=0; i<10; i++){
			if (o.childNodes[i]!=null){				
				if (o.childNodes[i].tagName == "INPUT"){
					o.childNodes[i].focus();
					return;
				}
			}
		}
		
		for(var i=0; i<10; i++){
			if (o.childNodes[i]!=null){
				for(var j=0; j<10; j++){
					if (o.childNodes[i].childNodes[j]!=null){						
						if (o.childNodes[i].childNodes[j].tagName == "INPUT"){
							o.childNodes[i].childNodes[j].focus();
							return;
						}
					}
				}
			}
		}
	/*
	alert(o.childNodes[0].tagName);
	alert(o.childNodes[1].tagName);
	alert(o.childNodes[1].childNodes[0].tagName);
	alert(o.childNodes[1].childNodes[1].tagName);	
	document.getElementById(field).childNodes[1].childNodes[0].focus();
	*/
	} catch (e) {
	}

}


function getHora() {
    var d = new Date();    
    var h = addZero(d.getHours());
    var m = addZero(d.getMinutes());
    var s = addZero(d.getSeconds());
    //console.info("Hora: " + h + ":" + m + ":" + s);
}

function addZero(i) {
    if (i < 10) {
        i = "0" + i;
    }
    return i;
}


function getUsrEmail(){
	var eMail = "";
	try{
		eMail = ApiaFunctions.getForm("TRM_TITULO").getField("TRM_EMAIL_USUARIO_STR").getValue();
	} catch (e) {
	}
	
	return eMail;
}


function ajustarAnchoColumna(){	
	try{
		var x = document.getElementsByClassName("css-file-input");
		if (x != null) {
			var i;
			for (i = 0; i < x.length; i++) {
				
				var el = x[i];
				
				el = el.parentNode;
				el = el.parentNode;
				el = el.parentNode;
				el = el.parentNode;
				el = el.parentNode;
				
				//Acciones
				var el1 = el.children[0].children[0].children[0].children[0].children[0];
							
				el1.style.width = "100px";
				
				//adjutnos
				var el2 = el.children[0].children[0].children[0].children[0].children[1];
							
				el2.style.width = "500px";
				
			}			
		}
		
		var x = document.getElementsByClassName("docData");
		if (x != null) {
			var i;
			for (i = 0; i < x.length; i++) {
				var el = x[i];
				if (el.innerHTML != ""){
					var l = el.innerHTML.length;	
					var m = (l * 6);					
					el.parentNode.children[5].style.marginLeft = m;
				}
			}
		}
		
	} catch (e) {
	}
}

function removeClass(className){
	var x = document.getElementsByClassName(className);
	if (x != null) {
		var i = 0;
		var max = x.length;
		while (i < max) {
			x = document.getElementsByClassName(className);
			var oErrorFnc = x[0];
			oErrorFnc.classList.remove(className);
			i++;		
		}
	}
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


function showDivAyuda(envId, nameCampo, nameForm) {

	//var x = parseInt(event.clientX - 0);     // Get the horizontal coordinate
	//var y = parseInt(event.clientY - 30); 
	
	
	var xmlHttp = getXmlHttp();
	xmlHttp.onreadystatechange = function() {
		if (xmlHttp.readyState==4 && xmlHttp.status==200){
			var htmlCode = xmlHttp.responseText;
			
			var div_ayu = document.getElementById("div_ayuda");
			div_ayu.style.top = posY-30 +"px";//y;
			div_ayu.style.left = posX +"px";//x;
			
			div_ayu.style.display = "block";
			
			div_ayu.innerHTML = htmlCode.trim();
			setTimeout(function(){hiddeDivAyuda();}, 5000);
			
		}
	};

	URL = URL_APP + "/portal/getAyuda.jsp?att=" + nameCampo;
	
	xmlHttp.open("GET" , URL , false);
	xmlHttp.send(null);
		
}

function hiddeDivAyuda(){
	var div_ayu = document.getElementById("div_ayuda");
	div_ayu.style.display = "none";
}



function setFocoObj(){
	fncRemoveMsg();	
	//document.getElementById("btnSalir").focus();
	//setTimeout(function(){objVolverFoco.setFocus();}, 3000);	
	//objVolverFoco.focus();	
	//objVolverFoco.setFocus();	
	try{
		objVolverFoco.getAllFields(0)[0].setFocus();
	}catch(err){		
	}	
}

function ponerNombrBotones(){
	
	tarea = ApiaFunctions.getCurrentTaskName();
	var step = 0;
	if (!isMonitor) {
		step = ApiaFunctions.getCurrentStep();
	}

	var form = ApiaFunctions.getForm("TRM_TITULO");
	var firma =  "";
	var pago =  "";
	var agenda = "";
	
	if(form != null){
		firma = form.getField("TRM_REQUIERE_FIRMA_NUM").getValue();
		pago = form.getField("TRM_PAGO_REQUIERE_NUM").getValue();
		agenda = form.getField("TRM_AGENDA_REQUIERE_NUM").getValue();
	}
		
	//--TITULO DE BOTONES
	if (tarea == "SELECCIONAR_TRAMITE" || tarea == "CARGA_DATOS_TRAMITE"){	
		
		if (step == "10") {		
			if (firma == "2" || pago == "2" || agenda == "2"){
				document.getElementById("btnNext").innerHTML = "Continuar al paso siguiente &gt;&gt;";
				document.getElementById("btnConf").innerHTML = "Continuar al paso siguiente &gt;&gt;";
			}else{
				document.getElementById("btnNext").innerHTML = "Finalizar &gt;&gt;";
				document.getElementById("btnConf").innerHTML = "Finalizar &gt;&gt;";
				
			}
		} else {
			document.getElementById("btnNext").innerHTML = "Continuar al paso siguiente &gt;&gt;";
			document.getElementById("btnConf").innerHTML = "Continuar al paso siguiente &gt;&gt;";
		}
	}

	if (tarea == "AGENDAR_TRAMITE"){	
		document.getElementById("btnNext").innerHTML = "Continuar al paso siguiente &gt;&gt;";
		document.getElementById("btnConf").innerHTML = "Continuar al paso siguiente &gt;&gt;";		
	}
	
	if (tarea == "FIRMA"){
		
		//if (firma == "1" || pago == "1" || agenda == "1"){
		document.getElementById("btnNext").innerHTML = "Continuar al paso siguiente &gt;&gt;";
		document.getElementById("btnConf").innerHTML = "Continuar al paso siguiente &gt;&gt;";		
	}
	
	if (tarea == "SELECCIONAR_MEDIO_PAGO"){
		//if (firma == "1" || pago == "1" || agenda == "1"){
		//document.getElementById("btnNext").innerHTML = "Continuar al paso siguiente &gt;&gt;";
		//document.getElementById("btnConf").innerHTML = "Continuar al paso siguiente &gt;&gt;";		
	}
	
	//--TITULO DE BOTONES
	if (tarea == "ENCUESTA" || tarea == "RESULTADO"){
		document.getElementById("btnNext").innerHTML = "Finalizar &gt;&gt;";
		document.getElementById("btnConf").innerHTML = "Finalizar &gt;&gt;";				
	}
		
}
/*
TRM_REQUIERE_FIRMA_NUM - 1 -NO
TRM_REQUIERE_FIRMA_NUM - 2 -SI

TRM_PAGO_REQUIERE_NUM - 1 -NO
TRM_PAGO_REQUIERE_NUM - 2 -SI

TRM_AGENDA_REQUIERE_NUM - 1 -NO
TRM_AGENDA_REQUIERE_NUM - 2 -SI
*/

function ponerLinkEnListaDeErrores(){
	try {
		if ((objError != null) && (indexError!=0)) {
			debugger;
			maxError = indexError;
			indexError = 0;
						
			var cantError = objError.childElementCount;
			cantError = (cantError - 1);

			var strError = objError.children[0].innerHTML;

			var msg = "";

			if (cantError == 1) {
				msg = "Hay <b>" + cantError + " error</b> en el formulario";
			} else {
				msg = "Hay <b>" + cantError + " errores</b> en el formulario";
			}
			
			if (cantError == 0) {
				
			}
			document.getElementById('errorlist').style.display = "block";

			objError.children[0].innerHTML = msg;
			objError.children[0].style.display = "";
			
			//--
			
			var cant = objError.childElementCount;
			for (var i=1;i<cant;i++){
				var linea = objError.children[i].innerHTML;
								
				if (linea.indexOf("href") == -1){					
									
					var txt1 = "rightErrorSpan\">";
					var txt2 = ". </div>";
					
					var lIni = linea.indexOf(txt1) + txt1.length;
					var lFin = linea.indexOf(txt2) + 1;
					
					var lineaIni = linea.substring(0,lIni);
					var lineaInter = linea.substring(lIni, lFin);
					
					var txtLink = "<a id='myLink" + i  + "' href='#' onclick='setFocoError(" + i + ");return false;'>" + lineaInter + "</a>";
										
					//linea = linea.replace(". </div>", ". " + txtLink + "</div>");
					linea = lineaIni + txtLink + " </div>";   
					objError.children[i].innerHTML = linea;
					objError.children[i].style.height = "30px";
				}
				
//				try{
//					debugger;
//				    var z = document.getElementsByClassName("err-num-" + i);
//				    if (z != null){
//				    	for(var j=1; j < z.length; j++){
//				    		z[j].removeClass("err-num-" + i);
//				    	}
//				    }
//					
//				} catch (e) {
//				}
			}
			
			hideDivError();
						
			//--

			/*-------------------------------------------*/
			debugger;
			setaerErrorDosColumnas("numero_documento");
			setaerErrorDosColumnas("tipo_documento");
			setaerErrorDosColumnas("campoConAyuda");
			setaerErrorDosColumnas("primera_parte");
			setaerErrorDosColumnas("segunda_parte");
			/*-------------------------------------------*/
			
		}else{
			
			/*
			var cE = getCantErrores();
			if (ce == 0){
				if (maxError>1){
					hideDivError();
				}
			}
			*/
		}
		
	} catch (e) {
	}
}

function hiddeDivError(){
	try {
		var div_err = document.getElementById("box-error");
		div_err.style.display = "none";
	} catch (error) {
	}
}

function showPreviousError(){
debugger;
	try {
		
		debugger;
		var x = document.getElementsByClassName("fc-field-error");		
		if (x != null) {			
			if (x.length != 0){
				var nroError = 1;
				if (errorActual!=1){
					nroError = errorActual - 1;
				}else{
					nroError = maxError;
				}
				
				setFocoError(nroError);
			}else{
				hideDivError();				
			}			
		}			
	} catch (error) {
	}
}

function showNextError(){
debugger;	
	try {
		var cantErr = getCantErrores();		
		if (cantErr != 0) {
			var nroError = 1;
			maxError = cantErr;
						
			if (errorActual!=maxError){
				nroError = errorActual + 1;
			}else{
				nroError = 1;					
			}
			setFocoError(nroError);					
		}else{
			hideDivError();
		}		
	} catch (error) {
	}
}

function showDivError(objErrorFoco, nroError, cordX, cordY){

	try {
		
		if (maxError>1){
			debugger;
				
			var txtDivError = "<div class=\"box-error\">";
			txtDivError = txtDivError + "<span class=\"box-error-title\">" + "Error " + nroError + " de " + maxError + "</span>";
			txtDivError = txtDivError + "<ul>"
			txtDivError = txtDivError + "<li><a style=\"cursor: pointer;\" class=\"floatIzq\" href=\"#\" onclick=\"showPreviousError();return false;\">&lt;&lt; Anterior</a></li>";
			txtDivError = txtDivError + "<li><a style=\"cursor: pointer;\" class=\"floatDer\" href=\"#\" onclick=\"showNextError();return false;\">Siguiente &gt;&gt;</a></li>";
			txtDivError = txtDivError + "</ul>";
			txtDivError = txtDivError + "</div>";
		
			var newDiv = document.getElementById('div-nav-error');			
			newDiv.innerHTML = txtDivError;
			
			newDiv.setStyle('position', 'absolute');
			newDiv.setStyle('left', cordX + 'px');
			newDiv.setStyle('top', cordY + 'px');
					
			newDiv.style.zIndex = 1000;
			newDiv.style.display = "block";
			
			debugger;
			newDiv.scrollIntoView();	
			var cy = top.scrollY - 40;
			window.parent.parent.scrollTo(0, cy);
			
			errorActual = nroError;
		}else{			
			hideDivError();		
		}
		
	} catch (error) {
	}			

}

function hideDivError(){
	try {
		var newDiv = document.getElementById('div-nav-error');			
		newDiv.innerHTML = "";
//		listarErroresArriba();
	} catch (error) {
	}			
}

function listarErroresArriba(){
/*	
//Esta clase hay que revisala - no funciona bien.
	debugger;
	removeErrors();
	var x = document.getElementsByClassName("fc-field-error");
	var title = "";
	var meserror = "";
	var index=0;
	var i;
	var j;
	var y;
	var nomClass;
	
	var html = ""; 
	if (x != null) {		
		for (i = 0; i < x.length; i++) {
			
			if (isError(x[i])){
						
				var title = "";
				var meserror = "";
				try{
					title = x[i].children[0].title;
					meserror = x[i].children[1].innerHTML;
				} catch (error) {
				}
				
				var entrar = "no";
				debugger;
				
				if (title.trim()!="" && meserror.trim()!=""){
					if (meserror.indexOf("<input type")!=-1){
						meserror = x[i].children[x[i].childElementCount - 2].innerHTML;
					}
					entrar = "si";
				}else{
					
					try{
						if (title==""){
							title = x[i].children[0].children[0].textContent;
						}
						if (meserror==""){
							meserror = x[i].children[1].children[0].innerHTML;
						}
					} catch (error) {
					}
					
					if (title.trim()!="" && meserror.trim()!=""){
						entrar = "si";
					}else{
						
						if (x[i].innerHTML.indexOf("datePicker")!=-1){
							debugger;													
							meserror = "Este campo es requerido.";
							if (title.trim()!="" && meserror.trim()!=""){
								entrar = "si";
							}
						}
						
						if (x[i].innerHTML.indexOf("asLabelFileinput")!=-1){							
							y =  x[i].children[1];
							title = x[i].children[0].innerText;
							meserror = "Este campo es requerido.";
							if (title.trim()!="" && meserror.trim()!=""){
								entrar = "si";
							}
						}
						
						if (entrar!="si"){
							try{
								if (title==""){
									title = x[i].parentNode.children[0].textContent;						
									meserror = x[i].parentNode.parentNode.children[1].children[0].innerHTML;
								}
							} catch (error) {
							}
						}
						if (title.trim()!="" && meserror.trim()!=""){
							entrar = "si";
						}
						
						if(x[i].parentNode.hasClass("gridMinWidth")){
							title = x[i].title;						
							meserror = "Este campo es requerido.";
							entrar = "si";							
						}
					}
					
					if (entrar!="si"){
						if (x[i].children[0].children[1].tagName == "SELECT"){
							title = x[i].children[0].children[0].innerText;
							meserror = "Por favor, seleccione un valor.";
							entrar = "si";
						}
						if (x[i].children[0].children[1].tagName == "INPUT"){
							title = x[i].children[0].children[0].innerText;
							meserror = "Este campo es requerido.";
							entrar = "si";
						}
					}
				}
				
				if (entrar=="si"){
							
					title=title.replace(":", "");
									
					meserror=meserror.replace("<p>", "");
					meserror=meserror.replace("</p>", "");
					
					//alert(index + " - " + title + ": " + meserror);
					debugger;					
					if (isError(x[i])){
						
						index=index+1;
						
						if (x[i].innerHTML.indexOf("datePicker")!=-1){
							y = x[i].children[1];
						}else{
							
							if(x[i].parentNode.hasClass("gridMinWidth")){
								y =  x[i];
							}else{
							
								if (x[i].children[0].nodeName=="SPAN"){								
									if (x[i].children[0].hasClass("asLabelFileinput")){
										y =  x[i].children[1];
									}else{
										y =  x[i].children[1].children[0];
									}
								}else{
									if (x[i].children[0].hasClass("asLabelFileinput")){
										y =  x[i].children[1];
									}else{
										y = x[i].children[0].children[1];
									}		
								}
							}
							
						}
						
						y.addClass("err-num-" + index);						
						html = html + title + "##" + meserror + "**";
						
					}else{
						//alert("descarto: " + x[i] + " - " + x[i].nodeName);
					}
				}else{
					//alert("error: " + x[i] + " - " + x[i].innerHTML);
				}
			}
			debugger;
		}				
	}
	
	maxError = index;
	if (maxError!=0){
		debugger;
		var oTitulo;	
		if (index==1){
			oTitulo = new Element('div', {'id' : 'errorlistTitle'}).set('html',"Hay <b>" + index + " error</b> en el formulario");
		}else{
			oTitulo = new Element('div', {'id' : 'errorlistTitle'}).set('html',"Hay <b>" + index + " errores</b> en el formulario");
		}
					
		x = document.getElementsByClassName("fc-error");
		x[0].innerHTML = "";
		x[0].appendChild(oTitulo);
		
		var arrMsg = html.split("**");
		for(var i =0; i < arrMsg.length; i++){
		    
		    if(arrMsg[i]!=""){	    	
		    	var campo = arrMsg[i].split("##")[0];
		    	var error = "<a id=\"myLink\" href=\"#\" onclick=\"setFocoError(" + (i + 1) + ");return false;\">" + arrMsg[i].split("##")[1] + "</a>";
		    	var oErr = new Element('p').set('html',"<div class='leftErrorSpan'>" + (i + 1) + ". " + campo  + ": </div> <div class='rightErrorSpan'>" + error + " </div>");
		    	x[0].appendChild(oErr);	    	
		    }
		    
		    /*
		    debugger;
		    try{
			    var z = document.getElementsByClassName("err-num-" + (i + 1));
			    if (z != null){
			    	for(var j=1; j < z.length; j++){
			    		z[j].removeClass("err-num-" + (i + 1));
			    	}
			    }
		    } catch (error) {
			}
			*/
/*	
		}
	}else{
		document.getElementById('errorlist').style.display = "none";
		//var newDiv = document.getElementById('errorlist');			
		//newDiv.innerHTML = "";
	}
	
	debugger;
	if (errorActual == maxError){
		errorActual = 1;		
	}
	
	
	if (maxError>1){
		if (errorActual>maxError){
			errorActual=maxError;
		}
		setFocoError(errorActual);
	}else{
		hideDivError();		
	}
	
	//setTimeout(corregirDivError, 10000);
	debugger;
*/	
}	

function corregirDivError(){
	try{
		debugger;		
		var x = document.getElementsByClassName("fc-field-error");	 
		if (x != null) {		
			for (i = 0; i < x.length; i++) {
				var cant = 0;
				y = x[i];
				while ((y.nodeName!="TR") || (cant > 10)){
					y = y.parentNode;
					cant = cant +1;
				}
				if ((y.nodeName=="TR")){
					if (!y.hasClass("error-col2")){
						y.addClass("error-col2");
					}
				}			
			}
		}
	} catch (error) {
	}
}

function corregirDivError(ob){
	try{
		debugger;			 
		if (ob != null) {		
			
			var cant = 0;				
			while ((ob.nodeName!="TR") || (cant > 10)){
				ob = ob.parentNode;
				cant = cant +1;
			}
			if ((ob.nodeName=="TR")){
				if (!ob.hasClass("error-col2")){
					ob.addClass("error-col2");
				}
			}			
			
		}
	} catch (error) {
	}
}

function showVideoAyuda(){
	var cx = (top.innerWidth / 5) * 3;		
	var newDiv = document.getElementById('div_video');							
	newDiv.setStyle('position', 'absolute');
	newDiv.setStyle('left', cx + 'px');
	newDiv.setStyle('top', '100px');				
		
	var aClassName = "fancybox-close-video";
	var newDivCerrar = new Element("div", {'class': aClassName, tabIndex: ''});
	newDivCerrar.innerHTML = "<img title='Cerrar ventana' src='images/fancybox-custom-close.png' onclick='closeVideoAyuda()'></img>"
	newDiv.appendChild(newDivCerrar);
	
	newDiv.style.zIndex = 1000;
	newDiv.style.display = "block";
	//newDiv.scrollIntoView();
	window.location = '#';
}

function closeVideoAyuda(){
	var newDiv = document.getElementById('div_video');								
	newDiv.style.display = "none";	
}

function getCantErrores(){
	debugger;
	var cant = 0;
	var x = document.getElementsByClassName("fc-field-error");
	for (i = 0; i < x.length; i++) {		
		if (isError(x[i])){
			cant = cant + 1;
		}				
	}
	return cant;
}

function isError(xErr){
	debugger;
	if ((xErr.nodeName=="DIV") && !(xErr.hasClass("document"))){
		if (xErr.hasClass("campo-error-perso")) return true;
	}else{
		if (((xErr.nodeName=="INPUT") || (xErr.nodeName=="SELECT")) && (xErr.hasClass("gridMinWidth"))){
			if (xErr.hasClass("campo-error-perso")) return true;
		}else{
			if (((xErr.nodeName=="INPUT") || (xErr.nodeName=="SELECT")) && (!xErr.hasClass("gridMinWidth"))){
				if (xErr.hasClass("campo-error-perso")) return true;
			}else{
				if ((xErr.nodeName=="TEXTAREA")){
					if (xErr.hasClass("campo-error-perso")) return true;
				}
			}
		}
	}				
	return false;
	
}

function removeErrors(){
	debugger;
	var x = document.getElementsByClassName("fc-field-error");
	for (i = 0; i < x.length; i++) {
		
		var y = document.getElementsByClassName("err-num-" + i);
		for (j = 0; j < y.length; j++) {			
			y[j].removeClass("err-num-" + i);					 	
		}
						 	
	}	
	
	var x = document.getElementsByClassName("campo-error-perso");
	for (i = 0; i < x.length; i++) {
		x[i].removeClass("campo-error-perso");					 									 	
	}
	
}

function removeErrorsFondo(){
	debugger;
	var x = document.getElementsByClassName("fc-field-error");
	for (i = 0; i < x.length; i++) {
		
		var y = document.getElementsByClassName("err-num-" + i);
		for (j = 0; j < y.length; j++) {			
			y[j].removeClass("err-num-" + i);					 	
		}
		debugger;		
		if (x[i].tagName == "DIV" && x[i].hasChildNodes()){
			y = x[i].children;
			
			if (y!=null){
				for (j = 0; j < y.length; j++) {
					if (y[j].hasClass("fc-error")){
						y[j].destroy();
					}
				}
			}
		}
		x[i].removeClass("fc-field-error");
	}	
}

function setFocoError(nroError) {
	debugger;
	try {		
		var errorClass = "err-num-" + nroError;
		
		var x = document.getElementsByClassName(errorClass);
		if (x != null) {
			var i;
			var objErrorFoco;
			objErrorFoco = x[0];			
			
			if (!objErrorFoco){
				errorActual = 1;
				nroError = 1;
				errorClass = "err-num-1";
				x = document.getElementsByClassName(errorClass);
				objErrorFoco = x[0];
			}
						
			if (objErrorFoco && objErrorFoco!=null){
				
				if (objErrorFoco.hasClass("datePicker")){
					
					if (objErrorFoco.parentElement.children[4]!=null){
						objErrorFoco.parentElement.children[4].scrollIntoView();
					}else{
						if (objErrorFoco.parentElement.children[2]!=null){
							objErrorFoco.parentElement.children[2].scrollIntoView();
						}
					}						
					var cx = (top.innerWidth / 5) * 3;
					cy = top.scrollY + 30;							
					setTimeout(showDivError(objErrorFoco, nroError, cx, cy), 2000);
				}else{					
					objErrorFoco.focus();				
					var cx = (top.innerWidth / 5) * 3;
					var cy = objErrorFoco.getPosition().y + 27;
					setTimeout(showDivError(objErrorFoco, nroError, cx, cy), 2000);
				}
							
			}
		}
	} catch (error) {
	}
}