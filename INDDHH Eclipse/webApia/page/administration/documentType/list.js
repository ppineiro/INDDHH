function initPage(){
	getTabContainerController().changeTabState(TAB_ID, false); 
	
	//crear spinner de espere un momento
	sp = new Spinner($('gridBody').getParent(),{message:WAIT_A_SECOND});
	
	['orderByName','orderByTitle','orderByDesc','orderByRegUser','orderByRegDate'].each(setAdmOrder);
	['orderByName','orderByTitle','orderByDesc','orderByRegUser','orderByRegDate'].each(setAdmListTitle);
	['nameFilter','titleFilter','descFilter','regUsrFilter','regUsrFilter','maxSizeMinFilter','maxSizeMaxFilter','extensionsFilter'].each(setAdmFilters);
	['regDateFilter'].each(setDateFilters);
	
	$('clearFilters').addEvent("click", function(e) {
		if(e) e.stop();
		['nameFilter','titleFilter','descFilter','regUsrFilter','maxSizeMinFilter','maxSizeMaxFilter','extensionsFilter','freeMetadataFilter','disabledFilter'].each(clearFilter);
		['regDateFilter'].each(clearFilterDate);
		$('nameFilter').setFilter();
	}).addEvent('keypress', Generic.enterKeyToClickListener);
	
	initAdminActions();
	initNavButtons();
	
	callNavigate();
}

//establecer un filtro
function setFilter(){
	callNavigateFilter({
			txtName: $('nameFilter').value,
			txtTitle: $('titleFilter').value,
			txtDesc: $('descFilter').value,			
			txtRegUsr: $('regUsrFilter').value,
			txtRegDte: $('regDateFilter').value,
			txtMaxSizeMin: $('maxSizeMinFilter').value,
			txtMaxSizeMax: $('maxSizeMaxFilter').value,
			txtExt: $('extensionsFilter').value,
			txtFreeMeta: $('freeMetadataFilter').value,
			txtDisabled: $('disabledFilter').value
		},null);
}

