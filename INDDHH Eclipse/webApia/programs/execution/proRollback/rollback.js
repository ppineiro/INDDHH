function chkSelected(obj, ready) {
	selectOneChk(obj);
/*	if (obj.checked) {
		if (!ready) {
			document.getElementById("btnRoll").disabled = true;
			document.getElementById("btnAdHoc").disabled = false;				
		} else {
			document.getElementById("btnRoll").disabled =	 false;
			document.getElementById("btnAdHoc").disabled = true;					
		}
	} else {
		document.getElementById("btnRoll").disabled = true;
		document.getElementById("btnAdHoc").disabled = true;				
	}*/
}

function btnRoll_click(){
	var cant = document.getElementById("gridList").selectedItems.length;
	if(cant == 1) {
		document.getElementById("frmMain").action = "execution.ProRollbackAction.do?action=rollback";
		submitForm(document.getElementById("frmMain"));
	} else {
		alert(GNR_CHK_AT_LEAST_ONE);
	}
}

function btnAdHoc_click(){
	var cant = document.getElementById("gridList").selectedItems.length;
	if(cant == 1) {
		document.getElementById("frmMain").action = "execution.ProRollbackAction.do?action=adhoc&adhoc=true";
		submitForm(document.getElementById("frmMain"));
	} else {
		alert(GNR_CHK_AT_LEAST_ONE);
	}
}

function btnConfAd_click(){
	var cant = document.getElementById("gridList").selectedItems.length;
	if(cant >= 1) {
		if (confirm(msgProRoll)) {
			document.getElementById("frmMain").action = "execution.ProRollbackAction.do?action=confirm";
			submitForm(document.getElementById("frmMain"));
		}
	} else {
		alert(GNR_CHK_AT_LEAST_ONE);
	}
}

function btnRollback_click(){
	var rowId = getSelectedTaskId();
	if(rowId!=null){
		document.getElementById("frmMain").action = "execution.ProRollbackAction.do?action=tasks&" + rowId;
		submitForm(document.getElementById("frmMain"));	
	} else {
		alert(GNR_CHK_AT_LEAST_ONE);
	}
}

function btnConf_click(){
	var cant = chksChecked(document.getElementById("gridList"));
	if(cant == 1) {
		if (confirm(msgProRol)) {
			document.getElementById("frmMain").action = "execution.ProRollbackAction.do?action=rollback";
			submitForm(document.getElementById("frmMain"));
		}
	} else {
		alert(GNR_CHK_AT_LEAST_ONE);
	}
}

function btnConfRol_click(){
	if (confirm(msgProRoll)) {
		document.getElementById("frmMain").action = "execution.ProRollbackAction.do?action=confirm";
		submitForm(document.getElementById("frmMain"));
	}
}

function btnBackTask_click() {
	document.getElementById("frmMain").action = "execution.ProRollbackAction.do?action=backToTasks";
	submitForm(document.getElementById("frmMain"));
}

function btnBack_click(){
	var msg = confirm(GNR_PER_DAT_ING);
	if (msg) {
		document.getElementById("frmMain").action = "execution.ProRollbackAction.do?action=backToList";
		submitForm(document.getElementById("frmMain"));
	}
}

function btnSearch_click() {
	document.getElementById("frmMain").action = "execution.ProRollbackAction.do?action=filter";
	submitForm(document.getElementById("frmMain"));
}

function first() {
	document.getElementById("frmMain").action = "execution.ProRollbackAction.do?action=first";
	submitForm(document.getElementById("frmMain"));
}
function prev() {
	document.getElementById("frmMain").action = "execution.ProRollbackAction.do?action=prev";
	submitForm(document.getElementById("frmMain"));
}
function next() {
	document.getElementById("frmMain").action = "execution.ProRollbackAction.do?action=next";
	submitForm(document.getElementById("frmMain"));
}
function last() { 
	document.getElementById("frmMain").action = "execution.ProRollbackAction.do?action=last";
	submitForm(document.getElementById("frmMain"));
}
function goToPage(){
	document.getElementById("frmMain").action="execution.ProRollbackAction.do?action=page";
	submitForm(document.getElementById("frmMain"));
}
function btnExit_click(){
	var msg = confirm(GNR_PER_DAT_ING);
	if (msg) {
		splash();
	}
}

function orderBy(order){
	document.getElementById("frmMain").action = "execution.ProRollbackAction.do?action=order&orderBy=" + order;
	submitForm(document.getElementById("frmMain"));
}

function orderTasksBy(){
	document.getElementById("frmMain").action = "execution.ProRollbackAction.do?action=orderTasks";
	submitForm(document.getElementById("frmMain"));
}

function toggleMonitorFilter(realSize, maxSize){
	if(document.getElementById("monitorFilterArea").style.display=="none"){
		document.getElementById("monitorFilterArea").style.display="block";
		//document.getElementById("gridList").style.height=realSize;
	}else{
		document.getElementById("monitorFilterArea").style.display="none";
		//document.getElementById("gridList").style.height=maxSize;
	}
}

var lastSelection = null;

function deselectRowOrCell(r) {
  r.className = r.orgClassName;
  r.selected=false;
}

function selectRowOrCell(r) {
  r.orgClassName = r.className;
  r.className = "trSelected";
  r.selected=true;
}

function selectTask(element) {
	var e, r, c;
	/*if (element == null) {
    	e = window.event.srcElement;
	} else {*/
    	e = element;
	//}
  	if (e.tagName == "TR") {
    	r = findRow(e);
		if (r != null) {
	      	if (lastSelection != null) {
	        	deselectRowOrCell(lastSelection);
	      	}
	      	selectRowOrCell(r);
	      	lastSelection = r;
    	}
	} else {
		c = findCell(e);
		if (c != null) {
			if (lastSelection != null) {
				deselectRowOrCell(lastSelection);
			}
			selectRowOrCell(c);
			lastSelection = c;
		}
	}

	//window.event.cancelBubble = true;
}

function findCell(e) {
	if (e.tagName == "TD") {
		return findRow(e.parentNode);
	} else if (e.tagName == "BODY") {
		return null;
	} else {
		return findCell(e.parentNode);
	}
}


document.onclick = cancelSelect;

function findRow(e) {
	if (e.tagName == "TR" && e.rowIndex!=0) {
		return e;
	} else if (e.tagName == "BODY") {
		return null;
	} else {
		return findRow(e.parentNode);
	}
}

function cancelSelect() {
	if (lastSelection != null) {
		deselectRowOrCell(lastSelection);
		lastSelection = null;
	}
}

function getSelectedTaskId(){
	var rowId;
	if(document.getElementById("gridList").selectedItems.length>0){
		var oRow = document.getElementById("gridList").selectedItems[0];
		rowId = oRow.getAttribute("row_id");
		return rowId;
	} else {
		return null;
	}
}
