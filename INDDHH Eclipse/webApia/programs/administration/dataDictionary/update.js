function btnConf_click(){
	if (verifyRequiredObjects()) {
		if(isValidName(document.getElementById("txtName").value)){
			if (verifyPermissions()){
				if (dataUsed){ //Usado en una instancia --> no se puede modificar ni nombre ni achicar tamaño
					if (parseInt(document.getElementById("txtLength_aux").value) > parseInt(document.getElementById("txtLength").value)){
						//Se achico tamaño --> avisar usuario y salir
						alert(errAttLenNotAll);
						document.getElementById("txtLength").value = document.getElementById("txtLength_aux").value;
						document.getElementById("txtLength").blur();
						document.getElementById("txtLength").select();
						return;
					}
				}
				if(document.getElementById("txtLength").value == "" || validateValue(document.getElementById("txtLength"))){
					//Si llega aca es porque no esta siendo usado en una instancia --> puede modificar lo que quiera
					document.getElementById("frmMain").action = "administration.DataDictionaryAction.do?action=confirm";
					submitForm(document.getElementById("frmMain"));
				}
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
			document.getElementById("frmMain").action = "administration.DataDictionaryAction.do?action=backToList";
			submitForm(document.getElementById("frmMain"));
		}
	}else{
		document.getElementById("frmMain").action = "administration.DataDictionaryAction.do?action=backToList";
		submitForm(document.getElementById("frmMain"));
	}
}

function test(){
	if (document.getElementById("toTest").value != "") {
   		var re = new RegExp(document.getElementById("txtRegExp").value);
		var str = document.getElementById("toTest").value;
		if (re.test(str) != true) {
			alert(errRegExpFail);
		} else {
   			alert(errRegExpOk);
   		}
	}
}

function cmbType_change() {
	if ((document.getElementById("cmbType").selectedIndex && document.getElementById("cmbType").options[document.getElementById("cmbType").selectedIndex].value == dataTypeDate) || document.getElementById("cmbType").value ==dataTypeDate ) {
		if (clearValues) {
			document.getElementById("txtLength").value = DATE_LENGTH;
			document.getElementById("txtMask").value = DATE_MASK;
			document.getElementById("txtRegExp").value = "";
		}
		document.getElementById("txtRegExp").className = "txtReadOnly";
		document.getElementById("txtRegExp").readOnly = true;
		document.getElementById("txtLength").className = "txtReadOnly";
		document.getElementById("txtLength").readOnly = true;
		document.getElementById("toTest").className = "txtReadOnly";
		document.getElementById("toTest").readOnly = true;
		if (document.getElementById("btnTest") != null) {
		  document.getElementById("btnTest").disabled = true;
		}
	}
	if (document.getElementById("cmbType").selectedIndex && document.getElementById("cmbType").options[document.getElementById("cmbType").selectedIndex].value == dataTypeNumber) {
		if (clearValues) {
			document.getElementById("txtLength").value = "";
			document.getElementById("txtMask").value = "";
			document.getElementById("txtRegExp").value = "";
		}
		document.getElementById("txtRegExp").className = "";
		document.getElementById("txtRegExp").readOnly = false;
		document.getElementById("txtLength").className = "txtNumeric";
		document.getElementById("txtLength").readOnly = false;
		document.getElementById("toTest").className = "";
		document.getElementById("toTest").readOnly = false;
		if (document.getElementById("btnTest") != null) {
		  document.getElementById("btnTest").disabled = false;
		}
	}
	if (document.getElementById("cmbType").selectedIndex == 0 && document.getElementById("cmbType").options[document.getElementById("cmbType").selectedIndex].value == dataTypeString) {
		if (clearValues) {
			document.getElementById("txtLength").value = "";
			document.getElementById("txtMask").value = "";
		}
		document.getElementById("txtRegExp").className = "";
		document.getElementById("txtRegExp").className = "";
		document.getElementById("txtRegExp").readOnly = false;
		document.getElementById("txtLength").className = "txtNumeric";
		document.getElementById("txtLength").readOnly = false;
		document.getElementById("toTest").className = "";
		document.getElementById("toTest").readOnly = false;
		if (document.getElementById("btnTest") != null) {
		  document.getElementById("btnTest").disabled = false;
		}
	}
	if (document.getElementById("cmbType").value == "") {
		document.getElementById("txtLength").value = "";
		document.getElementById("txtMask").value = "";
		document.getElementById("txtRegExp").className = "";
		document.getElementById("txtRegExp").readOnly = false;
		document.getElementById("txtRegExp").value="";
		document.getElementById("txtLength").className = "txtNumeric";
		document.getElementById("txtLength").readOnly = false;		
		document.getElementById("toTest").className = "";
		document.getElementById("toTest").readOnly = false;
		if (document.getElementById("btnTest") != null) {
		  document.getElementById("btnTest").disabled = false;
		}
	}
	
	clearValues = true;
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
	var sXMLSourceUrl = "administration.DataDictionaryAction.do?action=getProjPermssions&prjId=" + prjId;
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