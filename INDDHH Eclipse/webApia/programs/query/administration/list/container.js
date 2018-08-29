function loadFrame(frameToLoad,urlTo){
//	switchTabs(frameToLoad)
	var win=window.parent;
	while(!win.document.getElementById("iframeMessages")){
		win=win.parent;
	}
	win.document.getElementById("iframeMessages").showResultFrame(document.body);
	if(frames["frameContent"+(frameToLoad)].document && frames["frameContent"+(frameToLoad)].document.body){
		frames["frameContent"+(frameToLoad)].document.body.innerHTML="";
	}
	document.getElementById("samplesTab").showContent(frameToLoad);
	document.getElementById("frameContent"+(frameToLoad)).src=URL_ROOT_PATH+"/"+urlTo;
//	showContent(frameToLoad-1);
}
function switchTabs(nTab){ 
	samplesTab.changeTab(nTab);
}

function resizeIframes(iFrameIndex){
	iFrameIndex.style.setExpression("height","document.body.clientHeight-50");
	iFrameIndex.style.setExpression("width","document.body.clientWidth-15");

}

function recalc(){
	for(fr=0;fr<window.frames.length;fr++)	{
		resizeIframes(document.getElementsByTagName("IFRAME")[fr]);
	}
	
	var obj = window.frames[0].document.getElementById("divContent");
	obj.runtimeStyle.setAttribute("height", window.document.body.clientHeight-50 - (obj.previousSibling.offsetHeight + obj.nextSibling.offsetHeight) - 4);

	var obj2 = window.frames[1].document.getElementById("divContent");
	obj2.runtimeStyle.setAttribute("height", window.document.body.clientHeight-50 - (obj.previousSibling.offsetHeight + obj.nextSibling.offsetHeight) - 4);	

}