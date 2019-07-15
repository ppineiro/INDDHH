
function DEFAULT_INDDHH_SA_JS_VALIDAR_CTD_PARTICIPANTES(evtSource, par_nameFrm, par_nameAtt, par_nameInicioTrm) { 
	var myForm = ApiaFunctions.getEntityForm('INDDHH_SA_FRM_ACTIVIDAD');	
	var myField = myForm.getField('INDDHH_SA_CANT_ESTIMADA_DE_PARTICIPANTES_STR');

	var ctd = myField.getValue();

    if ( parseInt(ctd) > 100 ) 
    {
      showMsgError('INDDHH_SA_FRM_ACTIVIDAD', 'INDDHH_SA_CANT_ESTIMADA_DE_PARTICIPANTES_STR', "La cantidad es mayor a 100.");
      myField.setValue("");
      return false;
    } 
	else
    {
      hideMsgError('INDDHH_SA_FRM_ACTIVIDAD', 'INDDHH_SA_CANT_ESTIMADA_DE_PARTICIPANTES_STR');
    }

    












return true; // END
} // END
