
function fnc_1001_3776(evtSource) {
	var myForm = ApiaFunctions.getForm("FIRMA");
	strAccion = myForm.getField("EXP_MODIFICAR_ACTUACION_STR").getValue();

	if (strAccion == 'PASE_MASIVO'){
		//Si es pase masivo, no hago nada.
	}else{
		if(document.getElementById("btnConf")!=null){
			if (strAccion == ''){	
				if (confirm("\u00BFDesea modificar la actuaci\u00F3n?. En caso de confirmar, el expediente quedar\u00E1 en su Bandeja de Entrada.")){
					return true;
				}else{
					return false;
				}
			}else{
				myForm.getField("EXP_MODIFICAR_ACTUACION_STR").setValue('');
//				try{
//					var win = window.parent;
//					var count=0;
//					while(win.name!="workArea" && count<5){
//						win = win.parent;
//						count++;
//					}
//					win=win.parent;
//					var id = myForm.getField("EXP_ID_QUERY_STR").getValue();
//					win.frames["workArea"].location.href = "toc/redirect.jsp?link=query.TaskListAction.do%3Faction=viewList&query=" + id;
//				}catch(e){
					//En caso que falle lo anterior, se presiona sobre el boton salir, para que el usuario entre manualmente a sus Tareas y la tarea no quede incoerente
					//Lo de arriba puede fallar si Apia modifica la forma en que maneja los tabs o alguna cosa de esas.
					alert(obtenerMensajeMultilenguajeSegunCodigo('MSG_EXPEDIENTE_DISPONIBLE_EN_BANDEJA_ENTRADA_JS',currentLanguage)); //alert('El expediente se encuentra disponible para ser trabajado, en su Bandeja de Entrada en el tab Mis Tareas.');
					//btnExit_click();	
					ApiaFunctions.closeCurrentTab(); 
				//}
			}
			return true; // END
		}
	}
	return true; // END
} // END
