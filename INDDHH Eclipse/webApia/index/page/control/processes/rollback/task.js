function initPage(){
	//crear spinner de espere un momento
	sp = new Spinner($('gridBody').getParent(),{message:WAIT_A_SECOND});
	 
	var btnCon = $('btnCon');
	if (btnCon){
		btnCon.addEvent("click", function(e) {
			e.stop();
			if(selectionCount($('tableData')) == 0) {
				showMessage(GNR_CHK_AT_LEAST_ONE, GNR_TIT_WARNING, 'modalWarning');
			}else{
				SYS_PANELS.newPanel();
				var panel = SYS_PANELS.getActive();
				panel.addClass("modalWarning");
				panel.content.innerHTML = NO_ROLL_MSG;
				panel.footer.innerHTML = "<div class='button' onClick=\"SYS_PANELS.closeAll(); confirm();\">" + CONFIRM + "</div>";
				SYS_PANELS.addClose(panel);			
				SYS_PANELS.refresh();				
			}
		});
	}
	
	var btnBack = $('btnBack');
	if (btnBack){
		btnBack.addEvent("click", function(e) {
			e.stop();
			sp.show(true);
			window.location = CONTEXT + URL_REQUEST_AJAX + '?action=list&' + TAB_ID_REQUEST+"&reset="+true;			
		});
	}	
	
	//$$("div.button").each(setAdmEvents);
	
	initNavButtons();
	initAdminFav();
	
	var request = new Request({
		method: 'post',
		url: CONTEXT + URL_REQUEST_AJAX + '?action=loadTasks&isAjax=true' + TAB_ID_REQUEST,
		onRequest: function() { sp.show(true); },
		onComplete: function(resText, resXml) { modalProcessXml(resXml); sp.hide(true); }
	}).send();
}

function confirm(){
	var id = encodeURIComponent(getSelectedRows($('tableData'))[0].getRowId());
	var request = new Request({
		method: 'post',
		url: CONTEXT + URL_REQUEST_AJAX + '?action=confirm&isAjax=true&task=true' + TAB_ID_REQUEST,
		onRequest: function() { SYS_PANELS.showLoading(); },
		onComplete: function(resText, resXml) { modalProcessXml(resXml); }
		}).send("id="+id);
}

function loadTableTasks(aux){
	var ajaxCallXml = getLastFunctionAjaxCall();
	if (ajaxCallXml != null) {
		var messages = ajaxCallXml.getElementsByTagName("messages");
		ajaxCallXml = null;
		if (messages != null && messages.length > 0) {
			ajaxCallXml = messages[0].getElementsByTagName("result")[0];
		}
		loadTable($('tableData'),ajaxCallXml,true); 
		addOnClickEvent($('tableData'));
	}		
};

function addOnClickEvent(tbl){
	tbl.getElements('.selectableTR').each(function(item, index){
	    item.addEvent("click",function(e){
	    	loadGrids();
	    });
	});
}

function loadGrids(){
	if (selectionCount($('tableData')) > 1) {
		showMessage(GNR_CHK_ONLY_ONE, GNR_TIT_WARNING, 'modalWarning');
	} else if (selectionCount($('tableData')) > 0) {
		var id = encodeURIComponent(getSelectedRows($('tableData'))[0].getRowId());
		var request = new Request({
			method: 'post',
			url: CONTEXT + URL_REQUEST_AJAX + '?action=loadBottomGrids&isAjax=true' + TAB_ID_REQUEST,			
			onComplete: function(resText, resXml) { modalProcessXml(resXml); sp.hide(true); }
		}).send("id="+id); 
		
	}else{
		$('bottomGrids').style.visibility='hidden';
	}
}

function loadBottomGrids(){
	var ajaxCallXml = getLastFunctionAjaxCall();
	if (ajaxCallXml != null) {
		var messages = ajaxCallXml.getElementsByTagName("messages");
		ajaxCallXml = null;
		if (messages != null && messages.length > 0) {
			ajaxCallXml = messages[0].getElementsByTagName("result")[0];
		}
		loadTable($('leftTableData'),ajaxCallXml);
		if (messages != null && messages.length > 0) {
			ajaxCallXml = messages[0].getElementsByTagName("result")[1];
		}
		loadTable($('rightTableData'),ajaxCallXml);
		$('bottomGrids').style.visibility='visible';
	}		
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