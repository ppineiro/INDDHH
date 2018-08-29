
function FORMAS_DOCUMENTALES_MC_DESBLOQUEAR_REQUERIDOS(evtSource) { 
var formPP = ApiaFunctions.getForm("PROXIMO_PASO");
var formAct = ApiaFunctions.getForm("ACTUACIONES");
formPP.getField("EXP_PROXIMO_PASO_STR").setProperty(IProperty.PROPERTY_REQUIRED, false);
formAct.getField("EXP_ACTUACION_STR").setProperty(IProperty.PROPERTY_REQUIRED, false);
formAct.getField("EXP_TIPO_ACTUACION_ENUM").setProperty(IProperty.PROPERTY_REQUIRED, false);

return true; // END
} // END
