var STATUSMODAL_HIDE_OVERFLOW	= true;

function initStaMdlPage(){
	var mdlStaContainer = $('mdlStaContainer');
	if (mdlStaContainer.initDone) return;
	mdlStaContainer.initDone = true;

	mdlStaContainer.blockerModal = new Mask();
	
	['orderByNameStaMdl'].each(function(ele){
		ele = $(ele);
		ele.tooltip(GNR_ORDER_BY + ele.getAttribute("title"), { mode: 'auto', width: 100, hook: 0 })
	});
	
	['nameFilterStaMdl'].each(function(ele) {
		ele = $(ele);
		ele.setFilterSta = setFilterSta;
		ele.oldValue = ele.value;
		ele.addEvent("keyup", function(e) {
			if (this.oldValue == this.value) return;
			if (this.timmer) $clear(this.timmer);
			this.oldValue = this.value;
			this.timmer = this.setFilterSta.delay(200, this);
			
		});		
	});
	
	$('closeModalSta').addEvent("click", function(e) {
		e.stop();
		closeStatusModal();
	});
	
	$('clearFiltersSta').addEvent("click", function(e) {
		e.stop();
		['nameFilterStaMdl'].each(clearFilter);
		$('nameFilterStaMdl').setFilterSta();
	});
	
 
	$('confirmModalSta').addEvent("click", function(e) {
		var mdlStaContainer = $('mdlStaContainer');
		if (mdlStaContainer.onModalConfirm) jsCaller(mdlStaContainer.onModalConfirm,getSelectedRows($('tableDataSta')));
		closeStatusModal();
	});
	
	//Evento doble-click con misma funcionalidad que boton confirmar
	$('tableDataSta').getParent().addEvent("dblclick", function(e) {
		if (mdlStaContainer.onModalConfirm) jsCaller(mdlStaContainer.onModalConfirm,getSelectedRows($('tableDataSta')));
		closeStatusModal();
	});
	
	//eventos para order
	['orderByNameStaMdl'].each(function(ele){
		$(ele).addEvent("click", function(e) {
			e.stop();
			currentPrefix = 'Sta';
			callNavigateOrder(this.getAttribute('sortBy'),this,'/apia.modals.StatusAction.run','Sta');
		});
	});
	
	window.sp_Sta = new Spinner($('tableDataSta'), {message: WAIT_A_SECOND});
	window.sp_Sta.content.getParent().addClass('mdlSpinner');
	
	initNavButtons('/apia.modals.StatusAction.run','Sta');
}

var STATUSMODAL_SHOWGLOBAL = false;
var STATUSMODAL_SELECTONLYONE	= false;

//establecer un filtro
function setFilterSta(){
	callNavigateFilter({
		txtName: $('nameFilterStaMdl').value,
		showGlobal : STATUSMODAL_SHOWGLOBAL,
		selectOnlyOne: STATUSMODAL_SELECTONLYONE
	},null,'/apia.modals.StatusAction.run','Sta');
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

function showStatusModal(retFunction, closeFunction){
	
	if(STATUSMODAL_HIDE_OVERFLOW) {
		$(document.body).setStyle('overflow', 'hidden');
	}
	
	setFilterSta();
	unSelectAllRows($('tableDataSta'));
	
	var mdlStaContainer = $('mdlStaContainer');
	mdlStaContainer.removeClass('hiddenModal');
	mdlStaContainer.position();
	mdlStaContainer.blockerModal.show();
	mdlStaContainer.setStyle('zIndex', SYS_PANELS.getNewZIndex());
	mdlStaContainer.onModalConfirm = retFunction;
	mdlStaContainer.onModalClose = closeFunction;
}

function closeStatusModal(){
	var mdlStaContainer = $('mdlStaContainer');
	
	if(Browser.chrome || Browser.firefox || Browser.safari) {
		var morph = new Fx.Morph(mdlStaContainer, {duration: 200, wait: false});
		
		morph.start({
			'margin-top': '-10px',
			'opacity': 0
		}).chain(function() {
			
			mdlStaContainer.addClass('hiddenModal');
			mdlStaContainer.setStyles({
				'opacity': 1,
				'margin-top': ''
			}); //Limpiar la transicion
						
			mdlStaContainer.blockerModal.hide();
			if (mdlStaContainer.onModalClose) mdlStaContainer.onModalClose();
			
			if(STATUSMODAL_HIDE_OVERFLOW) {
				$(document.body).setStyle('overflow', '');
			}
		});
	} else {
		
		mdlStaContainer.addClass('hiddenModal');
		
		mdlStaContainer.blockerModal.hide();
		if (mdlStaContainer.onModalClose) mdlStaContainer.onModalClose();
		
		if(STATUSMODAL_HIDE_OVERFLOW) {
			$(document.body).setStyle('overflow', '');
		}
	}
}
