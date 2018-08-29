
function FORMAS_DOCUMENTALES_DisabledBotonConfirmSaveArchivar(evtSource) { 
var myForm = ApiaFunctions.getForm("FRM_DEVOLVER_EXPEDIENTE_ARCHIVO", "E");

var valValidated = myForm.getField("LBL_DEVOlVER_EXP_SIN_PERMISO").getValue();

if(valValidated != ""){
	ApiaFunctions.hideActionButton(ActionButton.BTN_CONFIRM);
  	ApiaFunctions.hideActionButton(ActionButton.BTN_SAVE);

}else{
  	ApiaFunctions.showActionButton(ActionButton.BTN_CONFIRM);
    ApiaFunctions.showActionButton(ActionButton.BTN_SAVE);

}


return true; // END
} // END
