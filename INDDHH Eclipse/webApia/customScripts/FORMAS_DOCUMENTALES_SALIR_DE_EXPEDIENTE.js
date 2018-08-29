
function fnc_1001_1902(evtSource) {
	var myForm = ApiaFunctions.getForm("PROXIMO_PASO")
	if (myForm.getFieldo("FLAG_EXPEDIENTE_EN_ESPERA")!=null){
		if (myForm.getFieldo("FLAG_EXPEDIENTE_EN_ESPERA").getValue() == 'PASAR'){
			if (myForm.getFieldo("btnExit")!=null){
				myForm.getFieldo("btnExit").fireClickEvent();
			}
		}
	}
	

return true; // END
} // END
