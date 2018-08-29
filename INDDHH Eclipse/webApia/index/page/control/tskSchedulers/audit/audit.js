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
		e.stop();
		
		var form = $('frmData');
		if(!form.formChecker.isFormValid()){
			return;
		}
		
		var params = getFormParametersToSend(form);
		
		var request = new Request({
			method: 'post',
			url: CONTEXT + URL_REQUEST_AJAX + '?action=searchHistory&isAjax=true' + TAB_ID_REQUEST,
			onRequest: function() { SYS_PANELS.showLoading(); },
			onComplete: function(resText, resXml) { SYS_PANELS.closeAll(); modalProcessXml(resXml); }
		}).send(params);
	});
	$('btnReset').addEvent("click",function(e){
		e.stop();
		if ($('divHistory').style.display == ''){
			cleanFilters();
			cleanGrid();
		}		
	});
	$('btnCloseTab').addEvent("click",function(e){ getTabContainerController().removeActiveTab(); });
	//['btnSearch','btnReset','btnCloseTab'].each(setTooltip);
	
	initFilters();
	
	initAdminFav();	
	getBodyController().canRemoveTab = function() { return ! AT_LEAST_ON_FIELD_INPUT_CHANGED; };
}

function initFilters(){
	setAdmDatePicker($('txtFch'));
	$('txtFch').getNext().addClass("validate['required']");
	$('frmData').formChecker.register($('txtFch').getNext());
	$('txtHor').addClass("validate['required','~validHrMin']");
	$('txtHor').addClass("validate['~validHrMin']");
	$('frmData').formChecker.register($('txtHor'));
	setHourField('txtHor');	
	
	setAdmDatePicker($('txtFchFrom'));
	$('txtHorFrom').addClass("validate['~validHrMin']");
	$('frmData').formChecker.register($('txtHorFrom'));
	setHourField('txtHorFrom');
	setAdmDatePicker($('txtFchTo'));
	$('txtHorTo').addClass("validate['~validHrMin']");
	$('frmData').formChecker.register($('txtHorTo'));
	setHourField('txtHorTo');
	
	
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

function onChangeCmbTskSchedAudit(cmbTskSchedAudit){
	if ($('divHistory').style.display == ''){
		cleanFilters();
		cleanGrid();
	}
	var tskSchedId = cmbTskSchedAudit.value;
	var request = new Request({
		method: 'post',
		url: CONTEXT + URL_REQUEST_AJAX + '?action=loadTaskScheduler&isAjax=true&id=' + tskSchedId + TAB_ID_REQUEST,
		onRequest: function() { SYS_PANELS.showLoading(); },
		onComplete: function(resText, resXml) { modalProcessXml(resXml); }
	}).send();
}

function showHistory(show){
	if (show){
		$('divHistory').style.display = '';	
		
		$('txtFch').disabled = false;
		$('txtFch').getNext().disabled = false;
		$('txtHor').disabled = false;
		
		$('txtUsr').disabled = false;
		
		$('txtFchFrom').disabled = false;
		$('txtFchFrom').getNext().disabled = false;
		$('txtHorFrom').disabled = false;
		
		$('txtFchTo').disabled = false;
		$('txtFchTo').getNext().disabled = false;
		$('txtHorTo').disabled = false;		
		
	} else {
		$('divHistory').style.display = 'none';
		
		$('txtFch').disabled = true;
		$('txtFch').getNext().disabled = true;
		$('txtHor').disabled = true;
		
		$('txtUsr').disabled = true;
		
		$('txtFchFrom').disabled = true;
		$('txtFchFrom').getNext().disabled = true;
		$('txtHorFrom').disabled = true;
		
		$('txtFchTo').disabled = true;
		$('txtFchTo').getNext().disabled = true;
		$('txtHorTo').disabled = true;		
		
		if ($('divHistory').style.display == ''){
			cleanFilters();
			cleanGrid();
		}
	}
	SYS_PANELS.closeAll();
}

function cleanFilters(){
	$('txtFch').value = '';
	$('txtFch').getNext().value = '';
	$('txtHor').value = '';
	$('txtUsr').value = '';
	
	$('txtFchFrom').value = '';
	$('txtFchFrom').getNext().value = '';
	$('txtHorFrom').value = '';
	
	$('txtFchTo').value = '';
	$('txtFchTo').getNext().value = '';
	$('txtHorTo').value = '';	
}

function cleanGrid(){
	var table = $('tableDataHist');
	table.getElements("tr").each(function (tr){
		tr.destroy();
	});
	addScrollTable(table);
}

function loadHistory(){
	var request = new Request({
		method: 'post',
		url: CONTEXT + URL_REQUEST_AJAX + '?action=loadHistory&isAjax=true' + TAB_ID_REQUEST,
		onRequest: function() { SYS_PANELS.showLoading(); },
		onComplete: function(resText, resXml) { processXmlHistory(resXml); }
	}).send();
}

function processXmlHistory(resXml){
	$('divHistory').style.display = '';
	cleanGrid();
	var hasRecords = false;
	var tableDataHist = $('tableDataHist');
	var history = resXml.getElementsByTagName("history")
	if (history != null && history.length > 0 && history.item(0) != null) {
		history = history.item(0).getElementsByTagName("tskSchHist");
		
		hasRecords = history.length > 0;
		
		for(var i = 0; i < history.length; i++){
			var xmlHist = history[i];
			
			var tr = new Element("tr",{}).inject(tableDataHist);
			if (i % 2 == 0) { tr.addClass("trOdd"); }
			if (i == history.length-1) { tr.addClass("lastTr"); }			
			
			//td1 OPERACION
			var td1 = new Element("td", {styles: {width: '30%'}}).inject(tr);
			var div1 = new Element('div', {styles: {width: '100%', overflow: 'hidden', 'white-space': 'pre', 'margin': '4px 0px'}}).inject(td1);
			var spanOp = new Element('span',{html: xmlHist.getAttribute("operation")}).inject(div1);
			if (div1.scrollWidth > div1.offsetWidth) {
				td1.title = xmlHist.getAttribute("operation");
				td1.addClass("titiled");
			}
			
			//td2 RANGO HORARIO
			var td2 = new Element("td", {styles: {width: '15%'}}).inject(tr);
			var div2 = new Element('div', {styles: {width: '100%', overflow: 'hidden', 'white-space': 'pre', 'margin': '4px 0px'}}).inject(td2);
			var spanRangeHr = new Element('span',{html: xmlHist.getAttribute("rangeHr") }).inject(div2);
			
			//td3 DISPONIBILIDAD
			var td3 = new Element("td", {styles: {width: '20%'}}).inject(tr);
			var div3 = new Element('div', {styles: {width: '100%', overflow: 'hidden', 'white-space': 'pre', 'margin': '4px 0px'}}).inject(td3);
			var spanDisp = new Element('span',{html: xmlHist.getAttribute("disponibility")}).inject(div3);
			
			//td4 USUARIO
			var td4 = new Element("td", {styles: {width: '15%'}}).inject(tr);
			var div4 = new Element('div', {styles: {width: '100%', overflow: 'hidden', 'white-space': 'pre', 'margin': '4px 0px'}}).inject(td4);
			var spanUsr = new Element('span',{html: xmlHist.getAttribute("user")}).inject(div4);
			
			//td5 FECHA OPERACION
			var td5 = new Element("td", {styles: {width: '20%'}}).inject(tr);
			var div5 = new Element('div', {styles: {width: '100%', overflow: 'hidden', 'white-space': 'pre', 'margin': '4px 0px'}}).inject(td5);
			var spanOpDte = new Element('span',{html: xmlHist.getAttribute("operDate")}).inject(div5);			
		}		
	}
	SYS_PANELS.closeAll();
	if (hasRecords){
		addScrollTable(tableDataHist);
	} else {
		showMessage(GNR_MORE_RECORDS);
	}
	
}

