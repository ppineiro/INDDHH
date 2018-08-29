
function fnc_1001_1370(evtSource) { 
	//alert("Cargando datos de firma antes");
	var myForm = ApiaFunctions.getForm("FIRMA");
	var objApplet = document.getElementById("appletFirma");
	objApplet.pasarDatosPagina();
	//alert("Cargando datos de firma");
	//alert(document.getElementById("FIRMAR_ACTUACION_TMP_FIRMA_ARCHIVO_1_STR"));	
	var firma1 = document.getElementById("FIRMAR_ACTUACION_TMP_FIRMA_ARCHIVO_1_STR").value;
	//alert(firma1);
	if (firma1 == ''){ 
		alert("No se pudo obtener los datos de la firma.\nContáctese con el administrador del sistema.");
		return false; // END
	}
*/

return true; // END
} // END
