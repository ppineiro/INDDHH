
function INDDHH_JS_CHEQUEAR_TRAMITE_DESCARTADO(evtSource) { 
	var valor = ApiaFunctions.getForm("TRM_TITULO").getField("TRM_DESCARTADO_STR").getValue();

	var URL_SALIDA = CONTEXT + "/portal/redirectSLO.jsp?url="+URL_RETORNO + TAB_ID_REQUEST;           

	if(valor == "SI") {      
	    if (EXTERNAL_ACCESS=="true"){
			window.top.location = URL_SALIDA;
	    }else{
	    	ApiaFunctions.closeCurrentTab();	      	    
	    }    

      //window.top.location = URL_SALIDA;
      /*
	  if (CURRENT_USER_LOGIN == "guest") {
		if (parent.parent.document != null) {
	        window.top.location = URL_SALIDA;
	    } else if (parent.document != null) {
	        window.top.location = URL_SALIDA;
	    } else if (document != null) {
	        window.top.location = URL_SALIDA;    
	    }  
	  } else {	                      
	    if (EXTERNAL_ACCESS=="true"){
	    	window.top.location = URL_SALIDA;
	    }else{
	    	ApiaFunctions.closeCurrentTab();	      	    
	    }    
	    //document.location.href= URL_RETORNO  ;
	  }
      */
	}
	


return true; // END
} // END
