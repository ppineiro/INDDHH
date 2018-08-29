var PANELMODAL_HIDE_OVERFLOW	= true;

function initPanelMdlPage(){
	var mdlPanelContainer = $('mdlPanelContainer');
	if (mdlPanelContainer.initDone) return;
	mdlPanelContainer.initDone = true;
	
	mdlPanelContainer.blockerModal = new Mask();
	
	['orderByNamePnlMdl','orderByTitlePnlMdl','orderByTypePnlMdl'].each(function(ele){
		ele = $(ele);
		ele.tooltip(GNR_ORDER_BY + ele.getAttribute("title"), { mode: 'auto', width: 100, hook: 0 })
	});
	
	['nameFilterPnlMdl','titleFilterPnlMdl'].each(function(ele) {
		ele = $(ele);
		ele.setFilterPanel = setFilterPanel;
		ele.oldValue = ele.value;
		ele.addEvent("keyup", function(e) {
			if (this.oldValue == this.value) return;
			if (this.timmer) $clear(this.timmer);
			this.oldValue = this.value;
			this.timmer = this.setFilterPanel.delay(200, this);
			
		});		
	});
	
	$('closeModalPanel').addEvent("click", function(e) {
		e.stop();
		closePanelsModal();
	});
	
	$('clearFiltersPanel').addEvent("click", function(e) {
		e.stop();
		['nameFilterPnlMdl','titleFilterPnlMdl','typeFilterPnlMdl'].each(clearFilter);		
		$('nameFilterPnlMdl').setFilterPanel();
	});
	
	$('confirmModalPanel').addEvent("click", function(e) {
		var mdlPanelContainer = $('mdlPanelContainer');
		if (mdlPanelContainer.onModalConfirm) jsCaller(mdlPanelContainer.onModalConfirm,getSelectedRows($('tableDataPanel')));
		closePanelsModal();
	});
	
	//Evento doble-click con misma funcionalidad que boton confirmar
	$('tableDataPanel').getParent().addEvent("dblclick", function(e) {
		if (mdlPanelContainer.onModalConfirm) jsCaller(mdlPanelContainer.onModalConfirm,getSelectedRows($('tableDataPanel')));
		closePanelsModal();
	});
	
	//eventos para order
	['orderByNamePnlMdl','orderByTitlePnlMdl','orderByTypePnlMdl'].each(function(ele){
		$(ele).addEvent("click", function(e) {
			e.stop();
			callNavigateOrder(this.getAttribute('sortBy'),this,'/apia.modals.PanelsAction.run','Panel');
		});
	});
	
	window.sp_Panel = new Spinner($('tableDataPanel'), {message: WAIT_A_SECOND});
	window.sp_Panel.content.getParent().addClass('mdlSpinner');
	
	initNavButtons('/apia.modals.PanelsAction.run','Panel');
} 

//variables para valores fijos del modal
//se deben setear desde el js/jsp que usa el modal
var PANELMODAL_SELECTONLYONE	= false;

//establecer un filtro
function setFilterPanel(){
	callNavigateFilter({
		txtName: $('nameFilterPnlMdl').value,
		txtTitle: $('titleFilterPnlMdl').value,
		txtType: $('typeFilterPnlMdl').value,
		selectOnlyOne: PANELMODAL_SELECTONLYONE		
		},null,'/apia.modals.PanelsAction.run','Panel');
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

function showPanelsModal(retFunction, closeFunction){
	
	if(PANELMODAL_HIDE_OVERFLOW) {
		$(document.body).setStyle('overflow', 'hidden');
	}
	
	setFilterPanel();
	unSelectAllRows($('tableDataPanel'));

	var mdlPanelContainer = $('mdlPanelContainer');
	mdlPanelContainer.removeClass('hiddenModal');
	mdlPanelContainer.position();
	mdlPanelContainer.blockerModal.show();
	mdlPanelContainer.setStyle('zIndex', SYS_PANELS.getNewZIndex());
	mdlPanelContainer.onModalConfirm = retFunction;
	mdlPanelContainer.onModalClose = closeFunction;
}

function closePanelsModal(){
	var mdlPanelContainer = $('mdlPanelContainer');
	
	if(Browser.chrome || Browser.firefox || Browser.safari) {
		var morph = new Fx.Morph(mdlPanelContainer, {duration: 200, wait: false});
		
		morph.start({
			'margin-top': '-10px',
			'opacity': 0
		}).chain(function() {
			
			mdlPanelContainer.addClass('hiddenModal');
			mdlPanelContainer.setStyles({
				'opacity': 1,
				'margin-top': ''
			}); //Limpiar la transicion
						
			mdlPanelContainer.blockerModal.hide();
			if (mdlPanelContainer.onModalClose) mdlPanelContainer.onModalClose();
			
			if(PANELMODAL_HIDE_OVERFLOW) {
				$(document.body).setStyle('overflow', '');
			}
		});
	} else {
		
		mdlPanelContainer.addClass('hiddenModal');
		
		mdlPanelContainer.blockerModal.hide();
		if (mdlPanelContainer.onModalClose) mdlPanelContainer.onModalClose();
		
		if(PANELMODAL_HIDE_OVERFLOW) {
			$(document.body).setStyle('overflow', '');
		}
	}
	
	
	
}
