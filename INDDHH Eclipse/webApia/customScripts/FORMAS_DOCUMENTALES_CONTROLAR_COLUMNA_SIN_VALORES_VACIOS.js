
function fnc_1001_4182(evtSource, par_formName, par_attName, par_attLabel) { 
// Se obtiene la columna
var myForm = ApiaFunctions.getForm(par_formName);
var att= myForm.getFieldColumn(par_attName);

//Se itera sobre la columna
if (att != null){
   for(var j = 0; j <att.length; j++){			
       if (myForm.getFieldColumn(par_attName)[j] != null && myForm.getFieldColumn(par_attName)[j].getValue() != null && '' ==  myForm.getFieldColumn(par_attName)[j].getValue().replace(' ', '')){
           alert("No pueden haber valores vacíos en la columna " + par_attLabel + ".");
           return false;
           break;
       }                
   }	
}	


return true; // END
} // END
