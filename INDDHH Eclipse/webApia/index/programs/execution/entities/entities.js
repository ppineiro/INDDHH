//-- Funciones para impresi?n --//

//***********************************************************//
//     NO CAMBIAR EL ORDEN EN QUE SE ESTABLECEN LOS DATOS    //
//***********************************************************//
function btnPrint_click() {


	try {
		if (!beforePrintFormsData_E()) {
			return;
		}
	} catch (e){}
	try {
		if (!beforePrintFormsData_P()) {
			return;
		}
	} catch (e){}
	


	var modal=openModal("/frames/blank.jsp", 680,400);
	function submitPrint(){
		document.getElementById("printForm").submit();
	    document.getElementById("printForm").body.value = "";
    }
    modal.onload=function(){
    	submitPrint();
    }
	var selectedTab = null;
	var divContentHeight = document.getElementById("divContent").style.height;
	//document.getElementById("divContent").style.height = "";
	document.getElementById("printForm").body.value = "";
	document.getElementById("printForm").body.value = processBodyToPrint();
   //document.getElementById("divContent").style.height = divContentHeight;

    //styleWin.focus();
	document.getElementById("printForm").target=modal.content.name;//"Print";
	
		
	try {
		if (!afterPrintFormsData_E()) {
			return;
		}
	} catch (e){}
	try {
		if (!afterPrintFormsData_P()) {
			return;
		}
	} catch (e){}
	
}

var submitPerformed = false;

function submitFormReload(obj) {

	if (submitPerformed ==  true){
		return false;
	}

	try{
		obj.action=obj.action+"&selTab="+document.getElementById("samplesTab").getSelectedTabIndex();
	} catch (e) {
	}
	obj.target = "_self";
	submitForm(obj);
	submitPerformed = true;

}

function submitFormReloadFrm(obj,frmName) {
 
	if (submitPerformed ==  true){
		return false;
	}

	try{
		obj.action=obj.action+"&selTab="+document.getElementById("samplesTab").getSelectedTabIndex();
	} catch (e) {
	}
	obj.target = "_self";
	
	submitAjax(obj,frmName);
	
	submitPerformed = true;

}

function btnNew_click(){
	document.getElementById("frmMain").action = "execution.EntInstanceAction.do?action=new";
	submitForm(document.getElementById("frmMain"));
}

function btnBack_click(){
	var msg = true;
	if(CAN_CONFIRMUPDATE){
		msg = confirm(GNR_PER_DAT_ING);
	}
	if (msg) {
		
		if (QUERY_GO_BACK) {
			document.getElementById("frmMain").action = "query.QueryAction.do?action=returnAction";
		} else if (QUERY_ADMIN) {
			document.getElementById("frmMain").action = "query.EntInstanceAction.do?action=backToList";
		} else {
			if(SPECIFIC_ADMIN) {
				document.getElementById("frmMain").action = "execution.EntInstanceAction.do?action=backToList";
			} else {
				document.getElementById("frmMain").action = "execution.EntInstanceAction.do?action=init&clear=false";
				try{document.getElementById("txtBusEntId").value = "";}catch(e){}
			}
		}
				
		document.getElementById("frmMain").target = "_self";
		submitForm(document.getElementById("frmMain"));
	}
}

function btnDel_click(){
	var cant = chksChecked(document.getElementById("gridList"));
	if(cant != 0) {
		if (confirm(GNR_DELETE_RECORD)) {
	document.getElementById("frmMain").action = "execution.EntInstanceAction.do?action=remove";
			submitForm(document.getElementById("frmMain"));
		}
	} else {
		alert(GNR_CHK_AT_LEAST_ONE);
	}
}
function btnMod_click(){
	var cant = chksChecked(document.getElementById("gridList"));
	if(cant == 1) {
		document.getElementById("frmMain").action = "execution.EntInstanceAction.do?action=update";
		submitForm(document.getElementById("frmMain"));	
	} else if (cant > 1) {
		alert(GNR_CHK_ONLY_ONE);
	} else {
		alert(GNR_CHK_AT_LEAST_ONE);
	}

}


function btnClo_click(){
	var cant = chksChecked(document.getElementById("gridList"));
	if(cant == 1) {
		document.getElementById("frmMain").action = "execution.EntInstanceAction.do?action=clone";
		submitForm(document.getElementById("frmMain"));
	} else if (cant > 1) {
		alert(GNR_CHK_ONLY_ONE);
	} else {
		alert(GNR_CHK_AT_LEAST_ONE);
	}
}

function hideAllContents(){
	for(var i=0;i<5;i++){
		document.getElementById("tab"+i).parentNode.className="";
		document.getElementById("content"+i).style.display="none";
	}
}

function btnDep_click(){
	var cant = chksChecked(document.getElementById("gridList"));
	if(cant == 1) {
		document.getElementById("frmMain").action = "execution.EntInstanceAction.do?action=viewDeps";
		submitForm(document.getElementById("frmMain"));	
	} else if (cant > 1) {
		alert(GNR_CHK_ONLY_ONE);
	} else {
		alert(GNR_CHK_AT_LEAST_ONE);
	}
}


function btnSearch_click() {
	if (verifyRequiredObjects()) {
		document.getElementById("frmMain").action = "execution.EntInstanceAction.do?action=search";
		submitForm(document.getElementById("frmMain"));
	}
}

function orderBy(order){
	document.getElementById("frmMain").action = "execution.EntInstanceAction.do?action=order&orderBy=" + order;
	submitForm(document.getElementById("frmMain"));
}

function first() {
	document.getElementById("frmMain").action = "execution.EntInstanceAction.do?action=first";
	submitForm(document.getElementById("frmMain"));
}
function prev() {
	document.getElementById("frmMain").action = "execution.EntInstanceAction.do?action=prev";
	submitForm(document.getElementById("frmMain"));
}
function next() {
	document.getElementById("frmMain").action = "execution.EntInstanceAction.do?action=next";
	submitForm(document.getElementById("frmMain"));
}
function last() { 
	document.getElementById("frmMain").action = "execution.EntInstanceAction.do?action=last";
	submitForm(document.getElementById("frmMain"));
}
function goToPage(){
	document.getElementById("frmMain").target = "";
	document.getElementById("frmMain").action="execution.EntInstanceAction.do?action=page";
	submitForm(document.getElementById("frmMain"));
}
function startProcCreation(){
	if (verifyRequiredObjects()) {
		document.getElementById("txtBusEntId").disabled=false;
		document.getElementById("frmMain").action = "execution.EntInstanceAction.do?action=startCreation";
		submitForm(document.getElementById("frmMain"));
	}
}

function btnConf_click() {

	if (verifyRequiredObjects()) {

		try {
			if (!submitFormsData_E()) {
				return;
			}
		} catch (e){
			
		}

		try {
			if (!submitFormsData_F()) {
				return;
			}
		} catch (e){
			
		}
	
		if (QUERY_ADMIN) {
			if (FROM_URL){
				document.getElementById("frmMain").action = "query.EntInstanceAction.do?action=confirm&fromUrl=true";
			}else{
				document.getElementById("frmMain").action = "query.EntInstanceAction.do?action=confirm";
			}
		} else {
			if (FROM_URL){
				document.getElementById("frmMain").action = "execution.EntInstanceAction.do?action=confirm&specific="+SPECIFIC_ADMIN + "&fromUrl=true";
			}else{
				document.getElementById("frmMain").action = "execution.EntInstanceAction.do?action=confirm&specific="+SPECIFIC_ADMIN;
			}	
		}
	
		//- por si algun formulario ten?a ajax, quitar el target
		document.getElementById("frmMain").target = "_self";
	
		//- verificar si el submit no debe ir a un iframe
		if (window.parent.frames.length == 3) {
			document.getElementById("frmMain").target = "ifrTarget";
		}
		
		if(IS_MODAL){
			document.getElementById("frmMain").action = document.getElementById("frmMain").action + "&inModal=true"
		}
		try{
			document.getElementById("frmMain").action=document.getElementById("frmMain").action+"&selTab="+document.getElementById("samplesTab").getSelectedTabIndex();
		} catch (e) {
		}
		submitForm(document.getElementById("frmMain"));
	}
}

function btnExit_click(){
	var msg = confirm(GNR_PER_DAT_ING);
	if (msg) {
		splash();
	}
}
/*
function btnBack_click() {
	document.getElementById("frmMain").action = "execution.EntInstanceAction.do?action=backToList";
	submitForm(document.getElementById("frmMain"));
}
*/

function btnAnt_click() {
	document.getElementById("frmMain").target = "";
	document.getElementById("frmMain").action="query.QueryAction.do?action=returnAction";
	document.getElementById("frmMain").submit();
}


function btnSignData_click(){
		
		document.getElementById("frmMain").action = "execution.EntInstanceAction.do?action=signData";
		submitFormReload(document.getElementById("frmMain"));
		document.getElementById("btnExit").focus();
}
