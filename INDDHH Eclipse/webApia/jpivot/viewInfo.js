var viewsInfo;
function init(){
	viewsInfo=document.getElementById("viewsInfo");
	if(!viewsInfo){return;}
	
	document.getElementById("textInfoCubeName").innerHTML = VIEW_NAME;
	document.getElementById("textInfoCubeDesc").innerHTML = VIEW_DESC;

	if(!viewsInfo){
		return null;
	}

	viewsInfo.style.left=((getStageWidth()-viewsInfo.offsetWidth)/2)+"px";
	viewsInfo.style.top=((getStageHeight()-viewsInfo.offsetHeight)/2)+"px";
	
	viewsInfo.cancel=function(){
		var frmMain=document.getElementById("frmMain");
		//frmMain.action=URL_ROOT_PATH+"/Views?action=cancel";
		var input=document.createElement("INPUT");
		input.type="hidden";
		input.name="justClosedInfo";
		input.value="true";
		frmMain.appendChild(input);
		frmMain.submit();
	}
}


if (document.addEventListener) {
    document.addEventListener("DOMContentLoaded", init, false);
}else{
	init();
}