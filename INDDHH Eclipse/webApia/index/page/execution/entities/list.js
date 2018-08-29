function initPage(){
	
	if(window.frameElement && $(window.frameElement).hasClass('modal-content')) {
		$(window.frameElement).fireEvent('closeModal');
	}
	
	//crear spinner de espere un momento
	$$('.allowFilter').each(setAdmFilters);
	
	sp = new Spinner($('gridBody').getParent(),{message:WAIT_A_SECOND});
	
	//tooltips para orden
	['orderById','orderByType','orderByStatus','orderByCreateDate','orderByCreateUser'].each(setAdmListTitle);
	
	//eventos para orden
	//['orderById','orderByType','orderByStatus','orderByCreateDate','orderByCreateUser'].each(setAdmOrder);
	$$('.allowSort').each(setAdmOrder);
	
	//asociar eventos para los filtros
	['idFilter','typeFilter','statusFilter','createUserFilter','fecCreStartFilter','fecCreEndFilter'].each(setAdmFilters);
	
	$('fecCreStartFilter').setFilter = setFilter;
	$('fecCreStartFilter').addEvent("change", function(e) {
		this.setFilter();
	});
	$('fecCreEndFilter').setFilter = setFilter;
	$('fecCreEndFilter').addEvent("change", function(e) {
		this.setFilter();
	});
	
	
	$('clearFilters').addEvent("click", function(e) {
		e.stop();
		if ($('typeFilter')) { ['typeFilter'].each(clearFilter); }	
		['idFilter','statusFilter','createUserFilter'].each(clearFilter);
		['fecCreStartFilter','fecCreEndFilter'].each(clearFilterDate);	
		
		$$('.allowFilter').each(function(ele) { 
			ele.value = "";
			ele.oldValue = "";
			if (ele.getNext()) {
				ele.getNext().value = "";
				ele.getNext().oldValue = "";
			}
		});
		
		$('idFilter').setFilter();		
	});
	

	/*
	$$("div.button").each(function(ele){
		ele.addEvent("mouseover", function(evt) {this.toggleClass("buttonHover")});
		ele.addEvent("mouseout", function(evt) {this.toggleClass("buttonHover")});
	});
	*/
	
	initAdminActions();
	initNavButtons();
	
	
	callNavigate();
}


//navegar a una pagina 


//establecer un filtro
function setFilter(){
	var values = {
			txtId: $('idFilter').value,
			entName: ($('typeFilter') == null) ? '' : $('typeFilter').value.toUpperCase(),	
			filStaEnt: $('statusFilter').value.toUpperCase(),		
			filFchDes: $('fecCreStartFilter').value,
			filFchHas: $('fecCreEndFilter').value,	
			filUsuCre: $('createUserFilter').value.toLowerCase() 
		};
	
	$$('.allowFilter').each(function (ele){ values[ele.get('name')] = ele.get('value'); });
	
	callNavigateFilter(values,null);
}
