function btnExit_click(){
	splash();
}


function openTaskList(type,oTr){
		var proName = trim(oTr.cells[0].getElementsByTagName("SPAN")[0]?oTr.cells[0].getElementsByTagName("SPAN")[0].firstChild.data:oTr.cells[0].firstChild.data);
		var tskName = trim(oTr.cells[1].getElementsByTagName("SPAN")[0]?oTr.cells[1].getElementsByTagName("SPAN")[0].firstChild.data:oTr.cells[1].firstChild.data);
		var grpName = trim(oTr.cells[2].getElementsByTagName("SPAN")[0]?oTr.cells[2].getElementsByTagName("SPAN")[0].firstChild.data:oTr.cells[2].firstChild.data);
		
		 
		//alert(oTr.cells[0].innerHTML);
		if(document.getElementById("cmbList").value==0){
			var strFilter="&hidOpLog=&hidOpLog=AND&hidOpLog=AND&hidColName=51&hidColName=50&hidColName=3&hidRel=%3D&hidRel=%3D&hidRel=%3D&hidValue="+proName+"&hidValue="+tskName+"&hidValue="+grpName;
		
			//if(windowId==""){
				document.getElementById("frmx").action="execution.TasksListAction.do?action=init&preFilter=true&workMode="+type+strFilter;
				if(windowId==""){
					submitForm(document.getElementById("frmx"));
				}else{
					submitFormToNewDeskWin(document.getElementById("frmx"));
				}
			//} else {
			//	var url = document.getElementById("frmx").action;
			//	var atts={text:"text",name:"name",url:url,icon:"icon"};
			//	var winElement=new element(atts);
			//	openElementWindow(winElement.getIconElement());			
			//}
		} else {
			//ejecutar lista de usuario con id = document.getElementById("cmbList").value
			var strFilter="&hidColName=PRO_TITLE&hidColName=TSK_TITLE&hidColName=USERS_POOL&hidValue="+proName+"&hidValue="+tskName+"&hidValue="+grpName;
		//	if(windowId==""){
				document.getElementById("frmx").action="query.TaskListAction.do?action=viewList&query=" + document.getElementById("cmbList").value+"&preFilter=true&workMode="+type+strFilter;
				if(windowId==""){
					submitForm(document.getElementById("frmx"));
				}else{
					submitFormToNewDeskWin(document.getElementById("frmx"));
				}
			//} else {
			//	var url = document.getElementById("frmx").action;
			//	var atts={text:"text",name:"name",url:url,icon:"icon"};
			//	var winElement=new element(atts);
			//	openElementWindow(winElement.getIconElement());			
			//}
		}

}

function trim(str){
	while(str.charAt(0)==" "){
		str=str.substring(1);
	}
	while(str.charAt(str.length-1)==" "){
		str=str.substring(0,(str.length-1));
	}
	return str;
}

function btnRefresh_click(){
	document.getElementById("frmx").target = "";
	document.getElementById("frmx").action="execution.UserWorkResumeAction.do?action=init";
	submitForm(document.getElementById("frmx"));
}