
function DEFAULT_JS_STRING_LARGO_MAXIMO(evtSource, par_nombForm, par_nombAtt, par_cantMin) { 
limpiarErroresFnc();

var form = ApiaFunctions.getForm(par_nombForm);
var field = form.getField(par_nombAtt);
var cantidad = par_cantMin;

if(field != null && field != "")
{

	if(field.getValue().length > cantidad)
    {
      	if(cantidad != 1)
        {
        
          	showMsgError(par_nombForm, par_nombAtt, "Error: Este campo debe tener a lo sumo " + cantidad + " digitos.");
          	field.clearValue();
        
        }else{
        
          	showMsgError(par_nombForm, par_nombAtt, "Error: Este campo debe tener a lo sumo 1 digito.");
         	field.clearValue();
          
        }    

    }

}



















return true; // END
} // END
