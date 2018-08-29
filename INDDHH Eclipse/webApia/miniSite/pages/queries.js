function work(qryId){
	window.location = window.location = CONTEXT + '/page/externalAccess/query.jsp?logFromSession=true&envId='+ENV_ID+'&qryId='+qryId + '&tokenId=' + TOKENID;
}

function btnBack_click(){
	window.location = CONTEXT + '/miniSite/pages/menu.jsp?tokenId=' + TOKENID;
}