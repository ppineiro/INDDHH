function initPage(){
	getTabContainerController().changeTabState(TAB_ID, false); 
	
	sp = new Spinner($('gridBody').getParent(),{message:WAIT_A_SECOND});
	
	['orderByName','orderByClass','orderByPeriodicity','orderByLastExec','orderByState'].each(setAdmOrder);
	['orderByName','orderByClass','orderByPeriodicity','orderByLastExec','orderByState'].each(setAdmListTitle);
	['nameFilter','busClaFilter','periodicityFilter','statusFilter'].each(setAdmFilters);
	['dteStartFromFilter','dteStartToFilter','dteEndFromFilter','dteEndToFilter','dteLastFromFilter','dteLastToFilter'].each(setDateFilters);
		
	$('clearFilters').addEvent("click", function(e) {
		e.stop();
		['nameFilter','busClaFilter','periodicityFilter','statusFilter'].each(clearFilter);
		['dteStartFromFilter','dteStartToFilter','dteEndFromFilter','dteEndToFilter','dteLastFromFilter','dteLastToFilter'].each(clearFilterDate);
		$('showFilter').selectedIndex = 0;
		$('nameFilter').setFilter();
	});
	
	$('btnLiveView').addEvent("click", function(e) {
		e.stop();
		ADMIN_SPINNER.show(true);
		window.location = CONTEXT + URL_REQUEST_AJAX + '?action=liveView' + TAB_ID_REQUEST
				+ TAB_ID_REQUEST;
	});
	
	// Ejecutar Ahora
	$('btnExec').addEvent("click", function(e) {
		e.stop();
		if (selectionCount($('tableData')) == 0) {
			showMessage(GNR_CHK_AT_LEAST_ONE, GNR_TIT_WARNING, 'modalWarning');
		} else {
			var selected = getSelectedRows($('tableData'));
			var selection = "";
			for (i = 0; i < selected.length; i++) {
				selection += selected[i].getRowId();
				if (i < selected.length - 1) {
					selection += ";";
				}
			}
			var request = new Request({
				method : 'post',
				url : CONTEXT + URL_REQUEST_AJAX + '?action=runNow&isAjax=true&id=' + selection + TAB_ID_REQUEST,
				onRequest : function() { SYS_PANELS.showLoading(); },
				onComplete : function(resText, resXml) { modalProcessXml(resXml); }
			}).send();
		}
	});
	// Habilitar/Deshabilitar
	$('btnEnDis').addEvent("click", function(e) {
		e.stop();
		if (selectionCount($('tableData')) == 0) {
			showMessage(GNR_CHK_AT_LEAST_ONE, GNR_TIT_WARNING, 'modalWarning');
		} else {
			var selected = getSelectedRows($('tableData'));
			var selection = "";
			for (i = 0; i < selected.length; i++) {
				selection += selected[i].getRowId();
				if (i < selected.length - 1) {
					selection += ";";
				}
			}
			var request = new Request({
				method : 'post',
				url : CONTEXT + URL_REQUEST_AJAX + '?action=enableDisable&isAjax=true&id=' + selection + TAB_ID_REQUEST,
				onRequest : function() { SYS_PANELS.showLoading(); },
				onComplete : function(resText, resXml) { modalProcessXml(resXml); }
			}).send();
		}
		
	});
	//['btnExec','btnEnDis'].each(setTooltip);
	
	initAdminActions();
	initNavButtons();
	btnClone.setStyle("display","none");
	callNavigate();
}

function setFilter(){
	callNavigateFilter({
			dteStartFrom: $('dteStartFromFilter').value,
			dteStartTo: $('dteStartToFilter').value,
			dteEndFrom: $('dteEndFromFilter').value,
			dteEndTo: $('dteEndToFilter').value,
			cmbPer: $('periodicityFilter').value,
			txtBusClass: $('busClaFilter').value,
			dteLastFrom: $('dteLastFromFilter').value,
			dteLastTo: $('dteLastToFilter').value,
			cmbStatus: $('statusFilter').value,
			txtSchName: $('nameFilter').value,
			txtShow: $('showFilter').value
		},null);
}
