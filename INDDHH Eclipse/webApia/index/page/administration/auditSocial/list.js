var optsTitEnvironment;
var optsTitProcess;
var optsTitTasks;
var optsTitPools;
var optsTitUsers;

function initPage(){
	getTabContainerController().changeTabState(TAB_ID, false); 
	
	//crear spinner de espere un momento
	sp = new Spinner($('gridBody').getParent(),{message:WAIT_A_SECOND});
	
	['orderByObjType','orderByObjTitle','orderByMsgContent','orderByMsgAuthor','orderByMsgDate'].each(setAdmOrder);
	['orderByObjType','orderByObjTitle','orderByMsgContent','orderByMsgAuthor','orderByMsgDate'].each(setAdmListTitle);
	['msgContentFilter','msgAuthorFilter'].each(setAdmFilters);
	
	$('msgDteFromFilter').setFilter = setFilter;
	$('msgDteFromFilter').addEvent("change", function(e) { this.setFilter(); });
	$('msgDteToFilter').setFilter = setFilter;
	$('msgDteToFilter').addEvent("change", function(e) { this.setFilter(); });
	
	$('clearFilters').addEvent("click", function(e) {
		e.stop();
		['msgContentFilter','msgAuthorFilter','objTypeFilter','objTitleFilter'].each(clearFilter);
		['msgDteFromFilter','msgDteToFilter'].each(clearFilterDate);
		cleanObjTitleFilter();
		$('msgContentFilter').setFilter();
	});
	
	
	$('btnMsgView').addEvent("click",function(e){
		e.stop();
		if (selectionCount($('tableData')) > 1) {
			showMessage(GNR_CHK_ONLY_ONE, GNR_TIT_WARNING, 'modalWarning');
		} else if (selectionCount($('tableData')) == 0) {
			showMessage(GNR_CHK_AT_LEAST_ONE, GNR_TIT_WARNING,'modalWarning');
		} else {
			var id = getSelectedRows($('tableData'))[0].getRowId();
			var request = new Request({
				method : 'post',
				url : CONTEXT + URL_REQUEST_AJAX + '?action=viewMessage&isAjax=true' + TAB_ID_REQUEST,
				onRequest : function() { SYS_PANELS.showLoading(); },
				onComplete : function(resText, resXml) { modalProcessXml(resXml); }
			}).send('id=' + id);
		}
	});
	
	
	initAdminActions(true,true,true,false,true,false);
	$('btnDelete').addClass("suggestedAction");
	
	initNavButtons();
	
	loadTitleOptions();
	
	callNavigate();
}


function setFilter(){
	callNavigateFilter({
			txtObjType: $('objTypeFilter').value,
			txtObjid: $('objTitleFilter').value,			
			txtMsgContent: $('msgContentFilter').value,
			txtMsgAuthor: $('msgAuthorFilter').value,
			txtDteFrom: $('msgDteFromFilter').value,
			txtDteTo: $('msgDteToFilter').value
		},null);
}

function loadTitleOptions(){
	var request = new Request({
		method : 'post',
		url : CONTEXT + URL_REQUEST_AJAX + '?action=loadTitleOptions&isAjax=true' + TAB_ID_REQUEST,
		onRequest : function() { },
		onComplete : function(resText, resXml) { processXmlTitleOptions(resXml); }
	}).send();
}

function processXmlTitleOptions(resXml){
	var result = resXml.getElementsByTagName("result")
	if (result != null && result.length > 0 && result.item(0) != null) {
		result = result.item(0);
		
		//Ambientes
		var environments = result.getElementsByTagName("environment");
		optsTitEnvironment = new Array();
		if (environments != null && environments.length > 0 && environments.item(0) != null){
			environments = environments.item(0).getElementsByTagName("option");
			if (environments != null && environments.length > 0){
				for (var i = 0; i < environments.length; i++){
					var env = environments[i];
					optsTitEnvironment.push({'value':env.getAttribute("id"),'text':env.getAttribute("text")});
				}
			}
		}
		
		//Procesos
		var processes = result.getElementsByTagName("process");
		optsTitProcess = new Array();
		if (processes != null && processes.length > 0 && processes.item(0) != null){
			processes = processes.item(0).getElementsByTagName("option");
			if (processes != null && processes.length > 0){
				for (var i = 0; i < processes.length; i++){
					var pro = processes[i];
					optsTitProcess.push({'value':pro.getAttribute("id"),'text':pro.getAttribute("text")});
				}
			}
		}
		
		//Tareas
		var tasks = result.getElementsByTagName("task");
		optsTitTasks = new Array();
		if (tasks != null && tasks.length > 0 && tasks.item(0) != null){
			tasks = tasks.item(0).getElementsByTagName("option");
			if (tasks != null && tasks.length > 0){
				for (var i = 0; i < tasks.length; i++){
					var tsk = tasks[i];
					optsTitTasks.push({'value':tsk.getAttribute("id"),'text':tsk.getAttribute("text")});
				}
			}
		}
		
		//Grupos
		var pools = result.getElementsByTagName("pool");
		optsTitPools = new Array();
		if (pools != null && pools.length > 0 && pools.item(0) != null){
			pools = pools.item(0).getElementsByTagName("option");
			if (pools != null && pools.length > 0){
				for (var i = 0; i < pools.length; i++){
					var pool = pools[i];
					optsTitPools.push({'value':pool.getAttribute("id"),'text':pool.getAttribute("text")});
				}
			}
		}
		
		//Usuarios
		var users = result.getElementsByTagName("user");
		optsTitUsers = new Array();
		if (users != null && users.length > 0 && users.item(0) != null){
			users = users.item(0).getElementsByTagName("option");
			if (users != null && users.length > 0){
				for (var i = 0; i < users.length; i++){
					var usr = users[i];
					optsTitUsers.push({'value':usr.getAttribute("id"),'text':usr.getAttribute("text")});
				}
			}
		}		
	}
}

function onChangeObjType(value){
	cleanObjTitleFilter();
	
	if (value == "E"){
		setObjTitleFilter(optsTitEnvironment);
	} else if (value == "P"){
		setObjTitleFilter(optsTitProcess);
	} else if (value == "T"){
		setObjTitleFilter(optsTitTasks);
	} else if (value == "G"){
		setObjTitleFilter(optsTitPools);
	} else if (value == "U"){
		setObjTitleFilter(optsTitUsers);
	}
	
	setFilter();
}

function cleanObjTitleFilter(){
	var objTitleFilter = $('objTitleFilter');
	objTitleFilter.innerHTML = "";
	objTitleFilter.options[0] = new Option("","");
	objTitleFilter.value = "";
	objTitleFilter.oldValue = "";
}

function setObjTitleFilter(optionsValues){
	var objTitleFilter = $('objTitleFilter');
	if (optionsValues != null && optionsValues.length > 0){
		for (var i = 0; i < optionsValues.length; i++){
			objTitleFilter.options[i+1] = new Option(optionsValues[i].text,optionsValues[i].value);
		}		
	}
	objTitleFilter.value = "";
}

