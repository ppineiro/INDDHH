
function DEFAULT_JS_REDIRECT_COESYS(evtSource, par_form) {  
var myForm = ApiaFunctions.getForm(par_form);
if (par_form=='TRM_TITULO') {
	var field = myForm.getField('TRM_COD_TRAMITE_STR');
	var codTramite = field.getValue();

	var field = myForm.getField('TRM_VISIBILIDAD_STR');
	var visibilidad = field.getValue();

	var modoAut= myForm.getField("TRM_MODO_AUTENTICACION_STR").getValue();

	var noentro = true;
	if (visibilidad != '1') {
  		if (CURRENT_USER_LOGIN == 'guest' ) {
    		noentro = false;
    		top.document.location.href = CONTEXT + '/portal/linkCoesys.jsp?cod_tramite='+codTramite+"&modoAut=" + modoAut;
    		return true;
  		}    
	}

	if (noentro){
   		myForm = ApiaFunctions.getForm('TRM_FRM_EMAIL_USUARIO');
  		if (myForm!=null){    
			myForm.setProperty(IProperty.PROPERTY_FORM_CLOSED, false);    
          	myForm.setProperty(IProperty.PROPERTY_FORM_HIDDEN, false);    
  		} else {
    		myForm = ApiaFunctions.getForm('TRM_FRM_EMAIL_USUARIO_CON_CAPTCHA');
      		if (myForm!=null){    
				myForm.setProperty(IProperty.PROPERTY_FORM_CLOSED, false);   
              	myForm.setProperty(IProperty.PROPERTY_FORM_HIDDEN, false);    
  	  		}	
  		}  
	}  
}






return true; // END
} // END
