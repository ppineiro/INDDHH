function work(nom,id){
	window.location = CONTEXT + '/page/externalAccess/workTask.jsp?logFromSession=true&nomTsk='+nom+"&numInst="+id + '&tokenId=' + TOKENID;
}

function btnBack_click(){
	window.location = CONTEXT + '/miniSite/pages/menu.jsp?tokenId=' + TOKENID;
}