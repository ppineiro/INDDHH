
function INDDHH_JS_VALIDAR_EXPRESION_REGULAR(evtSource, par_form, par_field, par_exp_reg, par_mensaje, par_grilla) { 
var valor = evtSource.getValue();
var expreg = new RegExp(par_exp_reg);
var mensaje = par_mensaje;  

if(!expreg.test(valor)) {
   alert(mensaje);
   if (evtSource.isInGrid()){
       var myGrid = ApiaFunctions.getForm(par_form).getField(par_grilla);
       var fieldInGrid = myGrid.getField(par_field, evtSource.index);
   	   fieldInGrid.setValue('');
   } else { 
     ApiaFunctions.getForm(par_form).getField(par_field).setValue('');
     
   } 
}











return true; // END
} // END
