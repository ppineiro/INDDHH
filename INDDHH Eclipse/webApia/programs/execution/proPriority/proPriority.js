function btnViewPro_click(){
	var rowId = getSelectedTaskId();
	if(rowId!=null){
		document.getElementById("frmMain").action = "execution.ProPriorityAction.do?action=viewProcess&" + rowId;
//		alert(document.getElementById("frmMain").action);
		submitForm(document.getElementById("frmMain"));	
	} else {
		alert(GNR_CHK_AT_LEAST_ONE);
	}
}

function btnConf_click(){
	document.getElementById("frmMain").action = "execution.ProPriorityAction.do?action=confirm";
	submitForm(document.getElementById("frmMain"));
}

function btnBack_click(){
	var msg = confirm(GNR_PER_DAT_ING);
	if (msg) {
		document.getElementById("frmMain").action = "execution.ProPriorityAction.do?action=backToList";
		submitForm(document.getElementById("frmMain"));
	}
}

function btnSearch_click() {
	document.getElementById("frmMain").action = "execution.ProPriorityAction.do?action=filter";
	submitForm(document.getElementById("frmMain"));
}

function first() {
	document.getElementById("frmMain").action = "execution.ProPriorityAction.do?action=first";
	submitForm(document.getElementById("frmMain"));
}
function prev() {
	document.getElementById("frmMain").action = "execution.ProPriorityAction.do?action=prev";
	submitForm(document.getElementById("frmMain"));
}
function next() {
	document.getElementById("frmMain").action = "execution.ProPriorityAction.do?action=next";
	submitForm(document.getElementById("frmMain"));
}
function last() { 
	document.getElementById("frmMain").action = "execution.ProPriorityAction.do?action=last";
	submitForm(document.getElementById("frmMain"));
}
function goToPage(){
	document.getElementById("frmMain").action="execution.ProPriorityAction.do?action=page";
	submitForm(document.getElementById("frmMain"));
}
function btnExit_click(){
	var msg = confirm(GNR_PER_DAT_ING);
	if (msg) {
		splash();
	}
}

function orderBy(order){
	document.getElementById("frmMain").action = "execution.ProPriorityAction.do?action=order&orderBy=" + order;
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
	/*var rowId;
	var oRows = document.getElementById("gridList").rows;
	for (var t=0;t<oRows.length;t++){
		if(oRows[t].selected==true){
			rowId = oRows[t].row_id;
		}
	}
	return rowId;*/
	if(document.getElementById("gridList").selectedItems.length > 0){
		return document.getElementById("gridList").selectedItems[0].getAttribute("row_id");
	} else {
		return null;
	}
}

function btnViewCalendar() {
    calId = document.getElementById("selCal").value;
	if (calId != 0){
		openModal("/programs/modals/calendarView.jsp?calendarId="+calId,600,500);
	}

}
