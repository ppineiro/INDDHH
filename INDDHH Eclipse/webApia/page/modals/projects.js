var PRJMODAL_HIDE_OVERFLOW	= true;

function initPrjMdlPage(){
	var mdlPrjContainer = $('mdlPrjContainer');
	if (mdlPrjContainer.initDone) return;
	mdlPrjContainer.initDone = true;

	mdlPrjContainer.blockerModal = new Mask();
	
	['orderByNamePrjMdl'].each(function(ele){
		ele = $(ele);
		ele.set('title', GNR_ORDER_BY + ele.getAttribute("title"))
	});
	
	['nameFilterPrjMdl'].each(function(ele) {
		ele = $(ele);
		ele.setFilterPrj = setFilterPrj;
		ele.oldValue = ele.value;
		ele.addEvent("keyup", function(e) {
			if (this.oldValue == this.value) return;
			if (this.timmer) $clear(this.timmer);
			this.oldValue = this.value;
			this.timmer = this.setFilterPrj.delay(200, this);
			
		});		
	});
	
	$('closeModalPrj').addEvent("click", function(e) {
		e.stop();
		closeProjectModal();
	});
	
	$('clearFiltersPrj').addEvent("click", function(e) {
		e.stop();
		['nameFilterPrjMdl'].each(clearFilter);
		$('nameFilterPrjMdl').setFilterPrj();
	});
	
 
	$('confirmModalPrj').addEvent("click", function(e) {
		var mdlPrjContainer = $('mdlPrjContainer');
		if (mdlPrjContainer.onModalConfirm) jsCaller(mdlPrjContainer.onModalConfirm,getSelectedRows($('tableDataPrj')));
		closeProjectModal();
	});
	
	//Evento doble-click con misma funcionalidad que boton confirmar
	$('tableDataPrj').getParent().addEvent("dblclick", function(e) {
		if (mdlPrjContainer.onModalConfirm) jsCaller(mdlPrjContainer.onModalConfirm,getSelectedRows($('tableDataPrj')));
		closeProjectModal();
	});
	
	//eventos para order
	['orderByNamePrjMdl'].each(function(ele){
		$(ele).addEvent("click", function(e) {
			e.stop();
			currentPrefix = 'Prj';
			callNavigateOrder(this.getAttribute('data-sortBy'),this,'/apia.modals.ProjectsAction.run','Prj');
		});
	});
	
	window.sp_Prj = new Spinner($('tableDataPrj').getParent('table'), {message: WAIT_A_SECOND});
	window.sp_Prj.content.getParent().addClass('mdlSpinner');
	
	initNavButtons('/apia.modals.ProjectsAction.run','Prj');
}

//var PROCESSMODAL_SHOWGLOBAL = false;
//var PROCESSMODAL_SELECTONLYONE	= false;
//var PROCESSMODAL_IS_SCENARIO	= false;

//establecer un filtro
function setFilterPrj(){
	callNavigateFilter({
		txtName: $('nameFilterPrjMdl').value
	},null,'/apia.modals.ProjectsAction.run','Prj');
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
	$('projectsTrOrderBy').getElements(".orderedBy").each(function(item, index){
	    item.removeClass("orderedBy");
	});
	
	$('projectsTrOrderBy').getElements(".sortUp").each(function(item, index){
		if(obj!=item){
			item.removeClass("sortUp");
			item.addClass("unsorted");
		}
	});
	
	$('projectsTrOrderBy').getElements(".sortDown").each(function(item, index){
		if(obj!=item){
			item.removeClass("sortDown");
			item.addClass("unsorted");
		}
	});
	
}

var returnFunction;
var blocker;

function showProjectModal(retFunction, closeFunction){
	
	if(PRJMODAL_HIDE_OVERFLOW) {
		$(document.body).setStyle('overflow', 'hidden');
	}
	
	setFilterPrj();
	unSelectAllRows($('tableDataPrj'));
	
	var mdlPrjContainer = $('mdlPrjContainer');
	mdlPrjContainer.removeClass('hiddenModal');
	mdlPrjContainer.position();
	mdlPrjContainer.blockerModal.show();
	mdlPrjContainer.setStyle('zIndex', SYS_PANELS.getNewZIndex());
	mdlPrjContainer.onModalConfirm = retFunction;
	mdlPrjContainer.onModalClose = closeFunction;
}

function closeProjectModal(){
	var mdlPrjContainer = $('mdlPrjContainer');
	
	if(Browser.chrome || Browser.firefox || Browser.safari) {
		var morph = new Fx.Morph(mdlPrjContainer, {duration: 200, wait: false});
		
		morph.start({
			'margin-top': '-10px',
			'opacity': 0
		}).chain(function() {
			
			mdlPrjContainer.addClass('hiddenModal');
			mdlPrjContainer.setStyles({
				'opacity': 1,
				'margin-top': ''
			}); //Limpiar la transicion
						
			mdlPrjContainer.blockerModal.hide();
			if (mdlPrjContainer.onModalClose) mdlPrjContainer.onModalClose();
			
			if(PRJMODAL_HIDE_OVERFLOW) {
				$(document.body).setStyle('overflow', '');
			}
		});
	} else {
		
		mdlPrjContainer.addClass('hiddenModal');
		mdlPrjContainer.blockerModal.hide();
		if (mdlPrjContainer.onModalClose) mdlPrjContainer.onModalClose();
		
		if(PRJMODAL_HIDE_OVERFLOW) {
			$(document.body).setStyle('overflow', '');
		}
	}
}
