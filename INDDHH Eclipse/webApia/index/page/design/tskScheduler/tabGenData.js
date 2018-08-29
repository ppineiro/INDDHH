/**
 * Carga y control de la agenda
 */

var sp_tsksched;
var cal_spinner_width; 
var cal_spinner_height;

window.addEvent('domready', function() {

	//crear spinner de espere un momento
	sp_tsksched = new Spinner(document.body,{message:WAIT_A_SECOND});
	
	if(Browser.opera)
		sp_tsksched.content.getParent().addClass('documentSpinner');
	
	cal_spinner_width = $('schedTableContainer').getStyle('width');
	cal_spinner_height = $('schedTableContainer').getStyle('height');
	//navDate.getNext().setStyle('background-color', '');
	
	$('selCal').addEvent('change', function() {
		loadScheduler(myScheduler.getMondayDateStr());
	});
	
	Numeric.setNumeric($('txtOthFrec'), 'change');
	
	if ($('txtOthFrec').get('value')) {
		$('selFrec').set('value', 0);
	}
	
	$('selFrec').addEvent('change', function() {
		if (Number.from($('selFrec').get('value'))) {
			showConfirm(MSG_FREC_CHANGE_WARNING, GNR_TIT_WARNING, changeFrec, "modalWarning")
		}else {
			$('txtOthFrec').erase('disabled');
			$('txtOthFrec').set('value',  $('txtHidFrec').get('value'));
		}
	});
	
	$('txtOthFrec').addEvent('change',function() {
		if ($('txtOthFrec').value == "") {
			$('txtOthFrec').value = $('txtHidFrec').value;
		}else{
			
			showConfirm(MSG_FREC_CHANGE_WARNING, GNR_TIT_WARNING, changeFrec2, "modalWarning")
//			if (confirm(MSG_FREC_CHANGE_WARNING)){
//				$('txtHidFrec').value = $('txtOthFrec').value;
//				loadScheduler(myScheduler.getMondayDateStr());	
//			}else {
//				$('txtOthFrec').value = $('txtHidFrec').value;
//			}
		}
	});
	
	$('txtOvrAsign').addEvent('change', function(e) {
		var value = e.target.get('value');
		var num_value = Number.from(value);
		var monday = myScheduler.getCompleteMondayDateStr();
		if(value.length == (num_value + '').length) {
			new Request({
				method: 'post',
				url: CONTEXT + URL_REQUEST_AJAX + '?action=setWeekOverassign&isAjax=true&monday=' + monday + '&overassign=' + value + TAB_ID_REQUEST,
				/*onComplete: function(resText, resXml) {
					
				},*/
				onFailure: function() {
					alert('Connection error'); //TODO: Cambiar mensaje
				}
			}).send();
		} 
	});
	
	//$('selTemplate').addEvent('change',selTemplateChange);
	
	/*
	//Primera carga del calendario
	var xml_str = '<tskScheduler tskSchId="1001" mondayWeek="31/12/2012" frec="30" calId="1002"><tskSchDay day="13/8/2012"><tskSchHour hour="1100" value="3"/><tskSchHour hour="1130" value="2"/><tskSchHour hour="1200" value="3"/></tskSchDay><tskSchDay type="disabled"><tskSchHour hour="1100" value="3"/><tskSchHour hour="1130" value="2"/><tskSchHour hour="1200" value="3"/></tskSchDay><tskSchDay day="15/8/2012"/><tskSchDay day="16/8/2012"/><tskSchDay day="17/8/2012"/><tskSchDay day="18/8/2012"/><tskSchDay day="19/8/2012"/></tskScheduler>';
	var xml;
	//Parsear XML
	if (window.DOMParser) {
		xml = (new DOMParser()).parseFromString(xml_str,"text/xml");
	} else {
		// Internet Explorer
		xml = new ActiveXObject("Microsoft.XMLDOM");
		xml.async = false;
		xml.loadXML(xml_str);
	}
	
	//processXmlScheduler(xml.childNodes[0]);	
	*/
	
	loadScheduler(ACTUAL_MONDAY, true);
	loadExclusionDays();
});

function changeFrec(msg) {
	if (msg) {
		$('txtHidFrec').set('value', $('selFrec').get('value'));
		$('txtOthFrec').set('value', '');
		$('txtOthFrec').set('disabled', true);
		loadScheduler(myScheduler.getMondayDateStr());
	}else{
		if ($('txtOthFrec').get('value') != "") { //Si estaba seleccionado otro valor
			$('selFrec').set('value', 0);
		}
		$('selFrec').set('value', $('txtHidFrec').get('value'));
	}
}

function changeFrec2(msg) {
	if (msg) {
		$('txtHidFrec').value = $('txtOthFrec').value;
		loadScheduler(myScheduler.getMondayDateStr());	
	}else {
		$('txtOthFrec').value = $('txtHidFrec').value;
	}
}

function loadExclusionDays() {
	var request = new Request({
		method: 'post',
		url: CONTEXT + URL_REQUEST_AJAX + '?action=getExclusionDays' + TAB_ID_REQUEST,
		onRequest: function() { 
			sp_tsksched.show(true); 
		},
		onComplete: function(resText, resXml) { 
			processXMLExcDays(resXml);
			sp_tsksched.hide(true);
		}
	});
	
	request.send();
}


function loadScheduler(weekDay, dontShowSpinner, keepOldFrecuency) {
	var calId = $('selCal').value;
	var frec = $('selFrec').value;
	if (frec==0) frec = $('txtOthFrec').value;
	
	var calSpinner = null;
	if(!dontShowSpinner)
		calSpinner = new Spinner('schedTableContainer', {
			destroyOnHide: true,
			style: {width: cal_spinner_width, height: cal_spinner_height}
		});
	
	var forceFrecChange = (keepOldFrecuency == null) ? true : !keepOldFrecuency;
	
	//weekDay es cualquier dia de la semana que se desea cargar con formato: "dd/mm/yyyy"
	var request = new Request({
		method: 'post',
		url: CONTEXT + URL_REQUEST_AJAX + '?action=getSchedulerWeek&isAjax=true&weekDay=' + weekDay + '&calId=' + calId + '&frec=' + frec + '&forceFrecChange=' + forceFrecChange + TAB_ID_REQUEST,
		onRequest: function() {			
			if(calSpinner)
				calSpinner.show();
		},
		onSuccess: function(resText, resXml) {
			
			
			if(resXml.childNodes.length) {
				
				var xml;
				
//				if(Browser.ie)
//					xml = resXml.childNodes[1];
//				else
//					xml = resXml.childNodes[0];
				
				xml = resXml.childNodes[resXml.childNodes.length - 1];
				
				if(xml.tagName == 'data') {
					processXmlExceptions(xml);
					processXmlMessages(xml);
					processXmlScheduler(xml);
				} else {
					processXmlScheduler(xml);
				}
			} else {
				//TODO: retry!!!
			}
			
			if(calSpinner)
				calSpinner.hide();
		},
		onFailure: function() {
			//TODO: retry!!!!
		}
	}).send();
}

function processXMLExcDays(ajaxCallXml){
	if (ajaxCallXml != null) {
		var days = ajaxCallXml.getElementsByTagName("days");
		if (days != null && days.length > 0 && days.item(0) != null) {
			days = days.item(0).getElementsByTagName("day");
			for(var i = 0; i < days.length; i++) {
				var day = days.item(i);
				
				var text = day.getAttribute("text");
				var id = day.getAttribute("id");
				
				addExcDayToContainer(text,id);
			}
		}
	}
}

function addExcDayToContainer(text, id) {
	var element = addActionElement($('excDayContainter'),text,id,"day");
	if(element) {
		element.removeEvent('click', actionAlementAdminClickRemove);
		element.addEvent('click', function(evt) {
			this.destroy();
		});
	}
}

function selTemplateChange(event) {
	//TODO: cosa
}
