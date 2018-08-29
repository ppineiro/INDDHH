
function fnc_1001_4005(evtSource) { 
	var myForm = ApiaFunctions.getForm("OFA_RECIBIR_FIEE");
	var flag = myForm.getField("GRAL_FIRMA_OK_STR").getValue();
	
	if(flag  == 'SI' && document.getElementById("btnConf")!=null){
	   fireEvent(document.getElementById("btnConf"),"click");
	}
	return true; // END
} // END
