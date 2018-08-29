
function fnc_1001_4207(evtSource) { 
var myForm = ApiaFunctions.getForm("FRM_PERMISOS_USUARIO")
var bandera = myForm.getField("BANDERA_SIN_UOS_STR").getValue();
if(myForm.getField("btnConf")!=null && bandera == 'si'){
	myForm.getField("btnConf").setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN, true);
}

return true; // END
} // END
