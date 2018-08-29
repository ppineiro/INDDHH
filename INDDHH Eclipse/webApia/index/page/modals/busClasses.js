var BUSCLAMODAL_HIDE_OVERFLOW	= true;

function initBusClaMdlPage(){
	var mdlBusClaContainer = $('mdlBusClaContainer');
	if (mdlBusClaContainer.initDone) return;
	mdlBusClaContainer.initDone = true;

	mdlBusClaContainer.blockerModal = new Mask();
	
	['orderByNameBusClaMdl','orderByDescBusClaMdl'].each(function(ele){
		ele = $(ele);
		ele.tooltip(GNR_ORDER_BY + ele.getAttribute("title"), { mode: 'auto', width: 100, hook: 0 })
	});
	
	['nameFilterBusClaMdl','descFilterBusClaMdl'].each(function(ele) {
		ele = $(ele);
		ele.setFilterBusCla = setFilterBusCla;
		ele.oldValue = ele.value;
		ele.addEvent("keyup", function(e) {
			if (this.oldValue == this.value) return;
			if (this.timmer) $clear(this.timmer);
			this.oldValue = this.value;
			this.timmer = this.setFilterBusCla.delay(200, this);
			
		});		
	});
	
	$('closeModalBusCla').addEvent("click", function(e) {
		e.stop();
		closeBusClaModal();
	});
	
	$('clearFiltersBusCla').addEvent("click", function(e) {
		e.stop();
		['nameFilterBusClaMdl'].each(clearFilter);
		$('descFilterBusClaMdl').value="";
		
		$('nameFilterBusClaMdl').setFilterBusCla();
	});
	 
	$('confirmModalBusCla').addEvent("click", function(e) {
		var mdlBusClaContainer = $('mdlBusClaContainer');
		if (mdlBusClaContainer.onModalConfirm) jsCaller(mdlBusClaContainer.onModalConfirm,getSelectedRows($('tableDataBusCla')));
		closeBusClaModal();
	});
	
	//Evento doble-click con misma funcionalidad que boton confirmar
	$('tableDataBusCla').getParent().addEvent("dblclick", function(e) {
		if (mdlBusClaContainer.onModalConfirm) jsCaller(mdlBusClaContainer.onModalConfirm,getSelectedRows($('tableDataBusCla')));
		closeBusClaModal();
	});
	
	//eventos para order
	['orderByNameBusClaMdl','orderByDescBusClaMdl'].each(function(ele){
		$(ele).addEvent("click", function(e) {
			e.stop();
			currentPrefix = 'BusCla';
			callNavigateOrder(this.getAttribute('sortBy'),this,'/apia.modals.BusClassAction.run','BusCla');
		});
	});
	
	window.sp_BusCla = new Spinner($('tableDataBusCla'), {message: WAIT_A_SECOND});
	window.sp_BusCla.content.getParent().addClass('mdlSpinner');
	initNavButtons('/apia.modals.BusClassAction.run','BusCla');
}

var BUSCLAMODAL_SHOWGLOBAL = false;
var BUSCLAMODAL_FROMENVS = "";
var BUSCLAMODAL_SELECTONLYONE	= false;

//establecer un filtro
function setFilterBusCla(){
	callNavigateFilter({
		txtName: $('nameFilterBusClaMdl').value,
		txtDesc: $('descFilterBusClaMdl').value,
		showGlobal : BUSCLAMODAL_SHOWGLOBAL,
		fromEnvs : BUSCLAMODAL_FROMENVS,
		selectOnlyOne: BUSCLAMODAL_SELECTONLYONE
	},null,'/apia.modals.BusClassAction.run','BusCla');
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
	$('trOrderBy').getElements(".orderedBy").each(function(item, index){
	    item.removeClass("orderedBy");
	});
	
	$('trOrderBy').getElements(".sortUp").each(function(item, index){
		if(obj!=item){
			item.removeClass("sortUp");
			item.addClass("unsorted");
		}
	});
	
	$('trOrderBy').getElements(".sortDown").each(function(item, index){
		if(obj!=item){
			item.removeClass("sortDown");
			item.addClass("unsorted");
		}
	});
	
}

var returnFunction;
var blocker;

function showBusClassModal(retFunction, closeFunction){
	
	if(BUSCLAMODAL_HIDE_OVERFLOW) {
		$(document.body).setStyle('overflow', 'hidden');
	}
	
	setFilterBusCla();
	unSelectAllRows($('tableDataBusCla'));
	
	var mdlBusClaContainer = $('mdlBusClaContainer');
	mdlBusClaContainer.removeClass('hiddenModal');
	mdlBusClaContainer.position();
	mdlBusClaContainer.blockerModal.show();
	mdlBusClaContainer.setStyle('zIndex', SYS_PANELS.getNewZIndex());
	mdlBusClaContainer.onModalConfirm = retFunction;
	mdlBusClaContainer.onModalClose = closeFunction;
}

function closeBusClaModal(){
	var mdlBusClaContainer = $('mdlBusClaContainer');
	
	if(Browser.chrome || Browser.firefox || Browser.safari) {
		var morph = new Fx.Morph(mdlBusClaContainer, {duration: 200, wait: false});
		
		morph.start({
			'margin-top': '-10px',
			'opacity': 0
		}).chain(function() {
			
			mdlBusClaContainer.addClass('hiddenModal');
			mdlBusClaContainer.setStyles({
				'opacity': 1,
				'margin-top': ''
			}); //Limpiar la transicion
						
			mdlBusClaContainer.blockerModal.hide();
			if (mdlBusClaContainer.onModalClose) mdlBusClaContainer.onModalClose();
			
			if(BUSCLAMODAL_HIDE_OVERFLOW) {
				$(document.body).setStyle('overflow', '');
			}
		});
	} else {
		
		mdlBusClaContainer.addClass('hiddenModal');
		
		mdlBusClaContainer.blockerModal.hide();
		if (mdlBusClaContainer.onModalClose) mdlBusClaContainer.onModalClose();
		
		if(BUSCLAMODAL_HIDE_OVERFLOW) {
			$(document.body).setStyle('overflow', '');
		}
	}
}
