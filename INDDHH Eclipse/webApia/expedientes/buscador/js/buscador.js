function getXmlHttp() {

	var xmlHttp = null;
	if (window.XMLHttpRequest) {
		xmlHttp = new XMLHttpRequest();
	} else {
		xmlHttp = new ActiveXObject("Microsoft.XMLHTTP");
	}
	return xmlHttp;

}

function cargarInfoExtra() {
	
	var index = 0;
	var divT = "info-tamanio-" + index + "ee";
	setTimeout(function() {
		cargarTamanioEE(index);
	}, (100));
	clasesFiltrosFechas();
	
	comprobarBusquedaAvanzada();
}

function clasesFiltrosFechas() {
	
	var fch_crea_desde = $("fch_crea_desde");
	setAdmDatePicker(fch_crea_desde);
	fch_crea_desde.getNext().addClass("datepickerInput");

	var fch_crea_hasta = $("fch_crea_hasta");
	setAdmDatePicker(fch_crea_hasta);
	fch_crea_hasta.getNext().addClass("datepickerInput");

	var fch_pase_desde = $("fch_pase_desde");
	setAdmDatePicker(fch_pase_desde);
	fch_pase_desde.getNext().addClass("datepickerInput");

	var fch_pase_hasta = $("fch_pase_hasta");
	setAdmDatePicker(fch_pase_hasta);
	fch_pase_hasta.getNext().addClass("datepickerInput");
	
}

function funcionCallBackTamanioEE(index , result) {
	
	var divT = "info-tamanio-" + index + "ee";
	if (document.getElementById(divT) != null) {
		if (result.trim().length < 100) {
			document.getElementById(divT).innerHTML = result.trim();
		} else {
			document.getElementById(divT).style.display = 'block';
		}
	}
	
	if (index < 10) {
		index = index + 1;

		setTimeout(function() {
			cargarTamanioEE(index);
		}, (100));
	}
	
}

function cargarTamanioEE(index) {
	
	try {
		
		var divT = "info-tamanio-" + index + "ee";
		var nroEE = document.getElementById(divT).innerHTML;	
		var URL = getUrlApp() + "/expedientes/buscador/cargarTamanioEE.jsp?nroEE=" + nroEE + TAB_ID_REQUEST;
		
		var xmlHttp = getXmlHttp();
		xmlHttp.onreadystatechange = function() {
			if (xmlHttp.readyState==4 && xmlHttp.status==200){
				var result = xmlHttp.responseText;
				funcionCallBackTamanioEE(index , result);
			}
		};

		xmlHttp.open("POST" , URL , false);
		xmlHttp.send(null);
		
	}catch (e){
		// si entra al catch es porque divT no esta cargado
	}
	
}

function trabajarEE(valores) {
	
	if (valores != "") {
		var res = valores.split("*");
		var proInstId = res[0];
		var proEleInstId = res[1];
		var tarea = res[2];
		var url = getUrlApp() + "/apia.execution.TaskAction.run?action=getTask&forceAcquire=true&proInstId=" + proInstId + "&proEleInstId=" + proEleInstId + "&tabId=<%=System.currentTimeMillis()%>&tokenId=<%=tokenId%>";
		parent.tabContainer.addNewTab(tarea, url);
	}
	
}

function solicitarEEFromProcess(nroExp, ubAct, usrAct, usrActName){

	ubAct = convertCharacters(ubAct);
	usrActName = convertCharacters(usrActName);
    
	var url = getUrlApp() + "/apia.execution.TaskAction.run?action=startCreationProcess&busEntId=" + ent_id_sol + "&proId=" + pro_id_sol + "&E_SOL_TMP_NRO_EXP=" + nroExp + "&E_SOL_TMP_UBICACION_ACTUAL=" + ubAct + "&E_SOL_TMP_USUARIO_ACTUAL=" + usrAct + "&E_SOL_TMP_USUARIO_ACTUAL_NOMBRE=" + usrActName + TAB_ID_REQUEST;
	var title = "Solicitar expediente " + nroExp;
	parent.tabContainer.addNewTab(title, url);
	
}

function convertCharacters(text){	
	text = text.replace(/Á/g,"[A_tilde]");
	text = text.replace(/É/g,"[E_tilde]");
	text = text.replace(/Í/g,"[I_tilde]");
	text = text.replace(/Ó/g,"[O_tilde]");
	text = text.replace(/Ú/g,"[U_tilde]");
	text = text.replace(/á/g,"[a_tilde]");
	text = text.replace(/é/g,"[e_tilde]");
	text = text.replace(/í/g,"[i_tilde]");
	text = text.replace(/ó/g,"[o_tilde]");
	text = text.replace(/ú/g,"[u_tilde]");
	text = text.replace(/Ñ/g,"[N_tilde]");
	text = text.replace(/ñ/g,"[n_tilde]");
	return text;
}

function favorito(nroExp, ubAct, btn) {
	
	var action = "";
	var src = btn.getChildren()[0].get('src');
	if (src.indexOf('favOn') != -1) {
		action = "desmarcar";
		var favOff = getUrlApp() + '/expedientes/iconos/fav_12.png';
		btn.getChildren()[0].set('src', favOff);
	} else {
		action = "marcar";
		var favOn = getUrlApp() + '/expedientes/iconos/favOn_12.png';
		btn.getChildren()[0].set('src', favOn);
	}
	
	URL = getUrlApp() + "/expedientes/buscador/agregarFavorito.jsp?nroExp=" + nroExp + "&action=" + action + TAB_ID_REQUEST;
	
	var xmlHttp = getXmlHttp();
	xmlHttp.onreadystatechange = function() {
		if (xmlHttp.readyState==4 && xmlHttp.status==200){
			// cargo el favorito
		}
	};

	xmlHttp.open("POST" , URL , false);
	xmlHttp.send(null);
	
}

function ponerMayusculas(nombre, evnt) {
	var ev = (evnt) ? evnt : event;
	var code = (ev.which) ? ev.which : event.keyCode;

	if (!((code >= 48) & (code <= 57))) {
		nombre.value = nombre.value.toUpperCase();
	}
}

function sugerir() {
	
	if (!isSolrOff) {
		var texto = document.getElementById('search').value;
		if (textoActual != texto) {

			var client = getXmlHttp();
			client.onreadystatechange = function() {
				if (client.readyState==4 && client.status==200){
					document.getElementById('searchDiv').innerHTML = client.responseText;
				}
			};
			
			textoActual = texto;
			document.getElementById('searchDiv').innerHTML = "";
			URL = getUrlApp() + "/expedientes/solr/solr.jsp?m=suggest&q=" + texto;

			client.open("GET" , URL , false);
			client.send(null);

		}
	}
	
}

function mostrar() {
	
	var divBusquedaAvanzada = document.getElementById('oculto');
	if (divBusquedaAvanzada.style.display == 'block') {
		divBusquedaAvanzada.style.display = 'none';
	} else {
		divBusquedaAvanzada.style.display = 'block';
	}
	
}

function mostrarHistorialResultado(nroExp) {
	
	var URL = getUrlApp() + "/expedientes/HistorialActuaciones/historialActuaciones.jsp?NroExp=" + nroExp + TAB_ID_REQUEST;
	var tab = {
		title : "Historial " + nroExp,
		url : URL
	};
	parent.tabContainer.addNewTab(tab.title, tab.url);
	
}

function mostrarTitulares(envId , nroExp) {
	
	var URL = getUrlApp() + "/expedientes/buscador/titulares.jsp?envId=" + envId + "&exp=" + nroExp + TAB_ID_REQUEST;
	var tab = {
		title : "Titulares Exp. " + nroExp,
		url : URL
	};
	parent.tabContainer.addNewTab(tab.title, tab.url);
	
}

function limpiar() {
	
	clearFilterDate('fch_crea_desde');
	clearFilterDate('fch_crea_hasta');
	clearFilterDate('fch_pase_desde');
	clearFilterDate('fch_pase_hasta');
	document.getElementById('cmbTipoExpedientes').value   = "";
	document.getElementById('cmbOficinaActual').value     = "";
	document.getElementById('cmbEstado').value            = "";
	document.getElementById('cmbAccesoRestringido').value = "";
	document.getElementById('cmbElemFisc').value          = "";
	document.getElementById('cmbClasificacion').value     = "";
	document.getElementById('chkIncNumExt').checked       = false;
	document.getElementById('cmbCampoOrden').value        = CAMPO_ORDEN_RESULTADO;
	document.getElementById('cmbOrden').value             = TIPO_ORDEN_RESULTADO;

	var radios = document.getElementsByTagName('input');
	var value;
	for (var i = 0; i < radios.length; i++) {
		if (radios[i].type === 'radio') {

			if (radios[i].value == "AND") {
				radios[i].checked = true;
			}
		}
	}
	
	
	comprobarBusquedaAvanzada();
	
}

function cambiar(op) {
	
	if (op == 0) {
		if (isSolrOff) {
			showMessage("La busqueda por contenido no está disponible en este momento.");
			return;
		}
	}

	document.getElementById('op').value = op;
	document.getElementById('frmMain').submit();
	
}

function redirectArbol(exp) {
	
	var urlArbol = getUrlApp() + "/expedientes/arbolDelExpediente/arbolEE.jsp?nroEE=" + exp + TAB_ID_REQUEST;
	var tab = {
		title : "Arbol del expediente",
		url : urlArbol
	};
	parent.tabContainer.addNewTab(tab.title, tab.url);
	
}

function showStars(e, codPregunta) {
	
	var url = getUrlApp() + "/apia.execution.TaskAction.run?action=startCreationProcess&busEntId=" + ent_id + "&proId=" + pro_id + TAB_ID_REQUEST + "&E_ENC_USU_PREGUNTA_STR=" + codPregunta;
	var title = "Ay\u00fadenos a mejorar";
	parent.tabContainer.addNewTab(title, url);
	e.style.display = 'none';
	
}

function showdiv(boton , envId , expediente) {

	var rect = boton.getBoundingClientRect();
	
	var xmlHttp = getXmlHttp();
	xmlHttp.onreadystatechange = function() {
		if (xmlHttp.readyState==4 && xmlHttp.status==200){
			var htmlCode = xmlHttp.responseText;
			var div_tits = document.getElementById("titulares_div");
			div_tits.style.top = rect.bottom + document.body.scrollTop + 5;
			div_tits.style.left = rect.left + document.body.scrollLeft;
			div_tits.style.display = "block";
			div_tits.innerHTML = htmlCode.trim();
		}
	};

	URL = getUrlApp() + "/expedientes/buscador/titulares.jsp?envId=" + envId + "&exp=" + expediente + TAB_ID_REQUEST;
	
	xmlHttp.open("POST" , URL , false);
	xmlHttp.send(null);

}

function hiddediv(){
	var div_tits = document.getElementById("titulares_div");
	div_tits.style.display = "none";
}

function exportarResultado() {
	
	// CARGO LOS FILTROS APLICADOS
	var sep_filtros = ";";
	
	var palabras = document.getElementById("search").value;
	var tipo_busqueda = document.getElementsByClassName("one")[0].text;
	
	var todas_las_palabras = document.getElementsByName("rdoOperador")[0].checked;
	var al_menos_una = document.getElementsByName("rdoOperador")[1].checked;
	
	var ba_fecha_creacion_desde = document.getElementsByClassName("datepickerInput")[0].value;
	var ba_fecha_creacion_hasta = document.getElementsByClassName("datepickerInput")[1].value;
	var ba_fecha_ultimo_pase_desde = document.getElementsByClassName("datepickerInput")[2].value;
	var ba_ultimo_pase_hasta = document.getElementsByClassName("datepickerInput")[3].value;
	
	var ba_tipo_exp_grid = document.getElementById('cmbTipoExpedientes');
	var ba_tipo_exp = ba_tipo_exp_grid.options[ba_tipo_exp_grid.selectedIndex].text;
	
	var ba_oficina_actual_grid = document.getElementById('cmbOficinaActual');
	var ba_oficina_actual = ba_oficina_actual_grid.options[ba_oficina_actual_grid.selectedIndex].text;
	
	var ba_estado_grid = document.getElementById('cmbEstado');
	var ba_estado = ba_estado_grid.options[ba_estado_grid.selectedIndex].text;
	
	var ba_acc_rest_grid = document.getElementById('cmbAccesoRestringido');
	var ba_acc_rest = ba_acc_rest_grid.options[ba_acc_rest_grid.selectedIndex].text;
	
	var ba_elem_fisic_grid = document.getElementById('cmbElemFisc');
	var ba_elem_fisic = ba_elem_fisic_grid.options[ba_elem_fisic_grid.selectedIndex].text;
	
	var ba_clasificacion_grid = document.getElementById('cmbClasificacion');
	var ba_clasificacion = ba_clasificacion_grid.options[ba_clasificacion_grid.selectedIndex].text;
	
	var ba_num_ext = document.getElementById('chkIncNumExt').checked;
	
	var ba_orden_campo_grid = document.getElementById('cmbCampoOrden');
	var ba_orden_campo = ba_orden_campo_grid.options[ba_orden_campo_grid.selectedIndex].text;
	
	var ba_orden_tipo_grid = document.getElementById('cmbOrden');
	var ba_orden_tipo = ba_orden_tipo_grid.options[ba_orden_tipo_grid.selectedIndex].text;
	
	var filtros =
		palabras + sep_filtros + tipo_busqueda + sep_filtros + todas_las_palabras + sep_filtros + al_menos_una + sep_filtros +
		ba_fecha_creacion_desde + sep_filtros + ba_fecha_creacion_hasta + sep_filtros + ba_fecha_ultimo_pase_desde + sep_filtros + ba_ultimo_pase_hasta + sep_filtros +
		ba_tipo_exp + sep_filtros + ba_oficina_actual + sep_filtros + ba_estado + sep_filtros + ba_acc_rest + sep_filtros + ba_elem_fisic + sep_filtros +
		ba_clasificacion + sep_filtros + ba_num_ext + sep_filtros + ba_orden_campo + sep_filtros + ba_orden_tipo;
	
	// MANDO A GENERAR EL EXCEL
	var xmlHttp = getXmlHttp();
	xmlHttp.onreadystatechange = function() {
		if (xmlHttp.readyState==4 && xmlHttp.status==200){
			
			var uri = 'data:application/vnd.ms-excel;base64,';
			var template = '<html xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:x="urn:schemas-microsoft-com:office:excel" xmlns="http://www.w3.org/TR/REC-html40"><head><!--[if gte mso 9]><xml><x:ExcelWorkbook><x:ExcelWorksheets><x:ExcelWorksheet><x:Name>{worksheet}</x:Name><x:WorksheetOptions><x:DisplayGridlines/></x:WorksheetOptions></x:ExcelWorksheet></x:ExcelWorksheets></x:ExcelWorkbook></xml><![endif]--></head><body>{table}</body></html>';

			var base64 = function(s) {
				return window.btoa(unescape(encodeURIComponent(s)))
			};

			var format = function(s, c) {
				return s.replace(/{(\w+)}/g, function(m, p) {
					return c[p];
				})
			};
			
			var table_test = xmlHttp.responseText;			
			
			var ctx = {
				worksheet : 'Worksheet',
				table : table_test
			}
			
			// DESCARGA POR ANCHOR VALIDO EN TODOS LOS BROWSERS
			var link = document.createElement('a');
			link.addEventListener('click', function(ev) {
			    link.href = uri + base64(format(template, ctx));
			    link.download = "busqueda.xls";
			}, false);
			document.body.appendChild(link);
			link.click();
			// DESCARGA POR ANCHOR VALIDO EN TODOS LOS BROWSERS
			
		}
	};
	
	URL = getUrlApp() + "/expedientes/buscador/generateExportHtml.jsp?filtros=" + filtros + TAB_ID_REQUEST;
	
	xmlHttp.open("POST" , URL , false);
	xmlHttp.send(null);

}

function comprobarBusquedaAvanzada(){
	
	var ba_activa = false;
	
	var ba_fecha_creacion_desde = document.getElementsByClassName("datepickerInput")[0].value;
	var ba_fecha_creacion_hasta = document.getElementsByClassName("datepickerInput")[1].value;
	var ba_fecha_ultimo_pase_desde = document.getElementsByClassName("datepickerInput")[2].value;
	var ba_ultimo_pase_hasta = document.getElementsByClassName("datepickerInput")[3].value;
	
	if (ba_fecha_creacion_desde != "" || ba_fecha_creacion_hasta != "" || 
		ba_fecha_ultimo_pase_desde != "" || ba_ultimo_pase_hasta != "") {
		ba_activa = true;
	}
	
	var ba_tipo_exp_grid = document.getElementById('cmbTipoExpedientes');
	var ba_tipo_exp = ba_tipo_exp_grid.options[ba_tipo_exp_grid.selectedIndex].text;
	
	var ba_oficina_actual_grid = document.getElementById('cmbOficinaActual');
	var ba_oficina_actual = ba_oficina_actual_grid.options[ba_oficina_actual_grid.selectedIndex].text;
	
	var ba_estado_grid = document.getElementById('cmbEstado');
	var ba_estado = ba_estado_grid.options[ba_estado_grid.selectedIndex].text;
	
	var ba_acc_rest_grid = document.getElementById('cmbAccesoRestringido');
	var ba_acc_rest = ba_acc_rest_grid.options[ba_acc_rest_grid.selectedIndex].text;
	
	var ba_elem_fisic_grid = document.getElementById('cmbElemFisc');
	var ba_elem_fisic = ba_elem_fisic_grid.options[ba_elem_fisic_grid.selectedIndex].text;
	
	var ba_clasificacion_grid = document.getElementById('cmbClasificacion');
	var ba_clasificacion = ba_clasificacion_grid.options[ba_clasificacion_grid.selectedIndex].text;
	
	if (ba_tipo_exp != "" || ba_oficina_actual != "" || ba_estado != "" ||
		ba_acc_rest != "" || ba_elem_fisic != "" || ba_clasificacion != "") {
		ba_activa = true;
	}
	
	var ba_num_ext = document.getElementById('chkIncNumExt').checked;
	
	if (ba_num_ext) {
		ba_activa = true;
	}
	
	var ba_orden_campo_grid = document.getElementById('cmbCampoOrden');
	var ba_orden_campo = ba_orden_campo_grid.options[ba_orden_campo_grid.selectedIndex].text;
	
	var ba_orden_tipo_grid = document.getElementById('cmbOrden');
	var ba_orden_tipo = ba_orden_tipo_grid.options[ba_orden_tipo_grid.selectedIndex].text;
	
	if (ba_orden_campo != "Nro Expediente" || ba_orden_tipo != "Descendente") {
		ba_activa = true;
	}
	
	if (ba_activa) {
		document.getElementById("busqueda_avanzada_img").title = "Búsqueda avanzada activa";
		document.getElementById("busqueda_avanzada_img").style.background = "url('./img/busqueda_avanzada_active.png')";
	} else {
		document.getElementById("busqueda_avanzada_img").title = "Búsqueda avanzada inactiva";
		document.getElementById("busqueda_avanzada_img").style.background = "url('./img/busqueda_avanzada_inactive.png')";
		document.getElementById("busqueda_avanzada_img").style.opacity = "0.5";	
	}
	document.getElementById("busqueda_avanzada_img").style.backgroundSize = "20px";
	document.getElementById("busqueda_avanzada_img").style.backgroundRepeat = "no-repeat";
	document.getElementById("busqueda_avanzada_img").style.width = "20px";
	document.getElementById("busqueda_avanzada_img").style.height = "20px";
	document.getElementById("busqueda_avanzada_img").style.float = "right";
}
