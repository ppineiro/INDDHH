var isJsonType;

function initPage(){
	loadParams();
	
	copyValuesFromParent();
	
	loadHelp();
	
	$('btnTest').addEvent('click', function(){
		invokeService();
	})
	
	$('frmTestRestWS').formChecker = new FormCheck(
			'frmTestRestWS',
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
	
}

function copyValuesFromParent(){
	['txtUri','cmbRestTypeTag','cmbRestHttpMetTag','cmbType'].each(function(ele){
		var currentEle = document.getElement('[name='+ele+']');
		currentEle.value=window.parent.document.getElement('[name='+ele+']').value;
		
		if (ele=='cmbRestTypeTag'){
			isJsonType=currentEle.value=='J';
			var labelPath = $('labelPath');			
			labelPath.getElement('label').textContent= (isJsonType? LBL_JSON_PATH : LBL_XPATH) + ':';
			$('helpTableHeader').getElement('th').textContent = isJsonType? LBL_JSON_PATH : LBL_XPATH;
		}		
	})
}

function loadParams(){	
	var paramTable = window.parent.document.getElementById('tableDataParams');
	if (paramTable){
		var paramTableMdl = $('gridBodyParams');
		
		var rows = paramTable.getElements('tr');
		for (var i=0; i<rows.length; i++){
			var isInput = rows[i].getElement('[name=cmbParInOut]').value!='O';
			if (isInput){
				var paramName	= rows[i].getElement('[name=txtParName]').value;
				var paramType 	= rows[i].getElement('[name=cmbParType]').value;
			
				var tr = new Element('tr');
				var name = new Element('td', {'class':'bold', 'width':'35%'}).inject(tr);
				nameDiv=new Element('div',{'style':'overflow-x: hidden;'}).inject(name);
				nameDiv.textContent=paramName;
				
				new Element('input', {'type':'hidden','name':'txtParName','value':paramName}).inject(name);
				new Element('input', {'type':'hidden','name':'cmbParInOut','value':'I'}).inject(name);
				new Element('input', {'type':'hidden','name':'cmbParType','value':paramType}).inject(name);
				
				var parValue = new Element('input',{'name':'txtParValue'}).inject(new Element('td', {'class':'bold', 'width':'65%'}).inject(tr));
				if (paramType=='D'){
					parValue.addClass('datePicker');
					setAdmDatePicker(parValue);
				} else {
					if (paramType=='I'){
						parValue.setProperty('data-attLabel', paramName);
						Numeric.setNumeric(parValue);
					}
					parValue.setStyle('width', '96%');
				}
				
				if (i % 2 == 0) tr.addClass("trOdd"); else tr.removeClass("trOdd");
				
				tr.inject(paramTableMdl);
				
				if (nameDiv.scrollWidth > nameDiv.offsetWidth) {
					name.title = paramName;
					name.addClass("titiled");
				}
			}
		}
		
		addScrollTable(paramTableMdl);
	}
}

function showPath(element){
	var labelPathContainer = $('labelPath');
	var filterPath = $('filterPath');	
	if (element.selectedIndex==1){
		filterPath.removeAttribute('disabled');
		labelPathContainer.addClass('required');
	} else {
		filterPath.setAttribute('disabled','');
		filterPath.value='';
		labelPathContainer.removeClass('required');
	}
}

function invokeService(){
	if(!$('frmTestRestWS').formChecker.isFormValid()){
		return;
	}
	
	var params = getFormParametersToSend($('frmTestRestWS'));
		
	var request = new Request({
		method: 'post',
		url: CONTEXT + URL_REQUEST_AJAX + '?action=testRestService' + TAB_ID_REQUEST,
		onRequest: function() { SYS_PANELS.showLoading(); },
		onComplete: function(resText, resXml) { SYS_PANELS.closeActive(); modalProcessXml(resXml); }
	}).send(params);
	
}

function loadServiceRespose(p){
	try{
		var ajaxCallXml = getLastFunctionAjaxCall().getElementsByTagName("result")[0];
		
		$('restResponse').value= '';
		$('restResponse').value = ajaxCallXml.textContent;
		
	} catch (err){}
}

function loadHelp(){
	var helpTable = $('gridBodyHelp');
	
	var pathTags = [];
	if (isJsonType){
		pathTags = ['$', '@', '.', '$.tag1.tag2', '$..tag1', '$.tag1..tag2', '$..tag1[i]'];
	} else {
		pathTags = ['/', '.', '/', '/tag1/tag2', '//tag1', '/tag1//tag2', '//tag1[i]'];
	}

	pathTags.each(function(tag, idx){
		var tr = new Element('tr');
		var td = new Element('td', {'class':'bold', 'width':'35%'}).inject(tr);
		var path = new Element('span').inject(td);
		path.textContent=tag;
		
		var result = new Element('span').inject(new Element('td', {'width':'65%'}).inject(tr));
		result.innerHTML=window['MSG_REST_HELP_'+(idx+1)];
		
		if (idx % 2 == 0) tr.addClass("trOdd"); else tr.removeClass("trOdd");
		if (idx == pathTags.length-1) tr.addClass("lastTr"); else tr.removeClass("lastTr");
		
		tr.inject(helpTable);	
	})

	addScrollTable(helpTable);
}