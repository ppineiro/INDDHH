function work(id,entCode){
	window.location = window.location = CONTEXT + '/page/externalAccess/open.jsp?logFromSession=true&envId='+ENV_ID+'&proCode=' + id + '&type=P&entCode=' + entCode + '&tokenId=' + TOKENID;
}

function btnBack_click(){
	window.location = CONTEXT + '/miniSite/pages/menu.jsp?tokenId=' + TOKENID;
}