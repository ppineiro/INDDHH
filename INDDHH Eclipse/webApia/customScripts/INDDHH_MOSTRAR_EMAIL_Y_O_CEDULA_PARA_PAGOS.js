
function INDDHH_MOSTRAR_EMAIL_Y_O_CEDULA_PARA_PAGOS(evtSource) { 
var formRegistrarPago = ApiaFunctions.getForm('TRM_REGISTRAR_PAGO');
var cmbMedioPago = formRegistrarPago.getField('medioPago');
var campoCedulaParaPago = formRegistrarPago.getField('cedulaParaPago');
var campoEmailParaPago = formRegistrarPago.getField('emailParaPago');

if(cmbMedioPago.getValue() != ""){
  campoEmailParaPago.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN, false);
  if(cmbMedioPago.getValue() == "Abitab" || cmbMedioPago.getValue() == "RedPagos"){
  //Solo se pide la cédula si el medio de pago seleccionado es Abitab o RedPagos  	
  campoCedulaParaPago.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN, false);
  }
  
} else {
  campoEmailParaPago.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN, true);
  campoCedulaParaPago.setProperty(IProperty.PROPERTY_VISIBILITY_HIDDEN, true);
}

return true; // END
} // END
