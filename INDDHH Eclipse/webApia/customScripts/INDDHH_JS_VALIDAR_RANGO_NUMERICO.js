
function INDDHH_JS_VALIDAR_RANGO_NUMERICO(evtSource, par_nameFrm, par_nameAtt, par_minimo, par_maximo) { 

limpiarErroresFnc();

var myForm = ApiaFunctions.getEntityForm(par_nameFrm);	
var myField = myForm.getField(par_nameAtt);
var latitudStr = myField.getValue();
latitudStr = latitudStr.trim();

var latitud = parseInt(latitudStr); 

var minimoStr = par_minimo;
var maximoStr = par_maximo;

var minimo = parseInt(minimoStr); 
var maximo = parseInt(maximoStr); 

 //Compruebo si es un valor numerico 
if (isNaN(latitud)) { 
  showMsgError(par_nameFrm, par_nameAtt, "Error: El atributo debe ser numerico.");
  myField.setValue("");
  return false;
}else{
  
  if ((latitud < minimo) || (latitud > maximo)) {						
	showMsgError(par_nameFrm, par_nameAtt, "Error: El valor debe estar entre " + minimoStr + " y " + maximoStr);
    myField.setValue("");
    return false;
  }
  
//  if ((latitudStr < minimoStr) || (latitudStr > maximoStr)) {						
//	showMsgError(par_nameFrm, par_nameAtt, "Error: El valor debe estar entre " + minimoStr + " y " + maximoStr);
//    myField.setValue("");
//    return false;
//  }
}

return true; // END
} // END
