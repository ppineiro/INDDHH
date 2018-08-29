
function fnc_1001_4176(evtSource, par_formName, par_attName, par_attLabel) { 
// Se obtiene la columna
var myForm = ApiaFunctions.getForm(par_formName);
var att= myForm.getFieldColumn(par_attName);

if(att != null){
//Se obtiene el valor del atributo para la última fila
var attLastValue = myForm.getFieldColumn(par_attName)[att.length -1].getValue();



//Se itera sobre la columna
for(var j = 0; j < att.length; j++){
   for(var i = j+1; i < att.length; i++){			
    if (myForm.getFieldColumn(par_attName)[i].getValue().replace(' ', '') ==  myForm.getFieldColumn(par_attName)[j].getValue().replace(' ', '')){
        alert("El valor " + myForm.getFieldColumn(par_attName)[i].getValue() + " ya existe en la columna " + par_attLabel + ".");
        return false;
        break;
    }                
}
}	
}	



return true; // END
} // END
