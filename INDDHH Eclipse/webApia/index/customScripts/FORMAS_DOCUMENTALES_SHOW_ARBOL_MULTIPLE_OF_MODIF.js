
function fnc_1001_4080(evtSource) { 
//Se crean las variables
var modal =  ModalController.openWinModal(getUrlApp() + "/expedientes/adminUsuarios/armar.jsp?" + TAB_ID_REQUEST, 710, 400, null, null, null, true, true);

var indice = evtSource.index;
var boton;
var att;

modal.onclose=function(){
   //Se obtiene el valor seleciconado y se controla sea válido
   var sDestino=this.returnValue;
   if (sDestino == 'cancel' || sDestino == '' || sDestino == null){			        
      alert("No se ha elegido un destino válido.");
   }
   else{
      if (sDestino.length > 2){	
            //Se setea el atributo auxiliar para la carga de ofcinas con la oficina seleccionada							
	    var frmActual = ApiaFunctions.getForm("FRM_OFICINAS_USUARIO");
	    frmActual.getField("ATT_OFICINAS_OCULTO_STR").setValue(sDestino);
             
		var field = frmActual.getFieldColumn("ATT_TIENE_DEPENDENCIAS_OF_NUM")[indice];
        //Se muestra una ventana dependiendo si tiene o no dependencias
        if (field.getValue() == "1"){	

                //Se crea el mensaje a mostrar y se muestra la ventana	
               	msg = "El usuario tiene tareas adquiridas para la oficina antigua. Presione Aceptar para liberar las tareas y adquirirlas para la nueva oficina o Cancelar para liberarlas.\n";	
                var myForm = ApiaFunctions.getForm("FRM_OFICINAS_USUARIO");
				att = myForm.getField("ATT_MODIFICAR_IMPORTANDO_STR");

                //Se asigna el valor al atributo auxiliar para la modificación
		 if(confirm(msg)){
		   att.setValue("true");
		 }
                 else{
   		    att.setValue("false");
		 }
             }
             //Se presiona el botón que dispara la clase java
			  
              boton = frmActual.getFieldColumn("MODIFICAR_OFICINA")[indice];
              boton.fireClickEvent();				
         }				
      }
   }
return false;


return true; // END
} // END
