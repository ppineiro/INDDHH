function initPage(){
	getTabContainerController().changeTabState(TAB_ID, false); 
	
	//crear spinner de espere un momento
	sp = new Spinner($('gridBody').getParent(),{message:WAIT_A_SECOND});
	
	//$$("div.button").each(setAdmEvents);

	['orderByName','orderByDesc','orderByAttLabel', 'orderByRegUser','orderByRegDate'].each(setAdmOrder);
	['orderByPerm','orderByName','orderByDesc','orderByAttLabel', 'orderByRegUser','orderByRegDate'].each(setAdmListTitle);
	['nameFilter','descFilter','labelFilter', 'regUsrFilter','regUsrFilter'].each(setAdmFilters);
	['regDateFilter'].each(setDateFilters);
	
	$('clearFilters').addEvent("click", function(e) {
		if(e) e.stop();
		['nameFilter','descFilter','labelFilter','typeFilter','projectFilter','regUsrFilter'].each(clearFilter);
		['regDateFilter'].each(clearFilterDate);
		$('filterNoDepsValue').checked=false;
		$('nameFilter').setFilter();
	}).addEvent('keypress', Generic.enterKeyToClickListener);
	
	$('filterNoDepsValue').addEvent("click", function(e) {
		setFilter();
	});

	$('optionDownload').addEvent("click", function(e){
		e.stop();
		hideMessage();
		
		hideMessage();
		var request = new Request({
			method: 'post',
			url: CONTEXT + URL_REQUEST_AJAX+'?action=selectDownload&isAjax=true&' + TAB_ID_REQUEST,
			onRequest: function() { SYS_PANELS.showLoading(); },
			onComplete: function(resText, resXml) { modalProcessXml(resXml); }
		}).send();
	});
	
	$('optionUpload').addEvent("click", function(e){
		e.stop();
		upload();		
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
			txtLabel: $('labelFilter').value,
			cmbType: $('typeFilter').value,
			selPrj: $('projectFilter').value,
			txtRegUser: $('regUsrFilter').value,
			txtRegDate: $('regDateFilter').value,
			noDeps:$('filterNoDepsValue').checked?"on":""
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

function setMode(){	
	var request = new Request({
		method: 'post',
		url: CONTEXT + URL_REQUEST_AJAX+'?action=setMode&isAjax=true&' + TAB_ID_REQUEST,
		onRequest: function() { SYS_PANELS.showLoading(); },
		onComplete: function(resText, resXml) { modalProcessXml(resXml); }
	}).send("uploadMode="+$('uploadMode').value);
	hideMessage();
}

function doDownload() {
	createDownloadIFrame(TIT_DOWNLOAD,DOWNLOADING,URL_REQUEST_AJAX,"download","&downloadMode=" + $('downloadMode').get('value'),"","",null);
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