var USERMODAL_EXTERNAL = false;
var USERMODAL_SELECTONLYONE	= false;
var USERMODAL_GLOBAL_AND_ENV = false;
var USERMODAL_POOL_ID = -1;
var USERMODAL_HIERARCHY = false;
var USERMODAL_HIDE_OVERFLOW	= true;

function initUsrMdlPage(){
	var mdlUsersContainer = $('mdlUsersContainer');
	if (mdlUsersContainer.initDone) return;
	mdlUsersContainer.initDone = true;

	mdlUsersContainer.blockerModal = new Mask();
	
	['orderByLoginUsrMdl','orderByNameUsrMdl','orderByEmailUsrMdl'].each(function(ele){
		ele = $(ele);
//		ele.tooltip(GNR_ORDER_BY + ele.getAttribute("title"), { mode: 'auto', width: 100, hook: 0 })
		ele.set('title', GNR_ORDER_BY + ele.get("title"))
	});
	
	['loginFilterUsrMdl','nameFilterUsrMdl','emailFilterUsrMdl'].each(function(ele) {
		ele = $(ele);
		ele.setFilterUser = setFilterUser;
		ele.oldValue = ele.value;
		ele.addEvent("keyup", function(e) {
			if (this.oldValue == this.value) return;
			if (this.timmer) $clear(this.timmer);
			this.oldValue = this.value;
			this.timmer = this.setFilterUser.delay(200, this);
			
		});		
	});
	
	$('closeModalUser').addEvent("click", function(e) {
		if(e) e.stop();
		closeUserssModal();
	}).addEvent('keypress', Generic.enterKeyToClickListener);
	
	$('clearFiltersUser').addEvent("click", function(e) {
		if(e) e.stop();
		['loginFilterUsrMdl','nameFilterUsrMdl','emailFilterUsrMdl'].each(clearFilter);		
		$('loginFilterUsrMdl').setFilterUser();
	}).addEvent('keypress', Generic.enterKeyToClickListener);
	
	var confirmModalUser = $('confirmModalUser').addEvent("click", function(e) {
		var mdlUsersContainer = $('mdlUsersContainer');
		if (mdlUsersContainer.onModalConfirm) jsCaller(mdlUsersContainer.onModalConfirm,getSelectedRows($('tableDataUser')));
		closeUserssModal();
	}).addEvent('keypress', Generic.enterKeyToClickListener).addEvent('keydown', function(e) {
		if(!e.shift && e.key == 'tab') {
			e.preventDefault();
			mdlUsersContainer.focus();
		}
	});
	
	mdlUsersContainer.addEvent('keydown', function(e) {
		
		if(e.target == mdlUsersContainer && e.shift && e.key == 'tab') {
			e.preventDefault();
			confirmModalUser.focus();
		}
	});
	
	//Evento doble-click con misma funcionalidad que boton confirmar
	$('tableDataUser').getParent().addEvent("dblclick", function(e) {
		if (mdlUsersContainer.onModalConfirm) jsCaller(mdlUsersContainer.onModalConfirm,getSelectedRows($('tableDataUser')));
		closeUserssModal();
	});
	
	//eventos para order
	['orderByLoginUsrMdl','orderByNameUsrMdl','orderByEmailUsrMdl'].each(function(ele){
		$(ele).addEvent("click", function(e) {
			e.stop();
			callNavigateOrder(this.getAttribute('data-sortBy'),this, '/apia.modals.UsersAction.run','User');
		});
	});
	
	if(USERMODAL_EXTERNAL){
		//solo se puede filtrar por login
		$('nameFilterUsrMdl').addClass("hidden");
		$('emailFilterUsrMdl').addClass("hidden");
	}
	
	window.sp_User = new Spinner($('tableDataUser').getParent('table'), {message: WAIT_A_SECOND});
	window.sp_User.content.getParent().addClass('mdlSpinner');
	
	initNavButtons('/apia.modals.UsersAction.run','User');
}

//establecer un filtro
function setFilterUser(){
	callNavigateFilter({
		txtLogin: $('loginFilterUsrMdl').value,
		txtName: $('nameFilterUsrMdl').value,
		txtEmail: $('emailFilterUsrMdl').value,
		externalUser:USERMODAL_EXTERNAL,
		selectOnlyOne: USERMODAL_SELECTONLYONE,
		globalAndEnv: USERMODAL_GLOBAL_AND_ENV,
		hierarchy: USERMODAL_HIERARCHY,
	},null,'/apia.modals.UsersAction.run','User');
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
	$('usersTrOrderBy').getElements(".orderedBy").each(function(item, index){
	    item.removeClass("orderedBy");
	});
	
	$('usersTrOrderBy').getElements(".sortUp").each(function(item, index){
		if(obj!=item){
			item.removeClass("sortUp");
			item.addClass("unsorted");
		}
	});
	
	$('usersTrOrderBy').getElements(".sortDown").each(function(item, index){
		if(obj!=item){
			item.removeClass("sortDown");
			item.addClass("unsorted");
		}
	});
	
}

function showUsersModal(retFunction, closeFunction){
	
	if(USERMODAL_HIDE_OVERFLOW) {
		$(document.body).setStyle('overflow', 'hidden');
	}
	setFilterUser();
	unSelectAllRows($('tableDataUser'));

	var mdlUsersContainer = $('mdlUsersContainer');
	mdlUsersContainer.removeClass('hiddenModal');
	mdlUsersContainer.position();
	mdlUsersContainer.blockerModal.show();
	mdlUsersContainer.setStyle('zIndex', SYS_PANELS.getNewZIndex());
	mdlUsersContainer.onModalConfirm = retFunction;
	mdlUsersContainer.onModalClose = closeFunction;
	
	mdlUsersContainer.focus();
}

function closeUserssModal(){
	var mdlUsersContainer = $('mdlUsersContainer');
	
	if(Browser.chrome || Browser.firefox || Browser.safari) {
		var morph = new Fx.Morph(mdlUsersContainer, {duration: 200, wait: false});
		
		morph.start({
			'margin-top': '-10px',
			'opacity': 0
		}).chain(function() {
			
			mdlUsersContainer.addClass('hiddenModal');
			mdlUsersContainer.setStyles({
				'opacity': 1,
				'margin-top': ''
			}); //Limpiar la transicion
						
			mdlUsersContainer.blockerModal.hide();
			if (mdlUsersContainer.onModalClose) mdlUsersContainer.onModalClose();
			
			if(USERMODAL_HIDE_OVERFLOW) {
				$(document.body).setStyle('overflow', '');
			}
		});
	} else {
		
		mdlUsersContainer.addClass('hiddenModal');
		
		mdlUsersContainer.blockerModal.hide();
		if (mdlUsersContainer.onModalClose) mdlUsersContainer.onModalClose();
		
		if(USERMODAL_HIDE_OVERFLOW) {
			$(document.body).setStyle('overflow', '');
		}
	}
}