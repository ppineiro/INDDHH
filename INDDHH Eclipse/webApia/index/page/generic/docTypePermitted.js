function initDocTypePermitted(){
	
	$('docTypePermittedAdd').addEvent("click",function(e){
		e.stop();
		DOC_TYPE_MODAL_SELECTONLYONE = false;
		showDocTypeModal(processDocTypeModalReturn);
	});

	loadDocTypePermitted();
	
	initDocTypeMdlPage();
}

function processDocTypeModalReturn(ret){
	var btnAdd = $('docTypePermittedAdd');
	var added = false;	
	ret.each(function (e){
		var docTypeId = e.getRowId();
		if (!$('dtp_'+docTypeId)){
			var docTypeName = e.getRowContent()[0];
			var obj = createDocTypePermitted(docTypeId, docTypeName);
			obj.inject(btnAdd,"before");
			added = true;
		}
	});
	if (added){
		$('allDocTypePermitted').setStyle("display","none");
	}
}

function loadDocTypePermitted(){
	var request = new Request({
		method: 'post',
		url: CONTEXT + URL_REQUEST_AJAX + '?action=loadDocTypePermitted&isAjax=true' + TAB_ID_REQUEST,
		onRequest: function() { },
		onComplete: function(resText, resXml) { modalProcessXml(resXml); }
	}).send();
}

function processXMLDocTypePermitted(){
	var ajaxCallXml = getLastFunctionAjaxCall();
	if (ajaxCallXml != null) {
		var permitted = ajaxCallXml.getElementsByTagName("result");
		
		if (permitted != null && permitted.length > 0 && permitted.item(0) != null) {
			permitted = permitted.item(0).getElementsByTagName("docTypePermitted");
			
			var btnAdd = $('docTypePermittedAdd');
			for (var i = 0; i < permitted.length; i++){
				var docTypeId = permitted[i].getAttribute("id");
				var docTypeName = permitted[i].getAttribute("name");				
				var obj = createDocTypePermitted(docTypeId, docTypeName);
				obj.inject(btnAdd,"before");
			}
			
			if (permitted.length > 0){
				$('allDocTypePermitted').setStyle("display","none");
			}
		}
	}
}

function createDocTypePermitted(id,name){
	var obj = new Element("div.option.optionRemove.docTypePermittedClass",{html:name,'id':'dtp_'+id});
	new Element("input",{'type':'hidden','name':'hidDocTypeId','value':id}).inject(obj);
	obj.addEvent("click",function(e){
		if ($$('div.docTypePermittedClass').length == 1){
			$('allDocTypePermitted').setStyle("display","");
		}
		this.destroy();		
	});
	return obj;
}

