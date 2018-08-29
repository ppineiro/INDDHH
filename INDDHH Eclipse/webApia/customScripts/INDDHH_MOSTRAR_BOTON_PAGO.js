
function INDDHH_MOSTRAR_BOTON_PAGO(evtSource) { 
var formRegistrarPago = ApiaFunctions.getForm('TRM_REGISTRAR_PAGO');
var btnPagar = formRegistrarPago.getField('btnPagar');
var cmbMedioPago = formRegistrarPago.getField('medioPago');
var campoCedulaParaPago = formRegistrarPago.getField('cedulaParaPago');
var campoEmailParaPago = formRegistrarPago.getField('emailParaPago');



if(cmbMedioPago.getValue() == "Abitab" || cmbMedioPago.getValue() == "RedPagos"){
	if(campoCedulaParaPago.getValue() != "" && campoEmailParaPago.getValue() != ""){
	//Si ambos campos no estan vacios muestro el botón para pagar
		btnPagar.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN, false);
	} else {
		btnPagar.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN, true);
	}
} else if (cmbMedioPago.getValue() != "" && (cmbMedioPago.getValue() != "Abitab" && cmbMedioPago.getValue() != "RedPagos")){
	//Sino va a existir un medio de pago seleccionado de todas formas distinto que Abitab y RedPagos
	//Solo estando el campo de email no vacío muestro el botón de pagar
	if(campoEmailParaPago.getValue() != "" ){
		btnPagar.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN, false);
	} else {
		btnPagar.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN, true);
	}
} else {
	//Si cambia de medio de pago por ninguno, oculto el botón de pago
	btnPagar.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN, true);
}




return true; // END
} // END
