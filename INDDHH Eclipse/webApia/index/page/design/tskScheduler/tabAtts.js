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
		url: CONTEXT + URL_REQUEST_AJAX + '?action=getTskSchAtts' + TAB_ID_REQUEST,
		onRequest: function() { 
			//sp.show(true);
		},
		onComplete: function(resText, resXml) { 
			processXMLAtts(resXml);
			//sp.hide(true);
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
				
				addAttributeToContainer(text,id,type,req);
			}
		}
	}
}

//function addAttToContainer(text, id) {
//	var element = addActionElement($('attsContainter'),text,id,"attId");
//	element.removeEvent('click', actionAlementAdminClickRemove);
//	element.addEvent('click', function(evt) {
//		this.destroy();
//	});
//}

function processAttsModalReturn(ret){
	ret.each(function(e){
		var text = e.getRowContent()[0];
		var id = e.getRowId();
		addAttributeToContainer(text,id,"E","0");
	});
}

function addAttributeToContainer(name, id, type, required) {
	var content = addActionElement($('attsContainter'),name, id, "attId");
	var typeE = "";
	var typeP = "";
	var checked="false";
	
	if ("E" == type) typeE = "selected";
	if ("P" == type) typeP = "selected";
	if ("1" == required) checked="true";
	if (content == null) return;
	content.setStyle('background-position', 'right top');

	new Element('br').inject(content);
	var span = new Element('span').inject(content);
	span.set('html', LBL_TYPE + ":");
	span.addEvent('click', function(evt) {evt.stopPropagation(); });

	var hiddenInput = new Element( 'input',{ type:'hidden'}).inject(content);
	hiddenInput.setProperty('name','attName');
	hiddenInput.setProperty('value',name); 
	
	//Entidad o Proceso
	var ele = new Element('select', {
		name: 'chkAttType' + id, 
		id: 'chkAttType' + id, 
		html: '<option value="' + ATT_TYPE_ENTITY + '" ' + typeE + '>' + LBL_ATT_TYPE_ENTITY + '</option><option value="' + ATT_TYPE_PROCESS + '" ' + typeP + '>' + LBL_ATT_TYPE_PROCESS + '</option>'	
	}).inject(content);
	
	ele.addEvent('click', function(event) {
		event.stopPropagation();
	});
	
	new Element('br').inject(content);
	var span = new Element('span').inject(content);
	span.set('html', "Requerido:");
	span.addEvent('click', function(evt) {evt.stopPropagation(); });
	var elemDef;
	if ("1"==required) elemDef = new Element("input", {'name': "chkAttReq"+id, 'id': "chkAttReq"+id, 'type': "checkbox", 'checked':"true"}).inject(content);
	else elemDef = new Element("input", {'name': "chkAttReq"+id, 'id': "chkAttReq"+id, 'type': "checkbox"}).inject(content);
	elemDef.addEvent('click', function(evt) { evt.stopPropagation(); });
	if(Browser.ie)
		elemDef.addClass('text-aligned').setStyle('top', 4);
}