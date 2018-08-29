function initProperties() {
	var chkAllowCit = $('chkAllowCit');
	var txtDefOvrAsgn = $('txtDefOvrAsgn');
	var selDefSubHor = $('selDefSubHor');
	var txtDefOthFrec = $('txtDefOthFrec');
	var chkNotify = $('chkNotify');
	var txtEmails = $('txtEmails');
	
	if (chkAllowCit) {
		chkAllowCit.addEvent('click', function(evt){
			if (this.checked) {
				txtDefOvrAsgn.erase('disabled');
				selDefSubHor.erase('disabled');
				chkNotify.erase('disabled');
				if (selDefSubHor.value > 0){
					txtDefOthFrec.set('disabled', true);
				}else{
					txtDefOthFrec.erase('disabled');
				}
			}else{
				if (txtDefOvrAsgn.get('value') == ""){
					txtDefOvrAsgn.set('value','0');
				}
				txtDefOvrAsgn.set('disabled', true);
				selDefSubHor.set('value',30);
				selDefSubHor.set('disabled', true);
				chkNotify.set('disabled', true);
				txtDefOthFrec.set('disabled', true);
				txtDefOthFrec.set('value', '');
			}
		});
	}
	
	if (chkNotify) {
		chkNotify.addEvent('click', function(e) {
			if (chkNotify.checked){
				txtEmails.erase('disabled');
				//setRequiredField(txtEmails);
			}else{
				txtEmails.set('disabled', true);
				txtEmails.set('value', '');
				//unsetRequiredField(txtEmails);
			}
		});
	}

	if (selDefSubHor) {
		selDefSubHor.addEvent('change', function(e) {
			var fracc = selDefSubHor.get('value');
			if (fracc == -1){
				fracc = 30;
				selDefFraccTime(fracc);
			}
			if (selDefSubHor.get('value') == 0){ //Otro
				txtDefOthFrec.erase('disabled');
			}else{
				txtDefOthFrec.set('disabled', true);
				txtDefOthFrec.set('value', '');
			}
		});
	}
	
	if (chkAllowCit) {
		chkAllowCit.fireEvent("click");
	}
}

//Seleccionamos la subdivision horaria pasada por parametro
function selDefFraccTime(fracc){
	var cmbFracc = $('selDefSubHor');
	var found = false;
	for (i = 0; i < cmbFracc.options.length; i++) {
		if (cmbFracc.options[i].value == fracc) {
			cmbFracc.selectedIndex = i;
			found = true;
			$('txtDefOthFrec').set('value', '');
			return;
		}
	}
	
	//Si llego aqui no se encontro --> es otro valor
	cmbFracc.selectedIndex = cmbFracc.options.length-1;
	$('txtDefOthFrec').erase('disabled');
	$('txtDefOthFrec').set('value', fracc);
}

function validateEmails(el){ //Validación de los emails ingresados
	//Si se ingreso mas de un email, debe utilizarse el separador ';'
	var emails = $('txtEmails').value;
	if (emails != ""){
		if(emails.indexOf("@")>0){
			emails = emails.substring(emails.indexOf("@")+1, emails.length);
			if (emails!="" && emails.indexOf("@")>0){
				if (emails.indexOf(";")<0){
					el.errors.push(MSG_EMAILS_ERROR);
					return false;
				}
			}
		}else {
			el.errors.push(MSG_EMAILS_FORMAT_ERROR);
			return false;
		}
	}

    return true;
}

function validateDefOvrAsgn(el) { //Validación de sobreasignación por defecto
	//Si se permite asignar citas en semanas no configuradas -> la sobreasignacion por defecto debe ser mayor que 0 (sino no tiene sentido que permita asignar citas en semanas no configuradas)
	if ($('chkAllowCit').checked){
		var val = $('txtDefOvrAsgn').value;
		if (val == null || val== "" || parseInt(val) <= 0){
			el.errors.push(MSG_SCH_DEF_OVR_ASGN_ERROR);
			return false;
		}
	}
	return true;
}