
function DEFAULT_PAGAR_WEB_GW_ITC(evtSource) { 
var formDatosPagosWeb = ApiaFunctions.getForm("TRM_DATOS_GW_ITC_PAGOS");//este es el formulario que tiene todos los campos ocultos
var formAEnviar = new Element('form');

if(!isMonitor){
formAEnviar.set('method', 'POST');

//formAEnviar.set('action', ApiaFunctions.getRootPath() + '/page/generic/pagosWeb.jsp');
//formAEnviar.set('action', ApiaFunctions.getRootPath() + '/page/generic/sitioGwItcsimulado.jsp');
//formAEnviar.set('action', 'http://www.testing1.hg.com.uy/Gateway/Interface/default.aspx');
//formAEnviar.set('target', '_blank');
var urlSitioItc = formDatosPagosWeb.getField("urlSitioItc").getValue();
formAEnviar.set('action', urlSitioItc);

formAEnviar.inject(document.body);

//Completar campos

var IdOrganismo = formDatosPagosWeb.getField("IdOrganismo").getValue();
var campoIdOrganismo = new Element('input');
campoIdOrganismo.set('name', 'IdOrganismo');
campoIdOrganismo.set('value', IdOrganismo);
campoIdOrganismo.inject(formAEnviar);

var IdSol = formDatosPagosWeb.getField("IdSol").getValue();
var campoIdSol = new Element('input');
campoIdSol.set('name', 'IdSol');
campoIdSol.set('value', IdSol);
campoIdSol.inject(formAEnviar);

var IdTramite = formDatosPagosWeb.getField("IdTramite").getValue();
var campoIdTramite = new Element('input');
campoIdTramite.set('name', 'IdTramite');
campoIdTramite.set('value', IdTramite);
campoIdTramite.inject(formAEnviar);

var Cantidad = formDatosPagosWeb.getField("Cantidad").getValue();
var campoCantidad = new Element('input');
campoCantidad.set('name', 'Cantidad');
campoCantidad.set('value', Cantidad);
campoCantidad.inject(formAEnviar);

var ImporteTasa1 = formDatosPagosWeb.getField("ImporteTasa1").getValue();
ImporteTasa1 = ImporteTasa1.replace(".",",");
if(ImporteTasa1.split(",").length == 2){
	if(ImporteTasa1.split(",")[1] == 0){
		//Si es un 300,0 por ejemplo, lo dejo en 300
		ImporteTasa1 = ImporteTasa1.split(",")[0];
	}
}	
var campoImporteTasa1 = new Element('input');
campoImporteTasa1.set('name', 'ImporteTasa1');
campoImporteTasa1.set('value', ImporteTasa1);
campoImporteTasa1.inject(formAEnviar);

var ImporteTasa2 = formDatosPagosWeb.getField("ImporteTasa2").getValue();
ImporteTasa2 = ImporteTasa2.replace(".",",");
if(ImporteTasa2.split(",").length == 2){
	if(ImporteTasa2.split(",")[1] == 0){
		//Si es un 300,0 por ejemplo, lo dejo en 300
		ImporteTasa2 = ImporteTasa2.split(",")[0];
	}
}
var campoImporteTasa2 = new Element('input');
campoImporteTasa2.set('name', 'ImporteTasa2');
campoImporteTasa2.set('value', ImporteTasa2);
campoImporteTasa2.inject(formAEnviar);

var ImporteTasa3 = formDatosPagosWeb.getField("ImporteTasa3").getValue();
ImporteTasa3 = ImporteTasa3.replace(".",",");
if(ImporteTasa3.split(",").length == 2){
	if(ImporteTasa3.split(",")[1] == 0){
		//Si es un 300,0 por ejemplo, lo dejo en 300
		ImporteTasa3 = ImporteTasa3.split(",")[0];
	}
}
var campoImporteTasa3 = new Element('input');
campoImporteTasa3.set('name', 'ImporteTasa3');
campoImporteTasa3.set('value', ImporteTasa3);
campoImporteTasa3.inject(formAEnviar);

var TipoOperacion = formDatosPagosWeb.getField("TipoOperacion").getValue();
var campoTipoOperacion = new Element('input');
campoTipoOperacion.set('name', 'TipoOperacion');
campoTipoOperacion.set('value', TipoOperacion);
campoTipoOperacion.inject(formAEnviar);

var FechaVto = formDatosPagosWeb.getField("FechaVto").getValue();
var campoFechaVto = new Element('input');
campoFechaVto.set('name', 'FechaVto');
campoFechaVto.set('value', FechaVto);
campoFechaVto.inject(formAEnviar);

var CodsDesglose = formDatosPagosWeb.getField("CodsDesglose").getValue();
var campoCodsDesglose = new Element('input');
campoCodsDesglose.set('name', 'CodsDesglose');
campoCodsDesglose.set('value', CodsDesglose);
campoCodsDesglose.inject(formAEnviar);

var MontosDesglose = formDatosPagosWeb.getField("MontosDesglose").getValue();
MontosDesglose = MontosDesglose.replace(".",",");
var campoMontosDesglose = new Element('input');
campoMontosDesglose.set('name', 'MontosDesglose');
campoMontosDesglose.set('value', MontosDesglose);
campoMontosDesglose.inject(formAEnviar);

var Referencia = formDatosPagosWeb.getField("Referencia").getValue();
var campoReferencia = new Element('input');
campoReferencia.set('name', 'Referencia');
campoReferencia.set('value', Referencia);
campoReferencia.inject(formAEnviar);

var UsuarioPeu = formDatosPagosWeb.getField("UsuarioPeu").getValue();
var campoUsuarioPeu = new Element('input');
campoUsuarioPeu.set('name', 'UsuarioPeu');
campoUsuarioPeu.set('value', UsuarioPeu);
campoUsuarioPeu.inject(formAEnviar);

var ConsumidorFinal = formDatosPagosWeb.getField("ConsumidorFinal").getValue();
var campoConsumidorFinal = new Element('input');
campoConsumidorFinal.set('name', 'ConsumidorFinal');
campoConsumidorFinal.set('value', ConsumidorFinal);
campoConsumidorFinal.inject(formAEnviar);

var NumeroFactura = formDatosPagosWeb.getField("NumeroFactura").getValue();
var campoNumeroFactura = new Element('input');
campoNumeroFactura.set('name', 'NumeroFactura');
campoNumeroFactura.set('value', NumeroFactura);
campoNumeroFactura.inject(formAEnviar);
 
//alert("Valores de campos: IdOrganismo: " + campoIdOrganismo.value + " IdSol: " + campoIdSol.value + " IdTramite: " +  campoIdTramite.value + " Cantidad: "+  campoCantidad.value + " Importetasa1: " + campoImporteTasa1.value  + " Importetasa2: " + campoImporteTasa2.value  + " Importetasa3: "+ campoImporteTasa3.value  + " TipoOperacion: "+ campoTipoOperacion.value + " FechaVto: " + campoFechaVto.value + " CodsDesglose: " + campoCodsDesglose.value + " MontosDesglose: " + campoMontosDesglose.value + " Referencia: " + campoReferencia.value + " UsuarioPeu: " + campoUsuarioPeu.value + " ConsumidorFinal: " + campoConsumidorFinal.value + " NumeroFactura: " + campoNumeroFactura.value);

//var numeroOrden = formDatosPagosWeb.getField("numeroOrden").getValue();
//var campoNumeroOrden = new Element('input');
//campoNumeroOrden.set('name', 'numeroOrden');
//campoNumeroOrden.set('value', 'numeroOrden');
//campoNumeroOrden.inject(formAEnviar);

//Enviar
formAEnviar.target='_top';
formAEnviar.submit();
}


return true; // END
} // END
