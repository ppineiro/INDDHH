
function FORMAS_DOCUMENTALES_MC_BLOQUEAR_REQUERIDOS(evtSource) { 
var formPP = ApiaFunctions.getForm("PROXIMO_PASO");
var formAct = ApiaFunctions.getForm("ACTUACIONES");
formPP.getField("EXP_PROXIMO_PASO_STR").setProperty(IProperty.PROPERTY_REQUIRED, true);
formAct.getField("EXP_ACTUACION_STR").setProperty(IProperty.PROPERTY_REQUIRED, true);
formAct.getField("EXP_TIPO_ACTUACION_ENUM").setProperty(IProperty.PROPERTY_REQUIRED, true);

return true; // END

return true; // END
} // END
