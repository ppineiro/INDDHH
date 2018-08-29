
function FORMAS_DOCUMENTALES_JS_PONER_TITULO_PREGUNTA(evtSource) { 
var frm = ApiaFunctions.getForm('FRM_AYUDENOS_A_MEJORAR');
var field = frm.getField('ENC_USU_PREGUNTA_STR');
var value = field.getValue();
value = field.getSelectedText();
var obj = document.getElementById("PREGUNTA");

if (value!=''){
	obj.innerHTML = value;
}

return true; // END
} // END
