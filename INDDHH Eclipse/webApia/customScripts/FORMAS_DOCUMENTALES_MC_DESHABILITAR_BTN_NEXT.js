
function FORMAS_DOCUMENTALES_MC_DESHABILITAR_BTN_NEXT(evtSource) { 

	var step = ApiaFunctions.getCurrentStep();

	if (step == 2){
		document.getElementById("btnNext").style.display = "none";
	}

return true; // END
} // END
