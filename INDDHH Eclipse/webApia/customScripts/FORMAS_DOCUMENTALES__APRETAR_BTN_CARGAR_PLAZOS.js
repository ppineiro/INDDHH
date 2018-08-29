
function fnc_1001_3974(evtSource) { 
var	myForm = ApiaFunctions.getForm("PLAZOS_Y_ALARMAS_TIPO_EXP");
var myButton = myForm.getField("BTN_LLAMAR_CLASE"); 
myButton.fireClickEvent();

return true; // END
} // END
