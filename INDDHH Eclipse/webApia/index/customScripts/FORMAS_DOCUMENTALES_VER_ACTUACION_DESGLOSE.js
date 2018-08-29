
function fnc_1001_1561(evtSource) {
	var myForm = ApiaFunctions.getForm("DESGLOSE_DESGLOSAR");
	var nroExp = myForm.getField("DSGL_NRO_EXP_LBL_FRM").getValue();
	var nomArchivo = myForm.getField("DSGL_ARCHIVO_HIDD_TXT_FRM").getValue();
	
	if(nroExp != "" && nomArchivo != ""){
		verArchivo(nroExp, nomArchivo);
	}
	return true; // END


return true; // END
} // END
