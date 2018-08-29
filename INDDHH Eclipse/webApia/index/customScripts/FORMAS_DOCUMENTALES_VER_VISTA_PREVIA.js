
function fnc_1001_1389(evtSource) { 
	var myForm = ApiaFunctions.getForm("ACTUACIONES");
	if (myForm.getField("EXP_HIS_PREVIEW_STR").getValue() != ""){
		var nroExp = myForm.getField("EXP_NRO_EXPEDIENTE_STR").getValue();	
		var nameArchivo = myForm.getField("EXP_HIS_PREVIEW_STR").getValue();		
		verVistaPrevia(nroExp, nameArchivo);
		myForm.getField("EXP_HIS_PREVIEW_STR").setValue("");
	}	
				

return true; // END
} // END
