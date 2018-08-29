var MSIE = window.navigator.appVersion.indexOf("MSIE")>=0;
var MSIE6 = window.navigator.appVersion.indexOf("MSIE 6")>=0;
var MSIE7 = window.navigator.appVersion.indexOf("MSIE 7")>=0;
var OPERA = window.navigator.userAgent.toLowerCase().indexOf("opera")>=0;
var FIREFOX = window.navigator.appVersion.toLowerCase().indexOf("firefox")>=0;
var MOZILLA = (window.navigator.appVersion.toLowerCase().indexOf("firefox")<0 && window.navigator.userAgent.toLowerCase().indexOf("mozilla")>=0);

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

function HashTable(){
	this.elements=new Array();
	this.getElement=function(key){
		for(var i=0;i<this.elements.length;i++){
			if(this.elements[i].key===key){
				return this.elements[i].element;
			}
		}
		return null;
	}
	this.addElement=function(key,element){
		if(this.getElement(key)==null){
			this.elements.push({key:key,element:element});
		}
	}
	this.removeElement=function(key){
		for(var i=0;i<this.elements.length;i++){
			if(this.elements[i].key===key){
				delete this.elements[i].element;
				delete this.elements[i].key;
				this.elements.splice(i,1);
			}
		}
	}
}

var listenerFunctions=new HashTable();

function getListenerFunction(func,element){
	var ret=listenerFunctions.getElement(func);
	if(!ret){
		ret=new HashTable();
		listenerFunctions.addElement(func,ret);
	}
	
	if( !ret.getElement(element) ){
		var fnc;
		if(MSIE){
			var anchor={element:element};
			fnc=function(event){
				var event=window.event;
				event.element=anchor.element;
				func(event);
			}
		}else{
			fnc=function(event){
				event.element=event.currentTarget;
				func(event);
			}
		}
		ret.addElement(element,fnc);
	}
	return ret.getElement(element);
}

function removeListenerFunction(func,element){
	var ret=listenerFunctions[func];
	if(ret){
		if(MSIE){
			for(var o in ret){
				if(o.tagName){
					//alert("BORRRO dale ret   "+(o===element));
					o.style.border="7px solid red";
				}
			 	if(o===element){
			 		delete ret[o];
			 		break;
			 	}
			}
		}else{
			if(ret[element]){
				delete ret[element];
			}
		}
		for(var i in ret){
			if(ret[i]){
				return;
			}
		}
		delete listenerFunctions[func];
	}
}

function addListener(element,eventName,func){
	var fnc=getListenerFunction(func,element);
	if(document.body.attachEvent){
		element.attachEvent("on"+eventName, fnc);
	}else{
		element.addEventListener(eventName,fnc, false);
	}
}

function removeListener(element,eventName,func){
	if(document.body.detachEvent){
		element.detachEvent("on"+eventName, getListenerFunction(func,element));
	}else{
		element.removeEventListener(eventName, getListenerFunction(func,element), false);
	}
	removeListenerFunction(func,element);
}

function getMouseX(aEvent){
	if(MSIE){
		aEvent=getEventObject(aEvent);
		return(aEvent.clientX + document.body.scrollLeft);
	}else{
		return(aEvent.pageX);
	}	
}

function getMouseY(aEvent){
	if(MSIE){
		aEvent=getEventObject(aEvent);
		return(aEvent.clientY + document.body.scrollTop);
	}else{
		return(aEvent.pageY);
	}	
}

function hitTest(obj,obj2){
	var coords=getAbsolutePosition(obj);
	if(obj2.x && obj2.y){
		var x=obj2.x;
		var y=obj2.y;
		if(x>(coords.x) && x<(coords.x+obj.offsetWidth) && y>(coords.y) && y<(coords.y+obj.offsetHeight)){
			return true;
		}else{
			return false;
		}
	}else if(obj && obj2){
		var coords2=getAbsolutePosition(obj2);
		var isX=false;
		if( (coords.x<coords2.x && coords2.x<(coords.x+obj.offsetWidth)) ||
			(coords2.x<coords.x && coords.x<(coords2.x+obj2.offsetWidth)) ){
			isX=true;
		}
		var isY=false;
		if( (coords.y<coords2.y && coords2.y<(coords.y+obj.offsetHeight)) ||
			(coords2.y<coords.y && coords.y<(coords2.y+obj2.offsetHeight)) ){
			isY=true;
		}
		return (isX && isY);
	}
	//if(x>(obj.offsetLeft) && x<(obj.offsetLeft+obj.offsetWidth) && y>(obj.offsetTop) && y<(obj.offsetTop+obj.offsetHeight)){
}
function getAbsolutePosition(element) {
	var r = { x: element.offsetLeft, y: element.offsetTop };
	if (element.offsetParent) {
		var tmp = getAbsolutePosition(element.offsetParent);
		r.x += tmp.x;
		r.y += tmp.y;
	}
	return r;
}

function getElementsByClassName(className){
	var all=document.getElementsByTagName("*");
	var elements=new Array();
	for(var i=0;i<all.length;i++){
		if(all[i].className.indexOf(className)>=0){
			elements.push(all[i]);
		}
	}
	return elements;
}

function fireElementEvent(element,evtName){
	if(element.fireEvent){
		element.fireEvent("on"+evtName, null);
	}else{
		element["on"+evtName](new Object());
	}
}

function getStageWidth(){
	if(navigator.userAgent.indexOf("MSIE")>0){
		return document.body.parentElement.clientWidth-5;	
	}else{
		return document.body.offsetWidth-5;
	}
}
function getStageHeight(){
	if(navigator.userAgent.indexOf("MSIE")>0){
		var height=document.body.parentElement.clientHeight;
		if(document.body.parentElement.clientHeight==0){
			height=document.body.clientHeight;
		}
		return height;
	}else{
		return height=window.innerHeight;
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

function makeUnselectable(element) {
	element.onselectstart = function() {
		return false;
	}
	element.unselectable = "on";
	element.style.MozUserSelect = "none";
	element.style.cursor = "default";
}

function unsetSelection(el){
	setSelection(el,0,0)
}

function xmlLoader(){
	var doc;
	try{
		if(!MSIE){
			doc=new XMLHttpRequest();
			doc.load=function(url){
				this.open("GET",url,false);
				if(!MSIE){
					this.overrideMimeType('text/xml');
				}
				this.ignoreWhitespace=true;
				this.send(null);
			}
		}else{
			doc = new ActiveXObject("Microsoft.XMLDOM");
			doc.validateOnParse = false;
			doc.async = true;
			doc.preserveWhiteSpace = false;
		}
	}
	catch(err){
	}
	this.doc=doc;
	var tmp=this;
	this.load=function(url){
		if(MSIE){
			tmp.doc.onreadystatechange=function(){
				if(doc.readyState==4){
					if(doc.lastChild){
						tmp.xmlLoaded=doc.lastChild;
					}
					tmp.onload(tmp.xmlLoaded);
				}
			}
		}else{
			this.doc.parentObject=this;
			this.doc.onload=function(){
				this.parentObject.xmlLoaded=this.responseXML;
				this.parentObject.onload(this.parentObject.xmlLoaded.firstChild);
			}
		}
		this.doc.load(url);
	}
	this.loadString=function(xmlString){
		var xmlData; 
		if(MSIE){
			xmlData = new ActiveXObject("Microsoft.XMLDOM"); 
			xmlData.async="false"; 
			xmlData.loadXML(xmlString); 
		}else{ 
			var parser = new DOMParser(); 
			xmlData = parser.parseFromString(xmlString,"text/xml"); 
		}
		return xmlData;
	}
	this.onload=function(xmlLoaded){}
}

function XMLrequest(){
	try{
		var doc;
		if(XMLHttpRequest){
			doc=new XMLHttpRequest();
		}else{
			doc = new ActiveXObject("Microsoft.XMLDOM");
			doc.validateOnParse = false;
			doc.async = true;
			doc.preserveWhiteSpace = false;
		}
		return doc;
	}
	catch(err){
		return null;
	}
}

function sendVars(url,vars){
	var doc;
	doc=new XMLrequest();
	doc.open("POST", url, false); 
	doc.setRequestHeader("content-type","application/x-www-form-urlencoded");
	doc.send(vars); 
}