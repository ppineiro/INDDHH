var isConfirming=false;
function btnConf(){
	if(isValidName(document.getElementById("txtName").value)){
		if (verifyRequiredObjects()) {
			if (verifyOtherObjects()){
				isConfirming=true;
				fillHiddenInput(); //Cargamos el input oculto de dias de exclusion
				document.getElementById("frmMain").action = "administration.TaskSchedulerAction.do?action=confirm";
				submitForm(document.getElementById("frmMain"));
			}
		}
	}
}

function btnExit_click(){
	var msg = confirm(GNR_PER_DAT_ING);
	if (msg) {
		splash();
	}
}

function btnBack_click() {
	if (canWrite()){
		var msg = confirm(GNR_PER_DAT_ING);
		if (msg) {
			document.getElementById("frmMain").action = "administration.TaskSchedulerAction.do?action=backToList";
			submitForm(document.getElementById("frmMain"));
		}
	}else{
		document.getElementById("frmMain").action = "administration.TaskSchedulerAction.do?action=backToList";
		submitForm(document.getElementById("frmMain"));
	}
}

function verifyOtherObjects(){
	//Si se ingreso mas de un email, debe utilizarse el separador ';'
	var emails = document.getElementById("txtEmails").value;
	if (emails != "" && emails.indexOf("@")>0){
		emails = emails.substring(emails.indexOf("@")+1, emails.length);
		if (emails!="" && emails.indexOf("@")>0){
			if (emails.indexOf(";")<0){
				alert(MSG_EMAILS_ERROR);
				return false;
			}
		}
	}
	
	//Si se permite asignar citas en semanas no configuradas -> la sobreasignacion por defecto debe ser mayor que 0 (sino no tiene sentido que permita asignar citas en semanas no configuradas)
	if (document.getElementById("chkAllowCit").checked){
		var val = document.getElementById("txtDefOvrAsgn").value;
		if (val == null || val== "" || parseInt(val) <= 0){
			alert(MSG_SCH_DEF_OVR_ASGN_ERROR);
			return false;
		}
	}
	
	//Al menos alguien debe tener permiso de lectura y modificacion
	if (!document.getElementById("usePrjPerms").checked){ //Si no se usan los permisos del proyecto
		var trows=document.getElementById("tskSchPrivGrid").rows;
		var modify = false;
		for (i=0;(i<trows.length && !modify);i++) {
			if (trows[i].getElementsByTagName("TD")[3].getElementsByTagName("INPUT")[1].checked) {
				modify = true; //Si tiene permiso de modificacion tiene permiso de lectura tambien
			}
		}
		if (!modify){
			alert(MSG_SCH_PRIV_ERROR);
			return false;
		}
	}
	
	return true;
}

function canWrite(){
	var usrCanWrite = document.getElementById("hidUsrCanWrite").value;
	if (usrCanWrite=='true'){
		return true;
	}else{
		return false;	
	}
}

function cmbProySel(){
	if (document.getElementById("selPrj").value == "0"){
		//Deshabilitamos el checkbox de usar permisos del proyecto
		document.getElementById("usePrjPerms").checked = false;
		document.getElementById("usePrjPerms").disabled = true;
		
		//Habilitamos todos los check de lectura/modificacion
		var oRows = document.getElementById("tskSchPrivGrid").rows;
		for(var i=0; i<oRows.length;i++){
			var td = oRows[i].getElementsByTagName("TD");
			//Modo lectura
			td[3].getElementsByTagName("INPUT")[0].disabled = false;
			//Modo escritura
			td[3].getElementsByTagName("INPUT")[1].disabled = false;
		}
	}else{
		//Habilitamos el checkbox de usar permisos del proyecto	
		document.getElementById("usePrjPerms").disabled = false;
		if (!document.getElementById("usePrjPerms").checked){ //Si no esta clickeado el checkbox de usar los permisos del proyecto
			var msg = confirm(MSG_USE_PROY_PERMS);
			if (msg) {
				document.getElementById("usePrjPerms").checked = true;
				//Desclickeamos y deshabilitamos todos los check de lectura/modificacion
				var oRows = document.getElementById("tskSchPrivGrid").rows;
				for(var i=0; i<oRows.length;i++){
					var td = oRows[i].getElementsByTagName("TD");
					//Modo lectura
					td[3].getElementsByTagName("INPUT")[0].checked = false;
					td[3].getElementsByTagName("INPUT")[0].disabled = true;
					//Modo escritura
					td[3].getElementsByTagName("INPUT")[1].checked = false;
					td[3].getElementsByTagName("INPUT")[1].disabled = true;
				}
			}
		}
	}
}