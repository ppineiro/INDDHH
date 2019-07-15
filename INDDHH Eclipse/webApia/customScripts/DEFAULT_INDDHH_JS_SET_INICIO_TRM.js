
function DEFAULT_INDDHH_JS_SET_INICIO_TRM(evtSource, par_nameFrm) { 
var myForm = ApiaFunctions.getEntityForm(par_nameFrm);	
var myField = myForm.getField('INDDHH_INDICADOR_TRAMITE_PRESENCIAL_STR');
var currTaskName = ApiaFunctions.getCurrentTaskName();

if(currTaskName == 'CARGA_DATOS_TRAMITE'){
	myField.setValue(true); //Tramite online
}else{
	if(currTaskName == 'CARGA_DATOS_TRAMITE'){
	myField.setValue(false); //Tramite presencial
}
}



return true; // END
} // END
