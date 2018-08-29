
function fnc_1001_3925(evtSource) { 
	var form = ApiaFunctions.getForm('FRM_CONFIDENCIALIDAD_ACTUACION');	
    var i = evtSource.index;	
	form.getFieldColumn('EXP_TOTAL_CONF_FECHA_STR')[i].setValue(lastModalReturn[3]);
	form.getFieldColumn('EXP_TOTAL_CONF_TIPO_ACT_STR')[i].setValue(lastModalReturn[4]);
	form.getFieldColumn('EXP_TOTAL_CONF_USR_STR')[i].setValue(lastModalReturn[5]);
return true; // END
} // END
