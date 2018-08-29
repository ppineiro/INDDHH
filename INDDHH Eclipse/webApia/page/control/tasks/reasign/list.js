function initPage(){
	//crear spinner de espere un momento
	sp = new Spinner($('gridBody').getParent(),{message:WAIT_A_SECOND});
	
	Generic.updateFncImages();
	
	//$$("div.button").each(setAdmEvents);
		
	$("fncDescriptionText").innerHTML="";
	var htmlText = "<label id=\"messageText\">"+ FNC_DESCRIPTION + "</label>"; 
	new Element('label', {html: htmlText}).inject($('fncDescriptionText'));
	
	['orderByUser','orderByCapDate','orderByTaskTit','orderByNumEnt','orderByNumProc','orderByProcTit'].each(setAdmOrder);
	['orderByUser','orderByCapDate','orderByTaskTit','orderByNumEnt','orderByNumProc','orderByProcTit'].each(setAdmListTitle);
	['userFilter','cmbTskTitFilter','numEntFilter','numProcFilter','cmbProcTitFilter','fecAdqStartFilter','fecAdqEndFilter',
	 'cmbAccProcFilter','fecCreStartFilter','fecCreEndFilter','filPoolName'].each(setAdmFilters);
	
	['fecAdqStartFilter', 'fecAdqEndFilter', 'fecCreStartFilter', 'fecCreEndFilter'].each(setDateFilters);
	
	$('clearFilters').addEvent("click", function(e) {
		if(e) e.stop();
		['userFilter','cmbTskTitFilter','numEntFilter','numProcFilter','cmbProcTitFilter','cmbAccProcFilter','filPoolName'].each(clearFilter);
		['fecAdqStartFilter','fecAdqEndFilter','fecCreStartFilter','fecCreEndFilter'].each(clearFilterDate);
		cleanCmbTskTitFilter();
		$('userFilter').setFilter();
	}).addEvent('keypress', Generic.enterKeyToClickListener);
	
	//Reasign User
	if($('btnReasignUsr')){
		$('btnReasignUsr').addEvent("click",  function(e){ startReasign(e,"&usr=true");	});
		//['btnReasignUsr'].each(setTooltip);
	}
	
	//Reasign Pool
	if($('btnReasignPool')){
		$('btnReasignPool').addEvent("click", function(e){ startReasign(e,""); });
		//['btnReasignPool'].each(setTooltip);
	}
	
	
	initGridScroll();
	initNavButtons();
	initAdminFav();
	
	loadTasksByProcess($('cmbProcTitFilter'));
	
	//callNavigate();
	var gridBody = $('gridBody');
	firstTimeMsg = new Element('div', {'class': 'noDataMessage', html: MSG_FIRST_TIME}).inject(gridBody);
	firstTimeMsg.setStyle('display','');
	firstTimeMsg.setStyle("width",gridBody.getStyle("width"));
	firstTimeMsg.position( {
		relativeTo: gridBody,
		position: 'upperLeft'
	});
	gridBody.noDataMessage = firstTimeMsg;
}


function startReasign(e,param){
	e.stop();
	hideMessage();
	
	if(selectionCount($('tableData')) == 0) {
		showMessage(GNR_CHK_AT_LEAST_ONE, GNR_TIT_WARNING, 'modalWarning');
	} else {
		var selection = getSelectedRows($('tableData'));
		var ids = "";
		for (var i = 0; i < selection.length; i++){
			if (ids != "") ids += ";";
			ids += selection[i].getRowId().replace(/\u00B7/g, PRIMARY_SEPARATOR);
		}
		if(PRIMARY_SEPARATOR_IN_BODY) {
			new Request({
				method: 'post',
				url: CONTEXT + URL_REQUEST_AJAX + '?action=startReasig&isAjax=true' + TAB_ID_REQUEST + param,
				onRequest: function() { SYS_PANELS.showLoading(); },
				onComplete: function(resText, resXml) { modalProcessXml(resXml); }
			}).send('id=' + ids);
		} else {
			new Request({
				method: 'post',
				url: CONTEXT + URL_REQUEST_AJAX + '?action=startReasig&isAjax=true&id=' + encodeURIComponent(ids) + TAB_ID_REQUEST + param,
				onRequest: function() { SYS_PANELS.showLoading(); },
				onComplete: function(resText, resXml) { modalProcessXml(resXml); }
			}).send();
		}
		
	}
}

function reloadCmbUsr(){
	if ($('cmbPools').selectedIndex != 0){
		var poolId = $('cmbPools').value;
		var request = new Request({
			method: 'post',
			url: CONTEXT + URL_REQUEST_AJAX + '?action=getUsersPool&isAjax=true&poolId=' + poolId + TAB_ID_REQUEST ,
			onRequest: function() { SYS_PANELS.showLoading(); },
			onComplete: function(resText, resXml) { modalProcessXml(resXml); }
		}).send();
	} else {
		setOptionsCmbUsr("");
	}
}

function setOptionsCmbUsr(opts){
	var cmb = $('cmbUsers');
	var i = 1;
	var value = "";
	var text = "";
	cmb.innerHTML = ""
	cmb.options[0] = new Option("","");	
	if (opts != null){
		while (opts.indexOf(PRIMARY_SEPARATOR) > -1){
			value = opts.substring(0, opts.indexOf(PRIMARY_SEPARATOR));
			opts = opts.substring(opts.indexOf(PRIMARY_SEPARATOR) + 1, opts.length);
			text = opts.substring(0, opts.indexOf(PRIMARY_SEPARATOR));
			opts = opts.substring(opts.indexOf(PRIMARY_SEPARATOR) + 1, opts.length);
			cmb.options[i] = new Option(text,value);
			i++;
		}		
	}	
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
			filEntName: $('numEntFilter').value,
			filProName: $('numProcFilter').value,
			txtPoolName: $('filPoolName').value,
			proNameAux: $('cmbProcTitFilter').value != "" ? $('cmbProcTitFilter').options[cmbProcTitFilter.selectedIndex].getAttribute("proName") : ""
		},null);
}


function loadTasksByProcess(cmbProcTitFilter){
	cleanCmbTskTitFilter();
	var cmbValue = cmbProcTitFilter.value;	
	
	//CAM_12372
	var proParam = "";
	if (cmbValue != null && cmbValue != ""){
		var proId = cmbProcTitFilter.options[cmbProcTitFilter.selectedIndex].getAttribute("proId");
		proParam = '&proId=' + proId;
	}
	
	var request = new Request({
		method : 'post',
		url : CONTEXT + URL_REQUEST_AJAX + '?action=loadTasksByProcess&isAjax=true&fromReasign=true' + proParam + TAB_ID_REQUEST,
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
