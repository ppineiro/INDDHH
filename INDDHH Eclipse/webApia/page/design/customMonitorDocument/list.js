
function initPage(){
	sp = new Spinner($('gridBody').getParent(),{message:WAIT_A_SECOND});
	
	['orderByName','orderByTitle','orderByDesc','orderByRegUser','orderByRegDate'].each(setAdmListTitle);
	['orderByName','orderByTitle','orderByDesc','orderByRegUser','orderByRegDate'].each(setAdmOrder);
	['nameFilter','descFilter','regUsrFilter','titleFilter'].each(setAdmFilters);
	['regDateFilter'].each(setDateFilters);
	
	$('clearFilters').addEvent("click", function(e) {
		if(e) e.stop();
		['nameFilter','titleFilter','descFilter','regUsrFilter','prjFilter'].each(clearFilter);
		['regDateFilter'].each(clearFilterDate);
		$('nameFilter').setFilter();
	}).addEvent('keypress', Generic.enterKeyToClickListener);
		
	initAdminActions();	
	initNavButtons();
		
	callNavigate();
}

function setFilter(){
	callNavigateFilter({
		txtName: $('nameFilter').value,
		txtTitle: $('titleFilter').value,
		txtDesc: $('descFilter').value,
		txtRegUsr: $('regUsrFilter').value,
		txtRegDte: $('regDateFilter').value,
		txtPrjId: $('prjFilter').value					
	},null);
}
