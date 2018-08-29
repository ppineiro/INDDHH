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
	
	$('btnGenRep').addEvent("click",function(e){
		e.stop();
		var form = $('frmData');
		if(!form.formChecker.isFormValid()){
			return;
		}
		setStrParamsToSend();
		var params = getFormParametersToSend(form);
		
		var request = new Request({
			method: 'post',
			url: CONTEXT + URL_REQUEST_AJAX + '?action=generateReport&isAjax=true' + TAB_ID_REQUEST,
			onRequest: function() { SYS_PANELS.showLoading(); },
			onComplete: function(resText, resXml) { modalProcessXml(resXml); }
		}).send(params);
	});
	$('btnCloseTab').addEvent("click",function(e){ getTabContainerController().removeActiveTab(); });
	//['btnGenRep','btnCloseTab'].each(setTooltip);
	
	if (IS_REP_BUS_CLASS){
		$('divFormat').setStyle("display","none");
	} 	
	
	loadReport();
		
	initAdminFav();	
	
	getBodyController().canRemoveTab = function() { return ! AT_LEAST_ON_FIELD_INPUT_CHANGED; };
}

function loadReport(){
	sp.show(true);
	var request = new Request({
		method: 'post',
		url: CONTEXT + URL_REQUEST_AJAX + '?action=loadParameters&isAjax=true' + TAB_ID_REQUEST,
		onRequest: function() { },
		onComplete: function(resText, resXml) { processXmlParameters(resXml); sp.hide(true); }
	}).send();
}

function processXmlParameters(resXml){
	var tableDataParams = $('tableDataParams');
	var hasParameters = false;
	var parameters = resXml.getElementsByTagName("parameters")
	if (parameters != null && parameters.length > 0 && parameters.item(0) != null) {
		parameters = parameters.item(0).getElementsByTagName("parameter");
		
		hasParameters = parameters.length > 0;
		
		for(var i = 0; i < parameters.length; i++){
			var xmlParameter = parameters[i];
			
			var tr = new Element("tr",{}).inject(tableDataParams);
			if (i % 2 == 0) { tr.addClass("trOdd"); }
			if (i == parameters.length-1) { tr.addClass("lastTr"); }			
			
			var isRequired = toBoolean(xmlParameter.getAttribute("required"));
			var isDefValue = toBoolean(xmlParameter.getAttribute("defValue"));
			var paramType = xmlParameter.getAttribute("type");
			var paramValue = xmlParameter.getAttribute("value");
			var paramDesc = xmlParameter.getAttribute("description");
			
			//td1 NOMBRE
			var td1 = new Element("td", {styles: {width: '25%'}}).inject(tr);
			var div1 = new Element('div', {styles: {width: '100%', overflow: 'hidden', 'white-space': 'pre', 'margin': '4px 0px'}}).inject(td1);
			var spanName = new Element('span',{html: (isRequired?'* ':'')+xmlParameter.getAttribute("name")}).inject(div1);
			if (div1.scrollWidth > div1.offsetWidth) {
				td1.title = xmlParameter.getAttribute("name");
				td1.addClass("titiled");
			}
			
			//td2 DESCRIPCION
			var td2 = new Element("td", {styles: {width: '35%'}}).inject(tr);
			var div2 = new Element('div', {styles: {width: '100%', overflow: 'hidden', 'white-space': 'pre', 'margin': '4px 0px'}}).inject(td2);
			var spanType = new Element('span',{html: paramDesc }).inject(div2);
			
			//td3 TIPO
			var td3 = new Element("td", {styles: {width: '10%'}}).inject(tr);
			var div3 = new Element('div', {styles: {width: '100%', overflow: 'hidden', 'white-space': 'pre', 'margin': '4px 0px'}}).inject(td3);
			var spanType = new Element('span',{html: getLblType(paramType)}).inject(div3);
			
			//td4 VALOR
			var td4 = new Element("td", {styles: {width: '30%'}}).inject(tr);
			var div4 = new Element('div', {styles: {width: '100%', overflow: 'hidden', 'white-space': 'pre', 'margin': '4px 0px'}}).inject(td4);
			if (paramType == "D"){ //Date
				var inputValue = new Element('input',{'type':'text','value':paramValue,'class':'parameterDate datePickerCustom filterInputDate','format':'d/m/Y'}).inject(div4);
				setAdmDatePicker(inputValue);
				if (isRequired){
					inputValue.getNext().addClass("validate['required']")
					$('frmData').formChecker.register(inputValue.getNext());
				}				
			} else if (paramType == "I") { //Numeric
				var inputValue = new Element('input',{'type':'text','value':paramValue, 'class': 'parameterNumeric'}).inject(div4);
				if (isRequired){
					inputValue.addClass("validate['required','digit']")
					$('frmData').formChecker.register(inputValue);
				} else if (!isDefValue){
					inputValue.addClass("validate['digit']")
					$('frmData').formChecker.register(inputValue);
				}				
			} else if (paramType == "N"){
				var inputValue = new Element('input',{'type':'text','value':paramValue, 'class': 'parameterNumeric'}).inject(div4);
				if (isRequired){
					inputValue.addClass("validate['required','number']")
					$('frmData').formChecker.register(inputValue);
				} else if (!isDefValue){
					inputValue.addClass("validate['number']")
					$('frmData').formChecker.register(inputValue);
				}				
			} else { //String
				var inputValue = new Element('input',{'type':'text','value':paramValue, 'class': 'parameterString'}).inject(div4);
				if (isRequired){
					inputValue.addClass("validate['required']")
					$('frmData').formChecker.register(inputValue);
				}
			}
			
			if (isDefValue){ 
				inputValue.disabled = true;	
				if (paramType == "D"){
					inputValue.getNext().disabled = true;
				}
			}
							
			tr.getContent = function (){ //format: [name,value]
				var name = this.getElements("td")[0].getElements("div")[0].getElements("span")[0].innerHTML;
				var value = this.getElements("td")[3].getElements("div")[0].getElements("input")[0].value;
				var ret = new Array();
				ret.push(name);
				ret.push(value);
				return ret;
			}
		}		
	}
	
	if (hasParameters){
		$('divParameters').style.display = '';
		addScrollTable(tableDataParams);
	} else {
		$('divNoParameters').style.display = '';
	}	
}

function setStrParamsToSend(){
	var strParams = ""; //name1·value1;name2·value2;....
	$('tableDataParams').getElements("tr").each(function (tr){
		var trContent = tr.getContent();
		if (strParams != "") strParams += ";";
		strParams += trContent[0] + PRIMARY_SEPARATOR + trContent[1];
	});
	$('strParams').value = strParams;
}

function startDownload(){
	SYS_PANELS.closeAll();
	createDownloadIFrame(TIT_DOWN_REP,DOWNLOADING,URL_REQUEST_AJAX,"downloadReport","","","",null);
}

function getLblType(type){
	if (type == "D"){ //Fecha
		return LBL_DATE;
	} else if (type == "N"){ //Numerico
		return LBL_NUMERIC;
	} else if (type == "I"){ //Integer 
		return LBL_INTEGER;		
	} else { //String
		return LBL_STRING;		
	}
}