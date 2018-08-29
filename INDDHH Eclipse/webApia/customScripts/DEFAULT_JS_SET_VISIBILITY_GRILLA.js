
function DEFAULT_JS_SET_VISIBILITY_GRILLA(evtSource, par_form, par_attrib, par_grilla, par_valor, par_agregarFila, par_formAtt) { 
var form = ApiaFunctions.getForm(par_form);
var parformAtt = par_formAtt; 
if (parformAtt == null || parformAtt == "") {
	parformAtt=par_form;  
}
var formAtt=ApiaFunctions.getForm(parformAtt);
var attrib = formAtt.getField(par_attrib);
var selectedtValueValidacion = attrib.getValue();
if (selectedtValueValidacion==true) {
	selectedtValueValidacion= "true";
}  
if (selectedtValueValidacion==false) {
	selectedtValueValidacion= "false";
}  

var grilla = par_grilla;
var valor = par_valor;

if (valor == null || valor == "") {
  valor = "2";
}

if (grilla == null || grilla == "") {
  grilla = "PARAMETROS";
}

var field = form.getField(grilla);

if(selectedtValueValidacion == valor){	
	// Muestro 
  	field.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN,false);
} else {
  	//Oculto
	field.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN,true);	
}

















return true; // END
} // END
