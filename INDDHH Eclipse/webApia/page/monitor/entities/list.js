var busEntIdOldAux;
var changeEntNumFilter;

function initPage(){
	//crear spinner de espere un momento
	sp = new Spinner($('gridBody').getParent(),{message:WAIT_A_SECOND});
	
	$$('div.fncDescriptionImage').each(function(e){
		var path = 'url(' + e.get('data-src') + ')'
		e.setStyle('background-image', path);
		e.setStyle('background-repeat', 'no-repeat');
		e.setStyle('width', '64px');
		e.setStyle('height', '64px');
	});
	
	busEntIdOldAux = null;
	changeEntNumFilter = false;
	
	var btnChngPrio = $('btnView');
	if (btnChngPrio){
		btnChngPrio.addEvent("click", function(e) {
			e.stop();
			//verificar que solo un registro este seleccionado
			if (selectionCount($('tableData')) > 1) {
				showMessage(GNR_CHK_ONLY_ONE, GNR_TIT_WARNING, 'modalWarning');
			} else if(selectionCount($('tableData')) == 0) {
				showMessage(GNR_CHK_AT_LEAST_ONE, GNR_TIT_WARNING, 'modalWarning');
			} else {
				//obtener el registro seleccionado			
				SYS_PANELS.showLoading();
				var id = getSelectedRows($('tableData'))[0].getRowId();
				window.location = CONTEXT + URL_REQUEST_AJAX + '?action=view&id=' + id + TAB_ID_REQUEST+"&dateFrom="+
					$('modifiedDateFilterStart').value+"&dateTo="+$('modifiedDateFilterEnd').value+"&busEntId="+
					$('entNumFilter').value+"&pageNumber="+$('navBarCurrentPage').value + '&isFromMonitor=true';
			}
		});
	}
	
	var btnDocuments = $('btnDocuments');
	if (btnDocuments){
		btnDocuments.addEvent("click",function(e){
			e.stop();
			//verificar que solo un registro est� seleccionado
			if (selectionCount($('tableData')) > 1) {
				showMessage(GNR_CHK_ONLY_ONE, GNR_TIT_WARNING, 'modalWarning');
			} else if(selectionCount($('tableData')) == 0) {
				showMessage(GNR_CHK_AT_LEAST_ONE, GNR_TIT_WARNING, 'modalWarning');
			} else {
				var id = getSelectedRows($('tableData'))[0].getRowId();
				var request = new Request({
					method: 'post',
					url: CONTEXT + URL_REQUEST_AJAX + '?action=getBusEntityInfoForMonDocument&isAjax=true&id=' + id + TAB_ID_REQUEST,
					onRequest: function() { SYS_PANELS.showLoading(); },
					onComplete: function(resText, resXml) { modalProcessXml(resXml); }
				}).send();
			}
		});
	}
	
	//['btnView','btnDocuments'].each(setTooltip);
	
	['orderByEntityId','orderByEntityNum','orderByUser'].each(function(ele){
		setAdmListTitle(ele);
	});
	
	['entIdFilter', 'entNumFilter', 'userFilter', 'usrLoginFilter', 'modifiedDateFilterStart', 'modifiedDateFilterEnd', 'createDateFilterStart', 'createDateFilterEnd' ].each(setAdmFilters);
	
	$('modifiedDateFilterStart').addEvent("change", setFilter);
	$('modifiedDateFilterEnd').addEvent("change", setFilter);
	$('createDateFilterStart').addEvent("change", setFilter);
	$('createDateFilterEnd').addEvent("change", setFilter);
	
	$('clearFilters').addEvent("click", function(e) {
		e.stop();
		['entIdFilter','entNumFilter','userFilter','usrLoginFilter'].each(clearFilter);		
		['modifiedDateFilterStart','modifiedDateFilterEnd','createDateFilterStart','createDateFilterEnd'].each(clearFilterDate);
		busEntIdOld = "";
		clearEntFilters();
		$('entIdFilter').setFilter();
	});
	
	//eventos para order
	['orderByEntityId','orderByEntityNum','orderByUser'].each(setOrder);
	
	initNavButtons(URL_REQUEST_AJAX,"",['entNumFilter','modifiedDateFilterStart'],'tableData');
	initAdminFav();
	initPinGridOptions();
	callNavigate();
	setFilter();
}

function setOrder(ele){
	ele = $(ele);
	if (ele) {
		ele.addEvent("click", function(e) {
			e.stop();
			callNavigateOrder(this.get('data-sortBy'),this);			
		});
	}
}

//establecer un filtro
var busEntIdOld = "";
function setFilter(back){
		var strObj = "";
		strObj+="filEntNum="+ $('entIdFilter').value;
		strObj+="&busEntId="+ $('entNumFilter').value;
		strObj+="&usrLoginCreated="+ $('userFilter').value;
		strObj+="&usrLogin="+ $('usrLoginFilter').value;
		strObj+="&dateFrom="+ $('modifiedDateFilterStart').value;
		strObj+="&dateTo="+ $('modifiedDateFilterEnd').value;
		strObj+="&dateCreatedFrom="+ $('createDateFilterStart').value;
		strObj+="&dateCreatedTo="+ $('createDateFilterEnd').value,
		strObj+="&filter="+(busEntIdOld==$('entNumFilter').value?false:true)+"&";
		strObj+="&back="+(back!=null?back:false)+"&";
		
		if ($('entNumFilter').value != ""){
			changeEntNumFilter = busEntIdOldAux;
			busEntIdOld = $('entNumFilter').value;
			busEntIdOldAux = $('entNumFilter').value;
			changeEntNumFilter = changeEntNumFilter != busEntIdOldAux;
		} else {
			busEntIdOld = null;
			changeEntNumFilter = true;
			busEntIdOldAux = null;
		}
		
		if (!checkReqFiltersNoMsg()){
			busEntIdOld = null;
			changeEntNumFilter = true;
			busEntIdOldAux = null;			
		}
		
		callNavigateFilterEntity(strObj,null);
}

function getMessage(){
	var aux =  "";
	var i = GNR_REQUIRED.indexOf("<TOK1>");
	if ($('modifiedDateFilterStart').value==""){
		aux = GNR_REQUIRED.substring(0,i)+ MODIFIED_DATE_FROM +GNR_REQUIRED.substring(i+6,GNR_REQUIRED.length); 
	}else{
		aux = GNR_REQUIRED.substring(0,i)+ ENT_NUM +GNR_REQUIRED.substring(i+6,GNR_REQUIRED.length);
	}
	return aux;
}

function callNavigateFilterEntity(strParams,url){
	hideMessage();
	
	if (checkReqFilters()){
		if(!url){
			url = URL_REQUEST_AJAX;
		}
		
		for (var i=0;i<listFecha.length;i++){
			strParams+=listFecha[i]+"="+$(listFecha[i]).value+"&";
		}
		for (var i=0;i<list.length;i++){
			strParams+=list[i]+"="+$(list[i]).value+"&";
		}
	
		var request = new Request({
			method: 'post',		
			url: CONTEXT + url + '?action=filterEntities&isAjax=true' + TAB_ID_REQUEST,
			onRequest: function() { sp.show(true); },
			onComplete: function(resText, resXml) { modalProcessXml(resXml); sp.hide(true); }
		}).send(strParams);
	} else {
		clearEntFilters();
	}
}

function loadFilters(){
	var ajaxCallXml = lastFunctionAjaxCall;
	if (ajaxCallXml != null) {
		var messages = ajaxCallXml.getElementsByTagName("messages");
		if (messages != null && messages.length > 0) {
			ajaxCallXml = messages[0].getElementsByTagName("result")[1];
		}
		callNavigateProcessXmlListResponse();
		drawFilters(ajaxCallXml);		
	}
}
var list = new Array();
var listFecha = new Array();

function drawFilters(xml){
	
	if (!changeEntNumFilter) return;
	
	clearEntFilters();
	
	var table = xml.getElementsByTagName("table");
	
	list = new Array();
	listFecha = new Array();
	listNum = new Array();
	
	if (table != null && table.length > 0 && table.item(0) != null) {
		if ($('filterDiv').firstChild){
			$('filterDiv').firstChild.dispose();
		}		

		var rows = table.item(0).getElementsByTagName("row");
		for(var i = 0; i < rows.length; i++) { 
			var row = rows.item(i);
			var cells = row.getElementsByTagName("cell");
			
			var nomCell = cells.item(0);
			var nom = nomCell.firstChild ? nomCell.firstChild.nodeValue : "";

			var idCell = cells.item(1);
			var id = idCell.firstChild ? idCell.firstChild.nodeValue : "";
			
			var tipoCell = cells.item(2);
			var tipo = tipoCell.firstChild ? tipoCell.firstChild.nodeValue : "";
			
			var valorCell = cells.item(3);
			var valor = valorCell.firstChild ? valorCell.firstChild.nodeValue : "";
			
			
			if (tipo=="S" || tipo=="N"){
				if (tipo=="N"){
					listNum.push(id);
				}

				//var div = new Element("div",{'class':'filter','html':nom+":&nbsp;"});
				var div = new Element("div",{'class':'filter'});
				new Element("span",{html:nom+":&nbsp;"}).inject(div);
				var ONKEYUP  = tipo=="N"?"checkNum('"+nom+"',this)":"";
				var input = new Element("input",{'id':id,'type':'text','value':(valor!="null"?valor:""),'onkeyup':ONKEYUP})
				
				input.inject(div);
				div.inject($('filterDiv'));
				
				list.push(id);
			}else{				
				i++;				
						row = rows.item(i);
				cells = row.getElementsByTagName("cell");

				var idCellF = cells.item(1);
				var idF = idCellF.firstChild ? idCellF.firstChild.nodeValue : "";
				
				valorCellF = cells.item(3);
				valorF = valorCellF.firstChild ? valorCellF.firstChild.nodeValue : "";
				
				//var div = new Element("div",{'class':'filter','html':nom+":&nbsp;"});
				var div = new Element("div",{'class':'filter'});
				new Element("span",{html: nom+":&nbsp;"}).inject(div);
				var ONKEYUP  = tipo=="N"?"checkNum('"+nom+"',this)":"";
				var inputI = new Element("input",{'id':id,'type':'text','value':(valor!="null"?valor:""),'maxlength':'10','size':'10','format':'d/m/Y','class':'datePicker filterInputDate'})				
				var inputF = new Element("input",{'id':idF,'type':'text','value':(valorF!="null"?valorF:""),'maxlength':'10','size':'10','format':'d/m/Y','class':'datePicker filterInputDate'})
				//var sep = new Element('span',{'html':' - '});
				
				inputF.inject(div);
				//sep.inject(div);
				div.innerHTML = div.innerHTML + " - ";
				inputI.inject(div);
				div.inject($('filterDiv'));
				
				listFecha.push(id);
				listFecha.push(idF);
			}
		}
	
	}
		
	for (var i=0;i<listFecha.length;i++){
		var datepicker = $(listFecha[i]);
		var img = new Element("img", {src: CONTEXT+"/css/base/img/calendar.png"});
		img.inject(datepicker,"after");

		var format = (datepicker.getAttribute("format") == null) ? 'd/m/Y' : datepicker.getAttribute("format");
		
		new DatePicker(datepicker, { 
			pickerClass: 'datepicker_vista', 
			allowEmpty: true, 
			format: format, 
			inputOutputFormat: format, 
			toggleElements: img, 
			
			onClose:function(dpk){
				dpk.fireEvent('change');
			}
		});
		
		setDateFilters(datepicker);
	}
	
	for (var i=0;i<list.length;i++){
		if (!listNum.contains(list[i])){
			ele = $(list[i]);
			ele.setFilter = setFilter;
			ele.oldValue = ele.value;
			ele.addEvent("keyup", function(e) {
				if (this.oldValue == this.value) return;
				if (this.timmer) $clear(this.timmer);
				this.oldValue = this.value;
				this.timmer = this.setFilter.delay(200, this);
			});
		}
	}
}

function checkNum(titulo,obj){
	var re = new RegExp(objNumRegExp);
	if (!re.test(obj.value) && obj.value!="") {
		var i = GNR_NUMERIC.indexOf("<TOK1>");
		var aux = GNR_NUMERIC.substring(0,i)+ titulo +GNR_NUMERIC.substring(i+6,GNR_NUMERIC.length);
		showMessage(aux, GNR_TIT_WARNING, 'modalWarning');
		obj.value="";
		return false;
	}else{
		obj.setFilter = setFilter;
		if (obj.oldValue == obj.value) return;
		obj.oldValue = obj.value;
		obj.timmer = obj.setFilter.delay(200, obj);
	}
	
}
function clearEntFilters(){
	for (var i=0;i<listFecha.length;i++){
		$(listFecha[i]).value ="";
		$(listFecha[i]).oldValue ="";
		$(listFecha[i]).getNext ().value =""; 
		$(listFecha[i]).getNext ().oldValue ="";
	}
	for (var i=0;i<list.length;i++){
		$(list[i]).value='';
		$(list[i]).oldValue='';
	}
	$('filterDiv').innerHTML = "";
	list = new Array();
	listFecha = new Array();
	busEntIdOld="";
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

function openMonDocument(busEntTitle, busEntRegInst){
	SYS_PANELS.closeAll();
	var tabContainer = window.parent.document.getElementById('tabContainer');
	var url = CONTEXT + URL_REQUEST_AJAX_MON_DOCUMENT + '?action=init&favFncId=54&preFilBusEntity=true&busEntTitle=' + busEntTitle + '&busEntRegInst=' + busEntRegInst;
	tabContainer.addNewTab(MON_DOC_TAB_TITLE,url,null);		
}
