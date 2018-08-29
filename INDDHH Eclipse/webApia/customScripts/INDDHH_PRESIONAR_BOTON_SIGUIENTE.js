
function INDDHH_PRESIONAR_BOTON_SIGUIENTE(evtSource) { 
	retomarTramite.delay(0.1);
	return true; // END

function retomarTramite(){
	if(CURRENT_TASK_NAME == 'CARGA_DATOS_TRAMITE'){
	    var stepSiguiente = ApiaFunctions.getForm("TRM_TITULO").getField("TRM_STEP_ACTUAL_NUM").getValue();
	    //alert("Valor de stepActual antes de presionar el boton de siguiente " + stepSiguiente);
	    if(stepSiguiente != 1){
		    //btnSiguiente = $("btnNext").getElement("button");
		    //btnSiguiente.click();
		    document.getElementById("btnNext").click();	
	    }
	    //ApiaFunctions.hideActionButton(ActionButton.BTN_NEXT);
    }
}





return true; // END
} // END
