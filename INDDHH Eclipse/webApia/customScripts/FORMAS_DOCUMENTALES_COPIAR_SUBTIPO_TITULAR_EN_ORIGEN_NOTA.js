
function fnc_1001_1423(evtSource) { 
	var myForm = ApiaFunctions.getForm("CARATULA");
var tipoTitular = myForm.getForm('EXP_TIPO_TITULAR_ENUM');
var indiceSeleccion1 = tipoTitular.getValue();
var textoSeleccion1 = tipoTitular[indiceSeleccion1].innerHTML;

var subTipoTitular = myForm.getField('EXP_SUB_TIPO_TITULAR_ENUM');
var indiceSeleccion2 = subTipoTitular.getValue();
var textoSeleccion2 = subTipoTitular[indiceSeleccion2].innerHTML;

myForm.getField('NTA_ORIGEN_STR').setValue(textoSeleccion1 + ' - ' +textoSeleccion2);

return true; // END
} // END
