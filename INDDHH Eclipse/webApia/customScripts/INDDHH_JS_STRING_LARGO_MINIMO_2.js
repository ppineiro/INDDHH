
function INDDHH_JS_STRING_LARGO_MINIMO_2(evtSource, par_nombForm, par_nombAtt, par_cantMin) { 

limpiarErroresFnc();

var form = ApiaFunctions.getForm(par_nombForm);
var field = form.getField(par_nombAtt);
var cantidad = par_cantMin;

if(field != null && field != "")
{

	if(field.getValue().length < cantidad)
    {
      	if(cantidad != 1)
        {
        
          	showMsgError(par_nombForm, par_nombAtt, "Error: Este campo debe tener al menos " + cantidad + " digitos.");
          	field.clearValue();
        
        }else{
        
          	showMsgError(par_nombForm, par_nombAtt, "Error: Este campo no puede estar vac&iacute;o.");
          	field.clearValue();
          
        }    

    }

}
















return true; // END
} // END
