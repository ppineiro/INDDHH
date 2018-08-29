var COLUMNSMODAL_HIDE_OVERFLOW	= true;

function initColMdlPage(){
	var mdlColContainer = $('mdlColContainer');
	if (mdlColContainer.initDone) return;
	mdlColContainer.initDone = true;

	mdlColContainer.blockerModal = new Mask();
		
	['nameFilterColMdl'].each(function(ele) {
		ele = $(ele);
		ele.setFilterCol = setFilterCol;
		ele.oldValue = ele.value;
		ele.addEvent("keyup", function(e) {
			if (this.oldValue == this.value) return;
			if (this.timmer) $clear(this.timmer);
			this.oldValue = this.value;
			this.timmer = this.setFilterCol.delay(200, this);
			
		});		
	});
	
	$('closeModalCol').addEvent("click", function(e) {
		e.stop();
		closeColumnsModal();
	});
	
	$('clearFiltersCol').addEvent("click", function(e) {
		e.stop();
		['nameFilterColMdl'].each(clearFilter);
		$('nameFilterColMdl').setFilterCol();
	});
	
 
	$('confirmModalCol').addEvent("click", function(e) {
		var mdlColContainer = $('mdlColContainer');
		if (mdlColContainer.onModalConfirm){
			SYS_PANELS.showLoading();
			jsCaller(mdlColContainer.onModalConfirm,getSelectedRows($('tableDataCol')));
			if (!mdlColContainer.notCloseActive){
				SYS_PANELS.closeActive();
			}					
		}
		closeColumnsModal();
	});
	
	//Evento doble-click con misma funcionalidad que boton confirmar
	$('tableDataCol').getParent().addEvent("dblclick", function(e) {
		if (mdlColContainer.onModalConfirm) jsCaller(mdlColContainer.onModalConfirm,getSelectedRows($('tableDataCol')));
		closeColumnsModal();
	});
	
	window.sp_Col = new Spinner($('tableDataCol').getParent('table'), {message: WAIT_A_SECOND});
	window.sp_Col.content.getParent().addClass('mdlSpinner');
	
	initNavButtons('/apia.modals.ColumnsAction.run','Col');
}

var COLUMNSMODAL_SHOW_PROC_PARAMS = false;
var COLUMNSMODAL_SHOW_PROC_COLS = false;

//establecer un filtro
function setFilterCol(){
	callNavigateFilter({
		filterName: $('nameFilterColMdl').value,	
		viewName:QRY_DB_VIEW_NAME,
		isProcParams:COLUMNSMODAL_SHOW_PROC_PARAMS,
		isProcCols:COLUMNSMODAL_SHOW_PROC_COLS,
		dbConId:ID
	},null,'/apia.modals.ColumnsAction.run', 'Col');
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
	$('columnsTrOrderBy').getElements(".orderedBy").each(function(item, index){
	    item.removeClass("orderedBy");
	});
	
	$('columnsTrOrderBy').getElements(".sortUp").each(function(item, index){
		if(obj!=item){
			item.removeClass("sortUp");
			item.addClass("unsorted");
		}
	});
	
	$('columnsTrOrderBy').getElements(".sortDown").each(function(item, index){
		if(obj!=item){
			item.removeClass("sortDown");
			item.addClass("unsorted");
		}
	});
}

var returnFunction;
var blocker;

function showColumnsModal(retFunction, closeFunction, notCloseActive){
	
	if(COLUMNSMODAL_HIDE_OVERFLOW) {
		$(document.body).setStyle('overflow', 'hidden');
	}

	setFilterCol();
	unSelectAllRows($('tableDataCol'));
	
	var mdlStaContainer = $('mdlColContainer');
	mdlStaContainer.removeClass('hiddenModal');
	mdlStaContainer.position();
	mdlStaContainer.blockerModal.show();
	mdlStaContainer.setStyle('zIndex', SYS_PANELS.getNewZIndex());
	mdlStaContainer.onModalConfirm = retFunction;
	mdlStaContainer.onModalClose = closeFunction;
	mdlStaContainer.notCloseActive = toBoolean(notCloseActive);
}

function closeColumnsModal(){
	var mdlColContainer = $('mdlColContainer');
	
	if(Browser.chrome || Browser.firefox || Browser.safari) {
		var morph = new Fx.Morph(mdlColContainer, {duration: 200, wait: false});
		
		morph.start({
			'margin-top': '-10px',
			'opacity': 0
		}).chain(function() {
			
			mdlColContainer.addClass('hiddenModal');
			mdlColContainer.setStyles({
				'opacity': 1,
				'margin-top': ''
			}); //Limpiar la transicion
			
			mdlColContainer.blockerModal.hide();
			if (mdlColContainer.onModalClose) mdlColContainer.onModalClose();
			
			if(COLUMNSMODAL_HIDE_OVERFLOW) {
				$(document.body).setStyle('overflow', '');
			}
		});
	} else {
		
		mdlColContainer.addClass('hiddenModal');
		
		mdlColContainer.blockerModal.hide();
		if (mdlColContainer.onModalClose) mdlColContainer.onModalClose();
		
		if(COLUMNSMODAL_HIDE_OVERFLOW) {
			$(document.body).setStyle('overflow', '');
		}
	}
}
