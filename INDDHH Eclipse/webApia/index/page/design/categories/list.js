function initPage(){
	getTabContainerController().changeTabState(TAB_ID, false); 
	
	//crear spinner de espere un momento
	sp = new Spinner($('gridBody').getParent(),{message:WAIT_A_SECOND});
	
	//$$("div.button").each(setAdmEvents);

	['orderByName','orderByDesc','orderByFather', 'orderByRegUser','orderByRegDate'].each(setAdmOrder);
	['orderByName','orderByDesc','orderByFather', 'orderByRegUser','orderByRegDate'].each(setAdmListTitle);
	['nameFilter','descFilter','padFilter', 'regUsrFilter','regUsrFilter'].each(setAdmFilters);
	
	$('regDateFilter').setFilter = setFilter;
	$('regDateFilter').addEvent("change", function(e) {
		this.setFilter();
	});
	
	$('clearFilters').addEvent("click", function(e) {
		e.stop();
		['nameFilter','descFilter','padFilter','regUsrFilter'].each(clearFilter);
		['regDateFilter'].each(clearFilterDate);
		$('nameFilter').setFilter();
	});
	
	initAdminActions();
	initNavButtons();
	
	callNavigate();
}

function upload(){
	hideMessage();
	var request = new Request({
		method: 'post',
		url: CONTEXT + URL_REQUEST_AJAX+'?action=selectUpload&isAjax=true&' + TAB_ID_REQUEST,
		onRequest: function() { SYS_PANELS.showLoading(); },
		onComplete: function(resText, resXml) { modalProcessXml(resXml); }
	}).send();
}

//establecer un filtro
function setFilter(){
	callNavigateFilterAtt({
			txtName: $('nameFilter').value,
			txtDesc: $('descFilter').value,
			txtFather: $('padFilter').value,
			txtRegUser: $('regUsrFilter').value,
			txtRegDate: $('regDateFilter').value			
		},null);
}

function callNavigateFilterAtt(objParams, strParams,url){
	hideMessage();
	if(!url){
	url = URL_REQUEST_AJAX;
	}
	var request = new Request({
	method: 'post',
	data: objParams,
	url: CONTEXT + url + '?action=filterAtt&isAjax=true' + TAB_ID_REQUEST,
	onRequest: function() { sp.show(true); },
	onComplete: function(resText, resXml) { modalProcessXml(resXml); sp.hide(true); }
	}).send(strParams);
	} 


function populateCombo(){
	var request = new Request({
		method: 'post',
		url: CONTEXT + URL_REQUEST_AJAX+'?action=populateTable&isAjax=true&' + TAB_ID_REQUEST,		
		onComplete: function(resText, resXml) { displayCombo(resXml); }
	}).send("id="+$('connectionsCombo').value);	
}

function displayCombo(xml){
	//hideMessage();
	
	var exception = xml.getElementsByTagName("exception");
	
	if (exception != null && exception.length > 0) {
		$('cmbDbTableContainer').innerHTML = exception[0].getAttribute("text");
	} else {
		var toLoad = xml.getElementsByTagName("load").item(0);
		var theForm = toLoad.getElementsByTagName("form").item(0);
		var htmlForm = "";
		if (theForm != null) {
			var theElements = theForm.getElementsByTagName("elements");
			var formElements = processModalXmlFormElements(theElements, false);
			htmlForm = formElements; 
		}
		$('cmbDbTableContainer').innerHTML = htmlForm;
	}
}

function uploadDB(){
	var idConn = null;
	selected = new Array();
	var ok = true;
	if ($('connectionsCombo').value){
		idConn = $('connectionsCombo').value;
	}else{
		showMessage(MUST_CHOOSE_CONN,null,"modalWarning");
		ok = false;
	}
	if ($('connectionViews')!=null){
		for (var i = 0; i < $('connectionViews').options.length; i++){
		  if ($('connectionViews').options[ i ].selected){
		     selected.push($('connectionViews').options[ i ].value);
		  }
		}
		if (selected.length==0){  
			showMessage(MUST_CHOOSE_TABLE_VIEW,null,"modalWarning");
			ok = false;
		}
	}
	if (ok){
		hideMessage();
		var request = new Request({
			method: 'post',
			url: CONTEXT + URL_REQUEST_AJAX+'?action=uploadFromDB&isAjax=true&' + TAB_ID_REQUEST,
			onRequest: function() { SYS_PANELS.showLoading(); },
			onComplete: function(resText, resXml) { modalProcessXml(resXml); }
		}).send("idConnection="+idConn+"&nomView="+selected);
	}
}