
function fnc_1001_2268(evtSource) { 
	try{
		var myForm = ApiaFunctions.getForm("ACTUACIONES");
		if (myForm.getField("EXP_ACTUACION_STR")!=null || document.getElementById("CONTENIDO_MEMO_MEM_CONTENIDO_STR")!=null){
			var obj = getCustomJsp();
					
			if (obj != null){
				
				if (obj.document.getElementById("flag_auto_guardar_exp")!=null){
					obj.document.getElementById("flag_auto_guardar_exp").setValue('');
					obj.document.getElementById("flag_save_actuacion").setValue('');
					obj.document.getElementById("flag_fecha_hora_actual").setValue(getCurrentTime());				
				}
			}
		}			
	}catch(e){
		//alert(e);
	}	
return true; // END
} // END
