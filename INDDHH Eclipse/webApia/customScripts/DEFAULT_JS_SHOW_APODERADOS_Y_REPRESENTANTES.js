
function DEFAULT_JS_SHOW_APODERADOS_Y_REPRESENTANTES(evtSource) { 
//alert("JS_SHOW_APODERADOS_Y_REPRESENTANTES");
var form = ApiaFunctions.getForm("URSEC_FRM_PET_REC_DATOS_RECURRENTES");
var showAyR = form.getField("URSEC_SHOW_APODERADOS_Y_REPRESENTANTES").getValue();
//alert("showAyR: " + showAyR);
if (showAyR == "SI"){
	var URL = URL_APP + "/portal/Requisitos_Reg_PyE/apoderadosYRepresentantes.jsp?a=1" + TAB_ID_REQUEST;
	//alert("URL: " + URL);
	var modal =  ModalController.openWinModal(URL + TAB_ID_REQUEST, 800, 400);
}

form.getField("URSEC_SHOW_APODERADOS_Y_REPRESENTANTES").setValue("NO");
showAyR = form.getField("URSEC_SHOW_APODERADOS_Y_REPRESENTANTES").getValue();
//alert("showAyR: " + showAyR);
return true; // END
} // END
