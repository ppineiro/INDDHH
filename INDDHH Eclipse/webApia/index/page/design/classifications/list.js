function initPage(){
	getTabContainerController().changeTabState(TAB_ID, false); 
	
	//crear spinner de espere un momento
	sp = new Spinner($('gridBody').getParent(),{message:WAIT_A_SECOND});
	
	//$$("div.button").each(setAdmEvents);

	['orderByName','orderByTitle','orderByFather', 'orderByRegUser','orderByRegDate'].each(setAdmOrder);
	['orderByPerm','orderByName','orderByTitle','orderByFather', 'orderByRegUser','orderByRegDate'].each(setAdmListTitle);
	['nameFilter','titleFilter','fatherFilter','regUsrFilter','regUsrFilter'].each(setAdmFilters);
	
	$('regDateFilter').setFilter = setFilter;
	$('regDateFilter').addEvent("change", function(e) {
		this.setFilter();
	});
	
	$('clearFilters').addEvent("click", function(e) {
		e.stop();
		['nameFilter','titleFilter','projectFilter','fatherFilter','regUsrFilter'].each(clearFilter);
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
			txtTitle: $('titleFilter').value,
			selPrj: $('projectFilter').value,
			fatherName: $('fatherFilter').value,
			txtRegUser: $('regUsrFilter').value,
			txtRegDate: $('regDateFilter').value
		},null);
}