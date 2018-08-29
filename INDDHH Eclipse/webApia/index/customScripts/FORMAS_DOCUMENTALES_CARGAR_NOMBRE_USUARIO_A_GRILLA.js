
function fnc_1001_3916(evtSource, par_attributo, par_formulario) { 
	var frmActual = ApiaFunctions.getForm(par_formulario); 
	var i = evtSource.index;
	frmActual.getFieldColumn(par_attributo)[i].setValue(lastModalReturn[3]);	
return true; // END
} // END