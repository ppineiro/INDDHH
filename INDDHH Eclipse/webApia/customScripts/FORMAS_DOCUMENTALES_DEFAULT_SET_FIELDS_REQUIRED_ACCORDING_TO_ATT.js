
function fnc_1001_4018(evtSource, par_nombreFormulario, par_nomAtts, par_nomAttValidator, par_valueValidator) { 
	var arrayAtts = par_nomAtts.split(";");
	var myForm = ApiaFunctions.getForm(par_nombreFormulario);
	var valueAtt = myForm.getField(par_nomAttValidator).getValue();


	for(var j = 0; j < arrayAtts.length; j++){
		if(valueAtt == par_valueValidator ){
			myForm.getField(arrayAtts[j]).setProperty(IProperty.PROPERTY_REQUIRED, false);
		}
	}

return true; // END
} // END
