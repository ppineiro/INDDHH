
function fnc_1001_3761(evtSource, par_form_name) { 
	var fields =  window.location.href.split("/");
	var form = ApiaFunctions.getForm(par_form_name);
	form.getField('LOCAL_ADDRESS').setValue(fields[0]+"//"+fields[2]);	

return true; // END
} // END
