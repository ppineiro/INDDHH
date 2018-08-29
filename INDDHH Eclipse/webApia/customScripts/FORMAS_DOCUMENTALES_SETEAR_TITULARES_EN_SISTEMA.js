
function FORMAS_DOCUMENTALES_SETEAR_TITULARES_EN_SISTEMA(evtSource) { 
    
	var taskName = ApiaFunctions.getCurrentTaskName();
	var myForm = null;	

	if (taskName == "INICIAR EXPEDIENTE") {
    	myForm = ApiaFunctions.getForm("CARATULA");
    }
                                       
	if (taskName == "MODIFICAR_CARATULA") {
    	myForm = ApiaFunctions.getForm("MODIFICAR_CARATULA");
    }	

	var i = evtSource.index;
	
	var cantidadInicioRegistros = 2;
	var separadorDatosPrimarios = myForm.getFieldColumn('EXP_TIT_EXT_ER_DATOS_PRIMARIOS_TMP_STR')[i].getValue();
	var separadorDatosSecundarios = myForm.getFieldColumn('EXP_TIT_EXT_ER_DATOS_SECUNDARIOS_TMP_STR')[i].getValue();
	
	var j = 0;
	var campoDatosPrimarios = '';
	var campoDatosSecundarios = '';
	
	var listaAttsSalida = myForm.getFieldColumn('EXP_TIT_EXT_COL_RES_TIPO_MOSTRAR_TMP_STR')[i].getValue();
	var listaNomsSalida = myForm.getFieldColumn('EXP_TIT_EXT_COL_NAME_MOSTRAR_TMP_STR')[i].getValue();
	
	var arraySalida = listaAttsSalida.split('-');
	var arrayNombreSalida = listaNomsSalida.split('-');
	var elementoDuplaSalida = '';
	var nombreSalida = '';	
	
	while (j < 10){
		
		elementoDuplaSalida = arraySalida[j];
		nombreSalida = arrayNombreSalida[j];
		
		if (elementoDuplaSalida == '1'){
			
			if (campoDatosPrimarios != ''){
				campoDatosPrimarios = campoDatosPrimarios + separadorDatosPrimarios;
			}
			campoDatosPrimarios = campoDatosPrimarios + nombreSalida + ": " + lastModalReturn[ j + cantidadInicioRegistros];
			
		}else if (elementoDuplaSalida == '2'){
			
			if (campoDatosSecundarios != ''){
				campoDatosSecundarios = campoDatosSecundarios + separadorDatosSecundarios;
			}
			campoDatosSecundarios = campoDatosSecundarios + nombreSalida + ": " + lastModalReturn[ j + cantidadInicioRegistros];
		}
		
		j++;
	}
	
	//EXP_TITULAR_DESCRIPCION_STR
	myForm.getFieldColumn('EXP_TITULAR_DESCRIPCION_STR')[i].setValue(campoDatosPrimarios); //lastModalReturn[3] + " " + lastModalReturn[4];
	
	//EXP_TITULAR_OTROS_DATOS_STR
	myForm.getFieldColumn('EXP_TITULAR_OTROS_DATOS_STR')[i].setValue(campoDatosSecundarios); //lastModalReturn[5] + " " + lastModalReturn[6];
	

return true; // END
} // END
