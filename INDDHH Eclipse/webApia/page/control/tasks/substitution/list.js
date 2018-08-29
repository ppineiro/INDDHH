var ADMIN_SPINNER;
	
function initPage(){
	//crear spinner de espere un momento
	sp = new Spinner($('gridBody').getParent(),{message:WAIT_A_SECOND});
	
	Generic.updateFncImages();
	
	ADMIN_SPINNER = new Spinner(document.body, {
		message : WAIT_A_SECOND
	});

	if(Browser.opera)
		ADMIN_SPINNER.content.getParent().addClass('documentSpinner');
	
	//$$("div.button").each(setAdmEvents);
		 
	['orderByUser','orderByStartDate','orderByEndDate','orderByStatus','orderByRegUser','orderByRegDate'].each(setAdmOrder);
	['orderByUser','orderByStartDate','orderByEndDate','orderByStatus','orderByRegUser','orderByRegDate'].each(setAdmListTitle);	
	['userFilter','startDateFilter','endDateFilter','cmbStatusFilter','regUsrFilter','regDateFilter'].each(setAdmFilters);
	['startDateFilter', 'endDateFilter', 'regDateFilter'].each(setDateFilters);	
	
	$('clearFilters').addEvent("click", function(e) {
		if(e) e.stop();
		['userFilter','cmbStatusFilter','regUsrFilter'].each(clearFilter);				
		['startDateFilter','endDateFilter','regDateFilter'].each(clearFilterDate);
		$('userFilter').setFilter();
	}).addEvent('keypress', Generic.enterKeyToClickListener);

	//History
	$('btnHis').addEvent("click", function(e){
		e.stop();
		hideMessage();
		e.stop();
		if (selectionCount($('tableData')) > 1) {
			showMessage(GNR_CHK_ONLY_ONE, GNR_TIT_WARNING, 'modalWarning');
		} else if(selectionCount($('tableData')) == 0) {
			showMessage(GNR_CHK_AT_LEAST_ONE, GNR_TIT_WARNING, 'modalWarning');
		} else {
			var selected = getSelectedRows($('tableData'))[0].getRowId();
			
			var request = new Request({
				method: 'post',
				url: CONTEXT + URL_REQUEST_AJAX + '?action=showHistory&isAjax=true&id=' + selected + TAB_ID_REQUEST,
				onRequest: function() { SYS_PANELS.showLoading(); },
				onComplete: function(resText, resXml) { modalProcessXml(resXml); }
			}).send();
		}
	});
	
	//Create
	$('btnCre').addEvent("click", function(e){
		e.stop();
		window.location = CONTEXT + URL_REQUEST_AJAX + '?action=startCreate' + TAB_ID_REQUEST;
	});
	
	//Remove
	$('btnDel').addEvent("click", function(e){
		e.stop();
		hideMessage();
		if(selectionCount($('tableData')) == 0) {
			showMessage(GNR_CHK_AT_LEAST_ONE, GNR_TIT_WARNING, 'modalWarning');
		} else {
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
				url: CONTEXT + URL_REQUEST_AJAX + '?action=startRemoveSub&isAjax=true&id=' + selection + TAB_ID_REQUEST,
				onRequest: function() { SYS_PANELS.showLoading(); },
				onComplete: function(resText, resXml) { modalProcessXml(resXml); }
			}).send();
		}
	});
	
	//Modify
	$('btnMod').addEvent("click", function(e){
		e.stop();
		hideMessage();
		if (selectionCount($('tableData')) > 1) {
			showMessage(GNR_CHK_ONLY_ONE, GNR_TIT_WARNING, 'modalWarning');
		} else if(selectionCount($('tableData')) == 0) {
			showMessage(GNR_CHK_AT_LEAST_ONE, GNR_TIT_WARNING, 'modalWarning');
		} else {
			var uneditableTR = getSelectedRows($('tableData'))[0].get('uneditableTR') == "false" ? true : false;
			uneditableTR = uneditableTR || getSelectedRows($('tableData'))[0].hasClass('uneditableTR');
			
			ADMIN_SPINNER.show(true);
			var selected = getSelectedRows($('tableData'))[0].getRowId();
			window.location = CONTEXT + URL_REQUEST_AJAX + '?action=startUpdate&id=' + selected + (uneditableTR?'&onlyRead=true':'') + TAB_ID_REQUEST;
		}
	});
	
	//['btnHis','btnCre','btnDel','btnMod'].each(setTooltip);
	
	initNavButtons();
	initAdminFav();
	callNavigate();	
}


//establecer un filtro
function setFilter(){
	callNavigateFilter({
			txtLogin : $('userFilter').value,
			txtDteFrom : $('startDateFilter').value,
			txtDteTo : $('endDateFilter').value,
			txtStatus : $('cmbStatusFilter').value,
			txtRegUser : $('regUsrFilter').value,
			txtRegDate : $('regDateFilter').value,
			hierarchy : HIERARCHY
		},null);
}

