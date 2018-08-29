var chartWidget;
function setChartWidget(widget){
	chartWidget=widget;
	chartWidget.openTaskList=function(workMode,proName,tskName,grpName){
		//var strFilter="&hidColName=PRO_TITLE&hidColName=TSK_TITLE&hidColName=USERS_POOL&hidValue="+proName+"&hidValue="+tskName+"&hidValue="+grpName;
		//var strFilter="&hidOpLog=&hidOpLog=AND&hidOpLog=AND&hidColName=51&hidColName=50&hidColName=3&hidRel=%3D&hidRel=%3D&hidRel=%3D&hidValue="+proName+"&hidValue="+tskName+"&hidValue="+grpName;
		
		var strFilter="&hidOpLog=&";//"&hidOpLog=AND&hidOpLog=AND&";
		if(proName!=null){
			strFilter+="hidColName=51&"+"hidRel=%3D"+"&hidValue="+proName;
		}
		if(tskName!=null){
			strFilter+="hidColName=50&"+"hidRel=%3D"+"&hidValue="+tskName;
		}
		if(grpName!=null){
			strFilter+="hidColName=3&"+"hidRel=%3D"+"&hidValue="+grpName;
		}
		
		//var url="query.TaskListAction.do?action=viewList&query=" + document.getElementById("cmbList").value+"&preFilter=true&workMode="+type+strFilter;
		//var url="query.TaskListAction.do?action=viewList&query=0&preFilter=true&workMode="+workMode+strFilter;
		var url="execution.TasksListAction.do?action=init&preFilter=true&workMode="+workMode+strFilter;
		//var el=new element({text:"TASKLIST!",name:"TASKLIST!",url:url,icon:"" })
		//openElementWindow(el.getIconElement());
		var list;
		if(workMode=="R"){
			list=new genericFreeTasks(url+"&xml=true");
		}else{
			list=new genericMyTasks(url+"&xml=true");
		}
		list.openTaskList();
	}
}