function INDDHH_JS_GRID_ADD_ROW(evtSource, par_nameFrm, par_nameGrid, par_maximoFilas) { 
var myForm = ApiaFunctions.getEntityForm(par_nameFrm);
var myGrid = myForm.getField(par_nameGrid); 
var max= par_maximoFilas;

var cols = myGrid.getAllColumns();
var cantFilas = cols[0].length;
var cantCols = cols.length;
var ultFila = (cantFilas)-1;

debugger;

try{
 	if(cantFilas != 0){
for(var i = 0 ; i < cantCols; i++){
if(cols[i][ultFila].fldType == "select" || cols[i][ultFila].fldType == "input"){
if(cols[i][ultFila].getProperty(IProperty.PROPERTY_REQUIRED) && (cols[i][ultFila].getValue() == null || cols[i][ultFila].getValue() == "")){
              showMsgConfirm("warning", "Faltan campos requeridos!", "setFocoObj");
return false;
               }
       	}
}
         

   	if((max == null) ||  (cols[0].length < max)){
 	myGrid.addRow();
ajustarAnchoColumna();
 	
     	
   	}else{
var filas = cols[0].length;
 	if((max != null) && (filas+1 >= max)){
              showMsgConfirm("warning", "Se ha alcanzado el tope de filas permitido", "setFocoObj");
 	}
   	}
   }else{

   	if((max == null) ||  (cols[0].length < max)){
 	myGrid.addRow();
ajustarAnchoColumna();
 	
   	}else{

     	var filas = cols[0].length;
 	if((max != null) && (filas+1 >= max)){
              showMsgConfirm("warning", "Se ha alcanzado el tope de filas permitido", "setFocoObj");
 	}	
         
   	}
   }
}catch(err){
myGrid.addRow();
ajustarAnchoColumna();
}







return true; // END
} // END
