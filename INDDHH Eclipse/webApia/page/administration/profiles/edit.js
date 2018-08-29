var envContainer;
var dashContainer;
var fncsContainer;
var global;
var envSelected;
var envContainerSelected;
var spanFunc;
var spanDash;
var addFnc;
var fncToRemove;
var folToRemove;

function initPage(){
	//Inicializar variables
	addFnc = $('addFnc');
	envContainer = $('envsContainer');
	dashContainer = $('dashContainer');
	fncsContainer = $('fncsContainer');
	global = $('addEnv') != null;
	spanFunc = $('tFunc');
	spanDash = $('tDash');
	$('divDash').setStyle('display','none');
	envSelected = null;
	fncToRemove = null;
	folToRemove = null;
	sp = new Spinner(document.body,{message:WAIT_A_SECOND});
		
	//Cargar Ambientes
	loadEnvs();
	
	//Agregar Ambiente
	if (global){
		$('addEnv').addEvent("click", function(e) {
			e.stop();
			ADDITIONAL_INFO_IN_TABLE_DATA = false;
			ENVIRONMENTMODAL_SELECTONLYONE = false;
			showEnvironmentsModal(processEnvsModalReturn);				
		});
	}
	
	
	//Agregar Dashboards

	$('addDsh').addEvent("click", function(e) {
		e.stop();
		ADDITIONAL_INFO_IN_TABLE_DATA = false;
		DASHBOARDSMODAL_SELECTONLYONE = false;
		DASHBOARD_ENVIRONMENT = envSelected;
		showDashboardsModal(processDashModalReturn);				
	});
	
	
	//Agregar Funcionalidades
	addFnc.addEvent("click", function(e) {
		e.stop();
		showTreeFncsModal(global,getFncIdToExclude().split(","),envSelected,processFncsModalReturn);		
	});
	
	//Cargar datos de los ambientes a mandar
	$('btnConf').addEvent("click", function(e) {
		e.stop();		
		$('envs').value = getEnvToSend();		
	});
	
	initEnvMdlPage()
	initDashboardsMdlPage()
	initFncTreeMdlPage();
	initAdminFieldOnChangeHighlight();
	initAdminActionsEdition();
	initAdminFav();		
	
	getBodyController().canRemoveTab = function() { return ! AT_LEAST_ON_FIELD_INPUT_CHANGED; };
}

function loadEnvs(){
	var request = new Request({
		method: 'post',
		url: CONTEXT + URL_REQUEST_AJAX + '?action=loadEnvs&isAjax=true' + TAB_ID_REQUEST,
		onRequest: function() { SYS_PANELS.showLoading(); },
		onComplete: function(resText, resXml) { 
			SYS_PANELS.closeAll(); modalProcessXml(resXml);
			
			initAdminModalHandlerOnChangeHighlight($('envsContainer'));
		}
	}).send();
}

function processXMLEnvs(){
	var ajaxCallXml = getLastFunctionAjaxCall().getElementsByTagName("messages")[0].getElementsByTagName("result")[0];
	if (ajaxCallXml != null && ajaxCallXml.getElementsByTagName("environments")[0].getElementsByTagName("environment")) {
		var environments = ajaxCallXml.getElementsByTagName("environments")[0].getElementsByTagName("environment");
		for (var i = 0; i < environments.length; i++){
			var xmlEnv = environments[i];
			createEnv(xmlEnv.getAttribute("id"),xmlEnv.getAttribute("name"));					
		}		
	}
}

function processXMLDshs(){
	SYS_PANELS.closeAll();
	var ajaxCallXml = getLastFunctionAjaxCall().getElementsByTagName("messages")[0].getElementsByTagName("result")[0];
	if (ajaxCallXml != null && ajaxCallXml.getElementsByTagName("dashboards")[0].getElementsByTagName("dashboard")) {
		var dashboards = ajaxCallXml.getElementsByTagName("dashboards")[0].getElementsByTagName("dashboard");
		for (var i = 0; i < dashboards.length; i++){
			var xmlDsh = dashboards[i];
			var element = addActionElement($('dashContainer'), xmlDsh.getAttribute("name"),xmlDsh.getAttribute("id"),'hidDsh');
			element.getElement('div.optionRemove').removeEvent('click', actionElementAdminClickRemove).addEvent('click', function(evt) {
				
				new Request({
					method: 'post',
					url: CONTEXT + URL_REQUEST_AJAX + '?action=removeDashboard&isAjax=true&envId=' + envSelected  + "&dshId=" + this.getParent().getAttribute('data-id') + TAB_ID_REQUEST,
					onRequest: function() { SYS_PANELS.showLoading(); },
					onComplete: function(resText, resXml) {
						modalProcessXml(resXml);
						SYS_PANELS.closeAll(); 
					}
				}).send();
				
				this.getParent().destroy();
			});
		}		
	}
}


function createEnv(envId,envName){
	var elemDiv = new Element("div", {'id': envId, 'name': envName, 'class': 'option optionWidthAllModal optionBoxSizing'});
	var span = new Element("span", {html: envName});
	span.inject(elemDiv);
	
	if (envId == 0){
		span.addClass("optionItalic");
	} else if (global) {
		elemDiv.addClass('optionNoRightPadding')
		new Element('div.optionRemove').addEvent('click', function(evt) { deleteEvt(this.getParent()); }).inject(elemDiv);
	}
		
	var fncDiv = new Element("div", {'class': 'optionIcon optionModify'});
	fncDiv.set('title', FNCS);
	fncDiv.addEvent('click', function(evt) { showFunc(this.parentNode); if (evt) { evt.stopPropagation(); } });
	fncDiv.inject(elemDiv);
	if (global) { 
		elemDiv.inject($('addEnv'),"before") 
	} else { 
		elemDiv.inject(envContainer);
		//Mostrar Funcionalidades (solo para 'Perfiles del Ambiente')
		fncDiv.fireEvent("click");
		fncDiv.setStyle("visibility","hidden");
	}	
}

 

function deleteEvt(env){
	var request = new Request({
		method: 'post',
		url: CONTEXT + URL_REQUEST_AJAX + '?action=removeEnvironment&isAjax=true&envId=' + env.getAttribute("id") + TAB_ID_REQUEST,
		onRequest: function() { SYS_PANELS.showLoading(); },
		onComplete: function(resText, resXml) { modalProcessXml(resXml); SYS_PANELS.closeAll(); }
	}).send();
	
	if (env.getAttribute("id") == envSelected){ cleanFunc(); }
	env.destroy();
}

function showFunc(env){
	var spFncs = new Spinner($('divFunctionalities'));
	spFncs.show(true);
	
	cleanFunc();
	cleanDash();
	envSelected = env.getAttribute("id");
	envContainerSelected = env;
	spanFunc.innerHTML = FNCS + " - " + env.getAttribute("name");
	spanDash.innerHTML = DASH + " - " + env.getAttribute("name");
	if(envSelected != 0){
		$('divDash').setStyle('display','');
	} else {
		$('divDash').setStyle('display','none');
	}
	var request = new Request({
		method: 'post',
		url: CONTEXT + URL_REQUEST_AJAX + '?action=showFunctionalities&isAjax=true&envId=' + envSelected + TAB_ID_REQUEST,
		onRequest: function() { },
		onComplete: function(resText, resXml) { modalProcessXml(resXml); spFncs.hide(true); }
	}).send();	
	
	var request = new Request({
		method: 'post',
		url: CONTEXT + URL_REQUEST_AJAX + '?action=showDashboards&isAjax=true&envId=' + envSelected + TAB_ID_REQUEST,
		onRequest: function() { },
		onComplete: function(resText, resXml) { 
			modalProcessXmlDashboards(resXml); spFncs.hide(true);
			
			initAdminModalHandlerOnChangeHighlight(dashContainer);
		}
	}).send();	
}

function modalProcessXmlDashboards(ajaxCallXml){
	
	if (ajaxCallXml != null) {
		 
		var envs = ajaxCallXml.getElementsByTagName("dashboards");
		if (envs != null && envs.length > 0 && envs.item(0) != null) {
			envs = envs.item(0).getElementsByTagName("dashboard");
			for(var i = 0; i < envs.length; i++) {
				var env = envs.item(i);
				var text	= env.getAttribute("text");
				var id = env.getAttribute("id");
				var addRemove = true;
				var element = addActionElementAdmin($('dashContainer'), text, id, "false", addRemove, "hidDash");
				element.getElement('div.optionRemove').removeEvent('click', actionElementAdminClickRemove).addEvent('click', function(evt) {
					
					new Request({
						method: 'post',
						url: CONTEXT + URL_REQUEST_AJAX + '?action=removeDashboard&isAjax=true&envId=' + envSelected  + "&dshId=" + this.getParent().getAttribute('data-id') + TAB_ID_REQUEST,
						onRequest: function() { SYS_PANELS.showLoading(); },
						onComplete: function(resText, resXml) {
							modalProcessXml(resXml);
							SYS_PANELS.closeAll();
						}
					}).send();
					
					this.getParent().destroy();
				});
			}
		}
	}
}


function processXMLFncs(hasFncs){
	SYS_PANELS.closeAll();
	
	fncsContainer.innerHTML = '';	
	
	if ($('noFncs')) { $('noFncs').destroy(); }
	var ajaxCallXml = getLastFunctionAjaxCall().getElementsByTagName("messages")[0].getElementsByTagName("result")[0];
	if (ajaxCallXml != null && ajaxCallXml.getElementsByTagName("functionalities")[0].getElementsByTagName("functionality")) {
		var functionalities = ajaxCallXml.getElementsByTagName("functionalities")[0].getElementsByTagName("functionality");
		for (var i = 0; i < functionalities.length; i++){
			var xmlFnc = functionalities[i];
			
			if (!$("fnc_"+xmlFnc.getAttribute("id"))){
				var father = null;
				if (xmlFnc.getAttribute("father") != ""){
					father = $("father_"+xmlFnc.getAttribute("father"));
					if(!father)
						father = fncsContainer;
				} else {
					father = fncsContainer;
				}
				
				var elem = new Element('li',{'id': "fnc_"+xmlFnc.getAttribute("id")});
				elem.setAttribute("father",father.getAttribute("id"));
				if (xmlFnc.getAttribute("father") != "") { elem.setAttribute("fncFatherId","fnc_"+xmlFnc.getAttribute("father")); }
				elem.setAttribute("fncType",xmlFnc.getAttribute("type"));
				elem.inject(father);
				
				var span = new Element("span",{ html: xmlFnc.getAttribute("name") });
				span.inject(elem);
				
				var remove = new Element("div",{'class': 'optionRemoveFnc'}).inject(span);
				remove.set('title', GNR_NAV_ADM_DELETE);
				
				if (xmlFnc.getAttribute("type") == "F") {
					var ul = new Element("ul",{'id': "father_"+xmlFnc.getAttribute("id")});
					ul.inject(elem);
					remove.addEvent('click', function(evt) { 
						folToRemove = this.parentNode.parentNode; 
						if (this.OBJtooltip){ this.OBJtooltip.hide(); } 
						confirmDelete(); 
					});
					var opclo = new Element("div",{'class': "hideChilds"});
					opclo.setAttribute("childs","father_"+xmlFnc.getAttribute("id"));
					opclo.setAttribute("open","true");
					opclo.addEvent('click', function(evt) { showOrHideChilds(this); evt.stopPropagation(); });
					opclo.inject(remove,"before");
				} else {
					remove.addEvent('click', function(evt) { 
						fncToRemove = this.parentNode.parentNode; 
						if (this.OBJtooltip){ this.OBJtooltip.hide(); } 
						deleteFnc(); 
					});
				}				
			}			
		}
	}
	if (hasFncs){
		fncsContainer.setStyle("visibility",""); 
	} else {
		(new Element("span", {'id': 'noFncs', html: NO_FNCS_SEL})).inject(fncsContainer,"before");
	}
	addFnc.setStyle("visibility","");
}

function showOrHideChilds(obj){
	if (obj.getAttribute("open") == "true"){
		obj.removeClass("hideChilds");
		obj.addClass("showChilds");
		obj.setAttribute("open","false");
		$(obj.getAttribute("childs")).setStyle("display","none");
	} else {
		obj.removeClass("showChilds");
		obj.addClass("hideChilds");
		obj.setAttribute("open","true");
		$(obj.getAttribute("childs")).setStyle("display","");
	}
}

function alreadyFncExists(idFnc){
	var exist = false;
	if (!exist){
		envContainer.getElements("li").each(function(item){
			if (item.getAttribute("id") == idFnc){ exist = true; }
		});
	}
	return exist;
}

function confirmDelete(){
	SYS_PANELS.newPanel();
	var panel = SYS_PANELS.getActive();
	panel.addClass("modalWarning");
	panel.content.innerHTML = CONFIRM_FNC_DELETE;
	panel.footer.innerHTML = "<div class='button' onClick=\"SYS_PANELS.closeAll(); deleteFol();\">" + GNR_NAV_ADM_DELETE + "</div>";
	SYS_PANELS.addClose(panel);
	SYS_PANELS.refresh();
}

function deleteFol(){
	folToRemove.getElements("li").each(function(item){ 
		if (item && item.getAttribute("fncType") != "F"){
			fncToRemove = item;
			deleteFnc();
		} 
	});
	folToRemove = null;
	
	checkEnviromentModifications(true);
}

function deleteFnc(){
	var fncId = fncToRemove.getAttribute("id").split("_")[1];
	while (fncToRemove){
		var toDestroy = fncToRemove;
		var father = $(fncToRemove.getAttribute("father"));
		if (father.getAttribute("id") != fncsContainer.getAttribute("id") && father.getElements("li").length == 1){
			fncToRemove = $(fncToRemove.getAttribute("fncFatherId"))
		} else {
			fncToRemove = null;
		}
		toDestroy.destroy();		
	}	
	
	fncToRemove = null;
	
	if (fncsContainer.getElements("li").length == 0){
		(new Element("span", {'id': 'noFncs', html: NO_FNCS_SEL})).inject(fncsContainer,"before");
	}
	
	var request = new Request({
		method: 'post',
		url: CONTEXT + URL_REQUEST_AJAX + '?action=removeFunctionality&isAjax=true&envId=' + envSelected + "&fncId=" + fncId + TAB_ID_REQUEST,
		onRequest: function() { SYS_PANELS.showLoading(); },
		onComplete: function(resText, resXml) { 
			modalProcessXml(resXml);
			
			checkEnviromentModifications(true);
		}
	}).send();
}

function cleanFunc(){
	var spFncs = new Spinner($('divFunctionalities'));
	spFncs.show(true);
	
	envSelected = null;
	spanFunc.innerHTML = FNCS;
	spanDash.innerHTML = DASH;
	
	addFnc.setStyle("visibility","hidden");
	fncsContainer.setStyle("visibility","hidden");
	
	//Borra las funcionalidades mostradas
	fncsContainer.getElements("ul").each(function(item){ item.destroy(); });
	fncsContainer.getElements("li").each(function(item){ item.destroy(); });
	if ($('noFncs')) { $('noFncs').destroy(); }
	
	spFncs.hide(true);
}

function cleanDash(){
	$('divDash').setStyle('display','');
	claerActionElements($('dashContainer'));
}

function processEnvsModalReturn(ret){
	ret.each(function(e){
		if (!alreadyEnvExists(e.getRowId())){
			createEnv(e.getRowId(),e.getRowContent()[0],false);
		}
	});	
}

function processDashModalReturn(ret){
	
	var selected = "";
	ret.each(function(e){
		if (selected != "") { selected += ";"; }
		selected += e.getRowId();
	});
	if (selected != ""){
		var request = new Request({
			method: 'post',
			url: CONTEXT + URL_REQUEST_AJAX + '?action=addDashboards&isAjax=true&envId=' + envSelected + '&dash=' + selected + TAB_ID_REQUEST,
			onRequest: function() { SYS_PANELS.showLoading(); },
			onComplete: function(resText, resXml) { 
				modalProcessXml(resXml);
				
				//Si se modifica algún nuevo dashboard, el ambiente queda marcado como modificado
				var modElements = dashContainer.getElements('*.highlighted');
				if (modElements.length>0){
					envContainerSelected.addClass('highlighted');
				}
				
				
			}
		}).send();
	}	
}

function alreadyEnvExists(elemId){
	var exists = false;
	envContainer.getElements("div").each(function(item){
		if (item.getAttribute("id") == elemId){ exists = true; }
	});
	return exists;
}

function getEnvToSend(){
	var valuesToSend = "";
	envContainer.getElements("div").each(function(item){
		if (item.getAttribute("id") != "addEnv" && item.getAttribute("name") != null){
			if (valuesToSend != ""){ valuesToSend += ";"; }
			valuesToSend += item.getAttribute("id");   
		}				
	});
	return valuesToSend;		
}

function processFncsModalReturn(ret){
	var selected = "";
	ret.each(function(e){
		if (selected != "") { selected += ";"; }
		selected += e;
	});
	if (selected != ""){
		var request = new Request({
			method: 'post',
			url: CONTEXT + URL_REQUEST_AJAX + '?action=addFunctionalities&isAjax=true&envId=' + envSelected + '&fncs=' + selected + TAB_ID_REQUEST,
			onRequest: function() { SYS_PANELS.showLoading(); },
			onComplete: function(resText, resXml) { 
				modalProcessXml(resXml);
				
				checkEnviromentModifications();
			}
		}).send();
	}
}

function getFncIdToExclude(){
	var exclude = "";
	$$("li").each(function(li){
		var id = li.getAttribute("id");
		var arrId = id.split("_");
		if (arrId.length == 2 && arrId[0] == "fnc"){
			if (exclude != "") exclude += ",";
			exclude += arrId[1];
		}
	});
	return exclude;
}

function checkEnviromentModifications(force){
	//Si se modifica alguna funcionalidad, el ambiente queda marcado como modificado
	if (force){
		envContainerSelected.addClass('highlighted');
		return;
	}
	
	var modElements = $('mdlTreeFncsContainer').getElements('*.highlighted');
	if (modElements.length>0){
		envContainerSelected.addClass('highlighted');
	}
}