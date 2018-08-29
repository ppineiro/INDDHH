document.onkeypress=function(evt){
	evt=getEventObject(evt);
	var obj=getEventSource(evt);
	if(evt.keyCode==13 && obj.tagName=="INPUT"){
		if(MSIE){
			evt.keyCode=0;
		}else{
			evt.preventDefault();
		}
		evt.cancelBubble = true;
		return null;
	}
}

// -----install the global error-handler
//window.onerror = errorHandler;
//objects are drawn offscreen before being made visible to the user
//window.offscreenBuffering = true;


function hideResultFrame() {
	var win=window;
	while((!win.document.getElementById("iframeMessages") || !win.document.getElementById("workArea") || !win.document.getElementById("iframeResult")) && (win!=win.parent) ){
		win=win.parent;
	}
	if(win.document.getElementById("iframeMessages") && win.document.getElementById("iframeResult")){
		win.document.getElementById("iframeMessages").hideResultFrame();
		win.document.getElementById("iframeResult").hideResultFrame();
	}
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
	var elKeyCode = eventObj.keyCode;
	var shft = eventObj.shiftKey;
	var ctr = eventObj.ctrlKey;
	var alt = eventObj.altKey;
	var element=getEventSource(eventObj);
		if(alt && MSIE){
			var win=window;
			var blocker=null;
			while(win.document!=document && (!win.document.getElementById("workArea") || !blocker)){
				win=win.parent;
				if(win.document.getElementById("workArea") && win.blocker){
					blocker=win.blocker;
				}
			}
			evt=window.event;
			if (blocker){
				if (blocker.style.display=="block"){
					return 0;
				}
			}
		}
		if ((elKeyCode == 8)){
				//-----------------------------cancel--F3-F11-F5----------------//
			if (element.tagName != "INPUT" && element.tagName != "TEXTAREA") {
				return 0;
				}
			}

		if(!CHROME){
			if ((elKeyCode == 114) || (elKeyCode == 122) || (elKeyCode == 116)){
					//-----------------------------cancel--F3-F11-F5----------------//
				return 0;
				}
		}

		if (alt){	
			if ((elKeyCode == 36) || (elKeyCode == 39) || (elKeyCode == 37)){
				return 0;
			}
			//------------------PRESSED ALT+0 = MAXIMIZE/MINIMIZE tabElement-----//
			if ((elKeyCode == 48)){
					tabEl=getTabsInDocs();
					if(tabEl!=null){
						tabEl.MaximizeTabs();
					}
					
			}
		}

		if (ctr){	
			if ((elKeyCode == 70) || (elKeyCode == 82) || (elKeyCode == 116)){
			return 0;
			}
			if ((elKeyCode == 79) || (elKeyCode == 76) || (elKeyCode == 78)){
			return 0;
			}
			if ((elKeyCode == 87) || (elKeyCode == 83) || (elKeyCode == 80)){
			return 0;
			}
			if ((elKeyCode == 69) || (elKeyCode == 73) || (elKeyCode == 72)){
			return 0;
			}
			if (elKeyCode == 37){
			return 0;
			}
		}
	
//		if (elKeyCode == 112){
//			//-------------------------You pressed F1, the Help was canceled...------//
//			//Lanching OUR Help
//			//window.showHelp ("ms-its://adfac01/adfacTelas/helpSystem/AdfacHelp.chm::/HTMLs/AdfacHelp/AdfacHelp.html");	
//		}
	
		if (eventObj.keyCode == 113){
				//---------------------------------F2--HIDE TOC EXPLORER--------//
				top.toggleExplorer();
				return 0;
			}
}

function preloadImages() {
  if (!document.images) return;
  var ar = new Array();
  var arguments = preloadImages.arguments;
  for (var i = 0; i < arguments.length; i++) {
    ar = new Image();
    ar.src = URL_STYLE_PATH + arguments[i];
  }
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
		if(ret[element]){
			delete ret[element];
			for(var i in ret){
				if(ret[i]){
					return;
				}
			}
			delete listenerFunctions[func];
		}
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

var firingModalEvent=false;

function fireModalEvent(input,url,func){
	firingModalEvent=true;
	//don't execute check if input is disabled, as the value came from the modal query and is already checked
	if(input.disabled){
		return;
	}
	//alert((new Date()).getSeconds()+":"+(new Date()).getMilliseconds()+" ");

	var urlCheck=url.split("fireModal").join("checkModalValue")+"&value="+escape(input.value)+"&"+input.name+"="+escape(input.value);
	var inputs=input.parentNode.getElementsByTagName("INPUT");
	var val=null;
	var rowId=null;
	for(var i=0;i<inputs.length;i++){
		if(inputs[i].type=="hidden" && inputs[i].id.indexOf("ROWID")<0){
			val=inputs[i];
		}else if(inputs[i].type=="hidden" && inputs[i].id.indexOf("ROWID")>0){
			rowId=inputs[i];
		}
		
	}
	if(val){
		urlCheck+="&"+input.name+"="+escape(val.value);
	}
	if(rowId){
		urlCheck+="&"+rowId.name+"="+rowId.value;
	}
	
	var strFunc=(func+"");
	strFunc=strFunc.substring((strFunc.indexOf("{")+1),(strFunc.length-1));
	var f=new Function(strFunc);
	input.tmpFnc=func;
	var index=0;
	var manualFire=input.getAttribute("manualFire");
	if(input.getAttribute("grid")=="true"){
		index=getParentRow(input).rowIndex-1;
	}
	var loader=new xmlLoader(loaded);
	loader.onload=function(response){
		if(response.firstChild.nodeValue=="OK"){
			var val=null;
			var inputs=input.parentNode.getElementsByTagName("INPUT");
			for(var i=0;i<inputs.length;i++){
				if(inputs[i].type=="hidden" && inputs[i].name.indexOf("ROWID")<0){
					val=inputs[i];
				}
			}
			if(val){
				val.value = response.getAttribute("hiddenValue");
			}
			input.tmpFnc();
			document.getElementById("frmMain").action =url+"&index="+index+"&manualFire="+manualFire;
			input.setAttribute("manualFire","true");
			submitFormReload(document.getElementById("frmMain"));
			firingModalEvent=false;
		}else{
			input.value="";
			//para el caso que el input tenga mascara se llama al clear
			try{
			input.clear();
			}catch(e){}
		}
	}
	loader.load(urlCheck+"&index="+index+"&manualFire="+manualFire+"&value="+escape(input.value)+"&storeValue="+input.parentNode.childNodes[0].value);
}

function getTabsInDocs(){
/*	
	getTabEl=document.getElementsByTagName("tabElement");
		if(getTabEl[0]!=null){
			return getTabEl[0];
		}else{
			getTabEl=parent.document.getElementsByTagName("tabElement");
				if(getTabEl[0]!=null){
						return getTabEl[0];
				}else{
				return null;
				}
		}
*/
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
        	return;
		} 
		evt={target:element};
		try{element["on"+evtName](evt);}catch(e){}
	}
}

function setDispatcherId(elem){
	if(!window.name.indexOf("feedBack")>=0){
		if(elem){
			firstFocusSet=false;
			window.parent.dispatcherId=elem.id;
			if(document.getElementById("divContent")){
				setDispatcherScroll(document.getElementById("divContent").scrollTop);
			}
		}else{
			window.parent.dispatcherId=null;
			setDispatcherScroll(null);
		}
	}
}

function getDispatcherId(){
	return window.parent.dispatcherId;
}

function setDispatcherIndex(index){
	if(index!=null){
		window.parent.dispatcherIndex=index;
	}else{
		window.parent.dispatcherIndex=null;
	}
}

function getDispatcherIndex(){
	return window.parent.dispatcherIndex;
}

function setDispatcherScroll(scroll){
	if(scroll){
		window.parent.dispatcherScroll=scroll;
	}else{
		window.parent.dispatcherIndex=null;
	}
}

function getDispatcherScroll(){
	return window.parent.dispatcherScroll;
}

if (document.addEventListener) {
	document.addEventListener('keyup', handleKey, true);
}else{
	document.attachEvent('onkeyup', handleKey);
}


