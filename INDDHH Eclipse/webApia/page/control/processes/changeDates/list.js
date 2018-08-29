function initPage(){
	//crear spinner de espere un momento
	sp = new Spinner($('gridBody').getParent(),{message:WAIT_A_SECOND});
			 
	$$('div.fncDescriptionImage').each(function(e){
		var path = 'url(' + e.get('data-src') + ')'
		e.setStyle('background-image', path);
		e.setStyle('background-repeat', 'no-repeat');
		e.setStyle('width', '64px');
		e.setStyle('height', '64px');
	});
		
	['orderByProPiority','orderByRegNumber','orderByTitle','orderByDateCreate','orderByDateWarn','orderByDateOverdue'].each(function(ele){
		setAdmListTitle(ele);
		setAdmOrder(ele);
	});
	
	['activityFilter','numRegFilter','titleFilter','actionFilter','priorityFilter','createDateFilterStart','createDateFilterEnd','endDateFilterStart',
	 'endDateFilterEnd','alertDateFilterStart','alertDateFilterEnd','overdueDateFilterStart','overdueDateFilterEnd'].each(setAdmFilters);

	['createDateFilterStart','createDateFilterEnd','alertDateFilterStart','alertDateFilterEnd','overdueDateFilterStart','overdueDateFilterEnd'].each(setDateFilters);
	
	$('clearFilters').addEvent("click", function(e) {
		if(e) e.stop();
		['activityFilter','numRegFilter','titleFilter','actionFilter','priorityFilter'].each(clearFilter);
		['createDateFilterStart','createDateFilterEnd','alertDateFilterStart','alertDateFilterEnd','overdueDateFilterStart','overdueDateFilterEnd'].each(clearFilterDate);
		$('titleFilter').setFilter(false);
	}).addEvent('keypress', Generic.enterKeyToClickListener);
	
	
	$('btnModDate').addEvent("click",function(e){
		e.stop();
		if (selectionCount($('tableData')) == 0) {
			showMessage(GNR_CHK_AT_LEAST_ONE, GNR_TIT_WARNING,'modalWarning');
		} else {
			var selected = getSelectedRows($('tableData'));
			var id = "";
			for (i = 0; i < selected.length; i++) {
				id += selected[i].getRowId();
				if (i < selected.length - 1) {
					id += ";";
				}
			}
			var request = new Request({
				method : 'post',
				url : CONTEXT + URL_REQUEST_AJAX + '?action=startChangeDateModal&isAjax=true&id=' + id + TAB_ID_REQUEST,
				onRequest : function() { SYS_PANELS.showLoading(); },
				onComplete : function(resText, resXml) { showDatesModal(resXml,reloadList); SYS_PANELS.closeLoading(); }
			}).send();
		}
	});
	
	$('btnCloseTab').addEvent('click', function(e){
		e.stop();
		getTabContainerController().removeActiveTab();
	});
	
	initNavButtons();
	initAdminFav();
	initDatesModalPage();
	
	//callNavigate();
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
function setFilter(){
	callNavigateFilterProcesses({
		cmbBackLog: $('activityFilter').value,		
		filProName: $('numRegFilter').value,
		txtProTitle: $('titleFilter').value,
		cmbAct: $('actionFilter').value,
		cmbPriority: $('priorityFilter').value,
		txtStaSta: $('createDateFilterStart').value,
		txtStaEnd: $('createDateFilterEnd').value,
		txtWarnSta: $('alertDateFilterStart').value,
		txtWarnEnd: $('alertDateFilterEnd').value,
		txtOverdueSta: $('overdueDateFilterStart').value,
		txtOverdueEnd: $('overdueDateFilterEnd').value
	},null);
}

function reloadList(){
	callNavigate();
}
