
function FORMAS_DOCUMENTALES_RSV_NOTIFICACIONES(evtSource, par_clickOn) { 
var form 			 = ApiaFunctions.getForm('FRM_RSV_NRO_RESERVA');
var attNotAlUtilizar = 'RSV_NRO_EXP_NOTIFICAR';
var attNotPorMail 	 = 'RSV_NRO_EXP_NOT_POR_MAIL';
var attNotPorMsg 	 = 'RSV_NRO_EXP_NOT_POR_MSG';
var attNotGrupos 	 = 'RSV_NRO_EXP_NOT_GRUPOS';
var btnName 		 = 'btnGruNot';
var clickOn 		 = par_clickOn;

if (clickOn == 'chkUtilizar'){
	var checked = form.getField(attNotAlUtilizar).getValue();
	
  	if (checked){
		form.getField(attNotPorMail).setProperty(IProperty.PROPERTY_DISABLED, false);
		form.getField(attNotPorMsg).setProperty(IProperty.PROPERTY_DISABLED, false);
        form.getField(btnName).setProperty(IProperty.PROPERTY_READONLY, false);
	
    }else {
		form.getField(attNotPorMail).setProperty(IProperty.PROPERTY_DISABLED, true);
		form.getField(attNotPorMsg).setProperty(IProperty.PROPERTY_DISABLED, true);
		form.getField(attNotGrupos).setValue("");
		form.getField(btnName).setProperty(IProperty.PROPERTY_READONLY, true);
        form.getField(attNotPorMail).setValue(false);
		form.getField(attNotPorMsg).setValue(false);
	}       	
}

return true; // END
} // END
