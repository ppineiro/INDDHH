
var spModalDocInformation;

function initDocInformationMdlPage(){
	var mdlDocInformationContainer = $('mdlDocInformationContainer');
	if (mdlDocInformationContainer.initDone) return;
	mdlDocInformationContainer.initDone = true;

	mdlDocInformationContainer.blockerModal = new Mask();
	
	spModalDocInformation = new Spinner($('mdlBodyDocInfo'),{message:WAIT_A_SECOND});
	
	$('closeDocInformationModal').addEvent("click", function(e) {
		e.stop();
		closeDocInformationModal();
	});
}

function showDocInformationModal(docId){   
	var mdlDocInformationContainer = $('mdlDocInformationContainer');
	mdlDocInformationContainer.removeClass('hiddenModal');
	mdlDocInformationContainer.position();
	mdlDocInformationContainer.blockerModal.show();
	mdlDocInformationContainer.setStyle('zIndex', SYS_PANELS.getNewZIndex());
	mdlDocInformationContainer.docId = docId;
	
	spModalDocInformation.show(true);
	cleanDocInformationModal();
	loadDocInformation(mdlDocInformationContainer.docId);
}

function loadDocInformation(docId){
	var request = new Request({
		method : 'post',
		url : CONTEXT + URL_REQUEST_AJAX + '?action=loadDocInformation&isAjax=true&docId=' + docId + TAB_ID_REQUEST,
		onRequest : function() { },
		onComplete : function(resText, resXml) { processXmlDocInformation(resXml); }
	}).send();
}

function cleanDocInformationModal(){
	$("docType").innerHTML = "";
	$("docName").innerHTML = "";
	$("docDesc").innerHTML = "";
	$("docLock").innerHTML = "";
	$('permContainter').getElements("div").each(function(opt){ opt.destroy(); });
	$('tableDataMetadata').getElements("tr").each(function(tr){ tr.destroy(); });	
}

function processXmlDocInformation(resXml){
	var information = resXml.getElementsByTagName("information")
	if (information != null && information.length > 0 && information.item(0) != null) {
		information = information.item(0);
		var genData = information.getElementsByTagName("genData").item(0);
		var permissions = information.getElementsByTagName("permissions");
		var metadata = information.getElementsByTagName("docMetadata");
		
		//Datos generales
		$('docName').innerHTML = genData.getAttribute("name");
		$('docType').innerHTML = genData.getAttribute("docType");
		$('docDesc').innerHTML = genData.getAttribute("description");
		$('docLock').innerHTML = genData.getAttribute("lock");
		
		//Permisos
		if (permissions != null && permissions.length > 0 && permissions.item(0) != null) {
			permissions = permissions.item(0).getElementsByTagName("permission");
			var permContainter = $('permContainter');
			for (var i = 0; i < permissions.length; i++){
				var xmlPerm = permissions[i];
				var strHtml = xmlPerm.getAttribute("name")+": "+xmlPerm.getAttribute("value");
				var div = new Element("div",{'class':'option',html: strHtml}).inject(permContainter);
				var srcImg = xmlPerm.getAttribute("image");
				if (srcImg != null && srcImg != ""){
					new Element("div",{'class':'optionIcon ' + (srcImg == "pool" ? 'optionPool' : 'optionUser'),styles:{'float':'left'}}).inject(div);
				}
			}
		}
		
		//Metadatos
		var hasMetadata = false;
		var tableDataMetadata = $('tableDataMetadata');
		if (metadata != null && metadata.length > 0 && metadata.item(0) != null) {
			metadata = metadata.item(0).getElementsByTagName("metadata");
			for (var i = 0; i < metadata.length; i++){
				hasMetadata = true;
				var xmlMet = metadata[i];
				var tr = new Element("tr",{}).inject(tableDataMetadata);
				if (i % 2 == 0) { tr.addClass("trOdd"); }
				if (i == metadata.length-1) { tr.addClass("lastTr"); }				
				//td1 TITLE
				var td1 = new Element("td", {}).inject(tr);
				var div1 = new Element('div', {styles: {width: '200px', overflow: 'hidden', 'white-space': 'pre', 'margin': '4px 0px'}}).inject(td1);
				var spanName = new Element('span',{html: xmlMet.getAttribute("name")}).inject(div1);
				if (div1.scrollWidth > div1.offsetWidth) {
					td1.title = xmlMet.getAttribute("name");
					td1.addClass("titiled");
				}
				//td2 VALUE
				var td2 = new Element("td", {}).inject(tr);
				var div2 = new Element('div', {styles: {width: '180px', overflow: 'hidden', 'white-space': 'pre', 'margin': '4px 0px'}}).inject(td2);
				var spanValue = new Element('span',{html: xmlMet.getAttribute("value")}).inject(div2);
				if (div2.scrollWidth > div2.offsetWidth) {
					td2.title = xmlMet.getAttribute("value");
					td2.addClass("titiled");
				}
				//td3 LIBRE
				var td3 = new Element("td", {'align':'center'}).inject(tr);
				var div3 = new Element('div', {styles: {width: '50px', overflow: 'hidden', 'white-space': 'pre', 'margin': '4px 0px'}}).inject(td3);
				var spanFree = new Element('span',{html: xmlMet.getAttribute("free")}).inject(div3);
			}
		}
		if (hasMetadata){
			$('divNoMetadata').setStyle("display","none");
			$('divMetadata').setStyle("display","");
			addScrollTable(tableDataMetadata);
		} else {
			$('divNoMetadata').setStyle("display","");
			$('divMetadata').setStyle("display","none");
		}
	}		
	
	var mdlDocInformationContainer = $('mdlDocInformationContainer');
	mdlDocInformationContainer.position();
	
	spModalDocInformation.hide(true);
}

function closeDocInformationModal(){
    var mdlDocInformationContainer = $('mdlDocInformationContainer');
    mdlDocInformationContainer.addClass('hiddenModal');
    mdlDocInformationContainer.blockerModal.hide();	    
}

