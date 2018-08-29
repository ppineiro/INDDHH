function initPage(){
	getTabContainerController().changeTabState(TAB_ID, false); 
	
	//crear spinner de espere un momento
	sp = new Spinner($('gridBody').getParent(),{message:WAIT_A_SECOND});

	['orderByName','orderByTitle','orderByDescription','orderByRegUser','orderByRegDate'].each(setAdmOrder);
	['orderByPerm','orderByName','orderByTitle','orderByDescription','orderByRegUser','orderByRegDate'].each(setAdmListTitle);
	['nameFilter','titleFilter','descFilter','regUsrFilter','regUsrFilter'].each(setAdmFilters);
	['regDateFilter'].each(setDateFilters);
	
	$('clearFilters').addEvent("click", function(e) {
		if(e) e.stop();
		['nameFilter','titleFilter','descFilter','projectFilter','regUsrFilter'].each(clearFilter);
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
		selPrj: $('projectFilter').value,
		txtRegUser: $('regUsrFilter').value,
		txtRegDate: $('regDateFilter').value
	},null);
}