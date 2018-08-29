function initPage(){
	//crear spinner de espere un momento
	sp = new Spinner($('gridBody').getParent(),{message:WAIT_A_SECOND});
	
	//$$("div.button").each(setAdmEvents);

	['orderByUser','orderByCapDate','orderByTaskTit','orderByNumProc','orderByProcTit'].each(setAdmOrder);
	['orderByUser','orderByCapDate','orderByTaskTit','orderByNumProc','orderByProcTit'].each(setAdmListTitle);
	['userFilter','cmbTskTitFilter','numEntFilter','numProcFilter','cmbProcTitFilter','fecAdqStartFilter','fecAdqEndFilter',
	 'cmbAccProcFilter','fecCreStartFilter','fecCreEndFilter','fecFinStartFilter','fecFinEndFilter','filPoolName'].each(setAdmFilters)
	
	$('fecAdqStartFilter').addEvent("change", setFilter);
	$('fecAdqEndFilter').addEvent("change", setFilter);
	$('fecCreStartFilter').addEvent("change", setFilter);
	$('fecCreEndFilter').addEvent("change", setFilter);
	$('fecFinStartFilter').addEvent("change", setFilter);
	$('fecFinEndFilter').addEvent("change", setFilter);
	
	$('clearFilters').addEvent("click", function(e) {
		e.stop();
		['userFilter','cmbTskTitFilter','numEntFilter','numProcFilter','cmbProcTitFilter','cmbAccProcFilter','filPoolName'].each(clearFilter);
		['fecAdqStartFilter','fecAdqEndFilter','fecCreStartFilter','fecCreEndFilter','fecFinStartFilter','fecFinEndFilter'].each(clearFilterDate);
		cleanCmbTskTitFilter();
		$('userFilter').setFilter();
	});
	
	//Release
	$('btnRelease').addEvent("click", function(e){
		e.stop();
		hideMessage();
		e.stop();
		if(selectionCount($('tableData')) == 0) {
			showMessage(GNR_CHK_AT_LEAST_ONE, GNR_TIT_WARNING, 'modalWarning');
		} else {
			sp = new Spinner($('gridBody').getParent(),{message:WAIT_A_SECOND});
			var selected = getSelectedRows($('tableData'));
			var selection = "";
			for(i=0; i<selected.length; i++){
				selection+=selected[i].getRowId();
				if(i<selected.length-1){
					selection+=";";
				}
			}
			
			var row_id = 'id=' + encodeURIComponent(selection);
			
			var request = new Request({
				method: 'post',
				url: CONTEXT + URL_REQUEST_AJAX + '?action=startRelease&isAjax=true' + TAB_ID_REQUEST,
				onRequest: function() { SYS_PANELS.showLoading(); },
				onComplete: function(resText, resXml) { modalProcessXml(resXml); }
			}).send(row_id);
		}
	});
	
	//['btnRelease'].each(setTooltip);
	
	initNavButtons();
	initAdminFav();
	
	loadTasksByProcess($('cmbProcTitFilter'));
	
	callNavigate();	
}


//establecer un filtro
function setFilter(){
	callNavigateFilter({
			txtUsu: $('userFilter').value,
			datAcqSta: $('fecAdqStartFilter').value,
			datAcqEnd: $('fecAdqEndFilter').value,
			txtTskTit: $('cmbTskTitFilter').value,
			txtProTit: $('cmbProcTitFilter').value,
			cmbProAct: $('cmbAccProcFilter').value,
			datTskCreSta: $('fecCreStartFilter').value,
			datTskCreEnd: $('fecCreEndFilter').value,
			datProCreSta: $('fecFinStartFilter').value,
			datProCreEnd: $('fecFinEndFilter').value,
			filEntName: $('numEntFilter').value,
			filProName: $('numProcFilter').value,
			txtPoolName: $('filPoolName').value,
			proNameAux: $('cmbProcTitFilter').value != "" ? $('cmbProcTitFilter').options[cmbProcTitFilter.selectedIndex].getAttribute("proName") : ""
		},null);
}



function loadTasksByProcess(cmbProcTitFilter){
	cleanCmbTskTitFilter();
	var cmbValue = cmbProcTitFilter.value;
	
	//CAM_12371
	var proParam = "";
	if (cmbValue != null && cmbValue != ""){
		var proId = cmbProcTitFilter.options[cmbProcTitFilter.selectedIndex].getAttribute("proId");
		proParam = '&proId=' + proId;
	}
	
	var request = new Request({
		method : 'post',
		url : CONTEXT + URL_REQUEST_AJAX + '?action=loadTasksByProcess&isAjax=true' + proParam + TAB_ID_REQUEST,
		onRequest : function() { },
		onComplete : function(resText, resXml) { processXmlTasksByProcess(resXml); }
	}).send();
}

function cleanCmbTskTitFilter(){
	var cmbTskTitFilter = $('cmbTskTitFilter');
	while(cmbTskTitFilter.options.length>0){
		cmbTskTitFilter.options[0].parentNode.removeChild(cmbTskTitFilter.options[0]);
	}
	cmbTskTitFilter.options[0] = new Option("","");
	cmbTskTitFilter.value = "";
}

function processXmlTasksByProcess(resXml){
	var tasks = resXml.getElementsByTagName("tasks")
	if (tasks != null && tasks.length > 0 && tasks.item(0) != null) {
		tasks = tasks.item(0).getElementsByTagName("task");
		var cmbTskTitFilter = $('cmbTskTitFilter');
		
		for (var i = 0; i < tasks.length; i++){
			var tsk = tasks[i];
			cmbTskTitFilter.options[i+1] = new Option(tsk.getAttribute("id"),tsk.getAttribute("text"));			
		}
	}
}

