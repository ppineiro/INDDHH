function btnSuspend_click(){
	var rowId = getSelectedTaskId();
	if(rowId!=null){
		document.getElementById("frmMain").action = "execution.ProSuspendAction.do?action=suspend&" + rowId;
		submitForm(document.getElementById("frmMain"));	
	}else {
		alert(GNR_CHK_AT_LEAST_ONE);
	}
}

function btnContinue_click(){
	var rowId = getSelectedTaskId();
	if(rowId!=null){
		document.getElementById("frmMain").action = "execution.ProSuspendAction.do?action=continue&" + rowId;
		submitForm(document.getElementById("frmMain"));
	}else {
		alert(GNR_CHK_AT_LEAST_ONE);
	}
}

function btnSearch_click() {
	document.getElementById("frmMain").action = "execution.ProSuspendAction.do?action=filter";
	submitForm(document.getElementById("frmMain"));
}

function first() {
	document.getElementById("frmMain").action = "execution.ProSuspendAction.do?action=first";
	submitForm(document.getElementById("frmMain"));
}
function prev() {
	document.getElementById("frmMain").action = "execution.ProSuspendAction.do?action=prev";
	submitForm(document.getElementById("frmMain"));
}
function next() {
	document.getElementById("frmMain").action = "execution.ProSuspendAction.do?action=next";
	submitForm(document.getElementById("frmMain"));
}
function last() { 
	document.getElementById("frmMain").action = "execution.ProSuspendAction.do?action=last";
	submitForm(document.getElementById("frmMain"));
}
function goToPage(){
	document.getElementById("frmMain").action="execution.ProSuspendAction.do?action=page";
	submitForm(document.getElementById("frmMain"));
}
function btnExit_click(){
	splash();
}

function orderBy(order){
	document.getElementById("frmMain").action = "execution.ProSuspendAction.do?action=order&orderBy=" + order;
	submitForm(document.getElementById("frmMain"));
}

function orderTasksBy(){
	document.getElementById("frmMain").action = "execution.ProSuspendAction.do?action=orderTasks";
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
	if (element == null) {
    	e = window.event.srcElement;
	} else {
    	e = element;
	}
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

	window.event.cancelBubble = true;
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
		var rowId = oRow.getAttribute("row_id");
		return rowId;
	} else {
		return null;
	}
}
