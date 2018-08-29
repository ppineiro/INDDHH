function initPage(){
	//crear spinner de espere un momento
	sp = new Spinner($('gridBody').getParent(),{message:WAIT_A_SECOND});
	
	['orderByHasRead','orderByMessage','orderByDate','orderByFrom','orderByEvent'].each(function(ele){
		setAdmListTitle(ele);
	});
	
	//asociar eventos para los filtros
	
	['messageFilter','dateFilter','fromFilter','eventFilter','userFilter','dteFrom','dteTo'].each(function(ele) {
		setAdmFilters(ele);	
	});
	
	$('dateFilter').setFilter = setFilter;
	$('dateFilter').addEvent("change", function(e) {
		this.setFilter();
	});
	$('dteFrom').setFilter = setFilter;
	$('dteFrom').addEvent("change", function(e) {
		this.setFilter();
	});
	$('dteTo').setFilter = setFilter;
	$('dteTo').addEvent("change", function(e) {
		this.setFilter();
	});
	
	
	
	$('clearFilters').addEvent("click", function(e) {
		e.stop();
		['messageFilter','fromFilter','eventFilter','userFilter'].each(clearFilter);
		['dateFilter','dteFrom','dteTo'].each(clearFilterDate);				
		$('messageFilter').setFilter();
	});
	
	//eventos para order
	['orderByHasRead','orderByMessage','orderByDate','orderByFrom','orderByEvent'].each(function(ele){
		setAdmOrder(ele);
	});
	/*
	$$("div.button").each(function(ele){
		setAdmEvents(ele);
	});
	*/
	//eventos para opciones
	var btnDelete = $('btnDelete');
	btnDelete.tooltip(GNR_NAV_ADM_CLONE, { mode: 'auto', width: 100, hook: 0 });
	
	if (btnDelete) {
		btnDelete.addEvent("click", function(e) {
			e.stop();
			hideMessage();
			if (selectionCount($('tableData')) == 0) {
				showMessage(GNR_CHK_AT_LEAST_ONE, GNR_TIT_WARNING, 'modalWarning');
			} else {
				
				SYS_PANELS.newPanel();
				var panel = SYS_PANELS.getActive();
				panel.addClass("modalWarning");
				panel.content.innerHTML = CONFIRM_ELEMENT_DELETE;
				panel.footer.innerHTML = "<div class='button' onClick=\"SYS_PANELS.closeAll(); btnDeleteClickConfirm();\">" + GNR_NAV_ADM_DELETE + "</div>";
				SYS_PANELS.addClose(panel);
				
				SYS_PANELS.refresh();
			}
		});
	}
	
	initNavButtons();
	
	initAdminFav();
	
	initPinGridOptions();
		
	callNavigate();
}


//navegar a una pagina 


//establecer un filtro
function setFilter(){
	callNavigateFilter({
			txtMessage: $('messageFilter').value,			
			dte: $('dateFilter').value,
			cmbFrom: $('fromFilter').value,
			cmbEvent: $('eventFilter').value,			
			txtUserLogin: $('userFilter').value,
			dteTo: $('dteTo').value,
			dteFrom: $('dteFrom').value
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

function btnDeleteClickConfirm() {
	var selected = getSelectedRows($('tableData'));
	var selection = "";
	for(i=0; i<selected.length; i++){
		selection+=selected[i].getRowId();
		if(i<selected.length-1){
			selection+=";";
		}
	}
	var request = new Request({
		method: 'post',
		url: CONTEXT + URL_REQUEST_AJAX + '?action=delete&isAjax=true&id='+selection + TAB_ID_REQUEST,
		onRequest: function() { sp.show(true); },
		onComplete: function(resText, resXml) { modalProcessXml(resXml); sp.hide(true); }
	}).send();
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