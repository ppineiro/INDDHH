
function FORMAS_DOCUMENTALES_DES_HABILITAR_CONFIRMAR(evtSource) { 
	try{
		var form = ApiaFunctions.getForm("FIRMA");
		//ApiaFunctions.enableActionButton(ActionButton.BTN_CONFIRM);
		ApiaFunctions.showActionButton(ActionButton.BTN_CONFIRM);//PROVISORIO HASTA QUE EN APIA ARREGLEN EL enableActionButton

		//PASE DE EXPEDIENTES		
		//var myForm = ApiaFunctions.getForm("PROXIMO_PASO");
		//if (myForm.getField("EXP_OPCION_PASE_STR")!=null){				
		//if (myForm.getField("EXP_OPCION_PASE_STR").getValue() == ''){			
		//ApiaFunctions.disableActionButton(ActionButton.BTN_CONFIRM);		//}			
		//}			

		//FRIMA DE DOCUMENTOS
		if (form.getField("TMP_ARCHIVO_A_FIRMAR_1_STR")!=null){				
			if (form.getField("TMP_ARCHIVO_A_FIRMAR_1_STR").getValue() == ''){			

				form.getField("FIRMAR").setProperty(IProperty.PROPERTY_READONLY, false);

				//ocultamos otros botones
				ApiaFunctions.hideActionButton(ActionButton.BTN_RELEASE);
				ApiaFunctions.hideActionButton(ActionButton.BTN_SAVE);
				ApiaFunctions.hideActionButton(OptionButton.BTN_PRINT);
				ApiaFunctions.hideActionButton(ActionButton.BTN_SHARE);
				ApiaFunctions.hideActionButton(OptionButton.BTN_VIEW_DOCS);
				
				var strAccion = form.getField("EXP_MODIFICAR_ACTUACION_STR").getValue();
				if (strAccion == 'PRE_PRO_FIRMA_MULTIPLE'){
					ApiaFunctions.hideActionButton(ActionButton.BTN_PREV);
				}
				
				var nodoComentario = form.getField("TMP_COMENTARIO_STR");
				if (form.getField("TMP_FIRMA_SI_NO_STR")!=null){					
					var nodoFirma = form.getField("TMP_FIRMA_SI_NO_STR");	
					//ApiaFunctions.disableActionButton(ActionButton.BTN_CONFIRM);
					ApiaFunctions.hideActionButton(ActionButton.BTN_CONFIRM);
					//DESCOMENTADO HASTA QUE EN APIA ARREGLEN EL disableActionButton
					if (nodoFirma.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN) == true){
						//estoy en el caso en que no es pase a firma, siempre se firma por eso oculto el boton de confirmar y habilito el de firmar
						nodoComentario.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN, true);
					}else{
						//si entro acá estoy en un pase a firma
						//deshabilitamos el boton confirmar y habilitamos el de firma	
						form.getField("FIRMAR").setProperty(IProperty.PROPERTY_READONLY, false);
						if (form.getField("TMP_FIRMA_SI_NO_STR").getValue() == "2"){
							//si el usuario va a firmar no mostramos campo comentario
							nodoComentario.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN, true);
							nodoComentario.setProperty(IProperty.PROPERTY_REQUIRED, false);
							nodoComentario.setValue('');
						}else{
							//si el usuario no va a firmar mostramos campo comentario
							nodoComentario.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN, false);
							nodoComentario.setProperty(IProperty.PROPERTY_REQUIRED, true);
						}
					}
				}							
			}
		}
	}catch(e){
		alert(e);
	}
	return true; // END
} // END
