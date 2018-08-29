
function fnc_1001_1558(evtSource) { 
	//El signo de "+" es para convertir el valor a numérico
	//y que no haga la comparasión como strings 
	var myForm = ApiaFunctions.getForm("DESGLOSE_DESGLOSAR");
	var pagDesde = (myForm.getField("DSGL_PAG_DESDE_CBO_FRM").getValue());
	var pagHasta = (myForm.getField("DSGL_PAG_HASTA_CBO_FRM").getValue());
	
	if(pagDesde > pagHasta){
		alert("La página desde es mayor que la página hasta");
		return false;
	} 
	return true; // END

return true; // END
} // END
