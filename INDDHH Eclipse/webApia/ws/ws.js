
function btnUnPub_click(envId, pubId){
	document.getElementById("frmMain").action = "configuration.WsAction.do?action=unpublish&envId="+envId + "&pubId="+pubId;
	submitForm(document.getElementById("frmMain"));
}

function btnPub_click(envId, pubId){
	document.getElementById("frmMain").action = "configuration.WsAction.do?action=publish&envId="+envId + "&pubId="+pubId;
	submitForm(document.getElementById("frmMain"));
}

function btnUnPubDeleted_click(pubName){
	document.getElementById("frmMain").action = "configuration.WsAction.do?action=unpublishDeleted&wsName="+pubName ;
	submitForm(document.getElementById("frmMain"));
}

function btnUnPubAll_click(){
	document.getElementById("frmMain").action = "configuration.WsAction.do?action=unpublishAll";
	submitForm(document.getElementById("frmMain"));
}