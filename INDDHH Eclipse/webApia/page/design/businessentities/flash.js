//////////////////////////////////////////////////////////////////
//	FLASH FNs
//////////////////////////////////////////////////////////////////
// Handles all the FSCommand messages in a Flash movie

var flashLoaded = false;
var actionAfterFlash = "";

function shell_DoFSCommand(command, args) {
	if (command == "outputXML") {
		showFlashXML(args,"1")
	}
	if(command == "inputXML") {
		showFlashXML(args,"2")
	}
	if (command == "isReady") {
		flashLoaded = true;
	}
	if(command == "hideFlash") {
		$("txtMap").value=args;
		//var flashObj=getFlashObject("shell");
		var flashObj=getFlashObject("shell");
		var flashVars=flashObj.getAttribute("flashVars");
		flashVars=flashVars.split("&stringModel=")[0];
		flashVars+=("&stringModel="+args);
		flashObj.setAttribute("flashVars",flashVars);
		$("samplesTab").hideAllContents();
		$("samplesTab").showContent(listener.contentNumber);
		var container=window.parent.document.getElementById(window.name);
		if(container){
			container.style.display="none";
			container.style.display="block";
		}
		flashLoaded=false;
	}
}

function showFlashOutput(){
	if (flashLoaded) {
		actionAfterFlash = "confirm";
		getFlashObject("shell").SetVariable("call", "getOutputXML");
	} else {
		btnConf_click();
	}
}

function showFlashInput(){
	if (flashLoaded) {
		getFlashObject("shell").SetVariable("call", "getInputXML");
	}
}

//////////////////////////////////
//	DEBUG
//////////////////////////////

function xmlLoader(){
	var doc;
	this.data="";
	try{
		if(!MSIE){
			var tmp=this;
			doc=new XMLHttpRequest();
			doc.load=function(url){
				this.open("POST",url,false);
				this.overrideMimeType('text/xml');
				this.ignoreWhitespace=true;
				this.setRequestHeader("Content-type", "application/x-www-form-urlencoded; charset=utf-8");
//				this.setRequestHeader("Content-length", tmp.data.length);
//				this.setRequestHeader("Connection", "close");
				this.send(tmp.data);
			}
		}else{
			//doc = new ActiveXObject("Microsoft.XMLDOM");
			doc=new ActiveXObject("Microsoft.XMLHTTP");
			doc.validateOnParse = false;
			doc.async = true;
			doc.preserveWhiteSpace = false;
		}
	}
	catch(err){
	}
	this.doc=doc;
	var tmp=this;
	this.load=function(url){
		if(MSIE){
			tmp.doc.onreadystatechange=function(){
				if(doc.readyState==4){
					tmp.xmlLoaded=doc.responseXML.lastChild;
					tmp.textLoaded=doc.responseText;
					tmp.onload(tmp.xmlLoaded);
				}
			}
			tmp.doc.open("GET",url,false);
			tmp.doc.send(null);
		}else{
			this.doc.parentObject=this;
			this.doc.onload=function(){
				this.parentObject.xmlLoaded=this.responseXML;
				this.parentObject.textLoaded=this.responseText;
				var first=null;
				if(this.parentObject.xmlLoaded){
					first=this.parentObject.xmlLoaded.firstChild;
				}
				this.parentObject.onload(first);
			}
			this.doc.load(url);
		}
	}
	this.loadString=function(xmlString){
		var xmlData; 
		if(MSIE){
			xmlData = new ActiveXObject("Microsoft.XMLDOM"); 
			xmlData.async="false"; 
			xmlData.loadXML(xmlString); 
		}else{ 
			var parser = new DOMParser(); 
			xmlData = parser.parseFromString(xmlString,"text/xml"); 
		}
		return xmlData;
	}
	this.onload=function(xmlLoaded){}
}

function showFlashXML(doc,winName){
	var oXML = new xmlLoader();
	oXML.loadString(doc);
    var tempdoc = new xmlLoader();
    tempdoc.onload=function(root){
	    if (!root){
			//showHTML(reportParseError(tempdoc.parseError));
			alert("ERROR loading XSL")
		}else{
			if (actionAfterFlash == "confirm") {
				$("txtMap").value=doc;
				//Se traslada para los EntityState
				//btnConf_click();
				try {
					getFlashMovie("entStates").getOutXML();					
				} catch(error) {
					
				}
				if (btnConf_click()){
					sendFormEnt();
				}	
			} else if (actionAfterFlash == "guardar") {
				$("txtMap").value=doc;
				btnGua_click();
			} else if (actionAfterFlash == "validar") {
				$("txtMap").value=doc;
				btnVal_click();
			} else {
				var html = transformNode(oXML,tempdoc);
		    	showFlashHTML(html,winName);
		    }
	    }
    }
    tempdoc.load(CONTEXT + "/flash/process/xml/mimedefault.xsl")
}

function showFlashHTML(html,winName){
var w = window.open("",winName,"height=480,width=680,resizable=yes,scrollbars=yes");
	w.document.open();
    w.document.write(html);
    w.document.close();
    w.focus();
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
		return $(movieName);
	}
}

function getFlashMovie(movieName) {   
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

function thisMovie(movieName) {
    if (navigator.appName.indexOf("Microsoft") == -1) {
        return window[movieName];
    } else {
        return document[movieName];
    }
}


function getEntStatus() {
		
	//var staGrid = $("tblStatus");
	var staGrid = $('statusContainer');
	
	if(staGrid == undefined || staGrid == null)	return;
	
	var res = "<?xml version=\"1.0\" encoding=\"UTF-8\"?><ROWSET>";
	
	var states = staGrid.getChildren('div');
	for(var i = 0; i < states.length - 1; i++) {
		var state_data = states[i].getElements('input');
		res += "<ROW><COL>" + state_data[0].get('value') + "</COL><COL>" + state_data[1].get('value') + "</COL></ROW>";
	}
	
	res += "</ROWSET>";
	
	//Invocamos al flash
	try {
		getFlashMovie("entStates").setStatusXML(res);
	} catch(error) {}
	
	/*
	var tbody = staGrid.getElementsByTagName("tbody");
	
	if(tbody == undefined || tbody == null || tbody.length == 0)
		return;
	
	var trs = tbody[0].getElementsByTagName("tr");

	var res = "<?xml version=\"1.0\" encoding=\"UTF-8\"?><ROWSET>";

	for(var i = 0; i < trs.length; i++) {
		var aux = "";
		var els = trs[i].getElementsByTagName("td")[0].getElementsByTagName("*");
		for(var j = 0; j < els.length; j++) {
			if(els[j].getAttribute("id") == "chkStatus") 
				aux = "<COL>" + els[j].getAttribute("value") + "</COL>" + aux;
			else if(els[j].getAttribute("id") == "staName")
				aux = aux + "<COL>" + els[j].getAttribute("value") + "</COL>";
		}
		if(aux != "")
			res += "<ROW>" + aux + "</ROW>";
	}

	res += "</ROWSET>";
	
	//Invocamos al flash
	try {
		getFlashMovie("entStates").setStatusXML(res);
	} catch(error) {}
	
	*/
}

function setEntityStateXML(doc) {
	$("txtEntityStateXML").value=doc;
	if (actionAfterFlash == "confirm") {
		btnConf_click();
	}
}

function getEntityStateXML() {
	var res = $("txtEntityStateXML").value;
	/*
	try {		
		getFlashMovie("entStates").loadEntityStateXML(res);
	} catch(error) {
		console.log(error);
	}
	*/
	return res;
	
}