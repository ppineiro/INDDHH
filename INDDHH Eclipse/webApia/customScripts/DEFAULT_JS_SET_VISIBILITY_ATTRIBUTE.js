
function DEFAULT_JS_SET_VISIBILITY_ATTRIBUTE(evtSource, par_form, par_combo_evaluar, par_att1, par_att2) { 
var form = ApiaFunctions.getForm(par_form);
var field_combo_evaluar = form.getField(par_combo_evaluar);
var selectedtValueValidacion = field_combo_evaluar.getValue();
var att1 = par_att1.split(";");
var att2 = par_att2.split(";");

/*
for(var i = 0; i < att1.length; i++){
    // Seteo primero lista att1
    var field = form.getField(att1[i]);
  	
	if(selectedtValueValidacion != 3){	
    	// Muestro 
      	field.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN,false);
    	//field.setProperty(IProperty.PROPERTY_REQUIRED,true);
    } else {
      	//Oculto
		field.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN,true);	
		//field.setProperty(IProperty.PROPERTY_REQUIRED,false);
    	field.clearValue(); 
    }
}

for(var i = 0; i < att2.length; i++){
    // Seteo primero lista att2
    var field = form.getField(att2[i]);
  	
	if(selectedtValueValidacion == 3){	
    	// Muestro 
      	field.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN,false);
    	field.setProperty(IProperty.PROPERTY_REQUIRED,true);
    } else {
      	//Oculto
		field.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN,true);	
		field.setProperty(IProperty.PROPERTY_REQUIRED,false);
    	field.clearValue(); 
    }
}
*/

var field = form.getField("DEF_TRM_BO_URL_STR");
	
if( (selectedtValueValidacion != 3)  &&  (selectedtValueValidacion != 4) ){	
	// Muestro 
  	field.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN,false);
	field.setProperty(IProperty.PROPERTY_REQUIRED,true);
} else {
  	//Oculto
	field.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN,true);	
	field.setProperty(IProperty.PROPERTY_REQUIRED,false);
	field.clearValue(); 
}

var field = form.getField("DEF_TRM_BO_CLASE_NEGOCIO_STR");

if(selectedtValueValidacion == 3){	
	// Muestro 
  	field.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN,false);
	field.setProperty(IProperty.PROPERTY_REQUIRED,true);
} else {
  	//Oculto
	field.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN,true);	
	field.setProperty(IProperty.PROPERTY_REQUIRED,false);
	field.clearValue(); 
}

var field = form.getField("DEF_TRM_BO_EMAIL_STR");

if(selectedtValueValidacion == 4){	
	// Muestro 
  	field.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN,false);
	field.setProperty(IProperty.PROPERTY_REQUIRED,true);
} else {
  	//Oculto
	field.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN,true);	
	field.setProperty(IProperty.PROPERTY_REQUIRED,false);
	field.clearValue(); 
}



















return true; // END
} // END
