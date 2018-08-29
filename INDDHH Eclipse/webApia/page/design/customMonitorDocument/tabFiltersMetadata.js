function initTabFiltersMetadata(){
	
}

function executeBeforeConfirmTabFiltersMetadata(){
	$('filtersDocMetadata').value = getFilMetadata();
	return true;
}

function reloadFiltersMetadata(isLoad){
	if (isLoad == undefined) isLoad = false;
	
	var docTypeIds = "";
	var docMetadataValues = "";
	if (!isLoad){
		docTypeIds = "&docTypeIds=" + getFiltersDocType();
		docMetadataValues = "&docMetadataValues=" + getFilMetadata();
	}
	
	var request = new Request({
		method: 'post',
		url: CONTEXT + URL_REQUEST_AJAX + '?action=loadFiltersMetadata&isAjax=true&isLoad=' + isLoad + docTypeIds + docMetadataValues + TAB_ID_REQUEST,
		onRequest: function() { SYS_PANELS.showLoading(); },
		onComplete: function(resText, resXml) { processXmlFiltersMetadata(resXml); }
	}).send();
}

function processXmlFiltersMetadata(resXml){
	$('containerDocMetadata').getElements("div.option").each(function (item){ item.destroy(); });
	
	var hasFilInter = false;
	var filters = resXml.getElementsByTagName("filters")
	if (filters != null && filters.length > 0 && filters.item(0) != null) {
		filters = filters.item(0).getElementsByTagName("metadata");
		
		for (var i = 0; i < filters.length; i++){
			var xmlMet = filters[i];
			createFilMetadata(xmlMet.getAttribute("type"), xmlMet.getAttribute("name"), xmlMet.getAttribute("value1"), xmlMet.getAttribute("value2"));
		}
		
		hasFilInter = filters.length > 0;
	}
	
	if (! countDocTypeFilters() > 0){
		$('divNoMetadataNoSel').setStyle("display","");
		$('divNoMetadataNoInter').setStyle("display","none");
		$('divMetadata').setStyle("display","none");
	} else if (!hasFilInter){
		$('divNoMetadataNoSel').setStyle("display","none");
		$('divNoMetadataNoInter').setStyle("display","");
		$('divMetadata').setStyle("display","none");
	} else { //metadatos
		$('divNoMetadataNoSel').setStyle("display","none");
		$('divNoMetadataNoInter').setStyle("display","none");
		$('divMetadata').setStyle("display","");
	}
	
	SYS_PANELS.closeAll();
}

function countFilMetadata(){
	return $('containerDocMetadata').getElements("div.option").length;
}

function createFilMetadata(type,name,value1,value2){
	if (!$('filDocMet_'+name)){
		var div = new Element("div.option",{'id':'filDocMet_'+name, 'data-helper':'true', styles:{'cursor':'auto','width':'70%'}}).inject($('containerDocMetadata'));
		div.setAttribute("filDocMetType",type);
		div.setAttribute("filDocMetName",name);
		var spanName = new Element("span",{html: name + ":&nbsp;", styles:{'float':'left','width':'45%','vertical-align':'middle'}}).inject(div);
		if (type == TYPE_NUMERIC){
			var input1 = new Element("input.force50",{'type':'text','value':value1,styles:{'float':'right','width':'50% !important','vertical-align':'middle'}}).inject(div);
			input1.addEvent("keypress",function(e){
				if (e.key < '0' || e.key > '9'){
					if (e.key != "delete" && e.key != "tab" && e.key != "backspace" && e.key != "left" && e.key != "right"){
						e.stop();
					}
				} 
			});
		} else if (type == TYPE_DATE){
			var divAux = new Element("div",{styles:{'float':'right','vertical-align':'middle'}}).inject(div);
			var input1 = new Element("input.datePicker",{'type':'text','maxlength':'10','format':'d/m/Y','value':value1,styles:{'width':'23% !important','vertical-align':'top'}}).inject(divAux);
			new Element("span",{html: '&nbsp;&nbsp-&nbsp;',styles:{'vertical-align':'top'}}).inject(divAux);
			var input2 = new Element("input.datePicker",{'type':'text','maxlength':'10','format':'d/m/Y','value':value2,styles:{'width':'23% !important','vertical-align':'top'}}).inject(divAux);
			[input1,input2].each(setAdmDatePicker);
			divAux.getElements("img").each(function(img){ img.addClass("forceTop"); });
		} else { //TYPE_STRING
			var input1 = new Element("input.force50",{'type':'text','value':value1,styles:{'float':'right','width':'50% !important','vertical-align':'middle'}}).inject(div);			
		}
	}
}

function getFilMetadata(){
	var ret = ""; //type�name�value1�[value2]
	
	$('containerDocMetadata').getElements("div.option").each(function(docMet){
		var type = docMet.getAttribute("filDocMetType");
		var name = docMet.getAttribute("filDocMetName");
		var value1 = null;
		var value2 = null;
		
		if (type == TYPE_NUMERIC){
			value1 = docMet.getElement("input").value;
			if (value1 == "") value1 = null;
			value2 = null;
		} else if (type == TYPE_DATE){
			var inputs = docMet.getElement("div").getElements("input");
			value1 = inputs[0].value;
			if (value1 == "") value1 = null;
			value2 = inputs[2].value;
			if (value2 == "") value2 = null;
		} else { //TYPE_STRING
			value1 = docMet.getElement("input").value;
			if (value1 == "") value1 = null;
			value2 = null;
		}
		
		if (value1 != null || value2 != null){
			if (ret != "") ret += ";";
			ret += type;
			ret += PRIMARY_SEPARATOR;
			ret += name;
			ret += PRIMARY_SEPARATOR;
			ret += value1 != null ? value1 : "null";
			ret += value2 != null ? (PRIMARY_SEPARATOR + value2) : (PRIMARY_SEPARATOR + "null");			
		}
	});
	
	return ret;
}