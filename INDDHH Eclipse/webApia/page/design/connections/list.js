function initPage(){
	getTabContainerController().changeTabState(TAB_ID, false); 
	
	//crear spinner de espere un momento
	sp = new Spinner($('gridBody').getParent(),{message:WAIT_A_SECOND});
		
	['orderByName','orderByDescription','orderByType','orderByRegUser','orderByRegDate'].each(setAdmOrder);
	['orderByPerm','orderByName','orderByDescription','orderByType','orderByRegUser','orderByRegDate'].each(setAdmListTitle);
	['nameFilter','descFilter','cmbType','regUsrFilter','regUsrFilter','projectFilter'].each(setAdmFilters);
	['regDateFilter'].each(setDateFilters);
	
	$('clearFilters').addEvent("click", function(e) {
		if(e) e.stop();
		['projectFilter','nameFilter','descFilter','cmbType','regUsrFilter'].each(clearFilter);
		['regDateFilter'].each(clearFilterDate);		
		$('projectFilter').setFilter();
	}).addEvent('keypress', Generic.enterKeyToClickListener);
	
	$('btnTest').addEvent('click', btnTestClick);
	
	initAdminActions();
	initNavButtons();
	callNavigate();
}

//establecer un filtro
function setFilter(){
	callNavigateFilter({
		selPrj: $('projectFilter').value,	
		txtName: $('nameFilter').value,
		txtDesc: $('descFilter').value,
		cmbType: $('cmbType').value,
		txtRegUser: $('regUsrFilter').value,
		txtRegDate: $('regDateFilter').value
	},null);
}


function btnTestClick() {
	if (selectionCount($('tableData')) == 0) {
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
			url: CONTEXT + URL_REQUEST_AJAX + '?action=testMultipleConnection&isAjax=true&id='+selection + TAB_ID_REQUEST,
			onRequest: function() { sp.show(true); },
			onComplete: function(resText, resXml) { modalProcessXml(resXml); sp.hide(true); }
		}).send();
	}
}