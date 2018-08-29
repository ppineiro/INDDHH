var ENTITIESMODAL_HIDE_OVERFLOW	= true;

function initEntMdlPage(){
	var mdlEntContainer = $('mdlEntContainer');
	if (mdlEntContainer.initDone) return; 
	mdlEntContainer.initDone = true;

	mdlEntContainer.blockerModal = new Mask();
	
	['orderByNameEntMdl'].each(function(ele){
		ele = $(ele);
		ele.tooltip(GNR_ORDER_BY + ele.getAttribute("title"), { mode: 'auto', width: 100, hook: 0 })
	});
	
	['nameFilterEntMdl'].each(function(ele) {
		ele = $(ele);
		ele.setFilterEnt = setFilterEnt;
		ele.oldValue = ele.value;
		ele.addEvent("keyup", function(e) {
			if (this.oldValue == this.value) return;
			if (this.timmer) $clear(this.timmer);
			this.oldValue = this.value;
			this.timmer = this.setFilterEnt.delay(200, this);
			
		});		
	});
	
	$('closeModalEnt').addEvent("click", function(e) {
		e.stop();
		closeEntitiesModal();
	});
	
	$('clearFiltersEnt').addEvent("click", function(e) {
		e.stop();
		['nameFilterEntMdl'].each(clearFilter);
		$('nameFilterEntMdl').setFilterEnt();
	});
	
 
	$('confirmModalEnt').addEvent("click", function(e) {
		var mdlEntContainer = $('mdlEntContainer');
		if (mdlEntContainer.onModalConfirm) jsCaller(mdlEntContainer.onModalConfirm,getSelectedRows($('tableDataEnt')));
		closeEntitiesModal();
	});
	
	//Evento doble-click con misma funcionalidad que boton confirmar
	$('tableDataEnt').getParent().addEvent("dblclick", function(e) {
		if (mdlEntContainer.onModalConfirm) jsCaller(mdlEntContainer.onModalConfirm,getSelectedRows($('tableDataEnt')));
		closeEntitiesModal();
	});
	
	//eventos para order
	['orderByNameEntMdl'].each(function(ele){
		$(ele).addEvent("click", function(e) {
			e.stop();
			currentPrefix = 'Ent';
			callNavigateOrder(this.getAttribute('sortBy'),this,'/apia.modals.EntitiesAction.run','Ent');
		});
	});
	
	window.sp_Ent = new Spinner($('tableDataEnt'), {message: WAIT_A_SECOND});
	window.sp_Ent.content.getParent().addClass('mdlSpinner');
	
	initNavButtons('/apia.modals.EntitiesAction.run','Ent');
}

var ENTITIESMODAL_SHOWGLOBAL = false;
var ENTITIESMODAL_SELECTONLYONE	= false;

//establecer un filtro
function setFilterEnt(){
	callNavigateFilter({
		txtName: $('nameFilterEntMdl').value,
		showGlobal : ENTITIESMODAL_SHOWGLOBAL,
		selectOnlyOne: ENTITIESMODAL_SELECTONLYONE
	},null,'/apia.modals.EntitiesAction.run','Ent');
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

function showEntitiesModal(retFunction, closeFunction){
	
	if(ENTITIESMODAL_HIDE_OVERFLOW) {
		$(document.body).setStyle('overflow', 'hidden');
	}
	
	setFilterEnt();
	unSelectAllRows($('tableDataEnt'));
	
	var mdlEntContainer = $('mdlEntContainer');
	mdlEntContainer.removeClass('hiddenModal');
	mdlEntContainer.position();
	mdlEntContainer.blockerModal.show();
	mdlEntContainer.setStyle('zIndex', SYS_PANELS.getNewZIndex());
	mdlEntContainer.onModalConfirm = retFunction;
	mdlEntContainer.onModalClose = closeFunction;
}

function closeEntitiesModal(){
	var mdlEntContainer = $('mdlEntContainer');
	
	if(Browser.chrome || Browser.firefox || Browser.safari) {
		var morph = new Fx.Morph(mdlEntContainer, {duration: 200, wait: false});
		
		morph.start({
			'margin-top': '-10px',
			'opacity': 0
		}).chain(function() {
			
			mdlEntContainer.addClass('hiddenModal');
			mdlEntContainer.setStyles({
				'opacity': 1,
				'margin-top': ''
			}); //Limpiar la transicion
						
			mdlEntContainer.blockerModal.hide();
			if (mdlEntContainer.onModalClose) mdlEntContainer.onModalClose();
			
			if(ENTITIESMODAL_HIDE_OVERFLOW) {
				$(document.body).setStyle('overflow', '');
			}
		});
	} else {
		
		mdlEntContainer.addClass('hiddenModal');
		
		mdlEntContainer.blockerModal.hide();
		if (mdlEntContainer.onModalClose) mdlEntContainer.onModalClose();
		
		if(ENTITIESMODAL_HIDE_OVERFLOW) {
			$(document.body).setStyle('overflow', '');
		}
	}
	
}
