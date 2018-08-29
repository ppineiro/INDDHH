var canChange = true;
var readonlyClass = "readonly";
var validateClass = "validate['required']";
var requiredClass = "required";
var groupSelected;
var totalGroups = 0;
var isErrorDate = false;

function initPage(){
	//crear spinner de espere un momento
	sp = new Spinner(document.body,{message:WAIT_A_SECOND});
	
	//cargar datepicker
	$$("input.datePickerCustom").each(function(datepicker) {
		datepicker.set('hasDatepicker', true);
		var img = new Element("img.datepickerSelector", {src: CONTEXT+"/css/"+STYLE+"/img/calendar.png"});
		img.inject(datepicker,"after");

		var format = (datepicker.getAttribute("format") == null) ? DATE_FORMAT : datepicker.getAttribute("format");
		
		var d = new DatePicker(datepicker, { 
			pickerClass: 'datepicker_vista', 
			allowEmpty: true, 
			format: format, 
			inputOutputFormat: format, 
			toggleElements: img,
			toggleElementsDontAvoid: true,
			isReadonly: datepicker.hasClass('readonly'),
			onClose: function(o){ validateDates(o); }
		});
		
		if(datepicker.get('fld_id')) {
			datepicker.store('datepicker', d);
			datepicker.getNext().set('id', datepicker.get('fld_id') + '_d');
		}
	});
		
	//Data
	getData();
	/*
	var btnConf = $('btnConf');
	if (btnConf){
		btnConf.addEvent("click", function(e) {
			e.stop();		
			getValuesToSend();
		});
	}
	*/
	var extraSQL = "and usr_flags like '0%' and (usr_flags like '__1%' or usr_login in (select usr_login from env_user where env_id = ?))";
	extraSQL = extraSQL.replace("?",ENV_ID);
	
	if (HIERARCHY){
		extraSQL += " and usr_login in (select u.usr_login from users u, usr_pool up, pool_hierarchy ph where u.usr_login=up.usr_login and up.pool_id=ph.pool_id_child and up.pool_id in (?))";		
		if (POOLS_IN_HIERARCHY==""){
			//Representa estructura vacia
			POOLS_IN_HIERARCHY = "-1";
		}
		extraSQL = extraSQL.replace("?",POOLS_IN_HIERARCHY);
	}
	
	toLower($('usrLogin'));	
	setAutoCompleteGeneric( $('usrLogin'), null, 'search', 'users', 'usr_login', 'usr_login', 'usr_login', false, true, false, true, "", null, extraSQL);
	$('usrLogin').addEvent('optionNotSelected', function(evt) {
		$('usrName').innerHTML = "";
		$('usrEmail').innerHTML = "";
	});
	$('usrLogin').addEvent('optionSelected', function(evt) {
		var newUser = $('usrLogin').value;
		restart();
		$('usrLogin').value = newUser;
		var request = new Request({
			method: 'post',
			url: CONTEXT + URL_REQUEST_AJAX + '?action=userSelected&isAjax=true' + TAB_ID_REQUEST,
			onComplete: function(resText, resXml) { modalProcessXml(resXml);}
		}).send("usrLogin=" + $('usrLogin').value);
		
		//var load = $('dteFrom').value != "";  
		
		callGetData
		
		/*if (load){ 
			//Verifica si ya existe licencia para el usuario seleccionado
			var request = new Request({
				method: 'post',
				url: CONTEXT + URL_REQUEST_AJAX + '?action=verifyUser&isAjax=true&id=' + $('usrLogin').value + '&load=' + load + TAB_ID_REQUEST,
				onRequest: function() { SYS_PANELS.showLoading(); },
				onComplete: function(resText, resXml) { modalProcessXml(resXml); }
			}).send();
		}*/
	});
	

	
	initAdminActionsEdition(getValuesToSend);
	initUsrMdlPage();
	initPrfMdlPage();
		
}

function validateDates(date){
	var from = $('dteFrom');
	var to = $('dteTo');	
	if (verifyDates(from,to)){
		
		/*if ($('usrLogin').value != ""){ 
			//Verifica si ya existe licencia para el usuario seleccionado
			var request = new Request({
				method: 'post',
				url: CONTEXT + URL_REQUEST_AJAX + '?action=verifyUser&isAjax=true&id=' + $('usrLogin').value + '&load=' + load + TAB_ID_REQUEST,
				onRequest: function() { SYS_PANELS.showLoading(); },
				onComplete: function(resText, resXml) { modalProcessXml(resXml); }
			}).send();
		} else {*/
			callGetData();
		//}
		
	} else {
		showMessage(MSG_FEC_FIN_MAY_FEC_INI, GNR_TIT_WARNING, 'modalWarning');
		date.value = "";
		date.getNext().value = "";		
	}
}

function callGetData(){
	var user = $('usrLogin').value != ""
	var from = $('dteFrom').value != "";
	
	var to = $('dteTo').value != "";
	
	if (user && from && canChange){
		disableFields(to);
		canChange = false;	
		getData();		
	} else if (to && !canChange) {
		disableDteTo();		
	} else {
		canChange = true;
	}
}

function disableFields(disDteTo){
	$('usrLogin').addClass(readonlyClass);
	$('usrLogin').removeClass('autocomplete');
	$('usrLogin').readonly = true;
	$('usrLogin').disabled = true;
	$('dteFrom').addClass(readonlyClass);
	$('dteFrom').disabled = true;
	$('dteFrom').getNext().disabled = true;
	$('dteFrom').getNext().addClass(readonlyClass);	
	if (disDteTo){
		disableDteTo();
	}
}

function disableDteTo(){
	$('dteTo').addClass(readonlyClass);	
	$('dteTo').disabled = true;
	$('dteTo').getNext().disabled = true;
	$('dteTo').getNext().addClass(readonlyClass);
}

function getData(){
	var params = "";
	if ($('usrLogin').value != ""){ //mode create
		 params = "&usrLogin=" + $('usrLogin').value;
		 params += "&dteFrom=" + $('dteFrom').value;
		 params += "&dteTo=" + $('dteTo').value;		 
	}
	var request = new Request({
		method: 'post',
		url: CONTEXT + URL_REQUEST_AJAX + '?action=getUserGroups&isAjax=true' + TAB_ID_REQUEST + params,
		onRequest: function() { SYS_PANELS.showLoading(); },
		onComplete: function(resText, resXml) { modalProcessXml(resXml); }
	}).send();
}

function cleanTable(table){
	table.getChildren().each(function(ele) { ele.destroy(); });
}

function processXMLGridUserGroups(show){
	var tableData = $('tableData');
	if (!isErrorDate) {
		cleanTable(tableData);
	}
	
	var ajaxCallXml = getLastFunctionAjaxCall().getElementsByTagName("messages")[0].getElementsByTagName("result")[0];
	
	if (ajaxCallXml != null) {
		
		/* Fields */
		if (ajaxCallXml.getElementsByTagName("selection")[0].getElementsByTagName("user")){
			var userSel = ajaxCallXml.getElementsByTagName("selection")[0].getElementsByTagName("user")[0];
			if (userSel){
				$('usrLogin').value = userSel.getAttribute("login");
				$('usrName').innerHTML = userSel.getAttribute("name");
				$('usrEmail').innerHTML = userSel.getAttribute("email");
				$('dteFrom').value = userSel.getAttribute("from");
				$('dteFrom').getNext().value = userSel.getAttribute("from");
				if (userSel.getAttribute("to")){
					$('dteTo').value = userSel.getAttribute("to");
					$('dteTo').getNext().value = userSel.getAttribute("to");
				} 
				disableFields(true);
			}			
		}		
		
		if (!isErrorDate){
			/* Grid */
			if (ajaxCallXml.getElementsByTagName("groups")[0].getElementsByTagName("group")){
				var groups = ajaxCallXml.getElementsByTagName("groups")[0].getElementsByTagName("group");
				
				totalGroups = groups.length;
				if (totalGroups>0){ 
					$('opcBtns').removeClass('hidden');				
				}
				
				/* Groups */
				var rowClassId = -1;
				for(var i = 0; i < groups.length; i++){					
					var xmlGroup = groups[i];
					var fromHierarchy = xmlGroup.getAttribute("hierarchy")=="true"; 
					
					var tr = new Element("tr");
					if (HIERARCHY && !fromHierarchy){ 
						tr.addClass("hidden"); 
						}
					else { 
						rowClassId++; 
					}
					if (rowClassId % 2 == 0){ tr.addClass("trOdd"); }					
					
					tr.setAttribute("rowId", i);			
					tr.getRowId = function () { return this.getAttribute("rowId"); };
					tr.inject(tableData);
									
					/* Group */
					var tdGroup = new Element("td", { 'id': xmlGroup.getAttribute("id"), 'styles': {width: '20%'} } ).inject(tr);
					var divTdGroup = new Element('div', {styles: {width: '100%', overflow: 'hidden', 'white-space': 'pre', 'margin': '4px 0px'}}).inject(tdGroup);
					var spanTdGroup = new Element('span',{html: xmlGroup.getAttribute("name")}).inject(divTdGroup);
					if (divTdGroup.scrollWidth > divTdGroup.offsetWidth) {
						tdGroup.title = xmlGroup.getAttribute("name");
						tdGroup.addClass("titiled");
					}							
					
					/* Users */
					var tdUsers = new Element("td", { 'class': 'modalOptionsContainer', 'styles': {width: '40%'} });
					tdUsers.setAttribute("id","usrContainer_"+i);
					tdUsers.inject(tr);			
					var users = xmlGroup.getElementsByTagName("users")[0].getElementsByTagName("user");
					for (var j = 0; j < users.length; j++) {
						var xmlUser = users[j];
						var aUser = new Element("div", {'class': 'option optionRemove', 'id': xmlUser.getAttribute("id"), html: xmlUser.getAttribute("login") });
						if (!IS_FINISHED) { aUser.addEvent('click', function(evt) { this.destroy(); }); }
						aUser.inject(tdUsers);
					}
					if (!IS_FINISHED){
						var addUser = new Element("div", {'class': 'option optionAdd', html: BTN_ADD });
						addUser.setAttribute("id","addUsr_"+i);
						addUser.addEvent('click', function(evt) { groupSelected = this.parentNode.parentNode.getRowId(); addUsrToGroup(); });
						addUser.inject(tdUsers);
					}
					
					/* Profiles */
					var tdProfiles = new Element("td", { 'class': 'modalOptionsContainer', 'styles': {width: '40%'} });
					tdProfiles.setAttribute("id","profContainer_"+i);
					tdProfiles.inject(tr);			
					var profiles = xmlGroup.getElementsByTagName("profiles")[0].getElementsByTagName("profile");
					for (var j = 0; j < profiles.length; j++) {
						var xmlProfile = profiles[j];
						var aProfile = new Element("div", {'class': 'option optionRemove', 'id': xmlProfile.getAttribute("id"), 'name': xmlProfile.getAttribute("name"), html: xmlProfile.getAttribute("name") });
						if (!IS_FINISHED) { aProfile.addEvent('click', function(evt) { this.destroy(); }); }
						aProfile.inject(tdProfiles);
					}
					if (!IS_FINISHED){
						var addProf = new Element("div", {'class': 'option optionAdd', html: BTN_ADD });
						addProf.setAttribute("id","addPro_"+i);
						addProf.addEvent('click', function(evt) { groupSelected = this.parentNode.parentNode.getRowId(); addProfToGroup(); });
						addProf.inject(tdProfiles);
					}
				}				
			}

			//Se marca ultima fila visible
			if (rowClassId != -1){
				tr = tableData.getElements('tr:not([class*="hidden"]').getLast();
				tr.addClass("lastTr"); 
			}
			
			if (!IS_FINISHED){				
				$('addAllSust').addEvent('click', function(evt) { addUsrToGroup(true); });
				$('addAllProfSust').addEvent('click', function(evt) { addProfToGroup(true); });				
			}
			
		}		
	}	
	
	isErrorDate = false;
	
	SYS_PANELS.closeAll();
	
	//Mensaje: ya existe licencia
	if (show){
		showMessage(MSGSUBTALREADYEXIST, GNR_TIT_WARNING, 'modalWarning');
	}
}

function addUsrToGroup(all){
	sp = new Spinner($('gridTableBody').getParent(),{message:WAIT_A_SECOND});
	ADDITIONAL_INFO_IN_TABLE_DATA = false;
	USERMODAL_SELECTONLYONE = false;
	USERMODAL_GLOBAL_AND_ENV = true;
	USERMODAL_HIERARCHY = HIERARCHY;
	if (all){
		showUsersModal(processUsersAllGroupsModalReturnGrid);		
	}
	else{
		showUsersModal(processUsersModalReturnGrid);
	}
}

function addProfToGroup(all){
	sp = new Spinner($('gridTableBody').getParent(),{message:WAIT_A_SECOND});
	ADDITIONAL_INFO_IN_TABLE_DATA = false;
	PROFILEMODAL_SELECTONLYONE = false;
	PROFILEMODAL_SHOWGLOBAL = true;
	PROFILEMODAL_USERID = $('usrLogin').value;
	PROFILEMODAL_FROMENVS = CURRENT_ENVIRONMENT;
	if (HIERARCHY){/*poner estrucutra jerarquica*/}
	if (all){
		showProfilesModal(processProfilesAllGroupsModalReturnGrid);
	}
	else{
		showProfilesModal(processProfilesModalReturnGrid);
	}
}

//Reiniciar campos
function restart(){
	$('usrLogin').value = "";
	$('usrLogin').removeClass(readonlyClass);	
	$('usrLogin').addClass('autocomplete');	
	$('usrLogin').readonly = false;
	$('usrLogin').disabled = false;
	$('dteFrom').value = "";
	$('dteFrom').getNext().value = "";
	$('dteFrom').removeClass(readonlyClass);
	$('dteFrom').disabled = false;
	$('dteFrom').getNext().disabled = false;	
	$('dteTo').value = "";
	$('dteTo').getNext().value = "";
	$('dteTo').removeClass(readonlyClass);
	$('dteTo').disabled = false;
	$('dteTo').getNext().disabled = false;	
	cleanTable($('tableData'));	
	canChange = true;
}

function processUsersModalReturnGrid(ret){
	var add = $("addUsr_"+groupSelected);
	var container = $("usrContainer_"+groupSelected)
	ret.each(function(e){
		if (e.getRowId() != $('usrLogin').value && !alreadyExists(container,e.getRowId())){
			var nUser = new Element("div", {'class': 'option optionRemove', 'id': e.getRowId(), html: e.getRowId() });
			nUser.addEvent('click', function(evt) { this.destroy(); });
			nUser.inject(add, "before");		
		}
	});	
}
function processUsersAllGroupsModalReturnGrid(ret){
	var rowsCount = $('gridTableBody').getElementById('tableData').rows.length;
	for(var i=0; i<rowsCount; i++){
		groupSelected = i;
		var add = $("addUsr_"+groupSelected);
		var container = $("usrContainer_"+groupSelected)
		ret.each(function(e){
			if (e.getRowId() != $('usrLogin').value && !alreadyExists(container,e.getRowId())){
				var nUser = new Element("div", {'class': 'option optionRemove', 'id': e.getRowId(), html: e.getRowId() });
				nUser.addEvent('click', function(evt) { this.destroy(); });
				nUser.inject(add, "before");		
			}
		});
	};
}
function processProfilesModalReturnGrid(ret){
	var add = $("addPro_"+groupSelected);
	var container = $("profContainer_"+groupSelected)
	ret.each(function(e){
		if (!alreadyExists(container,e.getRowId())){
			var content = e.getRowContent();
			var nProfile = new Element("div", {'class': 'option optionRemove', 'id': e.getRowId(), 'name': content[0], html: content[0] });
			nProfile.addEvent('click', function(evt) { this.destroy(); });
			nProfile.inject(add, "before");
		}
	});		
}
function processProfilesAllGroupsModalReturnGrid(ret){
	var rowsCount = $('gridTableBody').getElementById('tableData').rows.length;
	for(var i=0; i<rowsCount; i++){
		groupSelected = i;
		var add = $("addPro_"+groupSelected);
		var container = $("profContainer_"+groupSelected)
		ret.each(function(e){
			if (!alreadyExists(container,e.getRowId())){
				var content = e.getRowContent();
				var nProfile = new Element("div", {'class': 'option optionRemove', 'id': e.getRowId(), 'name': content[0], html: content[0] });
				nProfile.addEvent('click', function(evt) { this.destroy(); });
				nProfile.inject(add, "before");
			}
		});	
	};
}

function alreadyExists(container,elementId){
	var exists = false;
	container.getElements("DIV").each(function(item){
		if (item.getAttribute("id") == elementId){
			exists = true;
		}
	});
	return exists;
}

function getValuesToSend(){
	var inputHidden = null;
	var values = null;
	for (var i = 0; i < totalGroups; i++){
		inputHidden = $('usrs_'+i);
		if (!inputHidden) inputHidden = new Element("input",{'type':'hidden','name':'usrs_'+i,'id':'usrs_'+i}).inject($('frmData'));
		values = "";
		
		//Usuarios
		$("usrContainer_"+i).getElements("DIV").each(function(item){
			var id = item.getAttribute("id");
			if (id != "addUsr_"+i){
				values += id + ";";   
			}				
		});
		inputHidden.value = values;
		
		//Perfiles
		inputHidden = $('prof_'+i);
		if (!inputHidden) inputHidden = new Element("input",{'type':'hidden','name':'prof_'+i,'id':'prof_'+i}).inject($('frmData'));
		values = "";
		$("profContainer_"+i).getElements("DIV").each(function(item){
			var id = item.getAttribute("id");
			if (id != "addPro_"+i){
				values += id + "," + item.getAttribute("name") + ";";   
			}				
		});		
		inputHidden.value = values;
	}	
}

function loadUserData(){
	var ajaxCallXml = getLastFunctionAjaxCall();
	if (ajaxCallXml != null) {
		var messages = ajaxCallXml.getElementsByTagName("messages");
		if (messages != null && messages.length > 0) {
			messages = messages[0].getElementsByTagName("message");
			if (messages != null) {
				for (var i = 0; i < messages.length; i++) {
					var message = messages[i];
					$(message.getAttribute('name')).innerHTML = (message.firstChild != null) ? message.firstChild.nodeValue : ""
				}
			}
		}
	}
}	

function toLower(ele){
	ele = $(ele);
	if (ele) { 
		ele.addEvent("keyup",function(e){
			if (ele.value != null && ele.value != ""){
				ele.value = ele.value.toLowerCase();
			}
		});
	}	
}

function mustBeChangeDate(){
	SYS_PANELS.closeAll();
	showMessage(MSG_CHANGE_DATE, GNR_TIT_WARNING, 'modalWarning');
	$('dteFrom').removeClass(readonlyClass);
	$('dteFrom').disabled = false;
	$('dteFrom').getNext().disabled = false;
	$('dteFrom').getNext().removeClass(readonlyClass);
	$('dteTo').removeClass(readonlyClass);
	$('dteTo').disabled = false;
	$('dteTo').getNext().disabled = false;
	$('dteTo').getNext().removeClass(readonlyClass);
	canChange = true;
	isErrorDate = true;
}
