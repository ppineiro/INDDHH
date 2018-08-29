var BUS_CLA_PARAM_MODAL_HIDE_OVERFLOW	= true;

function initBusClaParMdlPage(){
	var mdlBusClaParContainer = $('mdlBusClaParContainer');
	if (mdlBusClaParContainer.initDone) return;
	mdlBusClaParContainer.initDone = true;

	mdlBusClaParContainer.blockerModal = new Mask();
		
	['nameFilterBusClaParMdl'].each(function(ele) {
		ele = $(ele);
		ele.setFilterBusClaPar = setFilterBusClaPar;
		ele.oldValue = ele.value;
		ele.addEvent("keyup", function(e) {
			if (this.oldValue == this.value) return;
			if (this.timmer) $clear(this.timmer);
			this.oldValue = this.value;
			this.timmer = this.setFilterBusClaPar.delay(200, this);
			
		});		
	});
	
	$('closeModalBusClaPar').addEvent("click", function(e) {
		e.stop();
		closeBusClaParModal();
	});
	
	$('clearFiltersBusClaPar').addEvent("click", function(e) {
		e.stop();
		['nameFilterBusClaParMdl'].each(clearFilter);
		$('nameFilterBusClaParMdl').setFilterBusClaPar();
	});
	
 
	$('confirmModalBusClaPar').addEvent("click", function(e) {
		var mdlBusClaParContainer = $('mdlBusClaParContainer');
		if (mdlBusClaParContainer.onModalConfirm){
			SYS_PANELS.showLoading();
			jsCaller(mdlBusClaParContainer.onModalConfirm,getSelectedRows($('tableDataBusClaPar')));
			if (!mdlBusClaParContainer.notCloseActive){
				SYS_PANELS.closeActive();
			}					
		}
		closeBusClaParModal();
	});
	
	//Evento doble-click con misma funcionalidad que boton confirmar
	$('tableDataBusClaPar').getParent().addEvent("dblclick", function(e) {
		if (mdlBusClaParContainer.onModalConfirm) jsCaller(mdlBusClaParContainer.onModalConfirm,getSelectedRows($('tableDataBusClaPar')));
		closeBusClaParModal();
	});
	
	$$("div.button").each(function(ele){
		ele.addEvent("mouseover", function(evt) {this.toggleClass("buttonHover")});
		ele.addEvent("mouseout", function(evt) {this.toggleClass("buttonHover")});
	});
	
	window.sp_BusClaPar = new Spinner($('tableDataBusClaPar'), {message: WAIT_A_SECOND});
	window.sp_BusClaPar.content.getParent().addClass('mdlSpinner');
	initNavButtons('/apia.modals.BusClaParAction.run','BusClaPar');
}

var BUS_CLA_PARAM_MODAL_BC_ID = 0;
var BUS_CLA_PARAM_MODAL_PAR_TYPE = "B";

//establecer un filtro
function setFilterBusClaPar(){
	callNavigateFilter({
		parName: $('nameFilterBusClaParMdl').value,	
		busClaId:BUS_CLA_PARAM_MODAL_BC_ID,
		parType: BUS_CLA_PARAM_MODAL_PAR_TYPE,
	},null,'/apia.modals.BusClaParAction.run','BusClaPar');
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

function showBusClaParModal(retFunction, closeFunction, notCloseActive){
	
	if(BUS_CLA_PARAM_MODAL_HIDE_OVERFLOW) {
		$(document.body).setStyle('overflow', 'hidden');
	}
	
	setFilterBusClaPar();
	unSelectAllRows($('tableDataBusClaPar'));
	
	var mdlBusClaParContainer = $('mdlBusClaParContainer');
	mdlBusClaParContainer.removeClass('hiddenModal');
	mdlBusClaParContainer.position();
	mdlBusClaParContainer.blockerModal.show();
	mdlBusClaParContainer.setStyle('zIndex', SYS_PANELS.getNewZIndex());
	mdlBusClaParContainer.onModalConfirm = retFunction;
	mdlBusClaParContainer.onModalClose = closeFunction;
	mdlBusClaParContainer.notCloseActive = toBoolean(notCloseActive);
}

function closeBusClaParModal(){
	var mdlBusClaParContainer = $('mdlBusClaParContainer');
	
	if(Browser.chrome || Browser.firefox || Browser.safari) {
		var morph = new Fx.Morph(mdlBusClaParContainer, {duration: 200, wait: false});
		
		morph.start({
			'margin-top': '-10px',
			'opacity': 0
		}).chain(function() {
			
			mdlBusClaParContainer.addClass('hiddenModal');
			mdlBusClaParContainer.setStyles({
				'opacity': 1,
				'margin-top': ''
			}); //Limpiar la transicion
						
			mdlBusClaParContainer.blockerModal.hide();
			if (mdlBusClaParContainer.onModalClose) mdlBusClaParContainer.onModalClose();
			
			if(BUS_CLA_PARAM_MODAL_HIDE_OVERFLOW) {
				$(document.body).setStyle('overflow', '');
			}
		});
	} else {
		
		mdlBusClaParContainer.addClass('hiddenModal');
		
		mdlBusClaParContainer.blockerModal.hide();
		if (mdlBusClaParContainer.onModalClose) mdlBusClaParContainer.onModalClose();
		
		if(BUS_CLA_PARAM_MODAL_HIDE_OVERFLOW) {
			$(document.body).setStyle('overflow', '');
		}
	}
}
