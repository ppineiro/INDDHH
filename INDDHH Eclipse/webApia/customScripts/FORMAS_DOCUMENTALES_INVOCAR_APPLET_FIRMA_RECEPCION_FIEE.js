
function FORMAS_DOCUMENTALES_INVOCAR_APPLET_FIRMA_RECEPCION_FIEE(evtSource) { 
var form = ApiaFunctions.getForm("FIRMA_RECEPCION_FIEE");
	
if (form.getField("FIRMAR") != null){
	form.getField("FIRMAR").setProperty(IProperty.PROPERTY_READONLY, true);
}

var ua = navigator.userAgent.toLowerCase(),
platform = navigator.platform.toLowerCase(),
UA = ua.match(/(opera|ie|firefox|chrome|trident|version)[\s\/:]([\w\d\.]+)?.*?(safari|(?:rv[\s\/:]|version[\s\/:])([\w\d\.]+)|$)/) || [null, 'unknown', 0],
mode = UA[1] == 'ie' && document.documentMode;
	
if (UA[1] == 'trident'){
	UA[1] = 'ie';
	if (UA[4]) UA[2] = UA[4];
}	
	
var name = (UA[1] == 'version') ? UA[3] : UA[1];
var version = mode || parseFloat((UA[1] == 'opera' && UA[4]) ? UA[4] : UA[2]);
var url = null;
	
	
if(name == 'chrome' && version >= 42){
	url = getUrlApp() + "/expedientes/firma/firmarActuacionchromeSignature.jsp?esMC=false" + TAB_ID_REQUEST;
}else if(name == 'chrome' && version < 42){
	url = getUrlApp() + "/expedientes/firma/firmarActuacion.jsp?esMC=false" + TAB_ID_REQUEST;
}else if(name == 'ie'){
	url = getUrlApp() + "/expedientes/firma/firmarActuacionie.jsp?esMC=false" + TAB_ID_REQUEST;
}else{
	url = getUrlApp() + "/expedientes/firma/firmarActuacion.jsp?esMC=false" + TAB_ID_REQUEST;
}

var modal =  ModalController.openWinModal(url, 420, 235, null, null, true, true, true);
modal.addEvent('confirm', function(sDestino) {
if (sDestino == "OK"){
	// HABILITO EL BOTON DE CONFIRMAR
	document.getElementById("btnConf").setProperty(IProperty.PROPERTY_READONLY, false);
	document.getElementById("btnConf").fireClickEvent();
}
  
document.getElementById("btnConf").setProperty(IProperty.PROPERTY_READONLY, true);

	// HABILITO EL BOTON FIRMAR
	if (form.getField("FIRMAR") != null){
		form.getField("FIRMAR").setProperty(IProperty.PROPERTY_READONLY, false);
	}
});

modal.addEvent('close', function(sDestino) {
	// HABILITO EL BOTON FIRMAR
	if (form.getField("FIRMAR") != null){
		form.getField("FIRMAR").setProperty(IProperty.PROPERTY_READONLY, false);
	}
});
return true; // END
} // END
