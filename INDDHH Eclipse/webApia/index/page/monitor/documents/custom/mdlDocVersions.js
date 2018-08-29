
var spModalDocVersions;

function initDocVersionsMdlPage(){
	var mdlDocVersionsContainer = $('mdlDocVersionsContainer');
	if (mdlDocVersionsContainer.initDone) return;
	mdlDocVersionsContainer.initDone = true;

	mdlDocVersionsContainer.blockerModal = new Mask();
	
	spModalDocVersions = new Spinner($('mdlBodyDocVer'),{message:WAIT_A_SECOND});
	
	$('btnDownloadModal').addEvent("click", function(e){
		e.stop();
		if (selectionCount($('tableDataVersions')) > 1) {
			showMessage(GNR_CHK_ONLY_ONE, GNR_TIT_WARNING, 'modalWarning');
		} else if(selectionCount($('tableDataVersions')) == 0) {
			showMessage(GNR_CHK_AT_LEAST_ONE, GNR_TIT_WARNING, 'modalWarning');
		} else {
			var id = getSelectedRows($('tableDataVersions'))[0].getRowId();
			downloadDocVersion(id);
		}
	});
	
	$('closeDocVersionsModal').addEvent("click", function(e) {
		e.stop();
		closeDocVersionsModal();
	});
}

function showDocVersionsModal(docId){   
	var mdlDocVersionsContainer = $('mdlDocVersionsContainer');
	mdlDocVersionsContainer.removeClass('hiddenModal');
	mdlDocVersionsContainer.position();
	mdlDocVersionsContainer.blockerModal.show();
	mdlDocVersionsContainer.setStyle('zIndex', SYS_PANELS.getNewZIndex());
	mdlDocVersionsContainer.docId = docId;
	
	spModalDocVersions.show(true);
	cleanDocVersionsModal();
	loadDocVersions(mdlDocVersionsContainer.docId);
}

function loadDocVersions(docId){
	var request = new Request({
		method : 'post',
		url : CONTEXT + URL_REQUEST_AJAX + '?action=loadDocVersions&isAjax=true&docId=' + docId + TAB_ID_REQUEST,
		onRequest : function() { },
		onComplete : function(resText, resXml) { processXmlDocVersions(resXml); }
	}).send();
}

function cleanDocVersionsModal(){
	$("vdocType").innerHTML = "";
	$("vdocName").innerHTML = "";
	$("vdocDesc").innerHTML = "";
	$("vdocLock").innerHTML = "";
	$('tableDataVersions').getElements("tr").each(function(tr){ tr.destroy(); });	
}

function processXmlDocVersions(resXml){
	var information = resXml.getElementsByTagName("information")
	if (information != null && information.length > 0 && information.item(0) != null) {
		information = information.item(0);
		var genData = information.getElementsByTagName("genData").item(0);
		var versions = information.getElementsByTagName("versions");
		
		//Datos generales
		$('vdocName').innerHTML = genData.getAttribute("name");
		$('vdocType').innerHTML = genData.getAttribute("docType");
		$('vdocDesc').innerHTML = genData.getAttribute("description");
		$('vdocLock').innerHTML = genData.getAttribute("lock");
		
		//Versiones
		var tableDataVersions = $('tableDataVersions');
		if (versions != null && versions.length > 0 && versions.item(0) != null) {
			versions = versions.item(0).getElementsByTagName("version");
			for (var i = 0; i < versions.length; i++){
				var xmlVer = versions[i];
				var tr = new Element("tr",{'class':'selectableTR'}).inject(tableDataVersions);
				if (i % 2 == 0) { tr.addClass("trOdd"); }
				if (i == versions.length-1) { tr.addClass("lastTr"); }
				tr.setAttribute("rowId",xmlVer.getAttribute("id"));
				tr.getRowId = function () { return this.getAttribute("rowId"); }
				tr.addEvent("click",function(e){ e.stop(); this.toggleClass("selectedTR"); });
				
				//td1 VERSION
				var td1 = new Element("td", {'align':'center'}).inject(tr);
				var div1 = new Element('div', {styles: {width: '120px', overflow: 'hidden', 'white-space': 'pre', 'margin': '4px 0px'}}).inject(td1);
				var spanVer = new Element('span',{html: xmlVer.getAttribute("value")}).inject(div1);
				//td2 USUARIO
				var td2 = new Element("td", {'align':'center'}).inject(tr);
				var div2 = new Element('div', {styles: {width: '150px', overflow: 'hidden', 'white-space': 'pre', 'margin': '4px 0px'}}).inject(td2);
				var spanUser = new Element('span',{html: xmlVer.getAttribute("name")}).inject(div2);
				//td3 FECHA
				var td3 = new Element("td", {'align':'center'}).inject(tr);
				var div3 = new Element('div', {styles: {width: '150px', overflow: 'hidden', 'white-space': 'pre', 'margin': '4px 0px'}}).inject(td3);
				var spanDate = new Element('span',{html: xmlVer.getAttribute("date")}).inject(div3);
			}
		}
		addScrollTable(tableDataVersions);		
	}	
	spModalDocVersions.hide(true);
	
	var mdlDocVersionsContainer = $('mdlDocVersionsContainer');
	mdlDocVersionsContainer.position();
}

function downloadDocVersion(docVerId){
	var mdlDocVersionsContainer = $('mdlDocVersionsContainer');
	var docId = mdlDocVersionsContainer.docId;
	createDownloadIFrame("",DOWNLOADING,URL_REQUEST_AJAX,"download","&id="+docId+"&version="+docVerId,"","",null);
}

function closeDocVersionsModal(){
    var mdlDocVersionsContainer = $('mdlDocVersionsContainer');
    mdlDocVersionsContainer.addClass('hiddenModal');
    mdlDocVersionsContainer.blockerModal.hide();	    
}

