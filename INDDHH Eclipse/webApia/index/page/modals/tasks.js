var TASKMODAL_HIDE_OVERFLOW	= true;

function initTaskMdlPage(){
	var mdlTaskContainer = $('mdlTaskContainer');
	if (mdlTaskContainer.initDone) return;
	mdlTaskContainer.initDone = true;

	mdlTaskContainer.blockerModal = new Mask();
	
	['orderByNameTaskMdl','orderByTitleTaskMdl'].each(function(ele){
		ele = $(ele);
		ele.tooltip(GNR_ORDER_BY + ele.getAttribute("title"), { mode: 'auto', width: 100, hook: 0 })
	});
	
	['nameFilterTaskMdl', 'titleFilterTaskMdl'].each(function(ele) {
		ele = $(ele);
		ele.setFilterTask = setFilterTask;
		ele.oldValue = ele.value;
		ele.addEvent("keyup", function(e) {
			if (this.oldValue == this.value) return;
			if (this.timmer) $clear(this.timmer);
			this.oldValue = this.value;
			this.timmer = this.setFilterTask.delay(200, this);
			
		});		
	});
	
	$('closeModalTask').addEvent("click", function(e) {
		e.stop();
		closeTaskModal();
	});
	
	$('clearFiltersTask').addEvent("click", function(e) {
		e.stop();
		['nameFilterTaskMdl'].each(clearFilter);
		$('nameFilterTaskMdl').setFilterTask();
	});
	
 
	$('confirmModalTask').addEvent("click", function(e) {
		var mdlTaskContainer = $('mdlTaskContainer');
		if (mdlTaskContainer.onModalConfirm) jsCaller(mdlTaskContainer.onModalConfirm,getSelectedRows($('tableDataTask')));
		closeTaskModal();
	});
	
	//Evento doble-click con misma funcionalidad que boton confirmar
	$('tableDataTask').getParent().addEvent("dblclick", function(e) {
		if (mdlTaskContainer.onModalConfirm) jsCaller(mdlTaskContainer.onModalConfirm,getSelectedRows($('tableDataTask')));
		closeTaskModal();
	});
	
	//eventos para order
	['orderByNameTaskMdl', 'orderByTitleTaskMdl'].each(function(ele){
		$(ele).addEvent("click", function(e) {
			e.stop();
			currentPrefix = 'Task';
			callNavigateOrder(this.getAttribute('sortBy'),this,'/apia.modals.TasksAction.run','Task');
		});
	});
	
	window.sp_Task = new Spinner($('tableDataTask'), {message: WAIT_A_SECOND});
	window.sp_Task.content.getParent().addClass('mdlSpinner');
	
	initNavButtons('/apia.modals.TasksAction.run','Task');
}

var TASKMODAL_SELECTONLYONE	= false;
var TASKMODAL_ADT_SQL = '';

//establecer un filtro
function setFilterTask(){
	callNavigateFilter({
		txtName: $('nameFilterTaskMdl').value,
		txtTitle: $('titleFilterTaskMdl').value,
		selectOnlyOne: TASKMODAL_SELECTONLYONE,
		txtAdtSql: TASKMODAL_ADT_SQL
	},null,'/apia.modals.TasksAction.run','Task');
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

function showTaskModal(retFunction, closeFunction){
	
	if(TASKMODAL_HIDE_OVERFLOW) {
		$(document.body).setStyle('overflow', 'hidden');
	}
	
	setFilterTask();
	unSelectAllRows($('tableDataTask'));
	
	var mdlTaskContainer = $('mdlTaskContainer');
	mdlTaskContainer.removeClass('hiddenModal');
	mdlTaskContainer.position();
	mdlTaskContainer.blockerModal.show();
	mdlTaskContainer.setStyle('zIndex',SYS_PANELS.getNewZIndex());
	mdlTaskContainer.onModalConfirm = retFunction;
	mdlTaskContainer.onModalClose = closeFunction;
}

function closeTaskModal(){
	var mdlTaskContainer = $('mdlTaskContainer');
	
	if(Browser.chrome || Browser.firefox || Browser.safari) {
		var morph = new Fx.Morph(mdlTaskContainer, {duration: 200, wait: false});
		
		morph.start({
			'margin-top': '-10px',
			'opacity': 0
		}).chain(function() {
			
			mdlTaskContainer.addClass('hiddenModal');
			mdlTaskContainer.setStyles({
				'opacity': 1,
				'margin-top': ''
			}); //Limpiar la transicion
						
			mdlTaskContainer.blockerModal.hide();
			if (mdlTaskContainer.onModalClose) mdlTaskContainer.onModalClose();
			
			if(TASKMODAL_HIDE_OVERFLOW) {
				$(document.body).setStyle('overflow', '');
			}
		});
	} else {
		
		mdlTaskContainer.addClass('hiddenModal');
		
		mdlTaskContainer.blockerModal.hide();
		if (mdlTaskContainer.onModalClose) mdlTaskContainer.onModalClose();
		
		if(TASKMODAL_HIDE_OVERFLOW) {
			$(document.body).setStyle('overflow', '');
		}
	}
}
