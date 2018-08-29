function initPage(){
	//crear spinner de espere un momento
	sp = new Spinner($('gridBody').getParent(),{message:WAIT_A_SECOND});
	
	var current_form_tab = null;
	//disparar el cargado de los formularios
	$$('div.formContainer').each(function (frm) {
		
		if(current_form_tab == null) {
			current_form_tab = frm.getParent().getParent();
			Form.addCollapseFunctions(current_form_tab);
		}	
		
		//parse each form...
		var form = new Form(frm);
		form.parseXML(current_form_tab);
		if(form.tabContent)
			current_form_tab = form;
		
		//executionForms.push(form);
	});
	
	['orderMonEntDate','orderMonEntAtt'].each(function(ele) { $(ele).addEvent('click', sortAttributeHistory); });
	
	var btnTasks = $('btnTasks');
	if (btnTasks){
		btnTasks.addEvent("click", function(e) {
			e.stop();
			//verificar que solo un registro est� seleccionado
			if (selectionCount($('tableDataInstance')) > 1) {
				showMessage(GNR_CHK_ONLY_ONE, GNR_TIT_WARNING, 'modalWarning');
			} else if(selectionCount($('tableDataInstance')) == 0) {
				showMessage(GNR_CHK_AT_LEAST_ONE, GNR_TIT_WARNING, 'modalWarning');
			} else {
				//obtener el registro seleccionado
				var id = getSelectedRows($('tableDataInstance'))[0].getRowId();
				var tabContainer = window.parent.document.getElementById('tabContainer');
				var url = CONTEXT + URL_REQUEST_AJAX_MONITOR_TASKS + '?action=task&id=' + id +"&fromEntity=true";
				tabContainer.addNewTab(LABEL_MONITOR_PROCESS,url,null);
			}
		});
	}
	 
	var btnBack = $('btnBack');
	if (btnBack){
		btnBack.addEvent("click", function(e) {
			e.stop();
			sp.show(true);
			window.location = CONTEXT + URL_REQUEST_AJAX + '?action=goBack&' + TAB_ID_REQUEST+"&reset="+true;			
		});
	}
	/*
	$$("div.button").each(function(ele){
		setAdmEvents(ele);
	});
	*/
	initNavHistoryButtons();
	
	callNavigateHistory(1);
	
	checkErrors();
		
	var request = new Request({
		method: 'post',
		url: CONTEXT + URL_REQUEST_AJAX + '?action=loadInstance&isAjax=true' + TAB_ID_REQUEST,
		onRequest: function() { sp.show(true); },
		onComplete: function(resText, resXml) { modalProcessXml(resXml); sp.hide(true); }
	}).send();
	
	$('tabHolder').getChildren('div.tab').addEvent('click', checkOptionsPositionStyle);
	
	initDocumentMdlPage();
}

function checkErrors(xmlDoc){
	 
	if(!xmlDoc) {
		//Obtener el xml del textarea		
		if (window.DOMParser) {
			parser = new DOMParser();
			xmlDoc = parser.parseFromString($('execErrors').value,"text/xml");
		} else {
			// Internet Explorer
			xmlDoc = new ActiveXObject("Microsoft.XMLDOM");
			xmlDoc.async = false;
			xmlDoc.loadXML($('execErrors').value); 
		}
	}
	
	//ie friendly
	var xml = xmlDoc.childNodes.length == 1 ? xmlDoc.childNodes[0] : xmlDoc.childNodes[1];
	
	
	
	if (xml.getElementsByTagName("sysExceptions").length != 0) {
		processXmlExceptions(xml.getElementsByTagName("sysExceptions").item(0), true);
	}
	
	if (xml.getElementsByTagName("sysMessages").length != 0) {
		processXmlMessages(xml.getElementsByTagName("sysMessages").item(0), true);
	}
}
var firstLoad = true;

function fncChange(){
	if($('tabComponent').getActiveTabId()==3){
		$('btnTasks').removeClass('hidden');
	} else {
		$('btnTasks').addClass('hidden');
	}
	if($('tabComponent').getActiveTabId()==1){
		$('pnlOptions').removeClass('hidden');
		if(firstLoad){
			deleteFiltersAtt();
			firstLoad = false;
		}
	}else {
		$('pnlOptions').addClass('hidden');
	}
}

function loadHistory(draw,drawHistory){
	drawHistory = true;
	var ajaxCallXml = lastFunctionAjaxCall;
	if (ajaxCallXml != null) {
		var messages = ajaxCallXml.getElementsByTagName("messages");
		if (messages != null && messages.length > 0) {
			ajaxCallXml = messages[0].getElementsByTagName("result")[1];
		}
		if (drawHistory){
			sortHistoryAttribute(messages[0].getElementsByTagName("result")[2]);
			callNavigateProcessXmlListResponse();
		}
		if (draw){
			drawCombo(ajaxCallXml);
		}
	}
}

function deleteFiltersAtt(){
	var attIdFilter = $$('input.attIdFilter');
	for (var i = 0; i < attIdFilter.length; i++) {
		attIdFilter[i].checked = false;
	}
	filterByAttribute();
}

function filterByAttribute(){
	var attIdFilter = $$('input.attIdFilter');
	
	var id = "";
	
	for (var i = 0; i < attIdFilter.length; i++) {
		var attId = $(attIdFilter[i]);
		if (attId.checked) {
			if (id != "") id += "&";
			id += "id=" + attId.value;
		} 
	}
	
	
	var request = new Request({
		method: 'post',
		url: CONTEXT + URL_REQUEST_AJAX + '?action=attribute&isAjax=true' + TAB_ID_REQUEST,
		onRequest: function() { sp.show(true); },
		onComplete: function(resText, resXml) { modalProcessXml(resXml); sp.hide(true); }
	}).send(id);
}

function sortAttributeHistory() {
	var sortBy = this.get('data-sortBy');
	
	var request = new Request({
		method: 'post',
		url: CONTEXT + URL_REQUEST_AJAX + '?action=sortAttribute&isAjax=true' + TAB_ID_REQUEST,
		onRequest: function() { sp.show(true); },
		onComplete: function(resText, resXml) { modalProcessXml(resXml); sp.hide(true); }
	}).send("orderBy=" + sortBy);
}

function sortHistoryAttribute(xml) {
	if (xml == null) return;
	var sortBy = xml.getElementsByTagName('sort');
	if (sortBy == null) return;
	
	sortBy = sortBy.item(0);
	
	if (sortBy == null) return;
	
	var sortByCode = sortBy.getAttribute('code');
	var sortByDesc = sortBy.getAttribute('desc') == 'true';
	
	var sortColumns = ['orderMonEntDate','orderMonEntAtt'];
	for (var i = 0; i < sortColumns.length; i++) {
		var column = $(sortColumns[i]);
		
		column.removeClass('sortDown');
		column.removeClass('sortUp');
		column.addClass('unsorted');
		
		var sortByTheCode = column.get('sortBy');
		
		if (sortByTheCode == sortByCode) {
			column.removeClass('unsorted');
			column.addClass(sortByDesc ? 'sortUp' : 'sortDown');
		}
	}
}

function drawCombo(xml){
	var elements = xml.getElementsByTagName("element");
	
	var element = elements.item(0);
	
	var name	= element.getAttribute("text");
	
	var selectedValue	= element.getAttribute("value");
	
	var xmlOptions = element.getElementsByTagName("options").item(0);
	
	var options = new Array();
	if (xmlOptions){
		options = xmlOptions.getElementsByTagName("option");
	}

	if ($('filterDiv').firstChild){
		$('filterDiv').firstChild.dispose();
	}
	
	var div = new Element("div",{'class':'filter','html':name+":&nbsp;"});
		
	div.inject($('filterDiv'));
	

	
	for (var i = 0; i < options.length; i++) {
		var option = options.item(i);
		if (option != null) {
			var value		= option.getAttribute("value");
			var text		= (option.firstChild != null)?option.firstChild.nodeValue:"";
			var selected	= option.getAttribute("selected") == "true";
			var o = new Option(text,value);
			
			var aDiv = new Element('div').inject(div);
			new Element("span", {html: text}).inject(aDiv);
			new Element("input", {type: 'checkbox', value: value, name: 'attId', 'class': 'attIdFilter', events: {'change': filterByAttribute}}).inject(aDiv).checked = selected;
		}
	}
	
	if(options.length > 0)	
		$('clearFilters').addEvent('click', deleteFiltersAtt);
	
}

function loadTableTasks(){
	var ajaxCallXml = getLastFunctionAjaxCall();
	if (ajaxCallXml != null) {
		var messages = ajaxCallXml.getElementsByTagName("messages");
		ajaxCallXml = null;
		if (messages != null && messages.length > 0) {
			ajaxCallXml = messages[0].getElementsByTagName("result")[0];
		}
		loadTable($('tableDataInstance'),ajaxCallXml,true);
	}	
}

function initNavHistoryButtons(URL,prefix) {
	
	if(!prefix){
		prefix="";
	}
	
	var navFirst = $('navFirst' + prefix);
	var navPrev = $('navPrev' + prefix);
	var navNext = $('navNext' + prefix);
	var navLast = $('navLast' + prefix);
	var navRefresh = $('navRefresh' + prefix);
	var navBarCurrentPage = $('navBarCurrentPage' + prefix);
	
	if (navFirst) {
		if(URL){navFirst.url = URL;}
		navFirst.set('title', GNR_NAV_FIRST);
		navFirst.addEvent("click", function(e) {
			e.stop();
			currentPrefix = prefix;
			callNavigateHistory(1,this.url);
		});
	}

	if (navPrev) {
		if(URL){navPrev.url = URL;}
		navPrev.set('title', GNR_NAV_PREV);
		navPrev.addEvent("click", function(e) {
			e.stop();
			currentPrefix = prefix;
			var nextPage = parseInt($('navBarCurrentPage' + prefix).value)-1;
			if(nextPage<=0){nextPage=1;}
			callNavigateHistory(nextPage,this.url);
		});
	}

	if (navNext) {
		if(URL){navNext.url = URL;}
		navNext.set('title', GNR_NAV_NEXT);
		navNext.addEvent("click", function(e) {
			e.stop();
			currentPrefix = prefix;
			var nextPage = parseInt($('navBarCurrentPage' + prefix).value)+1;
			var maxPage = parseInt($('navBarPageCount' + prefix).innerHTML);
			if(nextPage>maxPage){nextPage=maxPage;}
			callNavigateHistory(nextPage,this.url)
		});
	}

	if (navLast) {
		if(URL){navLast.url = URL;}
		navLast.set('title', GNR_NAV_LAST);
		navLast.addEvent("click", function(e) {
			e.stop();
			currentPrefix = prefix;
			var nextPage = parseInt($('navBarPageCount' + prefix).innerHTML);
			callNavigateHistory(nextPage,this.url)
		});
	}

	if (navRefresh) {
		if(URL){navRefresh.url = URL;}
		navRefresh.set('title', GNR_NAV_REFRESH);
		navRefresh.addEvent("click", function(e) {
			if (e) e.stop();
			currentPrefix = prefix;
			var nextPage = parseInt($('navBarCurrentPage' + prefix).value);
			callNavigateHistory(nextPage,this.url);
		});
	}
	
	if (navBarCurrentPage) {
		navBarCurrentPage.addEvent("keyup", function(key) {
			var charCode = key.code;
			if((charCode < 48 || charCode > 57) && (charCode < 96 || charCode > 105)){
				var text = this.value;
				this.value = text.substr(0,text.length-1);
			}
		});
		if(URL){navBarCurrentPage.url = URL;}
		navBarCurrentPage.addEvent("change", function(e) {
			e.stop();
			currentPrefix = prefix;
			var nextPage = parseInt(this.value);
			callNavigateHistory(nextPage,this.url);
		});
	}
	//$('clearFilters').style.visibility='hidden';
}

function callNavigateHistory(nextPage,url,prefix){
	if(!url){
		url = URL_REQUEST_AJAX;
	}
	if(prefix){
		currentPrefix = prefix;
	}
	hideMessage();
	var request = new Request({
		method: 'post',
		url: CONTEXT + url + '?action=pageHistory&isAjax=true&pageNumber='+nextPage + TAB_ID_REQUEST,
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
