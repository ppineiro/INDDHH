
function fnc_1001_1394(evtSource) { 
	try{
		if (document.getElementById("ACTUACIONES_EXP_ACTUACION_STR")!=null || document.getElementById("CONTENIDO_MEMO_MEM_CONTENIDO_STR")!=null){
			var obj = getCustomJsp();
					
			if (obj != null){
				
				if (obj.document.getElementById("flag_auto_guardar_exp")!=null){
					obj.document.getElementById("flag_auto_guardar_exp").value = 'true';
					obj.document.getElementById("flag_save_actuacion").value = 'false';
					obj.document.getElementById("flag_fecha_hora_actual").value = getCurrentTime();				
				}
			}
		}			
	}catch(e){
		//alert(e);
	}	



return true; // END
} // END
