var spDatesModal;

function initDatesModalPage(){
	var dateModalContainer = $('dateModalContainer');
	if (dateModalContainer.initDone) return;
	dateModalContainer.initDone = true;

	$('mdlBodyDates').formChecker = new FormCheck(
		'mdlBodyDates',
		{
			submit:false,
			display : {
				keepFocusOnError : 1,
				tipsPosition: 'left',
				tipsOffsetX: -10
			}
		}
	);
	
	dateModalContainer.blockerModal = new Mask();
	
	spDatesModal = new Spinner($('mdlBodyDates'),{message:WAIT_A_SECOND});
	
	//COnfirmar
	$('btnConDatesModal').addEvent("click", function(e){
		e.stop();		
		if (!$('mdlBodyDates').formChecker.isFormValid()){ return; }
		var params = "";
		$('mdlBodyDates').getElements("input").each(function(input){
			params += "&" + input.getAttribute("id") + "=" + encodeURIComponent(input.value);
		});
		
		var request = new Request({
			method: 'post',
			url: CONTEXT + URL_REQUEST_AJAX + '?action=confirmChangeDateModal&isAjax=true' + TAB_ID_REQUEST,
			onRequest: function() { SYS_PANELS.showLoading(); },
			onComplete: function(resText, resXml) { modalProcessXml(resXml); }
		}).send(params);
	});
	//Cerrar
	$('closeDatesModal').addEvent("click", function(e) {
		if (e) { e.stop(); }
		closeDatesModal();
	});
}

function showDatesModal(resXml,closeFunction){  
	var dateModalContainer = $('dateModalContainer');
	dateModalContainer.removeClass('hiddenModal');
	dateModalContainer.position();
	dateModalContainer.blockerModal.show();
	dateModalContainer.setStyle('zIndex', SYS_PANELS.getNewZIndex());
	dateModalContainer.closeFunction = closeFunction;	
		
	initModalData(resXml);
	
	dateModalContainer.position();
}

function initModalData(resXml){
	spDatesModal.show(true);
	
	var dateModalContainer = $('dateModalContainer');
	dateModalContainer.getElements("div.fieldGroup").each(function(e) { e.destroy(); });
	
	if (resXml){
		var result = resXml.getElementsByTagName("result")
		if (result != null && result.length > 0 && result.item(0) != null) {
			var task = result.item(0).getElementsByTagName("task");
						
			for (var i = 0; i < task.length; i++){
				var tskTitle = task[i].getAttribute("title");
				var fieldGroup = new Element("div.fieldGroup",{}).inject($('mdlBodyDates'));
				new Element("div.subtitle",{html: tskTitle}).inject(fieldGroup);
				
				var instances = task[i].getElementsByTagName("instance");
				var first = true;
				for (var j = 0; j < instances.length; j++){
					var proEleInst = instances[j];
					
					if (!first){ new Element("div.hrDiv",{}).inject(fieldGroup); }
					
					var field = new Element("div.field.fieldHalfMdl",{}).inject(fieldGroup);
					new Element("label",{html:lblPro+':&nbsp;'}).inject(field);
					new Element("span",{html: proEleInst.getAttribute("proTitle")}).inject(field);
					
					field = new Element("div.field.fieldHalfMdl",{}).inject(fieldGroup);
					new Element("label",{html:lblMonInstProNroReg+':&nbsp;'}).inject(field);
					new Element("span",{html: proEleInst.getAttribute("regNumber")}).inject(field);
					
					field = new Element("div.field.fieldHalfMdl",{}).inject(fieldGroup);
					new Element("label",{html:lblMonInstProWarnDat+':&nbsp;'}).inject(field);
					var dte = new Element("input.datePicker",{'id':'wd_'+proEleInst.getAttribute("proEleInstId"),'type':'text','value':proEleInst.getAttribute("warnDte"),'size':'10','format':'d/m/Y'}).inject(field);
					dte.setStyle("width","25%");
					dte.addEvent("change",function(){
						if (this.value == ''){
							this.getNext().value = '';
							this.hr.disabled = true;
							this.hr.value = '';
						} else {
							this.hr.disabled = false;
						}
					});
					var hr = new Element("input.hour",{'id':'wh_'+proEleInst.getAttribute("proEleInstId"),'type':'text','value':proEleInst.getAttribute("warnHr"),'maxlength':'5','size':'10'}).inject(field);
					hr.addClass("validate['%hourMinute']");
					hr.setStyle("width","13%");
					hr.setStyle("margin-left","5px");
					$('mdlBodyDates').formChecker.register(hr);
					dte.hr = hr;
					hr.disabled = (dte.value == '');
					
					field = new Element("div.field.fieldHalfMdl",{}).inject(fieldGroup);
					new Element("label",{html:lblMonInstProOverDat+':&nbsp;'}).inject(field);
					var dte = new Element("input.datePicker",{'id':'od_'+proEleInst.getAttribute("proEleInstId"),'type':'text','value':proEleInst.getAttribute("overDte"),'size':'10','format':'d/m/Y'}).inject(field);
					dte.setStyle("width","25%");
					dte.addEvent("change",function(){
						if (this.value == ''){
							this.getNext().value = '';
							this.hr.disabled = true;
						} else {
							this.hr.disabled = false;
						}
					});
					var hr = new Element("input.hour",{'id':'oh_'+proEleInst.getAttribute("proEleInstId"),'type':'text','value':proEleInst.getAttribute("overHr"),'maxlength':'5','size':'10'}).inject(field);
					hr.addClass("validate['%hourMinute']");
					hr.setStyle("width","13%");
					hr.setStyle("margin-left","5px");
					$('mdlBodyDates').formChecker.register(hr);
					dte.hr = hr;
					hr.disabled = (dte.value == '');
					
					first = false;
				}
			}
			
			$$("input.datePicker").each(setAdmDatePicker);
			$$("input.hour").each(setHourField);
		}
	}
	
	spDatesModal.hide(true);	
}

function hourMinute(el){
	if (el.value == null || el.value == "") return true;
	
	var valueSplit = el.value.split(HOUR_SEPARATOR);
	if (valueSplit != null && valueSplit.length == 2){
		var hour = valueSplit[0]; 
		var min = valueSplit[1];
		if (!hour.test(/([0-1][0-9]|[2][0-3])/) || !min.test(/[0-5][0-9]/)){
			el.errors.push(VALID_HR);
	        return false;
		}
	} else {
		el.errors.push(VALID_HR);
        return false;
	}
	
	return true;
}

function closeDatesModal(){
	var dateModalContainer = $('dateModalContainer');
	dateModalContainer.addClass('hiddenModal');
    dateModalContainer.blockerModal.hide();
    $$('input.hour').each(function (e){
    	$('mdlBodyDates').formChecker.dispose(e);
    });
    if (dateModalContainer.closeFunction) dateModalContainer.closeFunction();
}

function updateDatesOk(){
	showMessage(msgOpCompList);
	closeOK.delay(1000);	
}

function closeOK(){
	SYS_PANELS.closeAll();
	$('closeDatesModal').fireEvent("click");
}
 