
function initStyMdlPage(){
	var mdlStyContainer = $('mdlStyContainer');
	if (mdlStyContainer.initDone) return;
	mdlStyContainer.initDone = true;

	mdlStyContainer.blockerModal = new Mask();
	
	['orderByNameStyMdl'].each(function(ele){
		ele = $(ele);
		ele.set('title', GNR_ORDER_BY + ele.getAttribute("title"))
	});
	
	['nameFilterStyMdl'].each(function(ele) {
		ele = $(ele);
		ele.setFilterSty = setFilterSty;
		ele.oldValue = ele.value;
		ele.addEvent("keyup", function(e) {
			if (this.oldValue == this.value) return;
			if (this.timmer) $clear(this.timmer);
			this.oldValue = this.value;
			this.timmer = this.setFilterSty.delay(200, this);
			
		});		
	});
	
	$('closeModalSty').addEvent("click", function(e) {
		e.stop();
		closeStylesModal();
	});
	
	$('clearFiltersSty').addEvent("click", function(e) {
		e.stop();
		['nameFilterStyMdl'].each(clearFilter);
		$('nameFilterStyMdl').setFilterSty();
	});
	
 
	$('confirmModalSty').addEvent("click", function(e) {
		var mdlStyContainer = $('mdlStyContainer');
		if (mdlStyContainer.onModalConfirm) jsCaller(mdlStyContainer.onModalConfirm,getSelectedRows($('tableDataSty')));
		closeStylesModal();
	});
	
	//Evento doble-click con misma funcionalidad que boton confirmar
	$('tableDataSty').getParent().addEvent("dblclick", function(e) {
		if (mdlStyContainer.onModalConfirm) jsCaller(mdlStyContainer.onModalConfirm,getSelectedRows($('tableDataSty')));
		closeStylesModal();
	});
	
	//eventos para order
	['orderByNameStyMdl'].each(function(ele){
		$(ele).addEvent("click", function(e) {
			e.stop();
			currentPrefix = 'Sty';
			callNavigateOrder(this.getAttribute('data-sortBy'),this,'/apia.modals.StylesAction.run','Sty');
		});
	});
	
	window.sp_Sty = new Spinner($('tableDataSty').getParent('table'), {message: WAIT_A_SECOND});
	window.sp_Sty.content.getParent().addClass('mdlSpinner');
	
	initNavButtons('/apia.modals.StylesAction.run','Sty');
}


//establecer un filtro
function setFilterSty(){
	callNavigateFilter({
		txtName: $('nameFilterStyMdl').value,
		selectOnlyOne: false
	},null,'/apia.modals.StylesAction.run','Sty');
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
	$('stylesTrOrderBy').getElements(".orderedBy").each(function(item, index){
	    item.removeClass("orderedBy");
	});
	
	$('stylesTrOrderBy').getElements(".sortUp").each(function(item, index){
		if(obj!=item){
			item.removeClass("sortUp");
			item.addClass("unsorted");
		}
	});
	
	$('stylesTrOrderBy').getElements(".sortDown").each(function(item, index){
		if(obj!=item){
			item.removeClass("sortDown");
			item.addClass("unsorted");
		}
	});
	
}

var returnFunction;
var blocker;

function showStylesModal(retFunction, closeFunction){
	
	
	setFilterSty();
	unSelectAllRows($('tableDataSty'));
	
	var mdlStyContainer = $('mdlStyContainer');
	mdlStyContainer.removeClass('hiddenModal');
	mdlStyContainer.position();
	mdlStyContainer.blockerModal.show();
	mdlStyContainer.setStyle('zIndex', SYS_PANELS.getNewZIndex());
	mdlStyContainer.onModalConfirm = retFunction;
	mdlStyContainer.onModalClose = closeFunction;
}

function closeStylesModal(){
	var mdlStyContainer = $('mdlStyContainer');
	
	if(Browser.chrome || Browser.firefox || Browser.safari) {
		var morph = new Fx.Morph(mdlStyContainer, {duration: 200, wait: false});
		
		morph.start({
			'margin-top': '-10px',
			'opacity': 0
		}).chain(function() {
			
			mdlStyContainer.addClass('hiddenModal');
			mdlStyContainer.setStyles({
				'opacity': 1,
				'margin-top': ''
			}); //Limpiar la transicion
						
			mdlStyContainer.blockerModal.hide();
			if (mdlStyContainer.onModalClose) mdlStyContainer.onModalClose();			
			
		});
	} else {
		
		mdlStyContainer.addClass('hiddenModal');
		
		mdlStyContainer.blockerModal.hide();
		if (mdlStyContainer.onModalClose) mdlStyContainer.onModalClose();
		
	}
}
