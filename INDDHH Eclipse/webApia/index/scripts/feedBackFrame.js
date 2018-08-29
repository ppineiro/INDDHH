// JavaScript Document
var oBody;
var blocker;
function setFeedBackFrame(frame){
	frame.oBody;
	frame.hideResultFrame=function(){
		try{
		window.frames[this.id].document.getElementById("divMsg").style.display="block";
		}catch(e){}
		try{
		window.frames[this.id].document.getElementById("divContent").style.display="block";
		}catch(e){}
		try{
		window.frames[this.id].document.getElementById("btnsBar").style.display="block";
		}catch(e){}
		this.style.display="none";
		this.hideWaitCursor();
		if(window.frames[this.id].document.getElementById("iframeKeepActive")){
			window.frames[this.id].document.getElementById("iframeKeepActive").src = "";
		}
		if(window.frames[this.id].document.getElementById("divTituloWaitStatusMessage")){
			window.frames[this.id].document.getElementById("divTituloWaitStatusMessage").style.display = "none";
		}
		if(window.frames[this.id].document.getElementById("divTituloWaitStatusImageContainer")){
			window.frames[this.id].document.getElementById("divTituloWaitStatusImageContainer").style.display = "none";
		}

		try{this.onclose()}catch(e){}
		unBlock();
	}
	frame.doCenterFrame=function(){
		var display=this.style.display+"";
		this.style.display="block";
		var x=window.innerWidth;
		var y=window.innerHeight;
		var width=this.clientWidth;
		var height=this.clientHeight;
		if(MSIE){
			x=document.documentElement.clientWidth;
			y=document.documentElement.clientHeight;
			width=this.clientWidth;
			height=this.clientHeight;
		}
		this.style.position="absolute";
		this.style.overflow="hidden";
		this.style.left=((x-width)/2)+"px";
		this.style.top=((y-height)/2)+"px";
		this.style.display=display;
	}
	frame.initFrame=function(){
		this.doCenterFrame();
	}
	frame.showResultFrame=function(body){
		if(this.id=="iframeMessages"){
			if (window.frames[this.id] != null && window.frames[this.id].document.getElementById("iframeKeepActive") != null) {
				window.frames[this.id].document.getElementById("iframeKeepActive").src = "FramesAction.do?action=keepActive";
			}
			
			if( window.frames[this.id].document.getElementById("btnsBar") &&
				window.frames[this.id].document.getElementById("divMsg") &&
				window.frames[this.id].document.getElementById("preMsg") ){
				window.frames[this.id].document.getElementById("btnsBar").style.display="none";
				window.frames[this.id].document.getElementById("divMsg").style.display="none";
				window.frames[this.id].document.getElementById("preMsg").innerHTML="";
			}
		}
		this.oBody = body;
		this.style.display="block";
		this.showWaitCursor();
		this.doCenterFrame();
		this.showWaitMsg();
		block();
	}
	frame.showMessage=function(str, body){
		this.doCenterFrame();
		this.style.display="block";
		window.frames[this.id].document.getElementById("preMsg").innerHTML = str;
		window.frames[this.id].document.getElementById("divMsg").style.display="block";
		window.frames[this.id].document.getElementById("divContent").style.display="block";
		window.frames[this.id].document.getElementById("btnsBar").style.display="block";
		window.frames[this.id].document.getElementById("divWait").style.display="none";
		
		window.frames[this.id].document.getElementById("iframeKeepActive").src = "";
		window.frames[this.id].document.getElementById("divTituloWaitStatusMessage").style.display = "none";
		window.frames[this.id].document.getElementById("divTituloWaitStatusImageContainer").style.display = "none";
		
		
		this.oBody = body;
		//disableUi(true, body);
		block();
		this.style.display="block";
		//this.showWaitCursor();
		try{
			window.frames[this.id].document.getElementById("buttomSbm").focus();
		}catch(e){}
	}
	frame.getBody=function(){
		if(this.oBody!=undefined){
			return this.oBody;
		}else{
		 	return window.parent.document.frames[window.name].getBody();
		}
	}
	frame.resizeFrame=function(iWidth){
		iWidth=iWidth + "px"
		this.style.width=iWidth;
	}

	frame.showWaitMsg=function(){
		try{
		window.frames[this.id].document.getElementById("divMsg").style.display="none";
		}catch(e){}
		try{
		window.frames[this.id].document.getElementById("divContent").style.display="none";
		}catch(e){}
		try{
		window.frames[this.id].document.getElementById("btnsBar").style.display="none";
		}catch(e){}
		if(window.frames[this.id].document.getElementById("divWait")){
			window.frames[this.id].document.getElementById("divWait").style.display="block";
		}
		return true;
	}
	
	frame.hideWaitMsg=function(){
		try{
		window.frames[this.id].document.getElementById("divMsg").style.display="block";
		}catch(e){}
		try{
		window.frames[this.id].document.getElementById("divContent").style.display="block";
		}catch(e){}
		try{
		window.frames[this.id].document.getElementById("btnsBar").style.display="block";
		}catch(e){}
		window.frames[this.id].document.getElementById("divWait").style.display="none";
		try{this.onclose()}catch(e){}
		return true;
	}
	
	frame.setSubmitWindow=function(win){
		this.submitWindow=win;
	}
	
	frame.getSubmitWindow=function(){
		return this.submitWindow;
	}
	
	frame.showWaitCursor=function(){
		for(var i=0;i<window.frames.length;i++){
			if(window.frames[i].document.body){
				window.frames[i].document.body.style.cursor="wait";
			}
		}
	}
	
	frame.hideWaitCursor=function(){
		for(var i=0;i<window.frames.length;i++){
			if(window.frames[i].document.body){
				window.frames[i].document.body.style.cursor="auto";
			}
		}
	}
}

function block(){
	var height=window.innerHeight;
	var width=(document.body.offsetWidth+2);
	if(MSIE){
		width=document.body.clientWidth;
		height=document.documentElement.clientHeight;
	}
	blocker.style.cursor="wait";
	blocker.style.display="block";
	blocker.style.width=width+"px";
	blocker.style.height=height+"px";
	blocker.style.left="0px";
	blocker.style.top="0px";
	blocker.style.display="block";
}

function unBlock(){
	var blockerAux=blocker.cloneNode(true);
	blocker.style.width="0px";
	blocker.style.height="0px";
	blocker.style.display="none";
}

function setFeedBackFrames(){
	if(document.getElementById("iframeMessages") && document.getElementById("iframeResult")){
		if(document.getElementById("iframeMessages")){
			setFeedBackFrame(document.getElementById("iframeMessages"));
			document.getElementById("iframeMessages").initFrame();
		}
		if(document.getElementById("iframeResult")){
			setFeedBackFrame(document.getElementById("iframeResult"));
			document.getElementById("iframeResult").initFrame();
		}
		blocker=document.createElement("IFRAME");
		blocker.allowtransparency="true";
		blocker.style.backgroundColor="#000000";
		blocker.style.opacity="0.05";
		blocker.style.filter="alpha(opacity=30)";
		blocker.style.zIndex="899999";
		blocker.style.position="absolute";
		blocker.style.display="none";
		blocker.id="blocker";
		blocker.name="blocker";
		document.body.appendChild(blocker);
		var doc;
		if(blocker.contentDocument){
		      doc = blocker.contentDocument;
		}else if(blocker.contentWindow){
		      doc = blocker.contentWindow.document;
		}else if(blocker.document){
		      doc = blocker.document;
		}
		doc.open();
		doc.close();
		doc.body.style.padding="0px";
		doc.body.style.margin="0px";
		doc.body.style.cursor="wait";
		doc.body.innerHTML="<div style='height:100%;width:100%;'></div>";
		document.getElementById("iframeMessages").showResultFrame(null);
		document.getElementById("iframeResult").showResultFrame(null);
		try{hideResultFrame();}catch(e){};
	}
}

if (document.addEventListener) {
    document.addEventListener("DOMContentLoaded", setFeedBackFrames, false);
}else{
	setFeedBackFrames();
}

function hideWaitCursor(){
	for(var i=0;i<window.frames.length;i++){
		if(window.frames[i].document.body){
			window.frames[i].document.body.style.cursor="auto";
		}
	}
}
