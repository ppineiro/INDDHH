var additionalFilters;
function initPage(){
	//crear spinner de espere un momento
	sp = new Spinner(document.body,{message:WAIT_A_SECOND});
	
	$('frmData').formChecker = new FormCheck(
			'frmData',
			{
				submit:false,
				display : {
					keepFocusOnError : 1,
					tipsPosition: 'left',
					tipsOffsetX: -10
				}
			}
		);
	
	//Botones
	$('btnSearch').addEvent("click",function(e){
		if (e) e.stop();
		
		var form = $('frmData');
		if(!form.formChecker.isFormValid()){
			return;
		}
		
		var params = getFormParametersToSend(form);
		
		var request = new Request({
			method: 'post',
			url: CONTEXT + URL_REQUEST_AJAX + '?action=searchQuery&isAjax=true' + TAB_ID_REQUEST,
			onRequest: function() { SYS_PANELS.showLoading(); },
			onComplete: function(resText, resXml) { SYS_PANELS.closeAll(); modalProcessXml(resXml); }
		}).send(params);
	});
	$('btnReset').addEvent("click",function(e){
		e.stop();
		if ($('divQry').style.display == ''){
			cleanFilters();
			cleanGrid();
		}		
	});
	$('btnReschedule').addEvent("click",function(e){
		e.stop();
		
		if ($('cmbTskSchedQrySched').value == NO_SEL_TSK_SCHEDULER){
			showMessage(MSG_SEL_TSK_SCH, GNR_TIT_WARNING, 'modalWarning');
			return;
		}
		
		if (selectionCount($('tableDataQry')) > 1) {
			showMessage(GNR_CHK_ONLY_ONE, GNR_TIT_WARNING, 'modalWarning');
		} else if (selectionCount($('tableDataQry')) == 0) {
			showMessage(GNR_CHK_AT_LEAST_ONE, GNR_TIT_WARNING, 'modalWarning');
		} else {
			var id = getSelectedRows($('tableDataQry'))[0].getRowId();
			var request = new Request({
				method: 'post',
				url: CONTEXT + URL_REQUEST_AJAX + '?action=canReschedule&isAjax=true&id=' + id + TAB_ID_REQUEST,
				onRequest: function() { SYS_PANELS.showLoading(); },
				onComplete: function(resText, resXml) { SYS_PANELS.closeAll(); modalProcessXml(resXml); }
			}).send();			
		}
	});
	$('btnCloseTab').addEvent("click",function(e){ getTabContainerController().removeActiveTab(); });
	//['btnSearch','btnReset','btnReschedule','btnCloseTab'].each(setTooltip);
	
	initFilters();
	if (FROM_BACK){
		$('cmbTskSchedQrySched').value = TSK_SCH_SEL;
		showQuery(true);
	}
	
	initNavButtons();
	initAdminFav();	
	getBodyController().canRemoveTab = function() { return ! AT_LEAST_ON_FIELD_INPUT_CHANGED; };
}

function initFilters(){
	setAdmDatePicker($('txtFchFrom'));
	setAdmDatePicker($('txtFchTo'));
	
	setAdmDatePicker($('txtStaSta'));
	setAdmDatePicker($('txtStaEnd'));	
	
	$('txtHorFrom').addClass("validate['~validHrMin']");
	$('frmData').formChecker.register($('txtHorFrom'));
	setHourField('txtHorFrom');
	$('txtHorTo').addClass("validate['~validHrMin']");
	$('frmData').formChecker.register($('txtHorTo'));
	setHourField('txtHorTo');
	
	$('txtNamNum').addClass("validate['digit']");
	$('frmData').formChecker.register($('txtNamNum'));
	
	additionalFilters = "";
	
	$('txtFchFrom').addEvent('change',function (e){
		if ($('txtFchFrom').value != '' && $('txtHorFrom').value == ''){
			$('txtHorFrom').value = '00:00';
		}		
	});
	$('txtFchTo').addEvent('change',function (e){
		if ($('txtFchTo').value != '' && $('txtHorTo').value == ''){
			$('txtHorTo').value = '00:00';
		}
	});
}

function validHrMin(ele){
	if (ele.value == "") return true;
	var arrHr = ele.value.split(HOUR_SEPARATOR);
	var reHr = new RegExp("^([0-1][0-9]|2[0-3])");
	var reMin = new RegExp("^([0-5][0-9])");
	if (!reHr.test(arrHr[0]) || !reMin.test(arrHr[1])){
		ele.errors.push(ERR_FORMAT_HR_MIN.replace("<TOK1>",HOUR_SEPARATOR));
		return false;
	}
	return true;
}

function requieredTskSch(ele){
	if (ele.value == "" || ele.value == null || ele.value == NO_SEL_TSK_SCHEDULER){
		ele.errors.push(MSG_REQ_FIELD);
		return false;
	}
	return true;
}

function onChangeCmbTskSchedQrySched(cmbTskSchedQrySched){
	if ($('divQry').style.display == ''){
		cleanFilters();
		destroyAdtFilters();
		cleanGrid();		
	}
	var tskSchedId = cmbTskSchedQrySched.value;
	var request = new Request({
		method: 'post',
		url: CONTEXT + URL_REQUEST_AJAX + '?action=loadTaskScheduler&isAjax=true&id=' + tskSchedId + TAB_ID_REQUEST,
		onRequest: function() { SYS_PANELS.showLoading(); },
		onComplete: function(resText, resXml) { modalProcessXml(resXml); }
	}).send();
}

function showQuery(show){
	if (show){
		$('divQry').style.display = '';	
		$('divGridQry').style.display = '';
		
		$('txtProTitle').disabled = false;
		$('txtInstUser').disabled = false;
		$('txtNamPre').disabled = false;
		$('txtNamNum').disabled = false;
		$('txtNamPos').disabled = false;
		
		$('txtStaSta').disabled = false;
		$('txtStaSta').getNext().disabled = false;
		$('txtStaEnd').disabled = false;
		$('txtStaEnd').getNext().disabled = false;
		
		$('txtFchFrom').disabled = false;
		$('txtFchFrom').getNext().disabled = false;
		$('txtHorFrom').disabled = false;
		
		$('txtFchTo').disabled = false;
		$('txtFchTo').getNext().disabled = false;
		$('txtHorTo').disabled = false;
		
		loadAdditionalFilters();		
	} else {
		$('divQry').style.display = 'none';
		$('divGridQry').style.display = 'none';
		
		$('txtProTitle').disabled = true;
		$('txtInstUser').disabled = true;
		$('txtNamPre').disabled = true;
		$('txtNamNum').disabled = true;
		$('txtNamPos').disabled = true;
		
		$('txtStaSta').disabled = true;
		$('txtStaSta').getNext().disabled = true;
		$('txtStaEnd').disabled = true;
		$('txtStaEnd').getNext().disabled = true;
		
		$('txtFchFrom').disabled = true;
		$('txtFchFrom').getNext().disabled = true;
		$('txtHorFrom').disabled = true;
		
		$('txtFchTo').disabled = true;
		$('txtFchTo').getNext().disabled = true;
		$('txtHorTo').disabled = true;
		
		if ($('divQry').style.display == ''){
			cleanFilters();
			cleanGrid();
		}
	}
	SYS_PANELS.closeAll();
}

function loadAdditionalFilters(){
	var request = new Request({
		method: 'post',
		url: CONTEXT + URL_REQUEST_AJAX + '?action=loadAdditionalFilters&isAjax=true' + TAB_ID_REQUEST,
		onRequest: function() { },
		onComplete: function(resText, resXml) { processXmlAdtFilters(resXml); if (FROM_BACK) { $('btnSearch').fireEvent("click"); FROM_BACK = false; } }
	}).send();
}

function processXmlAdtFilters(resXml){
	additionalFilters = "";
	var attributes = resXml.getElementsByTagName("attributes")
	if (attributes != null && attributes.length > 0 && attributes.item(0) != null) {
		attributes = attributes.item(0).getElementsByTagName("attribute");
		
		var container = $('divContentFilter');
		
		for(var i = 0; i < attributes.length; i++){
			var xmlAtt = attributes[i];
			
			var attId = "txtAtt_" + xmlAtt.getAttribute("id");
			var attLbl = xmlAtt.getAttribute("label");
			var attType = xmlAtt.getAttribute("type");
			var attReq = false;//toBoolean(xmlAtt.getAttribute("required"));
			var attVal = xmlAtt.getAttribute("value");
			
			var divFilter = new Element("div", {'class':'filter' + (attReq ? ' filterRequired' : '')}).inject(container);
			var spanFilter = new Element("span",{html: attLbl + ":&nbsp;"}).inject(divFilter);
			var inputFilter = new Element("input",{'id':attId, 'name':attId, 'value':attVal, 'type':'text'}).inject(divFilter);
			inputFilter.setAttribute("attType",attType);
			inputFilter.setAttribute("attId",attId);
			inputFilter.setAttribute("attReq",attReq);
			if (attType == TYPE_NUMERIC){
				inputFilter.addClass("validate['number'" + (attReq ? ",'required'" : "") + "]");
				$('frmData').formChecker.register(inputFilter);
			} else if (attType == TYPE_INT){
				inputFilter.addClass("validate['digit'" + (attReq ? ",'required'" : "") + "]");
				$('frmData').formChecker.register(inputFilter);
			} else if (attType == TYPE_DATE){
				inputFilter.size = "9";
				inputFilter.maxlength = "10";
				inputFilter.format = "d/m/Y";				
				inputFilter.addClass("datePicker filterInputDate");
				setAdmDatePicker(inputFilter);
				if (attReq) {
					inputFilter.getNext().addClass("validate['required']");
					$('frmData').formChecker.register(inputFilter.getNext());
				}
			} else { //String
				if (attReq) {
					inputFilter.addClass("validate['required']");
					$('frmData').formChecker.register(inputFilter);
				}
			}	
			
			if (additionalFilters != "") additionalFilters += ";";
			additionalFilters += attId;
		}	
	}
	
	if (additionalFilters != ""){
		$('divFilters').style.display = '';
	}
}

function cleanFilters(){
	$('txtProTitle').value = '';
	$('txtInstUser').value = '';
	$('txtNamPre').value = '';
	$('txtNamNum').value = '';
	$('txtNamPos').value = '';
	
	$('txtStaSta').value = '';
	$('txtStaSta').getNext().value = '';
	$('txtStaEnd').value = '';
	$('txtStaEnd').getNext().value = '';
	
	$('txtFchFrom').value = '';
	$('txtFchFrom').getNext().value = '';
	$('txtHorFrom').value = '';
	
	$('txtFchTo').value = '';
	$('txtFchTo').getNext().value = '';
	$('txtHorTo').value = '';
		
	if (additionalFilters != ""){
		var arrAddFilters = additionalFilters.split(";");
		for(var i = 0; i < arrAddFilters.length; i++){
			var objFilter = $(arrAddFilters[i]);
			if (objFilter){
				objFilter.value = "";
				if (objFilter.getAttribute("attType") == TYPE_DATE){
					objFilter.getNext().value = "";
				}
			}
		}
	}
}

function destroyAdtFilters(){
	$('divFilters').style.display = 'none';
	if (additionalFilters != ""){
		var arrAddFilters = additionalFilters.split(";");
		for(var i = 0; i < arrAddFilters.length; i++){
			var objFilter = $(arrAddFilters[i]);
			if (objFilter){
				var attType = objFilter.getAttribute("attType");
				if (attType == TYPE_DATE){
					$('frmData').formChecker.dispose(objFilter.getNext());
				} else if (attType == TYPE_NUMERIC || attType == TYPE_INT || toBoolean(objFilter.getAttribute("attReq"))){
					$('frmData').formChecker.dispose(objFilter);
				}
				objFilter.parentNode.destroy();
			}
		}
	}
	additionalFilters = "";	
}

function cleanGrid(){
	var table = $('tableDataQry');
	table.getElements("tr").each(function (tr){
		tr.destroy();
	});
	addScrollTable(table);
}

function loadQuery(){
	var request = new Request({
		method: 'post',
		url: CONTEXT + URL_REQUEST_AJAX + '?action=loadQuery&isAjax=true' + TAB_ID_REQUEST,
		onRequest: function() { SYS_PANELS.showLoading(); },
		onComplete: function(resText, resXml) { processXmlQuery(resXml); }
	}).send();
}

function processXmlQuery(resXml){
	$('divQry').style.display = '';
	$('divGridQry').style.display = '';
	cleanGrid();
	var hasRecords = false;
	var tableDataQry = $('tableDataQry');
	var query = resXml.getElementsByTagName("query")
	
	if (query != null && query.length > 0 && query.item(0) != null) {
		var hasAdditionalInfo = toBoolean(query.item(0).getAttribute("hasAdtInfo"));
		query = query.item(0).getElementsByTagName("tskSchMon");
		
		hasRecords = query.length > 0;
		
		for(var i = 0; i < query.length; i++){
			var xmlQry = query[i];
			
			var tr = new Element("tr",{'class': 'selectableTR' + (toBoolean(xmlQry.getAttribute("selected")) ? ' selectedTR' : '') }).inject(tableDataQry);
			tr.setAttribute("rowId",xmlQry.getAttribute("id"));
			tr.getRowId = function () { return this.getAttribute("rowId"); };
			tr.addEvent("click", function(e){ this.toggleClass("selectedTR"); e.stopPropagation(); });
			if (i % 2 == 0) { tr.addClass("trOdd"); }
			if (i == query.length-1) { tr.addClass("lastTr"); }			
			
			//td1 IDENTIFICACION PROCESO
			var td1 = new Element("td", {styles: {width: '15%'}}).inject(tr);
			var div1 = new Element('div', {styles: {width: '100%', overflow: 'hidden', 'white-space': 'pre', 'margin': '4px 0px'}}).inject(td1);
			if (hasAdditionalInfo) {
				var additionalInfo = new Element("div", {'class': 'additionalInfo'}).inject(div1);
				additionalInfo.trParent = tr;
				additionalInfo.loaded = false;
				additionalInfo.tdWidths = 5;
				additionalInfo.minTdWidth = 500;//minTdWidth;
				additionalInfo.addEvent('click', fncAdditionalInfo);
			}
			var spanOp = new Element('span',{html: xmlQry.getAttribute("proIdent")}).inject(div1);			
			
			//td2 PROCESO
			var td2 = new Element("td", {styles: {width: '30%'}}).inject(tr);
			var div2 = new Element('div', {styles: {width: '100%', overflow: 'hidden', 'white-space': 'pre', 'margin': '4px 0px'}}).inject(td2);
			var spanOp = new Element('span',{html: xmlQry.getAttribute("proName")}).inject(div2);
			if (div2.scrollWidth > div2.offsetWidth) {
				td2.title = xmlQry.getAttribute("proName");
				td2.addClass("titiled");
			}
			
			//td3 TAREA
			var td3 = new Element("td", {styles: {width: '25%'}}).inject(tr);
			var div3 = new Element('div', {styles: {width: '100%', overflow: 'hidden', 'white-space': 'pre', 'margin': '4px 0px'}}).inject(td3);
			var spanRangeHr = new Element('span',{html: xmlQry.getAttribute("tskName") }).inject(div3);
			if (div3.scrollWidth > div3.offsetWidth) {
				td3.title = xmlQry.getAttribute("tskName");
				td3.addClass("titiled");
			}
			
			//td4 FECHA
			var td4 = new Element("td", {styles: {width: '15%'}}).inject(tr);
			var div4 = new Element('div', {styles: {width: '100%', overflow: 'hidden', 'white-space': 'pre', 'margin': '4px 0px'}}).inject(td4);
			var spanDisp = new Element('span',{html: xmlQry.getAttribute("dateAct")}).inject(div4);
			
			//td5 HORA
			var td5 = new Element("td", {styles: {width: '15%'}}).inject(tr);
			var div5 = new Element('div', {styles: {width: '100%', overflow: 'hidden', 'white-space': 'pre', 'margin': '4px 0px'}}).inject(td5);
			var spanUsr = new Element('span',{html: xmlQry.getAttribute("hourAct")}).inject(div5);
		}		
	}
	
	SYS_PANELS.closeAll();
	
	if (hasRecords){
		addScrollTable(tableDataQry);
	} else {
		showMessage(GNR_MORE_RECORDS);
	}	
}

function startReschedule(ok){
	if (ok){
		sp.show(true);
		window.location = CONTEXT + URL_REQUEST_AJAX + '?action=goToReschedulePage' + TAB_ID_REQUEST;
	} else {
		showMessage(MSG_NO_PERM, GNR_TIT_WARNING, 'modalWarning');		
	}
}

