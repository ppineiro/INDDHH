function showFlashHTML(html,winName){
var w = window.open("",winName,"height=480,width=680,resizable=yes,scrollbars=yes");
	w.document.open();
    w.document.write(html);
    w.document.close();
    w.focus();
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
			document.getElementById("frmMain").action = "administration.FormAction.do?action=backToList";
			submitForm(document.getElementById("frmMain"));
		}
	}else{
		document.getElementById("frmMain").action = "administration.FormAction.do?action=backToList";
		submitForm(document.getElementById("frmMain"));
	}
}

function btnAddFieldEvt_click() {
	var trows=document.getElementById("gridForEvt").rows;
	 
	var oTd0 = document.createElement("TD"); 
	var oTd1 = document.createElement("TD"); 
	var oTd2 = document.createElement("TD");
	var oTd3 = document.createElement("TD");
	
	oTd0.innerHTML = "<input type='hidden' name='chkEnvSel'><input type='hidden' name='chkEnv'>";
	oTd0.getElementsByTagName("INPUT")[1].value = "";
	oTd0.align="center";

	oTd1.innerHTML = "<input type='text' name='txtEvtObj' maxlength='255' >";
	
	oTd2.innerHTML = cmbFieldsHTML;

	oTd3.innerHTML = "<input type='text' name='txtEvtFldDoc' maxlength='3000' size='100'>";

	var oTr = document.createElement("TR");
	oTr.appendChild(oTd0);
	oTr.appendChild(oTd1);
	oTr.appendChild(oTd2);
	oTr.appendChild(oTd3);
	document.getElementById("gridForEvt").addRow(oTr);
}

function btnDelFieldEvt_click() {
	document.getElementById("gridForEvt").removeSelected();
}

function btnAddFormEvt_click() {
	var trows=document.getElementById("gridForEvtForm").rows;
	 
	var oTd0 = document.createElement("TD"); 
	var oTd2 = document.createElement("TD");
	var oTd3 = document.createElement("TD");
	
	oTd0.innerHTML = "<input type='hidden' name='chkEnvSel'><input type='hidden' name='chkEnv'>";
	oTd0.getElementsByTagName("INPUT")[1].value = "";
	oTd0.align="center";


	
	oTd2.innerHTML = cmbFormsHTML;

	oTd3.innerHTML = "<input type='text' size='100' maxlength='3000' name='txtEvtFrmDoc'><input type='hidden' name='txtFrmObjId' value='"+(trows.length+1)+"' >";


	var oTr = document.createElement("TR");
	oTr.appendChild(oTd0);
	
	oTr.appendChild(oTd2);
	oTr.appendChild(oTd3);
	document.getElementById("gridForEvtForm").addRow(oTr);
}

function btnDelFormEvt_click() {
	document.getElementById("gridForEvtForm").removeSelected();
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
	var sXMLSourceUrl = "administration.FormAction.do?action=getProjPermssions&prjId=" + prjId;
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

