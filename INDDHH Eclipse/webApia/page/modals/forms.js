var FORMSMODAL_HIDE_OVERFLOW	= true;

function initFormMdlPage(){
	var mdlFormContainer = $('mdlFormContainer');
	if (mdlFormContainer.initDone) return;
	mdlFormContainer.initDone = true;

	mdlFormContainer.blockerModal = new Mask();
	
	['orderByNameFormMdl'].each(function(ele){
		ele = $(ele);
		ele.set('title', GNR_ORDER_BY + ele.getAttribute("title"))
	});
	
	['nameFilterFormMdl'].each(function(ele) {
		ele = $(ele);
		ele.setFilterForm = setFilterForm;
		ele.oldValue = ele.value;
		ele.addEvent("keyup", function(e) {
			if (this.oldValue == this.value) return;
			if (this.timmer) $clear(this.timmer);
			this.oldValue = this.value;
			this.timmer = this.setFilterForm.delay(200, this);
			
		});		
	});
	
	$('closeModalForm').addEvent("click", function(e) {
		e.stop();
		closeFormModal();
	});
	
	$('clearFiltersForm').addEvent("click", function(e) {
		e.stop();
		['nameFilterFormMdl'].each(clearFilter);
		$('nameFilterFormMdl').setFilterForm();
	});
	
 
	$('confirmModalForm').addEvent("click", function(e) {
		var mdlFormContainer = $('mdlFormContainer');
		if (mdlFormContainer.onModalConfirm) jsCaller(mdlFormContainer.onModalConfirm,getSelectedRows($('tableDataForm')));
		closeFormModal();
	});

	//Evento doble-click con misma funcionalidad que boton confirmar
	$('tableDataForm').getParent().addEvent("dblclick", function(e) {
		if (mdlFormContainer.onModalConfirm) jsCaller(mdlFormContainer.onModalConfirm,getSelectedRows($('tableDataForm')));
		closeFormModal();
	});
	
	//eventos para order
	['orderByNameFormMdl'].each(function(ele){
		$(ele).addEvent("click", function(e) {
			e.stop();
			currentPrefix = 'Form';
			callNavigateOrder(this.getAttribute('data-sortBy'),this,'/apia.modals.FormsAction.run','Form');
		});
	});
	
	window.sp_Form = new Spinner($('tableDataForm').getParent('table'), {message: WAIT_A_SECOND});
	window.sp_Form.content.getParent().addClass('mdlSpinner');
	
	initNavButtons('/apia.modals.FormsAction.run','Form');
}

var FORMSMODAL_SHOWGLOBAL = false;
var FORMSMODAL_SELECTONLYONE	= false;

//establecer un filtro
function setFilterForm(){
	callNavigateFilter({
		txtName: $('nameFilterFormMdl').value,
		showGlobal : FORMSMODAL_SHOWGLOBAL,
		selectOnlyOne: FORMSMODAL_SELECTONLYONE
	},null,'/apia.modals.FormsAction.run','Form');
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
	$('formsTrOrderBy').getElements(".orderedBy").each(function(item, index){
	    item.removeClass("orderedBy");
	});
	
	$('formsTrOrderBy').getElements(".sortUp").each(function(item, index){
		if(obj!=item){
			item.removeClass("sortUp");
			item.addClass("unsorted");
		}
	});
	
	$('formsTrOrderBy').getElements(".sortDown").each(function(item, index){
		if(obj!=item){
			item.removeClass("sortDown");
			item.addClass("unsorted");
		}
	});
	
}

var returnFunction;
var blocker;

function showFormModal(retFunction, closeFunction){
	
	if(FORMSMODAL_HIDE_OVERFLOW) {
		$(document.body).setStyle('overflow', 'hidden');
	}
	
	setFilterForm();
	unSelectAllRows($('tableDataForm'));
	
	var mdlFormContainer = $('mdlFormContainer');
	mdlFormContainer.removeClass('hiddenModal');
	mdlFormContainer.position();
	mdlFormContainer.blockerModal.show();
	mdlFormContainer.setStyle('zIndex', SYS_PANELS.getNewZIndex());
	mdlFormContainer.onModalConfirm = retFunction;
	mdlFormContainer.onModalClose = closeFunction;
}

function closeFormModal(){
	var mdlFormContainer = $('mdlFormContainer');
	
	if(Browser.chrome || Browser.firefox || Browser.safari) {
		var morph = new Fx.Morph(mdlFormContainer, {duration: 200, wait: false});
		
		morph.start({
			'margin-top': '-10px',
			'opacity': 0
		}).chain(function() {
			
			mdlFormContainer.addClass('hiddenModal');
			mdlFormContainer.setStyles({
				'opacity': 1,
				'margin-top': ''
			}); //Limpiar la transicion
						
			mdlFormContainer.blockerModal.hide();
			if (mdlFormContainer.onModalClose) mdlFormContainer.onModalClose();
			
			if(FORMSMODAL_HIDE_OVERFLOW) {
				$(document.body).setStyle('overflow', '');
			}
		});
	} else {
		
		mdlFormContainer.addClass('hiddenModal');
		
		mdlFormContainer.blockerModal.hide();
		if (mdlFormContainer.onModalClose) mdlFormContainer.onModalClose();
		
		if(FORMSMODAL_HIDE_OVERFLOW) {
			$(document.body).setStyle('overflow', '');
		}
	}
	
	
}
