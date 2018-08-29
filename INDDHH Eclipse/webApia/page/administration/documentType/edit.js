
function initPage(){
	//crear spinner de espere un momento
	sp = new Spinner(document.body,{message:WAIT_A_SECOND});
	
	if (IS_APIA_DOC_TYPE){
		//deshabilitar campos
		$('docTypeName').disabled = true;
		$('docTypeTitle').disabled = true;
		$('docTypeDesc').disabled = true;
		$('docTypeMaxSize').disabled = true;
		$('addExt').disabled = true;
		$('addExt').addClass("readonly");
		$('docTypeFreeMetadata').disabled = true;
	} else {		
		$('addExt').addEvent("change", function() { processAddExtension(); });
		$('addExt').addEvent("keydown", function(evt) { processAddExtension(evt); });
		$('divAddExt').addEvent("click", function() { processAddExtension(); });
		
		
		$('btnUp').addEvent("click",function(e){
			e.stop();
			if (selectionCount($('tableMetadata')) > 1) {
				showMessage(GNR_CHK_ONLY_ONE, GNR_TIT_WARNING, 'modalWarning');
			} else if (selectionCount($('tableMetadata')) == 0) {
				showMessage(GNR_CHK_AT_LEAST_ONE, GNR_TIT_WARNING, 'modalWarning');
			} else {
				var selected = getSelectedRows($('tableMetadata'))[0];
				moveRow(selected,true);
				fixTableMetadata();
			}	
		});
		
		$('btnDown').addEvent("click",function(e){
			e.stop();
			if (selectionCount($('tableMetadata')) > 1) {
				showMessage(GNR_CHK_ONLY_ONE, GNR_TIT_WARNING, 'modalWarning');
			} else if (selectionCount($('tableMetadata')) == 0) {
				showMessage(GNR_CHK_AT_LEAST_ONE, GNR_TIT_WARNING, 'modalWarning');
			} else {
				var selected = getSelectedRows($('tableMetadata'))[0];
				moveRow(selected,false);
				fixTableMetadata();
			}
		});
		
		$('btnAdd').addEvent("click", function(e){
			e.stop();
			addNewMetadata("null","","","S","N",false);
			fixTableMetadata();
		});
		
		$('btnDelete').addEvent("click", function(e){
			e.stop();
			if (selectionCount($('tableMetadata')) == 0) {
				showMessage(GNR_CHK_AT_LEAST_ONE, GNR_TIT_WARNING, 'modalWarning');
			} else {
				var selecteds = getSelectedRows($('tableMetadata'));
				removeMetadata(selecteds);
				fixTableMetadata();
			}		
		});
		
		//Cambiar imagen
		$('changeImg').addEvent("click", function(evt){
			evt.stop();
			showImagesModal(processModalImageConfirm);		
		});
		
		//Eliminar imagen
		$('btnResetImg').addEvent("click", function(evt){
			evt.stop();
			var txtPathImg = $('imgPath');
			var changeImg = $('changeImg'); 
			changeImg.style.backgroundImage = "";
			txtPathImg.value = "";
			txtPathImg.fireEvent('change');
		});
		
		var imgPath = $('imgPath');
		if (imgPath){
			imgPath.addEvent("change",function(){
				var isSameValue = this.value == this.get('initialValue');
				if (! isSameValue) {
					this.getParent().addClass("highlighted");
				} else {
					this.getParent().removeClass("highlighted");
				}
			});
		}
	}
	
	//Cargar Extensiones
	loadExtensions();
	
	//Cargar Metadatos
	loadMetadata();
	
	initImgMdlPage();
	initAdminFieldOnChangeHighlight();
	initAdminActionsEdition(checkMetadataNames);	
	
	getBodyController().canRemoveTab = function() { return ! AT_LEAST_ON_FIELD_INPUT_CHANGED; };
}

function checkMetadataNames(){
	//Verificamos todos las nombres de los metadatos sean distintos
	var trs = $('tableMetadata').getElements("tr");
	var arrayNames = new Array();
	
	for(var i = 0; i < trs.length; i++){
		var newName = trs[i].getElement("td").getElement("div").getElement("input").value;
		if (newName == "") continue;
		newName = newName.toUpperCase();
		if (arrayContain(arrayNames, newName)){
			showMessage(MSG_METADATA_NAME_UNIQUE, GNR_TIT_WARNING, 'modalWarning');
			return false;
		}
		arrayNames[arrayNames.length] = newName;			
	}
	setValues();
	return true;
}

function setValues(){
	//Extensiones
	var exts = "";	
	var container = $('extsContainter');
	container.getElements("div.optionRemove").each(function(ext){
		if (exts != "") exts += EXTENSIONS_SEPARATOR;
		exts += ext.getParent().getAttribute("ext");
	});
	container.getElements("div.option.used").each(function(ext){
		if (ext.getAttribute("id") != "defExt"){
			if (exts != "") exts += EXTENSIONS_SEPARATOR;
			exts += ext.getAttribute("ext");
		}
	});	
	
	if (exts != "") exts = EXTENSIONS_SEPARATOR + exts + EXTENSIONS_SEPARATOR;
	$('docTypeExt').value = exts;
	
	//metadata
	var metadata = "";
	$('tableMetadata').getElements("tr").each(function (tr){
		if (metadata != "") metadata += ";";
		metadata += tr.getContentStr();
	});
	$('txtMetadata').value = metadata;
}

function loadExtensions(){
	var request = new Request({
		method : 'post',
		url : CONTEXT + URL_REQUEST_AJAX + '?action=loadExtensions&isAjax=true' + TAB_ID_REQUEST,
		onRequest : function() { SYS_PANELS.showLoading(); },
		onComplete : function(resText, resXml) { 
			processXmlExtensions(resXml);
			
			initAdminModalHandlerOnChangeHighlight($('extsContainter'));
		}
	}).send();
}

function processXmlExtensions(resXml){
	var hasExtensions = false;
	var extensions = resXml.getElementsByTagName("extensions")
	if (extensions != null && extensions.length > 0 && extensions.item(0) != null) {
		extensions = extensions.item(0).getElementsByTagName("extension");
	
		for(var i = 0; i < extensions.length; i++){
			var xmlExt = extensions[i];
			addExtension(xmlExt.getAttribute("ext"),toBoolean(xmlExt.getAttribute("used")));
		}
		
		hasExtensions = extensions.length > 0;
	}
	
	if (!hasExtensions){
		addDefExtension();
	}
	
	SYS_PANELS.closeLoading();
}

function loadMetadata(){
	var request = new Request({
		method : 'post',
		url : CONTEXT + URL_REQUEST_AJAX + '?action=loadMetadata&isAjax=true' + TAB_ID_REQUEST,
		onRequest : function() { SYS_PANELS.showLoading(); },
		onComplete : function(resText, resXml) { processXmlMetadata(resXml); }
	}).send();
}

function processXmlMetadata(resXml){
	var metadata = resXml.getElementsByTagName("result")
	if (metadata != null && metadata.length > 0 && metadata.item(0) != null) {
		metadata = metadata.item(0).getElementsByTagName("metadata");
	
		for(var i = 0; i < metadata.length; i++){
			var xmlMetadata = metadata[i];
			
			var id = xmlMetadata.getAttribute("id");
			var name = xmlMetadata.getAttribute("name");
			var title = xmlMetadata.getAttribute("title");
			var type = xmlMetadata.getAttribute("type");
			var required = xmlMetadata.getAttribute("required");
			var used = toBoolean(xmlMetadata.getAttribute("used"));
			addNewMetadata(id,name,title,type,required,used);
		}			
	}
	
	fixTableMetadata();
	
	var table = $('tableMetadata');
	var footer = table.getParent('.fieldGroup').getElements('#buttonsDim');
	var notification = new Element('div', {id : 'editionNot'}); 
	footer.grab(notification, "top");
	initAdminModalHandlerOnChangeHighlight(table, true, false, notification);
	
	SYS_PANELS.closeLoading();
}

function addNewMetadata(id,name,title,type,required,used){
	used = used || IS_APIA_DOC_TYPE;
	
	var tr = new Element("tr",{'class': used ? '' : 'selectableTR'}).inject($('tableMetadata'));
	if (!used) tr.addEvent("click", function(evt) { this.toggleClass("selectedTR"); evt.stopPropagation(); });				
	tr.setAttribute("used",used);
	tr.isUsed = function () { return toBoolean(this.getAttribute("used")); }
	
	tr.setAttribute("rowId",id);
	tr.getRowId = function () { return this.getAttribute("rowId"); }
	
	var td1 = new Element("td", {'align':'center'}).inject(tr);
	var div1 = new Element('div', {styles: {width: '250px', overflow: 'hidden', 'white-space': 'pre', 'margin': '4px 0px'}}).inject(td1);
	var input1 = new Element('input',{'type': 'text', 'value': name, 'class': 'validate["required","~validName"]'}).inject(div1);
	input1.disabled = used;
	input1.setStyle("width","95%");
	input1.addEvent("click",function(e){ e.stopPropagation();})
	$('frmData').formChecker.register(input1);	
		
	var td2 = new Element("td", {'align':'center'}).inject(tr);
	var div2 = new Element('div', {styles: {width: '250px', overflow: 'hidden', 'white-space': 'pre', 'margin': '4px 0px'}}).inject(td2);
	var input2 = new Element('input',{'type': 'text', 'value': title, 'class': 'validate["required"]' }).inject(div2);
	$('frmData').formChecker.register(input2);
	input2.setStyle("width","95%");
	input2.addEvent("click",function(e){ e.stopPropagation();})
	input2.disabled = IS_APIA_DOC_TYPE;
	
	var td3 = new Element("td", {'align':'center'}).inject(tr);
	var div3 = new Element('div', {styles: {width: '120px', overflow: 'hidden', 'white-space': 'pre', 'margin': '4px 0px'}}).inject(td3);
	var select3 = new Element("select",{}).inject(div3);
	select3.disabled = used;
	select3.setStyle("width","95%");
	select3.addEvent("click",function(e){ e.stopPropagation();})
	new Element('option',{'value':'S',html: LBL_STRING}).inject(select3);
	new Element('option',{'value':'N',html: LBL_NUMERIC}).inject(select3);
	new Element('option',{'value':'D',html: LBL_DATE}).inject(select3);
	select3.value = type;
	
	var td4 = new Element("td", {'align':'center'}).inject(tr);
	var div4 = new Element('div', {styles: {width: '120px', overflow: 'hidden', 'white-space': 'pre', 'margin': '4px 0px'}}).inject(td4);
	var checkbox4 = new Element("input",{'type':'checkbox'}).inject(div4);
	checkbox4.addEvent("click",function(e){ e.stopPropagation();})
	checkbox4.checked = required == "Y";
	checkbox4.disabled = IS_APIA_DOC_TYPE;
	
	tr.getContentStr = function() { //format: id�name�type�required�title
		var tds = this.getElements("td");
		
		var id = this.getRowId();
		var name = tds[0].getElement("div").getElement("input").value;
		var title = tds[1].getElement("div").getElement("input").value;
		var type = tds[2].getElement("div").getElement("select").value;
		var required = tds[3].getElement("div").getElement("input").checked ? "Y" : "N";
		
		//armar string de valores para la dimension
		var str = id + PRIMARY_SEPARATOR + name + PRIMARY_SEPARATOR + type + PRIMARY_SEPARATOR + required + PRIMARY_SEPARATOR + title;
		return str;
	}	
	
	initAdminFieldOnChangeHighlight(false, false, false, tr);
}

function removeMetadata(toRemove){
	if (toRemove && toRemove.length > 0){
		for (var i = 0; i < toRemove.length; i++){
			var tr = toRemove[i];
			var inputName = tr.getElements("td")[0].getElement("div").getElement("input");
			$('frmData').formChecker.dispose(inputName);	
			var inputTitle = tr.getElements("td")[1].getElement("div").getElement("input");
			$('frmData').formChecker.dispose(inputTitle);	
			tr.destroy();
		}
	}
}

function moveRow(row,isUp){
	if (row){
		var pos = Number.from(row.getAttribute("pos"));
		trs = $('tableMetadata').getElements("tr");
		
		if ((pos == 0 && isUp) || (pos == trs.length-1 && !isUp)) return;
		
		var newPos = isUp ? (pos-1) : (pos+1); 
		
		var row2 = trs[newPos];
		
		if (isUp){
			row.inject(row2,'before');
		} else {
			row.inject(row2,'after');
		}
	}
}

function fixTableMetadata(){
	var tableMetadata = $('tableMetadata'); 
	
	var trs = tableMetadata.getElements("tr");
	for (var i = 0; i < trs.length; i++){
		var tr = trs[i];
		if (i % 2 == 0) tr.addClass("trOdd"); else tr.removeClass("trOdd");
		if (i == trs.length-1) tr.addClass("lastTr"); else tr.removeClass("lastTr");
		tr.setAttribute("pos",i);
	}
	
	addScrollTable(tableMetadata);
}

function addExtension(ext,used){
	if ($('defExt')){
		$('defExt').destroy();
	}
	
	var newExt = new Element("div.option", {html: ext}).inject($('add'),"before");
	
	used = used || IS_APIA_DOC_TYPE;
	if(used) {
		newExt.addClass('used');
	} else {
		new Element('div.optionRemove').addEvent('click', function() { processRemoveExt(this.getParent()); }).inject(newExt);
	}
	newExt.setAttribute("ext",ext);
}

function processRemoveExt(ext){
	ext.destroy();
	if ($$("div.optionRemove").length == 0 && $$("div.used").length == 0){
		addDefExtension();		
	}
}

function addDefExtension(){
	new Element("div", {'id':'defExt', 'class': 'option optionRemoveNoImg', html: DEFAULT_EXT}).inject($('add'),"before");
}

function existExtension(ext){
	var exist = false;
	var container = $('extsContainter');
	container.getElements("div.optionRemove").each(function(objExt){
		exist = exist || objExt.getParent().getAttribute("ext") == ext;
	});
	container.getElements("div.used").each(function(objExt){
		exist = exist || objExt.getAttribute("ext") == ext;
	});
	return exist;
}

function processAddExtension(evt){
	var ok = true;
	if (evt){ ok = (evt.key == "enter"); }
	if (ok){
		var newExt = $('addExt').value;
		if (newExt != "" && newExt[0] == "."){
			if (newExt == "."){
				newExt = "";
			} else {
				newExt = newExt.substring(1);
			}
		}
		newExt = newExt.toLowerCase();
		if (newExt != "" && !existExtension(newExt)){
			addExtension(newExt,false);						
		}
		$('addExt').value = '';
	}
}

function arrayContain(array,element){
	var contain = false;
	if (array != null && array.length > 0){
		var i = 0;
		while (i < array.length && !contain){
			contain = (array[i] == element);
			i++;
		}
	}
	return contain;	
}

function isValidNum(el){
	if (el.value == "") return true;
	
	var ok = true;
	for (var i = 0; i < el.value.length && ok; i++){
		var num = el.value[i];
		ok = num >= '0' && num <= '9' 
	}
	if (!ok) {
		el.errors.push(MSG_NUMERIC.replace('"<TOK1>"',"").replace('""',""));
		return false;
	}
	return true;
}

function processModalImageConfirm(image){
	if (image != null){
		var txtPathImg = $('imgPath');
		var changeImg = $('changeImg'); 
		changeImg.style.backgroundImage = "url('"+image.path+"')";
		txtPathImg.value = image.id;
		txtPathImg.fireEvent('change');
	}
}
