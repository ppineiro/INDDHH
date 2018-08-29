
function INDDHH_DESHABILITAR_BOTON_AL_PRESIONAR(evtSource, par_nameFrm, par_nameBtn, par_nuevoValorAlBoton) { 

try{
	
	var myForm = ApiaFunctions.getEntityForm(par_nameFrm);
  	var myButton = myForm.getField(par_nameBtn);
  	var nomNuevo = par_nuevoValorAlBoton;
  	
  	myButton.setProperty(IProperty.PROPERTY_READONLY,true);
  	myButton.setValue(nomNuevo);
	
}catch(e){
	
}



return true; // END
} // END
