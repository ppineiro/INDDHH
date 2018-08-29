function btnClo_click(){
	document.getElementById("frmMain").target = "";
	var cant = chksChecked(document.getElementById("gridList"));
	if(cant == 1) {
		if (canRead()==true){ 
			document.getElementById("frmMain").action = "administration.DataDictionaryAction.do?action=clone";
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

function btnDow_click(){
	var rets = openModal("/programs/modals/export.jsp?hiddeHtml=true&hiddeCSV=true&hiddePdf=true&hiddeXPDL=true&hiddeCount=true",500,220);
	var doAfter=function(rets){
		if (rets != null) {
			if (rets[0] == "excel") {
				document.getElementById("frmMain").action = "administration.DataDictionaryAction.do?action=downloadExcel";
			} else if (rets[0] == "txt") {
				document.getElementById("frmMain").action = "administration.DataDictionaryAction.do?action=downloadTxt";
			}
	
			document.getElementById("frmMain").target = "idResult";
			document.getElementById("frmMain").submit();
		}
	}
	rets.onclose=function(){
		doAfter(rets.returnValue);
	}
	/*if (window.navigator.appVersion.indexOf("MSIE")<0){
		var aux=rets.document;
		var isOpen=true;
		rets.onunload=function(event){
			event.cancelBubble=true;
			if(!isOpen){
				doAfter(rets.returnValue);
			}
			isOpen=false;
	    }
    }else{
		doAfter(rets);
	}*/
}

function btnUpl_click(){
	document.getElementById("frmMain").target = "";
	document.getElementById("frmMain").action = "administration.DataDictionaryAction.do?action=upload";
	submitForm(document.getElementById("frmMain"));
}

function btnNew_click(){
	document.getElementById("frmMain").target = "";
	document.getElementById("frmMain").action = "administration.DataDictionaryAction.do?action=new";
	submitForm(document.getElementById("frmMain"));
}

function btnDel_click(){
	document.getElementById("frmMain").target = "";
	var cant = chksChecked(document.getElementById("gridList"));
	if(cant != 0) {
		if(cant == 1 && canWrite()==false) {
			alert(MSG_INSUF_PERMS);
		}else{
			if (confirm(GNR_DELETE_RECORD)) {
				document.getElementById("frmMain").action = "administration.DataDictionaryAction.do?action=remove";
				submitForm(document.getElementById("frmMain"));
			}
		}
	} else {
		alert(GNR_CHK_AT_LEAST_ONE);
	}
}
function btnMod_click(){
	document.getElementById("frmMain").target = "";
	var cant = chksChecked(document.getElementById("gridList"));
	if(cant == 1) {
		if (canRead()==true){ 
			if (canWrite()==true){ //verificamos si el usuario tiene permisos de escritura
				document.getElementById("frmMain").action = "administration.DataDictionaryAction.do?action=update";
				submitForm(document.getElementById("frmMain"));	
			}else{ //si el usuario no tiene permisos de escritura, permitimos ingresar sin necesidad de bloquearlo
				var resp = confirm(MSG_ATT_ONLY_READ);
				if (resp){
					document.getElementById("frmMain").action = "administration.DataDictionaryAction.do?action=update";
					submitForm(document.getElementById("frmMain"));	
				}
			}
		}else{
			alert(MSG_ATT_CANT_READ);
		}
	} else if (cant > 1) {
		alert(GNR_CHK_ONLY_ONE);
	} else {
		alert(GNR_CHK_AT_LEAST_ONE);
	}

}

function btnDep_click(){
	document.getElementById("frmMain").target = "";
	var cant = chksChecked(document.getElementById("gridList"));
	if(cant == 1) {
		document.getElementById("frmMain").action = "administration.DataDictionaryAction.do?action=viewDeps";
		submitForm(document.getElementById("frmMain"));	
	} else if (cant > 1) {
		alert(GNR_CHK_ONLY_ONE);
	} else {
		alert(GNR_CHK_AT_LEAST_ONE);
	}
}

function btnSearch_click() {
	document.getElementById("frmMain").target = "";
	document.getElementById("frmMain").action = "administration.DataDictionaryAction.do?action=search";
	submitForm(document.getElementById("frmMain"));
}

function orderBy(order){
	document.getElementById("frmMain").target = "";
	document.getElementById("frmMain").action = "administration.DataDictionaryAction.do?action=order&orderBy=" + order;
	submitForm(document.getElementById("frmMain"));
}

function first() {
	document.getElementById("frmMain").target = "";
	document.getElementById("frmMain").action = "administration.DataDictionaryAction.do?action=first";
	submitForm(document.getElementById("frmMain"));
}
function prev() {
	document.getElementById("frmMain").target = "";
	document.getElementById("frmMain").action = "administration.DataDictionaryAction.do?action=prev";
	submitForm(document.getElementById("frmMain"));
}
function next() {
	document.getElementById("frmMain").target = "";
	document.getElementById("frmMain").action = "administration.DataDictionaryAction.do?action=next";
	submitForm(document.getElementById("frmMain"));
}
function last() { 
	document.getElementById("frmMain").target = "";
	document.getElementById("frmMain").action = "administration.DataDictionaryAction.do?action=last";
	submitForm(document.getElementById("frmMain"));
}
function goToPage(){
	document.getElementById("frmMain").action="administration.DataDictionaryAction.do?action=page";
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
