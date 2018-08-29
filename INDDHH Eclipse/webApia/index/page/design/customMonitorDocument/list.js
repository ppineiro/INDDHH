
function initPage(){
	sp = new Spinner($('gridBody').getParent(),{message:WAIT_A_SECOND});
	
	['orderByName','orderByTitle','orderByDesc','orderByRegUser','orderByRegDate'].each(function(ele){ setAdmListTitle(ele); });
	['orderByName','orderByTitle','orderByDesc','orderByRegUser','orderByRegDate'].each(function(ele){ setAdmOrder(ele); });
	['nameFilter','descFilter','regUsrFilter','titleFilter'].each(function(ele) { setAdmFilters(ele); });
	$('regDateFilter').setFilter = setFilter;
	$('regDateFilter').addEvent("change", function(e) { this.setFilter(); });	
	$('clearFilters').addEvent("click", function(e) {
		e.stop();
		['nameFilter','titleFilter','descFilter','regUsrFilter','prjFilter'].each(clearFilter);
		['regDateFilter'].each(clearFilterDate);
		$('nameFilter').setFilter();
	});
		
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
