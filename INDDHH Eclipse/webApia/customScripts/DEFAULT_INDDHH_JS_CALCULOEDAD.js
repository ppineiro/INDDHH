
function DEFAULT_INDDHH_JS_CALCULOEDAD(evtSource, par_nomFrm, par_nomAtt, par_nomAttEdad) { 
var myForm = ApiaFunctions.getForm(par_nomFrm);
var field = myForm.getField(par_nomAtt);
var fieldEdad = myForm.getField(par_nomAttEdad);
if (field.getValue()!=""){
	var fechaNac = field.getValue();
  	var fechaHoy = getFechaHoy();
    if (validarFechaMenorQue(fechaNac, fechaHoy)){
      showMsgError(par_nomFrm, par_nomAtt, "La fecha no puede ser posterior a la fecha actual o la fecha actual.");
      fieldEdad.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN, true);
      return false;
    }  else
    {
      fieldEdad.setValue(calcularEdad(fechaNac));
      hideMsgError(par_nomFrm, par_nomAtt);
      fieldEdad.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN, false);
    }            
}

function calcularEdad(fecha) {
    var hoy = new Date();
    var cumpleanos = new Date(fecha);
    var edad = hoy.getFullYear() - cumpleanos.getFullYear();
    var m = hoy.getMonth() - cumpleanos.getMonth();

    if (m < 0 || (m === 0 && hoy.getDate() < cumpleanos.getDate())) {
        edad--;
    }

    return edad;
}





return true; // END
} // END
