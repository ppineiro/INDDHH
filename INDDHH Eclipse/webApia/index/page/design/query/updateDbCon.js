function initPage(){
	//crear spinner de espere un momento
	sp = new Spinner(document.body,{message:WAIT_A_SECOND});

	$$('div.fncDescriptionImage').each(function(e){
		var path = 'url(' + e.get('src') + ')'
		e.setStyle('background-image', path);
		e.setStyle('background-repeat', 'no-repeat');
		e.setStyle('width', '64px');
		e.setStyle('height', '64px');
	});
	
	initAdminFav();
	
	$('frmData').formChecker = new FormCheck(
			'frmData',
			{
				submit:false,
				display : {
					keepFocusOnError : 1,
					tipsPosition: 'left',
					tipsOffsetY: 10,
					tipsOffsetX: -10
				}
			}
	);
	
	var btnSig = $('btnSig');
	if (btnSig){
		btnSig.addEvent("click",function(e){
			var form = $('frmData');
			
			
			//Seteo las validaciones
			var cmbSource = $('cmbSource');
			if (cmbSource.value==SOURCE_BUS_CLASS || cmbSource.value==SOURCE_CONNECTION){
				clearValidations();
				if (cmbSource.value==SOURCE_BUS_CLASS){
					registerValidation($('cmbBusCla'));
					registerValidation($(PARAM_NAME_QUERY_TYPE));
				}else if (cmbSource.value==SOURCE_CONNECTION){
					registerValidation($('connectionsCombo'));
					registerValidation($('viewName'));
					registerValidation($(PARAM_NAME_QUERY_TYPE));					
				}
			}
			//Hago la validacion
			if(!form.formChecker.isFormValid()){
				return;
			}		
			var params;
			if (cmbSource.value==SOURCE_BUS_CLASS){
				params = '&selQryTyp='+$('selQryTyp').value+'&cmbBusCla='+$('cmbBusCla').value;
			}else{
				params = '&selQryTyp='+$('selQryTyp').value+'&chkOraOpt='+$('chkOraOpt').checked;
			}
			
			sp.show(true);
			 var aux = CONTEXT + URL_REQUEST_AJAX + '?action=updateData' +params+TAB_ID_REQUEST;
			 window.location = aux;
			
		});
	}
	
	var btnBackToList = $('btnBackToList');
	if (btnBackToList){
		btnBackToList.addEvent("click",function(e){
			e.stop();			
			SYS_PANELS.newPanel();
			var panel = SYS_PANELS.getActive();
			panel.addClass("modalWarning");
			panel.content.innerHTML = GNR_PER_DAT_ING;
			panel.footer.innerHTML = "<div class='button' onClick=\"SYS_PANELS.closeAll(); goBackList();\">" + BTN_CONFIRM + "</div>";
			SYS_PANELS.addClose(panel);
			SYS_PANELS.refresh();					
		});
	}
	
	var cmbSource = $('cmbSource');
	cmbSource.addEvent("change",function(e){
		setSource(this.value);			
	});
	
	var cmbBusCla = $('cmbBusCla');
	cmbBusCla.addEvent("change",function(e){
		if (this.value!=""){
			var request = new Request({
				method: 'post',
				url: CONTEXT + URL_REQUEST_AJAX + '?action=checkBusClass&isAjax=true' + TAB_ID_REQUEST,
				data:{cmbBusCla:$('cmbBusCla').value},
				onRequest: function() { SYS_PANELS.showLoading(); },
				onComplete: function(resText, resXml) { modalProcessXml(resXml); SYS_PANELS.closeAll(); }
			}).send();
		}
	});
	
	var connectionsCombo = $('connectionsCombo');
	connectionsCombo.addEvent("change",function(e){		
		getViews();		
	});
	
	if (SOURCE!=""){
		firstLoad = true;
		change(SOURCE);	
	}
}
var firstLoad = false;
function clearValidations(){
	var validations = $('frmData').formChecker.validations;
	var i = validations.length-1;
	while (i>=0){
		disposeValidation(validations[i]);
		i--;
	}
}

function checkValidations(obj){
	var validations = $('frmData').formChecker.validations;
	if (obj!=null){
		for (var i=0;i<validations.length;i++){
			if (obj.id == validations[i].id){
				return false;
			}
		}
		return true;
	}
	return false;
}

function goBackList(){
	sp.show(true);
	window.location = CONTEXT + URL_REQUEST_AJAX + '?action=list' + TAB_ID_REQUEST;
}

//-------------------------------
//---- Funciones generales
//-------------------------------

function registerValidation(obj){
	var ok = checkValidations(obj);
	if (ok){
		obj.addClass("validate['required']");
		$('frmData').formChecker.register(obj);
	}
}

function disposeValidation(obj){
	if (obj!=null){
		$('frmData').formChecker.dispose(obj);
	}
}

function getSelect(xml){
	var elements = xml.getElementsByTagName("element");
	if (elements.length==1){
		var elem = elements.item(0);
	}else{
		var elem = elements.item(1);
	}
	var opts = elem.firstChild;
	var selectedValue = elem.getAttribute("value");
	var disabled  = toBoolean(elem.getAttribute("disabled"));
	var selector = new Element('select');
	selector.setProperty('id',elem.getAttribute("id"));
	selector.setProperty('name',elem.getAttribute("id"));
	if (disabled){
		selector.setProperty('disabled',disabled);	
	}
	
	var options = opts.getElementsByTagName("option");
	if (options==null){
		return null;
	}
	for (var l = 0; l < options.length; l++) {
		var optionDOM = new Element('option');
		var option = options.item(l);
		
		var value = option.getAttribute("value");
		var text = (option.firstChild != null)?option.firstChild.nodeValue:""; 
		
		optionDOM.setProperty('value',value);
		optionDOM.appendText(text);
		
		if (selectedValue!="" && selectedValue == value || selectedValue=="" && l==0){
			optionDOM.setProperty('selected','selected');
		}
		optionDOM.inject(selector);
	
	}
	
	return selector;
}

function clearCombo(obj){
	obj.options.length = 0;
}

function change(val){
	if (val==SOURCE_BUS_CLASS){		
		$('divClass').style.display='';
		$('divClass').addClass('required');
		$('divConn').style.display='none';
		$('divViews').style.display='none';
		$('tabAdvanced').style.display='none';
		getQueryTypes();
		
		if ($('viewName')){
			$('viewName').destroy();
		}
	}else if (val==SOURCE_CONNECTION){			
		$('divConn').style.display='';
		$('divConn').addClass('required');
		$('divClass').style.display='none';
		$('divQryType').style.display='none';
		getViews($('connectionsCombo').value);
		if (firstLoad){
			getQueryTypes();
		}
		firstLoad=false;
	}	
}
//-------------------------------
//---- Funciones source bus class
//-------------------------------

function setSource(val){
	var request = new Request({
		method: 'post',
		url: CONTEXT + URL_REQUEST_AJAX + '?action=setSource&isAjax=true' + TAB_ID_REQUEST,
		onComplete: function() { change(val); },
		data:{cmbSource:val,dbConId:$('connectionsCombo').value}		
	}).send();
	
}

function getQueryTypes(){
	var request = new Request({
		method: 'post',
		data:{'viewName':$('viewName')!=null?$('viewName').value:"",'firstLoad':firstLoad},
		url: CONTEXT + URL_REQUEST_AJAX + '?action=getQueryTypes&isAjax=true' + TAB_ID_REQUEST,
		onRequest: function() { SYS_PANELS.showLoading(); },
		onComplete: function(resText, resXml) { modalProcessXml(resXml);}
	}).send();
}

function processQueryTypesXml(){
	var resXml = getLastFunctionAjaxCall(); 
	var div = $('divQryType');
	var aux = $(PARAM_NAME_QUERY_TYPE);
	if (aux){
		aux.destroy();	
	}	
	var select = getSelect(resXml);
	select.inject(div);
	div.style.display='';	
	SYS_PANELS.closeAll();
}

function getViews(){
	var request = new Request({
		method: 'post',
		data:{cmbSource:SOURCE_CONNECTION,dbConId:$('connectionsCombo').value,'firstLoad':firstLoad},		
		url: CONTEXT + URL_REQUEST_AJAX + '?action=getViews&isAjax=true' + TAB_ID_REQUEST,
		onRequest: function() { 
			SYS_PANELS.showLoading();
			if ($('viewName')){
				clearCombo($('viewName'));
			}
			if ($(PARAM_NAME_QUERY_TYPE)){
				clearCombo($(PARAM_NAME_QUERY_TYPE));
			}
		},
		onComplete: function(resText, resXml) { modalProcessXml(resXml);}
	}).send();
}

function processViewsXml(showAdvancedTab){
	var resXml = getLastFunctionAjaxCall(); 
	var div = $('divViews');
	var aux = $(PARAM_NAME_VIEWS);
	if (aux){		
		aux.destroy();	
	}	
	var select = getSelect(resXml);
	if (select!=null){
		select.inject(div);
		div.style.display='';
		getQueryTypes();		
	}
	select.addEvent("change",function(e){		
		getQueryTypes();		
	});
	
	if (showAdvancedTab){
		$('tabAdvanced').style.display='';
	}else{
		$('tabAdvanced').style.display='none';
	}	
	
	SYS_PANELS.closeAll();
}