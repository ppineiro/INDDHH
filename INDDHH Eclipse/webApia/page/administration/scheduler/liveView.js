function initPage(){
	getTabContainerController().changeTabState(TAB_ID, false); 
	
	sp = new Spinner($('gridBody').getParent(),{message:WAIT_A_SECOND});
	
	var btnBinding = $('btnBinding');
	var btnBackToList = $('btnBackToList');
	var btnCloseTab = $('btnCloseTab');
	
	if (btnBinding) {
		btnBinding.addEvent("click", function(e) {
			e.stop();
			// verificar que solo un usuario est� seleccionado
			if (selectionCount($('tableData')) > 1) {
				showMessage(GNR_CHK_ONLY_ONE, GNR_TIT_WARNING, 'modalWarning');
			} else if (selectionCount($('tableData')) == 0) {
				showMessage(GNR_CHK_AT_LEAST_ONE, GNR_TIT_WARNING, 'modalWarning');
			} else {
				var id = getSelectedRows($('tableData'))[0].getRowId();
				
				var request = new Request({
					method : 'post',
					url : CONTEXT + URL_REQUEST_AJAX + '?action=showBinding&isAjax=true&id=' + id + TAB_ID_REQUEST,
					onRequest : function() { SYS_PANELS.showLoading(); },
					onComplete : function(resText, resXml) { modalProcessXml(resXml); }
				}).send();
			}
		});
	}
	
	if (btnCloseTab) {
		btnCloseTab.addEvent("click", closeCurrentTab);
	}
	
	if (btnBackToList){
		btnBackToList.addEvent("click", function(e) {
			e.stop();
			new Spinner(document.body, { message : WAIT_A_SECOND }).show(true);
			window.location = CONTEXT + URL_REQUEST_AJAX + '?action=list' + TAB_ID_REQUEST;
		});
	}
	
	refreshData();
}

function refreshData() {
	var request = new Request({
		method : 'post',
		url : CONTEXT + URL_REQUEST_AJAX + '?action=liveData&isAjax=true&id=' + TAB_ID_REQUEST,
		onComplete : function(resText, resXml) { processData(resXml); }
	}).send();
}

function closeCurrentTab() {
	getTabContainerController().removeActiveTab();
}

var tdWidths = null;

function processAdtData(xml) {
	var rows = xml.getElementsByTagName("scheduler");
	for(var i = 0; i < rows.length; i++) {
		var row = rows.item(i);
		
		var id = row.getAttribute("id");
		var end = row.getAttribute("end");
		var next = row.getAttribute("next");
		var progress = row.getAttribute("progress");
		
		$('schEnd' + id).innerHTML = end;
		$('schNext' + id).innerHTML = next;
		$('schProgress' + id).innerHTML = progress;
	}
}

function processData(xml) {
	
	var object = $('tableData');
	var gridBody = $('gridBody');
	
	if (tdWidths == null) {
		var parent = object.getParent();
		var thead = parent.getFirst("thead");
		var theadTr = thead ? thead.getFirst("tr") : null;
		var headers = theadTr ? thead.getElements("th") : null;
		
		tdWidths = headers ? new Array(headers.length) : null;
		
		if (headers) {
			for (var i = 0; i < headers.length; i++) {
				tdWidths[i] = headers[i].getStyle('width');
				if (! tdWidths[i]) tdWidths[i] = headers[i].width;
				if (! tdWidths[i]) tdWidths[i] = headers[i].getAttribute("width");
			}
			
			for (var i = 0; i < tdWidths.length; i++) {
				value = tdWidths[i];
				if (value.indexOf("px") != -1) value = value.substring(0, value.indexOf("px"));
				value = parseInt(value);
			}
		}
	}
	var elementsAdded = false;
	var lastCheck = new Date().getTime();
	var rows = xml.getElementsByTagName("scheduler");
	for(var i = 0; i < rows.length; i++) {
		var row = rows.item(i);
		
		var id = row.getAttribute("id");
		var schBusClaName = row.getAttribute("schBusClaName");
		var busClaName = row.getAttribute("busClaName");
		var start = row.getAttribute("start");
		var end = row.getAttribute("end");
		var next = row.getAttribute("next");
		var progress = row.getAttribute("progress");
		var message = getTagContent(row);
		
		if (progress == null) progress = "";
		
		var tr = $('sch' + id);
		
		if (tr != null) {
			tr.lastUpdate = lastCheck;
			$('schEnd' + id).innerHTML = end;
			$('schProgress' + id).innerHTML = progress;
			var schMessage = $('schMessage' + id);
			schMessage.innerHTML = message;
			schMessage.scrollTop = schMessage.scrollHeight;
			if (message == '') schMessage.style.display = 'none';
			if (message != '') schMessage.style.display = '';
			
		} else {
			elementsAdded = true;
			var tr = new Element('tr', {'id': 'sch' + id, 'class': 'schedulerExecution'}).inject(object);
			tr.addClass('selectableTR');
			if (i%2==0) tr.addClass("trOdd");
			tr.lastUpdate = lastCheck;
			tr.schBusClaId = id;
			
			tr.getRowId = function () { return this.schBusClaId; };
			tr.inject(object);
			
			new Element("td", {html: schBusClaName, styles: {'width': tdWidths[0]}}).inject(tr);
			new Element("td", {html: busClaName, styles: {width: tdWidths[1]}}).inject(tr);
			new Element("td", {html: start, styles: {width: tdWidths[2]}}).inject(tr);
			new Element("td", {html: end, id: "schEnd" + id, styles: {width: tdWidths[3]}}).inject(tr);
			new Element("td", {html: next, id: "schNext" + id, styles: {width: tdWidths[4]}}).inject(tr);
			new Element("td", {html: progress, id: "schProgress" + id, styles: {width: tdWidths[5]}}).inject(tr);
			
			tr.trMessage = new Element('tr').inject(object);
			if (i%2==0) tr.trMessage.addClass("trOdd");
			if (i == (rows.length - 1)) tr.trMessage.addClass("lastTr");
			
			var tdMessage = new Element("td", {'class' : 'additionalInfo', colSpan: 6}).inject(tr.trMessage);
			var divMessage = new Element("div", {'id': 'schMessage' + id, colSpan: 6, html: message, styles: {overflow: 'auto', height: '100px'}}).inject(tdMessage);
			divMessage.scrollTop = divMessage.scrollHeight;
			if (message == '') divMessage.style.display = 'none';
			
			//Agregar comportamiento de click sobre el registro
			tr.addEvent("click",function(e){
	    		var parent = this.getParent();
    			if (parent.lastSelected && parent.lastSelected != this) {
    				parent.lastSelected.removeClass("selectedTR");
	    		}
	    		
    			parent.lastSelected = this;
	    		if (!this.hasClass("selectedTR")) {
	    			this.addClass("selectedTR");
    	    	}
	    		
	    		var btnBinding = $('btnBinding');
	    		if (! btnBinding.hasClass('suggestedAction')) {
		    		var btnBindingButton = (btnBinding) ? btnBinding.getChildren('button')[0] : null;
		    		var btnBackToList = $('btnBackToList');
		    		var btnBackToListButton = (btnBackToList) ? btnBackToList.getChildren('button')[0] : null;
		    		
		    		btnBinding.addClass('suggestedAction'); 
		    		btnBindingButton.addClass('suggestedAction'); 
		    		btnBackToList.removeClass('suggestedAction'); 
		    		btnBackToListButton.removeClass('suggestedAction');
	    		}
		    });
		}
	}
	
	//Controle de los que se deben eliminar
	var keepEndedFor = $('keepEndedFor');
	var deleteAfter = keepEndedFor.options[keepEndedFor.selectedIndex].value.toInt() * 1000 * 60;
	
	var requestInformationFor = "";
	
	//Ver cuales se deben eliminar
	object.getElements('tr.schedulerExecution').each(function(ele) {
		if (ele.lastUpdate != lastCheck && (lastCheck - ele.lastUpdate > deleteAfter)) {
			elementsAdded = true;
			ele.trMessage.destroy();
			ele.destroy();
		} else if (ele.lastUpdate != lastCheck && ! ele.moreInfomrationRequested) {
			ele.moreInfomrationRequested = true;
			if (requestInformationFor.length > 0) requestInformationFor += "&";
			requestInformationFor += "id=" + ele.schBusClaId;
		}
	});
	
	//Perdir m�s informaci�n
	if (requestInformationFor != "") {
		var request = new Request({
			method : 'post',
			url : CONTEXT + URL_REQUEST_AJAX + '?action=adtInformation&isAjax=true&id=' + TAB_ID_REQUEST,
			/*onRequest : function() { },*/
			onComplete : function(resText, resXml) { processAdtData(resXml); }
		}).send(requestInformationFor);
	}
	
	//Agregar el scroll si corresponde
	if (elementsAdded) {
		addScrollTable(object);
		var i = 0;
		object.getElements('tr.schedulerExecution').each(function(ele) {
			if (i%2==0) {
				ele.addClass("trOdd");
				ele.trMessage.addClass("trOdd");
			} else {
				ele.removeClass("trOdd");
				ele.trMessage.removeClass("trOdd");
			}
			i++;
		});
	}
	
	
	var refreshEvery = $('refreshEvery');
	var delay = refreshEvery.options[refreshEvery.selectedIndex].value.toInt() * 1000;
	refreshData.delay(delay);
}

