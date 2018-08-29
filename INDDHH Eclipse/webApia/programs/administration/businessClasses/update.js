function isValidNameExe(s){
	var re = new RegExp("^[a-zA-Z0-9_./]*$");
	if (!s.match(re)) {
		alert(GNR_INVALID_NAME);
		return false;
	}
	return true;
}

function cmbType_onchange(obj) {

	document.getElementById("trWS").style.display="none"; 
	document.getElementById("trDB").style.display="none";
	document.getElementById("trJav").style.display="none";
	document.getElementById("divSubTit").style.display="none"; 
	document.getElementById("trView").style.display="none";
	document.getElementById("trProc").style.display="none";
		
	document.getElementById("txtUrl").p_required="false"; 
	document.getElementById("cmbConn").p_required="false";
	document.getElementById("txtView").p_required="false";
	document.getElementById("txtProc").p_required="false";	
	document.getElementById("txtExe").p_required="false";


	if (TYPE_WS==obj.value) {
	}

	if (TYPE_DB==obj.value) {
		document.getElementById("trDB").style.display="";
		document.getElementById("divSubTit").style.display="";
		document.getElementById("trView").style.display="";
		document.getElementById("trProc").style.display="none";		
				
		document.getElementById("cmbConn").p_required="true";
		document.getElementById("txtView").p_required="true";
	}

	if (TYPE_DB_PROC==obj.value) {
		document.getElementById("trDB").style.display="";
		document.getElementById("divSubTit").style.display="";
		document.getElementById("trView").style.display="none";
		document.getElementById("trProc").style.display="";
				
		document.getElementById("cmbConn").p_required="true";
		document.getElementById("txtProc").p_required="true";
	}	

	if (TYPE_JAV==obj.value || TYPE_SCR==obj.value) {
	}
}

function btnNext_click(){
	var name = document.getElementById("txtName");
	var usePrjPerms = document.getElementById("hidUsePrjPerms").value;
	if (verifyRequiredObjects() && isValidName(name.value)) {
		document.getElementById("frmMain").action = "administration.BusinessClassesAction.do?action=nextUpdate&usePrjPerms=" + usePrjPerms;
		submitForm(document.getElementById("frmMain"));
	}
}

function btnConf_click(){
	if (verifyRequiredObjects()) {
		if (verifyPermissions()){
			if(document.getElementById("txtExe")==null || isValidNameExe(document.getElementById("txtExe").value)){
				document.getElementById("frmMain").action = "administration.BusinessClassesAction.do?action=confirm";
				submitForm(document.getElementById("frmMain"));
			} else {
				document.getElementById("txtExe").focus();
			}
		}
	}
}

function btnExploreWsdl_click(){
	document.getElementById("frmMain").action = "administration.BusinessClassesAction.do?action=exploreWsdl";
	submitForm(document.getElementById("frmMain"));
}

function btnActWsdl_click(){
	document.getElementById("frmMain").action = "administration.BusinessClassesAction.do?action=refreshWsdl";
	submitForm(document.getElementById("frmMain"));
}

function  btnUploadClass_click(){
	
	var ret = openModal("/administration.BusinessClassesAction.do?action=uploadClass",480,300);
	ret.onclose=function(){
		if(ret.returnValue && ret.returnValue!="")
			document.getElementById("txtUploadedPath").value=ret.returnValue;		
	}	
}

function closeModal() {		
	window.parent.close();	
}

function  btnTest_click(){
	if (verifyRequiredObjects()) {
		var usePrjPerms = document.getElementById("usePrjPerms").checked;
		document.getElementById("frmMain").action = "administration.BusinessClassesAction.do?action=test&usePrjPerms=" + usePrjPerms;
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
	if (canWrite()){
		var msg = confirm(GNR_PER_DAT_ING);
		if (msg) {
			document.getElementById("frmMain").action = "administration.BusinessClassesAction.do?action=backToList";
			submitForm(document.getElementById("frmMain"));
		}
	}else{
		document.getElementById("frmMain").action = "administration.BusinessClassesAction.do?action=backToList";
		submitForm(document.getElementById("frmMain"));
	}
}

function btnBackNext_click() {
	var usePrjPerms = document.getElementById("usePrjPerms").checked;
	document.getElementById("frmMain").action = "administration.BusinessClassesAction.do?action=backFirst&usePrjPerms=" + usePrjPerms;
	submitForm(document.getElementById("frmMain"));
}

function selDbConId_change(){
	document.getElementById("frmMain").action = "administration.BusinessClassesAction.do?action=views";
	submitForm(document.getElementById("frmMain"));
}

function cmbMetName_change(){
	var cmb=document.getElementById("cmbMetName");
	for(var i=0;i<cmb.options.length;i++){
		if(cmb.options[i].selected){
			document.getElementById("txtExe").value = cmb.options[i].value;
			document.getElementById("frmMain").action = "administration.BusinessClassesAction.do?action=loadWsParams&method" + cmb.options[i].value;
			submitForm(document.getElementById("frmMain"));
		}		
	}
	
}

function btnAdd_click() {
	addRow();
}

function btnDel_click() {
	document.getElementById("tblParam").removeSelected();
	trows = document.getElementById("tblParam").rows;
	for (i = 0; i<trows.length; i++) {
		document.getElementById("tblParam").setCellInnerHTML(trows[i].getElementsByTagName("TD")[1],(i+1));
	}
}

function btnUp_click() {
	var grid=document.getElementById("tblParam");
	var cant=grid.selectedItems.length;
	if(cant != 0) {
		if(cant == 1) {
			grid.moveSelectedUp();
		} else if (cant > 1) {
			alert(GNR_CHK_ONLY_ONE);
		}
	} else {
		alert(GNR_CHK_AT_LEAST_ONE);
	}
	
}

function btnDown_click() {
	var grid=document.getElementById("tblParam");
	var cant=grid.selectedItems.length;
	if(cant != 0) {
		if(cant == 1) {
			grid.moveSelectedDown();
		} else if (cant > 1) {
			alert(GNR_CHK_ONLY_ONE);
		}
	} else if (cant > 1) {
		alert(GNR_CHK_ONLY_ONE);
	}
}

function swapRows(pos1, pos2) {
	var chkChk1 = document.getElementById("tblShowBody").rows(pos1).cells(0).children(0).checked;
	var chkChk2 = document.getElementById("tblShowBody").rows(pos2).cells(0).children(0).checked;

	document.getElementById("tblShowBody").rows(pos1).swapNode(document.getElementById("tblShowBody").rows(pos2));
	
	document.getElementById("tblShowBody").rows(pos1).cells(0).childNodes(0).checked = chkChk2;
	document.getElementById("tblShowBody").rows(pos1).cells(1).innerText = pos1+1;
	document.getElementById("tblShowBody").rows(pos2).cells(0).children(0).checked = chkChk1;
	document.getElementById("tblShowBody").rows(pos2).cells(1).innerText = pos2+1;	
}

function addRow() {
		var oTr;
		/*if(document.getElementById("tblParam").rows.length>0){
			oTr = document.getElementById("tblParam").rows[0].cloneNode(true);
		}else{*/
			oTr = document.createElement("TR");
			for(var i=0;i<12;i++){
				var td= document.createElement("TD");
				oTr.appendChild(td);
			}
		//}
		
		var oTd0 = oTr.getElementsByTagName("TD")[0];
		var oTd01 = oTr.getElementsByTagName("TD")[1];
		var oTd02 = oTr.getElementsByTagName("TD")[2];
		var oTd11 = oTr.getElementsByTagName("TD")[3];
		var oTd21 = oTr.getElementsByTagName("TD")[4];
		var oTd1 = oTr.getElementsByTagName("TD")[5];
		var oTd5 = oTr.getElementsByTagName("TD")[6];
		var oTd2 = oTr.getElementsByTagName("TD")[7];
		var oTd3 = oTr.getElementsByTagName("TD")[8];
		var oTd6 = oTr.getElementsByTagName("TD")[9];
		var oTd4 = oTr.getElementsByTagName("TD")[10];
		var oTd7 = oTr.getElementsByTagName("TD")[11];
		
		/*var oTd3 = oTr.getElementsByTagName("TD")[9];
		var oTd6 = oTr.getElementsByTagName("TD")[10];
		var oTd4 = oTr.getElementsByTagName("TD")[11];
		var oTd7 = oTr.getElementsByTagName("TD")[8];*/		

		oTd0.style.width="0px";
		oTd0.style.display="none";
		oTd0.innerHTML = "<input type='hidden' name='chkSel'><input type='hidden' name='txtParId'>";
		oTd0.align="center";

		num = (document.getElementById("tblShowBody").getElementsByTagName("TR").length + 1)
		oTd01.innerHTML= num;
		oTd01.align="center";

		oTd02.innerHTML = lblNom + " (" + lblParam + " " + num + ")";
		oTd02.style.display="none";

		oTd1.innerHTML = "<input p_required=true name='txtParName' maxlength='50' size=30 type='text' onblur='valName(this)'>";

		oTd11.style.display="none";
		oTd11.innerHTML = "<input type='hidden' name='txtParReadOnly' value='false'>";
		
		oTd5.innerHTML = "<input name='txtParDesc' maxlength='200' size=30 type='text'>";
		
		if(CLASS_TYPE != TYPE_WS){
			oTd2.innerHTML = "<select name=\"cmbParType\"><option value=\"N\">" + lblNumeric + "</option><option value=\"S\" selected>" + lblString + "</option><option value=\"D\">" + lblDate + "</option></select>";
		}else{
			oTd2.innerHTML = "<select name=\"cmbParType\"><option value=\"N\">" + lblNumeric + "</option><option value=\"S\" selected>" + lblString + "</option><option value=\"D\">" + lblDate + "</option><option value=\"I\">" + lblInt + "</option></select>";
		}
		oTd2.align="center";

		oTd21.innerHTML = lblLargo + " (" + lblParam + " " + document.getElementById("tblShowBody").rows.length + 1 + ")";
		oTd21.style.display="none";

		oTd3.innerHTML = "<input size=4 p_numeric=true name='txtParSize' maxlength='3' type='text'>";
		oTd3.align="center";
		oTd3.style.display="none";
		if (document.getElementById("cmbType").value==TYPE_SCR) {
			oTd4.innerHTML = "<input type=hidden name=\"cmbParInOut\" value=\"Z\">"+lblInOut;
		} else {
			oTd4.innerHTML = "<select name=\"cmbParInOut\"><option value=\"I\">" + lblIn + "</option><option value=\"O\">" + lblOut + "</option><option value=\"Z\" >" + lblInOut + "</option></select>";
		}
		oTd4.align="center";
		
		oTd6.style.display="none";
		oTd6.innerHTML = "<input type='hidden' name='txtInOutReadOnly' value='false'>";

		oTd7.style.display="none";
		oTd7.innerHTML = "<input type='hidden' name='txtHasBinding' value='false'>";

		document.getElementById("tblParam").addRow(oTr);
}

function valName (obj) {
	if(!isValidName(obj.value)){
//		obj.focus();
		obj.value="";
	}
}

function chkPubWs_change(){
	if(document.getElementById("chkPubWs").checked){
		document.getElementById("txtWsName").disabled = false;
		setRequiredField(document.getElementById('txtWsName'));
		document.getElementById("txtWsName").className = "";
	}else{
		document.getElementById("txtWsName").disabled = true;
		document.getElementById("txtWsName").value ="";
		unsetRequiredField(document.getElementById('txtWsName'));
		document.getElementById("txtWsName").className = "txtReadOnly";
	}
}
		
function changeAuthBasic(){
	var usr = document.getElementById("txtAuthUsr");
	var pwd = document.getElementById("txtAuthPwd");

	usr.readOnly = ! document.getElementById("chkBasicAuth").checked;
	pwd.readOnly = ! document.getElementById("chkBasicAuth").checked;
	usr.className = document.getElementById("chkBasicAuth").checked ? "" : "txtReadOnly";
	pwd.className = document.getElementById("chkBasicAuth").checked ? "" : "txtReadOnly";
	
	if (document.getElementById("chkBasicAuth").checked) {
		unsetBrwsReadOnly(usr); 
		unsetBrwsReadOnly(pwd); 
	} else {
		setBrwsReadOnly(usr);
		setBrwsReadOnly(pwd);
	}
}		


function changeWssUT(){
	var usr = document.getElementById("txtWssUTUsr");
	var pwd = document.getElementById("txtWssUTPwd");
	
	usr.readOnly = ! document.getElementById("chkWssUT").checked;
	pwd.readOnly = ! document.getElementById("chkWssUT").checked;
	usr.className = document.getElementById("chkWssUT").checked ? "" : "txtReadOnly";
	pwd.className = document.getElementById("chkWssUT").checked ? "" : "txtReadOnly";
	
	if (document.getElementById("chkWssUT").checked) {
		unsetBrwsReadOnly(usr); 
		unsetBrwsReadOnly(pwd); 
	} else {
		setBrwsReadOnly(usr);
		setBrwsReadOnly(pwd);
	}
}

function changechkWsAddressing(){
	var to = document.getElementById("txtWsAddTo");
	var action = document.getElementById("txtWsAddAction");
	
	to.readOnly = ! document.getElementById("chkWsAddressing").checked;
	action.readOnly = ! document.getElementById("chkWsAddressing").checked;
	to.className = document.getElementById("chkWsAddressing").checked ? "" : "txtReadOnly";
	action.className = document.getElementById("chkWsAddressing").checked ? "" : "txtReadOnly";
	
	if (document.getElementById("chkWsAddressing").checked) {
		unsetBrwsReadOnly(to); 
		unsetBrwsReadOnly(action); 
	} else {
		setBrwsReadOnly(to);
		setBrwsReadOnly(action);
	}	
}

function changechkWsSTS(){
	var url = document.getElementById("txtWsSTSUrl");
	var issuer = document.getElementById("txtWsSTSIssuer");
	var policy = document.getElementById("txtWsSTSPolicy");
	var role = document.getElementById("txtWsSTSRole");
	var user = document.getElementById("txtWsSTSUserName");
	var service = document.getElementById("txtWsSTSService");
	var alias = document.getElementById("txtWsSTSAlias");
	var ksPath = document.getElementById("txtWsSTSKSPath");
	var ksPwd = document.getElementById("txtWsSTSKSPwd");
	var tsPath = document.getElementById("txtWsSTSTSPath");
	var tsPwd = document.getElementById("txtWsSTSTSPwd");
	
	url.readOnly = ! document.getElementById("chkWsSTS").checked;
	issuer.readOnly = ! document.getElementById("chkWsSTS").checked;
	policy.readOnly = ! document.getElementById("chkWsSTS").checked;
	role.readOnly = ! document.getElementById("chkWsSTS").checked;
	user.readOnly = ! document.getElementById("chkWsSTS").checked;
	service.readOnly = ! document.getElementById("chkWsSTS").checked;
	alias.readOnly = ! document.getElementById("chkWsSTS").checked;
	ksPath.readOnly = ! document.getElementById("chkWsSTS").checked;
	ksPwd.readOnly = ! document.getElementById("chkWsSTS").checked;
	tsPath.readOnly = ! document.getElementById("chkWsSTS").checked;
	tsPwd.readOnly = ! document.getElementById("chkWsSTS").checked;
	
	url.className = document.getElementById("chkWsSTS").checked ? "" : "txtReadOnly";
	issuer.className = document.getElementById("chkWsSTS").checked ? "" : "txtReadOnly";
	policy.className = document.getElementById("chkWsSTS").checked ? "" : "txtReadOnly";
	role.className = document.getElementById("chkWsSTS").checked ? "" : "txtReadOnly";
	user.className = document.getElementById("chkWsSTS").checked ? "" : "txtReadOnly";
	service.className = document.getElementById("chkWsSTS").checked ? "" : "txtReadOnly";
	alias.className = document.getElementById("chkWsSTS").checked ? "" : "txtReadOnly";
	ksPath.className = document.getElementById("chkWsSTS").checked ? "" : "txtReadOnly";
	ksPwd.className = document.getElementById("chkWsSTS").checked ? "" : "txtReadOnly";
	tsPath.className = document.getElementById("chkWsSTS").checked ? "" : "txtReadOnly";
	tsPwd.className = document.getElementById("chkWsSTS").checked ? "" : "txtReadOnly";
	
	if (document.getElementById("chkWsSTS").checked) {
		unsetBrwsReadOnly(url); 
		unsetBrwsReadOnly(issuer);
		unsetBrwsReadOnly(policy);
		unsetBrwsReadOnly(role);
		unsetBrwsReadOnly(user);
		unsetBrwsReadOnly(service);
		unsetBrwsReadOnly(alias);
		unsetBrwsReadOnly(ksPath);
		unsetBrwsReadOnly(ksPwd);
		unsetBrwsReadOnly(tsPath);
		unsetBrwsReadOnly(tsPwd);
	} else {
		setBrwsReadOnly(url);
		setBrwsReadOnly(issuer);
		setBrwsReadOnly(policy);
		setBrwsReadOnly(role);
		setBrwsReadOnly(user);
		setBrwsReadOnly(service);
		setBrwsReadOnly(alias);
		setBrwsReadOnly(ksPath);
		setBrwsReadOnly(ksPwd);
		setBrwsReadOnly(tsPath);
		setBrwsReadOnly(tsPwd);
	}	
	
}

function enableExplore(){
	if(document.getElementById("txtUrl").value!=""){
		document.getElementById("btnExplore").disabled=false;
	}else{
		document.getElementById("btnExplore").disabled=true;
	}
}

function verifyPermissions(){
	if (!document.getElementById("usePrjPerms").checked){ //Si no se usan los permisos del proyecto
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

function cmbProySel(){
	if (document.getElementById("selPrj").value == "0"){
		//Deshabilitamos el checkbox de usar permisos del proyecto
		//document.getElementById("usePrjPerms").checked = false;
		//document.getElementById("usePrjPerms").disabled = true;
		//Habilitamos la grilla de permisos
		//document.getElementById("permGrid").disabled = false;
		//document.getElementById("addPoolUsrPerm").disabled = false;
		//document.getElementById("delPoolUsrPerm").disabled = false;
		//Vaciamos la grilla de permisos, dejando TODOS clickeado
		//delAllPerms(true);
		//var oRows = document.getElementById("permGrid").rows;
		//var td = oRows[0].getElementsByTagName("TD");
		//Marcamos el modo lectura
		//td[3].getElementsByTagName("INPUT")[0].checked = true;
		//td[0].getElementsByTagName("INPUT")[2].value = 1;
		//Marcamos escritura
		//td[3].getElementsByTagName("INPUT")[1].checked = true;
	 	//td[0].getElementsByTagName("INPUT")[3].value = 1;
	 	document.getElementById("hidUsePrjPerms").value = "false";
	}else{
		//Habilitamos el checkbox de usar permisos del proyecto	
		//document.getElementById("usePrjPerms").disabled = false;
		//Cargamos la grilla con los permisos del proyecto
		//loadProyectPerms(); <--- TODO, SI SE HACE SE DEBE HACER PARA TODOS LOS OBJETOS DE DISEÑO

		if (document.getElementById("hidUsePrjPerms").value == "false"){ //Si no se usan las props del proyecto
			var msg = confirm(MSG_USE_PROY_PERMS);
			if (msg) {
				//document.getElementById("usePrjPerms").checked = true;
				//Deshabilitamos la grilla de permisos
				//document.getElementById("permGrid").disabled = true;
				//document.getElementById("addPoolUsrPerm").disabled = true;
				//document.getElementById("delPoolUsrPerm").disabled = true;
				//Vaciamos la grilla de permisos, dejando TODOS sin clickear
				//delAllPerms(false);
				
				document.getElementById("hidUsePrjPerms").value = "true";
			}else{
				document.getElementById("hidUsePrjPerms").value = "false";
			}
		}
	}
}

function loadProyectPerms(){
	//1. Obtenemos el id del proyecto seleccionado
	var prjId = document.getElementById("selPrj").value;
	var sXMLSourceUrl = "administration.BusinessClassesAction.do?action=getProjPermssions&prjId=" + prjId;
	var xmlLoad=new xmlLoader();
	xmlLoad.onload=function(xmlRoot){
	
		for(i=0;i<xmlRoot.childNodes.length;i++){
			xRow = xmlRoot.childNodes[i];
			var option = document.createElement("OPTION");
			
			/* TODO */
		
		}
	}
	xmlLoad.load(sXMLSourceUrl);
}
