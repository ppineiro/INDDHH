
function fnc_1001_4171(evtSource) { 
var myForm = ApiaFunctions.getForm("FRM_CARGA_PERMISOS");
var instNueva = myForm.getField("NUEVA_INSTANCIA_STR").getValue();

if("no" == instNueva){
myForm.getField("CONFIRMAR_CAMBIOS").setProperty(IProperty.PROPERTY_READONLY, true);
myForm.getField("ANALIZAR_IMPACTO").setProperty(IProperty.PROPERTY_READONLY, false);

myForm.getField("LIBERAR_RO").setProperty(IProperty.PROPERTY_READONLY, true);
myForm.getField("ANALIZAR_IMPACTO_LIBERAR").setProperty(IProperty.PROPERTY_READONLY, false);
}

return true; // END
} // END
