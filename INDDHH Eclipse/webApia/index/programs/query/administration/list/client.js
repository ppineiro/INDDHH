var lastSelection = null;

function deselectRowOrCell(r) {
  r.className = r.orgClassName;
  r.selected=false;
}

function selectRowOrCell(r) {
  r.orgClassName = r.className
  r.className = "trSelected";
  r.selected=true;
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
	var task = "";
	var r = null;
	var lastSelections=document.getElementById("gridList").selectedItems;
	for (i = 0; i < lastSelections.length; i++) {
    	r = lastSelections[i];
    	task += "&" +r.getAttribute("task_id");
	}
	return task;
	/*var task;
	var oRows = document.getElementById("gridList").selectedItems;
	task = oRows[0].getAttribute("task_id");

	return task;*/
}

function splash_iframe(){
	splash();
}

function isOnlyOneSelected(){
	return document.getElementById("gridList").selectedItems.length == 1;
}

function isOneSelected(){
	return document.getElementById("gridList").selectedItems.length != 0;
}

function cantSelected(){
	return document.getElementById("gridList").selectedItems.length;
}

function btnCol_click(){
	var ret = openModal("/query.TaskListAction.do?action=columnModal&workMode=" + WORK_MODE,500,400);
	var doAfter=function(ret){
		if (ret == "OK") {
			first();
		}
	}
	ret.onclose=function(){
		doAfter(ret.returnValue);
	}
}
function btnTra_click(){
	if(isOneSelected()){
		if(isOnlyOneSelected()){
			var taskId = getSelectedTaskId();
			if(taskId!=null){
				parent.loadFrame(2,"query.TaskListAction.do?action=work&workMode=" + WORK_MODE + taskId + window.parent.windowId);
				setDirtyBoth();	
			} 
		}else {
			alert(GNR_CHK_ONLY_ONE);
			}

	} else {
		alert(GNR_CHK_AT_LEAST_ONE);
	}
	
	/*var taskId = getSelectedTaskId();
	if(taskId!=null){
		parent.loadFrame(2,"query.TaskListAction.do?action=work&workMode=" + WORK_MODE + "&" + taskId);
		setDirtyBoth();	
	}*/
}

function btnFil_click(){
	var ret = openModal("/query.TaskListAction.do?action=filterModal&workMode=" + WORK_MODE,650,400);
	var doAfter=function(ret){
		if (ret == "OK") {
			first();
		}
	}
	ret.onclose=function(){
		doAfter(ret.returnValue);
	}
}

function btnExp_click(){
	var rets = openModal("/programs/modals/export.jsp?hiddeHtml=true&hiddeXPDL=true&hiddeCount=true&hiddeTXT=true",500,220);
	var doAfter=function(rets){
		if (rets != null) {
			var theAction = null;
			if (rets[0] == "pdf") {
				theAction = "generatePdf";
			} else if (rets[0] == "excel") {
				theAction = "generateExcel";
			} else if (rets[0] == "csv") {
				theAction = "generateCsv";
			} else if (rets[0] == "txt") {
				theAction = "generateTxt";
			}

			if (theAction != null) {
				document.getElementById("frmMain").target = "idResult";
				document.getElementById("frmMain").action="query.TaskListAction.do?workMode=" + WORK_MODE+ "&action=" + theAction;
				document.getElementById("frmMain").submit();
				document.getElementById("frmMain").target = "_self";
			}
		}
	}
	rets.onclose=function(){
		doAfter(rets.returnValue);
	}
}


function btnLib_click(){
	if(cantSelected()!=0) {
		var taskId = getSelectedTaskId();
		if(taskId!=null){
			document.getElementById("frmMain").action = "query.TaskListAction.do?action=release&workMode=" + WORK_MODE + taskId;
			submitForm(document.getElementById("frmMain"));
			setDirtyMode();	
		}
	} else {
		alert(GNR_CHK_AT_LEAST_ONE);
	}
	
	/*var taskId = getSelectedTaskId();
	if(taskId!=null){
		document.getElementById("frmMain").action = "query.TaskListAction.do?action=release&workMode=" + WORK_MODE + "&" + taskId;
		submitForm(document.getElementById("frmMain"));
		setDirtyMode();	
	}*/
}

function orderBy(order){
	document.getElementById("frmMain").action = "query.TaskListAction.do?action=order&workMode=" + WORK_MODE + "&orderBy=" + order;
	submitForm(document.getElementById("frmMain"));
}

function first() {
	document.getElementById("frmMain").action = "query.TaskListAction.do?action=first&workMode=" + WORK_MODE;
	submitForm(document.getElementById("frmMain"));
}
function prev() {
	document.getElementById("frmMain").action = "query.TaskListAction.do?action=prev&workMode=" + WORK_MODE;
	submitForm(document.getElementById("frmMain"));
}
function next() {
	document.getElementById("frmMain").action = "query.TaskListAction.do?action=next&workMode=" + WORK_MODE;
	submitForm(document.getElementById("frmMain"));
}
function last() { 
	document.getElementById("frmMain").action = "query.TaskListAction.do?action=last&workMode=" + WORK_MODE;
	submitForm(document.getElementById("frmMain"));
}

function refresh() { 
	document.getElementById("frmMain").action = "query.TaskListAction.do?action=refresh&workMode=" + WORK_MODE;
	submitForm(document.getElementById("frmMain"));
}

function changeOnlyMyTaskValue() { 
	document.getElementById("frmMain").action = "query.TaskListAction.do?action=changeOnlyMyTaskValue&workMode=" + WORK_MODE;
	submitForm(document.getElementById("frmMain"));
}

function btnCap_click(){
	if(cantSelected()!=0) {
		var taskId = getSelectedTaskId();
		if(taskId!=null){
			document.getElementById("frmMain").action = "query.TaskListAction.do?action=acquire&workMode=" + WORK_MODE + taskId;
			submitForm(document.getElementById("frmMain"));	
			setDirtyMode();	
		}
	} else {
		alert(GNR_CHK_AT_LEAST_ONE);
	}
	
	/*var taskId = getSelectedTaskId();
	if(taskId!=null){
		document.getElementById("frmMain").action = "query.TaskListAction.do?action=acquire&workMode=" + WORK_MODE + "&" + taskId;
		submitForm(document.getElementById("frmMain"));	
		setDirtyMode();	
	}*/
}
