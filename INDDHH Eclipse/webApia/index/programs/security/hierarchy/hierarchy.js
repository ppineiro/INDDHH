function btnConf_click() {
	getXml();
}

function btnUpl_click(){
	var rets = openModal("/security.GroupHierarchyAction.do?action=upload" + windowId,700,280);
	var doAfter=function(rets){
	}
	rets.onclose=function(){
		doAfter(rets.returnValue);
		if (rets.returnValue==true){
			document.getElementById("frmMain").action = "security.GroupHierarchyAction.do?action=refresh";			
			document.getElementById("frmMain").submit();
		}
	}
}

function btnDow_click(){
	
	var rets = openModal("/security.GroupHierarchyAction.do?action=download" + windowId,(getStageWidth()*.4),(getStageHeight()*.20));
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
			
			document.getElementById("frmMain").action = "security.GroupHierarchyAction.do?action=" + action;			
			document.getElementById("frmMain").target = "idResult";
			document.getElementById("frmMain").submit();
		}
	}	
	rets.onclose=function(){
		doAfter(rets.returnValue);
	}
}