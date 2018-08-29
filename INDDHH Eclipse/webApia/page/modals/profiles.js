var PROFILEMODAL_HIDE_OVERFLOW	= true;

function initPrfMdlPage(){
	var mdlPrfContainer = $('mdlPrfContainer');
	if (mdlPrfContainer.initDone) return;
	mdlPrfContainer.initDone = true;

	mdlPrfContainer.blockerModal = new Mask();
	
	['orderByNamePrfMdl','orderByDescPrfMdl'].each(function(ele){
		ele = $(ele);
		ele.set('title', GNR_ORDER_BY + ele.getAttribute("title"))
	});
	
	['nameFilterPrfMdl','descFilterPrfMdl'].each(function(ele) {
		ele = $(ele);
		ele.setFilterPrf = setFilterPrf;
		ele.oldValue = ele.value;
		ele.addEvent("keyup", function(e) {
			if (this.oldValue == this.value) return;
			if (this.timmer) $clear(this.timmer);
			this.oldValue = this.value;
			this.timmer = this.setFilterPrf.delay(200, this);
			
		});		
	});
	
	$('closeModalPrf').addEvent("click", function(e) {
		e.stop();
		closeProfilesModal();
	});
	
	$('clearFiltersPrf').addEvent("click", function(e) {
		e.stop();
		['nameFilterPrfMdl'].each(clearFilter);
		$('descFilterPrfMdl').value="";
		
		$('nameFilterPrfMdl').setFilterPrf();
	});
	
 
	$('confirmModalPrf').addEvent("click", function(e) {
		var mdlPrfContainer = $('mdlPrfContainer');
		if (mdlPrfContainer.onModalConfirm) jsCaller(mdlPrfContainer.onModalConfirm,getSelectedRows($('tableDataPrf')));
		closeProfilesModal();
	});
	
	//Evento doble-click con misma funcionalidad que boton confirmar
	$('tableDataPrf').getParent().addEvent("dblclick", function(e) {
		if (mdlPrfContainer.onModalConfirm) jsCaller(mdlPrfContainer.onModalConfirm,getSelectedRows($('tableDataPrf')));
		closeProfilesModal();
	});
	
	//eventos para order
	['orderByNamePrfMdl','orderByDescPrfMdl'].each(function(ele){
		$(ele).addEvent("click", function(e) {
			e.stop();
			currentPrefix = 'Prf';
			callNavigateOrder(this.getAttribute('data-sortBy'),this,'/apia.modals.ProfilesAction.run','Prf');
		});
	});
	
	window.sp_Prf = new Spinner($('tableDataPrf').getParent('table'), {message: WAIT_A_SECOND});
	window.sp_Prf.content.getParent().addClass('mdlSpinner');
	
	initNavButtons('/apia.modals.ProfilesAction.run','Prf');
}

var PROFILEMODAL_SHOWGLOBAL = false;
var PROFILEMODAL_FROMENVS = "";
var PROFILEMODAL_SELECTONLYONE	= false;
var PROFILEMODAL_USERID = "";

//establecer un filtro
function setFilterPrf(){
	callNavigateFilter({
		txtName: $('nameFilterPrfMdl').value,
		txtDesc: $('descFilterPrfMdl').value,
		showGlobal : PROFILEMODAL_SHOWGLOBAL,
		fromEnvs : PROFILEMODAL_FROMENVS,
		selectOnlyOne: PROFILEMODAL_SELECTONLYONE,
		userId: PROFILEMODAL_USERID
	},null,'/apia.modals.ProfilesAction.run','Prf');
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
	$('profilesTrOrderBy').getElements(".orderedBy").each(function(item, index){
	    item.removeClass("orderedBy");
	});
	
	$('profilesTrOrderBy').getElements(".sortUp").each(function(item, index){
		if(obj!=item){
			item.removeClass("sortUp");
			item.addClass("unsorted");
		}
	});
	
	$('profilesTrOrderBy').getElements(".sortDown").each(function(item, index){
		if(obj!=item){
			item.removeClass("sortDown");
			item.addClass("unsorted");
		}
	});
	
}

var returnFunction;
var blocker;

function showProfilesModal(retFunction, closeFunction){
	
	if(PROFILEMODAL_HIDE_OVERFLOW) {
		$(document.body).setStyle('overflow', 'hidden');
	}
	
	setFilterPrf();
	unSelectAllRows($('tableDataPrf'));
	
	var mdlPrfContainer = $('mdlPrfContainer');
	mdlPrfContainer.removeClass('hiddenModal');
	mdlPrfContainer.position();
	mdlPrfContainer.blockerModal.show();
	mdlPrfContainer.setStyle('zIndex', SYS_PANELS.getNewZIndex());
	mdlPrfContainer.onModalConfirm = retFunction;
	mdlPrfContainer.onModalClose = closeFunction;
}

function closeProfilesModal(){
	var mdlPrfContainer = $('mdlPrfContainer');
	
	if(Browser.chrome || Browser.firefox || Browser.safari) {
		var morph = new Fx.Morph(mdlPrfContainer, {duration: 200, wait: false});
		
		morph.start({
			'margin-top': '-10px',
			'opacity': 0
		}).chain(function() {
			
			mdlPrfContainer.addClass('hiddenModal');
			mdlPrfContainer.setStyles({
				'opacity': 1,
				'margin-top': ''
			}); //Limpiar la transicion
						
			mdlPrfContainer.blockerModal.hide();
			if (mdlPrfContainer.onModalClose) mdlPrfContainer.onModalClose();
			
			if(PROFILEMODAL_HIDE_OVERFLOW) {
				$(document.body).setStyle('overflow', '');
			}
		});
	} else {
		
		mdlPrfContainer.addClass('hiddenModal');
		
		mdlPrfContainer.blockerModal.hide();
		if (mdlPrfContainer.onModalClose) mdlPrfContainer.onModalClose();
		
		if(PROFILEMODAL_HIDE_OVERFLOW) {
			$(document.body).setStyle('overflow', '');
		}
	}
}
