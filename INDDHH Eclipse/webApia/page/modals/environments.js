var ENVIRONMENTMODAL_HIDE_OVERFLOW	= true;

function initEnvMdlPage(){
	var mdlEnvContainer = $('mdlEnvContainer');
	if (mdlEnvContainer.initDone) return;
	mdlEnvContainer.initDone = true;

	mdlEnvContainer.blockerModal = new Mask();
	
	['orderByNameEnvMdl','orderByTitleEnvMdl','orderByDescEnvMdl'].each(function(ele){
		ele = $(ele);
		ele.set('title', GNR_ORDER_BY + ele.getAttribute("title"))
	});
	
	['nameFilterEnvMdl','titleFilterEnvMdl','descFilterEnvMdl'].each(function(ele) {
		ele = $(ele);
		ele.setFilterEnv = setFilterEnv;
		ele.oldValue = ele.value;
		ele.addEvent("keyup", function(e) {
			if (this.oldValue == this.value) return;
			if (this.timmer) $clear(this.timmer);
			this.oldValue = this.value;
			this.timmer = this.setFilterEnv.delay(200, this);
			
		});		
	});
	
	$('closeModalEnv').addEvent("click", function(e) {
		e.stop();
		closeEnvironmentsModal();
	});
	
	$('clearFiltersEnv').addEvent("click", function(e) {
		e.stop();
		['nameFilterEnvMdl','titleFilterEnvMdl','descFilterEnvMdl'].each(clearFilter);		
		$('nameFilterEnvMdl').setFilterEnv();
	});
	
 
	$('confirmModalEnv').addEvent("click", function(e) {
		var mdlEnvContainer = $('mdlEnvContainer');
		if (mdlEnvContainer.onModalConfirm) jsCaller(mdlEnvContainer.onModalConfirm,getSelectedRows($('tableDataEnv')));
		closeEnvironmentsModal();
	});
	
	//Evento doble-click con misma funcionalidad que boton confirmar
	$('tableDataEnv').getParent().addEvent("dblclick", function(e) {
		if (mdlEnvContainer.onModalConfirm) jsCaller(mdlEnvContainer.onModalConfirm,getSelectedRows($('tableDataEnv')));
		closeEnvironmentsModal();
	});
	
	//eventos para order
	['orderByNameEnvMdl','orderByTitleEnvMdl','orderByDescEnvMdl'].each(function(ele){
		$(ele).addEvent("click", function(e) {
			e.stop();
			callNavigateOrder(this.getAttribute('data-sortBy'),this,'/apia.modals.EnvironmentsAction.run','Env');
		});
	});
	
	window.sp_Env = new Spinner($('tableDataEnv').getParent('table'), {message: WAIT_A_SECOND});
	window.sp_Env.content.getParent().addClass('mdlSpinner');
	
	initNavButtons('/apia.modals.EnvironmentsAction.run','Env');
}


var ENVIRONMENTMODAL_SELECTONLYONE	= false;
var ENVIRONMENTMODAL_ADT_SQL		= '';

//establecer un filtro
function setFilterEnv(){
	currentPrefix = 'Env';
	callNavigateFilter({
		txtName: $('nameFilterEnvMdl').value,
		txtTitle: $('titleFilterEnvMdl').value,
		txtDesc: $('descFilterEnvMdl').value,
		selectOnlyOne: ENVIRONMENTMODAL_SELECTONLYONE,
		txtAdtSql: ENVIRONMENTMODAL_ADT_SQL
	},null,'/apia.modals.EnvironmentsAction.run','Env');
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
	$('environmentsTrOrderBy').getElements(".orderedBy").each(function(item, index){
	    item.removeClass("orderedBy");
	});
	
	$('environmentsTrOrderBy').getElements(".sortUp").each(function(item, index){
		if(obj!=item){
			item.removeClass("sortUp");
			item.addClass("unsorted");
		}
	});
	
	$('environmentsTrOrderBy').getElements(".sortDown").each(function(item, index){
		if(obj!=item){
			item.removeClass("sortDown");
			item.addClass("unsorted");
		}
	});
	
}

function showEnvironmentsModal(retFunction, closeFunction){
	
	if(ENVIRONMENTMODAL_HIDE_OVERFLOW) {
		$(document.body).setStyle('overflow', 'hidden');
	}
	
    setFilterEnv();
    unSelectAllRows($('tableDataEnv'));
	
	var mdlEnvContainer = $('mdlEnvContainer');
	mdlEnvContainer.removeClass('hiddenModal');
	mdlEnvContainer.position();
	mdlEnvContainer.blockerModal.show();
	mdlEnvContainer.setStyle('zIndex', SYS_PANELS.getNewZIndex());
	mdlEnvContainer.onModalConfirm = retFunction;
	mdlEnvContainer.onModalClose = closeFunction;
}

function closeEnvironmentsModal(){
    var mdlEnvContainer = $('mdlEnvContainer');
    
    if(Browser.chrome || Browser.firefox || Browser.safari) {
		var morph = new Fx.Morph(mdlEnvContainer, {duration: 200, wait: false});
		
		morph.start({
			'margin-top': '-10px',
			'opacity': 0
		}).chain(function() {
			
			mdlEnvContainer.addClass('hiddenModal');
			mdlEnvContainer.setStyles({
				'opacity': 1,
				'margin-top': ''
			}); //Limpiar la transicion
						
			mdlEnvContainer.blockerModal.hide();
			if (mdlEnvContainer.onModalClose) mdlEnvContainer.onModalClose();
			
			if(ENVIRONMENTMODAL_HIDE_OVERFLOW) {
				$(document.body).setStyle('overflow', '');
			}
		});
	} else {
		
		mdlEnvContainer.addClass('hiddenModal');
		
	    mdlEnvContainer.blockerModal.hide();
		if (mdlEnvContainer.onModalClose) mdlEnvContainer.onModalClose();
		
		if(ENVIRONMENTMODAL_HIDE_OVERFLOW) {
			$(document.body).setStyle('overflow', '');
		}
	}
}