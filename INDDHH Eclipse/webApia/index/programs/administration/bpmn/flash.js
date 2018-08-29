
//////////////////////////////////////////////////////////////////
//	FLASH FNs
//////////////////////////////////////////////////////////////////
// Handles all the FSCommand messages in a Flash movie

var flashLoaded = false;
var flashLoadedPrint = false;
var actionAfterFlash = "";
var argument = "";
var flashShown=false;

function importXPDL(){
	var str=document.getElementById("txtMap").value;
	if(str!=null && str != ""){
		getFlashMovie("Designer").setModel(str);
	}
}

var tabset;
var aftertab;

function onTabChangeSaveFlash(tab,tabnum){
	aftertab=tabnum;
	tabset=tab;
	getFlashMovie("Designer").saveModel();
}

function saveModel(model){
	document.getElementById("txtMap").value=model;
	tabset.afterShowContent(aftertab);
}

function exportXPDL(){
	if(MSIE || (!MSIE && getFlashMovie("Designer").getModel)){
		getFlashMovie("Designer").getModel();
	}else{
		if (actionAfterFlash == "confirmar") {
			btnConf_click();
		} else if (actionAfterFlash == "guardar") {
			btnGua_click();
		} else if (actionAfterFlash == "validar") {
			btnVal_click();
		}
	}
}

function gotModel(str){
	document.getElementById("txtMap").value=str; 
	if (actionAfterFlash == "confirmar") {
		btnConf_click();
	} else if (actionAfterFlash == "guardar") {
		btnGua_click();
	} else if (actionAfterFlash == "validar") {
		btnVal_click();
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
function formSend() {   
	var text = document.getElementById("txtMap").value;  
	getFlashMovie("Designer").sendTextToFlash(text);     
}    
function getTextFromFlash(str) {   
	document.htmlForm.receivedField.value = "From Flash: " + str;   
	return str + " received";  
}


function flashReady(){
	flashLoaded = true;
	setEntity();
	proTypeChange();
	flashShown=true;
	importXPDL();
}


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
			flashVars+=("&stringModel="+args);
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
}

function generateRTF(title){
	try{
		getFlashMovie("Designer").getRTF(title);
	}catch(e){}
}

function reloadFlash(){
	getFlashMovie("Designer").reload();
}

function setAuto(){
	//getFlashMovie("Designer").setAuto();
}

function setManual(){
	//getFlashMovie("Designer").setManual();
}

function setEntity(){
//	if (document.getElementById("txtBusEnt").value != "") {
//		getFlashMovie("Designer").setEntity(document.getElementById("txtBusEnt").value);
//	} 

}


function getFlashOutput(){
	if (flashLoaded==true || flashLoaded=="true"){
		exportXPDL();
	}else{
		if (actionAfterFlash == "confirmar") {
			btnConf_click();
		} else if (actionAfterFlash == "guardar") {
			btnGua_click();
		} else if (actionAfterFlash == "validar") {
			btnVal_click();
		}
	}
}

function restartFlash(){
	if((flashLoaded==true || flashLoaded=="true") && MSIE && getFlashMovie("Designer")){
		getFlashMovie("Designer").reloadFlash();
	}
}

function getSWFVersions(){
	getFlashMovie("Designer").getSWFVersions();
}

function modelLoaded(){
}
