function lnkDownDeps_click(){
	document.getElementById("frmMain").action = "administration.ProcessAction.do?action=downDepsTxt";
	document.getElementById("frmMain").submit();	
}

function btnDoc(){
	if (!confirm(CONFIRM_PRINT)) {
	 return
	}
/*	var win=window;
	while(!win.document.getElementById("iframeMessages") || !win.document.getElementById("iframeResult")){
		win=win.parent;
	}
	if(!MSIE){
		win.document.getElementById("iframeResult").style.visibility="hidden";
		win.document.getElementById("iframeResult").style.display="block";
		win.document.getElementById("iframeResult").doCenterFrame();
	}
 
	win.document.getElementById("iframeMessages").showResultFrame(document.body);
	win.document.getElementById("iframeResult").style.visibility="visible";*/
	uploadProcessImage();
}

function btnNew_click(){
	document.getElementById("frmMain").action = "administration.ProcessAction.do?action=new";
	submitForm(document.getElementById("frmMain"));
}

function btnDel_click(){
	var cant = chksChecked(document.getElementById("gridList"));
	if(cant != 0) {
		if(cant == 1 && canWrite()==false) {
			alert(MSG_INSUF_PERMISSIONS);
		}else{
			if (confirm(GNR_DELETE_RECORD)) {
				document.getElementById("frmMain").action = "administration.ProcessAction.do?action=remove";
				submitForm(document.getElementById("frmMain"));
			}
		}
	} else {
		alert(GNR_CHK_AT_LEAST_ONE);
	}
}

function btnRegenCond_click(){
	var cant = chksChecked(document.getElementById("gridList"));
	if(cant != 0) {
		if(cant == 1 && canWrite()==false) {
			alert(MSG_INSUF_PERMISSIONS);
		}else{
			document.getElementById("frmMain").action = "administration.ProcessAction.do?action=regenCond";
			submitForm(document.getElementById("frmMain"));
		}
	} else {
		alert(GNR_CHK_AT_LEAST_ONE);
	}
}

function btnIni_click(){
	var cant = chksChecked(document.getElementById("gridList"));
	if(cant != 0) {
		if(cant == 1 && canWrite()==false) {
			alert(MSG_INSUF_PERMISSIONS);
		}else{
			if (confirm(GNR_INIT_RECORD)) {
				document.getElementById("frmMain").action = "administration.ProcessAction.do?action=initPro";
				submitForm(document.getElementById("frmMain"));
			}
		}
	} else {
		alert(GNR_CHK_AT_LEAST_ONE);
	}
}

function btnMod_click(){
	var cant = chksChecked(document.getElementById("gridList"));
	if(cant == 1) {
		if (canRead()==true){ 
			if (canWrite()==true){ //verificamos si el usuario tiene permisos de escritura
				if (canUpdate()){ //verificamos si bloqueo el proceso
					document.getElementById("frmMain").action = "administration.ProcessAction.do?action=update";
					submitForm(document.getElementById("frmMain"));	
				}
			}else{ //si el usuario no tiene permisos de escritura, permitimos ingresar al procesos sin necesidad de bloquearlo
				var resp = confirm(MSG_PRO_ONLY_READ);
				if (resp){
					document.getElementById("frmMain").action = "administration.ProcessAction.do?action=update";
					submitForm(document.getElementById("frmMain"));	
				}
			}
		}else{
			alert(MSG_PRO_CANT_READ);
		}
	} else if (cant > 1) {
		alert(GNR_CHK_ONLY_ONE);
	} else {
		alert(GNR_CHK_AT_LEAST_ONE);
	}
}

function canUpdate(){
	var selItem = document.getElementById("gridList").selectedItems[0].rowIndex-1;
	var trows=document.getElementById("gridList").rows;
	var proId = trows[selItem].getElementsByTagName("TD")[1].getElementsByTagName("INPUT")[1].value;
	var	usrLock = getUsrLockProcess(proId);
	var isBPMN = isBPMNVerifier(proId);
	var usrCanRead = trows[selItem].getElementsByTagName("TD")[1].getElementsByTagName("INPUT")[2].value;
	if (usrLock=="" || usrLock ==null || usrLock=="null"){ //no esta bloqueado
		var resp = confirm(LBL_MST_LCK_PRO);
		if (resp){
			return true;
		}else{
			return false;
		}
	}else if (usrLock=="[true]" || usrLock==ACTUAL_USER){ //esta bloqueado por el usuario actual
		if (isBPMN == 'true'){
			var resp2 = confirm(MSG_IS_BPMN_PROCESS);
			if (resp2){
				return true;
			}else {
				return false;
			}
		}else{
			return true;
		}
	}else{ //esta bloqueado por otro usuario
		var resp = confirm(LBL_PRO_LCK_CONT);
		if (resp){
			return true;
		}else{
			return false;
		}
	}
}

function canWrite(){  //Called from list.jsp
	var selItem = document.getElementById("gridList").selectedItems[0].rowIndex-1;
	var trows=document.getElementById("gridList").rows;
	var usrCanWrite = trows[selItem].getElementsByTagName("TD")[1].getElementsByTagName("INPUT")[3].value;
	if (usrCanWrite=='true'){
		return true;
	}else{
		return false;	
	}
}

function canWrite2(){ //Called from update.jsp
	if (document.getElementById("hidUsrCanWrite")!=null){
		var usrCanWrite = document.getElementById("hidUsrCanWrite").value;
		if (usrCanWrite=='true'){
			return true;
		}else{
			return false;	
		}
	}else{
		return false;
	}
}

function canRead(){
	var selItem = document.getElementById("gridList").selectedItems[0].rowIndex-1;
	var trows=document.getElementById("gridList").rows;
	var usrCanRead = trows[selItem].getElementsByTagName("TD")[1].getElementsByTagName("INPUT")[2].value;
	if (usrCanRead=='true'){
		return true;
	}else{
		return false;	
	}
}

function btnVers_click(){
	var cant = chksChecked(document.getElementById("gridList"));
	if(cant == 1) {
		if (canRead()==true){ 
			document.getElementById("frmMain").action = "administration.ProcessAction.do?action=versions";
			submitForm(document.getElementById("frmMain"));	
		}else{
			alert(MSG_INSUF_PERMISSIONS);
		}
	} else if (cant > 1) {
		alert(GNR_CHK_ONLY_ONE);
	} else {
		alert(GNR_CHK_AT_LEAST_ONE);
	}
}

function btnClo_click(){
	var cant = chksChecked(document.getElementById("gridList"));
	if(cant == 1) {
		if (canRead()==true){ 
			var procId=document.getElementById("gridList").selectedItems[0].getElementsByTagName("INPUT")[1].value;
			document.getElementById("frmMain").action = "administration.ProcessAction.do?action=clone&toClone="+procId;
			submitForm(document.getElementById("frmMain"));	
		}else{
			alert(MSG_INSUF_PERMISSIONS);
		}
	} else if (cant > 1) {
		alert(GNR_CHK_ONLY_ONE);
	} else {
		alert(GNR_CHK_AT_LEAST_ONE);
	}
}

function btnConfClo_click(){
	if (verifyRequiredObjects()) {
		if(isValidName(document.getElementById("txtName").value)){
			document.getElementById("frmMain").action = "administration.ProcessAction.do?action=confClone";
			submitForm(document.getElementById("frmMain"));
		}
	}
}

function btnDep_click(){
	var cant = chksChecked(document.getElementById("gridList"));
	if(cant == 1) {
		document.getElementById("frmMain").action = "administration.ProcessAction.do?action=viewDeps";
		submitForm(document.getElementById("frmMain"));	
	} else if (cant > 1) {
		alert(GNR_CHK_ONLY_ONE);
	} else {
		alert(GNR_CHK_AT_LEAST_ONE);
	}
}

function btnSearch_click() {
	document.getElementById("frmMain").action = "administration.ProcessAction.do?action=search";
	submitForm(document.getElementById("frmMain"));
}

function orderBy(order){
	document.getElementById("frmMain").action = "administration.ProcessAction.do?action=order&orderBy=" + order;
	submitForm(document.getElementById("frmMain"));
}

function first() {
	document.getElementById("frmMain").action = "administration.ProcessAction.do?action=first";
	submitForm(document.getElementById("frmMain"));
}

function prev() {
	document.getElementById("frmMain").action = "administration.ProcessAction.do?action=prev";
	submitForm(document.getElementById("frmMain"));
}

function next() {
	document.getElementById("frmMain").action = "administration.ProcessAction.do?action=next";
	submitForm(document.getElementById("frmMain"));
}

function last() { 
	document.getElementById("frmMain").action = "administration.ProcessAction.do?action=last";
	submitForm(document.getElementById("frmMain"));
}

function goToPage(){
	document.getElementById("frmMain").action="administration.ProcessAction.do?action=page";
	submitForm(document.getElementById("frmMain"));
}

function verifyActualUserCanModify(){
	var permRows=document.getElementById("permGrid").rows;
	var actUser = document.getElementById("actualUser").value;
	var actUserCanModify = false;
	
	for(var i=0;i<permRows.length;i++){
		var isAll = ("-1" == permRows[i].getElementsByTagName("TD")[0].getElementsByTagName("INPUT")[1].value);
		var canModify= ("1" == permRows[i].getElementsByTagName("TD")[0].getElementsByTagName("INPUT")[3].value);
		var isActUser = (actUser == permRows[i].getElementsByTagName("TD")[2].title);
		if (canModify && (isActUser || isAll)){
			actUserCanModify = true;
		}
	}
	if (!actUserCanModify){
		alert("El usuario actual debe tener permisos de escritura.");
		return false;
	}
	return true;
}

function btnConf_click(){
	if (verifyRequiredObjects()) {
		if(isValidName(document.getElementById("txtName").value)){
			if (canModifyProcess()=='true'){
				if (verifyCubeData() && verifyPermissions()){ //&& verifyActualUserCanModify()
					var result = askAjax("administration.ProcessAction.do","action=checkWarning&txtMap="+document.getElementById("txtMap").value + "&windowId=" + windowId,
						function(result){
						if (result == "true"){
							var answer = confirm(WARN_USER_NOT_IN_POOLS);
							if (answer){
								continueConfirm();
							}
						}else{
							if (result == "false"){
								continueConfirm();
							}
						}
					});
				}
			}else{
				alert(MSG_PRO_LCK_BY_OTH_USER);
			}
		}
	}
}

function continueConfirm(){
	if (viewsWithError){
		var lbl = msgVwWithError;
		var msg = confirm(lbl.replace("<TOK1>", errorViews));
		if (msg){
			doConfirm();
		}
	}else {
		doConfirm();
	}
}

function doConfirm(){
	document.getElementById("frmMain").action = "administration.ProcessAction.do?action=confirm&firstConf=true";
	submitFormFrame(document.getElementById("frmMain"));	
}

function doSave(){
	document.getElementById("frmMain").action = "administration.ProcessAction.do?action=save";
	submitFormFrame(document.getElementById("frmMain"));
}

function btnVal_click(){
	document.getElementById("frmMain").action = "administration.ProcessAction.do?action=validate";
	submitFormFrame(document.getElementById("frmMain"));
}

function btnGua_click(){
	if (verifyRequiredObjects()) {
		if(confirm(VERSION_ON_SAVE)){
			doSave();
		}
	}		
}

function btnRecover() {
	var cant = chksChecked(document.getElementById("gridList"));
	if(cant == 1) {
		if (confirm(RECOVER_RECORD)) {
			document.getElementById("frmMain").action = "administration.ProcessAction.do?action=recover";
			submitForm(document.getElementById("frmMain"));	
		}
	} else if (cant > 1) {
		alert(GNR_CHK_ONLY_ONE);
	} else {
		alert(GNR_CHK_AT_LEAST_ONE);
	}
}

function btnVerVersion() {
	var cant = chksChecked(document.getElementById("gridList"));
	if(cant == 1) {
		document.getElementById("frmMain").action = "administration.ProcessAction.do?action=viewVersion";
		submitForm(document.getElementById("frmMain"));	
	} else if (cant > 1) {
		alert(GNR_CHK_ONLY_ONE);
	} else {
		alert(GNR_CHK_AT_LEAST_ONE);
	}
}

function btnExit_click(lockedByMe){
	if(lockedByMe=='true' && dependencies!=true){
		var msg = confirm(GNR_PER_DAT_ING);
		if (msg) {
			splash();
		}
		return true;
	}
	splash();
	return true;
}

function btnBack_click(lockedByMe) {
	if (canWrite2()){
		if(lockedByMe =='true' && dependencies!=true){
			var msg = confirm(GNR_PER_DAT_ING);
			if (msg) {
				document.getElementById("frmMain").action = "administration.ProcessAction.do?action=backToList";
				document.getElementById("frmMain").target = "_self";
				submitForm(document.getElementById("frmMain"));
			}
			return true;
		}
		document.getElementById("frmMain").action = "administration.ProcessAction.do?action=backToList";
		document.getElementById("frmMain").target = "_self";
		submitForm(document.getElementById("frmMain"));
		return true;
	}else{
		document.getElementById("frmMain").action = "administration.ProcessAction.do?action=backToList";
		document.getElementById("frmMain").target = "_self";
		submitForm(document.getElementById("frmMain"));
	}
}

function btnBackVer_click() {
	document.getElementById("frmMain").action = "administration.ProcessAction.do?action=backToVer";
	document.getElementById("frmMain").target = "_self";
	submitForm(document.getElementById("frmMain"));
}

function btnBackPro_click() {
	//var defaultTab=document.getElementById("samplesTab").shownIndex;
	var defaultTab=0;
	document.getElementById("frmMain").action = "administration.ProcessAction.do?action=backToPro&defaultTab="+defaultTab;
	document.getElementById("frmMain").target = "_self";
	submitForm(document.getElementById("frmMain"));
}

function proTypeChange() {
	if (flashLoaded) {
		if (document.getElementById("txtProType").selectedIndex==0) {
			setAuto();
		} else {
			setManual();
		}
	}
}

function entChange() {
	//if (flashLoaded && MSIE) {
	if (flashLoaded) {
		setEntity();
	}
}

function changeCustomMsg(){
	if (document.getElementById("txtCustomMsg").style.visibility == "hidden"){
		document.getElementById("txtCustomMsg").style.visibility = "visible";
	} else {
		document.getElementById("txtCustomMsg").style.visibility = "hidden";
	}
}


function loadQuerys() {
	var proAction = document.getElementById("txtProAction").value;
	var busEntId = document.getElementById("txtBusEnt").value;
	
	var qryId = document.getElementById("qryId");
	
	qryId.selectedIndex = 0;
	qryId.value = "";
	
	while (qryId.options.length > 0) qryId.remove(qryId.options[0]);
	qryId.options.add(document.createElement("OPTION"));
	
	if(document.getElementById("selBusEnt")==null && (busEntId == null || busEntId == "")){
		return;
	}
	
	if (busEntId == "" || busEntId == "-1") {
		busEntId = document.getElementById("selBusEnt").value;
	}

	var qryId = document.getElementById("qryId");
	while (qryId.options.length > 1) { 
		qryId.options.remove(1);
	}

	var sXMLSourceUrl = URL_ROOT_PATH + "/programs/administration/process/querysXML.jsp?proAction=" + proAction + "&busEntId=" + busEntId;;
	var listener=new Object();
	listener.onLoad=function(xml){
		if (isXMLOk(xml)) {
			readXML(xml);
		}
	}
	xml.addListener(listener);
	sXmlResult = __readInDOMDocument(sXMLSourceUrl);

}

function readXML(sXmlResult){
	var xmlRoot=getXMLRoot(sXmlResult);
	var qryId = document.getElementById("qryId");
	
	if (xmlRoot.nodeName != "EXCEPTION") {
		for(i=0;i<xmlRoot.childNodes.length;i++){
			xRow = xmlRoot.childNodes[i];
			var option = document.createElement("OPTION");
			option.value = xRow.childNodes[0].firstChild.nodeValue;
			option.text = xRow.childNodes[1].firstChild.nodeValue;
		
			qryId.options.add(option);
		}
	}else{
		alert("error occurred");
	}
	
	xmlRoot = "";
	sXmlResult = "";
}		



function entBlur() {
	if (document.getElementById("selBusEnt").value != "") {
		document.getElementById("txtBusEnt").value = document.getElementById("selBusEnt").value;
		document.getElementById("selBusEnt").disabled = 'true';

		if (document.getElementById("chkMsgEnt").disabled == true){
			document.getElementById("chkMsgEnt").disabled = false;
		}
		
		entChange();
		
	}
}

function changeTemplate() {
	if (document.getElementById("txtTemplate").value=="<CUSTOM>") {
		document.getElementById("btnVerOne").style.display = "none";
		document.getElementById("customTemplate").disabled = false;
		document.getElementById("customTemplate").style.display = "";
		document.getElementById("btnVerTwo").style.display = "";
		document.getElementById("btnVerTwo").style.disabled = true;
	} else if (!document.getElementById("customTemplate").disabled) {
		document.getElementById("btnVerOne").style.display = "";
		document.getElementById("customTemplate").disabled = true;
		document.getElementById("customTemplate").style.display = "none";
		document.getElementById("btnVerTwo").style.display = "none";
		document.getElementById("btnVerTwo").style.disabled = true;
	}
}

function btnViewTemplate() {
    tmpl = document.getElementById("txtTemplate").value;

	if (document.getElementById("txtTemplate").selectedIndex == document.getElementById("txtTemplate").options.length-1) {
		tmpl = document.getElementById("customTemplate").value;
	}

    if (tmpl == "") {
	    tmpl = "/templates/taskDefault.jsp";
    }
    
	openModal("/programs/modals/templateTest.jsp?template="+escape(tmpl),600,500);
}

function btnViewCalendar() {
    calId = document.getElementById("selCal").value;
	if (calId != 0){
		openModal("/programs/modals/calendarView.jsp?calendarId="+calId,600,500);
	}

}

//---------------------------------------------------
//------------   FUNCIONES PARA POOLS   -------------
//---------------------------------------------------
function btnAddPool_click() {
	var rets = openModal("/programs/modals/pools.jsp?showAutogenerated=true&showOnlyEnv=true&envId=" + ENV_ID + "&showGlobal=true",500,350);
		var doAfter=function(rets){
			if (rets != null) {
				for (j = 0; j < rets.length; j++) {
					var ret = rets[j];
					var addRet = true;
					
					trows=document.getElementById("gridPools").rows;
					for (i=0;i<trows.length & addRet;i++) {
						if (trows[i].getElementsByTagName("TD")[0].getElementsByTagName("INPUT")[1].value == ret[0]) {
							addRet = false;
						}
					}
					
				if (addRet) {
					var oTd0 = document.createElement("TD"); 
					var oTd1 = document.createElement("TD"); 
					
					oTd0.innerHTML = "<input type='checkbox' name='chkPoolSel'><input type='hidden' name='idPool'><input type='hidden' name='txtPool'>";
					oTd0.getElementsByTagName("INPUT")[1].value = ret[0];
					oTd0.getElementsByTagName("INPUT")[2].value = ret[1];
					oTd0.align="center";
					
					oTd1.innerHTML = ret[1];
					
					var oTr = document.createElement("TR");
					oTr.appendChild(oTd0);
					oTr.appendChild(oTd1);
					document.getElementById("gridPools").addRow(oTr);
				}
			}
		}
	}
	rets.onclose=function(){
		doAfter(rets.returnValue);
	}
	/*if (window.navigator.appVersion.indexOf("MSIE")<0){
		var aux=rets.document;
		var isOpen=true;
		rets.onunload=function(event){
			event.cancelBubble=true;
			if(!isOpen){
				doAfter(rets.returnValue);
			}
			isOpen=false;
	    }
    }else{
		doAfter(rets);
	}*/
}

function btnDelPool_click() {
	document.getElementById("gridPools").removeSelected();
}

function btnConfPools_click(event) {
	document.getElementById("frmMain").action = "administration.ProcessAction.do?action=addPools&event=" + EVENT;
	submitFormModal(document.getElementById("frmMain"));
}	

function btnExitPools_click() {
	window.returnValue=null;
	window.close();
}

function alterPools(event) {
	openModal("/programs/administration/process/pools.jsp?event=" + event,500,500);
}

function alterMessage(event) {
	openModal("/programs/administration/process/message.jsp?event=" + event,500,300);
}

//---------------------------------------------------
//------------  FUNCIONES PARA ALERTAS  -------------
//---------------------------------------------------
function cmbAlert_change(type) {
	if (document.getElementById(type).value == '0') {
		document.getElementById(type+'L').style.visibility = "";
		document.getElementById(type+'L').p_required = "true";
	} else {
		document.getElementById(type+'L').style.visibility = "hidden";
		document.getElementById(type+'L').value = '0';
	}
}

//---------------------------------------------------
//------------ FUNCIONES PARA MENSAJES --------------
//---------------------------------------------------
function btnConfMessage_click() {
	document.getElementById("frmMain").action = "administration.ProcessAction.do?action=alterMessage&event=" + EVENT;
	submitFormModal(document.getElementById("frmMain"));
}	

function btnExitMessage_click() {
	window.returnValue=null;
	window.close();
}

function btnDefMessage_click() {
	document.getElementById("txtMes").value = DEFAULT_MESSAGE;
}

//---------------------------------------------------
//------------ FUNCIONES PARA ATRIBUTOS -------------
//---------------------------------------------------

function btnRemAtt_click(val,type) {
	var extra = "";
	if (TYPE_NUMERIC == type) {
		extra = "Num";
	} else if (TYPE_DATE == type) {
		extra = "Dte";
	}

	document.getElementById('hidAttId'+extra+val).value = "";
	document.getElementById('txtAttName'+extra+val).value = "";
}

function btnLoadAtt_click(val,type) {
	var rets = openModal("/programs/modals/atts.jsp?onlyOne=true&type=" + type + "&showNative=true",500,300);
	var doAfter=function(rets){
		if (rets != null) {
			for (j = 0; j < rets.length; j++) {
				var ret = rets[j];
				var ok = true;
			
				var extra = "";
				var count = 0;
				if (TYPE_STRING == type) {
					count = 5;
				} else if (TYPE_NUMERIC == type) {
					extra = "Num";
					count = 3;
				} else if (TYPE_DATE == type) {
					extra = "Dte";
					count = 3;
				}
		
				for (i = 1; i <= count && ok; i++) {
					ok = ok && document.getElementById('hidAttId'+extra+i).value != ret[0];
				}
				
				if (ok) {
					document.getElementById('hidAttId'+extra+val).value = ret[0];
					document.getElementById('txtAttName'+extra+val).value = ret[1];
				}
			}	
		}
	}
	rets.onclose=function(){
		doAfter(rets.returnValue);
	}
	/*if (window.navigator.appVersion.indexOf("MSIE")<0){
		var aux=rets.document;
		var isOpen=true;
		rets.onunload=function(event){
			event.cancelBubble=true;
			if(!isOpen){
				doAfter(rets.returnValue);
			}
			isOpen=false;
	    }
    }else{
		doAfter(rets);
	}*/
}


//---------------------------------------------------
//------------ FUNCIONES PARA MONITOREO -------------
//---------------------------------------------------

function upMon_click() {
	var grid=document.getElementById("gridMonForms");
	grid.moveSelectedUp();
}

function downMon_click() {
	var grid=document.getElementById("gridMonForms");
	grid.moveSelectedDown();
}

function btnDelMonForm_click() {
	var rows=document.getElementById("gridMonForms").selectedItems;
	var esta = false;
	for(var i=0;i<rows.length;i++){
		document.getElementById("gridMonForms").deleteElement(rows[i]);
	}
	document.getElementById("gridMonForms").setOdds();
}
function btnAddMonForm_click() {
	var rets = openModal("/programs/modals/forms.jsp",500,300);
	var doAfter=function(rets){
		if (rets != null) {
			for (j = 0; j < rets.length; j++) {
				var ret = rets[j];
				var addRet = true;
				trows=document.getElementById("gridMonForms").rows;
				for (i=0;i<trows.length && addRet;i++) {
					if (trows[i].getElementsByTagName("TD")[0].getElementsByTagName("INPUT")[1].value == ret[0]) {
						addRet = false;
					}
				}
	
				if (addRet) {
					var oTd0 = document.createElement("TD"); 
					var oTd1 = document.createElement("TD"); 
			
					oTd0.innerHTML = "<input type='checkbox' name='chkMonFormSel'><input type='hidden' name='chkMonForm'>";
					oTd0.getElementsByTagName("INPUT")[1].value = ret[0];
					oTd0.align="center";
			
					oTd1.innerHTML = ret[1];
			
					var oTr = document.createElement("TR");
					oTr.appendChild(oTd0);
					oTr.appendChild(oTd1);
					
					document.getElementById("gridMonForms").addRow(oTr);
				}
			}
		}
	}
	rets.onclose=function(){
		doAfter(rets.returnValue);
	}
}

function openImagePicker(caller){
	var rets = openModal("/administration.ImagesAction.do?action=picker",560,300);
	var doAfter=function(rets){
		if(rets && rets.path && rets.id){
			var path=rets.path;
			var id=rets.id;
			caller.style.backgroundImage="url("+path+")";
			caller.firstChild.value=id;
		}else{
			caller.firstChild.value="";
			caller.style.backgroundImage="url("+URL_ROOT_PATH+"/images/uploaded/procicon.png)";
		}
	}
	rets.onclose=function(){
		doAfter(rets.returnValue);
	}
}

function customKeyPress(){
	if (document.getElementById("customTemplate") != null) {
		if(document.getElementById("customTemplate").value!=""){
			document.getElementById("btnVerTwo").disabled = false;
		} else {
			document.getElementById("btnVerTwo").disabled = true;
		}
	}
}

function btnLockPro_click(){
	var cant = chksChecked(document.getElementById("gridList"));
	if(cant == 1) {
			var selItem = document.getElementById("gridList").selectedItems[0].rowIndex-1;
			var trows=document.getElementById("gridList").rows;
			var usrLock = trows[selItem].getElementsByTagName("TD")[1].getElementsByTagName("INPUT")[0].value;
			var proId = trows[selItem].getElementsByTagName("TD")[1].getElementsByTagName("INPUT")[1].value;
			if (usrLock==""){ //no esta bloqueado
				if (canWrite()==true){
					//Bloqueamos el proceso
					var ret = lockUnlockProcess(1,proId);
					if (ret == "OK"){
						trows[selItem].getElementsByTagName("TD")[1].getElementsByTagName("INPUT")[0].value = "[true]";
						//Mostramos el candado amarillo (bloqueado por el usuario actual)
						trows[selItem].getElementsByTagName("TD")[1].getElementsByTagName("IMG")[0].src = LOCK_SRC;
						trows[selItem].getElementsByTagName("TD")[1].getElementsByTagName("IMG")[0].style.display="block";
					}else {
						trows[selItem].getElementsByTagName("TD")[1].getElementsByTagName("INPUT")[0].value = ret; //ret tiene el nombre del usuario que lo tiene bloqueado
						//Mostramos el candado blanco (bloqueado por otro usuario)
						trows[selItem].getElementsByTagName("TD")[1].getElementsByTagName("IMG")[0].src = LOCK2_SRC;
						var lockedBy = MSG_PRO_LOCKED_BY.replace("<TOK1>", ret);
						trows[selItem].getElementsByTagName("TD")[1].getElementsByTagName("IMG")[0].title = lockedBy;
						trows[selItem].getElementsByTagName("TD")[1].getElementsByTagName("IMG")[0].style.display="block";
					}
				}else{
					alert(MSG_INSUF_PERMISSIONS);
				}
			}else if (usrLock=="[true]"){ //esta bloqueado por el usuario actual
				//Desbloqueamos el proceso
				var ret = lockUnlockProcess(0,proId);
				if (ret == "OK"){
					trows[selItem].getElementsByTagName("TD")[1].getElementsByTagName("INPUT")[0].value = "";
					//Ocultamos el candado
					trows[selItem].getElementsByTagName("TD")[1].getElementsByTagName("IMG")[0].style.display="none";
				}
			}else{ //esta bloqueado por otro usuario
				if (ADMIN_USER == 'true'){
					var resp = confirm(LBL_ADM_WIS_UNLOCK);
					if (resp) {
						//Desbloqueamos el proceso
						var ret = lockUnlockProcess(0,proId);
						if (ret == "OK"){
							trows[selItem].getElementsByTagName("TD")[1].getElementsByTagName("INPUT")[0].value = "";
							//Ocultamos el candado
							trows[selItem].getElementsByTagName("TD")[1].getElementsByTagName("IMG")[0].style.display="none";
						}
					}
				}else{
					//No hacemos nada
					alert(LBL_PRO_ALR_LOCKED);
				}
			}
			//document.getElementById("frmMain").action = "administration.ProcessAction.do?action=viewDeps";
			//submitForm(document.getElementById("frmMain"));	

	} else if (cant > 1) {
		alert(GNR_CHK_ONLY_ONE);
	} else {
		alert(GNR_CHK_AT_LEAST_ONE);
	}
}

function lockUnlockProcess(lock,proId){
	var	http_request = getXMLHttpRequest();
		
	http_request.open('POST', "administration.ProcessAction.do?action=lockUnlockProcess"+windowId, false);
	http_request.setRequestHeader("content-type","application/x-www-form-urlencoded");
	
	var str = "proId=" + proId + "&lock="+lock;
	http_request.send(str);
	    
	if (http_request.readyState == 4) {
   	   if (http_request.status == 200) {
           if(http_request.responseText != "NOK"){
		         if (http_request.responseText != "OK"){
		         	alert(MSG_PRO_LCK_BY_OTH_USER);
		         }else{
		         	return http_request.responseText;
		         }
		     }else{
				     alert("ERROR");
	         }
       } else {
               alert("Could not contact the server.");            
            }
	}
	return http_request.responseText;
}

function canModifyProcess(){
	var	http_request = getXMLHttpRequest();
	http_request.open('POST', "administration.ProcessAction.do?action=canModifyProcess"+windowId, false);
	http_request.setRequestHeader("content-type","application/x-www-form-urlencoded");
	
	http_request.send("");
	    
	if (http_request.readyState == 4) {
   	   if (http_request.status == 200) {
           if(http_request.responseText != "NOK"){
		         return http_request.responseText;
		     }else{
				     alert("ERROR");
	         }
       } else {
               alert("Could not contact the server.");            
            }
	}
}

function getUsrLockProcess(proId){
	var	http_request = getXMLHttpRequest();
	http_request.open('POST', "administration.ProcessAction.do?action=getUsrLockProcess"+windowId, false);
	http_request.setRequestHeader("content-type","application/x-www-form-urlencoded");
	
	http_request.send("&proId="+proId);
	    
	if (http_request.readyState == 4) {
   	   if (http_request.status == 200) {
           if(http_request.responseText != "NOK"){
		         return http_request.responseText;
		     }else{
				alert("ERROR");
	         }
       } else {
               alert("Could not contact the server.");            
            }
	}
}

function isBPMNVerifier(proId){
	var	http_request = getXMLHttpRequest();
	http_request.open('POST', "administration.ProcessAction.do?action=isBPMN"+windowId, false);
	http_request.setRequestHeader("content-type","application/x-www-form-urlencoded");
	
	http_request.send("&proId="+proId);
	    
	if (http_request.readyState == 4) {
   	   if (http_request.status == 200) {
           if(http_request.responseText != "NOK"){
		         return http_request.responseText;
		     }else{
				alert("ERROR");
	         }
       } else {
               alert("Could not contact the server.");            
            }
	}
}

function getXMLHttpRequest(){

		var http_request = null;
		if (window.XMLHttpRequest) {
			// browser has native support for XMLHttpRequest object
			http_request = new XMLHttpRequest();
		} else if (window.ActiveXObject) {
			// try XMLHTTP ActiveX (Internet Explorer) version
			try {
				http_request = new ActiveXObject("Msxml2.XMLHTTP");
			} catch (e1) {
				try {
					http_request = new ActiveXObject("Microsoft.XMLHTTP");
				} catch (e2) {
					http_request = null;
				}
			}
		}
	return http_request;
}

function cmbProySel(){
	if (document.getElementById("selPrj").value == "0"){
		//Deshabilitamos el checkbox de usar permisos del proyecto
		document.getElementById("usePrjPerms").checked = false;
		document.getElementById("usePrjPerms").disabled = true;
		//Habilitamos la grilla de permisos
		document.getElementById("permGrid").disabled = false;
		document.getElementById("addPoolUsrPerm").disabled = false;
		document.getElementById("delPoolUsrPerm").disabled = false;
		//Vaciamos la grilla de permisos, dejando TODOS clickeado
		//delAllPerms(true);
		var oRows = document.getElementById("permGrid").rows;
		var td = oRows[0].getElementsByTagName("TD");
		//Marcamos el modo lectura
		td[3].getElementsByTagName("INPUT")[0].checked = true;
		td[0].getElementsByTagName("INPUT")[2].value = 1;
		//Marcamos escritura
		td[3].getElementsByTagName("INPUT")[1].checked = true;
	 	td[0].getElementsByTagName("INPUT")[3].value = 1;
	}else{
		//Habilitamos el checkbox de usar permisos del proyecto	
		document.getElementById("usePrjPerms").disabled = false;
		//Cargamos la grilla con los permisos del proyecto
		//loadProyectPerms(); <--- TODO, SI SE HACE SE DEBE HACER PARA TODOS LOS OBJETOS DE DISEÑO
		if (!document.getElementById("usePrjPerms").checked){ //Si no esta clickeado el checkbox de usar los permisos del proyecto
			var msg = confirm(MSG_USE_PROY_PERMS);
			if (msg) {
				document.getElementById("usePrjPerms").checked = true;
				//Deshabilitamos la grilla de permisos
				document.getElementById("permGrid").disabled = true;
				document.getElementById("addPoolUsrPerm").disabled = true;
				document.getElementById("delPoolUsrPerm").disabled = true;
				//Vaciamos la grilla de permisos, dejando TODOS sin clickear
				delAllPerms(false);
			}
		}
	}
}

function loadProyectPerms(){
	//1. Obtenemos el id del proyecto seleccionado
	var prjId = document.getElementById("selPrj").value;
	var sXMLSourceUrl = "administration.ProcessAction.do?action=getProjPermssions&prjId=" + prjId;
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

function btnRegCbe_click(){
	var cant = chksChecked(document.getElementById("gridList"));
	if(cant != 0) {
		if(cant == 1 && canWrite()==false) {
			alert(MSG_INSUF_PERMS);
		}else{
			if (confirm(MSG_REG_CUBE)) {
				document.getElementById("frmMain").action = "administration.ProcessAction.do?action=regCbe";
				document.getElementById("frmMain").target = "";
				submitForm(document.getElementById("frmMain"));
			}
		}
	} else {
		alert(GNR_CHK_AT_LEAST_ONE);
	}
}
