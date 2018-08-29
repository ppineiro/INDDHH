function loadDescarga(){
		
	var xmlHttp = getXmlHttp();
	xmlHttp.onreadystatechange = function() {
		if (xmlHttp.readyState==4 && xmlHttp.status==200){
			var size = xmlHttp.responseText.split("\$")[0];	
			
			// TOMO LOS DATOS DESDE LA CARATULA
			var caratula = ApiaFunctions.getForm('CARATULA');
			var descarga = caratula.getField("EXP_LINK_FOLIADO").getValue();
			var datos = descarga.split("&nbsp;");
			
			// CARGO SUBTITULO DEL EXPEDIENTE
			
			var filetext = datos[8].replace("<b>",""); filetext = filetext.replace("</b>","");
			filetext = "<b>" + filetext.split(".")[0] + " [" + size + "]" +"</b>";
			document.getElementById('ExpTitle').innerHTML = filetext;
			
			document.getElementById('expSize').style.display = "none";
			document.getElementById('expSize').innerHTML = size;
			
			// CARGO BOTONES
			var url = datos[10];
			url = url.replace("<a", ""); url = url.replace("href=", ""); url = url.replace(">Descargar</a></td></tr></tbody></table>","");
			var btnDownHtml =				
			"<div title='Descargar Expediente' class='download' onClick="+url+">"+
			"<div id='imgDownload'></div>"+
			"<a href="+url+"></a>"+
			"</div>";
			
			var btnDownModalHtml =
				"<div title='Descargar Expediente' class='downModal' onClick='downloadModal()'>"+
				"<div id='imgDownModal'></div>"+
				"<a href='javascript:downloadModal()'></a>"+
				"<span class='sp_down_1'> Descargar </span>" +
				"<span class='sp_down_2'> Expediente </span>" +
				"</div>";		
			
			var btnPrevHtml =
				"<div title='Previsualizar Expediente' class='preview' onClick='preview()'>"+
				"<div id='imgPreview'></div>"+
				"<a href='javascript:preview()'></a>"+
				"<span class='sp_preview_1'> Previsualizar </span>" +
				"<span class='sp_preview_2'> Expediente </span>" +
				"</div>";
			
			var btnArbolHtml =
				"<div title='Arbol del Expediente' class='arbol' onClick='showArbol()'>"+
				"<div id='imgArbol'></div>"+
				"<a href='javascript:showArbol()'></a>"+
				"<span class='sp_arbol_1'> Arbol del </span>" +
				"<span class='sp_arbol_2'> Expediente </span>" +
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
	
	var getSize = getUrlApp() + "/expedientes/getSizeExpediente.jsp?ee=" + getNroExpe() + TAB_ID_REQUEST;
	xmlHttp.open("POST" , getSize , true);
	xmlHttp.send(null);	
	
}

function downloadModal(){
	var URL = getUrlApp() + "/templates/modalDownloadRealizarActuacion.jsp?nroExp=" + getNroExpe() + "&size=" + getSizeExpe();
	window.status = URL;
	var modal =  ModalController.openWinModal(URL + TAB_ID_REQUEST, 650, 190, null, null, true, false, false);
	
	modal.addEvent('confirm', function(action) {
		
		if(action == "descargar" ){
			document.getElementsByClassName("download")[0].click();
		}else{
			downloadUltimasActuaciones(action);
		}		
	});	
}

function downloadUltimasActuaciones(cantidad){
	var expeDec = getNroExpe();
	var expeEnc = btoa(expeDec);
	var tarea = "TSKOtra";
	
	var xmlHttp = getXmlHttp();	
	xmlHttp.onreadystatechange = function() {		
		if (xmlHttp.readyState==4 && xmlHttp.status==200){
			if(xmlHttp.responseText.startsWith("no")){
				showMessage("Usted no tiene los permisos para ver las actuaciones de este expediente.");
			}else{
				
				var xmlHttpUA = getXmlHttp();				
				xmlHttpUA.onreadystatechange = function() {
					if (xmlHttpUA.readyState==4 && xmlHttpUA.status==200){
						var path = xmlHttpUA.responseText;
						
						if (path != ""){
							path = "/expedientes/previsualizar/expedientes/UA_" + expeDec + "_Final.pdf";
							var urlServlet = getUrlApp() + "/GetArchiveFromPathServlet?filePath=" + path + TAB_ID_REQUEST;
							
							var anchorDownloader = new Element('a', {
								href: urlServlet,
								download: 'UA_' + expeDec + '_Final.pdf'
							}).setStyle('visibility', 'hidden').inject(document.body);
							anchorDownloader.click();
						}
										
					}
				};			
				
				var URLUA = getUrlApp() + "/expedientes/descarga/pathUltimasActuaciones.jsp?exp=" + expeDec + "&cant=" + parseInt(cantidad) + TAB_ID_REQUEST;				
				xmlHttpUA.open("POST" , URLUA , true);
				xmlHttpUA.send(null);			
			}
		}		
	};	
	
	var URL = getUrlApp() + "/expedientes/descarga/controlDescarga.jsp?tipo=FOLIADO&nroExp=" + expeEnc + "&tarea=" + tarea + TAB_ID_REQUEST;
	xmlHttp.open("POST" , URL , true);
	xmlHttp.send(null);	
}

function preview() {
	var URL = getUrlApp() + "/templates/modalPreviewRealizarActuacion.jsp?nroExp=" + getNroExpe() + "&size=" + getSizeExpe();
	window.status = URL;
	var modal =  ModalController.openWinModal(URL + TAB_ID_REQUEST, 675, 190, null, null, true, false, false);
	
	modal.addEvent('confirm', function(action) {
		
		if(action == "preview" ){
			var ejecutar = checkSize();
			if (ejecutar){
				previewEjecutar();		
			}else{				
				var msg = "Este expediente ocupa <b>" + getSizeExpe() + "</b>, la previsualizaci\u00f3n del mismo podr\u00eda demorar o incluso saturar el servicio. Se recomienda consultar el \u00e1rbol del expediente y descargar puntualmente las actuaciones requeridas. Pulse confirmar si a\u00fan as\u00ed desea previsualizarlo, en caso contrario puse cancelar.";				
				
				var URL = getUrlApp() + "/templates/modalConfirmMessage.jsp?msg=" + msg;
				window.status = URL;
				var modal =  ModalController.openWinModal(URL + TAB_ID_REQUEST, 500, 160, null, null, true, false, false);
				
				modal.addEvent('confirm', function(confirm) {
					if (confirm){
						previewEjecutar();
					}		
				});
			}
		}else{
			ultimasActuaciones(action);
		}		
	});
	
}

function previewEjecutar(){
	var expeDec = getNroExpe();
	var expeEnc = btoa(expeDec);
	var tarea = "TSKOtra";
	
	var xmlHttp = getXmlHttp();	
	xmlHttp.onreadystatechange = function() {
		if (xmlHttp.readyState==4 && xmlHttp.status==200){
			if(xmlHttp.responseText.startsWith("no")){			
				showMessage("Usted no tiene los permisos para ver este archivo");
			}else{
				var xmlHttpPrev = getXmlHttp();
				xmlHttpPrev.onreadystatechange = function() {
					if (xmlHttpPrev.readyState==4 && xmlHttpPrev.status==200){								
						var tab = { title: "Exp. " + expeDec, url: getUrlApp() +"/expedientes/previsualizar/previewExpediente.jsp?tipo=FOLIADO&nroExp=" + expeEnc + "&tarea=" + tarea + TAB_ID_REQUEST };
						parent.tabContainer.addNewTab(tab.title, tab.url);
					}
				};				
				
				var pathPreview = getUrlApp() +"/DownloadServlet?tipo=VER_FOLIADO_PREVIEW&nroExp=" + expeEnc + "&tarea=" + tarea + TAB_ID_REQUEST;				
				xmlHttpPrev.open("POST" , pathPreview , true);
				xmlHttpPrev.send(null);				
			}			    	
		}
	};
	
	var URL = getUrlApp() + "/expedientes/descarga/controlDescarga.jsp?tipo=FOLIADO&nroExp=" + expeEnc + "&tarea=" + tarea + TAB_ID_REQUEST;			
	xmlHttp.open("POST" , URL , true);
	xmlHttp.send(null);
}

function ultimasActuaciones(cantidad){
		var expeDec = getNroExpe();
		var expeEnc = btoa(expeDec);
		var tarea = "TSKOtra";		
		
		var xmlHttp = getXmlHttp();		
		xmlHttp.onreadystatechange = function() {
			if (xmlHttp.readyState==4 && xmlHttp.status==200){
				if(xmlHttp.responseText.startsWith("no")){
					showMessage("Usted no tiene los permisos para ver las actuaciones de este expediente.");
				}else{
					var tab = { title: "Exp. " + expeDec, url: getUrlApp() +"/expedientes/previsualizar/ultimasActuaciones.jsp?exp=" + expeDec + "&cant=" + parseInt(cantidad) + TAB_ID_REQUEST };
					parent.tabContainer.addNewTab(tab.title, tab.url);	
				}
			}
		};
		
		var URL = getUrlApp() + "/expedientes/descarga/controlDescarga.jsp?tipo=FOLIADO&nroExp=" + expeEnc + "&tarea=" + tarea + TAB_ID_REQUEST;
		xmlHttp.open("POST" , URL , true);
		xmlHttp.send(null);				
}

function showArbol(){
	var expediente = getNroExpe();
	var urlArbol =  getUrlApp() + "/expedientes/arbolDelExpediente/arbolEE.jsp?nroEE=" + expediente + "&indice=0&button=disable&usr=" + "<%=uData.getUserId()%>" + TAB_ID_REQUEST;
	var tab = { title: "Arbol Expediente " + expediente, url: urlArbol };
	parent.tabContainer.addNewTab(tab.title, tab.url);
}

function getNroExpe(){
	var caratula = ApiaFunctions.getForm('CARATULA');
	var descarga = caratula.getField("EXP_LINK_FOLIADO").getValue();
	var datos = descarga.split("&nbsp;");
	var expe = datos[8];
	expe = expe.replace("<b>Expediente ",""); expe = expe.replace(".pdf</b>","");
	return expe;
}
			
function getSizeExpe(){
	return document.getElementById('expSize').innerHTML;
}

function checkSize(){
	var unidades = compareUnits(getSizeExpe().split(" ")[1] , getSizeLimit().split(" ")[1]);
	if(unidades == -1){
		return true;
	}
	
	if(unidades == 0){
		if (parseInt(getSizeExpe().split(" ")[0]) <= parseInt(getSizeLimit().split(" ")[0])){
			return true;
		} 
	}
	
	return false;
}

function getSizeLimit(){
	return "70 KB";
	//return "100 MB";
}

/*
 * unit1 = unit2 = 0 | unit1 > unit2 = 1 | unit1 < unit2 = -1
 */
function compareUnits (unit1, unit2){
	
	switch (unit1){
		case "KB":
			if (unit2 == "MB" || unit2 == "GB" || unit2 == "TB"){ return -1; }
			break;
			
		case "MB":
			if (unit2 == "KB"){ return 1; }
			else{ if(unit2 == "GB" || unit2 == "TB"){ return -1; } }
			break;
			
		case "GB":
			if (unit2 == "KB" || unit2 == "MB"){ return 1; }else{ if(unit2 == "TB"){ return -1; } }
			break;
			
		case "TB":
			if (unit2 == "KB" || unit2 == "MB" || unit2 == "GB"){ return 1; }
			break;
	}		
	return 0;	
}

function showMenu(){
	document.getElementById("pinHidden").style.display = "block";
	document.getElementById("menuContainer").style.display = "block";
	document.getElementById("tabHolder").style.width = "auto";				
	document.getElementById("tabComponent").style.width = "100%";
	var tas = document.getElementsByTagName("textarea");
	document.getElementById("txtComment").style.width = "100%";			
}

function hiddeMenu(){
	document.getElementById("pinHidden").style.display = "none";
	document.getElementById("menuContainer").style.display = "none";
	document.getElementById("tabHolder").style.width = "96%";
	document.getElementById("tabComponent").style.width = "135%";
	
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

function getXmlHttp(){
	var xmlHttp = null;
	if(window.XMLHttpRequest){
		xmlHttp=new XMLHttpRequest();
	}
	else{
		xmlHttp=new ActiveXObject("Microsoft.XMLHTTP");
	}
	return xmlHttp;
}