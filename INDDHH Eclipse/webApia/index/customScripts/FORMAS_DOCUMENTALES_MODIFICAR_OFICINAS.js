
function fnc_1001_4079(evtSource) { 
var frmActual = ApiaFunctions.getForm('FRM_OFICINAS_USUARIO');
var indice = evtSource.index;
var boton;
var att;

if (frmActual.getFieldColumn('ATT_TIENE_DEPENDENCIAS_OF_NUM')[indice].getValue() == "1"){		
		msg = "El usuario tiene tareas adquiridas para la oficina antigua. Presione Aceptar para liberar las tareas y adquirirlas para la nueva oficina o Cancelar para liberarlas.\n";	
                att = frmActual.getField('ATT_MODIFICAR_IMPORTANDO_STR');
		if(confirm(msg)){
		 	att.setValue('true');
		}
        else{
   		 	att.setValue('false');
		}
}
var formBtn = ApiaFunctions.getForm('BTN_'+frmActual.getFormName());
boton = formBtn.getFieldColumn('MODIFICAR_OFICINA')[indice];
boton.fireClickEvent();
return true; // END
} // END
