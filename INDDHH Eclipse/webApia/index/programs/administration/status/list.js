function btnNew_click(){
	document.getElementById("frmMain").action = "administration.EntitiesStatusAction.do?action=new";
	submitForm(document.getElementById("frmMain"));
}
function btnDel_click(){
	var cant = chksChecked(document.getElementById("gridList"));
	if(cant != 0) {
		if(cant == 1 && canWrite()==false) {
			alert(MSG_INSUF_PERMS);
		}else{
			if (confirm(GNR_DELETE_RECORD)) {
				document.getElementById("frmMain").action = "administration.EntitiesStatusAction.do?action=remove";
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
				document.getElementById("frmMain").action = "administration.EntitiesStatusAction.do?action=update";
				submitForm(document.getElementById("frmMain"));	
			}else{ //si el usuario no tiene permisos de escritura, permitimos ingresar sin necesidad de bloquearlo
				var resp = confirm(MSG_STA_ONLY_READ);
				if (resp){
					document.getElementById("frmMain").action = "administration.EntitiesStatusAction.do?action=update";
					submitForm(document.getElementById("frmMain"));	
				}
			}
		}else{
			alert(MSG_STA_CANT_READ);
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
		document.getElementById("frmMain").action = "administration.EntitiesStatusAction.do?action=viewDeps";
		submitForm(document.getElementById("frmMain"));	
	} else if (cant > 1) {
		alert(GNR_CHK_ONLY_ONE);
	} else {
		alert(GNR_CHK_AT_LEAST_ONE);
	}
}


function btnSearch_click() {
	document.getElementById("frmMain").action = "administration.EntitiesStatusAction.do?action=search";
	submitForm(document.getElementById("frmMain"));
}

function orderBy(order){
	document.getElementById("frmMain").action = "administration.EntitiesStatusAction.do?action=order&orderBy=" + order;
	submitForm(document.getElementById("frmMain"));
}

function first() {
	document.getElementById("frmMain").action = "administration.EntitiesStatusAction.do?action=first";
	submitForm(document.getElementById("frmMain"));
}
function prev() {
	document.getElementById("frmMain").action = "administration.EntitiesStatusAction.do?action=prev";
	submitForm(document.getElementById("frmMain"));
}
function next() {
	document.getElementById("frmMain").action = "administration.EntitiesStatusAction.do?action=next";
	submitForm(document.getElementById("frmMain"));
}
function last() { 
	document.getElementById("frmMain").action = "administration.EntitiesStatusAction.do?action=last";
	submitForm(document.getElementById("frmMain"));
}
function goToPage(){
	document.getElementById("frmMain").action="administration.EntitiesStatusAction.do?action=page";
	submitForm(document.getElementById("frmMain"));
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
