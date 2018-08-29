function btnConf_click(){
	if (verifyRequiredObjects() && chkPassLength()) {
		
			document.getElementById("frmMain").action = "configuration.ParametersAction.do?action=change"+windowId;
			submitForm(document.getElementById("frmMain"));
		
	}
}
function chatActiviate(msg){
	if (confirm(msg)) {
		document.getElementById("frmMain").action = "configuration.ParametersAction.do?action=chatActivate"+windowId;
		submitForm(document.getElementById("frmMain"));
	}
}
function btnExit_click(){
	splash();
}

function btnTestEmail_click() {
	document.getElementById("frmMain").action = "configuration.ParametersAction.do?action=testEmail"+windowId;
	submitForm(document.getElementById("frmMain"));
}

function btnTestAll_click() {
	document.getElementById("frmMain").action = "configuration.ParametersAction.do?action=testParameters"+windowId;
	submitForm(document.getElementById("frmMain"));
}

function btnTestGenLocation_click() {
	document.getElementById("frmMain").action = "configuration.ParametersAction.do?action=testGenLoc"+windowId;
	submitForm(document.getElementById("frmMain"));
}

function btnTestCVS_click() {
	document.getElementById("frmMain").action = "configuration.ParametersAction.do?action=testCVS"+windowId;
	submitForm(document.getElementById("frmMain"));
}

function btnTestFTP_click() {
	document.getElementById("frmMain").action = "configuration.ParametersAction.do?action=testFTP"+windowId;
	submitForm(document.getElementById("frmMain"));
}

function btnTestIndexDoc_click() {
	document.getElementById("frmMain").action = "configuration.ParametersAction.do?action=testIndexDoc"+windowId;
	submitForm(document.getElementById("frmMain"));
}

function btnTestAuth_click() {
	document.getElementById("frmMain").action = "configuration.ParametersAction.do?action=testAuthentication"+windowId;
	submitForm(document.getElementById("frmMain"));
}

function chkEnvCbe(obj){
	var father = obj.parentNode;
	while(father.tagName!="TR"){
		father=father.parentNode;
	}
	var cells = father.cells;
	if(cells[2].getElementsByTagName("INPUT")[0].checked){
		if (!cells[3].getElementsByTagName("INPUT")[0].checked){
			var sel=cells[4].getElementsByTagName("SELECT")[0].options[1].selected=true;
		}
	}else if (!cells[3].getElementsByTagName("INPUT")[0].checked){
		var sel=cells[4].getElementsByTagName("SELECT")[0].options[0].selected=true;
	}
}

function chkAllEnvCbe(obj){
	var father = obj.parentNode;
	while(father.tagName!="TR"){
		father=father.parentNode;
	}
	var cells = father.cells;
	
	if(cells[3].getElementsByTagName("INPUT")[0].checked){
		if (!cells[2].getElementsByTagName("INPUT")[0].checked){
			var sel=cells[4].getElementsByTagName("SELECT")[0].options[1].selected=true;
		}
	}else if (!cells[2].getElementsByTagName("INPUT")[0].checked){
		var sel=cells[4].getElementsByTagName("SELECT")[0].options[0].selected=true;
	}
}

window.onload=function() {
	prmtAutMethod_onchange();
	prmtDocType_onchange();
	prmtSignOn_onchange();
	prmtBIProUpdMethFunc();
//	checkIndexState();
	docIndexOnchange()
	digitalSignChange();
	document.getElementById("prmtMaxDayNot").onblur=function(){
	if(document.getElementById("prmtMaxDayNot").value <= 0){
		document.getElementById("prmtMaxDayNot").value = 7;
	}
	}
	
	
	document.getElementById("prmtSignInClient").onchange=function(){
		digitalSignChange();
	}
	
	document.getElementById("prmtMaxResultNot").onblur=function(){
		if(document.getElementById("prmtMaxResultNot").value <= 0){
			document.getElementById("prmtMaxResultNot").value = 10;
		}
	}
	if(document.getElementById("prmtQueImpl").value == "SWIFTMQ"){
		document.getElementById("prmtQueSwiftRouter").parentNode.parentNode.style.display = "";
		document.getElementById("prmtQueChannel").parentNode.parentNode.style.display = "none";
		document.getElementById("prmtQueManager").parentNode.parentNode.style.display = "none";
	} else if (document.getElementById("prmtQueImpl").value == "WEBSPHERE"){
		document.getElementById("prmtQueSwiftRouter").parentNode.parentNode.style.display = "none";
		document.getElementById("prmtQueChannel").parentNode.parentNode.style.display = "";
		document.getElementById("prmtQueManager").parentNode.parentNode.style.display = "";
	} else {
		document.getElementById("prmtQueSwiftRouter").parentNode.parentNode.style.display = "none";
		document.getElementById("prmtQueChannel").parentNode.parentNode.style.display = "none";
		document.getElementById("prmtQueManager").parentNode.parentNode.style.display = "none";
	}
	prmtUseQueue_onchange();
	if (document.getElementById("prmtDocEncActive").value == "false"){
		//ocultamos el input con el password de BDDocuments y el combo
		document.getElementById("prmtDocumentDBPwd").className = "txtReadOnly";
		document.getElementById("prmtDocumentDBPwd").setAttribute("readOnly","true");
		document.getElementById("prmtDocumentDBPwd").value = '';
	}
	document.getElementById("prmtDocumentDBPwd").maxLength =8;
	document.getElementById("prmtDocumentDBPwd").onchange = chkPassLength;
	fncChangeChat();
	fncChangeEscape();
	fncChangeInitProc();
}

function hideAllAuth(){
		document.getElementById("prmtAuthClass").className = "txtReadOnly";
		document.getElementById("prmtLdapProvider").className = "txtReadOnly";
		document.getElementById("prmtLdapOrganization").className = "txtReadOnly";
		document.getElementById("prmtLdapRootUser").className = "txtReadOnly";
		document.getElementById("prmtLdapRootPwd").className = "txtReadOnly";
		document.getElementById("prmtLdapAttName").className = "txtReadOnly";
		document.getElementById("prmtLdapAttMail").className = "txtReadOnly";
		document.getElementById("prmtLdapAttComm").className = "txtReadOnly";
		document.getElementById("prmtLdapADDomain").className = "txtReadOnly";
		document.getElementById("prmtLdapAttLogin").className = "txtReadOnly";
		
		
		
		document.getElementById("prmtAuthClass").setAttribute("readOnly","true");
		document.getElementById("prmtLdapProvider").setAttribute("readOnly","true");
		document.getElementById("prmtLdapOrganization").setAttribute("readOnly","true");
		document.getElementById("prmtLdapRootUser").setAttribute("readOnly","true");
		document.getElementById("prmtLdapRootPwd").setAttribute("readOnly","true");
		document.getElementById("prmtLdapAttName").setAttribute("readOnly","true");
		document.getElementById("prmtLdapAttMail").setAttribute("readOnly","true");
		document.getElementById("prmtLdapAttComm").setAttribute("readOnly","true");
		document.getElementById("prmtLdapADDomain").setAttribute("readOnly","true");
		document.getElementById("prmtLdapAttLogin").setAttribute("readOnly","true");
		
		
		unsetRequiredField(document.getElementById("prmtAuthClass"));
		unsetRequiredField(document.getElementById("prmtLdapProvider"));
		unsetRequiredField(document.getElementById("prmtLdapOrganization"));
		unsetRequiredField(document.getElementById("prmtLdapOrganization"));
		unsetRequiredField(document.getElementById("prmtLdapRootUser"));
		unsetRequiredField(document.getElementById("prmtLdapRootPwd"));
		unsetRequiredField(document.getElementById("prmtLdapAttName"));
		unsetRequiredField(document.getElementById("prmtLdapAttMail"));
		unsetRequiredField(document.getElementById("prmtLdapAttComm"));
		
		unsetRequiredField(document.getElementById("prmtLdapADDomain"));
		unsetRequiredField(document.getElementById("prmtLdapAttLogin"));
		

document.getElementById("prmtAutFull").style.visibility = "hidden";
document.getElementById("prmtAutFull").parentNode.parentNode.style.visibility = "hidden";
}

function hideAllCVS() {

	document.getElementById("prmtDocCVSUsu").className = "txtReadOnly";
	document.getElementById("prmtDocCVSRep").className = "txtReadOnly";
	document.getElementById("prmtDocCVSPas").className = "txtReadOnly";
	document.getElementById("prmtDocCVSRoot").className = "txtReadOnly";
	document.getElementById("prmtDocCVSHost").className = "txtReadOnly";

	document.getElementById("prmtDocCVSUsu").setAttribute("readOnly","true");
	document.getElementById("prmtDocCVSRep").setAttribute("readOnly","true");
	document.getElementById("prmtDocCVSPas").setAttribute("readOnly","true");
	document.getElementById("prmtDocCVSRoot").setAttribute("readOnly","true");
	document.getElementById("prmtDocCVSHost").setAttribute("readOnly","true");	

	unsetRequiredField(document.getElementById("prmtDocCVSUsu"));
	unsetRequiredField(document.getElementById("prmtDocCVSRep"));
	unsetRequiredField(document.getElementById("prmtDocCVSPas"));
	unsetRequiredField(document.getElementById("prmtDocCVSRoot"));
	unsetRequiredField(document.getElementById("prmtDocCVSHost"));
}

function hideAllFTP() {

	document.getElementById("prmtFTPDocStorage").className = "txtReadOnly";
	document.getElementById("prmtFTPHost").className = "txtReadOnly";
	document.getElementById("prmtFTPPort").className = "txtReadOnly";
	document.getElementById("prmtFTPUser").className = "txtReadOnly";
	document.getElementById("prmtFTPPassword").className = "txtReadOnly";

	document.getElementById("prmtFTPDocStorage").setAttribute("readOnly","true");
	document.getElementById("prmtFTPHost").setAttribute("readOnly","true");
	document.getElementById("prmtFTPPort").setAttribute("readOnly","true");
	document.getElementById("prmtFTPUser").setAttribute("readOnly","true");
	document.getElementById("prmtFTPPassword").setAttribute("readOnly","true");

	unsetRequiredField(document.getElementById("prmtFTPDocStorage"));
	unsetRequiredField(document.getElementById("prmtFTPHost"));
	unsetRequiredField(document.getElementById("prmtFTPPort"));
	unsetRequiredField(document.getElementById("prmtFTPUser"));
	unsetRequiredField(document.getElementById("prmtFTPPassword"));
}


function prmtDocType_onchange() {

	if(document.getElementById("prmtDocType").value == "0"){
		hideAllCVS();
		hideAllFTP();
		document.getElementById("btnTestCVS").style.visibility = "hidden";
		document.getElementById("btnTestFTP").style.visibility = "hidden";

		//ocultamos el input con el password de BDDocuments y el combo
		document.getElementById("prmtDocumentDBPwd").className = "txtReadOnly";
		document.getElementById("prmtDocumentDBPwd").setAttribute("readOnly","true");
		document.getElementById("prmtDocumentDBPwd").value = '';
		
		document.getElementById("prmtDocEncActive").disabled = true;
		unsetRequiredField(document.getElementById("prmtDocEncActive"));
		document.getElementById("prmtDocEncActive").value = "false";
		
	} else if (document.getElementById("prmtDocType").value == "1"){
		hideAllFTP();
		document.getElementById("prmtDocCVSUsu").className = "";
		document.getElementById("prmtDocCVSRep").className = "";
		document.getElementById("prmtDocCVSPas").className = "";
		document.getElementById("prmtDocCVSRoot").className = "";
		document.getElementById("prmtDocCVSHost").className = "";

		document.getElementById("prmtDocCVSUsu").readOnly=false;
		document.getElementById("prmtDocCVSRep").readOnly=false;
		document.getElementById("prmtDocCVSPas").readOnly=false;
		document.getElementById("prmtDocCVSRoot").readOnly=false;
		document.getElementById("prmtDocCVSHost").readOnly=false;	

		setRequiredField(document.getElementById("prmtDocCVSUsu"));
		setRequiredField(document.getElementById("prmtDocCVSRep"));
		setRequiredField(document.getElementById("prmtDocCVSPas"));
		setRequiredField(document.getElementById("prmtDocCVSRoot"));
		setRequiredField(document.getElementById("prmtDocCVSHost"));
		
		document.getElementById("btnTestCVS").style.visibility = "visible";
		document.getElementById("btnTestFTP").style.visibility = "hidden";
		
		//ocultamos el input con el password de BDDocuments y el combo
		document.getElementById("prmtDocumentDBPwd").className = "txtReadOnly";
		document.getElementById("prmtDocumentDBPwd").setAttribute("readOnly","true");
		document.getElementById("prmtDocumentDBPwd").value = '';
		
		document.getElementById("prmtDocEncActive").disabled = true;
		unsetRequiredField(document.getElementById("prmtDocEncActive"));
		document.getElementById("prmtDocEncActive").value = "false";
		
	} else if (document.getElementById("prmtDocType").value == "2"){
		hideAllCVS();
		hideAllFTP();
		document.getElementById("btnTestCVS").style.visibility = "hidden";
		document.getElementById("btnTestFTP").style.visibility = "hidden";
		
		//hacemos visible el combo para seleccionar si desea ingresar clave de encriptacion
		document.getElementById("prmtDocEncActive").disabled = false;
		setRequiredField(document.getElementById("prmtDocEncActive"));
		
	}  else if (document.getElementById("prmtDocType").value == "3"){
		hideAllCVS();
		document.getElementById("btnTestCVS").style.visibility = "hidden";
		document.getElementById("btnTestFTP").style.visibility = "visible";
		
		//ocultamos el input con el password de BDDocuments y el combo
		document.getElementById("prmtDocumentDBPwd").className = "txtReadOnly";
		document.getElementById("prmtDocumentDBPwd").setAttribute("readOnly","true");
		document.getElementById("prmtDocumentDBPwd").value = '';
		
		document.getElementById("prmtDocEncActive").disabled = true;
		unsetRequiredField(document.getElementById("prmtDocEncActive"));
		document.getElementById("prmtDocEncActive").value = "false";
		
		//Hacemos visible los input de ftp
		document.getElementById("prmtFTPDocStorage").className = "";
		document.getElementById("prmtFTPHost").className = "";
		document.getElementById("prmtFTPPort").className = "";
		document.getElementById("prmtFTPUser").className = "";
		document.getElementById("prmtFTPPassword").className = "";

		document.getElementById("prmtFTPDocStorage").readOnly=false;
		document.getElementById("prmtFTPHost").readOnly=false;
		document.getElementById("prmtFTPPort").readOnly=false;
		document.getElementById("prmtFTPUser").readOnly=false;
		document.getElementById("prmtFTPPassword").readOnly=false;

		setRequiredField(document.getElementById("prmtFTPDocStorage"));
		setRequiredField(document.getElementById("prmtFTPHost"));
		setRequiredField(document.getElementById("prmtFTPPort"));
		setRequiredField(document.getElementById("prmtFTPUser"));
		setRequiredField(document.getElementById("prmtFTPPassword"));
		
	}  else if (document.getElementById("prmtDocType").value == "4"){
		hideAllCVS();
		document.getElementById("btnTestCVS").style.visibility = "hidden";
		document.getElementById("btnTestFTP").style.visibility = "visible";
		
		//ocultamos el input con el password de BDDocuments y el combo
		document.getElementById("prmtDocumentDBPwd").className = "txtReadOnly";
		document.getElementById("prmtDocumentDBPwd").setAttribute("readOnly","true");
		document.getElementById("prmtDocumentDBPwd").value = '';
		
		document.getElementById("prmtDocEncActive").disabled = true;
		unsetRequiredField(document.getElementById("prmtDocEncActive"));
		document.getElementById("prmtDocEncActive").value = "false";
		
		//Hacemos visible los input de ftp
		document.getElementById("prmtFTPDocStorage").className = "";
		document.getElementById("prmtFTPHost").className = "";
		document.getElementById("prmtFTPPort").className = "";
		document.getElementById("prmtFTPUser").className = "";
		document.getElementById("prmtFTPPassword").className = "";

		document.getElementById("prmtFTPDocStorage").readOnly=false;
		document.getElementById("prmtFTPHost").readOnly=false;
		document.getElementById("prmtFTPPort").readOnly=false;
		document.getElementById("prmtFTPUser").readOnly=false;
		document.getElementById("prmtFTPPassword").readOnly=false;

		setRequiredField(document.getElementById("prmtFTPDocStorage"));
		setRequiredField(document.getElementById("prmtFTPHost"));
		setRequiredField(document.getElementById("prmtFTPPort"));
		setRequiredField(document.getElementById("prmtFTPUser"));
		setRequiredField(document.getElementById("prmtFTPPassword"));
	}
}

function chkPassLength(){
	if (document.getElementById("prmtDocEncActive").value == "true"){
		var len = document.getElementById("prmtDocumentDBPwd").value.length;
		if (len < 8){
			document.getElementById("prmtDocumentDBPwd").value = '';
			document.getElementById("prmtDocumentDBPwd").focus();
			alert(MSG_WRNG_PASS);
			return false;
		}
	}
	return true;
}

function prmtUseQueue_onchange(){

	if(document.getElementById("prmtUseMailQueue").value == "false"){
	
		document.getElementById("prmtQueImpl").className = "txtReadOnly";
		document.getElementById("prmtQueServer").className = "txtReadOnly";
		document.getElementById("prmtQuePort").className = "txtReadOnly";
		document.getElementById("prmtQueUser").className = "txtReadOnly";
		document.getElementById("prmtQuePassword").className = "txtReadOnly";
		document.getElementById("prmtQueName").className = "txtReadOnly";
		document.getElementById("prmtQueSwiftRouter").className = "txtReadOnly";
		document.getElementById("prmtQueManager").className = "txtReadOnly";
		document.getElementById("prmtQueChannel").className = "txtReadOnly";	
		document.getElementById("prmtQueImpl").className = "txtReadOnly";
		
		unsetRequiredField(document.getElementById("prmtQueServer"));
		unsetRequiredField(document.getElementById("prmtQuePort"));
		unsetRequiredField(document.getElementById("prmtQueName"));
		unsetRequiredField(document.getElementById("prmtQueSwiftRouter"));
		unsetRequiredField(document.getElementById("prmtQueManager"));
		unsetRequiredField(document.getElementById("prmtQueChannel"));
			
		document.getElementById("prmtQueImpl").readOnly=true;
		document.getElementById("prmtQueServer").readOnly=true;
		document.getElementById("prmtQuePort").readOnly=true;
		document.getElementById("prmtQueUser").readOnly=true;
		document.getElementById("prmtQuePassword").readOnly=true;
		document.getElementById("prmtQueName").readOnly=true;
		document.getElementById("prmtQueSwiftRouter").readOnly=true;
		document.getElementById("prmtQueManager").readOnly=true;
		document.getElementById("prmtQueChannel").readOnly=true;
		document.getElementById("prmtQueImpl").readOnly=true;
		document.getElementById("prmtQueImpl").disabled=true;
		document.getElementById("prmtQueImpl").style.display="none";
		var input=document.createElement("INPUT");
		input.value=document.getElementById("prmtQueImpl").value;
		input.name=document.getElementById("prmtQueImpl").name;
		input.readOnly=true;
		input.className="txtReadOnly";
		document.getElementById("prmtQueImpl").parentNode.appendChild(input);
	} else {
		document.getElementById("prmtQueImpl").className = "";
		document.getElementById("prmtQueServer").className = "";
		document.getElementById("prmtQuePort").className = "";
		document.getElementById("prmtQueUser").className = "";
		document.getElementById("prmtQuePassword").className = "";
		document.getElementById("prmtQueName").className = "";
		document.getElementById("prmtQueSwiftRouter").className = "";
		document.getElementById("prmtQueManager").className = "";
		document.getElementById("prmtQueChannel").className = "";	
		document.getElementById("prmtQueImpl").className = "";	
		
		
		setRequiredField(document.getElementById("prmtQueServer"));
		setRequiredField(document.getElementById("prmtQuePort"));
		setRequiredField(document.getElementById("prmtQueName"));
		setRequiredField(document.getElementById("prmtQueSwiftRouter"));
		setRequiredField(document.getElementById("prmtQueManager"));
		setRequiredField(document.getElementById("prmtQueChannel"));
	
		document.getElementById("prmtQueImpl").readOnly=false;
		document.getElementById("prmtQueServer").readOnly=false;
		document.getElementById("prmtQuePort").readOnly=false;
		document.getElementById("prmtQueUser").readOnly=false;
		document.getElementById("prmtQuePassword").readOnly=false;
		document.getElementById("prmtQueName").readOnly=false;
		document.getElementById("prmtQueSwiftRouter").readOnly=false;
		document.getElementById("prmtQueManager").readOnly=false;
		document.getElementById("prmtQueChannel").readOnly=false;
		document.getElementById("prmtQueImpl").readOnly=false;
		document.getElementById("prmtQueImpl").disabled=false;
		document.getElementById("prmtQueImpl").style.display="";
		var input=document.getElementById("prmtQueImpl").parentNode.getElementsByTagName("INPUT")[0];
		if(input){
			input.parentNode.removeChild(input);
		}
	
	}
}

function prmtQueImpl_onchange(){

	if(document.getElementById("prmtQueImpl").value == "SWIFTMQ"){
		document.getElementById("prmtQueSwiftRouter").parentNode.parentNode.style.display = "";
		document.getElementById("prmtQueChannel").parentNode.parentNode.style.display = "none";
		document.getElementById("prmtQueManager").parentNode.parentNode.style.display = "none";
	} else if (document.getElementById("prmtQueImpl").value == "WEBSPHERE"){
		document.getElementById("prmtQueSwiftRouter").parentNode.parentNode.style.display = "none";
		document.getElementById("prmtQueChannel").parentNode.parentNode.style.display = "";
		document.getElementById("prmtQueManager").parentNode.parentNode.style.display = "";
	} else {
		document.getElementById("prmtQueSwiftRouter").parentNode.parentNode.style.display = "none";
		document.getElementById("prmtQueChannel").parentNode.parentNode.style.display = "none";
		document.getElementById("prmtQueManager").parentNode.parentNode.style.display = "none";
	}
}

function prmtAutMethod_onchange(){
	if(document.getElementById("prmtAutMethod") == null) return;
	
	if(document.getElementById("prmtAutMethod").value == "0"){
		hideAllAuth();
		
		document.getElementById("btnTestAuth").style.visibility = "hidden";
	} else if (document.getElementById("prmtAutMethod").value == "1"){
		hideAllAuth();
		document.getElementById("prmtLdapProvider").className = "";
		document.getElementById("prmtLdapOrganization").className = "";
		document.getElementById("prmtLdapRootUser").className = "";
		document.getElementById("prmtLdapRootPwd").className = "";
		document.getElementById("prmtLdapADDomain").className = "";
		document.getElementById("prmtLdapAttLogin").className = "";
		
		
//		document.getElementById("prmtDocIndexPath").readOnly=false;
		document.getElementById("prmtLdapProvider").readOnly=false;
		document.getElementById("prmtLdapOrganization").readOnly=false;
		document.getElementById("prmtLdapRootUser").readOnly=false;
		document.getElementById("prmtLdapRootPwd").readOnly=false;
		document.getElementById("prmtLdapADDomain").readOnly=false;
		document.getElementById("prmtLdapAttLogin").readOnly=false;
		
		setRequiredField(document.getElementById("prmtLdapProvider"));
		setRequiredField(document.getElementById("prmtLdapOrganization"));
		setRequiredField(document.getElementById("prmtLdapRootUser"));
		setRequiredField(document.getElementById("prmtLdapRootPwd"));
		
		setRequiredField(document.getElementById("prmtLdapADDomain"));
		setRequiredField(document.getElementById("prmtLdapAttLogin"));
		
		document.getElementById("btnTestAuth").style.visibility = "visible";	
		
	} else if (document.getElementById("prmtAutMethod").value == "2"){
		hideAllAuth();
		document.getElementById("prmtLdapProvider").className = "";
		document.getElementById("prmtLdapOrganization").className = "";
		document.getElementById("prmtLdapRootUser").className = "";
		document.getElementById("prmtLdapRootPwd").className = "";
		document.getElementById("prmtLdapAttName").className = "";
		document.getElementById("prmtLdapAttMail").className = "";
		document.getElementById("prmtLdapAttComm").className = "";
		
		document.getElementById("prmtLdapADDomain").className = "";
		document.getElementById("prmtLdapAttLogin").className = "";
		
		
		document.getElementById("prmtLdapProvider").readOnly=false;
		document.getElementById("prmtLdapOrganization").readOnly=false;
		document.getElementById("prmtLdapRootUser").readOnly=false;
		document.getElementById("prmtLdapRootPwd").readOnly=false;
		document.getElementById("prmtLdapAttName").readOnly=false;
		document.getElementById("prmtLdapAttMail").readOnly=false;
		document.getElementById("prmtLdapAttComm").readOnly=false;
		document.getElementById("prmtLdapADDomain").readOnly=false;
		document.getElementById("prmtLdapAttLogin").readOnly=false;
		
		
		setRequiredField(document.getElementById("prmtLdapProvider"));
		setRequiredField(document.getElementById("prmtLdapOrganization"));
		setRequiredField(document.getElementById("prmtLdapRootUser"));
		setRequiredField(document.getElementById("prmtLdapRootPwd"));
		setRequiredField(document.getElementById("prmtLdapAttName"));
		setRequiredField(document.getElementById("prmtLdapAttMail"));
		setRequiredField(document.getElementById("prmtLdapAttComm"));
		setRequiredField(document.getElementById("prmtLdapADDomain"));
		setRequiredField(document.getElementById("prmtLdapAttLogin"));
		
		document.getElementById("prmtAutFull").style.visibility = "visible";		
		document.getElementById("prmtAutFull").parentNode.parentNode.style.visibility = "visible";
		
		document.getElementById("btnTestAuth").style.visibility = "visible";	
	} else if (	document.getElementById("prmtAutMethod").value == "3"){
		hideAllAuth();
		document.getElementById("prmtAuthClass").className = "";
		document.getElementById("prmtAuthClass").readOnly=false;
		
		setRequiredField(document.getElementById("prmtAuthClass"));

		document.getElementById("prmtAutFull").style.visibility = "visible";		
		document.getElementById("prmtAutFull").parentNode.parentNode.style.visibility = "visible";
		
		
		document.getElementById("btnTestAuth").style.visibility = "hidden";
	}
}

function fncChangeChat(){
	var obj = null;
	
	obj = document.getElementById("prmtApiaChatActive");
	var serverActive = obj != null && (obj.value=="true" || obj.value==true)
	
	obj = document.getElementById("prmtApiaChatModeClie");
	var clientActive = obj.value=="true" || obj.value==true;
	
	obj = document.getElementById("prmtApiaChatCoreCli");
	var clientCoreActive = obj.value=="true" || obj.value==true;
	
	document.getElementById("prmtMaxResultNotChat").readOnly= ! clientActive;

	document.getElementById("prmtApiaChatUrl").readOnly= !(serverActive || clientActive || clientCoreActive);
	document.getElementById("prmtApiaChatUrl").className = (serverActive || clientActive || clientCoreActive) ? "" : "txtReadOnly";
	if (serverActive || clientActive || clientCoreActive) { setRequiredField(document.getElementById("prmtApiaChatUrl")); } else { unsetRequiredField(document.getElementById("prmtApiaChatUrl")); }
	
	document.getElementById("prmtApiaServerNode").disabled = ! serverActive;
	
	document.getElementById("prmtApiaChatSave").disabled = ! serverActive;
	if (serverActive) { setRequiredField(document.getElementById("prmtApiaChatSave")); } else { unsetRequiredField(document.getElementById("prmtApiaChatSave")); }
	
	document.getElementById("prmtApiaChatCoreFreq").disabled = ! clientCoreActive;
	if (clientCoreActive) { setRequiredField(document.getElementById("prmtApiaChatCoreFreq")); } else { unsetRequiredField(document.getElementById("prmtApiaChatCoreFreq")); }
	
	document.getElementById("prmtApiaChatFreqCall").disabled = ! serverActive;
	unsetRequiredField(document.getElementById("prmtApiaChatFreqCall"));
	if (serverActive) { setRequiredField(document.getElementById("prmtApiaChatFreqCall")); } else { unsetRequiredField(document.getElementById("prmtApiaChatFreqCall")); }
	
	document.getElementById("prmtApiaChatIndex").disabled = ! serverActive;
	unsetRequiredField(document.getElementById("prmtApiaChatIndex"));
	if (serverActive) { setRequiredField(document.getElementById("prmtApiaChatIndex")); } else { unsetRequiredField(document.getElementById("prmtApiaChatIndex")); }
	
	fncChangeChatSave();
}

function fncChangeChatSave() {
	var obj = document.getElementById("prmtApiaChatSave");
	if (obj==null) return;
	
	if(obj.value=="false" || obj.value==false || obj.disabled){
		document.getElementById("prmtApiaChatSaveAt").readOnly=true;
		document.getElementById("prmtApiaChatSaveAt").className = "txtReadOnly";
		document.getElementById("prmtApiaChatSaveAt").value = "";
		unsetRequiredField(document.getElementById("prmtApiaChatSaveAt"));
		
		document.getElementById("prmtApiaChatIndex").disabled=true;
		unsetRequiredField(document.getElementById("prmtApiaChatIndex"));
	}else{
		document.getElementById("prmtApiaChatSaveAt").readOnly=false;
		document.getElementById("prmtApiaChatSaveAt").className = "";
		setRequiredField(document.getElementById("prmtApiaChatSaveAt"));
		
		document.getElementById("prmtApiaChatIndex").disabled=false;
		setRequiredField(document.getElementById("prmtApiaChatIndex"));
	}
	
	fncChangeChatIndex();
}

function fncChangeChatIndex() {
	var obj = document.getElementById("prmtApiaChatIndex");
	if (obj==null) return;
	
	if(obj.value=="false" || obj.value==false || obj.disabled){
		document.getElementById("prmtApiaChatIndexAt").readOnly=true;
		document.getElementById("prmtApiaChatIndexAt").className = "txtReadOnly";
		document.getElementById("prmtApiaChatIndexAt").value = "";
		unsetRequiredField(document.getElementById("prmtApiaChatIndexAt"));
	}else{
		document.getElementById("prmtApiaChatIndexAt").readOnly=false;
		document.getElementById("prmtApiaChatIndexAt").className = "";
		setRequiredField(document.getElementById("prmtApiaChatIndexAt"));
	}
}

function prmtSignOn_onchange() {

	/*if(document.getElementById("prmtSSignOn").value=="false"){
		document.getElementById("prmtSSignOnClass").className = "txtReadOnly";
		document.getElementById("prmtSSignOnClass").setAttribute("readOnly","true");		
		document.getElementById("prmtSSignOnClass").p_required = false;		
	} else {
		document.getElementById("prmtSSignOnClass").className = "";
		document.getElementById("prmtSSignOnClass").readOnly=false;			
		document.getElementById("prmtSSignOnClass").p_required = true;				
	}*/
}

function checkIndexState() {
	if (actualIndexState) {
		document.getElementById("prmtDocIndexActiveCre").disabled = true;
	} else {
		document.getElementById("prmtDocIndexActiveCre").disabled = document.getElementById("prmtDocIndexActive").value == "false";
	}
	
}

function docIndexOnchange() {

	if(document.getElementById("prmtDocIndexActive").value == "true"){

		document.getElementById("prmtDocIndexPath").readOnly=false;
		document.getElementById("prmtDocIndexPath").className = "";
		setRequiredField(document.getElementById("prmtDocIndexPath"));
		
		document.getElementById("btnTestIndexDoc").style.visibility = "visible";
		//document.getElementById("prmtDocIndexBatch").readOnly=false;
		//document.getElementById("prmtDocIndexBatch").className = "";
		document.getElementById("prmtDocIndexBatch").disabled = false;
		setRequiredField(document.getElementById("prmtDocIndexBatch"));

	} else {
		document.getElementById("prmtDocIndexPath").setAttribute("readOnly","true");
		document.getElementById("prmtDocIndexPath").className = "txtReadOnly";
		unsetRequiredField(document.getElementById("prmtDocIndexPath"));
		document.getElementById("btnTestIndexDoc").style.visibility = "hidden";
		//document.getElementById("prmtDocIndexPath").setAttribute("readOnly","true");
		//document.getElementById("prmtDocIndexPath").className = "txtReadOnly";
		unsetRequiredField(document.getElementById("prmtDocIndexBatch"));
		document.getElementById("prmtDocIndexBatch").disabled = true;
	}
}

function docEncOnchange() {

	if(document.getElementById("prmtDocEncActive").value == "true"){

		//hacemos visible el input con el password de BDDocuments
		document.getElementById("prmtDocumentDBPwd").className = "";
		document.getElementById("prmtDocumentDBPwd").readOnly=false;
		document.getElementById("prmtDocumentDBPwd").maxLength =8;
		document.getElementById("prmtDocumentDBPwd").onchange = chkPassLength;
	} else {

		//ocultamos el input con el password de BDDocuments
		document.getElementById("prmtDocumentDBPwd").className = "txtReadOnly";
		document.getElementById("prmtDocumentDBPwd").setAttribute("readOnly","true");
		document.getElementById("prmtDocumentDBPwd").value = '';
	}
}

function prmtBIgenUpdate(){
	if(document.getElementById("prmtBIGeneralUpdate").value == "true"){
		//hacemos visible las demas propiedades
		document.getElementById("prmtBIEntitiesUpdate").disabled = false;
		document.getElementById("prmtBIActOnErrEntUpd").disabled = false;
		document.getElementById("prmtBIEntCbeUpdVerif").disabled = false;
		
		document.getElementById("prmtBIProcessUpdate").disabled = false;
		document.getElementById("prmtBIProUpdMethod").disabled = false;
		//document.getElementById("prmtBINullValue").disabled = false;
		//document.getElementById("prmtBINullValue").p_required = true;
		document.getElementById("prmtBIEntitiesUpdate").value = "true";
		document.getElementById("prmtBIActOnErrEntUpd").value = 0;
		document.getElementById("prmtBIProcessUpdate").value = "true";
		//document.getElementById("prmtBIProUpdMethod").value = 0;
		
		prmtBIProUpdMethFunc();
	}else{
		//ocultamos las demas propiedades
		document.getElementById("prmtBIEntitiesUpdate").value = "false";
		document.getElementById("prmtBIProcessUpdate").value = "false";
				
		document.getElementById("prmtBIEntitiesUpdate").disabled = true;
		document.getElementById("prmtBIActOnErrEntUpd").disabled = true;
		document.getElementById("prmtBIEntCbeUpdVerif").disabled = true;
		document.getElementById("prmtBIProcessUpdate").disabled = true;
		document.getElementById("prmtBIProUpdMethod").disabled = true;
		//if (document.getElementById("prmtBINullValue").value == ""){
		//	document.getElementById("prmtBINullValue").value = "null";		
		//}
		//document.getElementById("prmtBINullValue").disabled = true;
		//document.getElementById("prmtBINullValue").p_required = false;
		hideAllBIQueueParams();
	}
}

function fncBIExecAnywhere(){
	if(document.getElementById("prmtBIExecAnywhere").value == "true"){
		if (confirm(MSG_BI_EXEC_PARMS_WILL_BE_LOST)) {
			//deshabilitamos las demas propiedades
			document.getElementById("prmtBIExecServer").disabled = true;
			document.getElementById("prmtBIExecPort").disabled = true;
			document.getElementById("prmtBIExecWebName").disabled = true;
			document.getElementById("prmtBIExecUser").disabled = true;
			document.getElementById("prmtBIExecPassword").disabled = true;
			
			document.getElementById("prmtBIExecServer").value = "";
			document.getElementById("prmtBIExecPort").value = "";
			document.getElementById("prmtBIExecWebName").value = "";
			document.getElementById("prmtBIExecUser").value = "";
			document.getElementById("prmtBIExecPassword").value = "";
			
			unsetRequiredField(document.getElementById("prmtBIExecServer"));
			unsetRequiredField(document.getElementById("prmtBIExecPort"));
			unsetRequiredField(document.getElementById("prmtBIExecWebName"));
			unsetRequiredField(document.getElementById("prmtBIExecUser"));
			unsetRequiredField(document.getElementById("prmtBIExecPassword"));
		}else {
			document.getElementById("prmtBIExecAnywhere").value = "false";
		}
	}else{
		//habilitamos las demas propiedades
		document.getElementById("prmtBIExecServer").disabled = false;
		document.getElementById("prmtBIExecPort").disabled = false;
		document.getElementById("prmtBIExecWebName").disabled = false;
		document.getElementById("prmtBIExecUser").disabled = false;
		document.getElementById("prmtBIExecPassword").disabled = false;
		
		setRequiredField(document.getElementById("prmtBIExecServer"));
		setRequiredField(document.getElementById("prmtBIExecPort"));
		setRequiredField(document.getElementById("prmtBIExecWebName"));
		setRequiredField(document.getElementById("prmtBIExecUser"));
		setRequiredField(document.getElementById("prmtBIExecPassword"));
				
	}
}

function disabledBIGrid(){
	var rows = document.getElementById("gridBIParams").rows;
	for(var i=0;i<rows.length;i++){
		rows[i].disabled = true;
	}
}

function enabledBIGrid(){
	var rows = document.getElementById("gridBIParams").rows;
	for(var i=0;i<rows.length;i++){
		rows[i].disabled = false;
	}
}

function prmtBIEntUpdate(){
	if(document.getElementById("prmtBIEntitiesUpdate").value == "true"){
		//hacemos visible las demas propiedades
		document.getElementById("prmtBIActOnErrEntUpd").disabled = false;
	}else{
		//ocultamos las demas propiedades
		document.getElementById("prmtBIActOnErrEntUpd").disabled = true;
	}
}

function prmtBIProUpdate(){
	if(document.getElementById("prmtBIProcessUpdate").value == "true"){
		//hacemos visible las demas propiedades
		document.getElementById("prmtBIProUpdMethod").disabled = false;
//		document.getElementById("prmtBIProUpdMethod").value = 0;
		showAllBIQueueParams();
	}else{
		//ocultamos las demas propiedades
		document.getElementById("prmtBIProUpdMethod").disabled = true;
		hideAllBIQueueParams();
	}
}

function prmtBIProUpdMethFunc(){
	if (document.getElementById("prmtBIProUpdMethod")!=null){
		if(document.getElementById("prmtBIProUpdMethod").value == "1"){ //Cola de mensajes
			showAllBIQueueParams();
		} else if (document.getElementById("prmtBIProUpdMethod").value == "0"){ //Scheduler
			hideAllBIQueueParams();		
		} 
	}
}

function hideAllBIQueueParams(){
	//Implementacion del servidor JMS
	document.getElementById("prmtBIQueImpl").disabled=true;
	unsetRequiredField(document.getElementById("prmtBIQueImpl"));
	//Nombre del servidor
	document.getElementById("prmtBIQueServer").readOnly=true;
	document.getElementById("prmtBIQueServer").className = "txtReadOnly";
	//document.getElementById("prmtBIQueServer").value = "";
	unsetRequiredField(document.getElementById("prmtBIQueServer"));
	//Puerto del servidor
	document.getElementById("prmtBIQuePort").readOnly=true;
	document.getElementById("prmtBIQuePort").className = "txtReadOnly";
	//document.getElementById("prmtBIQuePort").value = "";
	unsetRequiredField(document.getElementById("prmtBIQuePort"));
	//Usuario del servidor
	document.getElementById("prmtBIQueUser").readOnly=true;
	document.getElementById("prmtBIQueUser").className = "txtReadOnly";
	//document.getElementById("prmtBIQueUser").value = "";
	//Contraseña del servidor
	document.getElementById("prmtBIQuePassword").readOnly=true;
	document.getElementById("prmtBIQuePassword").className = "txtReadOnly";
	//document.getElementById("prmtBIQuePassword").value = "";
	//Nombre de Cola
	document.getElementById("prmtBIQueName").readOnly=true;
	document.getElementById("prmtBIQueName").className = "txtReadOnly";
	//document.getElementById("prmtBIQueName").value = "";
	unsetRequiredField(document.getElementById("prmtBIQueName"));
}

function showAllBIQueueParams(){
	 //Implementacion del servidor JMS
	document.getElementById("prmtBIQueImpl").disabled=false;
	setRequiredField(document.getElementById("prmtBIQueImpl"));
	
	//Nombre del servidor
	document.getElementById("prmtBIQueServer").className = "";
	document.getElementById("prmtBIQueServer").readOnly=false;
	setRequiredField(document.getElementById("prmtBIQueServer"));
	
	//Puerto del servidor
	document.getElementById("prmtBIQuePort").className = "";
	document.getElementById("prmtBIQuePort").readOnly=false;
	setRequiredField(document.getElementById("prmtBIQuePort"));
	
	//Usuario del servidor
	document.getElementById("prmtBIQueUser").className = "";
	document.getElementById("prmtBIQueUser").readOnly=false;
	
	//Contraseña del servidor
	document.getElementById("prmtBIQuePassword").className = "";
	document.getElementById("prmtBIQuePassword").readOnly=false;
	
	document.getElementById("prmtBIQueName").disabled = false;
	//Nombre de Cola
	document.getElementById("prmtBIQueName").className = "";
	document.getElementById("prmtBIQueName").readOnly=false;
	setRequiredField(document.getElementById("prmtBIQueName"));
}

/*if (document.addEventListener) {
    document.addEventListener("DOMContentLoaded", setScriptBehaviors, false);
}else{
	setScriptBehaviors();
}*/

function fncChangeEscape(){
	var obj = document.getElementById("prmtUseSqlEscape");
	if (obj==null) return;
	if(obj.value=="false" || obj.value==false){
		document.getElementById("prmtSqlEscapeChar").readOnly=true;
		document.getElementById("prmtSqlEscapeChar").className = "txtReadOnly";
		document.getElementById("prmtSqlEscapeChar").value = "";
		unsetRequiredField(document.getElementById("prmtSqlEscapeChar"));
	}else{
		document.getElementById("prmtSqlEscapeChar").readOnly=false;
		document.getElementById("prmtSqlEscapeChar").className = "";
		setRequiredField(document.getElementById("prmtSqlEscapeChar"));
	}
}

function fncChangeInitProc(){
	var obj = document.getElementById("prmtUseInitProcess");
	if (obj==null) return;
	if(obj.value=="false" || obj.value==false){
		document.getElementById("prmtInitProcess").readOnly=true;
		document.getElementById("prmtInitProcess").className = "txtReadOnly";
		document.getElementById("prmtInitProcess").value = "";
		unsetRequiredField(document.getElementById("prmtInitProcess"));
	}else{
		document.getElementById("prmtInitProcess").readOnly=false;
		document.getElementById("prmtInitProcess").className = "";
		setRequiredField(document.getElementById("prmtInitProcess"));
	}
}

function colorPicker(element) {
	var color = element.previousSibling;
	selectedColor = color;
	var doAfter=function(rets){
		if (rets!=undefined){
			setColor(rets);
		}
	}
	var rets=openModal(("/flash/query/deploy/colorpicker.jsp?selectedColor="+color.value),260,160);
	rets.onclose=function(){
		doAfter(rets.returnValue);
	}
}

function setColor(aColor) {
	selectedColor.value = aColor;
	selectedColor.nextSibling.nextSibling.style.backgroundColor = aColor;
}

function digitalSignChange(){
	if(document.getElementById("prmtSignInClient").value=="false"){
		
		document.getElementById("prmtRootCAs").readOnly=true;
		document.getElementById("prmtRootCAs").className = "txtReadOnly";
		
		document.getElementById("prmtSearchAtts").readOnly=true;
		document.getElementById("prmtSearchAtts").className = "txtReadOnly";
		
		document.getElementById("prmtCheckRevoked").readOnly=true;
		document.getElementById("prmtCheckRevoked").className = "txtReadOnly";
		setBrwsReadOnly(document.getElementById("prmtCheckRevoked"));
		
		document.getElementById("prmtCheckDate").readOnly=true;
		document.getElementById("prmtCheckDate").className = "txtReadOnly";
		setBrwsReadOnly(document.getElementById("prmtCheckDate"));
	}else{
		document.getElementById("prmtRootCAs").readOnly=false;
		document.getElementById("prmtRootCAs").className = "";
		
		document.getElementById("prmtSearchAtts").readOnly=false;
		document.getElementById("prmtSearchAtts").className = "";
		
		document.getElementById("prmtCheckRevoked").readOnly=false;
		document.getElementById("prmtCheckRevoked").className = "";
		unsetBrwsReadOnly(document.getElementById("prmtCheckRevoked"));
		
		document.getElementById("prmtCheckDate").readOnly=false;
		document.getElementById("prmtCheckDate").className = "";
		unsetBrwsReadOnly(document.getElementById("prmtCheckDate"));
	}
	
}