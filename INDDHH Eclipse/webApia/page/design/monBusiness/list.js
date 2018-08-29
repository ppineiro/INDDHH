function initPage(){
	getTabContainerController().changeTabState(TAB_ID, false); 
	
	//crear spinner de espere un momento
	sp = new Spinner($('gridBody').getParent(),{message:WAIT_A_SECOND});
	
	//$$("div.button").each(setAdmEvents);

	['orderByName','orderByDesc','orderByTitle','orderByRegUser','orderByRegDate'].each(setAdmOrder);
	['orderByPerm','orderByName','orderByDesc','orderByTitle','orderByRegUser','orderByRegDate'].each(setAdmListTitle);
	['nameFilter','descFilter','titleFilter','regUsrFilter','regUsrFilter'].each(setAdmFilters);
	['regDateFilter'].each(setDateFilters);
	
	$('clearFilters').addEvent("click", function(e) {
		if(e) e.stop();
		['nameFilter','descFilter','titleFilter','projectFilter','regUsrFilter'].each(clearFilter);
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
		txtDesc: $('descFilter').value,
		title: $('titleFilter').value,
		selPrj: $('projectFilter').value,
		txtRegUser: $('regUsrFilter').value,
		txtRegDate: $('regDateFilter').value
	},null);
}