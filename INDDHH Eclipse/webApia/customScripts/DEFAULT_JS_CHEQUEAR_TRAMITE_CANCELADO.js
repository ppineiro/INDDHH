
function DEFAULT_JS_CHEQUEAR_TRAMITE_CANCELADO(evtSource, par_form) { 
//alert(ApiaFunctions.getForm("TRM_TITULO").getField("TRM_DESCARTADO_STR").getValue());
var nomForm = par_form;
var valor = ApiaFunctions.getForm(nomForm).getField("TRM_PROCESO_CANCELADO_STR").getValue();
if(valor == "SI") {      
  //alert("El usuario ya está registrado. Se cancela el trámite");
	
  var URL_PAGINA_MSG = CONTEXT + "/portal/paginaMensajes.jsp?d=1" + TAB_ID_REQUEST;
  var usuario = CURRENT_USER_LOGIN; 
  if ( usuario.indexOf('guest') > -1 ){
	if (parent.parent.document != null) {
        parent.parent.document.location.href= URL_PAGINA_MSG;
    } else if (parent.document != null) {
        parent.document.location.href= URL_PAGINA_MSG;
    } else if (document != null) {
        document.location.href= URL_PAGINA_MSG;    
    }  
  } else {
	/*
    var par = window.parent;
	while(par && par.name != "workArea"){
		par=par.parentNode;
	}
	if(par){
		//estas en un open
	} else {
		//no estas en el open
		ApiaFunctions.closeCurrentTab();
	}
	*/
    if (window.parent.location.href.indexOf('open.jsp') ==-1){
		//ApiaFunctions.closeCurrentTab();
	}
    
    document.location.href= URL_PAGINA_MSG;
  }
}





















return true; // END
} // END
