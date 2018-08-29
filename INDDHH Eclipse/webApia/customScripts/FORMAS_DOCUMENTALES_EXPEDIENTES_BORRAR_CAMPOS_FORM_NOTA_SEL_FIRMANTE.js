
function fnc_1001_1685(evtSource, par_par_Nombre_Form) { 
try{
var myForm = ApiaFunctions.getForm("NOTA_SELECCION_FIRMANTE");
myForm.getField("NTA_USUARIO_FIRMANTE1_STR").setValue("");
myForm.getField("NTA_NOMBRE_OFICINA_USUARIO_FIRMANTE1_STR").setValue("");
myForm.getField("NTA_OFICINA_USUARIO_FIRMANTE1_STR").setValue("");
} catch ( e)
{ 
alert(e.description);
}

return true; // END
} // END
