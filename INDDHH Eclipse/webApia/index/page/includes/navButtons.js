var currentPrefix=""; //esto es para cuando hay muchos modals, saber cual disparo, para con ese prefijo ir a buscar la tabla y los botones

var arrReqFilters;
var tbodyName;

function initNavButtons(URL,prefix,reqFilters,tbodyName) {
	if (! URL) URL = URL_REQUEST_AJAX;
	if (!prefix) prefix="";
	
	if (!reqFilters || reqFilters.length == 0){
		arrReqFilters = null;
	} else {
		arrReqFilters = reqFilters;
	}
	if (!tbodyName) tbodyName = 'tableData';
	this.tbodyName = tbodyName;
	
	var navFirst = $('navFirst' + prefix);
	var navPrev = $('navPrev' + prefix);
	var navNext = $('navNext' + prefix);
	var navLast = $('navLast' + prefix);
	var navRefresh = $('navRefresh' + prefix);
	var navBarCurrentPage = $('navBarCurrentPage' + prefix);
	
	if (navFirst) {
		if(URL){navFirst.url = URL;}
		navFirst.tooltip(GNR_NAV_FIRST, { mode: 'auto', width: 100, hook: 0 });
		navFirst.addEvent("click", function(e) {
			e.stop();
			if (checkReqFilters()){
				currentPrefix = prefix;
				callNavigate(1,this.url, prefix);
			}
		});
	}

	if (navPrev) {
		if(URL){navPrev.url = URL;}
		navPrev.tooltip(GNR_NAV_PREV, { mode: 'auto', width: 100, hook: 0 });
		navPrev.addEvent("click", function(e) {
			e.stop();
			if (checkReqFilters()){ 
				currentPrefix = prefix;
				var nextPage = parseInt($('navBarCurrentPage' + prefix).value)-1;
				if(nextPage<=0){nextPage=1;}
				callNavigate(nextPage,this.url, prefix);
			}
		});
	}

	if (navNext) {
		if(URL){navNext.url = URL;}
		navNext.tooltip(GNR_NAV_NEXT, { mode: 'auto', width: 100, hook: 0 });
		navNext.addEvent("click", function(e) {
			e.stop();
			if (checkReqFilters()){
				currentPrefix = prefix;
				var nextPage = parseInt($('navBarCurrentPage' + prefix).value)+1;
				var maxPage = parseInt($('navBarPageCount' + prefix).innerHTML);
				if(nextPage>maxPage){nextPage=maxPage;}
				callNavigate(nextPage,this.url, prefix)
			}
		});
	}

	if (navLast) {
		if(URL){navLast.url = URL;}
		navLast.tooltip(GNR_NAV_LAST, { mode: 'auto', width: 100, hook: 0 });
		navLast.addEvent("click", function(e) {
			e.stop();
			if (checkReqFilters()){
				currentPrefix = prefix;
				var nextPage;
				if($('navBarPageCount' + prefix).innerHTML.indexOf("<b>") == -1){
					nextPage = parseInt($('navBarPageCount' + prefix).innerHTML);
				}else{
					var str = $('navBarPageCount' + prefix).innerHTML;
					var idx = str.indexOf("*</b>");
					str = str.substring(3,idx);
					nextPage = parseInt(str);
				}
				callNavigate(nextPage,this.url, prefix)
			}
		});
	}

	if (navRefresh) {
		if(URL){navRefresh.url = URL;}
		navRefresh.tooltip(GNR_NAV_REFRESH, { mode: 'auto', width: 100, hook: 0 });
		navRefresh.addEvent("click", function(e) {
			if (e) e.stop();
			if (checkReqFilters()){
				currentPrefix = prefix;
	//			var nextPage = parseInt($('navBarCurrentPage' + prefix).value);
	//			callNavigate(nextPage,this.url);
				var request = new Request({
					method: 'post',
					url: CONTEXT + this.url + '?action=refresh&isAjax=true' + TAB_ID_REQUEST + "&timestamp=" + newAjaxCall(),
					onRequest: function() {
						var spinner = window['sp_' + prefix] || sp;
						if (spinner) spinner.show(true); 
					},
					onComplete: function(resText, resXml) { 
						if (lastActionCall(resXml)) { 
							modalProcessXml(resXml); 
							var spinner = window['sp_' + prefix] || sp;
							if (spinner) spinner.hide(true); 
						} 
					}
				}).send();
			}
		});
	}
	
	if (navBarCurrentPage) {
		if (URL) { navBarCurrentPage.url = URL; }
		navBarCurrentPage.navegateDelay = null;
		navBarCurrentPage.doNavegate = function() {
			if (checkReqFilters()){
				currentPrefix = prefix;
				var nextPage = parseInt(this.value);
				var maxPage = parseInt($('navBarPageCount' + (prefix ? prefix : '')).innerHTML);
				
				if (nextPage && nextPage > maxPage) nextPage = maxPage;
				
				callNavigate(nextPage,this.url, prefix);
			}
		}
		navBarCurrentPage.addEvent("keyup", function(key) {
			var charCode = key.code;
			if((charCode < 48 || charCode > 57) && (charCode < 96 || charCode > 105)){
				var text = this.value;
				this.value = text.substr(0,text.length-1);
			}
			
			if (48 <= charCode && charCode <= 57 || 96 <= charCode && charCode <= 105) {
				if (this.navegateDelay) $clear(this.navegateDelay);
				this.navegateDelay = this.doNavegate.delay(250, this);
			}
		});
		navBarCurrentPage.addEvent("change", function(e) {
			if (e) e.stop();
			this.doNavegate();
		});
	}
	
	initGridScroll();
}

function initGridScroll() {
	var gridHeader = $('gridHeader');
	if (gridHeader) {
		var table = gridHeader.getChildren('table');
		if (table) {
			var gridBody = $('gridBody');
			gridBody.tableHeader = table;
			gridBody.addEvent('scroll', function() {			
				this.tableHeader.setStyle('left', - this.scrollLeft);
			});
			gridBody.addEvent('custom_scroll', function(left) {			
				this.tableHeader.setStyle('left', left);
			});
		}
	}
}

function callNavigateRefresh(prefix) {
	if(!prefix){prefix="";}
	var navRefresh = $('navRefresh'+prefix);
	if (navRefresh) $('navRefresh'+prefix).fireEvent('click');
}

function callNavigate(nextPage,url,prefix){
	if (checkReqFilters()){
		if (!url) url = URL_REQUEST_AJAX;
		if (! nextPage) nextPage = "";
		if (prefix) currentPrefix = prefix;
		var request = new Request({
			method: 'post',
			url: CONTEXT + url + '?action=page&isAjax=true&pageNumber='+nextPage + TAB_ID_REQUEST + "&timestamp=" + newAjaxCall(),
			onRequest: function() { 
//				if (sp) sp.show(true);
				var spinner = window['sp_' + prefix] || sp;
				if (spinner) spinner.show(true); 
			},
			onComplete: function(resText, resXml) { 
				if (lastActionCall(resXml)) {
					
					var parentGridBody = $('tableData' + (prefix ? prefix : ''));
					if(parentGridBody) parentGridBody = parentGridBody.getParent('div.gridBody');
					if(parentGridBody) {
						var v_scroller = parentGridBody.retrieve('custom_v_scroller');
						if(v_scroller) v_scroller.setScroll(0);
					}
					
					modalProcessXml(resXml); 
//					if (sp) sp.hide(true); 
					var spinner = window['sp_' + prefix] || sp;
					if (spinner) spinner.hide(true); 
				} 
			}
		}).send();
	}
}

function callNavigateFilter(objParams, strParams, url, prefix){
	hideMessage();
	
	if (checkReqFilters()){
		if(!url){
			url = URL_REQUEST_AJAX;
		}
		var request = new Request({
			method: 'post',
			data: objParams,
			url: CONTEXT + url + '?action=filter&isAjax=true' + TAB_ID_REQUEST + "&timestamp=" + newAjaxCall(),
			onRequest: function() { 
//				if (sp) sp.show(true);
				var spinner = window['sp_' + prefix] || sp;
				if (spinner) spinner.show(true); 
			},
			onComplete: function(resText, resXml) { 
				if (lastActionCall(resXml)) { 
					modalProcessXml(resXml); 
//					if (sp) sp.hide(true);
					var spinner = window['sp_' + prefix] || sp;
					if (spinner) spinner.hide(true); 
				} 
			}
		}).send(strParams);
	}
}

var LAST_CALL_TIMESTAMP = null;
function newAjaxCall() {
	LAST_CALL_TIMESTAMP = new Date().getTime();
	return LAST_CALL_TIMESTAMP;
}

function lastActionCall(xml) {
	var xmlTimestamp;
	if(Browser.ie && xml.firstChild.baseName == "xml") {
		xmlTimestamp = xml.firstChild.nextSibling.getAttribute("timestamp");
	} else {
		xmlTimestamp = xml.firstChild.getAttribute("timestamp");
	}
	
	if (xmlTimestamp == '') xmlTimestamp = null;
	
	var result = LAST_CALL_TIMESTAMP == xmlTimestamp
	
	return result;
}

function callNavigateOrder(order,obj,url, prefix){
	hideMessage();
	
	if (checkReqFilters()){
		if(!url){
			url = URL_REQUEST_AJAX;
		}
		var request = new Request({
			method: 'post',
			data: {
				orderBy:order
			},
			url: CONTEXT + url + '?action=sort&isAjax=true' + TAB_ID_REQUEST + "&timestamp=" + newAjaxCall(),
			onRequest: function() { 
//				if (sp) sp.show(true);
				var spinner = window['sp_' + prefix] || sp;
				if (spinner) spinner.show(true);
			},
			onComplete: function(resText, resXml) { 
				if (lastActionCall(resXml)) { 
					modalProcessXml(resXml); 
					removeOrderByClass(obj); 
					setOrderByClass(obj); 
//					sp.hide(true); 
					var spinner = window['sp_' + prefix] || sp;
					if (spinner) spinner.hide(true); 
				} 
			}
		}).send();
	}
}

function callAdditionalProcessXmlInfoResponse() {
	var ajaxCallXml = getLastFunctionAjaxCall();
	if (ajaxCallXml != null) {
		//var messages = ajaxCallXml.getChildren("messages");
		var messages = ajaxCallXml.childNodes; //IE Friendly
		//var rowXml = ajaxCallXml.getChildren("messages")[0].getChildren("row")[0];
		var rowXml = ajaxCallXml.childNodes[0].childNodes[0]; //IE Friendly
		var id = rowXml.getAttribute("id");
		
		var row = $('adtInfoRow' + id);
		var td = row.getFirst("td");
		row.style.height = "";
		
		//var cells = rowXml.getChildren("cell");
		var cells = rowXml.childNodes; //IE Friendly
		for (var i = 0; i < cells.length; i++) {
			var cell = cells[i];
			var newLine = cell.getAttribute("newline") == "true";
			
			var className = cell.getAttribute("class");
			if (!className){
				className = "title";
			}
			var name = cell.getAttribute("name") + ":";
			var content = cell.firstChild ? cell.firstChild.nodeValue : "";
			var title = cell.getAttribute("title") != null && cell.getAttribute("title") != "" ? cell.getAttribute("title") : "";
			
			var div = new Element("div", {'class': 'container'});
			new Element("div", {'class': className, html: name, 'title': title}).inject(div);
			new Element("div", {'class': 'content', html: content}).inject(div);
			
			if (newLine){ new Element("div",{'class':'clear'}).inject(td); }
			
			div.inject(td);
		}
		
		var tbody = row.parentNode;
		addScrollTable(tbody);
	}
}

function callNavigateProcessXmlListResponse(){
	var ajaxCallXml = getLastFunctionAjaxCall();
	if (ajaxCallXml != null) {
		var messages = ajaxCallXml.getElementsByTagName("messages");
		
		ajaxCallXml = null;
		
		if (messages != null && messages.length > 0) {
			ajaxCallXml = messages[0].getElementsByTagName("result")[0];
		}
			
		var pageCount = ajaxCallXml.getElementsByTagName("pageInfo");
		var pages = pageCount.item(0).attributes.getNamedItem("pageCount").value;
		var currentPage = pageCount.item(0).attributes.getNamedItem("currentPage").value;
		var totalRecords =  pageCount.item(0).attributes.getNamedItem("totalRecords").value;
		var reachedMax =  (pageCount.item(0).attributes.getNamedItem("reachedMax") != null) ? pageCount.item(0).attributes.getNamedItem("reachedMax").value == 'true' : false;
		var selectOnlyOne = pageCount.item(0).attributes.getNamedItem("selectOnlyOne").value;
		var avoidNoRecordMessage = (pageCount.item(0).attributes.getNamedItem("avoidNoRecordsMessage") != null) ? pageCount.item(0).attributes.getNamedItem("avoidNoRecordsMessage").value : "";
		var moreData = (pageCount.item(0).attributes.getNamedItem("hasMore") != null) ? pageCount.item(0).attributes.getNamedItem("hasMore").value == "true" : false;
		var amount = (pageCount.item(0).attributes.getNamedItem("amount") != null) ? pageCount.item(0).attributes.getNamedItem("amount").value : "";
		
		currentPrefix = pageCount.item(0).attributes.getNamedItem("prefix").value;
		
		var navBarPageCount = $('navBarPageCount' + currentPrefix);
		var navBarCurrentPage = $('navBarCurrentPage' + currentPrefix);
		var hasMore = $('hasMore' + currentPrefix);
		var amountRecords = $('amountRecords' + currentPrefix);
		var navigator = $('navigator' + currentPrefix);
		
		if (reachedMax) pages = '<b>' + pages + ' *</b>';
		
		if (navBarPageCount) navBarPageCount.innerHTML = pages;
		if (navBarCurrentPage) navBarCurrentPage.value = currentPage;
		if (hasMore) if (moreData) { hasMore.removeClass('hidden'); } else { hasMore.addClass('hidden'); }
		if (amountRecords) {
			if (amount && amount != "") {
				amountRecords.removeClass('hidden');
				$('amountRecordsValue').innerHTML = amount;
			} else {
				amountRecords.addClass('hidden');
			}
		}
		
		var table = $('tableData' + currentPrefix);
		var gridBody = $('gridBody');
		if (! gridBody) gridBody = $('mdlGridBody');
		
		loadTable(table,ajaxCallXml,selectOnlyOne);
		if (gridBody && gridBody.noDataMessage) $(gridBody.noDataMessage).setStyle('display','none');
		
		if (navigator) {
			if(totalRecords>0){
				navigator.tooltip(GNR_TOT_RECORDS+": "+totalRecords + (reachedMax ? '<br>' + GNR_TOT_RECORDS_REACHED : ''), { mode: 'auto', width: 140, hook: 0 });
			} else if (avoidNoRecordMessage == null || avoidNoRecordMessage == "" || avoidNoRecordMessage == "false"){
				//showMessage(GNR_MORE_RECORDS);
				
				if (gridBody) {
					if (gridBody.noDataMessage) {gridBody.noDataMessage.dispose();}
					gridBody.noDataMessage = new Element('div', {'class': 'noDataMessage', html: GNR_MORE_RECORDS}).inject(gridBody);
					gridBody.noDataMessage.setStyle('display','');
					gridBody.noDataMessage.position( {
						relativeTo: gridBody,
						position: 'upperLeft'
					})
				}
				
				navigator.tooltip(GNR_MORE_RECORDS, { mode: 'auto', width: 140, hook: 0 });
			}
		}
		currentPrefix="";	
	}
}

function checkReqFilters(){
	var ok = true;
	if (arrReqFilters && arrReqFilters.length > 0){
		for (var i = 0; i < arrReqFilters.length && ok; i++){
			var filter = $(arrReqFilters[i]);
			if (filter && (filter.value == null || filter.value == "")){
				ok = false;
			}
		}	
	}
	if (!ok) {
		//showMessage(MUST_FILTER, GNR_TIT_WARNING, 'modalWarning');
		var gridBody = $('gridBody');
		if (! gridBody) gridBody = $('mdlGridBody');
		var navigator = $('navigator' + currentPrefix);
		
		if (gridBody) {
			if (gridBody.noDataMessage) {gridBody.noDataMessage.dispose();}
			gridBody.noDataMessage = new Element('div', {'class': 'noDataMessage', html: MUST_FILTER}).inject(gridBody);
			gridBody.noDataMessage.setStyle('display','');
			/*gridBody.noDataMessage.position( {
				relativeTo: gridBody,
				position: 'upperLeft'
			});*/
		}
		navigator.tooltip(MUST_FILTER, { mode: 'auto', width: 140, hook: 0 });
		
		clearGrid();
	}	
	return ok;
}

function checkReqFiltersNoMsg(){
	var ok = true;
	if (arrReqFilters && arrReqFilters.length > 0){
		for (var i = 0; i < arrReqFilters.length && ok; i++){
			var filter = $(arrReqFilters[i]);
			if (filter && (filter.value == null || filter.value == "")){
				ok = false;
			}
		}	
	}
	return ok;
}

function clearGrid(){
	var table = $(tbodyName);
	if (table) table.set('html', '');
	if ($('navBarCurrentPage')) $('navBarCurrentPage').value=0;
	if ($('navBarPageCount')) $('navBarPageCount').innerHTML=0;
}