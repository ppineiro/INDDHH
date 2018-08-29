function btnNew_click(){
	document.getElementById("frmMain").action = "scheduler.SchedulerAction.do?action=new";
	submitForm(document.getElementById("frmMain"));
}

function btnRun_click(){
	var cant = chksChecked(document.getElementById("gridList"));
	if(cant == 1) {
		document.getElementById("frmMain").action = "scheduler.SchedulerAction.do?action=runNow";
		submitForm(document.getElementById("frmMain"));	
	} else if (cant > 1) {
		alert(GNR_CHK_ONLY_ONE);
	} else {
		alert(GNR_CHK_AT_LEAST_ONE);
	}
}

function btnDep_click(){
	var cant = chksChecked(document.getElementById("gridList"));
	if(cant == 1) {
		document.getElementById("frmMain").action = "scheduler.SchedulerAction.do?action=viewDep";
		submitForm(document.getElementById("frmMain"));	
	} else if (cant > 1) {
		alert(GNR_CHK_ONLY_ONE);
	} else {
		alert(GNR_CHK_AT_LEAST_ONE);
	}
}

function btnDel_click(){
	var cant = chksChecked(document.getElementById("gridList"));
	if(cant != 0) {
		if (chckModify()){
			if (confirm(GNR_DELETE_RECORD)) {
				document.getElementById("frmMain").action = "scheduler.SchedulerAction.do?action=remove";
				submitForm(document.getElementById("frmMain"));
			}
		}else{
				alert(MSG_SCH_NO_DELETABLE);
			}
	} else {
		alert(GNR_CHK_AT_LEAST_ONE);
	}
}

function btnEnaDis_click(){
	var cant = chksChecked(document.getElementById("gridList"));
	if(cant != 0) {
		document.getElementById("frmMain").action = "scheduler.SchedulerAction.do?action=enable";
		submitForm(document.getElementById("frmMain"));
	} else {
		alert(GNR_CHK_AT_LEAST_ONE);
	}
}

function btnMod_click(){
	var cant = chksChecked(document.getElementById("gridList"));
	if(cant == 1) {
		if (chckModify()){
			document.getElementById("frmMain").action = "scheduler.SchedulerAction.do?action=update";
			submitForm(document.getElementById("frmMain"));	
		}else{
			alert(MSG_SCH_NO_UPDATABLE);
		}
	} else if (cant > 1) {
		alert(GNR_CHK_ONLY_ONE);
	} else {
		alert(GNR_CHK_AT_LEAST_ONE);
	}
}

//Verifica no se este modificando un scheduler que no se puede editar
function chckModify() {
	var selected = document.getElementById("gridList").selectedItems[0].rowIndex - 1;
	var rows=document.getElementById("gridList").rows;
	var schId=rows[selected].cells[0].getElementsByTagName("INPUT")[2].value;
	var busClaId = rows[selected].cells[0].getElementsByTagName("INPUT")[3].value;
	//Verifico si es un scheduler de carga de datawarehouse por defecto
	if (schId=='500' || schId=='501' || schId=='502' || schId=='503' || busClaId=='600' || busClaId=='601' || busClaId=='602'){
		return false;
	}
	var schName=rows[selected].cells[3].innerHTML;
	//Verifico si es un schedule de carga de datawarehouse generado automaticamente
	if (schName.indexOf("SCHEMA LOADER FOR CUBE")!=-1){
		return false;
	}
	//Verifico si es un scheduler de ejecución de widgets generado automaticamente
	if (schName.indexOf(WIDGET_SCHEDULER_NAME)==0){
		return false;
	}
	return true;
}

function btnSearch_click() {
	document.getElementById("frmMain").action = "scheduler.SchedulerAction.do?action=search";
	submitForm(document.getElementById("frmMain"));
}

function orderBy(order){
	document.getElementById("frmMain").action = "scheduler.SchedulerAction.do?action=order&orderBy=" + order;
	submitForm(document.getElementById("frmMain"));
}

function first() {
	document.getElementById("frmMain").action = "scheduler.SchedulerAction.do?action=first";
	submitForm(document.getElementById("frmMain"));
}

function prev() {
	document.getElementById("frmMain").action = "scheduler.SchedulerAction.do?action=prev";
	submitForm(document.getElementById("frmMain"));
}

function next() {
	document.getElementById("frmMain").action = "scheduler.SchedulerAction.do?action=next";
	submitForm(document.getElementById("frmMain"));
}

function last() { 
	document.getElementById("frmMain").action = "scheduler.SchedulerAction.do?action=last";
	submitForm(document.getElementById("frmMain"));
}
function goToPage(){
	document.getElementById("frmMain").action="scheduler.SchedulerAction.do?action=page";
	submitForm(document.getElementById("frmMain"));
}
function btnRefresh_click(){
	document.getElementById("frmMain").action="scheduler.SchedulerAction.do?action=page";
	submitForm(document.getElementById("frmMain"));
}