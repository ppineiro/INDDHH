
function INDDHH_JS_CONSTITUIR_DOM_ELEC(evtSource) { 

if (ApiaFunctions.getForm("TRM_FRM_CONST_DOM_EE").getField("TRM_CONT_DOM_EE_UNIDAD_EJECUTORA_STR").getValue() == "1"){
  ApiaFunctions.getForm("TRM_FRM_CONST_DOM_EE").getField("TRM_DOM_EE_URSEC_STR").setValue("Si");
  ApiaFunctions.getForm("TRM_FRM_CONST_DOM_EE").getField("TRM_DOM_EE_URSEC_Y_DINATEL_STR").setValue("No");
}else{
  ApiaFunctions.getForm("TRM_FRM_CONST_DOM_EE").getField("TRM_DOM_EE_URSEC_STR").setValue("Si");
  ApiaFunctions.getForm("TRM_FRM_CONST_DOM_EE").getField("TRM_DOM_EE_URSEC_Y_DINATEL_STR").setValue("Si");
}

return true; // END
} // END
