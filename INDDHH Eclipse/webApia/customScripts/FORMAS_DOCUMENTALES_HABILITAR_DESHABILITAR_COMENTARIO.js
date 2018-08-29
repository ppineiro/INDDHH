
function fnc_1001_1055(evtSource) { 
	if (MSIE6) {
		
		/*//FUNCIONA BIEN CUANDO SE DESACTIVA PERO SE COMPORTA RARO CUANDO SE ACTIVA
		var area=document.getElementById("area_1");		
		alert(window.frames[area.name].document.designMode);
			
		if (document.getElementById("CARATULA_EXP_DOCUMENTO_FISICO_NUM").value == 2){								
			window.frames[area.name].document.designMode="On";
		}else{			
			window.frames[area.name].document.designMode="Off"; 
		}		
		*/
		
	}else{
		/*	
		alert("aca");					
		alert(document.getElementById("CARATULA_EXP_COMENTARIO_DOCUMENTO_FISICO_STR"));
		alert(document.getElementById("CARATULA_EXP_COMENTARIO_DOCUMENTO_FISICO_STR").disabled);
		*/
		var myForm = ApiaFunctions.getForm("CARATULA")
		if (!myForm.getField("EXP_DOCUMENTO_FISICO_NUM").setProperty(IProperty.PROPERTY_READONLY, true)){
	        if (myForm.getField("EXP_DOCUMENTO_FISICO_NUM").getValue() == 2){		
	        	myForm.getField("EXP_COMENTARIO_DOCUMENTO_FISICO_STR").setProperty(IProperty.PROPERTY_READONLY, false);
			}else{		
				myForm.getField("EXP_COMENTARIO_DOCUMENTO_FISICO_STR").setProperty(IProperty.PROPERTY_READONLY, true);
				myForm.getField("EXP_COMENTARIO_DOCUMENTO_FISICO_STR").setValue("");
			}		
		} 
	}
	return true; // END

return true; // END
} // END
