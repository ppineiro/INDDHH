var mdlInformationBody;
var spMdlInformation;

var MDLINFO_MODAL_HIDE_OVERFLOW	= true;

function initMdlInformationPage(){
	var mdlInformationContainer = $('mdlInformationContainer');
	if (mdlInformationContainer.initDone) return;
	mdlInformationContainer.initDone = true;

	mdlInformationContainer.blockerModal = new Mask();
	
	mdlInformationBody = $('mdlInformationBody');
	spMdlInformation = new Spinner(mdlInformationBody,{message:WAIT_A_SECOND});
	
	$('closeMdlInformation').addEvent("click", function(e) {
		e.stop();
		closeMdlInformation();
	});		
}

function showMdlInformation(poolId,poolName){
	
	if(MDLINFO_MODAL_HIDE_OVERFLOW) {
		$(document.body).setStyle('overflow', 'hidden');
	}
	
	var mdlInformationContainer = $('mdlInformationContainer');
	mdlInformationContainer.position();
	mdlInformationContainer.blockerModal.show();
	mdlInformationContainer.setStyle('zIndex', SYS_PANELS.getNewZIndex());
	mdlInformationContainer.poolId = poolId;
	mdlInformationContainer.poolName = poolName;
	
	mdlInformationContainer.removeClass('hiddenModal');
	
	cleanTable($('tableEnvironments'));
	cleanTable($('tableUsers'));
	loadEnvironments(poolId);
	
	$('mdlTitle').innerHTML = LBL_INFO + " - " + poolName;			
}

function closeMdlInformation(){
    var mdlInformationContainer = $('mdlInformationContainer');
    
    if(Browser.chrome || Browser.firefox || Browser.safari) {
		var morph = new Fx.Morph(mdlInformationContainer, {duration: 200, wait: false});
		
		morph.start({
			'margin-top': '-10px',
			'opacity': 0
		}).chain(function() {
			
			mdlInformationContainer.addClass('hiddenModal');
			mdlInformationContainer.setStyles({
				'opacity': 1,
				'margin-top': ''
			}); //Limpiar la transicion
						
			mdlInformationContainer.blockerModal.hide();
			
			if(MDLINFO_MODAL_HIDE_OVERFLOW) {
				$(document.body).setStyle('overflow', '');
			}
		});
	} else {
		
		 mdlInformationContainer.addClass('hiddenModal');
		 mdlInformationContainer.blockerModal.hide();	
		
		if(MDLINFO_MODAL_HIDE_OVERFLOW) {
			$(document.body).setStyle('overflow', '');
		}
	}
    
   
}

function cleanTable(table){
	table.getElements("tr").each(function(tr){ tr.destroy(); });
	//addScrollTable(tableUsers);
	addScrollTable(table);
}

function loadEnvironments(poolId){
	var request = new Request({
		method: 'post',
		url: CONTEXT + URL_REQUEST_AJAX + '?action=loadEnvironments&isAjax=true&poolId=' + poolId + TAB_ID_REQUEST,
		onRequest: function() { spMdlInformation.show(true); },
		onComplete: function(resText, resXml) { processXmlEnvironments(resXml); spMdlInformation.hide(true); }
	}).send();
}

function processXmlEnvironments(resXml){
	var tableEnvironments = $('tableEnvironments');
		
	var environments = resXml.getElementsByTagName("environments");
	if (environments != null && environments.length > 0 && environments.item(0) != null) {
		environments = environments.item(0).getElementsByTagName("environment");
		
		for (var i = 0; i < environments.length; i++){
			var xmlEnv = environments[i];
			var envId = xmlEnv.getAttribute("id");
			var envName = xmlEnv.getAttribute("name");
			
			var tr = new Element("tr",{'class': 'selectableTR'}).inject(tableEnvironments);
			if (i % 2 != 0) { tr.addClass("trOdd"); }
			if (i == environments.length) { tr.addClass("lastTr"); }
			tr.setAttribute("rowId", envId);
			tr.getRowId = function () { return this.getAttribute("rowId"); }
			tr.addEvent("click", function(evt) { 
				cleanTable($('tableUsers'));
				if (this.hasClass("selectedTR")){
					this.removeClass("selectedTR");
				} else {
					$$('tr.selectedTR').removeClass('selectedTR');
					this.addClass("selectedTR");
					loadUsers(this.getRowId());
				}				 
			});	
			
			var td = new Element("td", {styles: {width: '95%', overflow: 'hidden', 'white-space': 'pre', 'margin': '4px 0px'}}).inject(tr);
			var div = new Element('div', {html: envName, styles: {width: '95%', overflow: 'hidden', 'white-space': 'pre', 'margin': '4px 0px'}}).inject(td);				
		}
	
		addScrollTable(tableEnvironments);
	}	
}

function loadUsers(envId){
	var poolId = $('mdlInformationContainer').poolId;
	var request = new Request({
		method: 'post',
		url: CONTEXT + URL_REQUEST_AJAX + '?action=loadUsers&isAjax=true&poolId=' + poolId + '&envId=' + envId + TAB_ID_REQUEST,
		onRequest: function() { SYS_PANELS.showLoading(); },
		onComplete: function(resText, resXml) { processXmlUsers(resXml); SYS_PANELS.closeActive(); }
	}).send();
}

function processXmlUsers(resXml){
	var users = resXml.getElementsByTagName("users");
	if (users != null && users.length > 0 && users.item(0) != null) {
		users = users.item(0).getElementsByTagName("user");
		
		var tableUsers = $('tableUsers');
		
		for (var i = 0; i < users.length; i++){
			var xmlUsr = users[i];
			var usrLogin = xmlUsr.getAttribute("id");
			var usrName = xmlUsr.getAttribute("name");
			
			var tr = new Element("tr",{}).inject(tableUsers);
			if (i % 2 != 0) { tr.addClass("trOdd"); }
			if (i == users.length) { tr.addClass("lastTr"); }
			tr.setAttribute("rowId", usrLogin);
			tr.getRowId = function () { return this.getAttribute("rowId"); }
						
			var td1 = new Element("td", {styles: {width: '49%', overflow: 'hidden', 'white-space': 'pre', 'margin': '4px 0px'}}).inject(tr);
			var div1 = new Element('div', {html: usrLogin, styles: {width: '49%', overflow: 'hidden', 'white-space': 'pre', 'margin': '4px 0px'}}).inject(td1);				
			
			var td2 = new Element("td", {styles: {width: '49%', overflow: 'hidden', 'white-space': 'pre', 'margin': '4px 0px'}}).inject(tr);
			var div2 = new Element('div', {html: usrName, styles: {width: '49%', overflow: 'hidden', 'white-space': 'pre', 'margin': '4px 0px'}}).inject(td2);
		}
		
		addScrollTable(tableUsers);
	}	
}
