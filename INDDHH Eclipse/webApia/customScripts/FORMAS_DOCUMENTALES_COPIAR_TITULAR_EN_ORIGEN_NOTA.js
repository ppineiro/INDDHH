
function fnc_1001_1422(evtSource) { 
var tipoTitular = document.getElementById('NOTA_DATOS_RECEPCION_EXP_TIPO_TITULAR_ENUM');
var indiceSeleccion = tipoTitular.getValue();
var textoSeleccion = tipoTitular[indiceSeleccion].innerHTML;

document.getElementById('NOTA_DATOS_RECEPCION_NTA_ORIGEN_STR').setValue(textoSeleccion);

return true; // END
} // END
