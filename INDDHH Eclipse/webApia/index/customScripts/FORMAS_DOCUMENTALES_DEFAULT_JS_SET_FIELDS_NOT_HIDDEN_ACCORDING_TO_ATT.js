
function fnc_1001_4019(evtSource, par_nombreFormulario, par_nomAtts, par_nomAttValidator, par_valueValidator, par_erase) { 
	var arrayAtts = par_nomAtts.split(";");
	
	var arrayAttVal = par_nomAttValidator.split(";");
	var arrayValAttVal = par_valueValidator.split(";");
	var myForm = ApiaFunctions.getForm(par_nombreFormulario);
	var valueAtt = null;
	var valueTrue= null;
	var notHidden = false;
	
	
	for(var i = 0; i < arrayAttVal.length; i++){
		
		valueAtt = myForm.getField(arrayAttVal[i]).getValue();
		if (arrayValAttVal.length > i){
			valueTrue = arrayValAttVal[i];
			
			if (valueTrue != "NOTNULL"){
				notHidden = (valueAtt == valueTrue) || notHidden;
			}else{
				if ((valueAtt != null)&& (valueAtt != ""))
					notHidden = true;
			}
				
		}
	}	
	
	
	for(var j = 0; j < arrayAtts.length; j++){

		if(arrayAtts[j] != ""){
			if(notHidden){
				
				myForm.getField(arrayAtts[j]).setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN, false);
			}else{
				if(par_erase == 'true'){
					myForm.getField(arrayAtts[j]).setValue("");
				}	
				myForm.getField(arrayAtts[j]).setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN, true);
			}
		}
	}


return true; // END
} // END
