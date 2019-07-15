
function DEFAULT_JS_CHEQUEAR_TRAMITE_DESCARTADO(evtSource) { 
	var valor = ApiaFunctions.getForm("TRM_TITULO").getField("TRM_DESCARTADO_STR").getValue();

	var URL_SALIDA = CONTEXT + "/portal/redirectSLO.jsp?url="+URL_RETORNO + TAB_ID_REQUEST;           

	if(valor == "SI") {      
	    if (EXTERNAL_ACCESS=="true"){
			window.top.location = URL_SALIDA;
	    }else{
	    	ApiaFunctions.closeCurrentTab();	      	    
	    }    

      //window.top.location = URL_SALIDA;
      
	}
	


return true; // END
} // END
