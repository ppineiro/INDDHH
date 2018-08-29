
function initTabGenData(){
	
	//eventos para el tab
    $('tabGenData').addEvent("focus", function(evt){
    	$('panelOptionsTabGenData').style.display='';
    	
    	var panelGenData = $('panelGenData');
    	if (panelGenData){
    		panelGenData.style.display='none';
    	}
    	
    });    
    $('tabGenData').addEvent("custom_blur", function(evt){
    //$('tabGenData').addEvent("blur", function(evt){
    	$('panelOptionsTabGenData').style.display='none';
    	
    	var panelGenData = $('panelGenData');
    	if (panelGenData){
    		panelGenData.style.display='';
    	}
    	
    });
    
    
	$('btnViewTemp').addEvent("click", function(evt){
		evt.stop();
		var cmbTemplate = $('cmbTemplate');
		
		var template = "";
				
		if (cmbTemplate.value == "<CUSTOM>"){
			if ($('txtTemplate').value == ""){
				showMessage(MSG_ADD_TEMPLATE, GNR_TIT_WARNING, 'modalWarning');
				return;
			} else {
				template = $('txtTemplate').value;
			}   		
		} else {
			template = cmbTemplate.value;												
		}
		
		var width = Number.from(frameElement.getParent("body").clientWidth);
		var height = Number.from(frameElement.getParent("body").clientHeight);
		width = (width*80)/100; //80%
		height = (height*80)/100; //80%
		
		var url = PRO_TEMPLATE_PAGE + "?template=" + template + TAB_ID_REQUEST;
		ModalController.openWinModal(url, width, height, undefined, undefined, false, true, false);
	});
	
	$('btnViewCal').addEvent("click", function(evt){
		evt.stop();
		var calId = $('cmbCalendar').value; 
		if (calId == "" || calId == null){
			showMessage(NO_SEL_CAL, GNR_TIT_WARNING, 'modalWarning');    		
		} else {
			showCalendarViewModal(calId);
		}
	});
	
	$('changeImg').addEvent("click", function(evt){
		evt.stop();
		onClickImage(this);
	});
	
	//Eliminar imagen
	$('btnResetImg').addEvent("click", function(evt){
		evt.stop();
		resetImage();
	});
    
	$('cmbAction').addEvent("change",function(evt){
		
		var proAction = $('cmbAction').value;
		var busEntId = $('cmbEntAsoc').value;
		
		if(proAction != "" && busEntId != ""){
		
			var request = new Request({
				method: 'post',
				url: CONTEXT + URL_REQUEST_AJAX + '?action=loadProcessQueries&isAjax=true&proAction=' + proAction + '&busEntId=' + busEntId + TAB_ID_REQUEST,
				onRequest: function() { },
				onComplete: function(resText, resXml) { processProQueriesXml(resXml); }
			}).send();
		}
	});
    
    //['btnViewTemp','btnViewCal'].each(setTooltip);
	
    onChangeCmbTemplate($('cmbTemplate'));
    onChangeFlagMsgCustCre($('flagMsgCustCre'));
    onChangeCmbEntAsoc($('cmbEntAsoc'));
    startRadioButtons();
    
    loadClassifications();        
}

function disabledAllTabGenData(){
	if (MODE_DISABLED){
    	var tabContent = $('contentTabGenData');
    	tabContent.getElements("input").each(function(input){
    		input.disabled = true;
    		input.readOnly = true;
    		input.addClass("readonly");
    	});
    	tabContent.getElements("select").each(function(select){
    		select.disabled = true;
    		select.readOnly = true;
    		select.addClass("readonly");
    	});    	
    	$('btnViewTemp').removeEvents('click');
    	$('btnViewCal').removeEvents('click');
    	$('changeImg').removeEvents('click');
    }
}

function loadClassifications(){
	var spClassification = new Spinner($('divClassifications'));
	var request = new Request({
		method: 'post',
		url: CONTEXT + URL_REQUEST_AJAX + '?action=loadClassifications&isAjax=true' + TAB_ID_REQUEST,
		onRequest: function() { spClassification.show(true); },
		onComplete: function(resText, resXml) { 
			processClassificationsXml(resXml); spClassification.hide(true); 
			
			initAdminFieldOnChangeHighlight(false, false, false, $('divClassifications'));
		}
	}).send();
}

function processClassificationsXml(resXml){
	var hasClassifications = false;
	
	var classifications = resXml.getElementsByTagName("classifications")
	if (classifications != null && classifications.length > 0 && classifications.item(0) != null) {
		classifications = classifications.item(0).getElementsByTagName("classification");
		var claContainer = $('claContainer');
		
		for (var i = 0; i < classifications.length; i++){
			hasClassifications = true;
			var xmlCla = classifications[i];
			
			if (!$("cla_"+xmlCla.getAttribute("id"))){
				var father = null;
				if (xmlCla.getAttribute("fatherId") != ""){
					father = $("father_"+xmlCla.getAttribute("fatherId"));
				} else {
					father = claContainer;
				}
				
				var elem = new Element('li',{'id': "cla_"+xmlCla.getAttribute("id")});
				elem.inject(father);
				
				var chk = new Element('input',{'type': 'checkbox', 'id': "chkCla_"+xmlCla.getAttribute("id")}).inject(elem);
				chk.setAttribute("claIdNum",xmlCla.getAttribute("id"));
				if (xmlCla.getAttribute("selected") == "true"){
					chk.checked = true;
					$('txtCla').value = xmlCla.getAttribute("id");
				} else {
					chk.checked = false;
				}
				
				chk.addEvent("click", function(evt) { unCheckOthers(this); });
				
				var span = new Element("span",{ text: xmlCla.getAttribute("name") }).inject(elem);
												
				if (xmlCla.getAttribute("fatherId") == "") {
					var ul = new Element("ul",{'id': "father_"+xmlCla.getAttribute("id")});
					ul.inject(elem);
				}				
			}			
		}		
	}
	
	if (!hasClassifications){
		$('divOptionClaTree').style.display = 'none';
		var divClassifications = $('divClassifications');
		var span = new Element("span",{'class': 'italic', html: NO_CLASSIFICATIONS}).inject(divClassifications);
	} else {
		$('divOptionClaTree').style.display = '';
	}
	
	disabledAllTabGenData();
}

function unCheckOthers(chk){
	var chkClaId = chk.getAttribute("id");
	var txtCla = $('txtCla');
	$('claContainer').getElements("input").each(function (item){ 
		if (item.getAttribute("id") != chkClaId){
			item.checked = false;
		}	
	});
	
	txtCla.value = chk.checked ? chk.getAttribute("claIdNum") : "";
}

function onChangeCmbEntAsoc(cmbEntAsoc){
	removeAllCmbQryAsoc();
	if (cmbEntAsoc.value != null && cmbEntAsoc.value != ""){
		var proAction = $('cmbAction').value;
		var busEntId = cmbEntAsoc.value;
		
		var request = new Request({
			method: 'post',
			url: CONTEXT + URL_REQUEST_AJAX + '?action=loadProcessQueries&isAjax=true&proAction=' + proAction + '&busEntId=' + busEntId + TAB_ID_REQUEST,
			onRequest: function() { },
			onComplete: function(resText, resXml) { processProQueriesXml(resXml); }
		}).send();
		
		if (cmbEntAsoc.options != null){
			$('dataGenEntAso').innerHTML = cmbEntAsoc.options[cmbEntAsoc.selectedIndex].innerHTML;
		}
	} else {
		$('dataGenEntAso').innerHTML = "";
	} 
	
	entBlur();
}

function removeAllCmbQryAsoc(){
	var cmbQryAsoc = $('cmbQryAsoc');
	cmbQryAsoc.innerHTML = ""
	cmbQryAsoc.value = '';
	//cmbQryAsoc.options = new Array();
	cmbQryAsoc.getElements('option').destroy();
}

function processProQueriesXml(resXml){
	var cmbQryAsoc = $('cmbQryAsoc');
	///cmbQryAsoc.options = new Array();
	cmbQryAsoc.getElements('option').destroy();
	//cmbQryAsoc.options[0] = new Option("","");
	new Element('option', {
		value: '',
		html: '',
		selected: "true"
	}).inject(cmbQryAsoc)
	//cmbQryAsoc.options[0] = new Option("","");
	var selectedIndex = 0;
	
	var proQueries = resXml.getElementsByTagName("processQueries")
	if (proQueries != null && proQueries.length > 0 && proQueries.item(0) != null) {
		//proQueries = proQueries.item(0).getElements("query");
		proQueries = proQueries.item(0).getElementsByTagName("query");
						
		for (var i = 0; i < proQueries.length; i++) {
			var selected = "false";
			if(proQueries[i].getAttribute("id") == cmbQryAsoc.get("initial_value")){
				selected = "true";
			}
			var ele = new Element('option', {
				value: proQueries[i].getAttribute("id"),
				selected: selected,
				html: proQueries[i].getAttribute("name")
			});
			ele.inject(cmbQryAsoc);
			if (toBoolean(selected)){
				selectedIndex = i+1;
			}
		}		
	}
	cmbQryAsoc.selectedIndex = selectedIndex;
}

function onChangeCmbTemplate(cmbTemplate){
	var divTemplate = $('divTemplate');
	var txtTemplate = $('txtTemplate');
	
	if (cmbTemplate.value == "<CUSTOM>"){
		if (!txtTemplate.hasClass("validate['required']")){
			txtTemplate.addClass("validate['required']");
		}
		$('frmData').formChecker.register(txtTemplate);
		divTemplate.addClass("required");
		
		txtTemplate.style.visibility = "";
	} else {
		txtTemplate.value = "";
		txtTemplate.style.visibility = "hidden";
		$('frmData').formChecker.dispose(txtTemplate);
		if (divTemplate.hasClass("required")){
			divTemplate.removeClass("required");
		}	
	}
}

function onChangeFlagMsgCustCre(flagMsgCustCre){
	var divFlagMsgCustCreTxt = $('divFlagMsgCustCreTxt');
	var flagMsgCustCreTxt = $('flagMsgCustCreTxt');
	
	if (flagMsgCustCre.checked == true){
		if (!flagMsgCustCreTxt.hasClass("validate['required']")){
			flagMsgCustCreTxt.addClass("validate['required']");
		}
		$('frmData').formChecker.register(flagMsgCustCreTxt);
		divFlagMsgCustCreTxt.addClass("required");
		flagMsgCustCreTxt.style.visibility = "";
	} else {
		flagMsgCustCreTxt.value = "";
		flagMsgCustCreTxt.style.visibility = "hidden";
		$('frmData').formChecker.dispose(flagMsgCustCreTxt);
		divFlagMsgCustCreTxt.removeClass("required");
	}
}

function onClickImage(image){
	showImagesModal(processModalImageConfirm,null);
}

function processModalImageConfirm(image){
	if (image != null){
		var txtPathImg = $('txtPathImg');
		var changeImg = $('changeImg'); 
		changeImg.style.backgroundImage = "url('"+image.path+"')";
		txtPathImg.value = image.id;
	}
}

function resetImage(){
	var txtPathImg = $('txtPathImg');
	var changeImg = $('changeImg'); 
	changeImg.style.backgroundImage = "url('"+CONTEXT + PATH_IMG + DEFAULT_IMG+"')";
	txtPathImg.value = DEFAULT_IMG;
}

function startRadioButtons(){
	var radIdePreNo = $('radIdePreNo');
	var radIdePreAll = $('radIdePreAll');
	var radIdePreFix = $('radIdePreFix');
	if (radIdePreNo.checked){
		changeIdePre(radIdePreNo);
	} else if (radIdePreAll.checked){
		changeIdePre(radIdePreAll);
	} else {
		changeIdePre(radIdePreFix);
		var txtIdePre = $('txtIdePre');
		txtIdePre.disabled = radIdePreFix.disabled;
	}
	
	var radIdePosNo = $('radIdePosNo');
	var radIdePosAll = $('radIdePosAll');
	var radIdePosFix = $('radIdePosFix');
	if (radIdePosNo.checked){
		changeIdePos(radIdePosNo);
	} else if (radIdePosAll.checked){
		changeIdePos(radIdePosAll);
	} else {
		changeIdePos(radIdePosFix);
		var txtIdePos = $('txtIdePos');
		txtIdePos.disabled = radIdePosFix.disabled;
	}	
}

function changeIdePre(radioIdePre){
	var txtIdePre = $('txtIdePre');
	var divMandatoryIdePre = $('divMandatoryIdePre');
	if (radioIdePre.value != IDENTIFIER_TXT_FIXED){
		txtIdePre.readOnly = true;
		txtIdePre.value = "";
		$('frmData').formChecker.dispose(txtIdePre);
		if (divMandatoryIdePre.hasClass("required")){
			divMandatoryIdePre.removeClass("required")
		}
		txtIdePre.addClass("readonly");
	} else {
		txtIdePre.readOnly = false;
		if (!txtIdePre.hasClass("validate['required']")){
			txtIdePre.addClass("validate['required']");
		}
		$('frmData').formChecker.register(txtIdePre);
		divMandatoryIdePre.addClass("required");
		txtIdePre.removeClass("readonly");
	}
}

function changeIdePos(radioIdePos){
	var txtIdePos = $('txtIdePos');
	var divMandatoryIdePos = $('divMandatoryIdePos');
	if (radioIdePos.value != IDENTIFIER_TXT_FIXED){
		txtIdePos.readOnly = true;	
		txtIdePos.value = "";
		$('frmData').formChecker.dispose(txtIdePos);
		if (divMandatoryIdePos.hasClass("required")){
			divMandatoryIdePos.removeClass("required");
		}
		txtIdePos.addClass("readonly");
	} else {
		txtIdePos.readOnly = false;
		if (!txtIdePos.hasClass("validate['required']")){
			txtIdePos.addClass("validate['required']");
		}
		$('frmData').formChecker.register(txtIdePos);
		divMandatoryIdePos.addClass("required");
		txtIdePos.removeClass("readonly");
	}
}

function entBlur() {
	var cmbEntAsoc = $("cmbEntAsoc");
	if (cmbEntAsoc.get('value') != "") {
		//$("txtBusEnt").set('value', $("selBusEnt").get('value'));
		cmbEntAsoc.set('disabled', 'true');
		
		if(IS_PRO_BPMN) {
			//Enviamos por AJAX la nueva entidad
			var busEntId = cmbEntAsoc.get('value');
			var request = new Request({
		 		url: CONTEXT + '/apia.design.BPMNProcessAction.run?action=setEntity&busEntId=' + busEntId + TAB_ID_REQUEST
			}).send();
			
		} else {
			oldEntChange();
		}
	}
}

function onChangeProName(proName){
	$('dataGenProName').innerHTML = proName.value;
}

function onChangeProTitle(proTitle){
	$('dataGenProTitle').innerHTML = proTitle.value;
}

function onChangeCmbAction(cmbAction){
	var value = cmbAction.value;
	if (value != null && value != ""){
		$('dataGenProAcc').innerHTML = cmbAction.options[cmbAction.selectedIndex].innerHTML;
	} else {
		$('dataGenProAcc').innerHTML = "";
	}	 
}

