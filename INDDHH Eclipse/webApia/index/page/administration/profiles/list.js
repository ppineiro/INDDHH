function initPage(){
	getTabContainerController().changeTabState(TAB_ID, false); 
	
	//crear spinner de espere un momento
	sp = new Spinner($('gridBody').getParent(),{message:WAIT_A_SECOND});
	
	['orderByName','orderByDesc','orderByRegUser','orderByRegDate'].each(setAdmOrder);
	['orderByName','orderByDesc','orderByRegUser','orderByRegDate'].each(setAdmListTitle);
	['nameFilter','descFilter','regUsrFilter','regUsrFilter'].each(setAdmFilters);
	
	$('regDateFilter').setFilter = setFilter;
	$('regDateFilter').addEvent("change", function(e) { this.setFilter(); });
	
	$('clearFilters').addEvent("click", function(e) {
		e.stop();
		['nameFilter','descFilter','regUsrFilter'].each(clearFilter);
		['regDateFilter'].each(clearFilterDate);
		$('nameFilter').setFilter();
	});
	
	initAdminActions();
	initNavButtons();
	
	callNavigate();
}

//establecer un filtro
function setFilter(){
	callNavigateFilter({
			txtName: $('nameFilter').value,
			txtDesc: $('descFilter').value,
			txtRegUser: $('regUsrFilter').value,
			txtRegDate: $('regDateFilter').value
		},null);
}