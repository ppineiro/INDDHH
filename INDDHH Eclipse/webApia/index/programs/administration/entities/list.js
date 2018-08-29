function btnClo_click(){

	var cant = chksChecked(document.getElementById("gridList"));
	if(cant == 1) {
		if (canRead()==true){ 
			document.getElementById("frmMain").action = "administration.EntitiesAction.do?action=clone";
			document.getElementById("frmMain").target = "";
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

function btnRegCbe_click(){
	var cant = chksChecked(document.getElementById("gridList"));
	if(cant != 0) {
		if(cant == 1 && canWrite()==false) {
			alert(MSG_INSUF_PERMS);
		}else{
			if (confirm(MSG_REG_CUBE)) {
				document.getElementById("frmMain").action = "administration.EntitiesAction.do?action=regCbe";
				document.getElementById("frmMain").target = "";
				submitForm(document.getElementById("frmMain"));
			}
		}
	} else {
		alert(GNR_CHK_AT_LEAST_ONE);
	}
}

function btnNew_click(){
	document.getElementById("frmMain").action = "administration.EntitiesAction.do?action=new";
	document.getElementById("frmMain").target = "";
	submitForm(document.getElementById("frmMain"));
}

function btnDel_click(){
	var cant = chksChecked(document.getElementById("gridList"));
	if(cant != 0) {
		if(cant == 1 && canWrite()==false) {
			alert(MSG_INSUF_PERMS);
		}else{
			if (confirm(GNR_DELETE_RECORD)) {
				document.getElementById("frmMain").action = "administration.EntitiesAction.do?action=remove";
				document.getElementById("frmMain").target = "";
				submitForm(document.getElementById("frmMain"));
			}
		}
	} else {
		alert(GNR_CHK_AT_LEAST_ONE);
	}
}

function btnIni_click(){
	var cant = chksChecked(document.getElementById("gridList"));
	if(cant != 0) {
		if(cant == 1 && canWrite()==false) {
			alert(MSG_INSUF_PERMS);
		}else{
			if (confirm(GNR_INIT_RECORD)) {
				document.getElementById("frmMain").action = "administration.EntitiesAction.do?action=initEnt";
				document.getElementById("frmMain").target = "";
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
				document.getElementById("frmMain").action = "administration.EntitiesAction.do?action=update";
				document.getElementById("frmMain").target = "";
				submitForm(document.getElementById("frmMain"));	
			}else{ //si el usuario no tiene permisos de escritura, permitimos ingresar sin necesidad de bloquearlo
				var resp = confirm(MSG_ENT_ONLY_READ);
				if (resp){
					document.getElementById("frmMain").action = "administration.EntitiesAction.do?action=update";
					submitForm(document.getElementById("frmMain"));	
				}
			}
		}else{
			alert(MSG_ENT_CANT_READ);
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
		document.getElementById("frmMain").action = "administration.EntitiesAction.do?action=viewDeps";
		document.getElementById("frmMain").target = "";
		submitForm(document.getElementById("frmMain"));	
	} else if (cant > 1) {
		alert(GNR_CHK_ONLY_ONE);
	} else {
		alert(GNR_CHK_AT_LEAST_ONE);
	}
}

function btnUpl_click(){
	var cant = chksChecked(document.getElementById("gridList"));
	if(cant == 1) {
		if (canWrite()==true){ 
			var selected = document.getElementById("gridList").selectedItems[0].cells[0].getElementsByTagName("input")[1].value;
			var rets = openModal("/administration.EntitiesAction.do?action=upload&selected=" + selected + windowId,600,280);
			var doAfter=function(rets){
			}
			rets.onclose=function(){
				doAfter(rets.returnValue);
			}
		}else{
			alert(MSG_INSUF_PERMS);
		}
	}
}

function btnDow_click(){
	var cant = chksChecked(document.getElementById("gridList"));
	if(cant == 1) {
		if (canRead()==true){ 
			var selected = document.getElementById("gridList").selectedItems[0].cells[0].getElementsByTagName("input")[1].value;
			var rets = openModal("/administration.EntitiesAction.do?action=download&busEntId="+selected + windowId,(getStageWidth()*.7),(getStageHeight()*.65));
			var doAfter=function(rets){
				var action = "";
				var frmIds= "";
				var attIds= "";
				if (rets != null) {
					if (rets[0] == "excel") {
						action="downloadExcel";
					} else if (rets[0] == "csv") {
						action="downloadTxt";
					} else if (rets[0] == "xml") {
						action="downloadXml";
					}
					if (rets[1] != null && rets[1].length > 0){
						var frms = rets[1];
						for (var i=0;i<frms.length;i++){
							if ("" == frmIds){
								frmIds = frms[i];
							}else{
								frmIds = frmIds + "&frmId=" + frms[i];
							}
						}
					}
					if (rets[2] != null && rets[2].length > 0){
						var atts = rets[2];
						for (var j=0;j<atts.length;j++){
							if ("" == attIds){
								attIds = atts[j];
							}else{
								attIds = attIds + "&attId=" + atts[j];
							}
						}
					}
					
					document.getElementById("frmMain").action = "administration.EntitiesAction.do?action=" + action + "&selected=" + selected + "&frmId=" + frmIds + "&attId=" + attIds;			
					document.getElementById("frmMain").target = "idResult";
					document.getElementById("frmMain").submit();
				}
			}	
			rets.onclose=function(){
				doAfter(rets.returnValue);
			}
		}else{
			alert(MSG_ENT_CANT_READ);
		}
	}else if (cant > 1) {
		alert(GNR_CHK_ONLY_ONE);
	} else {
		alert(GNR_CHK_AT_LEAST_ONE);
	} 
}

function btnSearch_click() {
	document.getElementById("frmMain").action = "administration.EntitiesAction.do?action=search";
	document.getElementById("frmMain").target = "";
	submitForm(document.getElementById("frmMain"));
}

function orderBy(order){
	document.getElementById("frmMain").action = "administration.EntitiesAction.do?action=order&orderBy=" + order;
	document.getElementById("frmMain").target = "";
	submitForm(document.getElementById("frmMain"));
}

function first() {
	document.getElementById("frmMain").action = "administration.EntitiesAction.do?action=first";
	document.getElementById("frmMain").target = "";
	submitForm(document.getElementById("frmMain"));
}
function prev() {
	document.getElementById("frmMain").action = "administration.EntitiesAction.do?action=prev";
	document.getElementById("frmMain").target = "";
	submitForm(document.getElementById("frmMain"));
}
function next() {
	document.getElementById("frmMain").action = "administration.EntitiesAction.do?action=next";
	document.getElementById("frmMain").target = "";
	submitForm(document.getElementById("frmMain"));
}
function last() { 
	document.getElementById("frmMain").action = "administration.EntitiesAction.do?action=last";
	document.getElementById("frmMain").target = "";
	submitForm(document.getElementById("frmMain"));
}
function goToPage(){
	document.getElementById("frmMain").action="administration.EntitiesAction.do?action=page";
	document.getElementById("frmMain").target = "";
	submitForm(document.getElementById("frmMain"));
}

function btnMerToEnt_click() {
	document.getElementById("frmMain").action="administration.EntitiesAction.do?action=uploadMER";
	document.getElementById("frmMain").target = "";
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
