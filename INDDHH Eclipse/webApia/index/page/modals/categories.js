var CATEGORIESMODAL_HIDE_OVERFLOW	= true;

function initCatMdlPage(){
	var mdlCatContainer = $('mdlCatContainer');
	if (mdlCatContainer.initDone) return; 
	mdlCatContainer.initDone = true;

	mdlCatContainer.blockerModal = new Mask();
	
	['orderByNameCatMdl'].each(function(ele){
		ele = $(ele);
		ele.tooltip(GNR_ORDER_BY + ele.getAttribute("title"), { mode: 'auto', width: 100, hook: 0 })
	});
	
	['nameFilterCatMdl'].each(function(ele) {
		ele = $(ele);
		ele.setFilterCat = setFilterCat;
		ele.oldValue = ele.value;
		ele.addEvent("keyup", function(e) {
			if (this.oldValue == this.value) return;
			if (this.timmer) $clear(this.timmer);
			this.oldValue = this.value;
			this.timmer = this.setFilterCat.delay(200, this);
			
		});		
	});
	
	$('closeModalCat').addEvent("click", function(e) {
		e.stop();
		closeCategoriesModal();
	});
	
	$('clearFiltersCat').addEvent("click", function(e) {
		e.stop();
		['nameFilterCatMdl'].each(clearFilter);
		$('nameFilterCatMdl').setFilterCat();
	});
	
 
	$('confirmModalCat').addEvent("click", function(e) {
		var mdlCatContainer = $('mdlCatContainer');
		if (mdlCatContainer.onModalConfirm) jsCaller(mdlCatContainer.onModalConfirm,getSelectedRows($('tableDataCat')));
		closeCategoriesModal();
	});
	//eventos para order
	['orderByNameCatMdl'].each(function(ele){
		$(ele).addEvent("click", function(e) {
			e.stop();
			currentPrefix = 'Cat';
			callNavigateOrder(this.getAttribute('sortBy'),this,'/apia.modals.CategoriesAction.run','Cat');
		});
	});
	
	window.sp_Cat = new Spinner($('tableDataCat'), {message: WAIT_A_SECOND});
	window.sp_Cat.content.getParent().addClass('mdlSpinner');
	
	initNavButtons('/apia.modals.CategoriesAction.run','Cat');
}

var CATEGORIESMODAL_SHOWGLOBAL = false;
var CATEGORIESMODAL_SELECTONLYONE	= false;

//establecer un filtro
function setFilterCat(){
	callNavigateFilter({
		txtName: $('nameFilterCatMdl').value,
		showGlobal : CATEGORIESMODAL_SHOWGLOBAL,
		selectOnlyOne: CATEGORIESMODAL_SELECTONLYONE
	},null,'/apia.modals.CategoriesAction.run','Cat');
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

function showCategoriesModal(retFunction, closeFunction){

	if(CATEGORIESMODAL_HIDE_OVERFLOW) {
		$(document.body).setStyle('overflow', 'hidden');
	}
	
	setFilterCat();
	unSelectAllRows($('tableDataCat'));
	
	var mdlCatContainer = $('mdlCatContainer');
	mdlCatContainer.removeClass('hiddenModal');
	mdlCatContainer.position();
	mdlCatContainer.blockerModal.show();
	mdlCatContainer.setStyle('zIndex', SYS_PANELS.getNewZIndex());
	mdlCatContainer.onModalConfirm = retFunction;
	mdlCatContainer.onModalClose = closeFunction;
}

function closeCategoriesModal(){
	var mdlCatContainer = $('mdlCatContainer');
	
	if(Browser.chrome || Browser.firefox || Browser.safari) {
		var morph = new Fx.Morph(mdlCatContainer, {duration: 200, wait: false});
		
		morph.start({
			'margin-top': '-10px',
			'opacity': 0
		}).chain(function() {
			
			mdlCatContainer.addClass('hiddenModal');
			mdlCatContainer.setStyles({
				'opacity': 1,
				'margin-top': ''
			}); //Limpiar la transicion
						
			mdlCatContainer.blockerModal.hide();
			if (mdlCatContainer.onModalClose) mdlCatContainer.onModalClose();
			
			if(CATEGORIESMODAL_HIDE_OVERFLOW) {
				$(document.body).setStyle('overflow', '');
			}
		});
	} else {
		
		mdlCatContainer.addClass('hiddenModal');
		
		mdlCatContainer.blockerModal.hide();
		if (mdlCatContainer.onModalClose) mdlCatContainer.onModalClose();
		
		if(CATEGORIESMODAL_HIDE_OVERFLOW) {
			$(document.body).setStyle('overflow', '');
		}
	}	
}
