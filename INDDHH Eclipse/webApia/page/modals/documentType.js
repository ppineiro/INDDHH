var DOC_TYPE_MODAL_HIDE_OVERFLOW	= true;

function initDocTypeMdlPage(){
	var mdlDocTypeContainer = $('mdlDocTypeContainer');
	if (mdlDocTypeContainer.initDone) return;
	mdlDocTypeContainer.initDone = true;

	mdlDocTypeContainer.blockerModal = new Mask();
	
	['orderByNameDocTypeMdl','orderByTitleDocTypeMdl'].each(function(ele){
		ele = $(ele);
		ele.set('title', GNR_ORDER_BY + ele.getAttribute("name"))
	});
	
	['nameFilterDocTypeMdl','titleFilterDocTypeMdl'].each(function(ele) {
		ele = $(ele);
		ele.setFilterDocType = setFilterDocType;
		ele.oldValue = ele.value;
		ele.addEvent("keyup", function(e) {
			if (this.oldValue == this.value) return;
			if (this.timmer) $clear(this.timmer);
			this.oldValue = this.value;
			this.timmer = this.setFilterDocType.delay(200, this);			
		});		
	});
	
	
	$('closeModalDocType').addEvent("click", function(e) {
		e.stop();
		closeDocTypeModal();
	});
	
	
	$('clearFiltersDocType').addEvent("click", function(e) {
		e.stop();
		['nameFilterDocTypeMdl','titleFilterDocTypeMdl'].each(clearFilter);
		$('nameFilterDocTypeMdl').setFilterDocType();
	});
	
	$('confirmModalDocType').addEvent("click", function(e) {
		var mdlDocTypeContainer = $('mdlDocTypeContainer');
		if (mdlDocTypeContainer.onModalConfirm) jsCaller(mdlDocTypeContainer.onModalConfirm,getSelectedRows($('tableDataDocType')));
		closeDocTypeModal();
	});
	
	//Evento doble-click con misma funcionalidad que boton confirmar
	$('tableDataDocType').getParent().addEvent("dblclick", function(e) {
		if (mdlDocTypeContainer.onModalConfirm) jsCaller(mdlDocTypeContainer.onModalConfirm,getSelectedRows($('tableDataDocType')));
		closeDocTypeModal();
	});
	
	//eventos para order
	['orderByNameDocTypeMdl','orderByTitleDocTypeMdl'].each(function(ele){
		$(ele).addEvent("click", function(e) {
			e.stop();
			callNavigateOrder(this.getAttribute('data-sortBy'),this,'/apia.modals.DocumentTypeAction.run','DocType');
		});
	});
	
	window.sp_DocType = new Spinner($('tableDataDocType').getParent('table'), {message: WAIT_A_SECOND});
	window.sp_DocType.content.getParent().addClass('mdlSpinner');
	initNavButtons('/apia.modals.DocumentTypeAction.run','DocType');
}


var DOC_TYPE_MODAL_SELECTONLYONE	= false;

//establecer un filtro
function setFilterDocType(){
	currentPrefix = 'DocType';
	callNavigateFilter({
		txtName: $('nameFilterDocTypeMdl').value,
		txtTitle: $('titleFilterDocTypeMdl').value,
		selectOnlyOne: DOC_TYPE_MODAL_SELECTONLYONE
	},null,'/apia.modals.DocumentTypeAction.run','DocType');
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
	$('documentTypeTrOrderBy').getElements(".orderedBy").each(function(item, index){
	    item.removeClass("orderedBy");
	});
	
	$('documentTypeTrOrderBy').getElements(".sortUp").each(function(item, index){
		if(obj!=item){
			item.removeClass("sortUp");
			item.addClass("unsorted");
		}
	});
	
	$('documentTypeTrOrderBy').getElements(".sortDown").each(function(item, index){
		if(obj!=item){
			item.removeClass("sortDown");
			item.addClass("unsorted");
		}
	});
	
}

function showDocTypeModal(retFunction, closeFunction){
	
	if(DOC_TYPE_MODAL_HIDE_OVERFLOW) {
		$(document.body).setStyle('overflow', 'hidden');
	}
	
	setFilterDocType();
   
    unSelectAllRows($('tableDataDocType'));
	
	var mdlDocTypeContainer = $('mdlDocTypeContainer');
	mdlDocTypeContainer.removeClass('hiddenModal');
	mdlDocTypeContainer.position();
	mdlDocTypeContainer.blockerModal.show();
	mdlDocTypeContainer.setStyle('zIndex', SYS_PANELS.getNewZIndex());
	mdlDocTypeContainer.onModalConfirm = retFunction;
	mdlDocTypeContainer.onModalClose = closeFunction;
}

function closeDocTypeModal(){
    var mdlDocTypeContainer = $('mdlDocTypeContainer');
    
    if(Browser.chrome || Browser.firefox || Browser.safari) {
		var morph = new Fx.Morph(mdlDocTypeContainer, {duration: 200, wait: false});
		
		morph.start({
			'margin-top': '-10px',
			'opacity': 0
		}).chain(function() {
			
			mdlDocTypeContainer.addClass('hiddenModal');
			mdlDocTypeContainer.setStyles({
				'opacity': 1,
				'margin-top': ''
			}); //Limpiar la transicion
						
			mdlDocTypeContainer.blockerModal.hide();
			if (mdlDocTypeContainer.onModalClose) mdlDocTypeContainer.onModalClose();
			
			if(DOC_TYPE_MODAL_HIDE_OVERFLOW) {
				$(document.body).setStyle('overflow', '');
			}
		});
	} else {
		
		mdlDocTypeContainer.addClass('hiddenModal');
		
		mdlDocTypeContainer.blockerModal.hide();
		if (mdlDocTypeContainer.onModalClose) mdlDocTypeContainer.onModalClose();
		
		if(DOC_TYPE_MODAL_HIDE_OVERFLOW) {
			$(document.body).setStyle('overflow', '');
		}
	}
}
