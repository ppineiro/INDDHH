
function fnc_1001_1062(evtSource, par_idProcesoOculto, par_nombFormularioActual, par_nomProcesoOculto, par_nroExp) { 
	var form = ApiaFunctions.getForm(par_nombFormularioActual);
	form.getField(par_idProcesoOculto).setValue(lastModalReturn[4]);	
	
	if(par_nomProcesoOculto!=null && par_nomProcesoOculto!='')
			form.getField(par_nomProcesoOculto).setValue(lastModalReturn[5]);

	if(par_nroExp!=null && par_nroExp!='')
			form.getField(par_nroExp).setValue(lastModalReturn[2]);
		
	if (par_nombFormularioActual == 'FRM_ALTA_VINC_PARCIAL'){
		var myForm = ApiaFunctions.getForm("FRM_ALTA_VINC_PARCIAL");
		var myButton = myForm.getField("VER_ACTS_BTN");
		myButton.fireClickEvent();
	}
	
	return true; // END

    


return true; // END
} // END
