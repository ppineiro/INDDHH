function initPage(){
	//crear spinner de espere un momento
	sp = new Spinner($('gridBody').getParent(),{message:WAIT_A_SECOND});
	
	//tooltips para orden
	['orderById','orderByStatus','orderByCreateDate','orderByCreateUser'].each(setAdmListTitle);
	
	//eventos para orden
	['orderById','orderByStatus','orderByCreateDate','orderByCreateUser'].each(setAdmOrder);
	
	//asociar eventos para los filtros
	['idFilter','statusFilter','createUserFilter','fecCreStartFilter','fecCreEndFilter'].each(setAdmFilters);

	$$('.allowSort').each(setAdmOrder);
	$$('.allowFilter').each(setAdmFilters);
	
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
		['idFilter','statusFilter','createUserFilter'].each(clearFilter);		
		['fecCreStartFilter','fecCreEndFilter'].each(clearFilterDate);		
		$('idFilter').setFilter();
	});
	

	
	$$("div.button").each(function(ele){
		ele.addEvent("mouseover", function(evt) {this.toggleClass("buttonHover")});
		ele.addEvent("mouseout", function(evt) {this.toggleClass("buttonHover")});
	});
	
	$('btnStart').addEvent("click",function(e){
		
		e.stop();
		// verificar que solo un usuario esté seleccionado
		if (selectionCount($('tableData')) > 1) {
			showMessage(GNR_CHK_ONLY_ONE, GNR_TIT_WARNING, 'modalWarning');
		} else if (selectionCount($('tableData')) == 0) {
			showMessage(GNR_CHK_AT_LEAST_ONE, GNR_TIT_WARNING,'modalWarning');
		} else {
			// obtener el usuario seleccionado
			sp.show(true);
			 
			var busEntinstId = getSelectedRows($('tableData'))[0].getRowId();
			window.location = "apia.execution.TaskAction.run?action=startAlterationProcess&busEntInstId=" + busEntinstId + "&proId=" + PRO_ID + TAB_ID_REQUEST;
		}
		
		
	});
	
	initNavButtons();

	//callNavigate();
	var gridBody = $('gridBody');
	var firstTimeMsg = new Element('div', {'class': 'noDataMessage', html: MSG_FIRST_TIME}).inject(gridBody);
	firstTimeMsg.setStyle('display','');
	firstTimeMsg.setStyle("width",gridBody.getStyle("width"));
	firstTimeMsg.position( {
		relativeTo: gridBody,
		position: 'upperLeft'
	});
	gridBody.noDataMessage = firstTimeMsg;
}


//navegar a una pagina 


//establecer un filtro
function setFilter(){
	var data = {
			txtId: $('idFilter').value,
			filStaEnt: $('statusFilter').value.toUpperCase(),		
			filFchDes: $('fecCreStartFilter').value,
			filFchHas: $('fecCreEndFilter').value,	
			filUsuCre: $('createUserFilter').value.toLowerCase() 
		};
	
	$$('.allowFilter').each(function(ele) {
		data[ele.name] = ele.value;
	});
	
	callNavigateFilter(data,null);
}
