var FLAG_AUTO_FILTER;

function suggestSearchButton() {
	var btnSearch = $('btnSearch');
	if (btnSearch) {
		btnSearch.addClass('suggestedAction');
		btnSearch.getChildren('button').addClass('suggestedAction');
	}
}

function initQueryButtons() {
	//crear spinner de espere un momento
	sp = new Spinner($('gridBody').getParent('.gridContainer'),{message:WAIT_A_SECOND});
	ADMIN_SPINNER = sp;

	var queryFormAction = $('queryFormAction');
	queryFormAction.eventFilter = new Element('input', {'type': 'hidden', 'name': 'eventFilter', 'id': 'queryFormEventFilter'});
	queryFormAction.eventFilter.inject(queryFormAction, 'after');
	
	var btnSearch = $('btnSearch');
	var btnFilterType = $('btnFilterType');
	var clearFilters = $('clearFilters');
	var btnExport = $('btnExport');
	try{
	frameElement.fireEvent('unblock'); //desbloquear botones si está en un modal
	frameElement.fireEvent('setFocus'); //dar foco al modal
	}catch(err){}
	if (btnSearch) {
		btnSearch.addEvent('click', function(e) {
			if (e) e.stop();
			
			if (toBoolean(this.getAttribute("hideFilters")) && $('modalAccessFilters')){
				$('optionsContainer').removeClass("open");
			}
			
			ADMIN_SPINNER.show(true);
			frameElement.fireEvent('block'); //bloquear botones si está en un modal
			
			$('queryFormAction').value = 'filter';
			
			$('queryForm').submit();
			
			dirtyFilters = false;
		}).addEvent('keypress', Generic.enterKeyToClickListener);
	}
	
	if (btnFilterType) {
		btnFilterType.addEvent('click', function(evt){
			var request = new Request({
				method: 'post',
				url: CONTEXT + URL_REQUEST_AJAX + "?action=filterOptions" + TAB_ID_REQUEST,
				onRequest: function() { /* SYS_PANELS.showLoading(); */ },
				onComplete: function(resText, resXml) { modalProcessXml(resXml); }
			}).send();
		});
	}
	
	if (clearFilters) {
		clearFilters.addEvent('click', function(evt){
			$$('input.queryFilter').each(function(ele){ ele.value = ""; ele.oldValue = ""; });
			$$('select.queryFilter').each(function(ele){ ele.selectedIndex = ""; ele.oldValue = ""; });
			suggestSearchButton();
			
			var request = new Request({
				method: 'post',
				url: CONTEXT + URL_REQUEST_AJAX + "?action=clearFilter" + TAB_ID_REQUEST + "&timestamp=" + newAjaxCall(),				
				onRequest: function() { if (sp) sp.show(true); },
				onComplete: function(resText, resXml) { if (lastActionCall(resXml)) { modalProcessXml(resXml); if (sp) sp.hide(true); } }
			}).send();
		}).addEvent('keypress', Generic.enterKeyToClickListener);
	}
	
	$$('.allowSort').each(function(ele){ 
		ele.addEvent('click', function(evt){
			if(evt) evt.stop();
			ADMIN_SPINNER.show(true);
			
			document.location = CONTEXT + URL_REQUEST_AJAX + "?action=sort" + "&orderBy=" + this.get('data-sortBy') + TAB_ID_REQUEST;
		}); 
	});
	
	$$('.fireEventOnChange').each(function(ele){
		ele.addEvent('change', function(evt){
			if(evt) evt.stop();
			ADMIN_SPINNER.show(true);
			
			var queryFormAction = $('queryFormAction');
			queryFormAction.value = 'eventOnChange';
			queryFormAction.eventFilter.value = this.name;
			$('queryForm').submit();
		});
	});
	
	if (btnExport) {
		btnExport.addEvent('click', function(evt){
			var request = new Request({
				method: 'post',
				url: CONTEXT + URL_REQUEST_AJAX + "?action=export" + TAB_ID_REQUEST,
				onRequest: function() { /* SYS_PANELS.showLoading(); */ },
				onComplete : function(resText, resXml) {
					modalProcessXml(resXml);
				}
			}).send();

		});
	}
	
	//['btnSearch','btnFilterType','btnExport'].each(setTooltip);
		
	
	var filterParams = {};
	if (FLAG_AUTO_FILTER){
		filters = document.getElementsByClassName('queryFilter');
		Array.each(filters, function(filter){			
			filter.oldValue = filter.value;
			if (filter.tagName == 'SELECT') {
				filter.addEvent('change', function(e){
					e.stop();
					
					setFiltersQuery.delay(200, this);
				})
			}
			else {	// if (filter.tagName == 'INPUT')
				filter.addEvent('keyup', function(e){
					e.stop();
					
					if (this.oldValue == this.value) return;
					if (this.timmer) $clear(this.timmer);
					this.oldValue = this.value;
					this.timmer = setFiltersQuery.delay(200, this);
				})
			}
			
		})
	}

	function setFiltersQuery(){
		for(var i=0; i<filters.length; i++){
			filterParams[filters[i].id] = filters[i].value;
		}
		
		var request = new Request({
			method: 'post',
			data: filterParams,
			url: CONTEXT + URL_REQUEST_AJAX + '?action=filterQuery&isAjax=true' + TAB_ID_REQUEST,
			onRequest: function() { sp.show(true); },
			onComplete: function(resText, resXml) { modalProcessXml(resXml); sp.hide(true); }
		}).send();	
	}	
	
	
	initPinGridOptions();
	
	//CAM_13326
	checkColumnsWidth();
}

function startDownload(btn) {
	btn = $(btn);
	var form = $(btn.get('data-formId'));
	
	var queryDownload = $('queryDownload');

	WaitForIFrame();

    function WaitForIFrame() {
    	
    	if(Cookie.read("userQry" + TAB_ID)) {
    		Cookie.dispose("userQry" + TAB_ID);
    		//Se agreg� el contexto, ya que no se borraba la cookie
    		Cookie.dispose("userQry" + TAB_ID, {path : CONTEXT});
    		SYS_PANELS.closeAll();
    	} else {
    		setTimeout(WaitForIFrame, 200);
    	}
    }

	form.set('target','queryDownload');
	form.submit();
	
	SYS_PANELS.showLoading();
}


function closeModalExport(){
	SYS_PANELS.closeAll();
}

function controllAtLeastOneSelected() {
	var tableData = $('tableData');
	
	if (selectionCount($('tableData')) == 0) {
		showMessage(GNR_CHK_AT_LEAST_ONE, GNR_TIT_WARNING, 'modalWarning');
		return null;
	} else {
		var result = "";
		var selected = getSelectedRows($('tableData'));
		if (selected != null) {
			for (var i = 0; i < selected.length; i++) {
				if (result != "") result += "&";
				result += "id=" + selected[i].getRowId();
			}
		}
		return result;
	}
}

function controllOneSelected() {
	var tableData = $('tableData');
	
	if (selectionCount(tableData) > 1) {
		showMessage(GNR_CHK_ONLY_ONE, GNR_TIT_WARNING, 'modalWarning');
		return null;
	} else if (selectionCount($('tableData')) == 0) {
		showMessage(GNR_CHK_AT_LEAST_ONE, GNR_TIT_WARNING, 'modalWarning');
		return null;
	} else {
		var result = "";
		var selected = getSelectedRows($('tableData'));
		if (selected != null) {
			for (var i = 0; i < selected.length; i++) {
				if (result != "") result += "&";
				result += "id=" + selected[i].getRowId();
			}
		}
		return result;
	}
}

var dirtyFilters = false;
function  customizeRefresh(){	
	//Se elimina el evento generico de refresh para personalizarlo
	var navRefresh = $('navRefresh');
	if (navRefresh){
		navRefresh.removeEvents('click');
		navRefresh.addEvent("click", function(e) {
			if (e) e.stop();
			if (checkReqFilters()){
				var btnSearch = $('btnSearch');
				if (!dirtyFilters || !btnSearch){ //no se tocaron a mano los filtros
					var request = new Request({
						method: 'post',
						url: CONTEXT + this.url + '?action=refresh&isAjax=true' + TAB_ID_REQUEST + "&timestamp=" + newAjaxCall(),
						onRequest: function() { if (sp) sp.show(true); },
						onComplete: function(resText, resXml) { if (lastActionCall(resXml)) { modalProcessXml(resXml); if (sp) sp.hide(true); } }
					}).send();
				} else {
					btnSearch.fireEvent("click");
				}
				dirtyFilters = false;
			}
		});
	}
	
	//obtener todos los filtros y modificar el onchange para que marcar dirtyFilters
	$$('.queryFilter').addEvent('change',function(e){
		dirtyFilters = true;
	});
}

function downloadDocument(docId) {
	var anchor = new Element('a', {target: '_new', href: 
		CONTEXT + URL_REQUEST_AJAX + '?action=downloadDocument&docId=' + docId + TAB_ID_REQUEST
	});
	
	anchor.inject(document.body);
	
	if(anchor.click) {
		anchor.click();
	} else if(document.createEvent) {
	    var eventObj = document.createEvent('MouseEvents');
	    eventObj.initEvent('click', true, true);
	    anchor.dispatchEvent(eventObj);
	}
	
	anchor.destroy();
}

function checkColumnsWidth(){
	var widths = [];
	var mustUpdateGridWidth = false;
	
	var ths = $('gridHeader').getElement('tr.header').getElements('th');
	ths.each(function(th) {
		var divContainer = th.getFirst();
		var divEle = divContainer.getFirst();
		var width = divContainer.getStyle('width');
		var autoFit = divContainer.getAttribute('data-autofit')=="true";		
		if (autoFit && divEle.scrollWidth > divEle.offsetWidth){
			mustUpdateGridWidth = true;
			width = divEle.scrollWidth + 15 + 'px';
			divContainer.setStyle('width', width);
		}
		widths.push(width);
	})
	
	
	if (mustUpdateGridWidth){
		ths = $('gridBody').getElements('th');
		var trFilter = $('gridHeader').getElement('tr.filter');
		if (trFilter) var thsFilter = trFilter.getElements('th');
		
		for(var i=0; i<ths.length; i++){
			ths[i].setStyle('width', widths[i]);
			
			if (thsFilter && thsFilter[i]){
				thsFilter[i].getElement('div').setStyle('width', widths[i]);
			}
		}
	}
}