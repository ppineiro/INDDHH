
function FORMAS_DOCUMENTALES_JS_REDIRECT_TO_PIEZAS(evtSource) {
	
	var form = ApiaFunctions.getForm('PIEZAS_VER_PIEZAS_FORMA_DOCUMETAL');
	var nroFomDdoc = form.getField("PIEZAS_NRO_FORMA_DOC_STR").getValue();
	
	if(nroFomDdoc == ""){
		alert("Debe ingresar el n\u00famero de expediente para poder ver sus piezas.");
	} else {		
		var URL = getUrlApp() + "/expedientes/piezas/piezasFormaDocumental.jsp?context=" + getUrlApp() + "&nro=" + nroFomDdoc + TAB_ID_REQUEST;
		var tab = { title: "Piezas del expediente " + nroFomDdoc , url: URL };
		parent.tabContainer.addNewTab(tab.title, tab.url);		
	}	
	
return true; // END
} // END
