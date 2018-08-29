/** Se pasa para initPage
window.onload=function(){
	if (BUS_CLA_ID!=''){	
		showType(TYPE_SELECTED);				
	}else{
		var aux = $('busType');
		showType(TYPE_DB);		
	}
}
*/

var Scroller;

function clearValidations(){
	if($('frmData').formChecker) {
		disposeValidation($('txtExeJava'));
		disposeValidation($('txtExeScript'));
		disposeValidation($('txtUrl'));
		disposeValidation($('txtExeQuery'));		
		disposeValidation($('txtRulePath'));
		disposeValidation($('txtRuleInput'));
		disposeValidation($('txtRuleOutput'));
		disposeValidation($('connectionsCombo'));
		disposeValidation($('connectionViews'));
		disposeValidation($('connectionProc'));
	}
}

function clearGrid(){
	if ($('tableDataParams')){
		var table = $('tableDataParams');
		var i =table.rows.length-1;
		while (i>=0){
			var row = table.rows[i];
			disposeValidation(row);
			row.dispose();
			i--;
		}		
	}
}

function showType(t){
	hideAll();
	clearValidations();
	clearGrid();
	var isDB = false;
	var isC = false;
	var loadPar = false;
	if (t==TYPE_DB){
		$("divConn").style.display='';
		$("divB").style.display='';
		registerValidation($('connectionsCombo'));
		populateCombo();			
		isDB = true;
		
		$('panelShortcuts').setStyle('display', 'none');
		
	}else if (t==TYPE_DB_PROC){
		$("divConn").style.display='';
		$("divD").style.display='';
		registerValidation($('connectionsCombo'));
		populateCombo();
		isDB = true;
		
		$('panelShortcuts').setStyle('display', 'none');
		
	}else if (t==TYPE_JAV){
		$("divP").style.display='';
		$("btnTest").style.display='';
		$("optionUpload").style.display='';
		$("panelOptions").style.display='';		
		registerValidation($('txtExeJava'));
		loadPar=true;
		
		$('panelShortcuts').setStyle('display', 'none');
		
	}else if (t==TYPE_SCR){
		$("divT").style.display='';
		registerValidation($('txtExeScript'));
		loadPar=true;
		
		//Refrescar el editor
		if(editor) {
			editor.refresh();
		}
		
		$('panelShortcuts').setStyle('display', '');
		
	}else if (t==TYPE_WS_SOA){
		$("divC").style.display='';			
		registerValidation($('txtUrl'));
		if (BUS_CLA_ID!=''){
			$("divWSOpeName").style.display='';
			if (SEL_WS_METHOD!=''){
				$("btnAct").style.display='';	
				$("panelOptions").style.display='';
			} else {
				$('panelOptions').style.display = 'none';
			}
			loadPar=true;
		}else{
			$('btnExplore').style.display='';
			$('divCmbMethod').style.display='';
			$("panelOptions").style.display='';
			
			
			$('divCmbMethod').addClass("required");
			if (!$('cmbMetName').hasClass("validate['required']")){
				$('cmbMetName').addClass("validate['required']");
			}
			registerValidation($('cmbMetName'));			
		}			
		isC = true;
		
		$('panelShortcuts').setStyle('display', 'none');
		
	}else if (t==TYPE_QRY_FIL){
		$("divF").style.display='';
		$("btnTestQuery").style.display='';
		$("optionUpload").style.display='';
		$("panelOptions").style.display='';		
		registerValidation($('txtExeQuery'));	
		
		$('panelShortcuts').setStyle('display', 'none');
		
	}else{
		$("divR").style.display='';
		registerValidation($('txtRulePath'));
		registerValidation($('txtRuleInput'));		
		registerValidation($('txtRuleOutput'));	
		$("btnTestBR").style.display='';		
		$("panelOptions").style.display='';		
		loadPar=true;
		
		$('panelShortcuts').setStyle('display', 'none');
		
	}
	if (t!=TYPE_QRY_FIL){
		if (!isC){
			$("trHNC").style.display='';
			$("trHNC").addClass('header');
			$("trHC").removeClass('header');
			$("trBNC").style.display='';
			$("trBNC").addClass('header');
			$("trBC").removeClass('header');
			if (!isDB){
				$("gridFooter").style.display='';		
			}
		}else{
			$("trHC").style.display='';
			$("trHC").addClass('header');
			$("trHNC").removeClass('header');
			$("trBC").style.display='';
			$("trBC").addClass('header');
			$("trBNC").removeClass('header');
		}
		$("tabParam").style.display='';
	}else{
		$("tabParam").style.display='none';
	}
	if (loadPar){
		if (BUS_CLA_ID!=''){
			loadParams();
		} else {
			clearParams();
		}
	}
	
	if (t != TYPE_WS_SOA && $('divCmbMethod').hasClass("required")){
		$('divCmbMethod').removeClass("required");
		if ($('cmbMetName').hasClass("validate['required']")){
			$('cmbMetName').removeClass("validate['required']");
		}
		disposeValidation($('cmbMetName'));				
	}
	
	TYPE_SELECTED = t;
	
	clearParams();
	
}

var divs = new Array();
divs.push("divConn");
divs.push("divB");//1
divs.push("divD");
divs.push("divP");//3
divs.push("divT");
divs.push("divC");//5
divs.push("divF");
divs.push("divR");//7
divs.push("trHNC");
divs.push("trHC");//9
divs.push("trBNC");
divs.push("trBC");//11
divs.push("gridFooter");
divs.push("divWSOpeName");//13
divs.push("panelOptions");
divs.push("btnAct");//15
divs.push("btnExplore");
divs.push("optionUpload");//17
divs.push("btnTest");
divs.push("btnTestBR");
divs.push("btnTestQuery");




function hideAll(){
	for (var i=0;i<divs.length;i++){
		$(divs[i]).style.display='none';
	}
}

function clearParams(){
	var object =  $('tableDataParams');
	
	var newBody = new Element("tbody");
	newBody.id = object.id;
	newBody.addClass("tableData");
	var parent = object.parentNode;
	object.dispose();
	newBody.inject(parent);
	object = newBody;
}

function loadParams(){
	var v = "";
	if (TYPE_SELECTED!=''){
		if (TYPE_SELECTED==TYPE_DB){
			v = getComboValue($('connectionViews'));
		}else if(TYPE_SELECTED==TYPE_DB_PROC){
			v = getComboValue($('connectionProc'));
		}
	}else{
		var w = $('busType').options[$('busType').selectedIndex].value;
		if (w==TYPE_DB){
			v = getComboValue($('connectionViews'));
		}else if (w == TYPE_DB_PROC){
			v = getComboValue($('connectionProc'));
		}
	}
	if (v!=null || (TYPE_SELECTED!=TYPE_DB && TYPE_SELECTED!=TYPE_DB_PROC)){
		var request = new Request({
			method: 'post',
			data:{
					type:TYPE_SELECTED!=''?TYPE_SELECTED:$('busType').options[$('busType').selectedIndex].value,
					connId:getComboValue($('connectionsCombo')),
					view: v
				 },
			url: CONTEXT + URL_REQUEST_AJAX+'?action=loadParams&isAjax=true&' + TAB_ID_REQUEST,
			onRequest: function() { SYS_PANELS.showLoading(); },
			onComplete: function(resText, resXml) { loadTableParams(resXml); }
		}).send();
	}
}

function getComboValue(obj){
	var a;
	try{
		a = obj.options[obj.selectedIndex].value;
	}catch(e){
		a=null;
	}
	return a
}

var editor;
var server;

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
	
	if(JS_EXECUTABLE != "")
		$('txtExeScript').set('value', JS_EXECUTABLE.substring(currentEnvironment.length + 1));
	
	var btnTest = $('btnTest');
	if (btnTest){
		btnTest.addEvent("click", function(e) {
			e.stop();
			
			var form = $('frmData');
			if(!form.formChecker.isFormValid()){
				return;
			}
			if ($('txtExeJava').value!=""){
				var request = new Request({
					method: 'post',
					data:{type:(BUS_CLA_ID!=''?TYPE_SELECTED:$('busType').options[$('busType').selectedIndex].value),txtName:BUS_CLA_NAME,txtExe:$('txtExeJava').value},
					url: CONTEXT + URL_REQUEST_AJAX + '?action=test&isAjax=true' + TAB_ID_REQUEST,
					onRequest: function() { SYS_PANELS.showLoading(); },
					onComplete: function(resText, resXml) { modalProcessXml(resXml); }
				}).send();
			}
		});
	}
	
	var btnTestQuery = $('btnTestQuery');
	if (btnTestQuery){
		btnTestQuery.addEvent("click", function(e) {
			e.stop();
			
			var form = $('frmData');
			if(!form.formChecker.isFormValid()){
				return;
			}
			if ($('txtExeQuery').value!=""){
				var request = new Request({
					method: 'post',
					data:{type:(BUS_CLA_ID!=''?TYPE_SELECTED:$('busType').options[$('busType').selectedIndex].value),txtName:BUS_CLA_NAME,txtExe:$('txtExeQuery').value},
					url: CONTEXT + URL_REQUEST_AJAX + '?action=test&isAjax=true' + TAB_ID_REQUEST,
					onRequest: function() { SYS_PANELS.showLoading(); },
					onComplete: function(resText, resXml) { modalProcessXml(resXml); }
				}).send();
			}
		});
	}
	
	var btnTestBR = $('btnTestBR');
	if (btnTestBR){
		btnTestBR.addEvent("click", function(e) {
			e.stop();
			
			var form = $('frmData');
			if(!form.formChecker.isFormValid()){
				return;
			}
			var request = new Request({
				method: 'post',
				data:{type:(BUS_CLA_ID!=''?TYPE_SELECTED:$('busType').options[$('busType').selectedIndex].value),txtName:$('bcName').value,txtRulePath:$('txtRulePath').value,txtRuleInput:$('txtRuleInput').value,txtRuleOutput:$('txtRuleOutput').value,cmbRuleEngine:$('cmbRuleEngine').value},
				url: CONTEXT + URL_REQUEST_AJAX + '?action=test&isAjax=true' + TAB_ID_REQUEST,
				onRequest: function() { SYS_PANELS.showLoading(); },
				onComplete: function(resText, resXml) { modalProcessXml(resXml); }
			}).send();
			
		});
	}
	
	var chkPubWs = $('chkPubWs');
	if (chkPubWs){
		chkPubWs.addEvent("click", function(e) {
			if($("chkPubWs").checked){
				$("txtWsName").disabled = false;
				registerValidation($('txtWsName'));				
				$("txtWsName").className = "";
			}else{
				$("txtWsName").disabled = true;
				$("txtWsName").value ="";
				disposeValidation($('txtWsName'));
				$("txtWsName").className = "txtReadOnly";
			}
			
			var checked = $("chkPubWs").checked; 
			fixChkMul(!checked);
			fixChkDateTime(!checked);
		});
	}

	var optionUpload = $('optionUpload');
	if (optionUpload){
		optionUpload.addEvent("click", function(e) {
			e.stop();
			upload();	
		});
	}	
	
	var btnConf = $('btnConf');
	if (btnConf){
		btnConf.addEvent("click", function(e) {
			e.stop();
			
			$('txtJS').set('value', editor.getValue());
			
			var form = $('frmData');
			if(!form.formChecker.isFormValid()){
				return;
			}
			
			if(!verifyPermissions()){
				return;
			}
			
			var params = getFormParametersToSend(form);
			
			var request = new Request({
				method: 'post',
				url: CONTEXT + URL_REQUEST_AJAX + '?action=confirm&isAjax=true' + TAB_ID_REQUEST,
				onRequest: function() { SYS_PANELS.showLoading(); },
				onComplete: function(resText, resXml) { modalProcessXml(resXml); }
			}).send(params);
			
		});
	}
	
	$('btnBackToList').addEvent("click", function(e) {
		e.stop();
		
		var btnConf = $('btnConf');
		if (btnConf){
			SYS_PANELS.newPanel();
			var panel = SYS_PANELS.getActive();
			panel.addClass("modalWarning");
			panel.content.innerHTML = GNR_PER_DAT_ING;
			panel.footer.innerHTML = "<div class='button' onClick=\"SYS_PANELS.closeAll(); clickGoBack();\">" + BTN_CONFIRM + "</div>";
			SYS_PANELS.addClose(panel);
			SYS_PANELS.refresh();
		} else {
			clickGoBack();
		}
	});
	
	
	var btnUp = $('btnUp');
	if (btnUp){
		btnUp.addEvent("click", function(e) {
			e.stop();
			if(selectionCount($('tableDataParams')) == 0) {
				showMessage(GNR_CHK_AT_LEAST_ONE, GNR_TIT_WARNING, 'modalWarning');
			} else {
				var pos = getSelectedRows($('tableDataParams'))[0].getRowId();
				upRow(parseInt(pos));
			}
			
		});
	}
	
	var btnDown = $('btnDown');
	if (btnDown){
		btnDown.addEvent("click", function(e) {
			e.stop();
			if(selectionCount($('tableDataParams')) == 0) {
				showMessage(GNR_CHK_AT_LEAST_ONE, GNR_TIT_WARNING, 'modalWarning');
			} else {
				var pos = getSelectedRows($('tableDataParams'))[0].getRowId();
				downRow(parseInt(pos));
			}
		});
	}
	
	var btnAdd = $('btnAdd');
	if (btnAdd){
		btnAdd.addEvent("click", function(e) {
			e.stop();
			addRow();
		});
	}
	
	var btnDelete = $('btnDelete');
	if (btnDelete){
		btnDelete.addEvent("click", function(e) {
			e.stop();
			if(selectionCount($('tableDataParams')) == 0) {
				showMessage(GNR_CHK_AT_LEAST_ONE, GNR_TIT_WARNING, 'modalWarning');
			} else {
				var pos = getSelectedRows($('tableDataParams'))[0].getRowId();
				deleteRow(parseInt(pos));
			}			
		});
	}
	
	var btnExplore = $('btnExplore');
	if (btnExplore){
		btnExplore.addEvent("click", function(e) {
			if (e) e.stop();
			if (!toBoolean(btnExplore.getAttribute("disabled"))){
				btnExploreWsdl_click();	
			}						
		});
	}
	
	var btnAct = $('btnAct');
	if (btnAct){
		btnAct.addEvent("click", function(e) {
			if (e) e.stop();
			btnActWsdl_click();
		});
	}
	
	var tabParam = $('tabParam');
	if (tabParam){
		tabParam.addEvent('focus',function (evt){
			addScrollTableParams();
		})
	}
	/*
	var datGen = $('datGen');
	if (datGen){
		datGen.addEvent('focus',function (evt){
			getURL(ECMA_URL, function(err, code) {
				if (err) throw new Error("Request for ecma5.json: " + err);
				server = new CodeMirror.TernServer({defs: [JSON.parse(code)]});
				editor.setOption("extraKeys", {
					"Ctrl-Space": function(cm) { server.complete(cm); },
					"Ctrl-I": function(cm) { server.showType(cm); },
					"Alt-.": function(cm) { server.jumpToDef(cm); },
					"Alt-,": function(cm) { server.jumpBack(cm); }//,
					//"Ctrl-R": function(cm) { server.rename(cm); },
				})
				editor.on("cursorActivity", function(cm) { server.updateArgHints(cm); });
			}); 
		})
	}
	*/
	
	
	initPermissions();	
	if (btnConf) { btnConf.style.display = ''; }
	$('btnBackToList').style.display = '';
	$('divAdminActEdit').style.display = '';

	
	if (!MODE_CREATE){
		$('txtUrl').addEvent('change',function(e){
			if (e) e.stop();
			$('btnAct').fireEvent("click");
		});		
	}
	
	initAdminFieldOnChangeHighlight(false, false);
	
	if (BUS_CLA_ID!=''){	
		showType(TYPE_SELECTED);				
	}else{
		var aux = $('busType');
		showType(TYPE_DB);		
	}
	
	/*
	CodeMirror.commands.autocomplete = function(cm) {
		CodeMirror.showHint(cm, CodeMirror.hint.apia);
	};
	*/ 
	editor = CodeMirror.fromTextArea(document.getElementById("txtJS"), {
		lineNumbers: true,
		matchBrackets: true,
		continueComments: "Enter",
		extraKeys: {"Ctrl-Q": "toggleComment"/*"Ctrl-Q": "toggleComment", "Ctrl-Space": "autocomplete"*/},
		theme: "eclipse"
	});
	
	getURL(ECMA_URL, function(err, code) {
		if (err) throw new Error("Request for ecma5.json: " + err);
		server = new CodeMirror.TernServer({defs: [JSON.parse(code)]});
		editor.setOption("extraKeys", {
			"Ctrl-Space": function(cm) { server.complete(cm); },
			"Ctrl-I": function(cm) { server.showType(cm); },
			"Alt-.": function(cm) { server.jumpToDef(cm); },
			"Alt-,": function(cm) { server.jumpBack(cm); }/*,
			"Ctrl-R": function(cm) { server.rename(cm); },*/
		})
		editor.on("cursorActivity", function(cm) { server.updateArgHints(cm); });
	});
}

function getURL(url, c) {
	var xhr = new XMLHttpRequest();
	xhr.open("get", url, true);
	xhr.send();
	xhr.onreadystatechange = function() {
	if (xhr.readyState != 4) return;
	if (xhr.status < 400) return c(null, xhr.responseText);
	var e = new Error(xhr.responseText || "No response");
	e.status = xhr.status;
	c(e);
	};
}	

function addScrollTableParams(){
	var table = $('tableDataParams');
	var trs = table.getElements("tr");
	if (trs.length > 0){
		for (var i = 0; i < trs.length; i++){
			var tr = trs[i];
			if (i == trs.length-1){
				tr.addClass("lastTr");
			} else {
				tr.removeClass("lastTr");
			}
		}
	}
	Scroller = addScrollTable(table);
}

function upload(){
	hideMessage();
	var request = new Request({
		method: 'post',
		url: CONTEXT + URL_REQUEST_AJAX+'?action=ajaxUploadStart&isAjax=true&' + TAB_ID_REQUEST,
		onRequest: function() { SYS_PANELS.showLoading(); },
		onComplete: function(resText, resXml) { modalProcessXml(resXml); }
	}).send();
}

function enableExplore(){
	if($("txtUrl").value!=""){
		$("btnExplore").setAttribute("disabled",false)
		
		if (MODE_CREATE){
			$("btnExplore").fireEvent("click");
		} 
	}else{
		$("btnExplore").setAttribute("disabled",true);
		
		if (MODE_CREATE) {
			for (var i = $('cmbMetName').options.length-1; i > 0; i--){
				$('cmbMetName').options[i].dispose();
			}
			$('cmbMetName').selectedIndex = 0;			
		}
	}
}

function btnExploreWsdl_click(){
	if (MODE_CREATE){
		disposeValidation($('cmbMetName'));
		var request = new Request({
			method: 'post',
			data: {txtUrl:$('txtUrl').value,chkBasicAuth:($('chkBasicAuth').checked?"on":""),txtAuthUsr:$('txtAuthUsr').value,txtAuthPwd:$('txtAuthPwd').value},
			url: CONTEXT + URL_REQUEST_AJAX+'?action=exploreWsdl&isAjax=true&' + TAB_ID_REQUEST,
			onRequest: function() { SYS_PANELS.showLoading(); },
			onComplete: function(resText, resXml) { loadMethodsCombo(resXml); }
		}).send();
	}
}


function loadMethodsCombo(xml){
	var toLoad = xml.getElementsByTagName("load").item(0);
	if(toLoad!=null){
		var theForm = toLoad.getElementsByTagName("form").item(0);
		if (theForm!=null){
			var theElements = theForm.getElementsByTagName("elements");
			var formElements = processModalXmlFormElements(theElements, false);
			var htmlForm = formElements; 
			$('divMethods').innerHTML=htmlForm;	
			
			registerValidation($('cmbMetName'));
			$('cmbMetName').setStyle("width","150px");
		}
		SYS_PANELS.closeActive();
	}
	if (xml.getElementsByTagName("sysExceptions").length != 0) {
		processXmlExceptions(xml.getElementsByTagName("sysExceptions").item(0), true);
	}
	
	if (xml.getElementsByTagName("sysMessages").length != 0) {
		processXmlMessages(xml.getElementsByTagName("sysMessages").item(0), true);
	}
}


function btnActWsdl_click(){	
	var request = new Request({
		method: 'post',
		data:{txtExe:$('WSMethodName').value,txtUrl:$('txtUrl').value,txtAuthUsr:$('txtAuthUsr').value,txtAuthPwd:$('txtAuthPwd').value},
		url: CONTEXT + URL_REQUEST_AJAX+'?action=refreshWsdl&isAjax=true&' + TAB_ID_REQUEST,
		onRequest: function() { SYS_PANELS.showLoading(); },
		onComplete: function(resText, resXml) { loadTableParams(resXml); }
	}).send();	
}

//Carga Parametros con el metodo seleccionado
function cmbMetName_change(){
	var cmb=$("cmbMetName");
	if (cmb.selectedIndex!=0){
		$('WSMethodName').value = cmb.options[cmb.selectedIndex].value;
		var request = new Request({
			method: 'post',
			data:{txtExe:cmb.options[cmb.selectedIndex].value,txtUrl:$('txtUrl').value,txtAuthUsr:$('txtAuthUsr').value,txtAuthPwd:$('txtAuthPwd').value},
			url: CONTEXT + URL_REQUEST_AJAX+'?action=loadWSParams&isAjax=true&' + TAB_ID_REQUEST,
			onRequest: function() { SYS_PANELS.showLoading(); },
			onComplete: function(resText, resXml) { loadTableParams(resXml); }
		}).send();
	} else {
		clearParams();
	}		
}

function changeWssUT(){
	var usr = $("txtWssUTUsr");
	var pwd = $("txtWssUTPwd");
	
	usr.disabled = ! $("chkWssUT").checked;
	pwd.disabled = ! $("chkWssUT").checked;
	
 
}

function changeAuthBasic(){
	var usr = $("txtAuthUsr");
	var pwd = $("txtAuthPwd");

	usr.disabled = ! $("chkBasicAuth").checked;
	pwd.disabled = ! $("chkBasicAuth").checked;
 
}		

function changeWsAddressing(){
	$("txtWsAddTo").disabled = ! $("chkWsAddressing").checked
	$("txtWsAddAction").disabled = ! $("chkWsAddressing").checked
}

function changechkWsSTS(){
	$("txtWsSTSUrl").disabled = ! $("chkWsSTS").checked;
	$("txtWsSTSIssuer").disabled = ! $("chkWsSTS").checked;
	$("txtWsSTSPolicy").disabled = ! $("chkWsSTS").checked;
	$("txtWsSTSRole").disabled = ! $("chkWsSTS").checked;
	$("txtWsSTSUserName").disabled = ! $("chkWsSTS").checked;
	$("txtWsSTSService").disabled = ! $("chkWsSTS").checked;
	$("txtWsSTSAlias").disabled = ! $("chkWsSTS").checked;
	$("txtWsSTSKSPath").disabled = ! $("chkWsSTS").checked;
	$("txtWsSTSKSPwd").disabled = ! $("chkWsSTS").checked;
	$("txtWsSTSTSPath").disabled = ! $("chkWsSTS").checked;
	$("txtWsSTSTSPwd").disabled = ! $("chkWsSTS").checked;
}

function registerValidation(obj){
	if (obj.id=="bcName"){
		obj.className="validate['required','~validName']";
	}else{
		obj.className="validate['required']";
	}
	$('frmData').formChecker.register(obj);
}

function disposeValidation(obj){
	$('frmData').formChecker.dispose(obj);
}

function loadTableParams(ajaxXml){
	var tables = ajaxXml.getElementsByTagName("table");
	if (tables==null || tables.length==0){
		var m = ajaxXml.getElementsByTagName("message");
		if (m!=null && m.length!=0){
			SYS_PANELS.closeActive();
			processXmlMessages(ajaxXml,true);
		}else{
			SYS_PANELS.closeActive();
		}
		
		clearParams();
		return;
	}
	var object =  $('tableDataParams');
	var selectOnlyOne = true;
	
	var newBody = new Element("tbody");
	newBody.id = object.id;
	newBody.addClass("tableData");
	//var parent = object.parentNode;
	var parent = object.getParent();
	object.dispose();
	newBody.inject(parent);
	object = newBody;
	object.selectOnlyOne = selectOnlyOne;
	
	var thead = parent.getFirst("thead");
	var theadTr = thead ? thead.getFirst("tr") : null;
	if (!theadTr.hasClass("header")){
		theadTr = thead ? thead.rows.item(1) : null;
	}
	
	var headers = theadTr ? theadTr.getElements("th") : null;
	var tdWidths = headers ? new Array(headers.length) : null;
	
	if (headers) {
		for (var i = 0; i < headers.length; i++) {
			var div = headers[i].getElement('div');
			if (! div) continue;
			tdWidths[i] = div.style.width;
			if (! tdWidths[i]) tdWidths[i] = div.width;
			if (! tdWidths[i]) tdWidths[i] = div.getAttribute("width");
		}
	}

	var table = tables.item(0);
	var hiddenTable = tables.item(1);
	if (table != null) {
		var rows = table.getElementsByTagName("row");		
		var rowsHidden = hiddenTable.getElementsByTagName("row");
		for(var i = 0; i < rows.length; i++) {
			var row = rows.item(i);
			var id = row.getAttribute("id");
			var classToAdd = row.getAttribute("classToAdd");

			var unselectableTR = row.getAttribute("unselectableTR");
			var tr = null;
			if (!unselectableTR){				
				tr = new Element('tr', {'class': 'selectableTR'});
			}else{
				tr = new Element('tr', null);
			}
			if(i%2==0) tr.addClass("trOdd");
			if (classToAdd) tr.className += " " + classToAdd;
			if (id != null && id != null) tr.setAttribute("rowId", id);
			
			tr.getRowId = function () { return this.getAttribute("rowId"); };
			tr.setRowId = function (a) { this.setAttribute("rowId",a); };
			tr.inject(object);
			
			//Agregado para que individualmente se pueda especificar una fila sin additional info
			var addInfo = true;
			if (row.getAttribute("additional_info_in_table_data")=="false"){
				addInfo = false;
			}
			
			var cells = row.getElementsByTagName("cell");
			for(var j = 0; j < cells.length; j++) {
				var cell = cells.item(j);
				var tdClassToAdd = cell.getAttribute("classToAdd");
				var isCombo = toBoolean(cell.getAttribute("isCombo"));
				var isInput = toBoolean(cell.getAttribute("isInput"));
				var isCheckbox = toBoolean(cell.getAttribute("isCheckbox"));
				var isHidden = toBoolean(cell.getAttribute("isHidden"));
				var content = cell.firstChild ? cell.firstChild.nodeValue : "";
				
				var additionalInfo = null;
				
				var td = new Element('td',{'align':'center'});
				td.setProperty('style','width:'+tdWidths[j]);
				//crear el TD
				if (isCombo){
					var data = cell.getElementsByTagName("data");
					var elements = data.item(0).firstChild;
					var opts = elements.firstChild;
					var selectedValue = elements.getAttribute("value");
					
					var selector = new Element('select', {styles: {width: '100%'}});
					selector.setProperty('id',elements.getAttribute("id"));
					selector.setProperty('name',elements.getAttribute("id"));
					
					var options = opts.getElementsByTagName("option");
					for (var k = 0; k < options.length; k++) {
						var optionDOM = new Element('option');
						var option = options.item(k);
						
						var value = option.getAttribute("value");
						var text = (option.firstChild != null)?option.firstChild.nodeValue:""; 
						
						optionDOM.setProperty('value',value);
						optionDOM.appendText(text);
						
						if (selectedValue!="" && selectedValue == value || selectedValue=="" && k==0){
							optionDOM.setProperty('selected','selected');
						}
						optionDOM.inject(selector);
					
					}
					
					if (elements.getAttribute("id") == "cmbParType"){
						selector.addEvent("change",function(e){
							e.stop();
							var value = this.value;
							var tr = this.getParent("tr");
							var chkDateTime = tr.getElements("td")[5].getElement("input");
							if (value != "D"){
								chkDateTime.checked = false;
								onChangeChkDatetime(chkDateTime);
								chkDateTime.disabled = true;
							} else if ($('chkPubWs').checked && (($('busType') && $('busType').value == "P") || TYPE_SELECTED == TYPE_JAV)){
								chkDateTime.disabled = false;
							}
						});
					}
					
					if (tdClassToAdd) td.addClass(tdClassToAdd);
					var div = new Element('div');
					selector.inject(div);
					div.inject(td);
										
				}else if (isInput){
					var aux = cell.getElementsByTagName("input");
					var data = aux.item(0);
					var value = data.getAttribute("value");
					var onBlur = data.getAttribute("onblur");
					var id = data.getAttribute("id");
					var name = data.getAttribute("name");
					
					var inputDOM = new Element('input', {'id': id, 'name': name, styles: {width: '93%'}});
					if (value!="null"){
						inputDOM.setProperty("value",value);
					}
					if (onblur!=null){
						inputDOM.setProperty("onblur",onblur);
					}
					inputDOM.setProperty('type','text');
					if (tdClassToAdd){
						if (tdClassToAdd=="validate['required','~validName']"){
							registerValidation(inputDOM);
						}
						inputDOM.addClass(tdClassToAdd);
					}
					var div = new Element('div');
					div.inject(td);
					inputDOM.inject(div);
					if (tdClassToAdd=="validate['required','~validName']"){
						new Element("span",{html:"&nbsp;*", styles:{'float':'left'}}).inject(div);
					}
					
				}else if (isCheckbox){
					var aux = cell.getElementsByTagName("input");
					var data = aux.item(0);
					var checked = toBoolean(data.getAttribute("checked"));
					var name = data.getAttribute("name");
					var forceReadOnly = toBoolean(data.getAttribute("forceReadOnly"));
					
					if (name == 'chkMul'){
						var inputDOM = new Element('input', {'align': 'center', 'name': 'chkMul'});
						inputDOM.setProperty('type','checkbox');
						inputDOM.checked = checked;
						inputDOM.disabled = forceReadOnly || !((($('busType') && $('busType').value == "P") || TYPE_SELECTED == TYPE_JAV) && $('chkPubWs').checked);
						inputDOM.forceReadOnly = forceReadOnly;
						inputDOM.addEvent("click",function(){ onChangeChkMul(this); });
						var inputHidden = new Element('input',{'type':'hidden','value':checked?'true':'false','name':'txtChkMul'});
						inputDOM.inputHidden = inputHidden;
						
						var div = new Element('div');
						div.inject(td);
						inputDOM.inject(div);
						inputHidden.inject(div);
					} else if (name == 'chkDatetime'){
						var enable = toBoolean(data.getAttribute("enable"));
						var inputDOM = new Element('input', {'align': 'center', 'name': 'chkDatetime'});
						inputDOM.setProperty('type','checkbox');
						inputDOM.checked = checked;
						inputDOM.disabled = forceReadOnly || !((($('busType') && $('busType').value == "P") || TYPE_SELECTED == TYPE_JAV) && $('chkPubWs').checked && enable);
						inputDOM.forceReadOnly = forceReadOnly;
						inputDOM.addEvent("click",function(){ onChangeChkDatetime(this); });
						var inputHidden = new Element('input',{'type':'hidden','value':checked?'true':'false','name':'txtChkDatetime'});
						inputDOM.inputHidden = inputHidden;
						
						var div = new Element('div');
						div.inject(td);
						inputDOM.inject(div);
						inputHidden.inject(div);
					}
					
				}else{
					if (tdWidths) {
						var td = new Element('td', {styles: {width: tdWidths[j]}});
						var div = new Element('div');
						if (additionalInfo) additionalInfo.inject(div);
						new Element('span', {html: content}).inject(div);
						div.inject(td);						
						
						if (div.scrollWidth > div.offsetWidth) {
							td.title = content;
							td.addClass("titiled");
						}
						if (tdClassToAdd) td.addClass(tdClassToAdd);
					} else {
						var td = new Element('td', {html: content});
						var tdClassToAdd = cell.getAttribute("classToAdd");
						if (tdClassToAdd) td.addClass(tdClassToAdd);					
					}
				}
				if (j==0){
					td = processHiddenCells(td,rowsHidden,i);
				}
				td.inject(tr);	
			}		
		}
		
		initTable(object);			
	}

	
	SYS_PANELS.closeActive();
	
	
	var chkPubWs = $('chkPubWs');
	if (chkPubWs){
		chkPubWs.fireEvent("click");
	}
}

function processHiddenCells(td,rows,i){
	var row = rows.item(i);
	var cells = row.getElementsByTagName("cell");
	for(var k = 0; k < cells.length; k++) {
		var cell = cells.item(k);
		var aux = cell.getElementsByTagName("input");
		var data = aux.item(0);
		var value = data.getAttribute("value");
		var id = data.getAttribute("id");
		var name = data.getAttribute("name");
		var inputDOM = new Element('input');
		
		inputDOM.setProperty("id",id);
		inputDOM.setProperty("name",name);
		inputDOM.setProperty("value",value);
		inputDOM.setProperty('type','hidden');	
		inputDOM.inject(td);
	}
	return td;
}

function addRow() {
	var table = $('tableDataParams');	
	table.selectOnlyOne = true;
	var headers = $('trBNC').getElements('th');
	var tdWidths = headers ? new Array(headers.length) : null;
	
	if (headers) {
		for (var i = 0; i < headers.length; i++) {
			var div = headers[i].getElement('div');
			if (! div) continue;
			tdWidths[i] = div.style.width;
			if (! tdWidths[i]) tdWidths[i] = div.width;
			if (! tdWidths[i]) tdWidths[i] = div.getAttribute("width");
		}
	}
	
	var tdName = new Element("td", {'align':'center', styles: {width: tdWidths[0]}});
	var divName = new Element("div");
	divName.inject(tdName);
	var inputName = new Element("input");
	inputName.setProperty("name","txtParName");
	inputName.setProperty('type','text');		
	inputName.setProperty('style','width:93%');
	inputName.addClass("validate['required','~validName']");
	registerValidation(inputName);	
	inputName.inject(divName);
	new Element("span",{html:"&nbsp;*", styles:{'float':'left'}}).inject(divName);
	
	var input = new Element("input");
	input.setProperty("name","txtInOutReadOnly");
	input.setProperty('type','hidden');	
	input.setProperty('value','false');
	input.inject(tdName);
	
	input = new Element("input");
	input.setProperty("name","txtHasBinding");
	input.setProperty('type','hidden');	
	input.setProperty('value','false');
	input.inject(tdName);
	
	input = new Element("input");
	input.setProperty("name","txtParReadOnly");
	input.setProperty('type','hidden');	
	input.setProperty('value','false');
	input.inject(tdName);
	
	input = new Element("input");
	input.setProperty("name","txtParId");
	input.setProperty('type','hidden');	
	input.inject(tdName);
	
	input = new Element("input");
	input.setProperty("name","txtParSize");
	input.setProperty('type','hidden');	
	input.inject(tdName);
			
	var tdDesc = new Element("td", {'align':'center', styles: {width: tdWidths[1]}});
	var divDesc = new Element("div");
	divDesc.inject(tdDesc);
	var inputDesc = new Element("input");
	inputDesc.setProperty("name","txtParDesc");
	inputDesc.setProperty('type','text');	
	inputDesc.setProperty('style','width:95%');
	inputDesc.inject(divDesc);
	
	var tdType = new Element("td", {styles: {width: tdWidths[2]}});
	var divType = new Element("div");
	divType.inject(tdType);
	var selectType = new Element('select', {styles: {width: '100%'}});
	selectType.setProperty('name',"cmbParType");
	
	selectType.addEvent("change",function(e){
		e.stop();
		var value = this.value;
		var tr = this.getParent("tr");
		var chkDateTime = tr.getElements("td")[5].getElement("input");
		if (value != "D"){
			chkDateTime.checked = false;
			onChangeChkDatetime(chkDateTime);
			chkDateTime.disabled = true;
		} else if ($('chkPubWs').checked && (($('busType') && $('busType').value == "P") || TYPE_SELECTED == TYPE_JAV)){
			chkDateTime.disabled = false;
		}
	});
	
	var option = new Element('option');
	option.setProperty('value',"N");
	option.appendText(LBL_NUMERIC);
	option.inject(selectType);
	
	option = new Element('option');
	option.setProperty('value',"S");
	option.appendText(LBL_STRING);
	option.inject(selectType);
	
	option = new Element('option');
	option.setProperty('value',"D");
	option.appendText(LBL_DATE);
	option.inject(selectType);
	
	option = new Element('option');
	option.setProperty('value',"I");
	option.appendText(LBL_INT);
	option.inject(selectType);
		
	selectType.inject(divType);
	
	if (TYPE_SELECTED == null || TYPE_SELECTED == ""){
		TYPE_SELECTED = $('busType').value;
	}
	
	if (TYPE_SELECTED!=TYPE_SCR){
		var tdInOut = new Element("td", {styles: {width: tdWidths[3]}});
		var divInOut = new Element("div");
		divInOut.inject(tdInOut);
		var selectInOut = new Element('select', {styles: {width: '100%'}});
		selectInOut.setProperty('name',"cmbParInOut");
		
		var option = new Element('option');
		option.setProperty('value',"I");
		option.appendText(LBL_IN);
		option.inject(selectInOut);
		
		option = new Element('option');
		option.setProperty('value',"O");
		option.appendText(LBL_OUT);
		option.inject(selectInOut);
		
		option = new Element('option');
		option.setProperty('value',"Z");
		option.appendText(LBL_INOUT);
		option.inject(selectInOut);
		
		selectInOut.inject(divInOut);
	}else{
		var tdInOut = new Element("td",{html:LBL_INOUT, styles: {width: tdWidths[3]}});
		var divInOut = new Element("div");
		divInOut.inject(tdInOut);
		input = new Element("input");
		input.setProperty("name","cmbParInOut");
		input.setProperty('type','hidden');	
		input.setProperty('value','Z');
		input.inject(divInOut);	
	}
	
	
	///checkbox Multievaluado
	var tdMul = new Element("td", {'align':'center',styles: {width: tdWidths[4]}});
	var divMul = new Element("div");
	divMul.inject(tdMul);
	var chkMul = new Element('input',{'type':'checkbox'});
	chkMul.setProperty('name',"chkMul");
	chkMul.checked = false;
	chkMul.disabled = !((($('busType') && $('busType').value == "P") || TYPE_SELECTED == TYPE_JAV) && $('chkPubWs').checked);
	chkMul.inject(divMul);
	chkMul.addEvent("click",function(){ onChangeChkMul(this); });
	var inputHidden = new Element('input',{'type':'hidden','value':'false','name':'txtChkMul'});
	chkMul.inputHidden = inputHidden;
	inputHidden.inject(divMul);	
	///	
	///checkbox dateTime
	var tdDatetime = new Element("td", {'align':'center',styles: {width: tdWidths[5]}});
	var divDatetime = new Element("div");
	divDatetime.inject(tdDatetime);
	var chkDatetime = new Element('input',{'type':'checkbox'});
	chkDatetime.setProperty('name',"chkDatetime");
	chkDatetime.checked = false;
	chkDatetime.disabled = true;//!((($('busType') && $('busType').value == "P") || TYPE_SELECTED == TYPE_JAV) && $('chkPubWs').checked);
	chkDatetime.inject(divDatetime);
	chkDatetime.addEvent("click",function(){ onChangeChkDatetime(this); });
	var inputDatetimeHidden = new Element('input',{'type':'hidden','value':'false','name':'txtChkDatetime'});
	chkDatetime.inputHidden = inputDatetimeHidden;
	inputDatetimeHidden.inject(divDatetime);	
	///
	
	var count = table.rows.length;	
	var row = new Element("tr",{'class': 'selectableTR'});
	row.setAttribute("rowId", count);
	row.getRowId = function () { return this.getAttribute("rowId"); };
	row.setRowId = function (a) { this.setAttribute("rowId",a); };
	if(count%2==0){
		row.addClass("trOdd");
	}
	
	
	tdName.inject(row);
	tdDesc.inject(row);
	tdType.inject(row);
	tdInOut.inject(row);
	tdMul.inject(row);
	tdDatetime.inject(row);
	
	table.appendChild(row);
	 
	row.addEvent("click",function(e){
		if (row.getParent().selectOnlyOne) {
			var parent = row.getParent();
			if (parent.lastSelected) parent.lastSelected.toggleClass("selectedTR");
				parent.lastSelected = row;
			}
		row.toggleClass("selectedTR");
	}); 
	
	count++;
	
	
	addScrollTableParams();	
	if (Scroller != null && Scroller.v != null){
		Scroller.v.showElement(row);
	}
}

function deleteRow(pos) {
	var table = $('tableDataParams');	
	var row = table.rows[pos];
	inputs = row.getElementsByTagName("input");
	input = inputs.item(0);
	disposeValidation(input);
	row.dispose();
	for (var i=0;i<table.rows.length;i++){
		table.rows[i].setRowId(i);
		if (i%2==0){
			table.rows[i].addClass("trOdd");
		}else{
			table.rows[i].removeClass("trOdd");
		}
	}
	
	addScrollTableParams();
} 

function downRow(pos){
	var table = $('tableDataParams');	
	if ((pos+1)==table.rows.length){
		return
	}else{
		table.rows[pos].parentNode.insertBefore(table.rows[pos+1],table.rows[pos]);
		table.rows[pos].setRowId(pos);
		table.rows[pos+1].setRowId(pos+1);
	}
	if (Scroller != null && Scroller.v != null){
		Scroller.v.showElement(table.rows[pos+1]);
	}
}

function upRow(pos){
	var table = $('tableDataParams');	
	if (pos==0){
		return
	}else{
		table.rows[pos].parentNode.insertBefore(table.rows[pos],table.rows[pos-1]);
		table.rows[pos-1].setRowId(pos-1);
		table.rows[pos].setRowId(pos);
	}
	if (Scroller != null && Scroller.v != null){
		Scroller.v.showElement(table.rows[pos-1]);
	}
}

function changeType(valueCmb){
	if (valueCmb==TYPE_DB_PROC){
		$('divD').style.display='';
		disposeValidation($('connectionViews'));
		$('divB').style.display='none';
		$('specific').style.display='';
		populateCombo();
	}else if (valueCmb==TYPE_DB){			
		$('divB').style.display='';
		disposeValidation($('connectionProc'));
		$('divD').style.display='none';
		$('specific').style.display='';
		populateCombo();		
	}else{
		showType(valueCmb);
	}
}

function populateCombo(){
	var aux = $('busType');
	var views = true;
	if (TYPE_SELECTED!=null || (aux.options[aux.selectedIndex].value==TYPE_DB_PROC || aux.options[aux.selectedIndex].value==TYPE_DB)){
		$('specific').style.display='';
		if (BUS_CLA_ID!="" && TYPE_SELECTED==TYPE_DB_PROC || (aux!=null && aux.options[aux.selectedIndex].value==TYPE_DB_PROC)){
			views = false;
		}
		var request = new Request({
			method: 'post',
			data:{id:$('connectionsCombo').value,views:views},
			url: CONTEXT + URL_REQUEST_AJAX+'?action=populateCombo&isAjax=true&' + TAB_ID_REQUEST,		
			onComplete: function(resText, resXml) { displayCombo(resXml); }
		}).send();
	}
}



function displayCombo(xml){
	//hideMessage();
	var aux = $('busType');
	var toLoad = xml.getElementsByTagName("load").item(0);
	var theForm = toLoad.getElementsByTagName("form").item(0);
	if (theForm!=null){
		var theElements = theForm.getElementsByTagName("elements");
		var formElements = processModalXmlFormElements(theElements, false);
		var htmlForm = formElements; 
		if ( (BUS_CLA_ID!="" && TYPE_SELECTED==TYPE_DB) || aux!=null && aux.options[aux.selectedIndex].value==TYPE_DB){
			disposeValidation($('connectionViews'));
			$('cmbDbTableContainer').innerHTML=htmlForm;
			var t_aux = $('cmbDbTableContainer').getElement("table");
			if(t_aux) t_aux.setStyle("width", "100%");
			disposeValidation($('connectionProc'));
			if ($('connectionViews')){
				registerValidation($('connectionViews'));				
			}
			
		}else if (aux!=null || (BUS_CLA_ID!="" && TYPE_SELECTED==TYPE_DB_PROC)){
			disposeValidation($('connectionProc'));
			$('cmbProcTableContainer').innerHTML=htmlForm;
			var t_aux = $('cmbProcTableContainer').getElement("table");
			if(t_aux) t_aux.setStyle("width", "100%");
			disposeValidation($('connectionViews'));
			if($('connectionProc')){
				registerValidation($('connectionProc'));
			}			
		}
		loadParams();
	}else{
		processModalXmlText(xml,null,true);
	}
}


function clickGoBack(){
	sp.show(true);
	window.location = CONTEXT + URL_REQUEST_AJAX + '?action=list' + TAB_ID_REQUEST;	
}

function fixChkMul(disabled){
	var table = $('tableDataParams');
	var trs = table.getElements("tr");
	
	for (var i = 0; i < trs.length; i++){
		var tr = trs[i]; 
		var chk = tr.getElements("td")[4].getElement("input");
		if (!chk.forceReadOnly){
			chk.disabled = disabled;
		}
	}
}

function fixChkDateTime(disabled){
	var table = $('tableDataParams');
	var trs = table.getElements("tr");
	
	for (var i = 0; i < trs.length; i++){
		var tr = trs[i];
		var chk = tr.getElements("td")[5].getElement("input");
		if (!chk.forceReadOnly){
			var cmbTypes = tr.getElements("td")[2].getElement("select");
			if (!cmbTypes){
				var inputs = tr.getElements("td")[0].getElements("input");
				for (var j = 0; j < inputs.length; j++){
					if (inputs[j].getAttribute("name")=='cmbParType'){
						cmbTypes = inputs[j];
						break;
					}
				}
			}			
				
			
			if (cmbTypes && cmbTypes.value == "D"){
				chk.disabled = disabled;
			} else {
				chk.disabled = true;
			}
		}
	}
}

function onChangeChkMul(chk){
	chk.inputHidden.value = chk.checked ? 'true' : 'false';
}

function onChangeChkDatetime(chk){
	chk.inputHidden.value = chk.checked ? 'true' : 'false';
}
