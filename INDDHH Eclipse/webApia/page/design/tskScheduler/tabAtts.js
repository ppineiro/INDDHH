function initTskSchAtts(mode) {
	var prpAddAtt = $('prpAddAtt');
	
	if (prpAddAtt) {
		prpAddAtt.addEvent("click", function(e) {
			e.stop();
			showAttributesModal(processAttsModalReturn);
		});
	}
	
	initAttMdlPage();
	loadAttributes();
}

function loadAttributes() {
	var request = new Request({
		method: 'post',
		url: CONTEXT + URL_REQUEST_AJAX + '?action=getTskSchAtts&isAjax=true' + TAB_ID_REQUEST,
		onComplete: function(resText, resXml) { 
			processXMLAtts(resXml);
			
			initAdminModalHandlerOnChangeHighlight($('attsContainter'));
		}
	});
	
	request.send();
}

function processXMLAtts(ajaxCallXml){
	if (ajaxCallXml != null) {
		var atts = ajaxCallXml.getElementsByTagName("atts");
		if (atts != null && atts.length > 0 && atts.item(0) != null) {
			atts = atts.item(0).getElementsByTagName("att");
			for(var i = 0; i < atts.length; i++) {
				var att = atts.item(i);
				
				var text = att.getAttribute("text");
				var id = att.getAttribute("id");
				var type = att.getAttribute("type");
				var req = att.getAttribute("required");
				
				addAttributeToContainer(text, id, type, req);
			}
		}
	}
}

function processAttsModalReturn(ret){
	ret.each(function(e){
		var text = e.getRowContent()[0];
		var id = e.getRowId();
		addAttributeToContainer(text, id, "E", "0");
	});
}

function addAttributeToContainer(name, id, type, required) {
	var content = addActionElement($('attsContainter'), name, id, "attId");
	var typeE = "";
	var typeP = "";
	var checked = "false";
	
	if ("E" == type) typeE = "selected";
	if ("P" == type) typeP = "selected";
	if ("1" == required) checked="true";
	
	if (content == null) return;
	
	content.setStyles({
		'min-width': 120,
		'padding-top': 5,
		'padding-left': 10
	});

	new Element('br').inject(content);
	
	new Element('span', {
		html: LBL_TYPE + ":"
	}).inject(content);

	new Element('input', {
		type: 'hidden',
		name: 'attName',
		value: name
	}).inject(content);
	
	//Entidad o Proceso
	new Element('select', {
		name: 'chkAttType' + id, 
		id: 'chkAttType' + id, 
		html: '<option value="' + ATT_TYPE_ENTITY + '" ' + typeE + '>' + LBL_ATT_TYPE_ENTITY + '</option><option value="' + ATT_TYPE_PROCESS + '" ' + typeP + '>' + LBL_ATT_TYPE_PROCESS + '</option>'	
	}).inject(content);
	
	new Element('br').inject(content);

	new Element('span', {
		html: LBL_REQ + ':'
	}).inject(content);
	
	var elemDef;
	if ("1" == required)
		elemDef = new Element("input", {'name': "chkAttReq" + id, 'id': "chkAttReq" + id, 'type': "checkbox", 'checked':"true"}).inject(content);
	else 
		elemDef = new Element("input", {'name': "chkAttReq" + id, 'id': "chkAttReq" + id, 'type': "checkbox"}).inject(content);
	
	if(Browser.ie)
		elemDef.addClass('text-aligned').setStyle('top', 4);
}