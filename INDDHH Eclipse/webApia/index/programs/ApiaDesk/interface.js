// JavaScript Document
var backArea;
var iconArea;
var winArea;
var menuArea;
var topArea;
var postiItArea;
function initInterFace(){
	backArea=document.createElement("DIV");
	backArea.id="backArea";
	backArea.style.position="absolute";
	backArea.style.zIndex=1;
	document.body.appendChild(backArea);
	postiItArea=document.createElement("DIV");
	postiItArea.id="backArea";
	postiItArea.style.position="absolute";
	postiItArea.style.zIndex=3;
	document.body.appendChild(postiItArea);
	iconArea=document.createElement("DIV");
	iconArea.id="iconArea";
	iconArea.style.position="absolute";
	iconArea.style.zIndex=5;
//	iconArea.style.height=(getStageHeight()-20)+"px";
//	iconArea.style.width=getStageWidth()+"px";
	iconArea.style.top="0px";
	iconArea.style.left="0px";
	document.body.appendChild(iconArea);
	winArea=document.createElement("DIV");
	winArea.id="winArea";
	winArea.style.position="absolute";
	winArea.style.zIndex=6;
//	winArea.style.height=getStageHeight()+"px"; 
//	winArea.style.width=getStageWidth()+"px";
	winArea.style.top="0px";
	winArea.style.left="0px";
	document.body.appendChild(winArea);
	menuArea=document.createElement("DIV");
	menuArea.id="menuArea";
	menuArea.style.position="absolute";
	menuArea.style.zIndex=25;
//	menuArea.style.height=getStageHeight()+"px";
//	menuArea.style.width=getStageWidth()+"px";
	menuArea.style.top="0px";
	menuArea.style.left="0px";
	document.body.appendChild(menuArea);
	topArea=document.createElement("DIV");
	topArea.id="topArea";
	topArea.style.position="absolute";
	topArea.style.zIndex=30;
	topArea.fadeInPrompt=function(){
		if(!this.fader){
			var fader=document.createElement("DIV");
			fader.className="fader";
			this.appendChild(fader);
			this.fader=fader;
			this.fader.style.position="absolute";
		}
		this.fader.style.display="block";
		this.fader.style.top="-20px";
		this.fader.style.left="-10px";
		this.fader.style.width=(getStageWidth()+20)+"px";
		this.fader.style.height=(getStageHeight()+40)+"px";
		this.fader.style.zIndex=9999999;
		showLoadingIcon(this.fader);
	}
	topArea.fadeOut=function(){
		new Effect.Opacity(this.fader, {duration:1.5,from:1, to:0,afterFinish:function(){ setTimeout(function(){topArea.fader.style.display="none";schelduler.checkToday();},100) }});
		if(MSIE){
			topArea.fader.style.display="none";
		}
	}
	topArea.fadeIn=function(after){
		new Effect.Opacity(this.fader, {duration:1.5,from:0, to:1,afterFinish:after});
	}
	topArea.block=function(){
		if(!this.blocker){
			var blocker=document.createElement("DIV");
			blocker.className="opacity30";
			blocker.style.backgroundColor="#000000";
			this.appendChild(blocker);
			this.blocker=blocker;
			this.blocker.style.position="absolute";
		}
		this.blocker.style.display="block";
		this.blocker.style.top="-20px";
		this.blocker.style.left="-10px";
		this.blocker.style.width=(getStageWidth()+20)+"px";
		this.blocker.style.height=(getStageHeight()+40)+"px";
	}
	topArea.unblock=function(){
		if(this.blocker){
			this.blocker.parentNode.removeChild(this.blocker);
			this.blocker=null;
		}
	}
	topArea.fadeInPrompt();
	setBackgroundFlash();
	document.body.appendChild(topArea);
	setDeskTop();
	setMenu();
	//addListener(document.body,"resize",function(){alert(111);});
	window.onresize=function(){
		deskTop.size();
		dock.positionate();
		menuBar.size();
		widgetArea.size();
		sizeAllWindows();
		var height = screen.availHeight;
		var width = screen.availWidth;
		/*window.width=width+"px";
		window.height=width+"px";
		window.resizeTo(width,height);
		window.moveTo(0,0);*/
	}
	document.body.onscroll=function(){
		//alert(winArea.offsetTop);
		document.body.scrollTop=0;
	}
	addListener(document,"keypress",function(event){handleKey(event);});
}

function handleKey(event){
	event=getEventObject(event);
	if (mainFrameHandleKeyEvent(event) == 0) {
		if (event.altKey)event.altkey=false;
		if(MSIE){
			event.keyCode=0;
		}else{
			event.preventDefault();
		}
		event.returnValue = false;
		event.cancelBubble = true;
	}		
}

//------------------------------------MAIN KEY EVENT HANDLER-----------------//
function mainFrameHandleKeyEvent(eventObj){
	var element=getEventSource(eventObj);
	var elKeyCode = eventObj.keyCode;
	/*if ((elKeyCode == 114) || (elKeyCode == 122) || (elKeyCode == 116)){
		return 0;
	}*/
}

function setBackgroundFlash(){
	var back=document.createElement("DIV");
	backArea.appendChild(back);
	backArea.style.overflow="hidden";
	back.style.position="absolute";
	back.style.top="-20px";
	back.style.left="-20px";
	back.style.width=(getStageWidth()+40)+"px";
	back.style.height=(getStageHeight()+90)+"px";
	back.style.zIndex=1;
	if(MSIE){
		var overBack=document.createElement("DIV");
		overBack.style.position="absolute";
		overBack.style.top="-20px";
		overBack.style.left="-20px";
		overBack.style.width=(getStageWidth()+40)+"px";
		overBack.style.height=(getStageHeight()+90)+"px";
		overBack.style.zIndex=99999;
		overBack.onmousedown=function(evt){cancelBubble(getEventObject(evt));}
		overBack.innerHTML="&nbsp;";
		overBack.style.backgroundColor="#FFFFFF";
		overBack.style.filter="alpha(opacity=0)";
		overBack.style.cursor="pointer";
		backArea.appendChild(overBack);
	}
	back.innerHTML='<object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=6,0,29,0" width="100%" height="100%"><param name="movie" value="flash/background.swf"><param name="wmode" value="transparent"><param name="flashvars" value=""><param name="quality" value="high"><embed src="flash/background.swf" quality="high" pluginspage="http://www.macromedia.com/go/getflashplayer" type="application/x-shockwave-flash" width="100%" height="100%" wmode="transparent" flashvars=""></embed></object>';
}

function setDragDiv(){
	if(!document.getElementById("dragDiv")){
		var dragDiv=document.createElement("DIV");
		dragDiv.style.display="block";
		dragDiv.style.top="-20px";
		dragDiv.style.left="-10px";
		dragDiv.style.width=(getStageWidth()+20)+"px";
		dragDiv.style.height=(getStageHeight()+40)+"px";
		dragDiv.id="dragDiv";
		if(MSIE){
			dragDiv.className="opacity30";
		}
		topArea.appendChild(dragDiv);
	}
}

function unSetDragDiv(){
	if(document.getElementById("dragDiv")){
		topArea.removeChild(document.getElementById("dragDiv"));
	}
}