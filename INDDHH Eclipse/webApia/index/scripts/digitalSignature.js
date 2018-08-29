function openSignModal(divName,evt,frmId,frmParent,frmName) {

	if(document.getElementById(divName).getAttribute("isvisible")=="false"){
 
		if(window.event){
			evt=window.event;
		}
		document.getElementById(divName).style.display="block";
		document.getElementById(divName).style.zIndex=9990;
		document.getElementById(divName).setAttribute("isvisible","true");	
	} else {
		document.getElementById(divName).style.display="none";
		document.getElementById(divName).setAttribute("isvisible","false");	
	}
}