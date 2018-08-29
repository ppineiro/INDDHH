
function fnc_1001_1190(evtSource) { 
	//No es confidencial
	var myForm = ApiaFunctions.getForm("CARATULA");
	if (document.getElementById("btnConf")!=null && myForm.getField("EXP_CONFIDENCIALIDAD_ENUM").getValue() == "1"){
		//msg = "¿Realmente desea Confirmar la actuación?\nAtención: Una vez confirmado no se puede modificar la actuación.";
		msg = "¿Realmente desea Confirmar la actuación?\n";
	
	}
	//Es confidencial
	if (document.getElementById("btnConf")!=null && myForm.getField("EXP_CONFIDENCIALIDAD_ENUM").getValue() == "2"){
		//msg = "¿Realmente desea Confirmar la actuación y pasar este expediente confidencial?\nAtención: Una vez confirmado no se puede modificar la actuación.";
		msg = "¿Realmente desea Confirmar la actuación ?\n";
	
	}
	
	/*if (document.getElementById("btnConf")!=null) {
		if(!confirm(msg)){
	 	return false;
		}
	}*/
	return true; // END



return true; // END
} // END
