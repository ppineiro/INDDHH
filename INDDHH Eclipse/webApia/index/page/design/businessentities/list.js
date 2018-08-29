function initPage(){
	getTabContainerController().changeTabState(TAB_ID, false); 
	
	//crear spinner de espere un momento
	sp = new Spinner($('gridBody').getParent(),{message:WAIT_A_SECOND});
	
	['orderByPerm','orderByName','orderByDesc','orderByTitle','orderByRegUser','orderByRegDate'].each(function(ele){
		setAdmListTitle(ele);
	});
	
	//asociar eventos para los filtros
	
	['nameFilter','descFilter','titleFilter','regUsrFilter','regUsrFilter'].each(function(ele) {
		setAdmFilters(ele);		
	});
	
	$('regDateFilter').setFilter = setFilter;
	$('regDateFilter').addEvent("change", function(e) {
		this.setFilter();
	});
	
	$('clearFilters').addEvent("click", function(e) {
		e.stop();
		['nameFilter','descFilter','titleFilter','projectFilter','regUsrFilter','typeFilter','cubeFilter'].each(clearFilter);
		['regDateFilter'].each(clearFilterDate);
		$('nameFilter').setFilter();
	});
	
	//eventos para order
	['orderByName','orderByDesc','orderByTitle','orderByRegUser','orderByRegDate'].each(function(ele){
		setAdmOrder(ele);
	});
	/*
	$$("div.button").each(function(ele){
		setAdmEvents(ele);
	});
	*/
	var optionInit = $('optionInit');
	if (optionInit){
		optionInit.addEvent("click", function(e) {
			e.stop();
			if(selectionCount($('tableData')) == 0) {
				showMessage(GNR_CHK_AT_LEAST_ONE, GNR_TIT_WARNING, 'modalWarning');
			} else {
				
				SYS_PANELS.newPanel();
				var panel = SYS_PANELS.getActive();
				panel.addClass("modalWarning");
				panel.content.innerHTML = GNR_INIT_RECORD;
				panel.footer.innerHTML = "<div class='button' onClick=\"SYS_PANELS.closeAll(); initializeEntity();\">" + BTN_CONFIRM + "</div>";
				SYS_PANELS.addClose(panel);

				SYS_PANELS.refresh();
			}
			
		});
	}
	
	var optionRegCube = $('optionRegCube');
	if (optionRegCube){
		optionRegCube.addEvent("click", function(e) {
			e.stop();
			if(selectionCount($('tableData')) == 0) {
				showMessage(GNR_CHK_AT_LEAST_ONE, GNR_TIT_WARNING, 'modalWarning');
			} else {
				SYS_PANELS.newPanel();
				var panel = SYS_PANELS.getActive();
				panel.addClass("modalWarning");
				panel.content.innerHTML = MSG_REG_CUBE;
				panel.footer.innerHTML = "<div class='button' onClick=\"SYS_PANELS.closeAll(); regenerateCube();\">" + BTN_CONFIRM + "</div>";
				SYS_PANELS.addClose(panel);
				SYS_PANELS.refresh();
			}			
		});
	}
	
	var optionMer = $('optionMer');
	if (optionMer) {
		optionMer.addEvent("click", function(e) {
		 e.stop();
		 ADMIN_SPINNER.show(true);
		 window.location = CONTEXT + URL_REQUEST_AJAX + '?action=merImport&fromList=true' + TAB_ID_REQUEST;
		 });
	} 
	
	var optionUpload = $('optionUpload');
	if (optionUpload){
		optionUpload.addEvent("click", function(e) {
			e.stop();
			if (selectionCount($('tableData')) > 1) {
				showMessage(GNR_CHK_ONLY_ONE, GNR_TIT_WARNING, 'modalWarning');
			} else if (selectionCount($('tableData')) == 0) {
				showMessage(GNR_CHK_AT_LEAST_ONE, GNR_TIT_WARNING, 'modalWarning');
			} else {
				var selected = getSelectedRows($('tableData'))[0].getRowId();
				var request = new Request({
					method: 'post',					
					url: CONTEXT + URL_REQUEST_AJAX+'?action=upload&isAjax=true&id=' + selected + TAB_ID_REQUEST,
					onRequest: function() { },
					onComplete: function(resText, resXml) { modalProcessXml(resXml); }
				}).send()
			}			
		});
	}
	
	var optionDownload = $('optionDownload');
	if (optionDownload){
		optionDownload.addEvent("click", function(e) {
			e.stop();
			if (selectionCount($('tableData')) > 1) {
				showMessage(GNR_CHK_ONLY_ONE, GNR_TIT_WARNING, 'modalWarning');
			} else if (selectionCount($('tableData')) == 0) {
				showMessage(GNR_CHK_AT_LEAST_ONE, GNR_TIT_WARNING, 'modalWarning');
			} else {
				var selected = getSelectedRows($('tableData'))[0].getRowId();
				showExportModal(selected);				
			}			
		});
	}
	
	//['optionInit','optionMer','optionRegCube','optionUpload','optionDownload'].each(setTooltip);
	
	initExportMdlPage();
	
	initAdminActions();
	
	initNavButtons();	
	
	callNavigate();
}


//navegar a una pagina 


//establecer un filtro
function setFilter(){
	callNavigateFilter({
			txtName: $('nameFilter').value,
			txtDesc: $('descFilter').value,
			txtTitle: $('titleFilter').value,
			selPrj: $('projectFilter').value,
			txtRegUser: $('regUsrFilter').value,
			txtRegDate: $('regDateFilter').value,
			cubeType: $('cubeFilter').value,
			cmbType: $('typeFilter').value
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

function initializeEntity(){
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
		data:{id:selection},
		url: CONTEXT + URL_REQUEST_AJAX+'?action=initEntity&isAjax=true' + TAB_ID_REQUEST,
		onRequest: function() { sp.show(true); },
		onComplete: function(resText, resXml) { modalProcessXml(resXml); sp.hide(true); }
	}).send();
}

function regenerateCube(){
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
		data:{id:selection},
		url: CONTEXT + URL_REQUEST_AJAX+'?action=regCube&isAjax=true' + TAB_ID_REQUEST,
		onRequest: function() { sp.show(true); },
		onComplete: function(resText, resXml) { modalProcessXml(resXml); sp.hide(true); }
	}).send();	
}