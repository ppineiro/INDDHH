var countDeleted;
function initPage(){
	//crear spinner de espere un momento
	sp = new Spinner(document.body,{message:WAIT_A_SECOND});
	
	//actualizar
	var btnUpdate = $('btnUpdate');
	if (btnUpdate){
		btnUpdate.addEvent('click',function(e){
			e.stop();
			sp.show(true);
			window.location = CONTEXT + URL_REQUEST_AJAX + '?action=init&favFncId=131' + TAB_ID_REQUEST;
		})
	}
	//cerrar
	var btnCloseTab = $('btnCloseTab');
	if (btnCloseTab) {
		btnCloseTab.addEvent('click', function(e){
			e.stop();
			getTabContainerController().removeActiveTab();
		});
	}
	
	$$('div.fncDescriptionImage').each(function(e){
		var path = 'url(' + e.get('data-src') + ')'
		e.setStyle('background-image', path);
		e.setStyle('background-repeat', 'no-repeat');
		e.setStyle('width', '64px');
		e.setStyle('height', '64px');
	});
	
	//Unpublish All
	$('unpubAll').addEvent("click", function(e) {
		e.stop();
		if (countDeleted > 0){
			var request = new Request({
				method: 'post',
				url: CONTEXT + URL_REQUEST_AJAX + '?action=unpublishAllDeleted&isAjax=true' + TAB_ID_REQUEST,
				onRequest: function() { SYS_PANELS.showLoading(); },
				onComplete: function(resText, resXml) { SYS_PANELS.closeAll(); modalProcessXml(resXml); }
			}).send();		
		}
	});	
	
	initAdminFav();
	
	$$('div.fncDescriptionImage').each(function(e){
		var path = 'url(' + e.get('data-src') + ')'
		e.setStyle('background-image', path);
		e.setStyle('background-repeat', 'no-repeat');
		e.setStyle('width', '64px');
		e.setStyle('height', '64px');
	});
	
	//Cargar Web Services
	loadWebServices();			
}

function loadWebServices(){
	var spWSProcessContainter = new Spinner($('WSProcessContainter'));
	var spWSBusClassContainter = new Spinner($('WSBusClassContainter'));
	var spWSQueryContainter = new Spinner($('WSQueryContainter'));
	var spWSDeletedContainter = new Spinner($('WSDeletedContainter'));
	spWSProcessContainter.show(true);
	spWSBusClassContainter.show(true);
	spWSQueryContainter.show(true);
	spWSDeletedContainter.show(true);
	
	var request = new Request({
		method: 'post',
		url: CONTEXT + URL_REQUEST_AJAX + '?action=loadWebServices&isAjax=true' + TAB_ID_REQUEST,
		onRequest: function() { },
		onComplete: function(resText, resXml) { modalProcessXml(resXml); SYS_PANELS.closeAll(); spWSProcessContainter.hide(true); spWSBusClassContainter.hide(true); spWSQueryContainter.hide(true); spWSDeletedContainter.hide(true); }
	}).send();
}

function processXMLWebServices(all){
	var ajaxCallXml = getLastFunctionAjaxCall().getElementsByTagName("messages")[0].getElementsByTagName("result")[0];
	
	if (ajaxCallXml != null) {
		if (all){
			var wsProcess 	= ajaxCallXml.getElementsByTagName("webServices")[0].getElementsByTagName("webServicesProcess")[0].getElementsByTagName("webService");
			var wsBusClass 	= ajaxCallXml.getElementsByTagName("webServices")[0].getElementsByTagName("webServicesBusClass")[0].getElementsByTagName("webService");
			var wsQuery 	= ajaxCallXml.getElementsByTagName("webServices")[0].getElementsByTagName("webServicesQuery")[0].getElementsByTagName("webService");
			
			//WS : PROCCESS
			proccessXmlGroup(wsProcess,$('WSProcessContainter'),false);		
			//WS : BUSCLASS
			proccessXmlGroup(wsBusClass,$('WSBusClassContainter'),false);
			//WS : QUERY
			proccessXmlGroup(wsQuery,$('WSQueryContainter'),false);
		}
		
		//WS : DELETED
		var wsDeleted 	= ajaxCallXml.getElementsByTagName("webServices")[0].getElementsByTagName("webServicesDeleted")[0].getElementsByTagName("webService");
		proccessXmlGroup(wsDeleted,$('WSDeletedContainterIn'),true);
		countDeleted = wsDeleted.length;		
	}
}		

function proccessXmlGroup(arrayXml,container,deleted){
	for(var i = 0; i < arrayXml.length; i++){
		var hasStatus = true;
		var xmlWS = arrayXml[i];
		//DIV 
		var wsDiv = new Element("div", {'id': xmlWS.getAttribute("id"), 'class': 'option'});
		wsDiv.setAttribute("type",xmlWS.getAttribute("type"));
		wsDiv.inject(container);
		var wsSpan = new Element("span",{ html: xmlWS.getAttribute("name") });
		wsSpan.inject(wsDiv);
		//STATUS
		if (!deleted){
			wsDiv.addClass("optionLarge");
			var status = xmlWS.getAttribute("status");
			var wsStatus = new Element("div", {'id': "st_"+xmlWS.getAttribute("id"), 'class': 'optionIcon'});
			wsStatus.setAttribute("status",status);
			wsStatus.inject(wsDiv);
			if (status == "U"){
				wsStatus.addClass("optionWebServiceUnPub");
			} else if (status == "PO"){
				wsStatus.addClass("optionWebServicePubOk");
			} else if (status == "PN") {
				wsStatus.addClass("optionWebServicePubNOk");				
			} else {
				wsStatus.addClass("optionWebServiceNoStatus");
				hasStatus = false;
			}
			//TOOLTIP
			if (xmlWS.getAttribute("tooltip") == "PROC") {
				wsSpan.set('title', TOOLTIP_WS_PROC); 
			} else if (xmlWS.getAttribute("tooltip") == "TSK") {
				wsSpan.set('title', TOOLTIP_WS_TSK);
			}						
		}
		//ACTION
		var action = xmlWS.getAttribute("action");
		if (action == "P"){
			var wsAction = new Element("div", {'id': "act_"+xmlWS.getAttribute("id"), 'class': 'optionIcon optionPublish' });
			wsAction.set('title', TOOLTIP_PUB_UNPUB);
			wsAction.setAttribute("action",action);
			wsAction.addEvent('click', function(evt) { publishOrUnpublish(this.parentNode.getAttribute("id"),this.getAttribute("action")); });
			wsAction.inject(wsDiv);
		} else if (action == "U"){
			var wsAction = new Element("div", {'id': "act_"+xmlWS.getAttribute("id"), 'class': 'optionIcon optionUnPublish' });
			wsAction.set('title', TOOLTIP_PUB_UNPUB);
			wsAction.setAttribute("action",action);
			wsAction.addEvent('click', function(evt) { publishOrUnpublish(this.parentNode.getAttribute("id"),this.getAttribute("action")); });
			wsAction.inject(wsDiv);
		} else if (action == "UD"){
			var wsAction = new Element("div", {'id': "act_"+xmlWS.getAttribute("id"), 'class': 'optionIcon optionUnPublish' });
			wsAction.set('title', TOOLTIP_PUB_UNPUB);
			wsAction.setAttribute("action",action);
			wsAction.addEvent('click', function(evt) { unpublishDeleted(this.getAttribute("id")); });
			wsAction.inject(wsDiv);
		} else {
			var wsAction = new Element("div", {'class': 'optionIcon' });
			wsAction.inject(wsDiv);
		}
		//USER
		if (!deleted && hasStatus) {
			var wsUsr = new Element("div", {'id': "usr_"+xmlWS.getAttribute("id"), 'class': 'optionIcon'});
			var user = xmlWS.getAttribute("user");
			var blocked = (action == "U");
			wsUsr.setAttribute("users",user);
			wsUsr.setAttribute("blocked",blocked);
			if (user != null && user != ""){
				wsUsr.addClass("optionUsersSelected")
			} else {
				wsUsr.addClass("optionUsersUnSelected")
			}
			wsUsr.set('title', TOOLTIP_USERS);
			wsUsr.addEvent('click', function(evt) { openModalUsers(this.getAttribute("id"),this.getAttribute("users"),this.getAttribute("blocked")); });
			wsUsr.inject(wsDiv);
			//WSS
			var wssDiv = new Element("div", {'class': 'optionIcon'});
			wssDiv.set('title', "WSS");
			var wssCheck = new Element("input", {'type': "checkbox", 'id': "wss_"+xmlWS.getAttribute("id")});
			if(Browser.ie) wssCheck.setStyle('margin-top', 3);
			if (xmlWS.getAttribute("wss") == "true") { wssCheck.checked = true; }
			else { wsUsr.setStyle("visibility","hidden"); }
			wssCheck.addEvent('change', function(evt) { showUsrsIcon(this); });
			wssCheck.inject(wssDiv);
			wssDiv.inject(wsDiv);
			if (action == "U") { wssCheck.disabled = true; }
		}		
	}
	
	if (arrayXml.length == 0){
		new Element("span",{'class': 'italic', html: NO_EXIST_WS_CAT}).inject(container);
	}
	
	if (deleted){
		$('unpubAll').style.display = (arrayXml.length > 0) ? '' : 'none';		
	}
	
}

function openModalUsers(id,selectedUsers,blocked){
	var request = new Request({
		method: 'post',
		url: CONTEXT + URL_REQUEST_AJAX + '?action=webServicesUsers&isAjax=true&id=' + id + '&selected=' + selectedUsers + '&blocked=' + blocked + TAB_ID_REQUEST,
		onRequest: function() { SYS_PANELS.showLoading(); },
		onComplete: function(resText, resXml) { modalProcessXml(resXml); }
	}).send();
}

function publishOrUnpublish(wsId,action){
	if (action == "P"){
		publish(wsId);
	} else if (action == "U"){
		unpublish(wsId)
	}
}

function publish(wsId){
	var params = getWSData(wsId);
	var request = new Request({
		method: 'post',
		url: CONTEXT + URL_REQUEST_AJAX + '?action=publish&isAjax=true' + TAB_ID_REQUEST,
		onRequest: function() { SYS_PANELS.showLoading(); },
		onComplete: function(resText, resXml) { modalProcessXml(resXml); }
	}).send(params);
}

function unpublish(wsId){
	var params = getWSData(wsId); 
	var request = new Request({
		method: 'post',
		url: CONTEXT + URL_REQUEST_AJAX + '?action=unpublish&isAjax=true' + TAB_ID_REQUEST,
		onRequest: function() { SYS_PANELS.showLoading(); },
		onComplete: function(resText, resXml) { modalProcessXml(resXml); }
	}).send(params);
}

function unpublishDeleted(wsName){
	var name = wsName.split("_")[1]; 
	var request = new Request({
		method: 'post',
		url: CONTEXT + URL_REQUEST_AJAX + '?action=unpublishDeleted&isAjax=true&name=' + name + TAB_ID_REQUEST,
		onRequest: function() { SYS_PANELS.showLoading(); },
		onComplete: function(resText, resXml) { SYS_PANELS.closeAll(); modalProcessXml(resXml); }
	}).send();
}

function getWSData(wsId){
	var params = "&id="+encodeURIComponent(wsId);
	var wss = $("wss_"+wsId);
	if (wss.checked == true){
		params += "&wss=true"
	} else {
		params += "&wss=false"
	}
	var users = $("usr_"+wsId);
	params += "&user="+users.getAttribute("users");
	params += "&type="+$(wsId).getAttribute("type");
	return params;
}

function processXMLActionReturn(showMsg){
	var ajaxCallXml = getLastFunctionAjaxCall().getElementsByTagName("messages")[0].getElementsByTagName("result")[0];
	if (ajaxCallXml != null) {
		var xmlWS = ajaxCallXml.getElementsByTagName("webServices")[0].getElementsByTagName("webService")[0];
		var id = xmlWS.getAttribute("id");
		var published = xmlWS.getAttribute("action") == "U";
		
		//Cambio de estado
		var state = $("st_"+id);
		var oldStateValue = state.getAttribute("status");
		var newStateValue = xmlWS.getAttribute("status");
		if (oldStateValue != newStateValue){
			if (oldStateValue == "U"){
				state.removeClass("optionWebServiceUnPub");
			} else if (oldStateValue == "PO"){
				state.removeClass("optionWebServicePubOk");
			} else if (oldStateValue == "PN") {
				state.removeClass("optionWebServicePubNOk");
			}
			if (newStateValue == "U"){
				state.addClass("optionWebServiceUnPub");
			} else if (newStateValue == "PO"){
				state.addClass("optionWebServicePubOk");
			} else if (newStateValue == "PN"){
				state.addClass("optionWebServicePubNOk");
			}
			state.setAttribute("status",newStateValue);
		}
		
		//Cambio de accion
		var action = $("act_"+id);
		if (action.getAttribute("action") != xmlWS.getAttribute("action")){
			var wss = $("wss_"+id);
			
			if (published){
				action.removeClass("optionPublish");
				action.addClass("optionUnPublish");
				
				wss.disabled = true; //Deshabilita wss
				
				var usrs = $("usr_"+id); //Bloquea el cambio de usuarios
				usrs.setAttribute("blocked",true);
				
			} else {
				action.removeClass("optionUnPublish");
				action.addClass("optionPublish");
				
				wss.disabled = false; //Habilita wss
				
				var usrs = $("usr_"+id); //Bloquea el cambio de usuarios
				usrs.setAttribute("blocked",false);
			}
			
			action.setAttribute("action",xmlWS.getAttribute("action"));
		}
		SYS_PANELS.closeActive();
		if (showMsg) { showMessage(COMPLETE_OK); }
	}
}

function processXMLUnpublishDeletedReturn(showComplete){
	//Elimina todos los existentes
	var container = $('WSDeletedContainterIn');
	container.getElements("div").each(function(item){ item.destroy(); });
	//Recarga el panel
	processXMLWebServices(false);
	if (showComplete) {
		showMessage(COMPLETE_OK);
	}
}

function changeUserSelected(id,usr){
	var elem = $(id);
	elem.setAttribute("users",usr);
	if (usr == "") { 
		elem.removeClass("optionUsersSelected"); 
		elem.addClass("optionUsersUnSelected"); 
	} else {
		elem.removeClass("optionUsersUnSelected"); 
		elem.addClass("optionUsersSelected");
	}
}

function showUsrsIcon(chk){
	var numId = chk.getAttribute("id").split("_")[1];
	var usr = $("usr_"+numId);
	if (chk.checked == true){
		usr.setStyle("visibility","visible");
	} else {
		usr.setStyle("visibility","hidden");
	}
}
	