var FNCMODAL_HIDE_OVERFLOW	= true;

function initFncMdlPage(){
	var mdlFncsContainer = $('mdlFncsContainer');
	if (mdlFncsContainer.initDone) return;
	mdlFncsContainer.initDone = true;

	mdlFncsContainer.blockerModal = new Mask();
	
	['orderByFncFolderMdl','orderByFncNameMdl'].each(setAdmListTitle);	
	['folderFilterFncMdl','nameFilterFncMdl'].each(function(ele) {
		ele = $(ele);
		ele.setFilterFnc = setFilterFnc;
		ele.oldValue = ele.value;
		ele.addEvent("keyup", function(e) {
			if (this.oldValue == this.value) return;
			if (this.timmer) $clear(this.timmer);
			this.oldValue = this.value;
			this.timmer = this.setFilterFnc.delay(200, this);
		});		
	}); 
	
	
	$('closeModalFnc').addEvent("click", function(e) {
		e.stop();
		closeFncsModal();
	});
	
	$('clearFiltersFnc').addEvent("click", function(e) {
		e.stop();
		['folderFilterFncMdl','nameFilterFncMdl'].each(clearFilter);
		$('folderFilterFncMdl').setFilterFnc();
	});
	
	$('confirmModalFnc').addEvent("click", function(e) {
		var mdlFncsContainer = $('mdlFncsContainer');
		if (mdlFncsContainer.onModalConfirm) jsCaller(mdlFncsContainer.onModalConfirm,getSelectedRows($('tableDataFnc')));
		closeFncsModal();
	});
	
	//Evento doble-click con misma funcionalidad que boton confirmar
	$('tableDataFnc').getParent().addEvent("dblclick", function(e) {
		if (mdlFncsContainer.onModalConfirm) jsCaller(mdlFncsContainer.onModalConfirm,getSelectedRows($('tableDataFnc')));
		closeFncsModal();
	});
	
	//eventos para order
	['orderByFncFolderMdl','orderByFncNameMdl'].each(function(ele){
		$(ele).addEvent("click", function(e) {
			e.stop();
			callNavigateOrder(this.getAttribute('sortBy'),this, '/apia.modals.FunctionalitiesAction.run','Fnc');
		});
	});
	
	window.sp_Fnc = new Spinner($('tableDataFnc'), {message: WAIT_A_SECOND});
	window.sp_Fnc.content.getParent().addClass('mdlSpinner');
	
	initNavButtons('/apia.modals.FunctionalitiesAction.run','Fnc');
}

var FNCMODAL_SELECTONLYONE	= false;
var FNCS_ENVIRONMENT = null;
var FNCS_EXCLUDED = "";

//establecer un filtro
function setFilterFnc(){
	callNavigateFilter({
		txtFncFolder: $('folderFilterFncMdl').value,
		txtFncName: $('nameFilterFncMdl').value,
		selectOnlyOne: FNCMODAL_SELECTONLYONE,
		txtEnvId: FNCS_ENVIRONMENT,
		txtExcludesId: FNCS_EXCLUDED
	},null,'/apia.modals.FunctionalitiesAction.run','Fnc');
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

function showFncsModal(retFunction, closeFunction){
	
	if(FNCMODAL_HIDE_OVERFLOW) {
		$(document.body).setStyle('overflow', 'hidden');
	}
	
	setFilterFnc();
	unSelectAllRows($('tableDataFnc'));

	var mdlFncsContainer = $('mdlFncsContainer');
	mdlFncsContainer.removeClass('hiddenModal');
	mdlFncsContainer.position();
	mdlFncsContainer.blockerModal.show();
	mdlFncsContainer.setStyle('zIndex', SYS_PANELS.getNewZIndex());
	mdlFncsContainer.onModalConfirm = retFunction;
	mdlFncsContainer.onModalClose = closeFunction;
}

function closeFncsModal(){
	var mdlFncsContainer = $('mdlFncsContainer');
	
	if(Browser.chrome || Browser.firefox || Browser.safari) {
		var morph = new Fx.Morph(mdlFncsContainer, {duration: 200, wait: false});
		
		morph.start({
			'margin-top': '-10px',
			'opacity': 0
		}).chain(function() {
			
			mdlFncsContainer.addClass('hiddenModal');
			mdlFncsContainer.setStyles({
				'opacity': 1,
				'margin-top': ''
			}); //Limpiar la transicion
						
			mdlFncsContainer.blockerModal.hide();
			if (mdlFncsContainer.onModalClose) mdlFncsContainer.onModalClose();
			
			if(FNCMODAL_HIDE_OVERFLOW) {
				$(document.body).setStyle('overflow', '');
			}
		});
	} else {
		
		mdlFncsContainer.addClass('hiddenModal');
		
		mdlFncsContainer.blockerModal.hide();
		if (mdlFncsContainer.onModalClose) mdlFncsContainer.onModalClose();
		
		if(FNCMODAL_HIDE_OVERFLOW) {
			$(document.body).setStyle('overflow', '');
		}
	}
}
