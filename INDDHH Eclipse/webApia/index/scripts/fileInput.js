function uploadFileDocument(index,frmId,frmParent,attId,inModal,hidePermissions) {
	var ret=openModal("/execution.FormAction.do?action=uploadFile&frmId="+frmId+"&frmParent="+frmParent+"&inModal="+inModal+"&index="+index+"&attId="+attId+"&hidePermissions="+hidePermissions+windowId,500,420);
	ret.onclose=function(){
		document.getElementById("frmMain").action = "execution.FormAction.do?action=refresh&frmParent="+frmParent+"&frmId="+frmId+"&inModal="+inModal;
		submitFormReload(document.getElementById("frmMain"));
	}
	var inputId="frm_"+frmParent+"_"+frmId+"_"+attId+"_ROWID";
	setFocusedElement(inputId,index);
}

function downloadFileDocument(frmId,frmParent,docId,inModal) {
	document.getElementById("docFrame").src="execution.FormAction.do?action=download&frmId="+frmId+"&frmParent="+frmParent+"&inModal="+inModal+"&docId="+docId;
}

function downloadDocumentAtt(index,frmId,frmParent,attId,inModal) {
	document.getElementById("docFrame").src="execution.FormAction.do?action=download&frmId="+frmId+"&frmParent="+frmParent+"&inModal="+inModal+"&index="+index+"&attId="+attId;
}

function downloadTMPDocument(index,frmId,frmParent,attId,inModal) {
	document.getElementById("docFrame").src="execution.FormAction.do?action=downloadTMP&frmId="+frmId+"&frmParent="+frmParent+"&inModal="+inModal+"&index="+index+"&attId="+attId;
}

function eraseFileDocument(index,frmId,frmParent,attId,docId,inModal,usrLock){
	document.getElementById("frmMain").action = "execution.FormAction.do?action=removeFile&frmId="+frmId+"&attId="+attId+"&docId="+docId+"&index="+index+"&usrLock="+usrLock+"&frmParent="+frmParent+"&inModal="+inModal;
	submitFormReload(document.getElementById("frmMain"));
}

function updateFileDocumentModal(index,frmId,frmParent,attId,docId,hidePermissions,inModal,usrLock){
	var ret=openModal("/execution.FormAction.do?action=updateFile&frmId="+frmId+"&usrLock="+usrLock+ "&index="+index+"&attId="+attId+"&docId="+docId+"&hidePermissions="+hidePermissions+"&frmParent="+frmParent,500,370);
	ret.onclose=function(){
		document.getElementById("frmMain").action = "execution.FormAction.do?action=refresh&frmParent="+frmParent+"&frmId="+frmId+"&inModal="+inModal;
		submitFormReload(document.getElementById("frmMain"));
	}
}

function updateFileDocument(index,frmId,frmParent,attId,inModal,usrLock){
	document.getElementById("frmMain").action = "execution.FormAction.do?action=updateFile&frmId="+frmId+"&usrLock="+usrLock+"&inModal="+inModal+"&index="+index+"&attId="+attId+"&frmParent="+frmParent;
	submitFormReload(document.getElementById("frmMain"));
}

function lockFileDocument(frmId,frmParent,attId,docId,inModal,usrLock,ableToLock){
	document.getElementById("frmMain").action = "execution.FormAction.do?action=lockFile&frmId="+frmId+"&attId="+attId+"&docId="+docId+"&usrLock="+usrLock+"&lock="+ableToLock+"&frmParent="+frmParent+"&inModal="+inModal;
	submitFormReload(document.getElementById("frmMain"));
}

function showFileDocumentHistory(docId,inModal){
	openModal("/execution.FormAction.do?action=history&docId="+ docId + "&inModal=" + inModal,500,370);
}

function digitalSignDocument(index,frmId,frmParent,fldId,inModal,onbeforeunload,width,height,doModal){
	if(doModal){
		openModal("/execution.FormAction.do?action=secretPhrase&frmId=" + frmId + "&fldId=" + fldId + "&inModal=" + inModal + "&frmParent=" + frmParent +windowId , width , height);
		var doAfter=function(rets){ 
			if (rets != null) {
				var samplesTabName = "samplesTab";
				document.getElementById("frmMain").action = "execution.FormAction.do?action=signField&onbeforeunload="+onbeforeunload+"&frmId=" + frmId + "&inModal=" + inModal + "&fldId=" + fldId + "&index=" + index + "&frmParent=" + frmParent +"&usrPhrase=" + rets + "&selTab=" + document.getElementById(samplesTabName).getSelectedTabIndex();
				document.getElementById('frmMain').target="_self";
				submitForm(document.getElementById("frmMain"));
			}
		}
		rets.onclose=function(){
			doAfter(this.returnValue);
		}
	}else{
		var samplesTabName = "samplesTab";
		document.getElementById("frmMain").action = "execution.FormAction.do?action=signField&onbeforeunload="+onbeforeunload+"&frmId=" + frmId + "&inModal=" + inModal + "&fldId=" + fldId + "&index=" + index + "&frmParent=" + frmParent +"&usrPhrase=&selTab=" + document.getElementById(samplesTabName).getSelectedTabIndex();
		document.getElementById('frmMain').target="_self";
		submitForm(document.getElementById("frmMain"));
	}
}

function viewFieldSigns(index,frmId,frmParent,fldId,inModal,width,height){
	var rets = openModal("/execution.FormAction.do?action=viewFieldSigns&frmId=" + frmId + "&index=" + index + "&inModal=" + inModal + "&fldId=" + fldId + "&frmParent=" + frmParent +windowId,width,height );
}

function setFocusedElement(id,index){
	var el=document.getElementById(id);
	if (! el) return;
	var parent=el.parentNode;
	var els=parent.getElementsByTagName("INPUT");
	el=els[1];
	setDispatcherId(el);
	setDispatcherIndex(index);
}