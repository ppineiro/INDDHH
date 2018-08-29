var MSIE = window.navigator.appVersion.indexOf("MSIE")>=0;
var MSIE6 = window.navigator.appVersion.indexOf("MSIE 6")>=0;
var MSIE7 = window.navigator.appVersion.indexOf("MSIE 7")>=0;
var OPERA = window.navigator.userAgent.toLowerCase().indexOf("opera")>=0;
var FIREFOX = window.navigator.userAgent.toLowerCase().indexOf("firefox")>=0;
var FIREFOXVER = FIREFOX?( window.navigator.userAgent.toLowerCase().charAt(window.navigator.userAgent.toLowerCase().indexOf("firefox/")+8)  ):"";
var MOZILLA = (window.navigator.appVersion.toLowerCase().indexOf("firefox")<0 && window.navigator.userAgent.toLowerCase().indexOf("mozilla")>=0);
var CHROME = ((window.navigator.appVersion.toLowerCase().indexOf("chrome"))>=0);

function getStageWidth(){
	if(MSIE){
		return document.body.parentElement.clientWidth;	
	}else{
		return document.body.offsetWidth;
	}
}
function getStageHeight(){
	if(MSIE){
		var height=document.body.parentElement.clientHeight;
		if(document.body.parentElement.clientHeight==0){
			height=document.body.clientHeight;
		}
		return height;
	}else{
		return height=window.innerHeight;
	}
}

function getAbsolutePosition(element) {
	var r = { x: element.offsetLeft, y: element.offsetTop };
	try{
		if (element.offsetParent) {
			var tmp = getAbsolutePosition(element.offsetParent);
			r.x += tmp.x;
			r.y += tmp.y;
			if(element.parentNode.scrollHeight>element.parentNode.offsetHeight){
				r.x-=element.parentNode.scrollLeft;
				r.y-=element.parentNode.scrollTop;
			}
		}
	}catch(e){}
	return r;
}

function addListener(element,eventName,func){
	if(document.body.attachEvent){
		element.attachEvent("on"+eventName, function(){var event=window.event;event.element=element;func(event);});
	}else{
		element.addEventListener(eventName,function(event){event.element=element;func(event);}, false);
	}
}

function removeListener(element,eventName,func){
	if(document.body.detachEvent){
		element.detachEvent("on"+eventName, function(){var event=window.event;event.element=element;func(event);});
	}else{
		element.removeEventListener(eventName, function(event){event.element=element;func(event);}, false);
	}
}

function cancelBubble(evt){
	if(window.event){evt=window.event;}
	evt.cancelBubble=true;
}

function fireEvent(element,evtName){
	if(element.fireEvent){
		element.fireEvent("on"+evtName, null);
	}else{
		var evt=null;
		if(evtName=="mousedown" || evtName=="mouseup" || evtName=="click" || evtName=="mousemove"){
			evt=window.document.createEvent("MouseEvent");
			evt.initEvent(evtName, false, true); 
        	element.dispatchEvent(evt);
		} 
		evt={target:element};
		try{element["on"+evtName](evt);}catch(e){}
	}
}

function setSelection(el, pos1, pos2){
	if(el.setSelectionRange){
		el.focus();
		el.setSelectionRange(pos1, pos2);
	}else if(el.createTextRange){
		var range = el.createTextRange();
		range.collapse(true);
		range.moveEnd('character', pos1);
		range.moveStart('character', pos2);
		range.select();
	}
}

function unsetSelection(el){
	setSelection(el,0,0)
}

function getEventObject(evt){
	if(MSIE){
		return window.event;
	}
	return evt;
}

function getEventSource(evt){
	if(MSIE){
		return window.event.srcElement;
	}
	return evt.target;
}

function ScriptLoader(){
	
	this.load=function(url){
		var script=document.createElement("SCRIPT");
		script.src=url;
		script.loader=this;
		document.getElementsByTagName("HEAD")[0].appendChild(script);
		if(MSIE){
			script.onreadystatechange= function () {
      			if (this.readyState == "loaded" || this.readyState == "complete") {
      				this.onload();
      			}
   			}
		}
		script.onload=function(){
			this.loader.onload();
		}
	}
	
	this.onload=function(){}
}

function setSubIFrameMouseDown(iframe){

	function setMouseEvents(ifr){
		try{
		ifr.addListener(ifr.document,"mousedown",function(e){
			fireEvent(ifr.frameElement,"mousedown");}
		);
		ifr.addListener(ifr.document,"mouseup",function(e){
			fireEvent(ifr.frameElement,"mouseup");}
		);
		ifr.addListener(ifr.document,"mousemove",function(e){
			fireEvent(ifr.frameElement,"mousemove");}
		);
		ifr.addListener(ifr.document,"click",function(e){
			fireEvent(ifr.frameElement,"click");}
		);
		
		ifr.setMouseEvents=setMouseEvents;
		
		var iframes=ifr.document.getElementsByTagName("IFRAME");
		for(var i=0;i<iframes.length;i++){
			ifr.addListener(iframes[i],"load",function(e){
				e=ifr.getEventObject(e);
				var el=ifr.getEventSource(e);
				setMouseEvents(ifr.frames[el.name]);
			});
		}
		}catch(e){}
	}
	
	setMouseEvents(window.frames[iframe.name])

}


function getUrlVar(url,varName){
	var values=null;
	if(url.indexOf(varName)>=0){
		var arrAux=url.split(varName);
		values=new Array();
		for(var i=1;i<arrAux.length;i++){
			var actual=arrAux[i];
			if(actual.charAt(0)=="="){
				var value="";
				var charPos=1;
				while(actual.charAt(charPos)!="&" && charPos<actual.length){
					value+=actual.charAt(charPos);
					charPos++;
				}
				values.push(value);
			}
		}
	}
	return (values && values.length==1)?values[0]:values;
}


function sendVars(url,vars){
	var doc;
	doc=new XMLHttpRequest();
	doc.open("POST", url, false); 
	doc.setRequestHeader("content-type","application/x-www-form-urlencoded; charset=utf-8");
//	doc.setRequestHeader("Content-length", (vars.length+500));
	doc.send(vars); 
}