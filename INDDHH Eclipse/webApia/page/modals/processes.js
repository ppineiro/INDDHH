var PROCESSMODAL_HIDE_OVERFLOW	= true;

function initProcMdlPage(){
	var mdlProcContainer = $('mdlProcContainer');
	if (mdlProcContainer.initDone) return;
	mdlProcContainer.initDone = true;

	mdlProcContainer.blockerModal = new Mask();
	
	['orderByNameProcMdl'].each(function(ele){
		ele = $(ele);
		ele.set('title', GNR_ORDER_BY + ele.getAttribute("title"))
	});
	
	['nameFilterProcMdl'].each(function(ele) {
		ele = $(ele);
		ele.setFilterProc = setFilterProc;
		ele.oldValue = ele.value;
		ele.addEvent("keyup", function(e) {
			if (this.oldValue == this.value) return;
			if (this.timmer) $clear(this.timmer);
			this.oldValue = this.value;
			this.timmer = this.setFilterProc.delay(200, this);
			
		});		
	});
	
	$('closeModalProc').addEvent("click", function(e) {
		e.stop();
		closeProcessModal();
	});
	
	$('clearFiltersProc').addEvent("click", function(e) {
		e.stop();
		['nameFilterProcMdl'].each(clearFilter);
		$('nameFilterProcMdl').setFilterProc();
	});
	
 
	$('confirmModalProc').addEvent("click", function(e) {
		var mdlProcContainer = $('mdlProcContainer');
		if (mdlProcContainer.onModalConfirm) jsCaller(mdlProcContainer.onModalConfirm,getSelectedRows($('tableDataProc')));
		closeProcessModal();
	});
	
	//Evento doble-click con misma funcionalidad que boton confirmar
	$('tableDataProc').getParent().addEvent("dblclick", function(e) {
		if (mdlProcContainer.onModalConfirm) jsCaller(mdlProcContainer.onModalConfirm,getSelectedRows($('tableDataProc')));
		closeProcessModal();
	});
	
	//eventos para order
	['orderByNameProcMdl'].each(function(ele){
		$(ele).addEvent("click", function(e) {
			e.stop();
			currentPrefix = 'Proc';
			callNavigateOrder(this.getAttribute('data-sortBy'),this,'/apia.modals.ProcessesAction.run','Proc');
		});
	});
	
	window.sp_Proc = new Spinner($('tableDataProc').getParent('table'), {message: WAIT_A_SECOND});
	window.sp_Proc.content.getParent().addClass('mdlSpinner');
	
	initNavButtons('/apia.modals.ProcessesAction.run','Proc');
}

var PROCESSMODAL_SHOWGLOBAL = false;
var PROCESSMODAL_SELECTONLYONE	= false;
var PROCESSMODAL_IS_SCENARIO	= false;
var PROCESSMODAL_SHOW_ALL = false;
var PROCESSMODAL_ADT_SQL = '';

//establecer un filtro
function setFilterProc(){
	callNavigateFilter({
		txtName: $('nameFilterProcMdl').value,
		showGlobal : PROCESSMODAL_SHOWGLOBAL,
		selectOnlyOne: PROCESSMODAL_SELECTONLYONE,
		isScenario:PROCESSMODAL_IS_SCENARIO,
		showAll:PROCESSMODAL_SHOW_ALL,
		txtAdtSql: PROCESSMODAL_ADT_SQL
	},null,'/apia.modals.ProcessesAction.run','Proc');
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
	$('processTrOrderBy').getElements(".orderedBy").each(function(item, index){
	    item.removeClass("orderedBy");
	});
	
	$('processTrOrderBy').getElements(".sortUp").each(function(item, index){
		if(obj!=item){
			item.removeClass("sortUp");
			item.addClass("unsorted");
		}
	});
	
	$('processTrOrderBy').getElements(".sortDown").each(function(item, index){
		if(obj!=item){
			item.removeClass("sortDown");
			item.addClass("unsorted");
		}
	});
	
}

var returnFunction;
var blocker;

function showProcessModal(retFunction, closeFunction){
	
	if(PROCESSMODAL_HIDE_OVERFLOW) {
		$(document.body).setStyle('overflow', 'hidden');
	}
	
	setFilterProc();
	unSelectAllRows($('tableDataProc'));
	
	var mdlProcContainer = $('mdlProcContainer');
	mdlProcContainer.removeClass('hiddenModal');
	mdlProcContainer.position();
	mdlProcContainer.blockerModal.show();
	mdlProcContainer.setStyle('zIndex', SYS_PANELS.getNewZIndex());
	mdlProcContainer.onModalConfirm = retFunction;
	mdlProcContainer.onModalClose = closeFunction;
}

function closeProcessModal(){
	var mdlProcContainer = $('mdlProcContainer');
	
	if(Browser.chrome || Browser.firefox || Browser.safari) {
		var morph = new Fx.Morph(mdlProcContainer, {duration: 200, wait: false});
		
		morph.start({
			'margin-top': '-10px',
			'opacity': 0
		}).chain(function() {
			
			mdlProcContainer.addClass('hiddenModal');
			mdlProcContainer.setStyles({
				'opacity': 1,
				'margin-top': ''
			}); //Limpiar la transicion
						
			mdlProcContainer.blockerModal.hide();
			if (mdlProcContainer.onModalClose) mdlProcContainer.onModalClose();
			
			if(PROCESSMODAL_HIDE_OVERFLOW) {
				$(document.body).setStyle('overflow', '');
			}
		});
	} else {
		
		mdlProcContainer.addClass('hiddenModal');
		
		mdlProcContainer.blockerModal.hide();
		if (mdlProcContainer.onModalClose) mdlProcContainer.onModalClose();
		
		if(PROCESSMODAL_HIDE_OVERFLOW) {
			$(document.body).setStyle('overflow', '');
		}
	}
	
	
}
