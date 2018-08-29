
function INDDHH_PAGAR_WEB(evtSource) { 
var formRegistrarPago = ApiaFunctions.getForm("TRM_REGISTRAR_PAGO"); //de acá solo se obtiene el modo de pago
var formDatosPagosWeb = ApiaFunctions.getForm("TRM_DATOS_PAGOS_WEB");//este es el formulario que tiene todos los campos ocultos
var formAEnviar = new Element('form');

formAEnviar.set('method', 'POST');
//formAEnviar.set('action', ApiaFunctions.getRootPath() + '/page/generic/pagosWeb.jsp');
formAEnviar.set('action', 'http://testing.pagosweb.com.uy/v3.4/requestprocessor.aspx');

formAEnviar.inject(document.body);

//Completar campos

//var medioPago = formRegistrarPago.getField("medioPago").getValue();
var idTarjetaCredito = formDatosPagosWeb.getField("idTarjetaCredito").getValue();
var campoIdTarjetaCredito = new Element('input');
campoIdTarjetaCredito.set('name', 'idTarjetaCredito');
campoIdTarjetaCredito.set('value', idTarjetaCredito);
campoIdTarjetaCredito.inject(formAEnviar);

var idCliente = formDatosPagosWeb.getField("idCliente").getValue();
var campoIdCliente = new Element('input');
campoIdCliente.set('name', 'idCliente');
campoIdCliente.set('value', idCliente);
campoIdCliente.inject(formAEnviar);

var primerNombre = formDatosPagosWeb.getField("primerNombre").getValue();
var campoPrimerNombre = new Element('input');
campoPrimerNombre.set('name', 'primerNombre');
campoPrimerNombre.set('value', primerNombre);
campoPrimerNombre.inject(formAEnviar);

var email = formDatosPagosWeb.getField("email").getValue();
//var email = formRegistrarPago.getField("emailParaPago").getValue();//Se obtiene del mail que se le pide antes de presionar el botón de Pagar
var campoEmail = new Element('input');
campoEmail.set('name', 'email');
campoEmail.set('value', email);
campoEmail.inject(formAEnviar);

var primerApellido = formDatosPagosWeb.getField("primerApellido").getValue();
var campoPrimerApellido = new Element('input');
campoPrimerApellido.set('name', 'primerApellido');
campoPrimerApellido.set('value', primerApellido);
campoPrimerApellido.inject(formAEnviar);

var valorTransaccion = formDatosPagosWeb.getField("valorTransaccion").getValue();
var campoValorTransaccion = new Element('input');
campoValorTransaccion.set('name', 'valorTransaccion');
campoValorTransaccion.set('value', valorTransaccion);
campoValorTransaccion.inject(formAEnviar);

var cantidadCuotas = formDatosPagosWeb.getField("cantidadCuotas").getValue();
var campoCantidadCuotas = new Element('input');
campoCantidadCuotas.set('name', 'cantidadCuotas');
campoCantidadCuotas.set('value', cantidadCuotas);
campoCantidadCuotas.inject(formAEnviar);

var moneda = formDatosPagosWeb.getField("moneda").getValue();
var campoMoneda = new Element('input');
campoMoneda.set('name', 'moneda');
campoMoneda.set('value', moneda);
campoMoneda.inject(formAEnviar);

var numeroOrden = formDatosPagosWeb.getField("numeroOrden").getValue();
//var apia_ids = TAB_ID_REQUEST.split('&'); 
//var tabId = apia_ids[1].split('=')[1];
//var tokenId = apia_ids[2].split('=')[1];
//alert("tabId = " + 'A' + tabId + "tokenId" + 'A' + tokenId);
//el numero de orden ya viene con idProceso+"A"+tabId+"A"+tokenId
var campoNumeroOrden = new Element('input');
campoNumeroOrden.set('name', 'numeroOrden');
campoNumeroOrden.set('value', numeroOrden);
campoNumeroOrden.inject(formAEnviar);

var version = formDatosPagosWeb.getField("version").getValue();
var campoVersion = new Element('input');
campoVersion.set('name', 'version');
campoVersion.set('value', version);
campoVersion.inject(formAEnviar);

var fecha = formDatosPagosWeb.getField("fecha").getValue();
var campoFecha = new Element('input');
campoFecha.set('name', 'fecha');
campoFecha.set('value', fecha);
campoFecha.inject(formAEnviar);

var plan = formDatosPagosWeb.getField("plan").getValue();
var campoPlan = new Element('input');
campoPlan.set('name', 'plan');
campoPlan.set('value', plan);
campoPlan.inject(formAEnviar);

var segundoNombre = formDatosPagosWeb.getField("segundoNombre").getValue();
var campoSegundoNombre = new Element('input');
campoSegundoNombre.set('name', 'segundoNombre');
campoSegundoNombre.set('value', segundoNombre);
campoSegundoNombre.inject(formAEnviar);

var segundoApellido = formDatosPagosWeb.getField("segundoApellido").getValue();
var campoSegundoApellido = new Element('input');
campoSegundoApellido.set('name', 'segundoApellido');
campoSegundoApellido.set('value', segundoApellido);
campoSegundoApellido.inject(formAEnviar);

var direccionEnvio = formDatosPagosWeb.getField("direccionEnvio").getValue();
var campoDireccionEnvio = new Element('input');
campoDireccionEnvio.set('name', 'direccionEnvio');
campoDireccionEnvio.set('value', direccionEnvio);
campoDireccionEnvio.inject(formAEnviar);

var plazoEntrega = formDatosPagosWeb.getField("plazoEntrega").getValue();
var CampoPlazoEntrega = new Element('input');
CampoPlazoEntrega.set('name', 'plazoEntrega');
CampoPlazoEntrega.set('value', plazoEntrega);
CampoPlazoEntrega.inject(formAEnviar);

var telefono = formDatosPagosWeb.getField("telefono").getValue();
var campoTelefono = new Element('input');
campoTelefono.set('name', 'telefono');
campoTelefono.set('value', telefono);
campoTelefono.inject(formAEnviar);

var cedula = formDatosPagosWeb.getField("cedula").getValue();
//var cedula = formRegistrarPago.getField("cedulaParaPago").getValue();//Se obtiene de la cédula que se le pide antes de presionar el botón de Pagar
var campoCedula = new Element('input');
campoCedula.set('name', 'cedula');
campoCedula.set('value', cedula);
campoCedula.inject(formAEnviar);

var consumidorFinal = formDatosPagosWeb.getField("consumidorFinal").getValue();
var campoConsumidorFinal = new Element('input');
campoConsumidorFinal.set('name', 'consumidorFinal');
campoConsumidorFinal.set('value', consumidorFinal);
campoConsumidorFinal.inject(formAEnviar);

var importeGravado = formDatosPagosWeb.getField("importeGravado").getValue();
var campoImporteGravado = new Element('input');
campoImporteGravado.set('name', 'importeGravado');
campoImporteGravado.set('value', importeGravado);
campoImporteGravado.inject(formAEnviar);

var numeroFactura = formDatosPagosWeb.getField("numeroFactura").getValue();
var campoNumeroFactura = new Element('input');
campoNumeroFactura.set('name', 'numeroFactura');
campoNumeroFactura.set('value', numeroFactura);
campoNumeroFactura.inject(formAEnviar);

var transactionSecurityToken = formDatosPagosWeb.getField("transactionSecurityToken").getValue();
var campoTransactionSecurityToken = new Element('input');
campoTransactionSecurityToken.set('name', 'transactionSecurityToken');
campoTransactionSecurityToken.set('value', transactionSecurityToken);
campoTransactionSecurityToken.inject(formAEnviar);

var tipoDocumento = formDatosPagosWeb.getField("tipoDocumento").getValue();
var campoTipoDocumento = new Element('input');
campoTipoDocumento.set('name', 'tipoDocumento');
campoTipoDocumento.set('value', tipoDocumento);
campoTipoDocumento.inject(formAEnviar);



/*var apia_ids = TAB_ID_REQUEST.split('&'); // 
var tabId = apia_ids[1].split('=')[1];
var tokenId = apia_ids[2].split('=')[1];

var campo2 = new Element('input');
campo2.set('name', 'tabId');
campo2.set('value', tabId);

campo2.inject(form);

var campo3 = new Element('input');
campo3.set('name', 'tokenId');
campo3.set('value', tokenId);

campo3.inject(form);*/

//Enviar
formAEnviar.submit();







return true; // END
} // END
