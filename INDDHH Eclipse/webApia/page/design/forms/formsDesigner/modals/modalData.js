var prefix="MdlData";
var container;
var action;

function initPage(){
	if(Browser.chrome) {
		$$('.gridContainerWithFilter').each(function(container){
			container.setStyle('padding-top','45px');
		})
	}
	
	switch(MDL_TYPE){
	case '10': $('mdlTitle').innerHTML=LBL_MODALS; break; /*PROPERTY_MODAL*/
	case '11': $('mdlTitle').innerHTML=LBL_ENTS; break; /*PROPERTY_ENTITY*/
	case '22': $('mdlTitle').innerHTML=LBL_IMGS; break; /*PROPERTY_IMAGE*/
	case '25': $('mdlTitle').innerHTML=LBL_QRY; break; /*PROPERTY_QUERY*/
	case '38': $('mdlTitle').innerHTML=LBL_FORMS; break; /*PROPERTY_GRID_FORM*/
	case '88': $('mdlTitle').innerHTML=LBL_IMGS; break; /*PROPERTY_TREE_PARENT_ICON*/
	case '89': $('mdlTitle').innerHTML=LBL_IMGS; break; /*PROPERTY_TREE_LEAF_ICON*/
	case '91': $('mdlTitle').innerHTML=LBL_DOCS; break; /*PROPERTY_DOC_TYPE*/
	}
	
	//crear spinner de espere un momento
	container = $('gridContainer'+prefix);	
	sp = new Spinner(container.getElement('.gridContainerWithFilter'),{message:WAIT_A_SECOND});
	
	if (MDL_TYPE=='38'){
		action = "refreshForms"; 
		initContainerNavButtons(container); //navButtons.js
	} else {
		action = "refreshModalData"; 
	}
	
	/* Auxiliares para filtros */
	$('clearFilters').addEvent("click", function(e) {
		if(e) e.stop();
		['nameFilter','titleFilter'].each(clearFilter);
		$('nameFilter').setFilter();
	}).addEvent('keypress', Generic.enterKeyToClickListener);
	
	['nameFilter','titleFilter'].each(setAdmFilters);
	
	//Se carga tabla
	setFilter();
	
	var ths = $('paramGridHeader').getElement('.header').getElements('th');
	if (MDL_TYPE == '22'/*PROPERTY_IMAGE*/ || MDL_TYPE == '88'/*PROPERTY_TREE_PARENT_ICON*/
		|| MDL_TYPE == '89' /*PROPERTY_TREE_LEA*/){
		ths[0].innerHTML=LBL_LABEL;
		ths[1].innerHTML=LBL_NAME;
	} else {
		ths[0].innerHTML=LBL_NAME;
		ths[1].innerHTML=LBL_TITLE;
	}
	
	if (MDL_TYPE == '91'/*PROPERTY_DOC_TYPE*/){
		$('titleFilter').hide()
	}
}

function setFilter(page){
	callFilterModal({
		name:  $('nameFilter').value,
		title: $('titleFilter').value,
		curPage: (page? page : 0)
	}, null);
}

function callFilterModal(objParams){
	var addParams = '&type='+MDL_TYPE+'&isAjax=true' + TAB_ID_REQUEST;
	if (FLAG_PARAM) addParams += '&flag=' + FLAG_PARAM;
	
	var request = new Request({
		method: 'post',
		data: objParams,
		url: CONTEXT + URL_REQUEST_AJAX + '?action=' + action + addParams,
		onRequest: function() {
			var spinner = window['sp_' + prefix] || sp;
			if (spinner) spinner.show(true); 
		},
		onComplete: function(resText, resXml) {
			if (resXml != null) {
				
				if (MDL_TYPE=='38'){
					modalProcessXml(resXml); 
					
					var spinner = window['sp_' + prefix] || sp;
					if (spinner) spinner.hide(true);
					
					return;
				}
				
				var messages = resXml.getElementsByTagName("messages");
				
				ajaxCallXml = null;
				
				if (messages != null && messages.length > 0) {
					ajaxCallXml = messages[0].getElementsByTagName("result")[0];
				}
				
				var table = container.getElementById('tableData');
				var gridBody = table.getParent('.gridBody');		
				
				loadTable(table,ajaxCallXml, true, null, true, container);
				if (gridBody && gridBody.noDataMessage) $(gridBody.noDataMessage).setStyle('display','none');
				
				var spinner = window['sp_' + prefix] || sp;
				if (spinner) spinner.hide(true);
			}
		}
	}).send();
}

function getModalReturnValue() {
	var table = container.getElementById('tableData');
	
	if (selectionCount(tableData) > 1) {
		showMessage(GNR_CHK_ONLY_ONE, GNR_TIT_WARNING, 'modalWarning');
		return null;
	} else if (selectionCount(tableData) == 0) {
		showMessage(GNR_CHK_AT_LEAST_ONE, GNR_TIT_WARNING, 'modalWarning');
		return null;
	} else {
		var selected = getSelectedRows(tableData)[0]; 
		return {
			id: selected.getRowId(),
			name: MDL_TYPE == '22' ? /*PROPERTY_IMAGE*/
					selected.getRowId() : 
					selected.getElements('td')[0].getAttribute('data-textcontent')
		}
	}
}
