function btnClo_click(){
	var cant = chksChecked(document.getElementById("gridList"));
	if(cant == 1) {
		if (canRead()==true){ 
			document.getElementById("frmMain").action = "administration.TaskSchedulerAction.do?action=clone";
			submitForm(document.getElementById("frmMain"));
		}else{
			alert(MSG_INSUF_PERMS);
		}
	} else if (cant > 1) {
		alert(GNR_CHK_ONLY_ONE);
	} else {
		alert(GNR_CHK_AT_LEAST_ONE);
	}
}
function btnNew_click(){
	document.getElementById("frmMain").action = "administration.TaskSchedulerAction.do?action=new";
	submitForm(document.getElementById("frmMain"));
}
function btnDel_click(){
	var cant = chksChecked(document.getElementById("gridList"));
	if(cant != 0) {
		if(cant == 1 && canWrite()==false) {
			alert(MSG_INSUF_PERMS);
		}else{
			if (confirm(GNR_DELETE_RECORD)) {
				document.getElementById("frmMain").action = "administration.TaskSchedulerAction.do?action=remove";
				submitForm(document.getElementById("frmMain"));
			}
		}
	} else {
		alert(GNR_CHK_AT_LEAST_ONE);
	}
}

function btnMod_click(){
	var cant = chksChecked(document.getElementById("gridList"));
	if(cant == 1) {
		if (canRead()==true){ 
			if (canWrite()==true){ //verificamos si el usuario tiene permisos de escritura
				//canModify(function(){
					document.getElementById("frmMain").action = "administration.TaskSchedulerAction.do?action=update";
					submitForm(document.getElementById("frmMain"));	
				//})
			}else{ //si el usuario no tiene permisos de escritura, permitimos ingresar sin necesidad de bloquearlo
				var resp = confirm(MSG_TSK_SCH_ONLY_READ);
				if (resp){
				//	canModify(function(){
						document.getElementById("frmMain").action = "administration.TaskSchedulerAction.do?action=update";
						submitForm(document.getElementById("frmMain"));	
					//})
				}
			}
		}else{
			alert(MSG_TSK_SCH_CANT_READ);
		}
	} else if (cant > 1) {
		alert(GNR_CHK_ONLY_ONE);
	} else {
		alert(GNR_CHK_AT_LEAST_ONE);
	}
}

function btnDep_click(){
	var cant = chksChecked(document.getElementById("gridList"));
	if(cant == 1) {
		document.getElementById("frmMain").action = "administration.TaskSchedulerAction.do?action=viewDeps";
		submitForm(document.getElementById("frmMain"));	
	} else if (cant > 1) {
		alert(GNR_CHK_ONLY_ONE);
	} else {
		alert(GNR_CHK_AT_LEAST_ONE);
	}
}

function btnSearch_click() {
	document.getElementById("frmMain").action = "administration.TaskSchedulerAction.do?action=search";
	submitForm(document.getElementById("frmMain"));
}

function orderBy(order){
	document.getElementById("frmMain").action = "administration.TaskSchedulerAction.do?action=order&orderBy=" + order;
	submitForm(document.getElementById("frmMain"));
}

function first() {
	document.getElementById("frmMain").action = "administration.TaskSchedulerAction.do?action=first";
	submitForm(document.getElementById("frmMain"));
}
function prev() {
	document.getElementById("frmMain").action = "administration.TaskSchedulerAction.do?action=prev";
	submitForm(document.getElementById("frmMain"));
}
function next() {
	document.getElementById("frmMain").action = "administration.TaskSchedulerAction.do?action=next";
	submitForm(document.getElementById("frmMain"));
}
function last() { 
	document.getElementById("frmMain").action = "administration.TaskSchedulerAction.do?action=last";
	submitForm(document.getElementById("frmMain"));
}
function goToPage(){
	document.getElementById("frmMain").action="administration.TaskSchedulerAction.do?action=page";
	submitForm(document.getElementById("frmMain"));
}

function canModify(after){
	var selItem = document.getElementById("gridList").selectedItems[0].rowIndex-1;
	var trows = document.getElementById("gridList").rows;
	var tskSchId = trows[selItem].getElementsByTagName("TD")[0].getElementsByTagName("INPUT")[1].value;
	var sXMLSourceUrl = "administration.TaskSchedulerAction.do?action=checkUserPerm&tskSchId=" + tskSchId + "&permCheck=" + PERM_READ;
	var xmlLoad=new xmlLoader();
	xmlLoad.onload=function(xml){
		if(this.textLoaded=="true"){
			after();
		}else{
			alert(PERM_INSUFICIENTES);
		}
	}
	xmlLoad.load(sXMLSourceUrl);
}

function canWrite(){
	var selItem = document.getElementById("gridList").selectedItems[0].rowIndex-1;
	var trows=document.getElementById("gridList").rows;
	var usrCanWrite = trows[selItem].getElementsByTagName("TD")[1].getElementsByTagName("INPUT")[1].value;
	if (usrCanWrite=='true'){
		return true;
	}else{
		return false;	
	}
}
function canRead(){
	var selItem = document.getElementById("gridList").selectedItems[0].rowIndex-1;
	var trows=document.getElementById("gridList").rows;
	var usrCanRead = trows[selItem].getElementsByTagName("TD")[1].getElementsByTagName("INPUT")[0].value;
	if (usrCanRead=='true'){
		return true;
	}else{
		return false;	
	}
}