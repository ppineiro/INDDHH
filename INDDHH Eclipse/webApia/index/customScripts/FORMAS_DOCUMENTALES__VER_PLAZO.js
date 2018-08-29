
function fnc_1001_3975(evtSource, par_indxId, par_tipoNum, par_for, par_tipoAct) { 
if (par_indxId.getValue() == ""){
    return true;
}else {
      if (par_indxId.getValue() == null || par_indxId.getValue() == "0") {
    	  alert(obtenerMensajeMultilenguajeSegunCodigo('MSG_SELECCIONAR_PLAZO_JS',currentLanguage)); //alert("Debe seleccionar un plazo");
      }else {
            	openModal("/expedientes/plazoView.jsp?indxId="+par_indxId.getValue()+"&tipoNum="+par_tipoNum.getValue()+"&for="+par_for,600,300);
     }	
}

return true; // END
} // END
