var showErrorFnc = true;
var btnAction = "";
var contador = 0;

var frmCheckerDisplay = {
	addClassErrorToField : 1,
	errorsLocation : 3,
	listErrorsAtTop : true,
	// keepFocusOnError : 2,
	indicateErrors : 2,
	scrollToFirst : false
}

var addStepsName = true;

/*
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

	// setInterval(loadMsgError, 1000);
});
*/

String.prototype.replaceAll = function(str1, str2, ignore) {
	return this.replace(new RegExp(str1.replace(/([\/\,\!\\\^\$\{\}\[\]\(\)\.\*\+\?\|\<\>\-\&])/g, "\\$&"),(ignore ? "gi" : "g")), (typeof (str2) == "string") ? str2.replace(/\$/g, "$$$$") : str2);
}

function loadTitle() {

	ajustarAnchoColumna();

	var tarea = ApiaFunctions.getCurrentTaskName();

	var step = 0;

	if (!isMonitor) {
		step = ApiaFunctions.getCurrentStep();
	}

	var entro = false;
	var form = ApiaFunctions.getForm("TRM_TITULO");
	if (form != null) {
		var title = form.getField("TRM_NOMBRE_STR").getValue();
		var logo = CONTEXT + "/images/" + NOMBRE_LOGO;

		var t = "<table width='100%'><tr><td align='left' width='70%'><label id='titleTramite' for='trmInput' class='titleTramite'>"
				+ title
				+ "</label></td><td align='right' width='30%'><img src='"
				+ logo + "'></td></tr></table>";
		document.getElementById("titleTramite").innerHTML = t;

		try {
			top.document.title = title;
		} catch (e) {
		}

		if (window.CURRENT_PROCESS_NAME == undefined
				|| CURRENT_PROCESS_NAME == "TRAMITE_PORTAL"
				|| CURRENT_PROCESS_NAME == "COMUNICACIONES") {

			var w = window.innerWidth;
			var h = window.innerHeight;
			var wTotal = window.top.innerWidth;
			var porcent = parseInt((w * 100) / wTotal);
			var limite = parseInt("85");

			var anchoBtnLast = "0%";
			var anchoBtnSalir = "0%";
			var anhoBtnDescartar = "0%";
			var anchoBtnSave = "0%";

			if (tarea == "SELECCIONAR_TRAMITE") {
				document.getElementById("btnLast").style.display = "none";
				document.getElementById("btnSalir").style.display = "none";
				document.getElementById("btnDescartar").style.display = "none";
				document.getElementById("btnSave").style.display = "none";
				document.getElementById("btnNext").style.display = "none";
				document.getElementById("btnConf").innerHTML = "Continuar al paso siguiente &gt;&gt;";
			}

			if (tarea == "CARGA_DATOS_TRAMITE" || tarea == "RETOMA_CARGA_DATOS") {
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
			if (tarea == "FIRMA") {
				document.getElementById("btnLast").style.display = "none";
				document.getElementById("btnNext").style.display = "none";
			}

		}

		entro = true;
	}
	var form = ApiaFunctions.getForm("CMN_TITULO");
	if (form != null) {
		var title = form.getField("CMN_NOMBRE_STR").getValue();
		document.getElementById("titleTramite").innerHTML = title;

		if (window.CURRENT_PROCESS_NAME == undefined
				|| CURRENT_PROCESS_NAME == "COMUNICACIONES") {

			var w = window.innerWidth;
			var h = window.innerHeight;
			var wTotal = window.top.innerWidth;
			var porcent = parseInt((w * 100) / wTotal);
			var limite = parseInt("85");

			var anchoBtnLast = "0%";
			var anchoBtnSalir = "0%";
			var anhoBtnDescartar = "0%";
			var anchoBtnSave = "0%";
			if (tarea == "CARGA_DATOS_COMUNICACION") {
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

	if (tarea == "TAREA_DUMMY") {
		document.getElementById("btnLast").style.display = "none";
		document.getElementById("btnSalir").style.display = "none";
		document.getElementById("btnDescartar").style.display = "none";
		document.getElementById("btnSave").style.display = "none";
		document.getElementById("btnNext").style.display = "none";
		document.getElementById("btnConf").innerHTML = "Continuar al paso siguiente &gt;&gt;";
	}

	if (tarea == "AGENDAR_TRAMITE") {
		document.getElementById("btnLast").style.display = "none";
		// document.getElementById("btnSalir").style.display = "none";
		document.getElementById("btnDescartar").style.display = "none";
		// document.getElementById("btnSave").style.display = "none";
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

	if (tarea == "PEDIR_ACLARACIONES") {
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
		document.getElementById("titleTramite").innerHTML = "Consultar expediente";
		entro = true;
	}
	var form = ApiaFunctions.getForm("DATOS_EXPEDIENTE_WS");
	if (form != null) {
		document.getElementById("titleTramite").innerHTML = "Consultar expediente";
		entro = true;
	}
	var form = ApiaFunctions.getForm("RET_TRM_DATOS_RETOMA");
	if (form != null) {
		document.getElementById("titleTramite").innerHTML = "Retomar Trámite";
		entro = true;
	}
	var form = ApiaFunctions.getForm("RET_TRM_DATOS_RETOMA_2");
	if (form != null) {
		document.getElementById("titleTramite").innerHTML = "Retomar Trámite";
		entro = true;
	}
	if (!entro) {
		// document.getElementById("titleTramite").innerHTML = "No se encontró
		// el expediente <br><br>";
		document.getElementById("titleTramite").innerHTML = "";
	}

	if (isMonitor) {
		document.getElementById("btnLast").style.display = "none";
		document.getElementById("btnSalir").style.display = "none";
		document.getElementById("btnDescartar").style.display = "none";
		document.getElementById("btnSave").style.display = "none";
		document.getElementById("btnConf").style.display = "none";
		document.getElementById("btnNext").style.display = "none";
	} else {
		document.getElementById("btnBack").style.display = "none";
	}

	if (tarea == "SELECCIONAR_TRAMITE") {
		showFrmMail();
		// hideFrmMail();
	}

	if (tarea == "RETOMAR_TRAMITE") {
		hideFrmMail();
	}

	/*
	 * var x = document.getElementsByClassName("css-ver-como-link");
	 * alert(x[0].children[0].children[0].children[0].innerHTML);
	 */
	// <div tabindex="0" class="gridButton" style="width: 64px;">Agregar</div>
	/*
	 * var i; for (i = 0; i < x.length; i++) {
	 * //alert(x[i].style.backgroundColor); }
	 * 
	 * 
	 * 
	 * document.getElementById("btnNext").style.display = "none"; <div
	 * tabindex="0" class="gridButton" style="width: 64px;">Agregar</div>
	 */
	setInterval(loadMsgError, 2000);
	
	setInterval(fixFrameHeight, 1000);		

}

function loadAttributes() {

	document.onkeypress = function(e) {
		if (e.keyCode == 13) {
			return false;
		}
	}

	loadTitle();

}

function showMsgConfirm(type, message, fncName) {

	var aClassName = "dialog-box dialog-info";
	var newDiv = new Element("div", {'class' : aClassName,tabIndex : ''});

	var w = ((window.innerWidth / 2) - 250) + 'px';
	var h = ((window.innerHeight / 2) - 50) + 'px';

	newDiv.setStyle('width', '500px');
	newDiv.setStyle('height', '125px');
	newDiv.setStyle('position', 'fixed');
	newDiv.setStyle('top', '300px');
	newDiv.setStyle('left', w);

	newDiv.setStyle('zIndex', '9999');

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

	var links = "<button class='btn-lg btn-primario-modal' onclick='" + fncName	+ "()'>Confirmar</button>";
	// "<a class='fancybox-close'href='#' onclick='fncRemoveMsg()'>No</a>";

	aClassName = "fancybox-close";
	var newA = new Element("a", {'class' : aClassName,tabIndex : ''});
	newDiv.appendChild(newA);

	if (fncName != "") {
		newDiv4.innerHTML = links;
	}

	newDiv.appendChild(newDiv4);

	document.getElementById('tabla-msg-confirm').appendChild(newDiv);
	document.getElementById('tabla-msg-confirm-block').style.display = "block";

	window.location.href = '#';
}

function modalMsgError(type, message, fncName) {

	var aClassName = "dialog-box dialog-info";
	var newDiv = new Element("div", {'class' : aClassName,tabIndex : ''});

	var w = ((window.innerWidth / 2) - 250) + 'px';
	var h = ((window.innerHeight / 2) - 50) + 'px';

	newDiv.setStyle('width', '500px');
	newDiv.setStyle('height', '125px');
	newDiv.setStyle('position', 'fixed');
	newDiv.setStyle('top', '300px');
	newDiv.setStyle('left', w);

	newDiv.setStyle('zIndex', '9999');

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
	showMsgConfirm("warning", "¿Confirma la cancelación del trámite?","fncDescartarTramite");
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
	showMsgConfirm("warning", "¿Confirma que desea salir del trámite?",	"frmSalirTramite");
}

function frmSalirTramite() {
	window.top.location = CONTEXT + "/portal/redirectSLO.jsp?url="+ URL_RETORNO + TAB_ID_REQUEST;
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

			/*-------------------------------------------*/
			setaerErrorDosColumnas("numero_documento");
			setaerErrorDosColumnas("tipo_documento");
			setaerErrorDosColumnas("campoConAyuda");
			setaerErrorDosColumnas("primera_parte");
			setaerErrorDosColumnas("segunda_parte");
			/*-------------------------------------------*/

		}
	} catch (e) {
	}
	// loadMsgError();
}

function setaerErrorDosColumnas(nameClass) {
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
			 * oErrorFnc.innerHTML = ""; oErrorFnc.className = "";
			 */
		}
	}

	removeClass("error-col2");
	removeClass("error-col2-f1");
	removeClass("error-col2-f2");

}


function showMsgError(par_frm, par_atr, par_msg) {

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



				if (eleErr.childNodes[1] != null) {
					eleErr.childNodes[1].innerHTML = "";
				}
			

			var tag = eleErr.innerHTML;
			eleErr = eleErr.parentNode;

			par_msg = "<p>" + par_msg + "</p>";

			var tError = eleErr.innerHTML;
			var n = tError.indexOf("fc-errorFnc");

			if (n == -1) {

				var obj = new Element('div', {'class' : 'fc-errorFnc','html' : par_msg	});

				var objTR = new Element('TR', {'class' : 'error-col2'});
				var objTD = new Element('TD', {'colspan' : '4'});

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

				var obj = new Element('div', {'class' : 'fc-errorFnc','html' : par_msg});

				var objTR = new Element('TR', {'class' : 'error-col2'});
				var objTD = new Element('TD', {'colspan' : '4'});

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
		if (form != null) {
			field = form.getFieldTel(par_atr);
		}

		if (field != null) {

			/*
			 * eleErr.remoClasse();
			 * 
			 * 
			 * var x = document.getElementsByClassName(className); if (x !=
			 * null) { var i = 0; var max = x.length; while (i < max) { x =
			 * document.getElementsByClassName(className); var oErrorFnc = x[0];
			 * alert(oErrorFnc.parentNode.parentNode.nodeName + " - " +
			 * oErrorFnc.parentNode.parentNode.innerHTML);
			 * oErrorFnc.classList.remove(className); i++; } }
			 * 
			 * 
			 *  /* eleErr.parentNode.parentNode.removeClass("error-col2");
			 * eleErr.parentNode.parentNode.removeClass("error-col2-f1");
			 * 
			 * if(eleErr.parentNode.childNodes[1].innerHTML!=""){
			 * eleErr.parentNode.childNodes[1].remove(); }
			 * 
			 * var nTR = eleErr.parentNode.parentNode;
			 * 
			 * if (nTR.hasClass("error-col2")){ nTR.removeClass("error-col2"); }
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
			if (tr.className == "error-col2") {
				var trN = oTabla.insertRow(i + 1);
				var obj = new Element('div', {'html' : '<p></p>'});
				var td = new Element('td', {'class' : 'fc-errorAux'});
				td.appendChild(obj);
				trN.appendChild(td);
			}
		}
	}
}

function loadMsgError() {

	if (contador < 10) {


		// getHora();
		// console.info("INICIO - loadMsgError() - showErrorFnc: " +
		// showErrorFnc);

		// if (showErrorFnc){

		// Creamos el control XMLHttpRequest segun el navegador en el que
		// estemos
		var MSIE = window.navigator.appVersion.indexOf("MSIE") >= 0;
		if (!MSIE) {
			ajax = new XMLHttpRequest(); // No Internet Explorer
			ajax.onload = function() {
				funcionCallBackLoadMsgError();
			}
		} else {
			ajax = new ActiveXObject("Microsoft.XMLHTTP"); // Internet Explorer
			// Almacenamos en el control al funcion que se invocara cuando la
			// peticion cambie de estado
			ajax.onreadystatechange = funcionCallBackLoadMsgError;
		}

		contador = contador + 1;
		// console.info("contador: " + contador);
		if (contador > 10) {
			// showErrorFnc = false;
		}

		// Enviamos la peticion

		var URL = CONTEXT + "/portal/cargarMsgError.jsp?a=1" + TAB_ID_REQUEST;

		// alert(URL);
		ajax.open("POST", URL, false);
		ajax.send("");

		// }

		// console.info("FIN - loadMsgError() - showErrorFnc: " + showErrorFnc);
	}
}

function funcionCallBackLoadMsgError() {


	// console.info("INICIO - funcionCallBackLoadMsgError() - showErrorFnc: " +
	// showErrorFnc);

	// Escribimos el resultado en la pagina HTML mediante DHTML
	var result = ajax.responseText;
	// alert(result);

	// console.info("result: " + result);

	if (result.indexOf("OK") != -1) {
		var arr = result.split(";");
		showMsgError(arr[1], arr[2], arr[3]);
	}

	// console.info("FIN - funcionCallBackLoadMsgError() - showErrorFnc: " +
	// showErrorFnc);
}

function showFrmMail() {

	var tarea = ApiaFunctions.getCurrentTaskName();

	if (tarea == "RETOMAR_TRAMITE") {

		var objFrm = null;
		var objFrm2 = null;
		var x = document.getElementsByClassName("RET_TRM_DATOS_RETOMA");
		if (x != null) {
			var i;
			for (i = 0; i < x.length; i++) {
				objFrm = x[i];
			}

			if (objFrm != null) {
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

			if (objFrm != null) {
				objFrm.style.visibility = "visible";
			}
		}

		// document.getElementById("btnConf").style.visibility = "visible";
		document.getElementById("titleTramite").style.visibility = "visible";
	}

	if (tarea == "SELECCIONAR_TRAMITE") {

		var objFrm = null;
		var objFrm2 = null;
		var x = document.getElementsByClassName("TRM_FRM_EMAIL_USUARIO");
		if (x != null) {
			var i;
			for (i = 0; i < x.length; i++) {
				objFrm = x[i];
			}
		}

		x = document
				.getElementsByClassName("TRM_FRM_EMAIL_USUARIO_CON_CAPTCHA");
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

		var modoAut = myForm.getField("TRM_MODO_AUTENTICACION_STR").getValue();

		var mostrar = true;
		if (visibilidad != '1') {
			if (CURRENT_USER_LOGIN == 'guest') {
				mostrar = false;
			}
		}

		if (mostrar) {
			if (objFrm != null) {
				objFrm.style.visibility = "visible";
			}
			if (objFrm2 != null) {
				objFrm2.style.visibility = "visible";
			}

			document.getElementById("btnConf").style.visibility = "visible";
			document.getElementById("titleTramite").style.visibility = "visible";
		} else {
			if (objFrm != null) {
				objFrm.style.visibility = "hidden";
				document.getElementById("btnConf").style.visibility = "hidden";
				document.getElementById("btnNext").style.visibility = "hidden";
			}
			if (objFrm2 != null) {
				objFrm2.style.visibility = "hidden";
				document.getElementById("btnConf").style.visibility = "hidden";
				document.getElementById("btnNext").style.visibility = "hidden";
			}
		}
	}
}

function hideFrmMail() {

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

	if (eMail != "") {
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
		var x = document
				.getElementsByClassName("TRM_FRM_EMAIL_USUARIO_CON_CAPTCHA");
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

function setFocus(o) {

	try {
		for (var i = 0; i < 10; i++) {
			if (o.childNodes[i] != null) {
				if (o.childNodes[i].tagName == "INPUT") {
					o.childNodes[i].focus();
					return;
				}
			}
		}

		for (var i = 0; i < 10; i++) {
			if (o.childNodes[i] != null) {
				for (var j = 0; j < 10; j++) {
					if (o.childNodes[i].childNodes[j] != null) {
						if (o.childNodes[i].childNodes[j].tagName == "INPUT") {
							o.childNodes[i].childNodes[j].focus();
							return;
						}
					}
				}
			}
		}
		/*
		 * alert(o.childNodes[0].tagName); alert(o.childNodes[1].tagName);
		 * alert(o.childNodes[1].childNodes[0].tagName);
		 * alert(o.childNodes[1].childNodes[1].tagName);
		 * document.getElementById(field).childNodes[1].childNodes[0].focus();
		 */
	} catch (e) {
	}

}

function getHora() {
	var d = new Date();
	var h = addZero(d.getHours());
	var m = addZero(d.getMinutes());
	var s = addZero(d.getSeconds());
	// console.info("Hora: " + h + ":" + m + ":" + s);
}

function addZero(i) {
	if (i < 10) {
		i = "0" + i;
	}
	return i;
}

function getUsrEmail() {
	var eMail = "";
	try {
		eMail = ApiaFunctions.getForm("TRM_TITULO").getField("TRM_EMAIL_USUARIO_STR").getValue();
	} catch (e) {
	}

	return eMail;
}

function ajustarAnchoColumna() {
	try {
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

				// Acciones
				var el1 = el.children[0].children[0].children[0].children[0].children[0];

				el1.style.width = "100px";

				// adjutnos
				var el2 = el.children[0].children[0].children[0].children[0].children[1];

				el2.style.width = "500px";

			}
		}

		var x = document.getElementsByClassName("docData");
		if (x != null) {
			var i;
			for (i = 0; i < x.length; i++) {
				var el = x[i];
				if (el.innerHTML != "") {
					var l = el.innerHTML.length;
					var m = (l * 6);
					el.parentNode.children[5].style.marginLeft = m;
				}
			}
		}

	} catch (e) {
	}
}

function removeClass(className) {
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
