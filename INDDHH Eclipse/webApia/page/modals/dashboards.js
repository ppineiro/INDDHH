var DASHBOARDSMODAL_HIDE_OVERFLOW	= true;

function initDashboardsMdlPage(){
	var mdlDshContainer = $('mdlDshContainer');
	if (mdlDshContainer.initDone) return;
	mdlDshContainer.initDone = true;

	mdlDshContainer.blockerModal = new Mask();
	
	['orderByNameDshMdl'].each(function(ele){
		ele = $(ele);
		ele.set('title', GNR_ORDER_BY + ele.getAttribute("name"))
	});
	
	['nameFilterDshMdl'].each(function(ele) {
		ele = $(ele);
		ele.setFilterDsh = setFilterDsh;
		ele.oldValue = ele.value;
		ele.addEvent("keyup", function(e) {
			if (this.oldValue == this.value) return;
			if (this.timmer) $clear(this.timmer);
			this.oldValue = this.value;
			this.timmer = this.setFilterDsh.delay(200, this);
			
		});		
	});
	
	$('closeModalDsh').addEvent("click", function(e) {
		e.stop();
		closeDashboardsModal();
	});
	
	$('clearFiltersDsh').addEvent("click", function(e) {
		e.stop();
		['nameFilterDshMdl'].each(clearFilter);
		$('nameFilterDshMdl').setFilterDsh();
	});
	
	$('confirmModalDsh').addEvent("click", function(e) {
		var mdlDshContainer = $('mdlDshContainer');
		if (mdlDshContainer.onModalConfirm) jsCaller(mdlDshContainer.onModalConfirm,getSelectedRows($('tableDataDsh')));
		closeDashboardsModal();
	});
	
	//Evento doble-click con misma funcionalidad que boton confirmar
	$('tableDataDsh').getParent().addEvent("dblclick", function(e) {
		if (mdlDshContainer.onModalConfirm) jsCaller(mdlDshContainer.onModalConfirm,getSelectedRows($('tableDataDsh')));
		closeDashboardsModal();
	});
	
	//eventos para order
	['orderByNameDshMdl'].each(function(ele){
		$(ele).addEvent("click", function(e) {
			e.stop();
			callNavigateOrder(this.getAttribute('data-sortBy'),this,'/apia.modals.DashboardsAction.run','Dsh');
		});
	});
	
	window.sp_Dsh = new Spinner($('tableDataDsh').getParent('table'), {message: WAIT_A_SECOND});
	window.sp_Dsh.content.getParent().addClass('mdlSpinner');
	initNavButtons('/apia.modals.DashboardsAction.run','Dsh');
}


var DASHBOARDSMODAL_SELECTONLYONE	= false;
var DASHBOARD_ENVIRONMENT = null;
var DASHBOARD_ONLY_LANDING_PAGE = false;

//establecer un filtro
function setFilterDsh(){
	currentPrefix = 'Dsh';
	callNavigateFilter({
		txtName: $('nameFilterDshMdl').value,
		selectOnlyOne: DASHBOARDSMODAL_SELECTONLYONE,
		txtEnvId: DASHBOARD_ENVIRONMENT,
		txtLand: DASHBOARD_ONLY_LANDING_PAGE ? '1' : null
	},null,'/apia.modals.DashboardsAction.run','Dsh');
}

//establecer el orden
function setOrderByClass(obj){
	obj.toggleClass("orderedBy");
	if(obj.hasClass("unsorted")){
		obj.removeClass("unsorted")
		obj.addClass("sortUp");
	} else {
		if(obj.hasClass("sortUp")){
			obj.removeClass("sortUp")
			obj.addClass("sortDown");
		}else{
			obj.addClass("sortUp")
			obj.removeClass("sortDown");
		}
	}
}

function removeOrderByClass(obj){
	$('dashboardsTrOrderBy').getElements(".orderedBy").each(function(item, index){
	    item.removeClass("orderedBy");
	});
	
	$('dashboardsTrOrderBy').getElements(".sortUp").each(function(item, index){
		if(obj!=item){
			item.removeClass("sortUp");
			item.addClass("unsorted");
		}
	});
	
	$('dashboardsTrOrderBy').getElements(".sortDown").each(function(item, index){
		if(obj!=item){
			item.removeClass("sortDown");
			item.addClass("unsorted");
		}
	});
}

function showDashboardsModal(retFunction, closeFunction, valueToShow){
	
	if(DASHBOARDSMODAL_HIDE_OVERFLOW) {
		$(document.body).setStyle('overflow', 'hidden');
	}
	
	if (!valueToShow || valueToShow == null || valueToShow == "undefined")
		valueToShow = "";
	
	$('nameFilterDshMdl').set('value', valueToShow);
	
	setFilterDsh();
   
    unSelectAllRows($('tableDataDsh'));
	
	var mdlDshContainer = $('mdlDshContainer');
	mdlDshContainer.removeClass('hiddenModal');
	mdlDshContainer.position();
	mdlDshContainer.blockerModal.show();
	mdlDshContainer.setStyle('zIndex', SYS_PANELS.getNewZIndex());
	mdlDshContainer.onModalConfirm = retFunction;
	mdlDshContainer.onModalClose = closeFunction;
}

function closeDashboardsModal(){
    var mdlDshContainer = $('mdlDshContainer');
    
    if(Browser.chrome || Browser.firefox || Browser.safari) {
		var morph = new Fx.Morph(mdlDshContainer, {duration: 200, wait: false});
		
		morph.start({
			'margin-top': '-10px',
			'opacity': 0
		}).chain(function() {
			
			mdlDshContainer.addClass('hiddenModal');
			mdlDshContainer.setStyles({
				'opacity': 1,
				'margin-top': ''
			}); //Limpiar la transicion
						
			mdlDshContainer.blockerModal.hide();
			if (mdlDshContainer.onModalClose) mdlDshContainer.onModalClose();
			
			if(DASHBOARDSMODAL_HIDE_OVERFLOW) {
				$(document.body).setStyle('overflow', '');
			}
		});
	} else {
		
		mdlDshContainer.addClass('hiddenModal');
		
		mdlDshContainer.blockerModal.hide();
		if (mdlDshContainer.onModalClose) mdlDshContainer.onModalClose();
		
		if(DASHBOARDSMODAL_HIDE_OVERFLOW) {
			$(document.body).setStyle('overflow', '');
		}
	}
   
}