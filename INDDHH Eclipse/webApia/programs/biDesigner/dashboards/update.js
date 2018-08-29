function btnConf_click(){
	if (verifyRequiredObjects()) {
		if(isValidName(document.getElementById("dshName").value)){
			if (verifyOtherReqObjects() && verifyPermissions()){
				document.getElementById("frmMain").action = "biDesigner.DashboardAction.do?action=confirm" + windowId;
				submitForm(document.getElementById("frmMain"));
			}
		}
	}
}

function btnExit_click(){
	var msg = confirm(GNR_PER_DAT_ING);
	if (msg) {
		splash();
	}
}
function btnBack_click() {
	if (canWrite()){
		var msg = confirm(GNR_PER_DAT_ING);
		if (msg) {
			document.getElementById("frmMain").action = "biDesigner.DashboardAction.do?action=backToList" + windowId;
			submitForm(document.getElementById("frmMain"));
		}
	}else{
		document.getElementById("frmMain").action = "biDesigner.DashboardAction.do?action=backToList" + windowId;
		submitForm(document.getElementById("frmMain"));
	}
}

function verifyOtherReqObjects(){

	//1. Verificamos si ingreso algun perfil
//	if (document.getElementById("gridProfiles").rows.length<=0){
//		alert(MSG_MUST_ENT_ONE_PRF);
//		return false;
//	}

	return true;
}

function btnAddProfile_click() {

	var rets = null;
	rets = openModal("/programs/modals/profiles.jsp",(getStageWidth()*.6),(getStageHeight()*.6));
	var doLoad=function(rets){
		if (rets != null) {
			if (rets != null) {
				for (j = 0; j < rets.length; j++) {
					var ret = rets[j];
					var addRet = true;
					
					trows=document.getElementById("gridProfiles").rows;
					for (i=0;i<trows.length && addRet;i++) {
						if (trows[i].getElementsByTagName("TD")[0].getElementsByTagName("INPUT")[1].value == ret[0]) {
							addRet = false;
						}
					}
					
					if (addRet) {
						var oTd0 = document.createElement("TD"); 
						var oTd1 = document.createElement("TD"); 
				
						oTd0.innerHTML = "<input type='checkbox' name='chkPrfSel'><input type='hidden' name='chkPrf'>";
						oTd0.getElementsByTagName("INPUT")[1].value = ret[0];
						oTd0.align="center";
				
						if(ret[2]==1){
							oTd1.innerHTML = "<B>"+ret[1]+"</B>";			
						} else {
							oTd1.innerHTML = ret[1];			
						}
				
						var oTr = document.createElement("TR");
						oTr.appendChild(oTd0);
						oTr.appendChild(oTd1);
						document.getElementById("gridProfiles").addRow(oTr);
					}
				}
			}
		}
	}
	rets.onclose=function(){
		doLoad(rets.returnValue);
	}
}

function btnDelProfile_click() {
	document.getElementById("gridProfiles").removeSelected();
}

function chkWidName(obj){

	var td=obj.parentNode;
	while(td.tagName!="TD"){
		td=td.parentNode;
	}
	
	if(obj.checked){
		td.getElementsByTagName("INPUT")[1].value = "on";
	}else{
		td.getElementsByTagName("INPUT")[1].value = "off";
	}
}

///////////////// FUNCIONES DE USO GRAL ////////////////

//Funcion interna para borrar un textArea dado su nombre
function borrarTextArea(name){
	while(document.getElementById(name).options.length>0){
		var opt=document.getElementById(name).options[0];
		if(opt){
			opt.parentNode.removeChild(opt);
		}
	}
}
var flashLoadedVar=false;
function flashLoaded(){
	flashLoadedVar=true;
	
}

var tabset;
var aftertab;

function onTabChangeSaveFlash(tab,tabnum){
	if(!MSIE){
		flashLoadedVar=false;
	}
	aftertab=tabnum;
	tabset=tab;
	getFlashMovie("dashDesign").saveModel();
}

function saveModel(model){
	document.getElementById("txtXML").value=model;
	tabset.afterShowContent(aftertab);
}

function gotDashDesignXML(model){
	document.getElementById("txtXML").value=model;
	btnConf_click();
}

function loadModel(){
	var model=document.getElementById("txtXML").value;
	getFlashMovie("dashDesign").loadModel(model);
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

function verifyPermissions(){
	//Verificamos si almenos una persona tiene acceso de modificacion
	var permRows=document.getElementById("permGrid").rows;
	var someoneCanModify = false;
	for(var i=0;i<permRows.length;i++){
		var canModify= ("1" == permRows[i].getElementsByTagName("TD")[0].getElementsByTagName("INPUT")[3].value);
		if(canModify){//Verificamos que los nombres de los atributos no sean nulos
			someoneCanModify = true;
		}
	}
	if (!someoneCanModify){
		alert(MSG_PERMISSIONS_ERROR);	
		return false;
	}
	return true;
}

function canWrite(){
	var usrCanWrite = document.getElementById("hidUsrCanWrite").value;
	if (usrCanWrite=='true'){
		return true;
	}else{
		return false;	
	}
}