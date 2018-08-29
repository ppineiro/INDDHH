var LANGUAGEMODAL_HIDE_OVERFLOW	= true;

function initLangMdlPage(){
	var mdlLangContainer = $('mdlLangContainer');
	if (mdlLangContainer.initDone) return;
	mdlLangContainer.initDone = true;

	mdlLangContainer.blockerModal = new Mask();
	
	['orderByNameLangMdl'].each(function(ele) {
		ele = $(ele);
		ele.tooltip(GNR_ORDER_BY + ele.get("title"), { mode: 'auto', width: 100, hook: 0 })
	});
	
	['nameFilterLangMdl'].each(function(ele) {
		ele = $(ele);
		ele.setFilterLang = setFilterLang;
		ele.oldValue = ele.value;
		ele.addEvent("keyup", function(e) {
			if (this.oldValue == this.value) return;
			if (this.timmer) $clear(this.timmer);
			this.oldValue = this.value;
			this.timmer = this.setFilterSta.delay(200, this);
		});
	});
	
	$('closeModalLang').addEvent("click", function(e) {
		e.stop();
		closeLanguageModal();
	});
	
	$('clearFiltersLang').addEvent("click", function(e) {
		e.stop();
		['nameFilterLangMdl'].each(clearFilter);
		$('nameFilterLangMdl').setFilterLang();
	});
	
 
	$('confirmModalLang').addEvent("click", function(e) {
		var mdlLangContainer = $('mdlLangContainer');
		if (mdlLangContainer.onModalConfirm) jsCaller(mdlLangContainer.onModalConfirm, getSelectedRows($('tableDataLang')));
		closeLanguageModal();
	});
	
	//Evento doble-click con misma funcionalidad que boton confirmar	
	$('tableDataLang').getParent().addEvent("dblclick", function(e) {
		if (mdlLangContainer.onModalConfirm) jsCaller(mdlLangContainer.onModalConfirm,getSelectedRows($('tableDataLang')));
		closeLanguageModal();
	});
	
	//eventos para order
	['orderByNameLangMdl'].each(function(ele) {
		$(ele).addEvent("click", function(e) {
			e.stop();
			currentPrefix = 'Lang';
			callNavigateOrder(this.get('sortBy'), this, '/apia.modals.LanguageAction.run', 'Lang');
		});
	});
	
	window.sp_Lang = new Spinner($('tableDataLang'), {message: WAIT_A_SECOND});
	window.sp_Lang.content.getParent().addClass('mdlSpinner');
	
	initNavButtons('/apia.modals.LanguageAction.run','Lang');
}

var LANGUAGEMODAL_SELECTONLYONE	= false;

//establecer un filtro
function setFilterLang(){
	callNavigateFilter({
		txtName: $('nameFilterLangMdl').value,
		selectOnlyOne: LANGUAGEMODAL_SELECTONLYONE
	},null,'/apia.modals.LanguageAction.run','Lang');
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
	
	$('trOrderBy').getElements(".sortDown").each(function(item, index) {
		if(obj!=item){
			item.removeClass("sortDown");
			item.addClass("unsorted");
		}
	});
	
}

var returnFunction;
var blocker;

function showLanguageModal(retFunction, closeFunction) {
	
	if(LANGUAGEMODAL_HIDE_OVERFLOW) {
		$(document.body).setStyle('overflow', 'hidden');
	}
	
	setFilterLang();
	unSelectAllRows($('tableDataLang'));
	
	var mdlLangContainer = $('mdlLangContainer');
	mdlLangContainer.removeClass('hiddenModal');
	mdlLangContainer.position();
	mdlLangContainer.blockerModal.show();
	mdlLangContainer.setStyle('zIndex', SYS_PANELS.getNewZIndex());
	mdlLangContainer.onModalConfirm = retFunction;
	mdlLangContainer.onModalClose = closeFunction;
}

function closeLanguageModal(){
	var mdlLangContainer = $('mdlLangContainer');
	
	if(Browser.chrome || Browser.firefox || Browser.safari) {
		var morph = new Fx.Morph(mdlLangContainer, {duration: 200, wait: false});
		
		morph.start({
			'margin-top': '-10px',
			'opacity': 0
		}).chain(function() {
			
			mdlLangContainer.addClass('hiddenModal');
			mdlLangContainer.setStyles({
				'opacity': 1,
				'margin-top': ''
			}); //Limpiar la transicion
						
			mdlLangContainer.blockerModal.hide();
			if (mdlLangContainer.onModalClose) mdlLangContainer.onModalClose();
			
			if(LANGUAGEMODAL_HIDE_OVERFLOW) {
				$(document.body).setStyle('overflow', '');
			}
		});
	} else {
		
		mdlLangContainer.addClass('hiddenModal');
		
		mdlLangContainer.blockerModal.hide();
		if (mdlLangContainer.onModalClose) mdlLangContainer.onModalClose();
		
		if(LANGUAGEMODAL_HIDE_OVERFLOW) {
			$(document.body).setStyle('overflow', '');
		}
	}
	
	
}
