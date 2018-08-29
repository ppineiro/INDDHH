function initPage(){
	//crear spinner de espere un momento
	sp = new Spinner($('gridBody').getParent(),{message:WAIT_A_SECOND});
	
	var btnChngPrio = $('btnChngPrio');
	if (btnChngPrio){
		btnChngPrio.addEvent("click", function(e) {
		e.stop();
		//verificar que solo un registro est� seleccionado
		if (selectionCount($('tableData')) > 1) {
			showMessage(GNR_CHK_ONLY_ONE, GNR_TIT_WARNING, 'modalWarning');
		} else if(selectionCount($('tableData')) == 0) {
			showMessage(GNR_CHK_AT_LEAST_ONE, GNR_TIT_WARNING, 'modalWarning');
		} else {
			var id = getSelectedRows($('tableData'))[0].getRowId();		
			
			var row_id = 'id=' + encodeURIComponent(id);
			
			var request = new Request({
				method: 'post',
				url: CONTEXT + URL_REQUEST_AJAX + '?action=prepareChangePriorityModal&isAjax=true' + TAB_ID_REQUEST,
				onRequest: function() { SYS_PANELS.showLoading(); },
				onComplete: function(resText, resXml) { modalProcessXml(resXml); }
			}).send(row_id);
		}
		});
	}
	
	['orderByRegNumber','orderByTitle','orderByAction','orderByPriority'].each(function(ele){
		setAdmListTitle(ele);
	});
	
	//asociar eventos para los filtros
		
	['actionFilter',
	 'priorityFilter',
	 'userFilter',
	 'numRegFilter',
	 'activityFilter',	
	 'createDateFilterStart',
	 'createDateFilterEnd'
	 ].each(function(ele) {
		 setAdmFilters(ele);	
	});
	
	$('createDateFilterStart').setFilter = setFilter;
	$('createDateFilterStart').addEvent("change", function(e) {
		this.setFilter();
	});
	$('createDateFilterEnd').setFilter = setFilter;
	$('createDateFilterEnd').addEvent("change", function(e) {
		this.setFilter();
	});
	
	
	$('clearFilters').addEvent("click", function(e) {
		e.stop();
		['titleFilter','actionFilter','priorityFilter','userFilter','numRegFilter','activityFilter'].each(clearFilter);			
		['createDateFilterStart','createDateFilterEnd'].each(clearFilterDate);
		$('titleFilter').setFilter();
	});
	
	//eventos para order
	['orderByRegNumber','orderByTitle','orderByAction','orderByPriority'].each(function(ele){
		setAdmOrder(ele);
	});
	/*
	$$("div.button").each(function(ele){
		setAdmEvents(ele);
	});
	*/
	
	initNavButtons(URL_REQUEST_AJAX,"",['titleFilter','actionFilter'],'tableData');
	initAdminFav();
	callNavigate();
	
	
}

//establecer un filtro
function setFilter(){
	callNavigateFilter({
		txtProTitle: $('titleFilter').value,
		cmbAct: $('actionFilter').value,
		cmbPriority: $('priorityFilter').value,
		txtInstUser: $('userFilter').value,
		filProName: $('numRegFilter').value,
		cmbBackLog: $('activityFilter').value,		
		txtStaSta: $('createDateFilterStart').value,
		txtStaEnd: $('createDateFilterEnd').value,
		cmbSta:STATUS_R
		},null);
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

function processXMLResponseReload(ajaxCallXml){
	if (ajaxCallXml != null) {
		//recargar la pagina--- no se llama a la funcion navigate para que no borre los mensajes
		var currPage = parseInt($('navBarCurrentPage').value);
		var request = new Request({
			method: 'post',
			url: CONTEXT + URL_REQUEST_AJAX+'?action=page&isAjax=true&pageNumber='+currPage + TAB_ID_REQUEST,
			onRequest: function() { sp.show(true); },
			onComplete: function(resText, resXml) { processXMLListResponse(resXml); sp.hide(true); }
		}).send();
		
		//obtener el codigo de retorno
		var code = ajaxCallXml.getElementsByTagName("code");
		if("0" == code.item(0).firstChild.nodeValue){
			
			
		} else {
			//si el codigo es diferente de 0	
			var messages = ajaxCallXml.getElementsByTagName("messages");
			if (messages != null && messages.length > 0 && messages.item(0) != null) {
				messages = messages.item(0).getElementsByTagName("message");
				for(var i = 0; i < messages.length; i++) {
					var message = messages.item(i);
					var text	= message.getAttribute("text");
					showMessage(text);	
				}
			}
			
			messages = ajaxCallXml.getElementsByTagName("exceptions");
			if (messages != null && messages.length > 0 && messages.item(0) != null) {
				messages = messages.item(0).getElementsByTagName("exception");
				for(var i = 0; i < messages.length; i++) {
					var message = messages.item(i);
					var text	= message.getAttribute("text");
					showMessage(text);	
				}
			}
		}
	}
}