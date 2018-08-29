
function fnc_1001_3898(evtSource) { 
	var myForm = ApiaFunctions.getForm("ALARMAS");
	var myButton = myForm.getField("BTN_LLAMAR_CLASE");
	myButton.fireClickEvent();

	return true; // END
} // END
