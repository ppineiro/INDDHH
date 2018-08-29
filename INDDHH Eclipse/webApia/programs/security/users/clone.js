function btnConf_click(){
	if (verifyRequiredObjects()) {
		if(isValidName(document.getElementById("txtUsrLogin").value)){
			document.getElementById("frmMain").action = "security.UserAction.do?action=confClone";
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
		document.getElementById("frmMain").action = "security.UserAction.do?action=backToList";
		submitForm(document.getElementById("frmMain"));
	}
}

function searchExt(){
	var rets = openModal("/programs/modals/users.jsp?external=true",500,300);
	var doAfter=function(rets){
		if(rets != null) {
			var ret = rets[0];
			document.getElementById("txtUsrLogin").value = ret[0];
			document.getElementById("txtPwd").value = ret[0];
			document.getElementById("txtName").value = ret[1];
			document.getElementById("txtEmail").value = ret[2];
			document.getElementById("txtComments").value = ret[3];
		}
	}
	rets.onclose=function(){
		doAfter(rets.returnValue);
	}
 
}