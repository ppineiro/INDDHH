// JavaScript Document
var maxDepth=1000;
var dragWindow=1100;
var windows=new Array();
var focusedWindow;

var modalWin;

function createWindow(id,title){
	var win=document.createElement("div");
	//win.style.width="350px";
	//win.style.haight="250px";
	
	win.listView=false;
	win.iconView=false;
	win.winTitle=title;
	
	win.url="";
	win.id="window_"+id;
	
	win.style.border="1px solid black";
	win.name=title.toUpperCase();
	win.style.zIndex=maxDepth;
	maxDepth++;
	drawWindow(win);
	
	win.setListView=function(){
		if(!this.listView){
			setGrid(this.content);
			this.listView=true;
			this.iconView=false;
			this.content.setDataSource(this.objectData.elements);
		}
	}
	win.setIconsView=function(){
		if(!this.iconView){
			setIconView(this.content);
			this.listView=false;
			this.iconView=true;
			this.content.setDataSource(this.objectData.elements);
		}
	}
	win.close=function(){
		stopObjTilt(this);
		//try{win.onclose();}catch(e){}
		try{this.onclose();}catch(e){}

		//Seteamos el foco en el primer elemento
		try {
			var ifrs = win.getElementsByTagName("iframe");
			if(ifrs && ifrs.length > 0) {
				var ifr = ifrs[0];				
				var els = ifr.contentWindow.document.getElementById("divContent").childNodes[0].elements;
				for(var el_iter = 0; el_iter < els.length; el_iter++){
					try {
						els[el_iter].focus();
						break;
					} catch(e){}
				}
			}
		} catch(e) {}	
		
		dock.removeElement(win.minimizedwin);
		if(this.ownerIcon){
			this.ownerIcon.getObject().elementWindow=null;
			this.ownerIcon=null;
		}
		for(var i=0;i<windows.length;i++){
			if(windows[i]==this){
				windows.splice(i,1);
			}
		}
		try{
			this.parentNode.removeChild(this);
		}catch(e){	}
	}
	win.minimize=function(){
		if(this.minimized!=true){
			if(!this.maximized){
				this.actualWidth=win.offsetWidth;
				this.actualHeight=win.offsetHeight;
				this.actualTop=win.offsetTop;
				this.actualLeft=win.offsetLeft;
			}
			if(MSIE){
				this.style.display="none";
			}else{
				this.actualLeft=win.offsetLeft;
				this.style.left=(getStageWidth()+100)+"px";
			}
			this.style.width=(300,22);
			this.minimized=true;
		}else{
			if(MSIE){
				this.style.display="block"
			}else{
				this.style.left=this.actualLeft+"px";
			}
			if(!this.maximized){
				this.setSize(this.actualWidth,this.actualHeight);
			}
			this.minimized=false;
			this.bringToTop();
			try{window.frames[this.name].emulateLoaded();}catch(e){}
		}
		try{win.onminimized()}catch(e){}
	}
	win.maximize=function(){
		if(!this.maximized){
			win.titleBar.menu[1].text=lblRestoreWindow;
			this.actualWidth=win.offsetWidth;
			this.actualHeight=win.offsetHeight;
			this.actualTop=win.offsetTop;
			this.actualLeft=win.offsetLeft;
			this.sizer.style.display="none"
			this.setSize((getStageWidth()-4),(getStageHeight()-35));
			this.style.top="5px";
			this.style.left="0px";
			this.bringToTop();
			this.maxButton.src="styles/"+currStyle+"/images/window/maxBtn1.gif";
			this.maximized=true;
		}else{
			win.titleBar.menu[1].text=lblMaximizeWindow;
			this.sizer.style.display="block"
			this.style.top=this.actualTop+"px";
			this.style.left=this.actualLeft+"px";
			this.setSize(this.actualWidth,this.actualHeight);
			this.maxButton.src="styles/"+currStyle+"/images/window/maxBtn.gif";
			this.maximized=false;
		}
	}
	
	win.createFolder=function(){
		var aux=new folder({icon:"styles/"+currStyle+"/images/folder_icon.png",name:"",url:"",elements:new Array()});
		//var icon=aux.getIconElement();
		var icon=this.addElement(aux);
		icon.changeName=function(){
			startNameWriter(this);
		}
		startNameWriter(icon);
	}
	
	windows.push(win);
	//document.body.appendChild(win);
	deskTop.appendChild(win);
	/*win.titleBar=win.getElementsByTagName("DIV")[0];
	win.content=win.getElementsByTagName("DIV")[1];
	win.sizer=win.getElementsByTagName("DIV")[2];
	win.minButton=win.titleBar.getElementsByTagName("IMG")[0];
	win.closeButton=win.titleBar.getElementsByTagName("IMG")[1];*/
	
	new Draggable("window_"+id, {onStart:function(){setDragDiv();},onEnd:function(){unSetDragDiv();},revert:false,handle:win.titleBar,zindex:2000,endeffect:function(e){e.bringToTop()}});
	return win;
}
var windowsId=0;
function winSortCascade(){
	var depthIni=maxDepth-windows.length;
	for(var i=0;i<windows.length;i++){
		if(!windows[i].minimized && !windows[i].maximized){
			windows[i].style.top=(100+(i*20))+"px";
			windows[i].style.left=(100+(i*20))+"px";
			windows[i].style.zIndex=depthIni+i;
		}
	}
}

function drawWindow(win){
	var title=(win.winTitle)?win.winTitle:"";
	win.style.position="absolute";
	win.className="window";
	win.innerHTML="<div class='winDrag' style='width:400px;height:20px;position:relative;vertical-align:top'><table width='100%'><tr><td><div style='white-space:nowrap;'>"+title.toUpperCase()+"</div></td><td width=0px align=right valign='top' style='vertical-align:top;'><img style='position:relative;top:-2px;' src='min_btn.gif'><span style='visibility:hidden'>|</span><img style='position:relative;top:-2px;' src='styles/"+currStyle+"/images/close_btn.gif'></td></tr></table></div><div style='width:396px;height:276px;position:relative;overflow:auto;z-index:5;' class='winContent'></div><div class='winSizer' style='width:10px;height:10px;z-index:1;position:absolute;top:240px;left:340px;'></div>";//<iframe name='loader_"+id+"' id='loader_"+id+"' style='display:none;visibility:hidden;'></iframe>"
	win.titleBar=win.getElementsByTagName("DIV")[0];
	win.titleBar.innerHTML="<table width='100%' cellpadding='0' cellspacing='0'><tr> <td width='23px'><img src='styles/"+currStyle+"/images/window/winCorner1.gif'></td> <td style='background-image:url(styles/"+currStyle+"/images/window/winMiddle.gif);background-repeat:repeat-x;'><div style='white-space=nowrap;cursor:pointer;cursor:default'>"+title.toUpperCase()+"</div><div style='position:absolute;'><img src='styles/"+currStyle+"/images/window/minBtn.gif'><img src='styles/"+currStyle+"/images/window/maxBtn.gif'><img src='styles/"+currStyle+"/images/window/closeBtn.gif'></div></td> <td width='23px'><img src='styles/"+currStyle+"/images/window/winCorner2.gif'></td> </tr></table>";
	win.titleBar.style.top="-5px";
	win.titleBar.titleText=win.titleBar.getElementsByTagName("DIV")[0];
	win.titleBar.titleText.style.height="20px";
	win.titleBar.titleText.style.left="15px";
	win.titleBar.titleText.style.overflow="hidden";
	win.titleBar.titleText.style.top="3px";
	win.objectData=null;
	win.buttons=win.titleBar.getElementsByTagName("DIV")[1];
	win.content=win.getElementsByTagName("DIV")[3];
	win.content.win=win;
	setIconView(win.content);
	win.sizer=win.getElementsByTagName("DIV")[4];
	win.minButton=win.titleBar.getElementsByTagName("IMG")[1];
	win.maxButton=win.titleBar.getElementsByTagName("IMG")[2];
	win.closeButton=win.titleBar.getElementsByTagName("IMG")[3];

	addListener(win,"mousedown",function(evt){evt=getEventObject(evt);var w=getEventSource(evt);while(w.className!="window"){w=w.parentNode;}w.bringToTop();});
	addListener(win.titleBar,"mousedown",function(evt){evt=getEventObject(evt);var w=getEventSource(evt);while(w.className!="window"){w=w.parentNode;}w.bringToTop();});
	addListener(win.buttons,"mousedown",function(evt){cancelBubble(evt);});
	
	win.setSize=function(width,height){
		this.style.width=width+"px";
		this.style.height=height+"px";
		this.titleBar.style.width=(width-2)+"px";
		this.content.style.width=(width-8)+"px";
		this.content.style.height=((height-22)-8)+"px";
		try{this.content.sizeGrid()}catch(e){}
		if(this.blockDiv){
			this.blockDiv.style.width=(width-8)+"px";
			this.blockDiv.style.height=((height-22)-8)+"px";
			this.blockDiv.style.top="25px";
			this.blockDiv.style.left="5px";
		}
		this.sizer.style.top=(height-10)+"px";
		this.sizer.style.left=(width-10)+"px";
		this.content.style.top="3px";
		this.content.style.left="3px";
		this.buttons.style.top="0px";
		this.buttons.style.left=(width-120)+"px";
		win.titleBar.titleText.style.width=(width-135)+"px";
		this.titleBar.getElementsByTagName("TABLE")[0].style.width=width+"px";
		if(this.content.getElementsByTagName("IFRAME")[0]){
			var iframeWidth=(width)-6;
			var iframeHeight=(height-22)-6;
			if(!MSIE){
				iframeWidth-=3;
				iframeHeight-=3;
			}
			this.content.getElementsByTagName("IFRAME")[0].style.width=iframeWidth+"px";
			this.content.getElementsByTagName("IFRAME")[0].style.height=iframeHeight+"px";
		}
		this.content.sizeMe();
		try{this.onresize();}catch(e){}
	}
	
	win.closeButton.onclick=function(){
		var win=this.parentNode;
		while(win.className!="window"){
			win=win.parentNode;
		}
		reportClose(win.id);
		win.close({element:win});
	}
	win.onmousedown=function(aEvent){
		aEvent=getEventObject(aEvent);
		cancelBubble(aEvent);
	}
	win.clear=function(){
		if(this.content.clear){
			this.content.clear();
		}else{
			this.content.innerHTML="";
		}
		this.elements=new Array();
		this.nextElement=0;
		win.objectData.clear();
	}
	
	win.maximize=function(){}
	win.minimize=function(){}
	win.close=function(){}
	
	win.minButton.onclick=function(){
		win.minimize();
	}
	win.maxButton.onclick=function(){
		win.maximize();
	}
	win.titleBar.ondblclick=function(){
		win.maximize();
	}
	
	win.onblur=function(){
		this.setFlashWmode("transparent");
	}
	win.onfocus=function(){
		this.setFlashWmode("opaque");
	}
	win.setFlashWmode=function(mode){
		try{
			var doc=window.frames[this.name].document;
			if (!MSIE){
				for (var i=0;i<doc.embeds.length;i++){
					doc.embeds[i].setAttribute("wmode",mode);
				}
			}else{ 
				var objs=doc.getElementsByTagName("PARAM");
				for(var i=0;i<objs.length;i++){
					if(objs[i].getAttribute("name")=="flashVars"){
						var vars=updateVariable("WMODE",mode,objs[i].value)
						objs[i].value=vars;
					}
				}
			}
		}catch(e){}
	}
	win.bringToTop=function(){
		if(focusedWindow==this){
			return;
		}
		try{focusedWindow.onblur();}catch(e){}
		focusedWindow=this;
		try{focusedWindow.onfocus();}catch(e){}
		this.style.zIndex=maxDepth;
		if(this.content.getElementsByTagName("IFRAME")[0]){
			var frame=this.content.getElementsByTagName("IFRAME")[0];
			frame.style.zIndex=maxDepth;
			if(MSIE && window.frames[frame.name]){
				window.frames[frame.name].setFirstFocus();
			}
		}
		maxDepth++;
		insideStage(this);
	}
	new Draggable(win.sizer, {revert:false,onStart:function(){setDragDiv();},onEnd:function(){unSetDragDiv();},change:function(e){if(e.element.offsetLeft<250 || e.element.offsetTop<30){e.finishDrag()}e.element.parentNode.setSize((e.element.offsetLeft+10),(e.element.offsetTop+10));}});
	win.elements=new Array();
	win.nextElement=0;
	win.addElement=function(anElement){
		//this.objectData.elements.push(anElement.getObject());
		this.objectData.elements.push(anElement);
		return this.addElementView(anElement);
	}
	win.addElementView=function(anElement){
		return this.content.addElement(anElement);
	}
	win.setPosition=function(x,y){
		this.style.left=x+"px";
		this.style.top=y+"px";
	}
	win.update=function(){
		if(this.objectData && this.objectData.type=="folder"){
			this.nextElement=0;
			if(this.objectData){
				var elementsAux=this.objectData.elements;
				this.content.innerHTML="";
				this.elements=new Array();
				for(var i=0;i<elementsAux.length;i++){
					var element=elementsAux[i];
					//var icon=this.getIconElement(element);
					//var icon=element.getIconElement();
					//this.addElementView(icon);
					this.addElementView(element);
				}
			}
		}
	}
	win.doDrop=function(dropped){
		win.addElement(dropped);
	}
	win.block=function(){
		if(!this.blockDiv){
			this.blockDiv=document.createElement("div");
			this.blockDiv.style.position="absolute";
			this.blockDiv.style.zIndex=1000;
			this.blockDiv.align="center";
			//this.blockDiv.innerHTML='<div style="position:relative;top:30px"><object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=6,0,29,0" width="50" height="50"><param name="movie" value="flash/loading.swf"><param name="wmode" value="transparent"><param name="flashvars" value=""><param name="quality" value="high"><embed src="flash/loading.swf" quality="high" pluginspage="http://www.macromedia.com/go/getflashplayer" type="application/x-shockwave-flash" width="50" height="50" wmode="transparent" flashvars=""></embed></object></div>';
			showLoadingIcon(this.blockDiv);
			this.blockDiv.style.backgroundColor="#ffffff";
			this.blockDiv.style.width=this.content.offsetWidth+"px";
			this.blockDiv.style.height=this.content.offsetHeight+"px";
			this.blockDiv.style.top=this.content.offsetTop+"px";
			this.blockDiv.style.left=this.content.offsetLeft+"px";
			this.appendChild(this.blockDiv);
		}
	}
	win.unBlock=function(){
		if(this.blockDiv!=null){
			this.removeChild(this.blockDiv);
			this.blockDiv=null;
		}
	}
		
}

function winExist(atts){
	for(var i=0;i<windows.length;i++){
		if(atts.title==windows[i].name){
			return windows[i];
		}
	}
	return null;
}

function openWindow(atts){
	//if(winExist(atts)){var win=winExist(atts);win.elements=atts.elements;win.update();win.bringToTop();return false;}
	//var width=600;
	//var height=450;
	var width=(getStageWidth()*85)/100;
	var height=(getStageHeight()*85)/100;
	var x=(Math.floor(Math.random()*30)+10);
	var y=x;
	var url=atts.url;
	if(atts.width){width=atts.width;}
	if(atts.height){height=atts.height;}
	if(atts.center==true){x=((getStageWidth()-width)/2);y=((getStageHeight()-height)/2);}
	var namedWin=getNamedWindow(atts.title);
	if(namedWin!=null){
		x=(namedWin.offsetLeft+20);
		y=(namedWin.offsetTop+20);
	}
	if(atts.x){x=atts.x;}
	if(atts.y){y=atts.y;}
	var win=createWindow(windowsId,atts.title);
	if(atts.object && atts.object.atts && atts.object.atts.onlyCopy){win.onlyCopy=true;}
	win.objectData=atts.object;
	if(!atts.object){
		win.objectData=atts;
	}
	win.persistable=(atts.persistable==false)?false:true;
	win.name=atts.title;
	win.setAttribute("img",atts.icon);
	if(atts.fixedSize){win.sizer.style.display="none";win.minButton.style.visibility="hidden";win.maxButton.style.visibility="hidden";win.titleBar.ondblclick=null;win.fixedSize=true;}
	win.setPosition(x,y);
	if(url!=null && url!="null" && url!=""){
		var iframeWidth=width;
		var iframeHeight=height;
		if(!MSIE){
			iframeWidth-=2;
			iframeHeight-=2;
		}
		win.content.style.overflow="hidden";
		if(url.indexOf("http")<0){
			win.url=url+"&windowId="+win.id;
		}else{
			win.url=url;
		}
		var iframeTxt="<iframe name='"+win.name+"' style='width:"+iframeWidth+"px;height:"+iframeHeight+"px;overflow:hidden;' scrolling='no' src='"+win.url+"'></iframe>";
		win.content.innerHTML=iframeTxt;
		win.block();
		var ifraux=win.content.getElementsByTagName("IFRAME")[0];
		ifraux.container=win;
		addListener(ifraux,"mousedown",function(e){
			e=getEventObject(e);
			var el=getEventSource(e);
			fireEvent(el.parentNode.parentNode,"mousedown");
		});
		if (!MSIE){
			ifraux.onload=function(){
				setSubIFrameMouseDown(ifraux);
				ifraux.container.unBlock();
			}
		}else{
			var func=function(){
				var element=window.event.srcElement;
				if (element.readyState=="complete"){
					setSubIFrameMouseDown(ifraux);
					ifraux.container.unBlock();
				}
			}
			ifraux.onreadystatechange=func;
		}
	}else if(atts.elements){
		for(var i=0;i<atts.elements.length;i++){
			var element=atts.elements[i];
			//var icon=win.getIconElement(element);
			//var icon=element.getIconElement();
			//win.addElementView(icon);
			win.addElementView(element);
		}
		Droppables.add(win, {accept:'trashable',hoverclass:'opacity50',
			onDrop:function(draggable,droppable){
					while(deskTop.selectedItems.length>0){
						//droppable.doDrop(draggable);
						var dropped=deskTop.selectedItems[0];
						droppable.doDrop(dropped);
						deskTop.unSelectElement(dropped);
					}
				}
			} );
	}
	win.doDrop=function(draggable){
		if((draggable.getObject && draggable.getObject()!=this.objectData) || !draggable.getObject){
			var drop=this.objectData.addElement(draggable.getObject());
		}
		if(drop){
			this.update();
			try{draggable.remove();}catch(e){}
			return drop;
		}else{
			
		}
	}
	win.setTitle=function(title){
		win.titleBar.getElementsByTagName("DIV")[0].innerHTML=title.toUpperCase();
	}
	win.titleBar.menu=[{text:lblCloseWindow,calledFunction:"caller.parentNode.caller.parentNode.close()"}];
	if(!atts.fixedSize){
		win.titleBar.menu.push({text:lblMaximizeWindow,calledFunction:"caller.parentNode.caller.parentNode.maximize()"});
		win.titleBar.menu.push({text:lblMinimizeWindow,calledFunction:"caller.parentNode.caller.parentNode.minimize()"});
	}
	setElementMenu(win.titleBar);
	win.content.menu=[{text:lblNewFolder,calledFunction:"caller.parentNode.caller.parentNode.createFolder()"}]
	win.content.menu.push({text:"List View",calledFunction:"caller.parentNode.caller.parentNode.setListView()"})
	win.content.menu.push({text:"Icon View",calledFunction:"caller.parentNode.caller.parentNode.setIconsView()"});
	setElementMenu(win.content);
	win.setSize(width,height);
	windowsId++;
	if(atts.minimized=="true"){
		//win.minimize();
	}
	
	var minimizedwin=dock.addElement(win);
	minimizedwin.win=win;
	win.minimizedwin=minimizedwin;
	minimizedwin.onclick=function(){
		this.win.minimize();
	}
	
	return win;
}

function doDrop(aEvent){
	document.onmousemove=null;
	document.onmouseup=null;
	var clone=document.getElementById("clone");
	var win=getWindowDrop(clone);
	if(!hitTest(clone.dragWindow,{x:getMouseX(aEvent),y:getMouseY(aEvent)})|| win!=clone.dragWindow){
		clone.onmousedown=null;
		clone.onmouseup=null;
		clone.x=getMouseX(aEvent);
		clone.y=getMouseY(aEvent);
		var added=deskTop.doDrop(clone);
		try{clone.original.onrelease(addedElement);}catch(e){}
		if(added){
			if(clone.original.style.display=="none" && this.onlyCopy){
				clone.dragWindow.objectData.removeElement(clone.original.getObject());
				clone.dragWindow.update();
			}
		}else{
			if(clone.original.style.display=="none"){
				clone.original.style.display="block";
			}
		}
	}else{
		if(clone.original.style.display=="none"){
			clone.original.style.display="block";
		}
	}
	try{clone.parentNode.removeChild(clone);}
	catch(e){}
}

function getWindowDrop(el){
	var index=0;
	var win=null;
	for(var i=0;i<windows.length;i++){
		if(hitTest(el,windows[i])){
			if(parseInt(windows[i].style.zIndex)>index){
				index=parseInt(windows[i].style.zIndex);
				win=windows[i];
			}
		}
	}
	return win;
}

function reportClose(id){
	sendVars("ApiaDeskAction.do?action=closeWindow&windowId="+id,"");
}

function getWindow(windowId){
	for(var i=0;i<windows.length;i++){
		if(windows[i].id==windowId){
			return windows[i];
		}
	}
	return null;
}

function closeWindow(windowId){
	if(windowId.indexOf("_W")>=0){
		windowId=windowId.split("_W")[0];
	}
	getWindow(windowId).close();
}

function deleteLinkedElement(windowId){
	if(windowId.indexOf("_W")>=0){
		windowId=windowId.split("_W")[0];
	}
	var win=getWindow(windowId);//.close();
	if(win.ownerIcon){
		win.ownerIcon.remove();
		return;
	}
	win.close();
}

function getNamedWindow(name){
	var win=null;
	for(var i=0;i<windows.length;i++){
		if(windows[i].name==name){
			win=windows[i];
			win.bringToTop();
		}
	}
	return win;
}

function winMinimizeAll(){
	for(var i=0;i<windows.length;i++){
		if(!windows[i].minimized && !windows[i].fixedSize){
			windows[i].minimize();
		}
	}
}

function sizeAllWindows(){
	for(var i=0;i<windows.length;i++){
		var win=windows[i];
		if(win.maximized){
			win.setSize((getStageWidth()-4),(getStageHeight()-35));
		}
		if(win.minimized){
			win.actualLeft=win.offsetLeft;
			win.style.left=(getStageWidth()+100)+"px";
		}
	}
}

function closeModalWin(){
	if(modalWin){
		modalWin.parentNode.removeChild(modalWin);
		modalWin=null;
		topArea.unblock();
	}
}

function openModalWin(){
	if(modalWin){
		closeModalWin();
	}
	topArea.block();
	modalWin=document.createElement("DIV");
	drawWindow(modalWin);
	modalWin.close=function(){
		closeModalWin();
		try{this.onclose();}catch(e){}
	}
	topArea.appendChild(modalWin);
	modalWin.setSize(300,200);
	var x=((getStageWidth()-300)/2);
	var y=((getStageHeight()-200)/2);
	modalWin.setPosition(x,y);
	modalWin.sizer.style.display="none";
	modalWin.minButton.style.visibility="hidden";
	modalWin.maxButton.style.visibility="hidden";
	modalWin.fixedSize=true;
	return modalWin;
}