var prefix="FormAtts";
var container;
var isFromModal=false

function initAttributes(fromModal){
	if (fromModal) isFromModal=true;
	
	var cmbType = $('typeFilter');
	if (cmbType){
		new Element('option',{value:'', html:''}).inject(cmbType);
		new Element('option',{value:'S', html:LBL_STR_TYPE}).inject(cmbType);
		new Element('option',{value:'N', html:LBL_NUM_TYPE}).inject(cmbType);
		new Element('option',{value:'D', html:LBL_DATE_TYPE}).inject(cmbType);
	}
	
	container = $('gridContainer'+prefix);
	
	//crear spinner de espere un momento
	if (fromModal){
		sp = new Spinner(container.getElement('.gridContainerWithFilter'),{message:WAIT_A_SECOND});	
	} else {
		sp = new Spinner(container,{message:WAIT_A_SECOND});
	}
	
	initContainerNavButtons(container); //navButtons.js
	
	/* Auxiliares para filtros */
	$('clearFilters').addEvent("click", function(e) {
		if(e) e.stop();
		['typeFilter','nameFilter','lblFilter'].each(clearFilter);
		$('nameFilter').setFilter();
	}).addEvent('keypress', Generic.enterKeyToClickListener);
	
	['typeFilter','nameFilter','lblFilter'].each(setAdmFilters);
	
	var orderArray = ['orderByName', 'orderByLabel', 'orderByLength'];
	orderArray.each(setAdmOrder);
	orderArray.each(setAdmListTitle);
}

function callNavigateOrder(orderBy, obj){
	setFilter(null, orderBy, obj);
}

function setFilter(page, orderBy, orderByObj){
	callNavigateFilterAtt({
		name: $('nameFilter').value,
		label: $('lblFilter').value,
		type: $('typeFilter').value,
		curPage: (page? page : 0),
		orderBy: orderBy
	}, orderByObj);
}

function setFilterAttSchema(){
	setFilter(null);
}

function callNavigateFilterAtt(objParams, orderByObj, resetFilter){
	var URL_ACTION = "?action=refreshAttributes&isAjax=true";
	if (isFromModal) URL_ACTION += "&fromModal=true";
	if (resetFilter) URL_ACTION += "&resetFilter=true";

	var request = new Request({
		method: 'post',
		data: objParams,
		url: CONTEXT + URL_REQUEST_AJAX + URL_ACTION + TAB_ID_REQUEST + "&timestamp=" + newAjaxCall(),
		onRequest: function() {
			var spinner = window['sp_' + prefix] || sp;
			if (spinner) spinner.show(true); 
		},
		onComplete: function(resText, resXml) {
			if (lastActionCall(resXml)) { 
				modalProcessXml(resXml); 
				var spinner = window['sp_' + prefix] || sp;
				if (spinner) spinner.hide(true); 
				
				if (orderByObj){
					removeOrderByClass(orderByObj); 
					setOrderByClass(orderByObj);
				}
				
				if (!isFromModal){
					var rows = container.getElementById('tableData').getElements('tr');
					makeDraggableInstances(rows, null, cloneRowAttribute);	
				}
			} 
		}
	}).send();
} 

function cloneRowAttribute(row, event){
	var div = new Element('div',{'class':'drag-att'});
	
	var typeIcon = row.getElement('img').clone();
	typeIcon.inject(div);
	
	var span = new Element('span').inject(div);
	span.setAttribute('data-id', row.getAttribute('data-id'));
	span.textContent = row.getElements('td')[1].getAttribute('data-textcontent');
	span.setAttribute('data-label', row.getElements('td')[2].getAttribute('data-textcontent'));
		
	var coords = row.getCoordinates();	
	div.setStyles(coords);	
	div.style.width= (Generic.getHiddenWidth(span) + 30)+ 'px';
	div.style.left=(event.page.x-50)+'px';
	
	return div;
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
