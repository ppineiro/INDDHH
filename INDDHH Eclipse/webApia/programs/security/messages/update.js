window.onload=function(){
ckhPoolClick(document.getElementById("chkAllPools"));
}
function ckhPoolClick(oChk){
	if (oChk.checked == true) { 
		document.getElementById("divPools").style.display="none";
	} else {
		document.getElementById("divPools").style.display="block";
	}
}


function getPoolsString() {
	var auxChkCol = tblPools.getElementsByTagName("INPUT");
	var strPools = "";
	for(i=0; i < auxChkCol.length; i++) {
		if (auxChkCol[i].checked == true) {
			if (strPools == "") {
				strPools = auxChkCol[i].pool_id;
			} else {
				strPools = strPools + GNR_STRING_SEPARATOR + auxChkCol[i].pool_id;
			}
		}
	}
	document.getElementById("txtPools").value = strPools;	
}

function btnConf_click(){
	if (verifyRequiredObjects()) {
		document.getElementById("txtFchDes").disabled = false;
		document.getElementById("frmMain").action = "security.MessagesAction.do?action=confirm";
		submitForm(document.getElementById("frmMain"));
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
		document.getElementById("frmMain").action = "security.MessagesAction.do?action=backToList";
		submitForm(document.getElementById("frmMain"));
	}
}