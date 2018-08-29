var ENT_INST_MODAL_HIDE_OVERFLOW	= true;

function initEntInstMdlPage(){
	var mdlEntInstContainer = $('mdlEntInstContainer');
	if (mdlEntInstContainer.initDone) return;
	mdlEntInstContainer.initDone = true;

	mdlEntInstContainer.blockerModal = new Mask();
	
	/*['orderByNameSecMdl'].each(function(ele){
		ele = $(ele);
		ele.tooltip(GNR_ORDER_BY + ele.getAttribute("title"), { mode: 'auto', width: 100, hook: 0 })
	});*/
	
	['nameFilterEntInstMdl'].each(function(ele) {
		ele = $(ele);
		ele.setFilterEntInst = setFilterEntInst;
		ele.oldValue = ele.value;
		ele.addEvent("keyup", function(e) {
			if (this.oldValue == this.value) return;
			if (this.timmer) $clear(this.timmer);
			this.oldValue = this.value;
			this.timmer = this.setFilterEntInst.delay(200, this);
			
		});		
	});
	
	$('closeModalEntInst').addEvent("click", function(e) {
		e.stop();
		closeEntInstModal();
	});
	
	$('confirmModalEntInst').addEvent("click", function(e) {
		var mdlEntInstContainer = $('mdlEntInstContainer');
		if (mdlEntInstContainer.onModalConfirm) jsCaller(mdlEntInstContainer.onModalConfirm,getSelectedRows($('tableDataEntInst')));
		closeEntInstModal();
	});
	
	//Evento doble-click con misma funcionalidad que boton confirmar
	$('tableDataEntInst').getParent().addEvent("dblclick", function(e) {
		if (mdlEntInstContainer.onModalConfirm) jsCaller(mdlEntInstContainer.onModalConfirm,getSelectedRows($('tableDataEntInst')));
		closeEntInstModal();
	});
	
		
	$$("div.button").each(function(ele){
		ele.addEvent("mouseover", function(evt) {this.toggleClass("buttonHover")});
		ele.addEvent("mouseout", function(evt) {this.toggleClass("buttonHover")});
	});
	
	
	initNavButtons('/apia.modals.EntInstanceAction.run','EntInst');
}

//establecer un filtro
function setFilterEntInst(){
	callNavigateFilter({
		entName: $('nameFilterEntInstMdl').value,
		showGlobal : false,
		selectOnlyOne: true
	},null,'/apia.modals.EntInstanceAction.run');
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

function showEntInstModal(retFunction, closeFunction){
	
	if(ENT_INST_MODAL_HIDE_OVERFLOW) {
		$(document.body).setStyle('overflow', 'hidden');
	}
	
	setFilterEntInst();
	unSelectAllRows($('tableDataEntInst'));
	
	var mdlEntInstContainer = $('mdlEntInstContainer');
	mdlEntInstContainer.removeClass('hiddenModal');
	mdlEntInstContainer.position();
	//mdlEntInstContainer.blockerModal.show();
	mdlEntInstContainer.setStyle('zIndex', SYS_PANELS.getNewZIndex());
	mdlEntInstContainer.onModalConfirm = retFunction;
	mdlEntInstContainer.onModalClose = closeFunction;
}

function closeEntInstModal(){
	var mdlEntInstContainer = $('mdlEntInstContainer');
	
	if(Browser.chrome || Browser.firefox || Browser.safari) {
		var morph = new Fx.Morph(mdlEntInstContainer, {duration: 200, wait: false});
		
		morph.start({
			'margin-top': '-10px',
			'opacity': 0
		}).chain(function() {
			
			mdlEntInstContainer.addClass('hiddenModal');
			mdlEntInstContainer.setStyles({
				'opacity': 1,
				'margin-top': ''
			}); //Limpiar la transicion
						
			mdlEntInstContainer.blockerModal.hide();
			if (mdlEntInstContainer.onModalClose) mdlEntInstContainer.onModalClose();
			
			if(ENT_INST_MODAL_HIDE_OVERFLOW) {
				$(document.body).setStyle('overflow', '');
			}
		});
	} else {
		
		mdlEntInstContainer.addClass('hiddenModal');
		
		mdlEntInstContainer.blockerModal.hide();
		if (mdlEntInstContainer.onModalClose) mdlEntInstContainer.onModalClose();
		
		if(ENT_INST_MODAL_HIDE_OVERFLOW) {
			$(document.body).setStyle('overflow', '');
		}
	}
}
