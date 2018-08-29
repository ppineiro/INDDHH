
function fnc_1001_1424(evtSource) { 
var myForm = ApiaFunctios.getForm("CARATULA");
var tipoTitular = myForm.getField('EXP_TIPO_TITULAR_ENUM');


var indiceSeleccion = tipoTitular.getValue();
var textoSeleccion = tipoTitular[indiceSeleccion].innerHTML;

myForm.getField('NTA_DESTINATARIO_STR').setValue(textoSeleccion);


return true; // END
} // END
