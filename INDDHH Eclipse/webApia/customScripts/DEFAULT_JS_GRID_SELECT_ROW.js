
function DEFAULT_JS_GRID_SELECT_ROW(evtSource, par_nameFrm, par_nameGrid) { 
var myForm = ApiaFunctions.getEntityForm(par_nameFrm);
var myGrid = myForm.getField(par_nameGrid); 
/*
var myField = myGrid.getField("URSEC_AUTR_USR_SELECCION");
alert(myField.selectedIndex);

var indice = myField.index;
alert(indice);

var index = myGrid.getSelectedIndexes(true);
alert(index);
 
alert(i + " - " + myGrid.getField("URSEC_AUTR_USR_SELECCION", indice).getValue());

var i = 0;
while (i < 50) {
	if (myGrid.getField("URSEC_AUTR_USR_SELECCION", i) ==null){
		alert(i + " - fin");
		break;
	}else{		
		myGrid.getField("URSEC_AUTR_USR_SELECCION", i).setValue("false",i);
		alert(i + " - " + myGrid.getField("URSEC_AUTR_USR_SELECCION", i).getValue());
	}    
	i++
}

*/

/*var index = myGrid.getSelectedIndexes(true);
myGrid.deleteRow(index);
alert(index);
*/

/*
var index = myGrid.getSelectedIndexes(true);
alert(index);
*/
//myGrid.deleteRow(index);

return true; // END
} // END
