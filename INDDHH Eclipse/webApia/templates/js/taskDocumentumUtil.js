var TASK_OTRA             = "TSKOtra";
var TASK_FIRMAR_ACTUACION = "Firmar actuaci\u00f3n";

var ACTION_DESCARGA     = "descargar";
var ACTION_PREVIEW      = "preview";
var ACTION_MARCAR       = "marcar";
var ACTION_DESMARCAR    = "desmarcar";
var ELEM_FISIC_DENEGAR  = "DENEGAR";
var ELEM_FISIC_PERMITIR = "PERMITIR";

var LIMIT_PRMT_PIEZAS_UNIT = "KB";

var MSG_SIN_PERMISO_ACT   = "Usted no tiene los permisos para ver las actuaciones de este expediente.";
var MSG_SIN_PERMISO_FILE  = "Usted no tiene los permisos para ver este archivo.";
var MSG_ELEM_FISC_ACTIVOS = "Este expediente contiene elementos f\u00edsicos activos por lo cual no es posible cambiar la pertenencia de elemento f\u00edsico de si a no.<br><br>Para desactivar los elementos f\u00edsicos deber\u00e1 ir a la tabla de historial de los mismos y pulsar el check <b>Dar baja</b> de todos los que est\u00e9n activos y realizar una actuaci\u00f3n para que cobre efecto.<br><br>Tenga en cuenta que no podr\u00e1 realizar esta acci\u00f3n si el elemento f\u00edsico contiene folios reservados.";
var MSG_CLOSE_TAB         = "Est\u00e1 por perder las modificaciones realizadas. \u00BFDesea continuar?";
var MSG_ERROR_TAB         = "ERROR: No se encontr\u00f3 el tab actual";

function loadDescargaRealizarActuacion(edocs, botones) {

	favoritoIcono();
	document.getElementById("imgHelpVideo").style.background = "url(" + getUrlApp() + "/css/documentum/img/menu/help_12.png)";

	var nroExp = getNroExpe();

	var xmlHttp = getXmlHttp();
	xmlHttp.onreadystatechange = function() {

		if (xmlHttp.readyState == 4 && xmlHttp.status == 200) {

			var size = xmlHttp.responseText.split("\$")[0];

			// CARGO SUBTITULO DEL EXPEDIENTE
			var filetext = "<b>Expediente " + nroExp + " [" + size + "]</b>";
			document.getElementById('ExpTitle').innerHTML = filetext;

			document.getElementById('expSize').style.display = "none";
			document.getElementById('expSize').innerHTML = size;

			// CARGO BOTONES
			var nroExpEncode = btoa(nroExp);
			var url = "\"javascript:verFoliado('" + nroExpEncode + "','TSKOtra')\"";

			var btnDownHtml =
				"<div title='Descargar' class='download' onClick=" + url + ">" +
				 "<div id='imgDownload' class='imgDownload'></div>" +
				 "<a href=" + url + "></a>" +
				"</div>";
			document.getElementById('dowloadRef').innerHTML = btnDownHtml;

			var btnDownModalHtml =
				"<div title='Descargar' class='downModal' onClick='downloadModal()'>" +
				 "<div id='imgDownModal' class='imgDownModal'></div>" +
				 "<a href='javascript:downloadModal()'></a>" +
				 "<span class='sp_down'> Descargar </span>" +
				"</div>";
			document.getElementById('downModalRef').innerHTML = btnDownModalHtml;

			var btnPrevHtml =
				"<div title='Visualizar' class='preview' onClick='preview()'>" +
				 "<div id='imgPreview' class='imgPreview'></div>" +
				 "<a href='javascript:preview()'></a>" +
				 "<span class='sp_preview'> Visualizar </span>" +
				"</div>";
			document.getElementById('previewRef').innerHTML = btnPrevHtml;

			// if (edocs != "true") {

			var btnArbolHtml =
				"<div title='\u00c1rbol' class='arbol' onClick='showArbol()'>" +
				 "<div id='imgArbol' class='imgArbol'></div>" +
				 "<a href='javascript:showArbol()'></a>" +
				 "<span class='sp_arbol'> \u00c1rbol </span>" +
				"</div>";
			document.getElementById('arbolRef').innerHTML = btnArbolHtml;

			//} else {
			 //document.getElementById('downModalRef').style.left = "65%";
			 //document.getElementById('previewRef').style.left = "15%";
			//}
			
			if (!ApiaFunctions.getForm("TABSBUTTONS")) {
				document.getElementById('tabMenuContainer').style.display = "none";
				document.getElementById('buttonsActions').style.top = "34%";
			}

			ajustarEstiloFuncionalidades(botones);

		}
	};

	var getSize = getUrlApp() + "/expedientes/getSizeExpediente.jsp?ee=" + nroExp + TAB_ID_REQUEST;
	xmlHttp.open("POST", getSize, true);
	xmlHttp.send(null);

	cargarCerrarTab();

}

function loadDescargaFirmarExpediente(edocs) {
	
	var tarea = document.getElementsByClassName("taskTitle")[0].innerHTML;

	if (tarea == TASK_FIRMAR_ACTUACION) {

		var xmlHttp = getXmlHttp();
		xmlHttp.onreadystatechange = function() {
			if (xmlHttp.readyState == 4 && xmlHttp.status == 200) {
				
				var size = xmlHttp.responseText.split("\$")[0];

				// CARGO SUBTITULO DEL EXPEDIENTE
				var filetext = "Expediente " + getNroExpe() + " [" + size + "]" + "</b>";
				document.getElementById('ExpTitle').innerHTML = filetext;

				document.getElementById('expSize').style.display = "none";
				document.getElementById('expSize').innerHTML = size;

				// CARGO BOTONES
				var url = "javascript:verFoliado(\"" + encodeBase64(getNroExpe()) + "\",\"TSKOtra\")";
				var btnDownHtml =
					"<div title='Descargar Expediente' class='download' onClick=" + url + ">" +
					 "<div id='imgDownload' class='imgDownload'></div>" +
					 "<a href=" + url + "></a>" + 
					"</div>";
				document.getElementById('dowloadRef').innerHTML = btnDownHtml;

				var btnDownModalHtml =
					"<div title='Descargar Expediente' class='downModal' onClick='downloadModal()'>" +
					 "<div id='imgDownModal' class='imgDownModal'></div>" +
					 "<a href='javascript:downloadModal()'></a>" +
					 "<span class='sp_down'> Descargar </span>" +
					"</div>";
				document.getElementById('downModalRef').innerHTML = btnDownModalHtml;

				var btnPrevHtml =
					"<div title='Previsualizar Expediente' class='preview' onClick='preview()'>" +
					"<div id='imgPreview' class='imgPreview'></div>" +
					"<a href='javascript:preview()'></a>" +
					"<span class='sp_preview'> Visualizar </span>" +
					"</div>";
				document.getElementById('previewRef').innerHTML = btnPrevHtml;

				if (edocs != "true") {

					var btnArbolHtml =
						"<div title='Arbol del Expediente' class='arbol' onClick='showArbol()'>" +
						"<div id='imgArbol' class='imgArbol'></div>" +
						"<a href='javascript:showArbol()'></a>" +
						"<span class='sp_arbol'> \u00c1rbol </span>" +
						"</div>";
					document.getElementById('arbolRef').innerHTML = btnArbolHtml;

				} else {
					document.getElementById('downModalRef').style.left = "65%";
					document.getElementById('previewRef').style.left = "15%";
				}

			}
		};

		var getSize = getUrlApp() + "/expedientes/getSizeExpediente.jsp?ee=" + getNroExpe() + TAB_ID_REQUEST;
		xmlHttp.open("POST", getSize, true);
		xmlHttp.send(null);

	} else {
		document.getElementById("expedienteContainer").style.display = "none";
		document.getElementById("buttonsActions").style.top = "42%";
	}

	cargarCerrarTab();
	
}

function loadDescargaArchivarExpediente(){
	
	var nroExp = getNroExpe();
	
	var xmlHttp = getXmlHttp();
	xmlHttp.onreadystatechange = function() {
		if (xmlHttp.readyState==4 && xmlHttp.status==200){
			
			var size = xmlHttp.responseText.split("\$")[0];			
			
			// CARGO SUBTITULO DEL EXPEDIENTE
			var filetext = "<b>Expediente " + nroExp + " [" + size + "]</b>";			
			document.getElementById('ExpTitle').innerHTML = filetext;
			
			document.getElementById('expSize').style.display = "none";
			document.getElementById('expSize').innerHTML = size;
			
			// CARGO BOTONES			
			var nroExpEncode = btoa(nroExp);
			var url = "\"javascript:verFoliado('" + nroExpEncode + "','TSKOtra')\"";
			
			var btnDownHtml =				
			"<div title='Descargar Expediente' class='download' onClick="+url+">"+
			"<div id='imgDownload' class='imgDownload'></div>"+
			"<a href="+url+"></a>"+
			"</div>";
			
			var btnDownModalHtml =
				"<div title='Descargar Expediente' class='downModal' onClick='downloadModal()'>"+
				"<div id='imgDownModal' class='imgDownModal'></div>"+
				"<a href='javascript:downloadModal()'></a>"+
				"<span class='sp_down'> Descargar </span>" +
				"</div>";		
			
			var btnPrevHtml =
				"<div title='Previsualizar Expediente' class='preview' onClick='preview()'>"+
				"<div id='imgPreview' class='imgPreview'></div>"+
				"<a href='javascript:preview()'></a>"+
				"<span class='sp_preview'> Visualizar </span>" +
				"</div>";
			
			var btnArbolHtml =
				"<div title='Arbol del Expediente' class='arbol' onClick='showArbol()'>"+
				"<div id='imgArbol' class='imgArbol'></div>"+
				"<a href='javascript:showArbol()'></a>"+
				"<span class='sp_arbol'> \u00c1rbol </span>" +
				"</div>";
			
			document.getElementById('dowloadRef').innerHTML = btnDownHtml;
			document.getElementById('downModalRef').innerHTML = btnDownModalHtml;	
			document.getElementById('previewRef').innerHTML = btnPrevHtml;
			document.getElementById('arbolRef').innerHTML = btnArbolHtml;
			
		}	
	};
	
	var getSize = getUrlApp() + "/expedientes/getSizeExpediente.jsp?ee=" + nroExp + TAB_ID_REQUEST;
	xmlHttp.open("POST" , getSize , true);
	xmlHttp.send(null);	
	
}

function loadDescargaEnEspera(){

	var nroExp = getNroExpe();
	
	var xmlHttp = getXmlHttp();
	xmlHttp.onreadystatechange = function() {
		if (xmlHttp.readyState==4 && xmlHttp.status==200){

			var size = xmlHttp.responseText.split("\$")[0];			
			
			// CARGO SUBTITULO DEL EXPEDIENTE
			var filetext = "<b>Expediente " + nroExp + " [" + size + "]</b>";			
			document.getElementById('ExpTitle').innerHTML = filetext;
			
			document.getElementById('expSize').style.display = "none";
			document.getElementById('expSize').innerHTML = size;
			
			// CARGO BOTONES			
			var nroExpEncode = btoa(nroExp);
			var url = "\"javascript:verFoliado('" + nroExpEncode + "','TSKOtra')\"";
			
			var btnDownHtml =				
			"<div title='Descargar Expediente' class='download' onClick="+url+">"+
			"<div id='imgDownload' class='imgDownload'></div>"+
			"<a href="+url+"></a>"+
			"</div>";
			
			var btnDownModalHtml =
				"<div title='Descargar Expediente' class='downModal' onClick='downloadModal()'>"+
				"<div id='imgDownModal' class='imgDownModal'></div>"+
				"<a href='javascript:downloadModal()'></a>"+
				"<span class='sp_down'> Descargar </span>" +
				"</div>";		
			
			var btnPrevHtml =
				"<div title='Previsualizar Expediente' class='preview' onClick='preview()'>"+
				"<div id='imgPreview' class='imgPreview'></div>"+
				"<a href='javascript:preview()'></a>"+
				"<span class='sp_preview'> Visualizar </span>" +
				"</div>";
			
			var btnArbolHtml =
				"<div title='Arbol del Expediente' class='arbol' onClick='showArbol()'>"+
				"<div id='imgArbol' class='imgArbol'></div>"+
				"<a href='javascript:showArbol()'></a>"+
				"<span class='sp_arbol'> \u00c1rbol </span>" +
				"</div>";
			
			document.getElementById('dowloadRef').innerHTML = btnDownHtml;
			document.getElementById('downModalRef').innerHTML = btnDownModalHtml;	
			document.getElementById('previewRef').innerHTML = btnPrevHtml;
			document.getElementById('arbolRef').innerHTML = btnArbolHtml;
			
			if (!ApiaFunctions.getForm("TABSBUTTONS")){
				document.getElementById('tabMenuContainer').style.display = "none";
				document.getElementById('buttonsActions').style.top = "34%";
			}
			
		}	
	};
	
	var getSize = getUrlApp() + "/expedientes/getSizeExpediente.jsp?ee=" + nroExp + TAB_ID_REQUEST;
	xmlHttp.open("POST" , getSize , true);
	xmlHttp.send(null);
}

function ajustarEstiloFuncionalidades(botones) {
	
	var func = botones.split(";");

	if (func.length <= 4) {
		document.getElementsByClassName("buttonsActions")[0].style.top = "50%";
	}

	if (func.length <= 5) {
		document.getElementsByClassName("buttonsActions")[0].style.top = "65%";

		for (var i = 0; i < func.length; i++) {

			if (i == 0) {
				document.getElementsByClassName(func[i])[0].style.top = "0%";
				document.getElementsByClassName(func[i])[0].style.left = "3%";
			}

			if (i == 1) {
				document.getElementsByClassName(func[i])[0].style.top = "0%";
				document.getElementsByClassName(func[i])[0].style.left = "27%";
			}

			if (i == 2) {
				document.getElementsByClassName(func[i])[0].style.top = "0%";
				document.getElementsByClassName(func[i])[0].style.left = "52%";
			}

			if (i == 3) {
				document.getElementsByClassName(func[i])[0].style.top = "0%";
				document.getElementsByClassName(func[i])[0].style.left = "78%";
			}

			if (i == 4) {
				document.getElementsByClassName(func[i])[0].style.top = "55%";
				document.getElementsByClassName(func[i])[0].style.left = "3%";
			}

		}

	} 
	
	if (func.length == 9) {
		document.getElementsByClassName("buttonsActions")[0].style.top = "75%";

		for (var i = 0; i < func.length; i++) {

			if (i == 0) {
				document.getElementsByClassName(func[i])[0].style.top = "0%";
				document.getElementsByClassName(func[i])[0].style.left = "10%";
			}

			if (i == 1) {
				document.getElementsByClassName(func[i])[0].style.top = "55%";
				document.getElementsByClassName(func[i])[0].style.left = "10%";
			}

			if (i == 2) {
				document.getElementsByClassName(func[i])[0].style.top = "55%";
				document.getElementsByClassName(func[i])[0].style.left = "40%";
			}

			if (i == 3) {
				document.getElementsByClassName(func[i])[0].style.top = "55%";
				document.getElementsByClassName(func[i])[0].style.left = "70%";
			}

			if (i == 4) {
				document.getElementsByClassName(func[i])[0].style.top = "0%";
				document.getElementsByClassName(func[i])[0].style.left = "40%";
			}

			if (i == 5) {
				document.getElementsByClassName(func[i])[0].style.top = "105%";
				document.getElementsByClassName(func[i])[0].style.left = "10%";
			}

			if (i == 6) {
				document.getElementsByClassName(func[i])[0].style.top = "105%";
				document.getElementsByClassName(func[i])[0].style.left = "40%";
			}

			if (i == 7) {
				document.getElementsByClassName(func[i])[0].style.top = "105%";
				document.getElementsByClassName(func[i])[0].style.left = "70%";
			}

			if (i == 8) {
				document.getElementsByClassName(func[i])[0].style.top = "0%";
				document.getElementsByClassName(func[i])[0].style.left = "70%";
			}

		}

	} 
	
	if (func.length == 10) {
		document.getElementsByClassName("buttonsActions")[0].style.top = "75%";

		for (var i = 0; i < func.length; i++) {

			if (i == 0) {
				document.getElementsByClassName(func[i])[0].style.top = "0%";
				document.getElementsByClassName(func[i])[0].style.left = "5%";
			}

			if (i == 1) {
				document.getElementsByClassName(func[i])[0].style.top = "55%";
				document.getElementsByClassName(func[i])[0].style.left = "17%";
			}

			if (i == 2) {
				document.getElementsByClassName(func[i])[0].style.top = "55%";
				document.getElementsByClassName(func[i])[0].style.left = "42%";
			}

			if (i == 3) {
				document.getElementsByClassName(func[i])[0].style.top = "55%";
				document.getElementsByClassName(func[i])[0].style.left = "67%";
			}

			if (i == 4) {
				document.getElementsByClassName(func[i])[0].style.top = "0%";
				document.getElementsByClassName(func[i])[0].style.left = "28%";
			}

			if (i == 5) {
				document.getElementsByClassName(func[i])[0].style.top = "105%";
				document.getElementsByClassName(func[i])[0].style.left = "17%";
			}

			if (i == 6) {
				document.getElementsByClassName(func[i])[0].style.top = "105%";
				document.getElementsByClassName(func[i])[0].style.left = "42%";
			}

			if (i == 7) {
				document.getElementsByClassName(func[i])[0].style.top = "105%";
				document.getElementsByClassName(func[i])[0].style.left = "67%";
			}

			if (i == 8) {
				document.getElementsByClassName(func[i])[0].style.top = "0%";
				document.getElementsByClassName(func[i])[0].style.left = "78%";
			}
			
			if (i == 9) {
				document.getElementsByClassName(func[i])[0].style.top = "0%";
				document.getElementsByClassName(func[i])[0].style.left = "52%";
			}

		}
	}

}

function cargarCerrarTab() {

	var iframePosition = frameElement.getAllPrevious('iframe.tabContent').length - 1;

	var topParent = window;
	var tabContainer = topParent.$('tabContainer');
	while (tabContainer == null && topParent != topParent.parent) {
		topParent = topParent.parent;
		tabContainer = topParent.$('tabContainer');
	}

	if (tabContainer != null && tabContainer.tabs) {

		var tabPosition = tabContainer.tabs.length - (iframePosition + 2);

		var tab = tabContainer.tabs[tabPosition]

		tab.getElement('span.remover').closeTab = function() {

			var tab_X = this.tab;

			showConfirm(MSG_CLOSE_TAB, "", function(confirm) {

				if (confirm) {
					tab_X.container.removeTab(tab_X);
				} else {

				}

			}, undefined);
		};

	} else {
		if (window.console) {
			console.log(MSG_ERROR_TAB);
		}	
	}

}

function favoritoIcono() {

	var nroExp = getNroExpe();

	var xmlHttp = getXmlHttp();
	xmlHttp.onreadystatechange = function() {
		if (xmlHttp.readyState == 4 && xmlHttp.status == 200) {

			var favorito = xmlHttp.responseText;

			if (favorito.indexOf("true") != -1) {
				document.getElementById("imgFavorite").style.background = "url(" + getUrlApp() + "/expedientes/iconos/favOn_12.png)";
			}

			if (favorito.indexOf("false") != -1) {
				document.getElementById("imgFavorite").style.background = "url(" + getUrlApp() + "/expedientes/iconos/fav_12.png)";
			}

		}
	};

	var URL = getUrlApp() + "/expedientes/getFavoriteState.jsp?nroExp=" + nroExp + TAB_ID_REQUEST;
	xmlHttp.open("POST", URL, true);
	xmlHttp.send(null);

}

function helpVideo() {

	var funcionalidad = ApiaFunctions.getForm('TABSBUTTONS').getField("TAB_A_MOSTRAR").getValue();
	var URL = getUrlApp() + "/expedientes/videos/helpVideo.jsp?context=" + getUrlApp() + "&video=" + funcionalidad + "&" + TAB_ID_REQUEST;

	var tab = {
		title : "Video de ayuda",
		url : URL
	};
	parent.tabContainer.addNewTab(tab.title, tab.url);

}

function downloadModal() {

	var expediente = getNroExpe();

	var URL = getUrlApp() + "/templates/modalDownloadRealizarActuacion.jsp?nroExp=" + expediente + "&size=" + getSizeExpe();
	window.status = URL;
	var modal = ModalController.openWinModal(URL + TAB_ID_REQUEST, 650, 190, null, null, true, false, false);

	modal.addEvent('confirm', function(action) {

		if (action == ACTION_DESCARGA) {

			var xmlHttpLimt = getXmlHttp();
			xmlHttpLimt.onreadystatechange = function() {

				if (xmlHttpLimt.readyState == 4 && xmlHttpLimt.status == 200) {

					var limit = xmlHttpLimt.responseText;

					if (checkSize(limit + " " + LIMIT_PRMT_PIEZAS_UNIT)) {
						document.getElementsByClassName("download")[0].click();
					} else {
						
						var urlPiezas = getUrlApp() + "/expedientes/piezas/piezasFormaDocumental.jsp?nro=" + expediente + "&tamanio=" + limit + TAB_ID_REQUEST;
						
						var tab = {
							title : "Piezas del expediente " + expediente,
							url : urlPiezas
						};
						parent.tabContainer.addNewTab(tab.title, tab.url);

					}

				}

			};

			var urlLimt = getUrlApp() + "/expedientes/piezas/getPiezasPrmtLimit.jsp?" + TAB_ID_REQUEST;
			xmlHttpLimt.open("POST", urlLimt, true);
			xmlHttpLimt.send(null);

		} else {
			downloadUltimasActuaciones(action);
		}

	});

}

function downloadUltimasActuaciones(cantidad) {

	var expeDec = getNroExpe();
	var expeEnc = btoa(expeDec);

	var xmlHttp = getXmlHttp();
	xmlHttp.onreadystatechange = function() {
		if (xmlHttp.readyState == 4 && xmlHttp.status == 200) {

			if (xmlHttp.responseText.startsWith("no")) {
				showMessage(MSG_SIN_PERMISO_ACT);
			} else {

				var xmlHttpUA = getXmlHttp();
				xmlHttpUA.onreadystatechange = function() {
					if (xmlHttpUA.readyState == 4 && xmlHttpUA.status == 200) {

						var path = xmlHttpUA.responseText;
						if (path != "") {
							path = "/expedientes/previsualizar/expedientes/UA_" + expeDec + "_Final.pdf";
							var urlServlet = getUrlApp() + "/GetArchiveFromPathServlet?filePath=" + path + TAB_ID_REQUEST;

							var anchorDownloader = new Element('a', {
								href : urlServlet,
								download : 'UA_' + expeDec + '_Final.pdf'
							}).setStyle('visibility', 'hidden').inject(document.body);
							anchorDownloader.click();
						}

					}
				};

				var URLUA = getUrlApp() + "/expedientes/descarga/pathUltimasActuaciones.jsp?exp=" + expeDec + "&cant=" + parseInt(cantidad) + TAB_ID_REQUEST;
				xmlHttpUA.open("POST", URLUA, true);
				xmlHttpUA.send(null);

			}
		}
	};

	var URL = getUrlApp() + "/expedientes/descarga/controlDescarga.jsp?tipo=FOLIADO&nroExp=" + expeEnc + "&tarea=" + TASK_OTRA + TAB_ID_REQUEST;
	xmlHttp.open("POST", URL, true);
	xmlHttp.send(null);

}

function preview() {

	var expediente = getNroExpe();

	var URL = getUrlApp() + "/templates/modalPreviewRealizarActuacion.jsp?nroExp=" + expediente + "&size=" + getSizeExpe();
	window.status = URL;
	var modal = ModalController.openWinModal(URL + TAB_ID_REQUEST, 675, 190, null, null, true, false, false);

	modal.addEvent('confirm', function(action) {

		if (action == ACTION_PREVIEW) {

			var xmlHttpLimt = getXmlHttp();
			xmlHttpLimt.onreadystatechange = function() {

				if (xmlHttpLimt.readyState == 4 && xmlHttpLimt.status == 200) {
	
					var limit = xmlHttpLimt.responseText;
	
					if (checkSize(limit + " " + LIMIT_PRMT_PIEZAS_UNIT)) {
						previewEjecutar();
					} else {
	
						var urlPiezas = getUrlApp() + "/expedientes/piezas/piezasFormaDocumental.jsp?nro=" + expediente + "&tamanio=" + limit + TAB_ID_REQUEST;
						var tab = {
							title : "Piezas del expediente " + expediente,
							url : urlPiezas
						};
						parent.tabContainer.addNewTab(tab.title, tab.url);
	
					}
	
				}

			};

		var urlLimt = getUrlApp() + "/expedientes/piezas/getPiezasPrmtLimit.jsp?" + TAB_ID_REQUEST;
		xmlHttpLimt.open("POST", urlLimt, true);
		xmlHttpLimt.send(null);

		} else {
			ultimasActuaciones(action);
		}

	});

}

function previewEjecutar() {

	var expeDec = getNroExpe();
	var expeEnc = btoa(expeDec);

	var xmlHttp = getXmlHttp();
	xmlHttp.onreadystatechange = function() {
		if (xmlHttp.readyState == 4 && xmlHttp.status == 200) {

			if (xmlHttp.responseText.startsWith("no")) {
				showMessage(MSG_SIN_PERMISO_FILE);
			} else {

				var xmlHttpPrev = getXmlHttp();
				xmlHttpPrev.onreadystatechange = function() {
					if (xmlHttpPrev.readyState == 4 && xmlHttpPrev.status == 200) {
						var tab = {
							title : "Exp. " + expeDec,
							url : getUrlApp() + "/expedientes/previsualizar/previewExpediente.jsp?tipo=FOLIADO&nroExp=" + expeEnc + "&tarea=" + TASK_OTRA + TAB_ID_REQUEST
						};
						parent.tabContainer.addNewTab(tab.title, tab.url);
					}
				};

				var pathPreview = getUrlApp() + "/DownloadServlet?tipo=VER_FOLIADO_PREVIEW&nroExp=" + expeEnc + "&tarea=" + TASK_OTRA + TAB_ID_REQUEST;
				xmlHttpPrev.open("POST", pathPreview, true);
				xmlHttpPrev.send(null);

			}
		}
	};

	var URL = getUrlApp() + "/expedientes/descarga/controlDescarga.jsp?tipo=FOLIADO&nroExp=" + expeEnc + "&tarea=" + TASK_OTRA + TAB_ID_REQUEST;
	xmlHttp.open("POST", URL, true);
	xmlHttp.send(null);

}

function ultimasActuaciones(cantidad) {

	var expeDec = getNroExpe();
	var expeEnc = btoa(expeDec);

	var xmlHttp = getXmlHttp();
	xmlHttp.onreadystatechange = function() {
		if (xmlHttp.readyState == 4 && xmlHttp.status == 200) {

			if (xmlHttp.responseText.startsWith("no")) {
				showMessage(MSG_SIN_PERMISO_ACT);
			} else {
				var tab = {
					title : "Exp. " + expeDec,
					url : getUrlApp() + "/expedientes/previsualizar/ultimasActuaciones.jsp?exp=" + expeDec + "&cant=" + parseInt(cantidad) + TAB_ID_REQUEST
				};
				parent.tabContainer.addNewTab(tab.title, tab.url);
			}

		}
	};

	var URL = getUrlApp() + "/expedientes/descarga/controlDescarga.jsp?tipo=FOLIADO&nroExp=" + expeEnc + "&tarea=" + TASK_OTRA + TAB_ID_REQUEST;
	xmlHttp.open("POST", URL, true);
	xmlHttp.send(null);

}

function showArbol() {

	var expediente = getNroExpe();
	var urlArbol = getUrlApp() + "/expedientes/arbolDelExpediente/arbolEE.jsp?nroEE=" + expediente + "&indice=0&button=disable&usr=" + "<%=uData.getUserId()%>" + TAB_ID_REQUEST;

	var tab = {
		title : "\u00c1rbol del expediente",
		url : urlArbol
	};

	parent.tabContainer.addNewTab(tab.title, tab.url);

}

function favoritoAlterar() {

	var nroExp = getNroExpe();
	var fback = document.getElementById("imgFavorite").style.background;
	var action = "";

	if (fback.indexOf("fav_12") != -1) {
		action = ACTION_MARCAR;
		document.getElementById("imgFavorite").style.background = "url(" + getUrlApp() + "/expedientes/iconos/favOn_12.png)";
	}

	if (fback.indexOf("favOn_12") != -1) {
		action = ACTION_DESMARCAR;
		document.getElementById("imgFavorite").style.background = "url(" + getUrlApp() + "/expedientes/iconos/fav_12.png)";
	}

	var URL = getUrlApp() + "/expedientes/buscador/agregarFavorito.jsp?nroExp=" + nroExp + "&action=" + action + TAB_ID_REQUEST;

	var client = getXmlHttp();
	client.open("POST", URL, false);
	client.send();

}

function actuar() {

	var myForm = ApiaFunctions.getForm('TABSBUTTONS');
	var myButton = myForm.getField('ACTUAR');
	myButton.fireClickEvent();

}

function elem_fisc() {

	var myForm = ApiaFunctions.getForm('TABSBUTTONS');
	var myButton = myForm.getField('ELEM_FISICA');
	myButton.fireClickEvent();

}

function acc_rest() {

	var myForm = ApiaFunctions.getForm('TABSBUTTONS');
	var myButton = myForm.getField('ACC_REST');
	myButton.fireClickEvent();

}

function hist() {

	/*
	 * var myForm = ApiaFunctions.getForm('TABSBUTTONS');
	 * var myButton = myForm.getField('HISTORIAL');
	 * myButton.fireClickEvent();
	 */

	var nroExp = getNroExpe();
	var URL = getUrlApp() + "/expedientes/HistorialActuaciones/historialActuaciones.jsp?NroExp=" + nroExp + TAB_ID_REQUEST;
	var w = ModalController.openWinModal(URL, 1000, 510);
	w.setConfirmLabel('Imprimir');

}

function acords() {

	var myForm = ApiaFunctions.getForm('TABSBUTTONS');
	var myButton = myForm.getField('ACORDONADOS');
	myButton.fireClickEvent();

}

function relads() {

	var myForm = ApiaFunctions.getForm('TABSBUTTONS');
	var myButton = myForm.getField('RELACIONADOS');
	myButton.fireClickEvent();

}

function incorporados() {

	var myForm = ApiaFunctions.getForm('TABSBUTTONS');
	var myButton = myForm.getField('INCORPORADOS');
	myButton.fireClickEvent();

}

function val_exhaustiva(envId) {

	var nroExp = getNroExpe();
	var URL = getUrlApp() + "/page/externalAccess/query.jsp?askLogin=N&logFromSession=true&env=" + envId + "&type=P&qryId=2557&filter_att_value_1=" + nroExp + TAB_ID_REQUEST; // "&" +
	ApiaFunctions.openTab("Val. exhaustiva", URL);

}

function modf_cara() {

	var myForm = ApiaFunctions.getForm('TABSBUTTONS');
	var myButton = myForm.getField('MODF_CARA');
	myButton.fireClickEvent();

}

function modf_cara_proceso() {

	var caratula  = ApiaFunctions.getForm('CARATULA');
	var asunto    = caratula.getField("MC_PUEDE_MODIFICAR_ASUNTO").getValue();
	var prioridad = caratula.getField("MC_PUEDE_MODIFICAR_PRIORIDAD").getValue();
	var acc_rest  = caratula.getField("MC_PUEDE_MODIFICAR_ACC_REST").getValue();
	var elem_fisc = caratula.getField("MC_PUEDE_MODIFICAR_ELEM_FISIC").getValue();

	var parametros = "asunto=" + asunto + "&prioridad=" + prioridad + "&acc_rest=" + acc_rest + "&elem_fisc=" + elem_fisc;
	var URL = getUrlApp() + "/templates/modalModificarCaratulaRealizarActuacion.jsp?" + parametros;
	window.status = URL;

	var modal = ModalController.openWinModal(URL + TAB_ID_REQUEST, 500, 186, null, null, true, false, false);
	modal.addEvent('confirm', function(datos) {

		var action = datos.split(",")[0];
		var envId = datos.split(",")[1];

		if (action != "vacio") {
			if (action == "1") {

				var tabsbuttons = ApiaFunctions.getForm("TABSBUTTONS");
				var cambiar_ele_fisc = tabsbuttons.getField("TB_ELEM_FISC_ACTIVOS").getValue();

				if (cambiar_ele_fisc == ELEM_FISIC_DENEGAR) {
					showMessage(MSG_ELEM_FISC_ACTIVOS);
				}

				if (cambiar_ele_fisc == ELEM_FISIC_PERMITIR) {
					var URL = getUrlApp() + "/page/externalAccess/open.jsp?logFromSession=true&onFinish=2&env=" + envId + "&type=P&entCode=3029&proCode=3282&eatt_STR_EXP_TIPO_CAMBIO_CARATULA_STR=" + action + "&onFinish=100&eatt_STR_EXP_NRO_EXPEDIENTE_STR=" + getNroExpe() + TAB_ID_REQUEST;
					var obj = frameElement;
					obj.src = URL;
				}

			} else {
				var URL = getUrlApp() + "/page/externalAccess/open.jsp?logFromSession=true&onFinish=2&env=" + envId + "&type=P&entCode=3029&proCode=3282&eatt_STR_EXP_TIPO_CAMBIO_CARATULA_STR=" + action + "&onFinish=100&eatt_STR_EXP_NRO_EXPEDIENTE_STR=" + getNroExpe() + TAB_ID_REQUEST;
				var obj = frameElement;
				obj.src = URL;
			}

		}

	});

}

function getNroExpe() {

	var caratula = ApiaFunctions.getForm('CARATULA');
	var firma = ApiaFunctions.getForm('FIRMA');
	
	if (caratula) {
		var nroExp = caratula.getField("EXP_NRO_EXPEDIENTE_STR").getValue();
		return nroExp;
	}
	
	if (firma) {
		var firma = ApiaFunctions.getForm('FIRMA');
		var expe = firma.getField("TMP_NRO_DOC_A_FIRMAR_STR").getValue();
		return expe;
	}

}

function checkSize(limit) {

	var unidades = compareUnits(getSizeExpe().split(" ")[1], limit.split(" ")[1]);
	if (unidades == -1) {
		return true;
	}

	if (unidades == 0) {
		if (parseInt(getSizeExpe().split(" ")[0]) <= parseInt(limit.split(" ")[0])) {
			return true;
		}
	}

	return false;

}

function getSizeExpe() {
	return document.getElementById('expSize').innerHTML;
}

// unit1 = unit2 = 0 | unit1 > unit2 = 1 | unit1 < unit2 = -1
function compareUnits(unit1, unit2) {

	switch (unit1) {
		case "KB":
			if (unit2 == "MB" || unit2 == "GB" || unit2 == "TB") {
				return -1;
			}
			break;
	
		case "MB":
			if (unit2 == "KB") {
				return 1;
			} else {
				if (unit2 == "GB" || unit2 == "TB") {
					return -1;
				}
			}
			break;
	
		case "GB":
			if (unit2 == "KB" || unit2 == "MB") {
				return 1;
			} else {
				if (unit2 == "TB") {
					return -1;
				}
			}
			break;
	
		case "TB":
			if (unit2 == "KB" || unit2 == "MB" || unit2 == "GB") {
				return 1;
			}
			break;
	}
	return 0;

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

function customAlert(title, msg, funcConf, funcClose) {
	showMessageCustom(msg, title, "confirm", funcClose);
}

function showMenu(){
	
	document.getElementById("pinHidden").style.display     = "block";
	document.getElementById("menuContainer").style.display = "block";
	document.getElementById("tabHolder").style.width       = "auto";				
	document.getElementById("tabComponent").style.width    = "100%";
	document.getElementById("txtComment").style.width      = "100%";	
	
}

function hiddeMenu() {

	document.getElementById("pinHidden").style.display     = "none";
	document.getElementById("menuContainer").style.display = "none";
	document.getElementById("tabHolder").style.width       = "96%";
	document.getElementById("tabComponent").style.width    = "135%";

	var tas = document.getElementsByTagName("textarea");
	for (var i = 0; i < tas.length; i++) {
		tas[i].style.width = "104%";
	}

	var ghs = document.getElementsByClassName("gridHeader");
	for (var i = 0; i < tas.length; i++) {
		ghs[i].style.width = "104%";
	}

	var gbs = document.getElementsByClassName("gridBody");
	for (var i = 0; i < tas.length; i++) {
		gbs[i].style.width = "104%";
	}

	var gfs = document.getElementsByClassName("gridFooter");
	for (var i = 0; i < tas.length; i++) {
		gfs[i].style.width = "104%";
	}

	document.getElementById("txtComment").style.width = "100%";

}
