var idFreeDay = 0;

function initPage(){
	//crear spinner de espere un momento
	sp = new Spinner(document.body,{message:WAIT_A_SECOND});
	
	//Agregar Free Day
	$('addFreeDay').addEvent("change", function() { processAddFreeDay(); });
	$('addFreeDay').addEvent("keydown", function(evt) { processAddFreeDay(evt); });	
	$('addFreeDay').set('title', TT_ADD_FREE_DAY);
	
	//Por defecto se deshabilitan los checkboxes de todo el d�a
	['allDayChk1','allDayChk2','allDayChk3','allDayChk4','allDayChk5','allDayChk6','allDayChk7'].each(
			function(ele){ 
				if($(ele)) $(ele).disabled = true; 
			});
	
	//Cargar Laborables
	loadLaboralDays();
	
	//Cargar Feriados
	loadFreeDays();
	
	//Seleccionar los demas combos iguales
	['cmbSta1','cmbSta2','cmbSta3','cmbSta4','cmbSta5','cmbSta6','cmbSta7'].each(setStaEvtChangeOther);
	['cmbEnd1','cmbEnd2','cmbEnd3','cmbEnd4','cmbEnd5','cmbEnd6','cmbEnd7'].each(setEndEvtChangeOther);
	
	$('btnConf').addEvent("click", function() {
		$('freeDays').value = getFreeDays();
	});
	
	initAdminFieldOnChangeHighlight(true);
	initAdminActionsEdition(atLeastOneDay);	
	
	getBodyController().canRemoveTab = function() { return ! AT_LEAST_ON_FIELD_INPUT_CHANGED; };
}

function loadLaboralDays(){
	var request = new Request({
		method: 'post',
		url: CONTEXT + URL_REQUEST_AJAX + '?action=loadXMLLaboralDays&isAjax=true' + TAB_ID_REQUEST,
		onRequest: function() { SYS_PANELS.showLoading(); },
		onComplete: function(resText, resXml) { modalProcessXml(resXml); SYS_PANELS.closeAll(); }
	}).send();	
}

function loadFreeDays(){
	var request = new Request({
		method: 'post',
		url: CONTEXT + URL_REQUEST_AJAX + '?action=loadXMLFreeDays&isAjax=true' + TAB_ID_REQUEST,
		onRequest: function() { SYS_PANELS.showLoading(); },
		onComplete: function(resText, resXml) { 
			modalProcessXml(resXml); SYS_PANELS.closeAll();
			
			initAdminModalHandlerOnChangeHighlight($('freeDaysContainter'));	
		}
	}).send();
}

function processXMLLaboralDays(){
	var ajaxCallXml = getLastFunctionAjaxCall().getElementsByTagName("messages")[0].getElementsByTagName("result")[0];
	if (ajaxCallXml != null && ajaxCallXml.getElementsByTagName("laboralDays")[0].getElementsByTagName("laboralDay")) {
		var laboralDays = ajaxCallXml.getElementsByTagName("laboralDays")[0].getElementsByTagName("laboralDay");
		for (var i = 0; i < laboralDays.length; i++){
			var xmlLabDay = laboralDays[i]; 
			var day = xmlLabDay.getAttribute("day");
			var allDay = xmlLabDay.getAttribute("allDay")=="true";
			var ini = allDay? 0 : xmlLabDay.getAttribute("hrStart");
			var end = allDay? 0 : xmlLabDay.getAttribute("hrEnd");			
			var check = $("chk"+day);
			check.checked = true;
			var allDayChk = $("allDayChk"+day);
			allDayChk.checked  = allDay;
			allDayChk.disabled = false;
			enableDisableLabDay(allDayChk,day,ini,end);
		}
	}
	
	initAdminFieldOnChangeHighlight(false, true, true);
}

function enableDisableAllDay(checkDay,day,ini,end){
	var allDayChk = $("allDayChk"+day);
	allDayChk.disabled = !checkDay.checked;
	if (!checkDay.checked) allDayChk.checked = checkDay.checked;
	enableDisableLabDay(allDayChk,day,ini,end,!checkDay.checked);
}

function enableDisableLabDay(checkAllDay,day,ini,end,value){
	var cmbSta = $("cmbSta"+day);
	cmbSta.disabled = value || checkAllDay.checked;
	cmbSta.selectedIndex = ini;
	var cmbEnd = $("cmbEnd"+day);
	cmbEnd.disabled = value || checkAllDay.checked;
	cmbEnd.selectedIndex = end;
}

function processXMLFreeDays(){
	var ajaxCallXml = getLastFunctionAjaxCall().getElementsByTagName("messages")[0].getElementsByTagName("result")[0];
	if (ajaxCallXml != null && ajaxCallXml.getElementsByTagName("freeDays")[0].getElementsByTagName("freeDay")) {
		var freeDays = ajaxCallXml.getElementsByTagName("freeDays")[0].getElementsByTagName("freeDay");
		for (var i = 0; i < freeDays.length; i++){
			var xmlFreeDay = freeDays[i];
			addFreeDay(xmlFreeDay.getAttribute("day"));
		}
	}
}

function addFreeDay(day){
	if (!existDay(day) && isCorrect(day)){ 
		var add = $('divAddFreeDay');
		var newDay = new Element("div", {'id': idFreeDay, 'class': 'option'});
		//newDay.addEvent('click', function(evt) { this.destroy(); });
		new Element('div.optionRemove').addEvent('click', function() { this.getParent().destroy();}).inject(newDay);
		var span = new Element("span",{'id': "span"+idFreeDay, html: day});
		span.setAttribute("value",day);
		span.inject(newDay);
		var yearDiv = new Element("div", {'class': 'optionIcon optionModify'});
		yearDiv.set('title', TT_SHOW_YEAR);
		yearDiv.addEvent('click', function(evt) { 
			addRemoveYear(this.parentNode.getAttribute("id"),this); evt.stopPropagation();
			
			if (!this.getParent().hasClass('highlighted')){
				var spanEle = this.getParent().getElement('span');
				var initialValue = spanEle.getAttribute('value');
				var currentValue = spanEle.textContent;
				if (initialValue != currentValue)
					spanEle.addClass('highlighted');
				else
					spanEle.removeClass('highlighted');
			}
		});
		yearDiv.set('initialValue', day);
		yearDiv.inject(newDay);
		newDay.inject(add,"before");
		idFreeDay++;
	}
}

function isCorrect(day){
	if (day == null || day == "") { return false; }
	return true;
}

function existDay(day){
	var container = $('freeDaysContainter');
	var exist = false;
	container.getElements("span").each(function(item){
		if (item.getAttribute("value") == day){
			exist = true;
		}				
	});
	return exist;
}

function addRemoveYear(id){
	var span = $("span"+id);
	var valAct = span.innerHTML;
	var array = valAct.split("/");
	if (array.length == 3){
		var newVal = array[0] + "/" + array[1];
	} else {
		if (span.getAttribute("value").split("/").length == 3) {
			var newVal = span.getAttribute("value");
		} else {
			var newVal = valAct + "/" + (1900 + new Date().getYear());
		}
	}
	span.innerHTML = newVal;	
}

function getFreeDays(){
	var values = "";
	var container = $('freeDaysContainter');
	container.getElements("span").each(function(item){
		if (values != "") { values += ";"; }
		values += item.innerHTML;						
	});
	return values;
}

function validLabel(lbl){
	var i = lbl.getAttribute("day");
	var chkDay = $("chk"+i);
	var chkAllDay = $("allDayChk"+i);
	if (chkDay.checked && !chkAllDay.checked){
		var cmbSta = $("cmbSta"+i);
		var cmbEnd = $("cmbEnd"+i);
		var sta = parseInt(cmbSta.value);
		var end = parseInt(cmbEnd.value);
		if (sta >= end){
			lbl.errors.push(INCORRECT_DAY);
			return false;
		}
		return true;
	} else {
		return true;
	}	
}

function atLeastOneDay(){
	var selected = 0;
	for (var i = 1; selected == 0 && i <= 7; i++){
		if ($("chk"+i).checked) { selected++; }
	}
	if (selected == 0){
		showMessage(SELECT_DAY, GNR_TIT_WARNING, 'modalWarning');
        return false;
	}
	return true;
}

function processAddFreeDay(evt){
	var ok = true;
	if (evt){ ok = (evt.key == "enter"); }
	if (ok){
		addFreeDay($('addFreeDay').value);
		$('addFreeDay').value = '';
		$('addFreeDay').datepickerField.value = '';
	}
}

function setStaEvtChangeOther(ele){
	var cmbSta = $(ele); 
	cmbSta.addEvent("change", function() { changeOthers(true,cmbSta.value); });
}

function setEndEvtChangeOther(ele){
	var cmbEnd = $(ele); 
	cmbEnd.addEvent("change", function() { changeOthers(false,cmbEnd.value); });
}

function changeOthers(ini,value){
	var cmbName = "cmbSta";
	if (!ini) { cmbName = "cmbEnd"; }
	for(var i = 1; i <= 7; i++){
		var chk = $("chk"+i);
		var allDayChk = $("allDayChk"+i);
		if (chk && chk.checked == true && allDayChk && allDayChk.checked == false){
			var cmb = $(cmbName+i);
			if (cmb && cmb.value == "0") { cmb.value = value; }
		}
	}	
}


	