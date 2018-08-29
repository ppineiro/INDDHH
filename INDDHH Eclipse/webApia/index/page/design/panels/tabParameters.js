
var fstTime;

function initTabParameters(){
	fstTime = true;
	
	$('tabParameters').addEvent("focus", function(evt){
		if (fstTime){
    		fixTableParameters();
    		fstTime = false;
    	}
    }); 
	
	$('btnAddParam').addEvent("click", function(e){
		e.stop();
		createParameter("null", "", "", "", "", "", PNL_PARAM_VIEW_TYPE_INPUT);
		fixTableParameters();
	});
	$('btnDelParam').addEvent("click", function(e){
		e.stop();
		if (selectionCount($('tableParams')) == 0) { 
			showMessage(GNR_CHK_AT_LEAST_ONE, GNR_TIT_WARNING, 'modalWarning');
		} else {
			var selected = getSelectedRows($('tableParams'));
			selected.each(function (tr){
				deleteParameter(tr);
			});
			fixTableParameters();
		}
	});	
	
	loadParameters();
}

function loadParameters(){
	var request = new Request({
		method : 'post',
		url : CONTEXT + URL_REQUEST_AJAX + '?action=loadParameters&isAjax=true' + TAB_ID_REQUEST,
		onRequest : function() { },
		onComplete : function(resText, resXml) { processXmlParameters(resXml); }
	}).send();
}

function processXmlParameters(resXml){
	cleanTableParameters();
	
	var parameters = resXml.getElementsByTagName("parameters")
	if (parameters != null && parameters.length > 0 && parameters.item(0) != null) {
		//parameters = parameters.item(0).getElements("parameter");
		parameters = parameters.item(0).getElementsByTagName("parameter");
				
		for (var i = 0; i < parameters.length; i++){
			var xmlParam = parameters[i];
			var paramId = xmlParam.getAttribute("id");
			var paramName = xmlParam.getAttribute("name");
			var paramTitle = xmlParam.getAttribute("title");
			var paramDesc = xmlParam.getAttribute("description");
			var paramType = xmlParam.getAttribute("type");
			var paramSrc = xmlParam.getAttribute("source");
			var paramViewType = xmlParam.getAttribute("viewType");
			createParameter(paramId,paramName,paramTitle,paramDesc,paramType,paramSrc,paramViewType);			
		}		
	}
	
	fixTableParameters();
}

function createParameter(paramId,paramName,paramTitle,paramDesc,paramType,paramSrc,paramViewType){
	var tr = new Element("tr",{'class': 'selectableTR'}).inject($('tableParams'));
	tr.setAttribute("rowId",paramId != null && paramId != "" ? paramId : "null");
	tr.addEvent("click", function(evt) { this.toggleClass("selectedTR"); evt.stopPropagation(); });
	
	//td1 NOMBRE
	var td1 = new Element("td", {'align':'center'}).inject(tr);
	var div1 = new Element('div', {styles: {width: '165px', overflow: 'hidden', 'white-space': 'pre', 'margin': '4px 0px'}}).inject(td1);
	var inputName = new Element('input',{'type':'text','class':'validate["required","~validName"]','value':paramName}).inject(div1);
	inputName.maxLength = 50;
	inputName.setStyle("width","95%");
	inputName.addEvent('click', function(evt){ evt.stopPropagation(); });
	$('frmData').formChecker.register(inputName);
	
	//td2 TITULO
	var td2 = new Element("td", {'align':'center'}).inject(tr);
	var div2 = new Element('div', {styles: {width: '185px', overflow: 'hidden', 'white-space': 'pre', 'margin': '4px 0px'}}).inject(td2);
	var inputTitle = new Element('input',{'type':'text','value':paramTitle, 'class':'validate["required"]'}).inject(div2);
	inputTitle.maxLength = 250;
	inputTitle.setStyle("width","95%");
	inputTitle.addEvent('click', function(evt){ evt.stopPropagation(); });
	$('frmData').formChecker.register(inputTitle);	
	
	//td3 DESCRIPCION
	var td3 = new Element("td", {'align':'center'}).inject(tr);
	var div3 = new Element('div', {styles: {width: '185px', overflow: 'hidden', 'white-space': 'pre', 'margin': '4px 0px'}}).inject(td3);
	var inputDesc = new Element('input',{'type':'text','value':paramDesc }).inject(div3);
	inputDesc.maxLength = 255;
	inputDesc.setStyle("width","95%");
	inputDesc.addEvent('click', function(evt){ evt.stopPropagation(); });
			
	//td4 TIPO
	var td4 = new Element("td", {'align':'center'}).inject(tr);
	var div4 = new Element('div', {styles: {width: '75px', overflow: 'hidden', 'white-space': 'pre', 'margin': '4px 0px'}}).inject(td4);
	var selectType = new Element("select",{'class':'validate["required"]'}).inject(div4);
	selectType.setStyle("width","95%");
	new Element('option', {'value': "", html: "" }).inject(selectType);
	new Element('option', {'value': PNL_PARAM_TYPE_TXT, html: LBL_TXT }).inject(selectType);
	new Element('option', {'value': PNL_PARAM_TYPE_NUM, html: LBL_NUM }).inject(selectType);
	new Element('option', {'value': PNL_PARAM_TYPE_DTE, html: LBL_DTE }).inject(selectType);
	selectType.value = paramType;
	$('frmData').formChecker.register(selectType);
	selectType.addEvent('click', function(evt){ evt.stopPropagation(); });
		
	//td5 ORIGEN
	var td5 = new Element("td", {'align':'center'}).inject(tr);
	var div5 = new Element('div', {styles: {width: '100px', overflow: 'hidden', 'white-space': 'pre', 'margin': '4px 0px'}}).inject(td5);
	var selectSource = new Element("select",{'class':'validate["required"]'}).inject(div5);
	selectSource.setStyle("width","95%");
	new Element('option', {'value': "", html: "" }).inject(selectSource);
	new Element('option', {'value': PNL_PARAM_SRC_ADMIN, html: LBL_ADMIN }).inject(selectSource);
	new Element('option', {'value': PNL_PARAM_SRC_EXEC, html: LBL_EXEC }).inject(selectSource);
	new Element('option', {'value': PNL_PARAM_SRC_BOTH, html: LBL_BOTH }).inject(selectSource);
	selectSource.value = paramSrc;
	$('frmData').formChecker.register(selectSource);
	selectSource.addEvent('click', function(evt){ evt.stopPropagation(); });
	
	//td6 VISUALIZACION
	if (paramViewType == null || paramViewType == undefined) { paramViewType = PNL_PARAM_VIEW_TYPE_INPUT; }
	var td6 = new Element("td", {'align':'center'}).inject(tr);
	var div6 = new Element('div', {styles: {width: '80px', overflow: 'hidden', 'white-space': 'pre', 'margin': '4px 0px'}}).inject(td6);
	var selectViewType = new Element("select",{}).inject(div6);
	selectViewType.setStyle("width","95%");
	new Element('option', {'value': PNL_PARAM_VIEW_TYPE_INPUT, html: LBL_INPUT, 'selected': PNL_PARAM_VIEW_TYPE_INPUT == paramViewType }).inject(selectViewType);
	new Element('option', {'value': PNL_PARAM_VIEW_TYPE_COMBOBOX, html: LBL_COMBOBOX, 'selected': PNL_PARAM_VIEW_TYPE_COMBOBOX == paramViewType }).inject(selectViewType);
	new Element('option', {'value': PNL_PARAM_VIEW_TYPE_CHECKBOX, html: LBL_CHECKBOX, 'selected': PNL_PARAM_VIEW_TYPE_CHECKBOX == paramViewType }).inject(selectViewType);
	new Element('option', {'value': PNL_PARAM_VIEW_TYPE_MDL_ENV, html: LBL_MDL_ENV, 'selected': PNL_PARAM_VIEW_TYPE_MDL_ENV == paramViewType }).inject(selectViewType);
	new Element('option', {'value': PNL_PARAM_VIEW_TYPE_MDL_PRO, html: LBL_MDL_PRO, 'selected': PNL_PARAM_VIEW_TYPE_MDL_PRO == paramViewType }).inject(selectViewType);
	new Element('option', {'value': PNL_PARAM_VIEW_TYPE_MDL_TSK, html: LBL_MDL_TSK, 'selected': PNL_PARAM_VIEW_TYPE_MDL_TSK == paramViewType }).inject(selectViewType);
	new Element('option', {'value': PNL_PARAM_VIEW_TYPE_MDL_ENT, html: LBL_MDL_ENT, 'selected': PNL_PARAM_VIEW_TYPE_MDL_ENT == paramViewType }).inject(selectViewType);
	new Element('option', {'value': PNL_PARAM_VIEW_TYPE_MDL_CAT, html: LBL_MDL_CAT, 'selected': PNL_PARAM_VIEW_TYPE_MDL_CAT == paramViewType }).inject(selectViewType);
	new Element('option', {'value': PNL_PARAM_VIEW_TYPE_MDL_DSH, html: LBL_MDL_DSH, 'selected': PNL_PARAM_VIEW_TYPE_MDL_DSH == paramViewType }).inject(selectViewType);
	
	selectViewType.value = paramViewType;
	
	tr.getRowId = function () { return this.getAttribute("rowId"); }	
	tr.getRowContentStr = function (){ //format: paramId�paramName�paramTitle�paramDesc�paramType�paramSrc�paramViewType
		var tds = tr.getElements("div");
		
		var paramId = this.getRowId();
		var paramName = tds[0].getElements("input")[0].value;
		var paramTitle = tds[1].getElements("input")[0].value;
		var paramDesc = tds[2].getElements("input")[0].value;
		var paramType = tds[3].getElements("select")[0].value;
		var paramSrc = tds[4].getElements("select")[0].value;
		var paramViewType = tds[5].getElements("select")[0].value;
				
		var paramStr = "";
		paramStr = paramId + PRIMARY_SEPARATOR + paramName + PRIMARY_SEPARATOR + paramTitle + PRIMARY_SEPARATOR + paramDesc + PRIMARY_SEPARATOR + paramType + PRIMARY_SEPARATOR + paramSrc + PRIMARY_SEPARATOR + paramViewType; 
				
		return paramStr;
	}
}

function deleteParameter(trParam){
	registerOrDisposeRequired(false,trParam);
	trParam.destroy();
}

function registerOrDisposeRequired(register,trParam){
	var tds = trParam.getElements("div");
	var inputName = tds[0].getElements("input")[0];
	var inputTitle = tds[1].getElements("input")[0];
	var selectType = tds[3].getElements("select")[0];
	var selectSource = tds[4].getElements("select")[0];
	if (register){
		$('frmData').formChecker.register(inputName);
		$('frmData').formChecker.register(inputTitle);
		$('frmData').formChecker.register(selectType);
		$('frmData').formChecker.register(selectSource);
	} else { //dispose
		$('frmData').formChecker.dispose(inputName);
		$('frmData').formChecker.dispose(inputTitle);
		$('frmData').formChecker.dispose(selectType);
		$('frmData').formChecker.dispose(selectSource);
	}
}

function fixTableParameters(){
	var table =  $('tableParams');
	var trs = table.getElements("tr"); 
	var total = trs.length;
	var i = 1;
	trs.each(function (tr){
		if (i % 2 == 0){
			tr.addClass("trOdd");
		} else {
			tr.removeClass("trOdd");
		}
		if (i == total){
			tr.addClass("lastTr");
		} else {
			tr.removeClass("lastTr");
		}
		i++;
	});	
	addScrollTable(table);
}

function setParameters(){
	if (checkParamNames()){
		var strParams = "";
		$('tableParams').getElements("tr").each(function (tr){
			if (strParams != "") strParams += ";";
			strParams += tr.getRowContentStr();
		});
		$('strParams').value = strParams;
		
		return true;
	} else {
		return false;
	}
}

function cleanTableParameters(){
	$('tableParams').getElements("tr").each(function (tr){ deleteParameter(tr); });
}

function showTabParameters(show){
	if (show){ //mostrar
		$('tabParameters').style.display = "";
		
		//agregar requeridos
		$('tableParams').getElements("tr").each(function (tr){
			registerOrDisposeRequired(true,tr);
		});
	} else { //ocultar
		$('tabParameters').style.display = "none";
		
		//eliminar requeridos
		$('tableParams').getElements("tr").each(function (tr){
			registerOrDisposeRequired(false,tr);
		});
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

function checkParamNames(){
	if ($('tabParameters').style.display == "none") return true;
	
	var trs = $('tableParams').getElements("tr");
	var arrayNames = new Array();
	
	var exist = false;
	for (var i = 0; i < trs.length && !exist; i++){
		var paramName = trs[i].getElements("td")[0].getElements("input")[0].value;
		if (paramName != ""){
			paramName = paramName.toUpperCase();
			exist = arrayContain(arrayNames,paramName);
			arrayNames.push(paramName);
		}
	}
	
	if (exist){
		$('tabParameters').fireEvent("click");
		showMessage(PARAM_NAMES_EXIST, GNR_TIT_WARNING, 'modalWarning');
	}
	
	return !exist;
}