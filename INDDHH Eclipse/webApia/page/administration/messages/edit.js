var readonlyClass;
var blockAll;
var addPools;
var container;
var format;

function initPage(){
	sp = new Spinner(document.body,{message:WAIT_A_SECOND});
	
	//cargar datepicker
	$$("input.datePickerCustom").each(function(datepicker) {
		datepicker.set('hasDatepicker', true);
		var img = new Element("img", {src: CONTEXT+"/css/base/img/calendar.png"});
		img.inject(datepicker,"after");

		format = (datepicker.getAttribute("format") == null) ? DATE_FORMAT : datepicker.getAttribute("format");
		
		var datepicker_opts = { 
				pickerClass: 'datepicker_vista', 
				allowEmpty: true, 
				format: format, 
				inputOutputFormat: format, 
				toggleElements: img,
				toggleElementsDontAvoid: true,
				onClose: function(o){ validateDates(o); }
			};
		
		if(window.LBL_DAYS) {
			datepicker_opts.days = window.LBL_DAYS;
		}
		if(window.LBL_MONTHS) {
			datepicker_opts.months = window.LBL_MONTHS;
		}
		
		new DatePicker(datepicker, datepicker_opts);
		
		datepicker.getNext().set('id', datepicker.get('id') + '_d');
	});
	
	readonlyClass = "readonly";
	blockAll = false;
	addPools = $('addPool');
	container = $('poolsContainter');
	
	//Desabilita campos
	disableFields();
	
	//Agregar grupos
	if (!blockAll){
		$('addPool').addEvent("click", function(e) {
			e.stop();
			var envId = $('environmentId');
			if (envId != null && envId.value != ""){
				ADDITIONAL_INFO_IN_TABLE_DATA = false;
				POOLMODAL_SHOWAUTOGENERATED = true;
				POOLMODAL_SHOWNOTAUTOGENERATED = true;
				POOLMODAL_FROMENVS = envId.value;
				POOLMODAL_SHOWGLOBAL = true;
				POOLMODAL_EXACTMATCH = ""; 
				POOLMODAL_SELECTONLYONE	= false;
				showPoolsModal(processPoolsModalReturn);
			} else {
				showMessage(LBL_MUST_SEL_ENV, GNR_TIT_WARNING, 'modalWarning');
			}		
		});
	}				

	//Cargar Pools
	loadPools();
	
	var environment = $('environment');
	if (environment) {
		environment.addEvent('change', function(evt){
			this.setStyle('display', 'none');
			
			new Element("span", {html: $(this.options[this.selectedIndex]).get("text")}).setStyle('margin-left', 5).inject(this, 'after');
		});
	}
 
	
	initPoolMdlPage();
	initAdminFieldOnChangeHighlight();
	initAdminActionsEdition(function() {
		$('poolsSelected').value = getValuesToSend();
		return true;
	});
	initAdminFav();
	
	getBodyController().canRemoveTab = function() { return ! AT_LEAST_ON_FIELD_INPUT_CHANGED; };
}

function validateDates(date){
	var from = $('envDteFrom');
	var to = $('envDteTo');
	if (!verifyDates(from,to)){
		var msgToShow = MSG_FEC_FIN_MAY_FEC_INI;
	} else if (!verifyDateNoEarlyToday(date, format)){
		if (from == date){
			var msgToShow = MSG_FEC_INI_MEN_TODAY;
		} else {
			var msgToShow = MSG_FEC_FIN_MEN_TODAY;
		}
	}
	if (msgToShow){
		showMessage(msgToShow, GNR_TIT_WARNING, 'modalWarning');
		date.value = "";
		date.getNext().value = "";
	}
}

function disableFields(){ 
	var dteFrom = $('envDteFrom');
	var dteTo 	= $('envDteTo');
	
	if (dteFrom.value != "" && dteTo.value != ""){
		if (!verifyDateNoEarlyToday(dteFrom, format) || equalsDateToday(dteFrom, format)){
			dteFrom.addClass(readonlyClass);
			dteFrom.disabled = true;
			dteFrom.getNext().disabled = true;
			dteFrom.getNext().addClass(readonlyClass);	
			
		}
		if (!verifyDateNoEarlyToday(dteTo, format) || equalsDateToday(dteTo, format)){
			dteTo.addClass(readonlyClass);
			dteTo.disabled = true;
			dteTo.getNext().disabled = true;
			dteTo.getNext().addClass(readonlyClass);
			
			addPools.hidden = true;
			
			var msgText = $('envMsgText');
			msgText.addClass(readonlyClass);
			msgText.disabled = true;
			
			blockAll = true;
		}
	}
}

function loadPools(){
	var request = new Request({
		method: 'post',
		url: CONTEXT + URL_REQUEST_AJAX + '?action=loadPools&isAjax=true' + TAB_ID_REQUEST,
		onRequest: function() { SYS_PANELS.showLoading(); },
		onComplete: function(resText, resXml) { 
			modalProcessXml(resXml); SYS_PANELS.closeAll();
			
			initAdminModalHandlerOnChangeHighlight($('poolsContainter'));
		}
	}).send();
}

function processXMLPools(){
	var ajaxCallXml = getLastFunctionAjaxCall().getElementsByTagName("messages")[0].getElementsByTagName("result")[0];
	if (ajaxCallXml != null && ajaxCallXml.getElementsByTagName("pools")[0].getElementsByTagName("pool")) {
		var pools = ajaxCallXml.getElementsByTagName("pools")[0].getElementsByTagName("pool");
		for (var i = 0; i < pools.length; i++){
			var xmlPool = pools[i];
			createPool(xmlPool.getAttribute("id"),xmlPool.getAttribute("name"));					
		}		
		//Crear 'Todos los grupos'
		if (pools.length == 0){
			createAllPools();
		}
	}
}

function createPool(poolId,poolName){
	var elemDiv = new Element("div.option", {'id': "pool_"+poolId, 'poolIdNum': poolId, 'name': poolName, html: poolName});
	if (!blockAll) { 
		new Element('div.optionRemove').addEvent('click', function(evt) { 
			processRemovePool(this.getParent()); 
		}).inject(elemDiv);
	} else { 
		elemDiv.addClass(readonlyClass);
	}
	
	elemDiv.getId = function () { return this.getAttribute("id"); };
	elemDiv.getPoolIdNum = function () { return this.getAttribute("poolIdNum"); };
	elemDiv.getPoolName = function () { return this.getAttribute("name"); };
	elemDiv.inject(addPools,"before")
}

function processRemovePool(pool){
	pool.destroy();
	var countPools = container.getElements("DIV").length;
	if (countPools == 2){
		createAllPools();
	}
}

function createAllPools(){
	var elemDiv = new Element("div", {'id': "allPools", html: ALL_POOLS, 'class': 'option'});
	if (blockAll) { elemDiv.addClass(readonlyClass); }			
	elemDiv.getId = function () { return this.getAttribute("id"); };
	elemDiv.inject(addPools,"before")
}

function destroyAllPools(){
	var div = $('allPools');
	if (div){ div.destroy(); }
} 

function destroyAllPoolsSelected(){
	container.getElements("DIV").each(function(item){
		if (item.get("id") != "addPool" && item.getParent().get('id') != 'addPool') {
			item.destroy();   
		}				
	});
	createAllPools();
	
	initAdminModalHandlerOnChangeHighlight($('poolsContainter'));
}

function processPoolsModalReturn(ret){
	var added = false;
	ret.each(function(e){
		if (!alreadyPoolExists("pool_"+e.getRowId())){
			createPool(e.getRowId(),e.getRowContent()[0]);			
			added = true;
		}
	});
	if (added){
		destroyAllPools();
	}
}

function alreadyPoolExists(elementId){
	var exists = false;
	container.getElements("DIV").each(function(item){
		if (item.getAttribute("id") == elementId){
			exists = true;
		}
	});
	return exists;
}

function environmentChange(cmb){
	$('environmentId').value = cmb.value;
	destroyAllPoolsSelected(); 
}

function getValuesToSend(){
	if (alreadyPoolExists("allPools")){
		return "allPools";
	} else {
		var valuesToSend = "";
		container.getElements("DIV").each(function(item){
			if (item.getAttribute("id") != "addPool" && item.getPoolIdNum){
				valuesToSend += item.getPoolIdNum() + PRIMARY_SEPARATOR + item.getPoolName() + ";";   
			}				
		});
		return valuesToSend;
	}	
}



	