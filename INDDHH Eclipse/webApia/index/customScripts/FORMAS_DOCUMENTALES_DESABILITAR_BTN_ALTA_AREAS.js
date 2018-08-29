
function fnc_1001_1225(evtSource) { 
var myForm = ApiaFunctions.getForm("NODO_AREA_ALTA");
myForm.getField("BTN_CONF_CAM").setProperty(IProperty.PROPERTY_READONLY, true);
return true; // END
} // END
