
function getSelectedTaskId(){
	var task = "";
	var r = null;
	var lastSelections=document.getElementById("gridList").selectedItems;
	for (i = 0; i < lastSelections.length; i++) {
    	r = lastSelections[i];
    	if(navigator.userAgent.indexOf("MSIE")>0){
			task += "&" + r.task_id;
		}else{
			task += "&" +getValueOf(r,"task_id");
		}
	}

	return task;
}

function getValueOf(element,field){
	var value=null;
	for(var i=0;i<element.attributes.length;i++){
		if(element.attributes[i].nodeName.toLowerCase()==field){
			value=element.attributes[i].nodeValue;
		}
	}
	return value;
}

function splash_iframe(){
	splash();
}

function btnCap_click(){
	if(cantSelected()!=0) {
		var taskId = getSelectedTaskId();
		if(taskId!=null){
			document.getElementById("frmMain").action = "execution.TasksListAction.do?action=acquire&workMode=" + WORK_MODE + taskId;
			submitForm(document.getElementById("frmMain"));	
			setDirtyMode();	
		}
	} else {
		alert(GNR_CHK_AT_LEAST_ONE);
	}
	
}

function btnLib_click(){
	if(cantSelected()!=0) {
		var taskId = getSelectedTaskId();
		if(taskId!=null){
			document.getElementById("frmMain").action = "execution.TasksListAction.do?action=release&workMode=" + WORK_MODE + taskId;
			submitForm(document.getElementById("frmMain"));
			setDirtyMode();	
		}
	} else {
		alert(GNR_CHK_AT_LEAST_ONE);
	}
	
}

function btnTra_click(){
	if(isOneSelected()){
		if(isOnlyOneSelected()){
			var taskId = getSelectedTaskId();
			if(taskId!=null){
				parent.loadFrame(3,"execution.TasksListAction.do?action=work&workMode=" + WORK_MODE + taskId + window.parent.windowId);
				setDirtyBoth();	
			} 
		}else {
			alert(ONLY_ONE_SELECTED);
			}

	} else {
		alert(GNR_CHK_AT_LEAST_ONE);
	}
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

function first() {
	document.getElementById("frmMain").action = "execution.TasksListAction.do?action=first&workMode=" + WORK_MODE;
	submitForm(document.getElementById("frmMain"));
}
function prev() {
	document.getElementById("frmMain").action = "execution.TasksListAction.do?action=prev&workMode=" + WORK_MODE;
	submitForm(document.getElementById("frmMain"));
}
function next() {
	document.getElementById("frmMain").action = "execution.TasksListAction.do?action=next&workMode=" + WORK_MODE;
	submitForm(document.getElementById("frmMain"));
}
function last() { 
	document.getElementById("frmMain").action = "execution.TasksListAction.do?action=last&workMode=" + WORK_MODE;
	submitForm(document.getElementById("frmMain"));
}

function goToPage(){
	document.getElementById("frmMain").action="execution.TasksListAction.do?action=page&workMode=" + WORK_MODE;
	submitForm(document.getElementById("frmMain"));
}

function refresh() {
	document.getElementById("frmMain").action = "execution.TasksListAction.do?action=refresh&workMode=" + WORK_MODE;
	submitForm(document.getElementById("frmMain"));
}

function orderBy(order){
	document.getElementById("frmMain").action = "execution.TasksListAction.do?action=order&workMode=" + WORK_MODE + "&orderBy=" + order;
	submitForm(document.getElementById("frmMain"));
}

function btnFil_click(){
	var ret = openModal("/execution.TasksListAction.do?action=filterModal&workMode=" + WORK_MODE,700,400);
	ret.onclose=function(){
		if (ret.returnValue == "OK") {
			first();
		}
	}
	/*if (window.navigator.appVersion.indexOf("MSIE")<0){
		var aux=ret.document;
		var isOpen=true;
		ret.onunload=function(event){
			event.cancelBubble=true;
			if(!isOpen){
				if (ret.returnValue == "OK") {
					first();
				}
			}
			isOpen=false;
	    }
    }else{
		if (ret == "OK") {
			first();
		}
	}*/
}

function btnCol_click(){
	var ret = openModal("/execution.TasksListAction.do?action=columnModal&workMode=" + WORK_MODE,500,400);
	ret.onclose=function(){
		if (ret.returnValue == "OK") {
			first();
		}
	}
	/*if (window.navigator.appVersion.indexOf("MSIE")<0){
		var aux=ret.document;
		var isOpen=true;
		ret.onunload=function(event){
			event.cancelBubble=true;
			if(!isOpen){
 				if (ret.returnValue == "OK") {
					first();
				}
			}
			isOpen=false;
	    }
    }else{
		if (ret == "OK") {
			first();
		}
	}*/
}

function btnExp_click(){
	var rets = openModal("/programs/modals/exportTaskList.jsp?hiddeHtml=true",500,220);
	var doAfter=function(rets){
		if (rets != null) {
			if (rets[0] == "pdf") {
				exportPDF_click(rets[1]);
			} else if (rets[0] == "excel") {
				exportExcel_click(rets[1]);
			} else if (rets[0] == "csv") {
				exportCSV_click(rets[1]);
			}
		}
	}
	rets.onclose=function(){
		doAfter(rets.returnValue);
	}
}

function exportCSV_click(count) {
	document.getElementById("frmMain").target = "idResult";
	document.getElementById("frmMain").action="execution.TasksListAction.do?action=exportCsv&workMode=" + WORK_MODE + "&count=" + count;
	document.getElementById("frmMain").submit();
	document.getElementById("frmMain").target = "_self";
}

function exportExcel_click(count) {
	document.getElementById("frmMain").target = "idResult";
	document.getElementById("frmMain").action="execution.TasksListAction.do?action=exportExcel&workMode=" + WORK_MODE + "&count=" + count;
	document.getElementById("frmMain").submit();
	document.getElementById("frmMain").target = "_self";
}

function exportPDF_click(count) {
	document.getElementById("frmMain").target = "idResult";
	document.getElementById("frmMain").action="execution.TasksListAction.do?action=exportPDF&workMode=" + WORK_MODE + "&count=" + count;
	document.getElementById("frmMain").submit();
	document.getElementById("frmMain").target = "_self";
}
