function fnc_1001_4342(evtSource) { 
	var myForm = ApiaFunctions.getForm("FRM_OTROS_DATOS_USR");
	var valEmailNecesario = myForm.getField('ADM_DESC_RECIBIR_NOTIF_EMAIL_EXP_STR').getValue();
	var form = ApiaFunctions.getForm("USERCREATION");
	if (valEmailNecesario == 2){
		form.getField("A_EMAIL").setProperty(IProperty.PROPERTY_REQUIRED, true);
	}else{
		form.getField("A_EMAIL").setProperty(IProperty.PROPERTY_REQUIRED, false);
	}
	return true; // END
} // END
