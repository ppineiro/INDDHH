


function loadFrame(frameToLoad,urlTo){
//	switchTabs(frameToLoad)
	var win=window.parent;
	while(!win.document.getElementById("iframeMessages")){
		win=win.parent;
	}
	win.document.getElementById("iframeMessages").showResultFrame(document.body);
	if(frames["frameContent"+(frameToLoad-1)].document && frames["frameContent"+(frameToLoad-1)].document.body){
		frames["frameContent"+(frameToLoad-1)].document.body.innerHTML="";
	}
	document.getElementById("frameContent"+(frameToLoad-1)).src=urlTo;
	document.getElementById("samplesTab").showContent(frameToLoad-1);
//	showContent(frameToLoad-1);
}
function switchTabs(nTab){ 
	samplesTab.changeTab(nTab);
}





/////////////////////////////////////////////////////////////
//COMENTADO (width & height agregados a iframes)
/*
function window.onload(){	
	recalc();
}

function resizeIframes(iFrameIndex){
	iFrameIndex.style.setExpression("height","document.body.clientHeight-50");
	iFrameIndex.style.setExpression("width","document.body.clientWidth-15");
	
}


/////////////////////////////////////////////////////////////////
*/
/*
function sizeMe(){
	var height=window.innerHeight;
	if(navigator.userAgent.indexOf("MSIE")>0){
		window.event.cancelBubble = true;
		height=document.body.parentNode.clientHeight;
	}
	document.getElementById("divContent").style.height=(height)+"px";
	for(var i=0;i<3;i++){
		document.getElementById("content"+i).style.height=(height-30)+"px";
	}
}*/