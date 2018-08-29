//////////////////////////////////////////////////////////////////
//	FLASH FNs
//////////////////////////////////////////////////////////////////
// Handles all the FSCommand messages in a Flash movie

var flashLoaded = false;
var flashLoadedPrint = false;
var actionAfterFlash = "";
var argument = "";
var flashShown=false;

var xml_model_exported = false;

function shell_DoFSCommand(command, args) {
	var auxCol=getFlashObject("shell").bgcolor;
	if (command == "outputXML") {
		showFlashXML(args,"1")
	}
	if(command == "inputXML") {
		showFlashXML(args,"2")
	}
	if (command == "isReady") {
		flashLoaded = true;
		setEntity();
		proTypeChange();
		flashShown=true;
	}
	if (command == "setEntity") {
	}
	if (command == "viewProcess") {
		argument = args;
		actionAfterFlash = "viewProcess";
		getFlashObject("shell").SetVariable("call", "getOutputXML");
	}
	if (command == "changeColor") {
		if(args!=""){
			auxCol=getFlashObject("shell").bgcolor;
			getFlashObject("shell").bgcolor=args;		
		}else{
			getFlashObject("shell").bgcolor=auxCol;
		}
	}
	if(command == "hideFlash") {
		if(args!="" && args!="undefined" && args!=null){
			document.getElementById("txtMap").value=args;
			//var flashObj=getFlashObject("shell");
			var flashObj=document.getElementsByTagName("EMBED")[0];
			var flashVars=flashObj.getAttribute("flashVars");
			flashVars=flashVars.split("&stringModel=")[0];
			flashVars+=("&stringModel="+escape(args));
			flashObj.setAttribute("flashVars",flashVars);
			hideAllContents();
			document.getElementById("tab"+listener.contentNumber).parentNode.className="here";
			document.getElementById("content"+listener.contentNumber).style.display="block";
			var container=window.parent.document.getElementById(window.name);
			if(container){
				container.style.display="none";
				container.style.display="block";
			}
			flashShown=false;
		}
	}
	if(command == "getSWFVersions"){
		alert(args);
	}
	 
}


function shellPrint_DoFSCommand(command, args) {
	
	
	if (command == "isReady") {
		flashLoadedPrint = true;
		if(!newProcess){
			if(document.getElementById("btnGenDoc")){
				document.getElementById("btnGenDoc").disabled=false;
			}
		} else {
			if(document.getElementById("btnGenDoc")){
				document.getElementById("btnGenDoc").disabled=true;
			}
		}
	}
	 
	if(command == "ProcessImageUploaded"){
		//document.getElementById("frmMain").target = "ifrmDow";
		//document.getElementById("frmMain").action = URL_REQUEST_AJAX + "?action=genDoc" + TAB_ID_REQUEST;
		//document.getElementById("frmMain").submit();
		
//		var form = $('frmData');
//		form.target = 'ifrmDow';
//		form.action = CONTEXT + URL_REQUEST_AJAX + "?action=genDoc" + TAB_ID_REQUEST;
//		form.submit();//"frmPrint"
		
		//$('ifrmDow').set('src', CONTEXT + URL_REQUEST_AJAX + "?action=genDoc" + TAB_ID_REQUEST);
		document.getElementById("frmData").target = "ifrmDow";
		document.getElementById("frmData").action = CONTEXT + URL_REQUEST_AJAX + "?action=genDoc" + TAB_ID_REQUEST;
		
		var prntAction = $('prntAction').set('value', 'genDoc');
		var prntTabId = $('prntTabId').set('value', TAB_ID_REQUEST.split('&')[1].split('=')[1]);
		var prntTokenId = $('prntTokenId').set('value', TAB_ID_REQUEST.split('&')[2].split('=')[1]);
		
		document.getElementById("frmData").submit();
		
		prntAction.set('value','');
	}
}

function reloadFlash(){
	getFlashObject("shell").SetVariable("call", "reload");
}

function setAuto(){
	getFlashObject("shell").SetVariable("call", "setAuto");
}

function setManual(){
	getFlashObject("shell").SetVariable("call", "setManual");
}

function setEntity(){
	if (document.getElementById("cmbEntAsoc").value != "") {
		getFlashObject("shell").SetVariable("call", "setEntity,entId="+document.getElementById("cmbEntAsoc").value);
	} 
	//("call",flash_method,string_value)
}

function uploadProcessImage(){
	/*
	var caller = new AjaxCall();
	caller.callUrl			= URL_REQUEST_AJAX + "?action=genDocStatusStart" + TAB_ID_REQUEST;
	caller.callParams		= "";
	caller.onBeforeCall		= function() {
		var win = window;
		while(!win.document.getElementById("iframeMessages") || !win.document.getElementById("iframeResult")){
			win=win.parent;
		}
		win.document.getElementById("iframeResult").style.visibility="hidden";
		win.document.getElementById("iframeResult").style.display="block";
		win.document.getElementById("iframeResult").doCenterFrame();
		win.document.getElementById("iframeMessages").showResultFrame(document.body);
		win.document.getElementById("iframeResult").style.visibility="visible";
	};
	caller.onErrorCall		= function() { hideResultFrame(); };
	caller.onProcessCall	= function(xml) {
		getFlashObject("shellPrint").SetVariable("call", "uploadProcessImage");
		setTimeout(checkDocumentationStatus,500);
	};
	caller.doCall();
	*/
	
	new Request({
		url: CONTEXT + URL_REQUEST_AJAX + "?action=genDocStatusStart" + TAB_ID_REQUEST,
		onSuccess: function(responseText, responseXML) {
			getFlashObject("shellPrint").SetVariable("call", "uploadProcessImage");
			setTimeout(checkDocumentationStatus, 500);
		},
		onFailure: function(xhr) {
			//hideResultFrame();
			SYS_PANELS.closeLoading();
		},
		onRequest: function() {
			/*
			var win = window;
			while(!win.document.getElementById("iframeMessages") || !win.document.getElementById("iframeResult")){
				win=win.parent;
			}
			win.document.getElementById("iframeResult").style.visibility="hidden";
			win.document.getElementById("iframeResult").style.display="block";
			win.document.getElementById("iframeResult").doCenterFrame();
			win.document.getElementById("iframeMessages").showResultFrame(document.body);
			win.document.getElementById("iframeResult").style.visibility="visible";
			*/
			SYS_PANELS.showLoading();
		}
	}).send();

	//getFlashObject("shellPrint").SetVariable("call", "uploadProcessImage");
}

function getSWFVersions(){
	getFlashObject("shell").SetVariable("call", "getSWFVersions");
}

function checkDocumentationStatus() {
	/*
	var caller = new AjaxCall();
	caller.callUrl			= URL_REQUEST_AJAX + "?action=genDocStatus" + TAB_ID_REQUEST;
	caller.callParams		= "";
	caller.onBeforeCall		= function() {};
	caller.onErrorCall		= function() { hideResultFrame(); };
	caller.onProcessCall	= function(xml) {
		if (xml.lastChild.firstChild.nodeValue == "true") {
			setTimeout(checkDocumentationStatus,500);
		} else if (xml.lastChild.firstChild.nodeValue == "false") {
			hideResultFrame();
		} else { //error mostrarlo
			alert(xml.lastChild.firstChild.nodeValue);
			hideResultFrame();
		}
	};
	caller.doCall();
	*/
	
	new Request({
		url: CONTEXT + URL_REQUEST_AJAX + "?action=genDocStatus" + TAB_ID_REQUEST,
		onSuccess: function(responseText, responseXML) {
			if (responseXML.lastChild.firstChild.nodeValue == "true") {
				setTimeout(checkDocumentationStatus,500);
			} else if (responseXML.lastChild.firstChild.nodeValue == "false") {
				//hideResultFrame();
				SYS_PANELS.closeLoading();
			} else { //error mostrarlo
				alert(responseXML.lastChild.firstChild.nodeValue);
				//hideResultFrame();
				SYS_PANELS.closeLoading();
			}
		},
		onFailure: function(xhr) {
			SYS_PANELS.closeLoading();
		}
	}).send();
}

function getFlashOutput(){
	if(navigator.userAgent.indexOf("MSIE")>0){
		if (flashLoaded==true || flashLoaded=="true"){
				getFlashObject("shell").SetVariable("call", "getOutputXML");
		} else {
			if (actionAfterFlash == "confirmar") {
				btnConf_click();
			} else if (actionAfterFlash == "guardar") {
				btnGua_click();
			} else if (actionAfterFlash == "validar") {
				btnVal_click();
			}
		}
	}else{
		if((flashLoaded==true || flashLoaded=="true")&& flashShown){
			getFlashObject("shell").SetVariable("call", "getOutputXML");
		} else {
			if (actionAfterFlash == "confirmar") {
				btnConf_click();
			} else if (actionAfterFlash == "guardar") {
				btnGua_click();
			} else if (actionAfterFlash == "validar") {
				btnVal_click();
			}
		}
	}
}

function showFlashOutput(){
	if (flashLoaded) {
		actionAfterFlash = "show";
		getFlashObject("shell").SetVariable("call", "getOutputXML");
	}
}

function showFlashInput(){
	if (flashLoaded) {
		actionAfterFlash = "show";
		getFlashObject("shell").SetVariable("call", "getInputXML");
	}
}

//////////////////////////////////
//	DEBUG
//////////////////////////////
function showFlashHTML(html,winName){
var w = window.open("",winName,"height=480,width=680,resizable=yes,scrollbars=yes");
	w.document.open();
    w.document.write(html);
    w.document.close();
    w.focus();
}		

function showFlashXML(doc,winName){
//alert(doc);
	var oXML;
	var tempdoc;
	if(navigator.userAgent.indexOf("MSIE")>0){
		oXML = new ActiveXObject("Microsoft.XMLDOM");
		tempdoc = new ActiveXObject("Microsoft.XMLDOM");
		oXML.loadXML(doc);
	}else{
		//oXML= document.implementation.createDocument("", "", null);
		tempdoc = document.implementation.createDocument("", "", null);
		var objDOMParser = new DOMParser(); 
		oXML = objDOMParser.parseFromString(doc,"text/xml");
	}
    tempdoc.async = false;
    /*if (!tempdoc.load(URL_ROOT_PATH + "/flash/process/xml/mimedefault.xsl")){
		//showHTML(reportParseError(tempdoc.parseError));
		alert("ERROR loading XSL")
	}else{*/
    	/*
		if (actionAfterFlash == "confirmar") {
			document.getElementById("txtMap").value=doc;
			btnConf_click();
		} else if (actionAfterFlash == "guardar") {
			document.getElementById("txtMap").value=doc;
			btnGua_click();
		} else if (actionAfterFlash == "validar") {
			document.getElementById("txtMap").value=doc;
			btnVal_click();
		} else if (actionAfterFlash == "viewProcess") {
			document.getElementById("txtMap").value=doc;
			document.getElementById("frmMain").action = URL_REQUEST_AJAX + "?action=viewProcess&proId="+argument + TAB_ID_REQUEST;
			submitForm(document.getElementById("frmMain"));
		} else {
			var html = transformNode(oXML,tempdoc);
	    	showFlashHTML(html,winName);
	    }
	    */
    
    	//Se setea siempre el txtMap
    	document.getElementById("txtMap").value = doc;
    	xml_model_exported = true;
    	executeBeforeConfirmCallback();
    //}
}


function transformNode(oXML,tempdoc){
	if(MSIE){
		return oXML.transformNode(tempdoc);
	}else{
		var processor = new XSLTProcessor();
		processor.importStylesheet(tempdoc);
		return processor.transformToDocument(oXML);
	}
}

function getFlashObject(movieName){
	if (window.document[movieName]){
		return window.document[movieName];
	}
	if (navigator.appName.indexOf("Microsoft Internet")==-1){
		if (document.embeds && document.embeds[movieName]){
			return document.embeds[movieName];
		}
	}else{ // if (navigator.appName.indexOf("Microsoft Internet")!=-1){
		return document.getElementById(movieName);
	}
}

function startDownload(ok){
	if (ok){
		createDownloadIFrame("",DOWNLOADING,URL_REQUEST_AJAX,"downloadDoc","","","",null);
	} else {
		showMessage(LBL_GENERIC_ERROR, GNR_TIT_WARNING, 'modalWarning');
	}
}

function oldEntChange() {
	//if (flashLoaded && MSIE) {
	if (flashLoaded) {
		setEntity();
	}
}

function oldProTypeChange() {
	if (flashLoaded) {
		if (document.getElementById("txtProAction").selectedIndex==0) {
			setAuto();
		} else {
			setManual();
		}
	}
}
