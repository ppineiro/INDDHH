var modalsOpen=0;
var modalsOpened=new Array();
function openWinModal(url, width, height, top, left, zindex, callerWindow){
	modalBlock();
	var win=document.createElement("div");
	win.style.position="absolute";
	win.style.width=width+"px";
	win.style.height=(height+15)+"px";
	win.style.top="0px";
	win.style.top=top+"px";
	win.style.left=left+"px";
	win.className="modalWin";
	/*var zindex=0;
	var iframes=document.getElementsByTagName("IFRAME");
	for(var i=0;i<iframes.length;i++){
		if(zIndex<iframes.style.zIndex){
			zIndex=iframes.style.zIndex;
		}
	}
	win.style.zIndex=zIndex;*/
	if(zindex!=0){
		win.style.zIndex=zindex;
	}else{
		win.style.zIndex=9999;
	}
	var iframeWidth=width;
	var iframeHeight=height;
	if (!MSIE){
		iframeWidth=width-4;
		iframeHeight=iframeHeight-4;
	}
	var closeBtn=document.createElement("DIV");
	closeBtn.style.position="absolute";
	closeBtn.style.width="15px";
	closeBtn.style.height="15px";
	closeBtn.style.top="0px";
	win.appendChild(closeBtn);
	closeBtn.style.left=(width-15)+"px";
	closeBtn.className="closeButton";
	closeBtn.onclick=function(){
		this.parentNode.closeModal();
	}
	closeBtn.onmousedown=function(evt){
		evt=getEventObject(evt);
		evt.cancelBubble=true;
	}
	var content=document.createElement("IFRAME");
	content.scrolling="no";
	content.style.position="absolute";
	content.style.width=iframeWidth+"px";
	content.style.height=iframeHeight+"px";
	content.style.top="15px";
	content.frameBorder=0;
	content.id="modal"+modalsOpen;
	content.name="modal"+modalsOpen;
	content.style.zIndex=9990;
	if(url!=""){
		content.src=url;
	}
	win.onmodalload=function(){};
	win.appendChild(content);
	win.content=win.getElementsByTagName("iframe")[0];
	win.content.scrolling="NO";
	/*var divCloser=document.createElement("div");
	divCloser.style.backgroundColor="#999999"
	divCloser.style.width="10px";
	divCloser.style.height="10px";
	divCloser.style.position="absolute";
	divCloser.style.top="1px";
	divCloser.style.zIndex=999999999999999999999;
	divCloser.style.left=(iframeWidth-10)+"px";
	divCloser.onclick=function(){}
	win.appendChild(divCloser);*/
	win.content.container=win;
	//document.body.appendChild(win);
	getModalArea().appendChild(win);
	win.content.style.left=((win.clientWidth-win.content.offsetWidth)/2)+"px";
	win.closeModal=function(){
		var content=window.frames[this.content.id];
		for(var i=0;i<window.frames.length;i++){
			var winName="";
			try{
				winName=window.frames[i].name
				if(winName==this.content.id){
					content=window.frames[i];
				}
			}catch(e){
			}
		}
		var o=new Object();
		try{
		o.returnValue=content.returnValue;
		this.returnValue=content.returnValue;
		}catch(e){}
		for(var i=0;i<modalsOpened.length;i++){
			if(this==modalsOpened[i]){
				modalsOpened.splice(i,1);
			}
		}
		this.parentNode.removeChild(this);
		if(modalsOpened.length>0){
			modalsOpened[modalsOpened.length-1].style.display="block";
		}
		if(modalsOpened.length==0){
			if(MSIE){
				getModalArea().style.height="0px";
				getModalArea().style.width="0px";
				getModalArea().style.position="";
			}
			modalUnBlock();
		}
		if(this.onclose){
			this.onclose();
			this.onclose=null;
		}
		if(MSIE && window.frames["workArea"]){
			window.frames["workArea"].focus();
		}
	}
	if (!MSIE){
		document.getElementById("modal"+modalsOpen).addEventListener('load', function(){
			try{
				window.frames[this.name].close=function(){
					var modal=this.parent.document.getElementById(this.name);
					modal.parentNode.closeModal();
				}
			}catch(e){}
			this.dialogArguments=callerWindow;
			window.frames[this.name].setTimeout('var dialogArguments=window.parent.document.getElementById(window.name).dialogArguments;try{init()}catch(e){}',100);
			//modalsOpen++;
			if("modal"+modalsOpen==this.name){
				modalsOpen++;
			}
			try{
				this.container.onload(this.container);
				this.container.onload=null;
			}catch(e){}
		}
		, false);
	}else{
		var func=function(){
			var element=window.event.srcElement;
			if (element.readyState=="complete"){
				try{
					window.frames[element.id].close=function(){
						if(this.parent.document.getElementById(element.name)){
							element.parentNode.closeModal();
						}
					}
				}catch(e){}
				window.frames[element.id].name=element.id;
				try{
				window.frames["modal"+element.id].dialogArguments=callerWindow;
				window.frames["modal"+element.id].init();
				}catch(e){}
				if("modal"+modalsOpen==element.id){
					modalsOpen++;
				}
				try{
					element.container.onload(this.container);
					element.container.onload=null;
				}catch(e){}
				}
		}
		document.getElementById("modal"+modalsOpen).attachEvent("onreadystatechange", func);
	}
	modalsOpened.push(win);
	makeDraggable(win);
	return win;
}
function xShowModalDialog( sURL, vArguments, sFeatures, callerWindow ){
	if(sURL==null){
		sURL="";
	}
	if(vArguments==null){
		vArguments="";
	}
	if(sFeatures==null){
		sFeatures="";
	}
    if (sURL==''){ 
        alert ("Invalid URL input."); 
        return false; 
    } 
	var sFeatures = sFeatures.replace(/ /gi,''); 
    var aFeatures = sFeatures.split(";"); 
    sWinFeat = "directories=0,menubar=0,titlebar=0,toolbar=0,"; 
    var pWidth;
    var pHeight;
    var pTop;
    var pLeft;
    var zindex=0;
    for (var x=0;x<aFeatures.length;x++){
	    if(aFeatures[x]!=""){
	        aTmp = aFeatures[x].split(":"); 
	        sKey = aTmp[0].toLowerCase(); 
	        sVal = aTmp[1];
	        switch (sKey){ 
	            case "dialogheight": 
		            pHeight = parseInt(sVal); 
	                break; 
	            case "dialogwidth":
	            	pWidth= parseInt(sVal);
	                break; 
	            case "dialogtop": 
		            pTop= sVal;
	                break; 
	            case "dialogleft": 
	                pLeft= sVal; 
	                break;
	            case "zindex": 
	                zindex= sVal; 
	                break; 
	        }
        }
    }
	var height=window.innerHeight-8;
	var width=(document.body.offsetWidth-15);
	if(MSIE){
		height=document.body.parentNode.clientHeight-10;
		width=document.body.parentNode.clientWidth-5;
	}
	pTop=(height-pHeight)/2;
	pLeft=(width-pWidth)/2;
	var win=openWinModal(sURL, pWidth, pHeight, pTop, pLeft, zindex, callerWindow);
    return win;
}
var modalBlocker;
function modalBlock(){
	if(modalsOpened.length>0){
		modalsOpened[modalsOpened.length-1].style.display="none";
	}
	if(!modalBlocker){
		modalBlocker=document.createElement("IFRAME");
		modalBlocker.allowtransparency="true";
		modalBlocker.style.backgroundColor="#000000";
		modalBlocker.style.opacity="0.05";
		modalBlocker.style.filter="alpha(opacity=30)";
		modalBlocker.style.zIndex="999";
		modalBlocker.style.position="absolute";
		modalBlocker.style.display="none";
		modalBlocker.id="modalBlocker";
		modalBlocker.name="modalBlocker";
		
		document.body.appendChild(modalBlocker);
		
		var doc;
		if(modalBlocker.contentDocument){
		      doc = modalBlocker.contentDocument;
		}else if(modalBlocker.contentWindow){
		      doc = modalBlocker.contentWindow.document;
		}else if(modalBlocker.document){
		      doc = modalBlocker.document;
		}
		doc.open();
		doc.close();
		if (document.addEventListener) {
			doc.addEventListener('keypress', handleKey, true); 
		}else{
			doc.attachEvent('onkeydown', handleKey); 
		}
		
		var height=window.innerHeight;
		var width=(document.body.offsetWidth+2);
		if(navigator.userAgent.indexOf("MSIE")>0){
			width=document.body.clientWidth;
			height=document.documentElement.clientHeight;
		}
		document.body.style.display="none";
		modalBlocker.style.display="block";
		modalBlocker.style.width=width+"px";
		modalBlocker.style.height=height+"px";
		modalBlocker.style.left="0px";
		modalBlocker.style.top="0px";
		modalBlocker.style.filter="alpha(opacity=30)";
		document.body.style.display="block";
	}
}

function getModalArea(){
	var modalArea=document.getElementById("modalArea");
	if(!modalArea){
		modalArea=document.createElement("DIV");
		modalArea.id="modalArea";
		document.body.appendChild(modalArea);
		modalArea.style.zIndex=999999999;
	}
	return modalArea;
}

function modalUnBlock(){
	if(modalBlocker.parentNode){
		document.body.style.display="none";
		modalBlocker.parentNode.removeChild(modalBlocker);
		document.body.style.display="block";
		modalBlocker=null;
	}
}

function makeDraggable(modal){
	modal.onmousedown=function(evt){
		evt=getEventObject(evt);
		if(!this.startX && !this.startY){
			this.startMX=getMouseX(evt);
			this.startMY=getMouseY(evt);
			this.startX=this.offsetLeft;
			this.startY=this.offsetTop;
		}
		this.onmousemove=function(evt){
			evt=getEventObject(evt);
			this.moveTo(getMouseX(evt),getMouseY(evt));
		}
		
		this.moveTo=function(x,y){
			if(!this.startX && !this.startY){
				this.startMX=x;
				this.startMY=y;
				this.startX=this.offsetLeft;
				this.startY=this.offsetTop;
			}
			this.style.top=(this.startY-(this.startMY-y))+"px";
			this.style.left=(this.startX-(this.startMX-x))+"px";
		}
		if(MSIE){
			this.parentNode.style.overflow="hidden";
			this.parentNode.style.position="absolute";
			this.parentNode.style.top="0px";
			this.parentNode.style.left="0px";
			this.parentNode.style.width=getStageWidth()+"px";
			this.parentNode.style.height=getStageHeight()+"px";
		}
		if(!document.getElementById("modalDragger")){
			var div=document.createElement("DIV");
			div.id="modalDragger";
			div.style.position="absolute";
			if(MSIE){
				div.style.zIndex=this.parentNode.style.zIndex;
			}else{
				div.style.zIndex=9999999999;
			}
			div.style.top="0px";
			div.style.left="0px";
			div.style.backgroundColor="#FFFFFF";
			div.style.height=getStageHeight()+"px";
			div.style.width=getStageWidth()+"px";
			div.style.opacity="0.001";
			div.style.filter="alpha(opacity=0.1)";
			document.body.appendChild(div);
		}
		
		document.getElementById("modalDragger").onmousemove=function(evt){
		//this.parentNode.onmousemove=function(evt){
			evt=getEventObject(evt);
			modal.moveTo(getMouseX(evt),getMouseY(evt));
		}
		document.getElementById("modalDragger").onmouseup=function(evt){
		//this.parentNode.onmouseup=function(evt){
			modal.clear();
		}
	}
	
	modal.clear=function(){
		this.startMX=null;
		this.startMY=null;
		this.startX=null;
		this.startY=null;
		this.onmousemove=null;
		document.body.style.display="none";
		if(document.getElementById("modalDragger")){
			//this.parentNode.onmousemove=null;
			//this.parentNode.onmouseup=null;
			document.getElementById("modalDragger").onmousemove=null;
			document.getElementById("modalDragger").onmouseup=null;
			document.getElementById("modalDragger").parentNode.removeChild(document.getElementById("modalDragger"));
		}
		document.body.style.display="block";
	}
	
	modal.onmouseup=function(evt){
		this.clear();
	}
}