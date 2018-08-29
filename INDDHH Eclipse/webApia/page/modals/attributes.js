var ATTRIBUTEMODAL_HIDE_OVERFLOW	= true;

function initAttMdlPage(){
	var mdlAttContainer = $('mdlAttContainer');
	if (mdlAttContainer.initDone) return;
	mdlAttContainer.initDone = true;

	mdlAttContainer.blockerModal = new Mask();
	
	['orderByNameAttMdl'].each(function(ele){
		ele = $(ele);
		ele.set('title', GNR_ORDER_BY + ele.get("name"))
	});
	
	['nameFilterAttMdl'].each(function(ele) {
		ele = $(ele);
		ele.setFilterAtt = setFilterAtt;
		ele.oldValue = ele.value;
		ele.addEvent("keyup", function(e) {
			if (this.oldValue == this.value) return;
			if (this.timmer) $clear(this.timmer);
			this.oldValue = this.value;
			this.timmer = this.setFilterAtt.delay(200, this);
		});		
	});
	
	$('closeModalAtt').addEvent("click", function(e) {
		e.stop();
		closeAttributesModal();
	});
	
	$('clearFiltersAtt').addEvent("click", function(e) {
		e.stop();
		['nameFilterAttMdl'].each(clearFilter);
		$('nameFilterAttMdl').setFilterAtt();
	});
	
	$('confirmModalAtt').addEvent("click", function(e) {
		var mdlAttContainer = $('mdlAttContainer');
		if (mdlAttContainer.onModalConfirm) jsCaller(mdlAttContainer.onModalConfirm,getSelectedRows($('tableDataAtt')));
		closeAttributesModal();
	});
	
	//Evento doble-click con misma funcionalidad que boton confirmar
	$('tableDataAtt').getParent().addEvent("dblclick", function(e) {
		if (mdlAttContainer.onModalConfirm) jsCaller(mdlAttContainer.onModalConfirm,getSelectedRows($('tableDataAtt')));
		closeAttributesModal();
	});
	
	//eventos para order
	['orderByNameAttMdl'].each(function(ele){
		$(ele).addEvent("click", function(e) {
			e.stop();
			callNavigateOrder(this.getAttribute('data-sortBy'),this,'/apia.modals.AttributesAction.run','Att');
		});
	});
	
	window.sp_Att = new Spinner($('tableDataAtt').getParent('table'), {message: WAIT_A_SECOND});
	window.sp_Att.content.getParent().addClass('mdlSpinner');
	
	initNavButtons('/apia.modals.AttributesAction.run','Att');
}


var ATTRIBUTEMODAL_SELECTONLYONE	= false;

//establecer un filtro
function setFilterAtt(){
	currentPrefix = 'Att';
	callNavigateFilter({
		txtName: $('nameFilterAttMdl').value,
		selectOnlyOne: ATTRIBUTEMODAL_SELECTONLYONE
	},null,'/apia.modals.AttributesAction.run','Att');
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
	$('attributesTrOrderBy').getElements(".orderedBy").each(function(item, index){
	    item.removeClass("orderedBy");
	});
	
	$('attributesTrOrderBy').getElements(".sortUp").each(function(item, index){
		if(obj!=item){
			item.removeClass("sortUp");
			item.addClass("unsorted");
		}
	});
	
	$('attributesTrOrderBy').getElements(".sortDown").each(function(item, index){
		if(obj!=item){
			item.removeClass("sortDown");
			item.addClass("unsorted");
		}
	});
}

function showAttributesModal(retFunction, closeFunction, valueToShow){
	
	if(ATTRIBUTEMODAL_HIDE_OVERFLOW) {
		$(document.body).setStyle('overflow', 'hidden');
	}
	
	if (!valueToShow || valueToShow == null || valueToShow == "undefined")
		valueToShow = "";
	
	$('nameFilterAttMdl').set('value', valueToShow);
	
	setFilterAtt();
   
    unSelectAllRows($('tableDataAtt'));
	
	var mdlAttContainer = $('mdlAttContainer');
	mdlAttContainer.removeClass('hiddenModal');
	mdlAttContainer.position();
	mdlAttContainer.blockerModal.show();
	mdlAttContainer.setStyle('zIndex', SYS_PANELS.getNewZIndex());
	mdlAttContainer.onModalConfirm = retFunction;
	mdlAttContainer.onModalClose = closeFunction;
}

function closeAttributesModal(){
    var mdlAttContainer = $('mdlAttContainer');	
	
	if(Browser.chrome || Browser.firefox || Browser.safari) {
		var morph = new Fx.Morph(mdlAttContainer, {duration: 200, wait: false});
		
		morph.start({
			'margin-top': '-10px',
			'opacity': 0
		}).chain(function() {
			
			mdlAttContainer.addClass('hiddenModal');
			mdlAttContainer.setStyles({
				'opacity': 1,
				'margin-top': ''
			}); //Limpiar la transicion
						
		    mdlAttContainer.blockerModal.hide();
			if (mdlAttContainer.onModalClose) mdlAttContainer.onModalClose();
			
			if(ATTRIBUTEMODAL_HIDE_OVERFLOW) {
				$(document.body).setStyle('overflow', '');
			}
		});
	} else {
		
		mdlAttContainer.addClass('hiddenModal');
		
		mdlAttContainer.blockerModal.hide();
		if (mdlAttContainer.onModalClose) mdlAttContainer.onModalClose();
		
		if(ATTRIBUTEMODAL_HIDE_OVERFLOW) {
			$(document.body).setStyle('overflow', '');
		}
	}
}