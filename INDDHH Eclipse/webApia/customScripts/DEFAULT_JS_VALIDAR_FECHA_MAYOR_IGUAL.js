
function DEFAULT_JS_VALIDAR_FECHA_MAYOR_IGUAL(evtSource, par_nomFrm, par_attDesde, par_attHasta) { 
	var myForm = ApiaFunctions.getForm(par_nomFrm);
	var fieldHasta = myForm.getField(par_attHasta);
	if (fieldHasta.getValue()!=""){
                
        var fechaHasta = fieldHasta.getValue();
      
        var fieldDesde = myForm.getField(par_attDesde);
		if (fieldDesde.getValue()!=""){
                
        	var fechaDesde = fieldDesde.getValue();
	        if (!validarFechaMayorIgualQue(fechaDesde, fechaHasta)){
    	      	fieldHasta.setValue("");
	        	showMsgError(par_nomFrm, par_attHasta, "La fecha debe ser mayor o igual a "+fechaDesde);
	        	return false;
	        }              
        }        
	}












return true; // END
} // END
