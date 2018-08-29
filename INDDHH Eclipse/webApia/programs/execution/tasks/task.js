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
	
	var divContentHeight = document.getElementById("divContent").style.height;
	//document.getElementById("divContent").style.height = "";
	document.getElementById("printForm").body.value = "";
	document.getElementById("printForm").body.value = processBodyToPrint();
   //document.getElementById("divContent").style.height = divContentHeight;

    //styleWin.focus();

	var modal=openModal("/frames/blank.jsp", 680,400);
	document.getElementById("printForm").target=modal.content.name;//"Print";
	function submitPrint(){
		document.getElementById("printForm").submit();
	    document.getElementById("printForm").body.value = "";
    }
    modal.onload=function(){
    	submitPrint();
    }
	var selectedTab = null;
	
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

//-- Otras funciones --//
var submitPerformed = false;

//como no siempre estan los botones, los ponemos en un try
processButtons(false);

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

function submitFormExit(obj,frmName) {
	if (submitPerformed ==  true){
		return false;
	}

	obj.target = "_self";
	obj.submit();
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

function btnSave_click(){
	saving = true;
	try {
		if (!submitFormsData_E()) {
			return;
		}
	} catch (e){
		
	}

	try {
		if (!submitFormsData_P()) {
			return;
		}
	} catch (e){
		
	}

	processButtons(BTN_SAVE_EXIT);
	document.getElementById("frmMain").action = "execution.TaskAction.do?action=saveTask";
	if(BTN_SAVE_EXIT=="false"){
		submitFormFrame(document.getElementById("frmMain"));
	}else{	
		submitFormExit(document.getElementById("frmMain"));
	}
}

function btnLast_click(){
	
	firedByStepBack = true;
	firedByStepNext = false;
	firedByConfirm = false;
	
		try {
			if (!submitFormsData_E()) {
				return;
			}
		} catch (e){
			
		}

		try {
			if (!submitFormsData_P()) {
				return;
			}
		} catch (e){

		}

		try {
			if (!stepOnChange("btnLast")) {
				return;
			}
		} catch (e){
			//alert(e);
		}
		
		processButtons(true);
		document.getElementById("frmMain").action = "execution.TaskAction.do?action=lastStep";
		submitFormReload(document.getElementById("frmMain"));

}

function btnNext_click(){

	firedByStepBack = false;
	firedByStepNext = true;
	firedByConfirm = false;
	
	if (verifyRequiredObjects()) {

		try {
			if (!submitFormsData_E()) {
				return;
			}
		} catch (e){
			
		}

		try {
			if (!submitFormsData_P()) {
				return;
			}
		} catch (e){
			
		}
	

		try {
			if (!stepOnChange("btnNext")) {
				return;
			}
		} catch (e){
		
		}

		processButtons(true);
		document.getElementById("frmMain").action = "execution.TaskAction.do?action=nextStep";
		submitFormReload(document.getElementById("frmMain"));
	}
}

function btnFree_click(var1, var2){
	processButtons(true);
	if (window.name != "iframeAjax") {
		document.getElementById("frmMain").action = "execution.TaskAction.do?action=release&proInstId="+var1+"&proEleInstId="+var2;
		submitFormReload(document.getElementById("frmMain"));
	} else {
		submitPerformed = false;
 		window.parent.submitPerformed = false;
		window.parent.document.getElementById("frmMain").action = "execution.TaskAction.do?action=release&proInstId="+var1+"&proEleInstId="+var2;
		window.parent.submitFormReload(window.parent.document.getElementById("frmMain"));
	}
	
}

function btnFreeQuery_click(var1, var2){
	processButtons(true);
	if (window.name != "iframeAjax") {
		document.getElementById("frmMain").action = "execution.TaskAction.do?action=release&proInstId="+var1+"&proEleInstId="+var2;
		submitFormReload(document.getElementById("frmMain"));
	} else {
		submitPerformed = false;
 		window.parent.submitPerformed = false;
		window.parent.document.getElementById("frmMain").target = "_self";
		window.parent.document.getElementById("frmMain").action = "execution.TaskAction.do?action=release&proInstId="+var1+"&proEleInstId="+var2;
		window.parent.submitFormReload(window.parent.document.getElementById("frmMain"));
 
	}
}

function btnConf_click(){
	saving = false;
	firedByStepBack = false;
	firedByStepNext = false;
	firedByConfirm = true;
	
	if (verifyRequiredObjects()) {
		try {
			var test=submitFormsData_E();
			if (!test) {
				return;
			}
		} catch (e){
		}

		try {
			var test=submitFormsData_P();
			if (!test) {
				return;
			}
		} catch (e){

		}
		processButtons(true);
		if (FROM_URL){
			document.getElementById("frmMain").action = "execution.TaskAction.do?action=confirm&fromUrl=true";
		}else{
			document.getElementById("frmMain").action = "execution.TaskAction.do?action=confirm";
		}
		
		try{
			document.getElementById("frmMain").action=document.getElementById("frmMain").action+"&selTab="+document.getElementById("samplesTab").getSelectedTabIndex();
		} catch (e) {
		}
		submitFormFrame(document.getElementById("frmMain"));
		document.getElementById("btnExit").focus();
	}
}

function btnSignData_click(){
		processButtons(true);
		document.getElementById("frmMain").action = "execution.TaskAction.do?action=signData";
		submitFormReload(document.getElementById("frmMain"));
		document.getElementById("btnExit").focus();
}

function btnDelegate_click(){
	if (confirm(mesNoSave)) {
		processButtons(true);
		document.getElementById("frmMain").action = "execution.TaskAction.do?action=delegate";
		submitFormFrame(document.getElementById("frmMain"));
	}
}

function btnExit_click(){

	if (FROM_URL) {
		window.location.href = "FramesAction.do?action=splash";
	}else {
		if(document.getElementById("btnSave") && AUTOSAVE){
			if(AUTOSAVE_CONF){
				if(confirm(AUTOSAVE_CONF_MSG)){
					document.getElementById("frmMain").target = "ifrAutoSave";
					document.getElementById("frmMain").action = "execution.TaskAction.do?action=autosave";
					submitForm(document.getElementById("frmMain"));
				} else {
					splash_iframe();
				}
			} else {
				document.getElementById("frmMain").target = "ifrAutoSave";
				document.getElementById("frmMain").action = "execution.TaskAction.do?action=autosave";
				submitForm(document.getElementById("frmMain"));
			}
		}else{
			splash_iframe();
		}
	}
}

function btnExit_click_noConfirm(){
	if(AUTOSAVE){
		if (document.getElementById("btnSave") && document.getElementById("btnSave").disabled) return;
		document.getElementById("frmMain").target = "ifrAutoSave";
		document.getElementById("frmMain").action = "execution.TaskAction.do?action=autosave";
		submitForm(document.getElementById("frmMain"));
	}else{
		splash_iframe();
	}
}


//-----------------------------------------------------------------------------------------------------
//function btnExit_clickDesk(){
//	if(AUTOSAVE){
//		document.getElementById("frmMain").target = "ifrAutoSave";
//		document.getElementById("frmMain").action = "execution.TaskAction.do?action=autosave";
//		//submitForm(document.getElementById("frmMain"));
//		submitFormWithoutWaitScreen(document.getElementById("frmMain"));
//	 }
//}


function splash_iframe(){
	splash();
}

function btnAnt_click() {
	processButtons(true);
	document.getElementById("frmMain").target = "";
	document.getElementById("frmMain").action="query.QueryAction.do?action=returnAction";
	document.getElementById("frmMain").submit();
}

function btnVol_click() {
	var msg = confirm(GNR_PER_DAT_ING);
	if (msg) {
		processButtons(true);
		document.getElementById("frmMain").target = "";

		if(CANCEL_PROCESS){
			document.getElementById("frmMain").action = CANCEL_BACK_URL;
		} else if(ALTER_PROCESS){
			document.getElementById("frmMain").action = ALTER_BACK_URL;	
		} else if (QUERY_GO_BACK) {
			document.getElementById("frmMain").action = "query.QueryAction.do?action=returnAction";
		} else if (QUERY_ADMIN) {
			document.getElementById("frmMain").action = "query.QueryAction.do?action=backToList";
		} else if(ALTER_ENTITY) {
//			document.getElementById("frmMain").action = "execution.EntInstanceAction.do?action=backToList";
			document.getElementById("frmMain").action = "execution.EntInstanceAction.do?action=init&txtBusEntId="+txtBusEntId+"&txtBusEntAdm="+txtBusEntAdm;
		} else {
			if(SPECIFIC_ADMIN) {
				document.getElementById("frmMain").action = "execution.EntInstanceAction.do?action=backToList";
			} else {
				document.getElementById("frmMain").action = "execution.EntInstanceAction.do?action=init";
			}
		}
		document.getElementById("frmMain").submit();
	}
}


function processButtons(status){
		try{
			document.getElementById("btnLast").disabled = ((status+"")=="true");
		} catch(e){}
		try{
			document.getElementById("btnNext").disabled = ((status+"")=="true");
		} catch(e){}
		try{
			document.getElementById("btnConf").disabled = ((status+"")=="true");
		} catch(e){}
		try{
			document.getElementById("btnSave").disabled = ((status+"")=="true");
		} catch(e){}
		try{
			document.getElementById("btnFree").disabled = ((status+"")=="true");
		} catch(e){}
		try{
			document.getElementById("btnPrint").disabled = ((status+"")=="true");
		} catch(e){}
		try{
			document.getElementById("btnDelegate").disabled = ((status+"")=="true");
		} catch(e){}
		try{
			document.getElementById("btnElevate").disabled = ((status+"")=="true");
		} catch(e){
		}
}

function btnViewCalendar() {
    calId = document.getElementById("selCal").value;
	if (calId != 0){
		openModal("/programs/modals/calendarView.jsp?calendarId="+calId,600,500);
	}

}