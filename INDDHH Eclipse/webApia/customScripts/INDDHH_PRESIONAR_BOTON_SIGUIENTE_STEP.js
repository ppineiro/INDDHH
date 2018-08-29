
function INDDHH_PRESIONAR_BOTON_SIGUIENTE_STEP(evtSource) { 
	retomarTramite.delay(0.1);
	return true; // END

function retomarTramite(){
	if(CURRENT_TASK_NAME == 'CARGA_DATOS_TRAMITE'){
	  var retoma = ApiaFunctions.getForm("TRM_TITULO").getField("TRM_RETOMA_TRAMITE_STR").getValue();
	  //alert("Valor de retoma " + retoma);
	  if(retoma=='SI'){
		ApiaFunctions.getForm("TRM_TITULO").getField("TRM_RETOMA_TRAMITE_STR").setValue("NO");
	    var stepSiguiente = ApiaFunctions.getForm("TRM_TITULO").getField("TRM_STEP_ACTUAL_NUM").getValue();
	    //alert("Valor de stepActual antes de presionar el boton de siguiente " + stepSiguiente);
	    if(stepSiguiente != 1){
		    //btnSiguiente = $("btnNext").getElement("button");
		    //btnSiguiente.click();
	    	document.getElementById("btnNext").click();	
	    }
	    //ApiaFunctions.hideActionButton(ActionButton.BTN_NEXT);
	  }
	} else if (CURRENT_TASK_NAME == 'CARGA_DATOS_COMUNICACION'){
		  var retoma = ApiaFunctions.getForm("CMN_TITULO").getField("CMN_RETOMA_STR").getValue();
		  //alert("Valor de retoma " + retoma);
		  if(retoma=='SI'){
			ApiaFunctions.getForm("CMN_TITULO").getField("CMN_RETOMA_STR").setValue("NO");
		    var stepSiguiente = ApiaFunctions.getForm("CMN_TTULO").getField("CMN_STEP_ACTUAL_NUM").getValue();
		    //alert("Valor de stepActual antes de presionar el boton de siguiente " + stepSiguiente);
		    if(stepSiguiente != 1){
			    //btnSiguiente = $("btnNext").getElement("button");
			    //btnSiguiente.click();
		    	document.getElementById("btnNext").click();	
		    }
		    //ApiaFunctions.hideActionButton(ActionButton.BTN_NEXT);
		  }
	}
}



return true; // END
} // END
