if (document.addEventListener) {
    document.addEventListener("DOMContentLoaded", start, false);
}else{
	start();
}

function start(){
	if (document.getElementById("txtName").value == ""){
		document.getElementById("txtName").focus();
	}
}
function btnConf_click(){
	if (verifyRequiredObjects() && verifyPermissions()) {
		if(isValidName(document.getElementById("txtName").value)){
			document.getElementById("frmMain").action = "administration.ProjectAction.do?action=confirm";
			submitForm(document.getElementById("frmMain"));
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
	var msg = confirm(GNR_PER_DAT_ING);
	if (msg) {
		document.getElementById("frmMain").action = "administration.ProjectAction.do?action=backToList";
		submitForm(document.getElementById("frmMain"));
	}
}


function viewFnc(e){
	var previous=e.parentNode.parentNode.previousSibling;
	if(previous.tagName!="TD"){
		previous=previous.previousSibling;
	}
	var envId = previous.getElementsByTagName("INPUT")[1].value+"";
	if(envId=="all") {
		envId = 0;
	}
	var ret = openModal("/administration.ProjectsAction.do?action=openModal&envId=" + envId,400,500);
}

function btnAddEnv_click() {
	var rets = openModal("/programs/modals/envs.jsp",500,300);
	var doLoad=function(rets){
		if (rets != null) {
			for (j = 0; j < rets.length; j++) {
				var ret = rets[j];
				var addRet = true;
	
				trows=document.getElementById("gridEnv").rows;
				for (i=0;i<trows.length && addRet;i++) {
					if (trows[i].getElementsByTagName("TD")[0].getElementsByTagName("INPUT")[1].value == ret[0]) {
						addRet = false;
					}
				}
				
				if (addRet) {
					var oTd0 = document.createElement("TD"); 
					var oTd1 = document.createElement("TD"); 
					var oTd2 = document.createElement("TD"); 
					var oTd3 = document.createElement("TD"); 
					
					oTd0.innerHTML = "<input type='checkbox' name='chkEnvSel' id='chkEnvSel'><input type='hidden' name='chkEnv'>";
					
					oTd0.getElementsByTagName("INPUT")[1].value = ret[0];
				
					oTd1.innerHTML = "<img style='cursor:hand' src='"+ URL_STYLE_PATH + "/images/btn_mod.gif' onclick='viewFnc(this)'>";
					oTd1.align="center";

					oTd2.innerHTML= ret[1];
									
					oTd3.innerHTML = "<input name= 'txtEnvs' type='hidden'>";
					oTd3.getElementsByTagName("INPUT")[0].value = ret[0];
					
					var oTr = document.createElement("TR");
					oTr.appendChild(oTd0);
					oTr.appendChild(oTd1);
					oTr.appendChild(oTd2);
					oTr.appendChild(oTd3);
					document.getElementById("gridEnv").addRow(oTr);
				}
			}
		}
	}
	rets.onclose=function(){
		doLoad(this.returnValue);
	}
	/*if (window.navigator.appVersion.indexOf("MSIE")<0){
		var aux=rets.document;
		var isOpen=true;
		rets.onunload=function(event){
			event.cancelBubble=true;
			if(!isOpen){
				doLoad(rets.returnValue);
			}
			isOpen=false;
	    }
    }else{
		doLoad(rets);
	}*/
}

function btnDelEnv_click() {
	document.getElementById("gridEnv").removeSelected();
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