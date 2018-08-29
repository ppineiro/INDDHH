function initPage(){
	//crear spinner de espere un momento
	sp = new Spinner($('gridBody').getParent(),{message:WAIT_A_SECOND});
			 
	$$('div.fncDescriptionImage').each(function(e){
		var path = 'url(' + e.get('src') + ')'
		e.setStyle('background-image', path);
		e.setStyle('background-repeat', 'no-repeat');
		e.setStyle('width', '64px');
		e.setStyle('height', '64px');
	});
	
	var btnExport = $('btnExport');
	if (btnExport){
		btnExport.addEvent("click", function(e) {
		e.stop();
		var request = new Request({
			method: 'post',
			url: CONTEXT + URL_REQUEST_AJAX + '?action=prepareModalDownload&isAjax=true' + TAB_ID_REQUEST,
			onRequest: function() { SYS_PANELS.showLoading(); },
			onComplete: function(resText, resXml) { modalProcessXml(resXml); }
			}).send(); 
		});
	}
	
	var btnTasks = $('btnTasks');
	if (btnTasks){
		btnTasks.addEvent("click", function(e) {
			e.stop();
			//verificar que solo un registro esté seleccionado
			if (selectionCount($('tableData')) > 1) {
				showMessage(GNR_CHK_ONLY_ONE, GNR_TIT_WARNING, 'modalWarning');
			} else if(selectionCount($('tableData')) == 0) {
				showMessage(GNR_CHK_AT_LEAST_ONE, GNR_TIT_WARNING, 'modalWarning');
			} else {
				//obtener el registro seleccionado
				SYS_PANELS.showLoading();
				var id = getSelectedRows($('tableData'))[0].getRowId();
				window.location = CONTEXT + URL_REQUEST_AJAX + '?action=task&id=' + id + "&markSelected=true" + TAB_ID_REQUEST+"&proMaxDur="+id.split(PRIMARY_SEPARATOR)[1];
			}
		});
	}
	
	var btnDetails = $('btnDetails');
	if (btnDetails){
		btnDetails.addEvent("click", function(e) {
			e.stop();
			//verificar que solo un registro esté seleccionado
			if (selectionCount($('tableData')) > 1) {
				showMessage(GNR_CHK_ONLY_ONE, GNR_TIT_WARNING, 'modalWarning');
			} else if(selectionCount($('tableData')) == 0) {
				showMessage(GNR_CHK_AT_LEAST_ONE, GNR_TIT_WARNING, 'modalWarning');
			} else {
				//obtener el registro seleccionado
			  	SYS_PANELS.showLoading();
				var id = getSelectedRows($('tableData'))[0].getRowId();
				window.location = CONTEXT + URL_REQUEST_AJAX + '?action=details&id=' + id + "&markSelected=true" + TAB_ID_REQUEST;
			}
		});
	}
	
	var btnDocuments = $('btnDocuments');
	if (btnDocuments){
		btnDocuments.addEvent("click",function(e){
			e.stop();
			//verificar que solo un registro esté seleccionado
			if (selectionCount($('tableData')) > 1) {
				showMessage(GNR_CHK_ONLY_ONE, GNR_TIT_WARNING, 'modalWarning');
			} else if(selectionCount($('tableData')) == 0) {
				showMessage(GNR_CHK_AT_LEAST_ONE, GNR_TIT_WARNING, 'modalWarning');
			} else {
				var id = getSelectedRows($('tableData'))[0].getRowId();
				var request = new Request({
					method: 'post',
					url: CONTEXT + URL_REQUEST_AJAX + '?action=getProcessInfoForMonDocument&isAjax=true&id=' + id + TAB_ID_REQUEST,
					onRequest: function() { SYS_PANELS.showLoading(); },
					onComplete: function(resText, resXml) { modalProcessXml(resXml); }
				}).send();
			}
		});
	}
	
	//['btnExport','btnTasks','btnDetails','btnDocuments'].each(setTooltip);
		
	['orderByProPiority','orderByRegNumber','orderByTitle','orderByCreateUser','orderByDateCreate','orderByDateEnd'].each(function(ele){
		setAdmListTitle(ele);
		setAdmOrder(ele);
	});
	
	//asociar eventos para los filtros	
	
	[
	 	'activityFilter',
		 'numRegFilter',
		 'titleFilter',
		 'actionFilter',
		 'userFilter',
		 'statusFilter',
		 'priorityFilter',
		 'createDateFilterStart',
		 'createDateFilterEnd',
		 'endDateFilterStart',
		 'endDateFilterEnd',
		 'alertDateFilterStart',
		 'alertDateFilterEnd',
		 'overdueDateFilterStart',
		 'overdueDateFilterEnd'
	 ].each(setAdmFilters);

	[
		'createDateFilterStart',
		'createDateFilterEnd',
		'endDateFilterStart',
		'endDateFilterEnd',
		'alertDateFilterStart',
		'alertDateFilterEnd',
		'overdueDateFilterStart',
		'overdueDateFilterEnd',
	 ].each(function(ele){
		ele = $(ele);
		ele.setFilter = setFilter;
		ele.addEvent("change", function(e) { this.setFilter(); });
	});
	
	$('clearFilters').addEvent("click", function(e) {
		e.stop();
		['activityFilter','numRegFilter','titleFilter','actionFilter','statusFilter','priorityFilter','userFilter','statusFilter'].each(clearFilter);
		['createDateFilterStart','createDateFilterEnd','endDateFilterStart','endDateFilterEnd','alertDateFilterStart','alertDateFilterEnd',
		 'overdueDateFilterStart','overdueDateFilterEnd'].each(clearFilterDate);
		$('statusFilter').selectedIndex=1;
		$('titleFilter').setFilter(false);
	});
	
	//eventos para order
	
	//$$("div.button").each(setAdmEvents);
	
	initNavButtons();
	
	if (!BACK){
		callNavigate();
	}else{
		setFilter(true);
	}
	
	initAdminFav();
	
	initPinGridOptions();
}


//navegar a una pagina 
function callNavigateFilterProcesses(strParams,url){
	hideMessage();
	if(!url){
		url = URL_REQUEST_AJAX;
	}	
	var request = new Request({
		method: 'post',	
		data: strParams,
		url: CONTEXT + url + '?action=filterProcesses&isAjax=true' + TAB_ID_REQUEST,
		onRequest: function() { sp.show(true); },
		onComplete: function(resText, resXml) { modalProcessXml(resXml); sp.hide(true); }
	}).send(strParams);
}

//establecer un filtro
function setFilter(b){
	callNavigateFilterProcesses({
		cmbBackLog: $('activityFilter').value,		
		filProName: $('numRegFilter').value,
		txtProTitle: $('titleFilter').value,
		cmbAct: $('actionFilter').value,
		txtInstUser: $('userFilter').value,
		cmbSta: $('statusFilter').value,
		cmbPriority: $('priorityFilter').value,
		txtStaSta: $('createDateFilterStart').value,
		txtStaEnd: $('createDateFilterEnd').value,
		txtEndSta: $('endDateFilterStart').value,
		txtEndEnd: $('endDateFilterEnd').value,
		txtWarnSta: $('alertDateFilterStart').value,
		txtWarnEnd: $('alertDateFilterEnd').value,
		txtOverdueSta: $('overdueDateFilterStart').value,
		txtOverdueEnd: $('overdueDateFilterEnd').value,
		back:b
		},null);
}

function btnDeleteClickConfirm() {
	var selected = getSelectedRows($('tableData'));
	var selection = "";
	for(i=0; i<selected.length; i++){
		selection+=selected[i].getRowId();
		if(i<selected.length-1){
			selection+=";";
		}
	}
	var request = new Request({
		method: 'post',
		url: CONTEXT + URL_REQUEST_AJAX + '?action=delete&isAjax=true&id='+selection + TAB_ID_REQUEST,
		onRequest: function() { sp.show(true); },
		onComplete: function(resText, resXml) { modalProcessXml(resXml); sp.hide(true); }
	}).send();
}

function download(){
	
	var pdf = $('pdf'); 
	var excel = $('excel'); 
	
	var all = $('all'); 
	
	var format = "csv";
	var count = "actual";
	if (pdf.checked){
		format="pdf";
	}else if (excel.checked){
		format = "excel";
	}
	
	if (all.checked){
		count = "all";
	}
	hideMessage();
	createDownloadIFrame("",DOWNLOADING,URL_REQUEST_AJAX,"download","&count="+count+"&format="+format,"","",null);
}

function openMonDocument(procTitle, procRegInst, busEntTitle, busEntRegInst){
	SYS_PANELS.closeAll();
	var tabContainer = window.parent.document.getElementById('tabContainer');
	var url = CONTEXT + URL_REQUEST_AJAX_MON_DOCUMENT + '?action=init&favFncId=54&preFilProcess=true&procTitle=' + procTitle + '&procRegInst=' + procRegInst + '&busEntTitle=' + busEntTitle + '&busEntRegInst=' + busEntRegInst + TAB_ID_REQUEST;
	tabContainer.addNewTab(MON_DOC_TAB_TITLE,url,null);		
}
