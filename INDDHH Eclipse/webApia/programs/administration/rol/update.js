function btnConf_click(){
	if (verifyRequiredObjects()) {
		if(isValidName(document.getElementById("txtName").value)){
			if (verifyPermissions()){
				document.getElementById("frmMain").action = "administration.RolAction.do?action=confirm";
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
			document.getElementById("frmMain").action = "administration.RolAction.do?action=backToList";
			submitForm(document.getElementById("frmMain"));
		}
	}else{
		document.getElementById("frmMain").action = "administration.RolAction.do?action=backToList";
		submitForm(document.getElementById("frmMain"));
	}
}
function verifyPermissions(){
	if (!document.getElementById("usePrjPerms").checked){ //Si no se usan los permisos del proyecto
		//Verificamos si almenos una persona tiene acceso de modificacion
		var permRows=document.getElementById("permGrid").rows;
		var someoneCanModify = false;
		for(var i=0;i<permRows.length;i++){
			var canModify= ("1" == permRows[i].getElementsByTagName("TD")[0].getElementsByTagName("INPUT")[3].value);
			if(canModify){//Verificamos que los nombres de los atributos no sean nulos
				someoneCanModify = true;
			}
		}
		if (!someoneCanModify){
			alert(MSG_PERMISSIONS_ERROR);	
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
		//Habilitamos la grilla de permisos
		document.getElementById("permGrid").disabled = false;
		document.getElementById("addPoolUsrPerm").disabled = false;
		document.getElementById("delPoolUsrPerm").disabled = false;
		//Vaciamos la grilla de permisos, dejando TODOS clickeado
		//delAllPerms(true);
		var oRows = document.getElementById("permGrid").rows;
		var td = oRows[0].getElementsByTagName("TD");
		//Marcamos el modo lectura
		td[3].getElementsByTagName("INPUT")[0].checked = true;
		td[0].getElementsByTagName("INPUT")[2].value = 1;
		//Marcamos escritura
		td[3].getElementsByTagName("INPUT")[1].checked = true;
	 	td[0].getElementsByTagName("INPUT")[3].value = 1;
	}else{
		//Habilitamos el checkbox de usar permisos del proyecto	
		document.getElementById("usePrjPerms").disabled = false;
		//Cargamos la grilla con los permisos del proyecto
		//loadProyectPerms(); <--- TODO, SI SE HACE SE DEBE HACER PARA TODOS LOS OBJETOS DE DISEÑO
		if (!document.getElementById("usePrjPerms").checked){ //Si no esta clickeado el checkbox de usar los permisos del proyecto
			var msg = confirm(MSG_USE_PROY_PERMS);
			if (msg) {
				document.getElementById("usePrjPerms").checked = true;
				//Deshabilitamos la grilla de permisos
				document.getElementById("permGrid").disabled = true;
				document.getElementById("addPoolUsrPerm").disabled = true;
				document.getElementById("delPoolUsrPerm").disabled = true;
				//Vaciamos la grilla de permisos, dejando TODOS sin clickear
				delAllPerms(false);
			}
		}
	}
}

function loadProyectPerms(){
	//1. Obtenemos el id del proyecto seleccionado
	var prjId = document.getElementById("selPrj").value;
	var sXMLSourceUrl = "administration.RolAction.do?action=getProjPermssions&prjId=" + prjId;
	var xmlLoad=new xmlLoader();
	xmlLoad.onload=function(xmlRoot){
	
		for(i=0;i<xmlRoot.childNodes.length;i++){
			xRow = xmlRoot.childNodes[i];
			var option = document.createElement("OPTION");
			
			/* TODO */
		
		}
	}
	xmlLoad.load(sXMLSourceUrl);
}