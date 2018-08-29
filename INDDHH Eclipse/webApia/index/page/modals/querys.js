var QUERY_MODAL_HIDE_OVERFLOW	= true;

function initQueryMdlPage(){
	var mdlQueryContainer = $('mdlQueryContainer');
	if (mdlQueryContainer.initDone) return;
	mdlQueryContainer.initDone = true;

	mdlQueryContainer.blockerModal = new Mask();
		
	['nameFilterQueryMdl'].each(function(ele) {
		ele = $(ele);
		ele.setFilterQuery = setFilterQuery;
		ele.oldValue = ele.value;
		ele.addEvent("keyup", function(e) {
			if (this.oldValue == this.value) return;
			if (this.timmer) $clear(this.timmer);
			this.oldValue = this.value;
			this.timmer = this.setFilterQuery.delay(200, this);
			
		});		
	});
	
	$('closeModalQry').addEvent("click", function(e) {
		e.stop();
		closeQueryModal();
	});
	
	$('clearFiltersQry').addEvent("click", function(e) {
		e.stop();
		['nameFilterQueryMdl'].each(clearFilter);
		$('nameFilterQueryMdl').setFilterQuery();
	});
 
	$('confirmModalQry').addEvent("click", function(e) {
		var mdlQueryContainer = $('mdlQueryContainer');
		if (mdlQueryContainer.onModalConfirm) jsCaller(mdlQueryContainer.onModalConfirm,getSelectedRows($('tableDataQry')));
		closeQueryModal();
	});	
	
	//Evento doble-click con misma funcionalidad que boton confirmar
	$('tableDataQry').getParent().addEvent("dblclick", function(e) {
		if (mdlQueryContainer.onModalConfirm) jsCaller(mdlQueryContainer.onModalConfirm,getSelectedRows($('tableDataQry')));
		closeQueryModal();
	});
	
	window.sp_Qry = new Spinner($('tableDataQry'), {message: WAIT_A_SECOND});
	window.sp_Qry.content.getParent().addClass('mdlSpinner');
	
	initNavButtons('/apia.modals.QueryAction.run','Qry');
}

var STATUSMODAL_SHOWGLOBAL = false;
var STATUSMODAL_SELECTONLYONE	= false;

//establecer un filtro
function setFilterQuery(){
	callNavigateFilter({
		txtName: $('nameFilterQueryMdl').value,
		showGlobal : STATUSMODAL_SHOWGLOBAL,
		selectOnlyOne: STATUSMODAL_SELECTONLYONE
	},null,'/apia.modals.QueryAction.run','Qry');
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

function showQueryModal(retFunction, closeFunction){
	
	if(QUERY_MODAL_HIDE_OVERFLOW) {
		$(document.body).setStyle('overflow', 'hidden');
	}
	
	setFilterQuery();
	unSelectAllRows($('tableDataQry'));
	
	var mdlQueryContainer = $('mdlQueryContainer');
	mdlQueryContainer.removeClass('hiddenModal');
	mdlQueryContainer.position();
	mdlQueryContainer.blockerModal.show();
	mdlQueryContainer.setStyle('zIndex', SYS_PANELS.getNewZIndex());
	mdlQueryContainer.onModalConfirm = retFunction;
	mdlQueryContainer.onModalClose = closeFunction;
}

function closeQueryModal(){
	var mdlQueryContainer = $('mdlQueryContainer');
	
	if(Browser.chrome || Browser.firefox || Browser.safari) {
		var morph = new Fx.Morph(mdlQueryContainer, {duration: 200, wait: false});
		
		morph.start({
			'margin-top': '-10px',
			'opacity': 0
		}).chain(function() {
			
			mdlQueryContainer.addClass('hiddenModal');
			mdlQueryContainer.setStyles({
				'opacity': 1,
				'margin-top': ''
			}); //Limpiar la transicion
						
			mdlQueryContainer.blockerModal.hide();
			if (mdlQueryContainer.onModalClose) mdlQueryContainer.onModalClose();
			
			if(QUERY_MODAL_HIDE_OVERFLOW) {
				$(document.body).setStyle('overflow', '');
			}
		});
	} else {
		
		mdlQueryContainer.addClass('hiddenModal');
		
		mdlQueryContainer.blockerModal.hide();
		if (mdlQueryContainer.onModalClose) mdlQueryContainer.onModalClose();
		
		if(QUERY_MODAL_HIDE_OVERFLOW) {
			$(document.body).setStyle('overflow', '');
		}
	}
	
}
