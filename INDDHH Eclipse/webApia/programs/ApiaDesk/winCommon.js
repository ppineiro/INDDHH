var helpTips;
function getIconElement(element){
	var icon=document.createElement("DIV");
	icon.style.width="100px";
	icon.style.height="100px";
	icon.style.position="absolute";
	icon.id=element.id;
	if(element.droppable=="true"){
		icon.className="droppable";
	}
	icon.setAttribute("url",element.url);
	icon.setAttribute("icon",element.icon);
	icon.setAttribute("name",element.name.toUpperCase());
	icon.setAttribute("text",element.name.toUpperCase());
	icon.elements=element.elements;
	icon.name=element.name;
	icon.tooltip=element.name;
	icon.url=element.url;
	icon.ondblclick=function(){openElementWindow(this);}
	//icon.innerHTML='<img style="position:absolute;left:25px;top:10px;width:50px;height:50px; " src="'+element.icon+'"><div style="position:absolute;width:100px;height:40px;left:0px;top:60px;font-family:tahoma;font-size:10px;" align="center">'+element.name.toUpperCase();+'</div>';
	icon.innerHTML='<div style="position:absolute;left:25px;top:10px;width:50px;height:50px;background-image:url('+element.icon+');"></div><div style="position:absolute;width:100px;height:40px;left:0px;top:60px;font-family:tahoma;font-size:10px;cursor:pointer;cursor:default;overflow:hidden" align="center">'+element.name.toUpperCase();+'</div>';
	return icon;
}

function addToDesktop(anElement){
	return deskTop.addElement(anElement);
}

function openElementWindow(anElement){
	var title=anElement.title;
	if(title=="" || title==null){
		title=anElement.getAttribute("text");
	}
	return openWindow({/*width:350,height:250,*//*center:true,*/title:title,url:anElement.getAttribute('url'),elements:anElement.getObject().elements,icon:anElement.getAttribute("icon"),object:anElement.getObject()});
}

function openModelWindow(element){
	return openWindow(element);
}

function getMouseX(aEvent){
	if(MSIE){
		aEvent=window.event;
		return(aEvent.clientX + document.body.scrollLeft);
	}else{
		return(aEvent.pageX);
	}	
}

function getMouseY(aEvent){
	if(MSIE){
		aEvent=window.event;
		return(aEvent.clientY + document.body.scrollTop);
	}else{
		return(aEvent.pageY);
	}	
}

function getMouseXInElement(aEvent,el){
	var x=getMouseX(aEvent);
	return (x-el.offsetLeft);
}

function getMouseYInElement(aEvent,el){
	var y=getMouseY(aEvent);
	return (y-el.offsetTop);
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

function setElementMenu(element){
	element.onmousedown=function(aEvent){
		aEvent=getEventObject(aEvent);
		if(aEvent.button==2){
			cancelBubble(aEvent);
			document.oncontextmenu=function(){
				return false;
			}
			closeContextMenues();
			var x=getMouseX(aEvent);
			var y=getMouseY(aEvent);
			openElementMenu(this,{x:x,y:y,caller:this})
		}
	}
}

function setDesktopElementMenu(el){
	el.showMenu=function(aEvent){
		aEvent=getEventObject(aEvent);
		var el=this;
		if(aEvent.button==2){
			if(!el.selected){
				deskTop.unSelectAll();
				el.selectMe();
			}
			cancelBubble(aEvent);
			document.oncontextmenu=function(){
				return false;
			}
			closeContextMenues();
			var x=getMouseX(aEvent);
			var y=getMouseY(aEvent);
			el.menu=[{text:lblDeleteElement,calledFunction:"deskTop.removeSelected()"}];
			if(el.getObject().type=="folder"){
				el.menu.push({ text:lblChangeName, calledFunction:"caller.parentNode.caller.changeName()" });
			}
			openElementMenu(el,{x:x,y:y,caller:el})
		}
	}
	addListener(el,"mousedown",function(evt){
	evt=getEventObject(evt);
	var el=getEventSource(evt);
	while(!el.showMenu){
		el=el.parentNode;
	}
	el.showMenu(evt)});
}

function setWindowElementMenu(el){
	el.showMenu=function(aEvent){
		aEvent=getEventObject(aEvent);
		var el=this
		if(aEvent.button==2){
			cancelBubble(aEvent);
			document.oncontextmenu=function(){
				return false;
			}
			closeContextMenues();
			var x=getMouseX(aEvent);
			var y=getMouseY(aEvent);
			openElementMenu(el,{x:x,y:y,caller:el})
		}
	}
	addListener(el,"mousedown",function(evt){
	evt=getEventObject(evt);
	var el=getEventSource(evt);
	while(!el.showMenu){
		el=el.parentNode;
	}
	el.showMenu(evt)});
	
}

function setPostitMenu(element){
	element.onmousedown=function(aEvent){
		aEvent=getEventObject(aEvent);
		if(aEvent.button==2){
			cancelBubble(aEvent);
			document.oncontextmenu=function(){
				return false;
			}
			closeContextMenues();
			var x=getMouseX(aEvent);
			var y=getMouseY(aEvent);
			this.menu=[{text:lblDeleteElement,calledFunction:"caller.parentNode.caller.remove()"}];
			openElementMenu(this,{x:x,y:y,caller:this})
		}
	}
}

function setDesktopMenu(element){
	element.onmousedown=function(aEvent){
		aEvent=getEventObject(aEvent);
		element.unSelectAll();
		if(aEvent.button==2){
			cancelBubble(aEvent);
			document.oncontextmenu=function(){
				return false;
			}
			closeContextMenues();
			var x=getMouseX(aEvent);
			var y=getMouseY(aEvent);
			this.menu=[{text:lblNewFolder,calledFunction:"deskTop.createFolder(caller)"},{text:lblSortCascade,calledFunction:"winSortCascade()"},{text:lblMinimizeAll,calledFunction:"winMinimizeAll()"},{text:lblSort,menu: [ {text:lblSortByName,calledFunction:"deskTop.arrange('name')"},{text:lblSortByType,calledFunction:"deskTop.arrange('icon')"} ] }, {text:lblSaveDesk,calledFunction:"getModel()"}];
			openElementMenu(this,{x:x,y:y,caller:this})
		}
	}
}

function openElementMenu(element,opts){
	try{menuItems.close();}catch(e){}
	try{hideToolTip();}catch(e){}
	if(element.menu.length==0){return null}
	var menu=element.menu;
	var menuDiv=document.createElement("DIV");
	menuDiv.className="contextMenu";
	menuDiv.style.position="absolute";
	menuDiv.style.zIndex="200";
	menuDiv.caller=opts.caller;
	menuDiv.parentMenu=opts.parentMenu;
	var menuContent="";
	for(var i=0;i<menu.length;i++){
		var menuItem=document.createElement("DIV");
		menuItem.innerHTML=menu[i].text;
		menuItem.className="menuItem";
		menuItem.setAttribute("disabledItem","false");
		if(menu[i].disabled && menu[i].disabled==true){ 
			menuItem.style.color="#999999";
			menuItem.setAttribute("disabledItem","true");
		}
		if(menu[i].menu&& menu[i].menu.length>0){
			menuItem.menu=menu[i].menu;
			menuItem.style.backgroundImage="url(styles/"+currStyle+"/images/moreItems.gif)";
			menuItem.style.backgroundRepeat="no-repeat";
			menuItem.style.backgroundPosition="right";
			menuItem.onmouseover=function(evt){
				this.className="contextMenuHover";
				if(this.parentNode.innerMenu!=null){
					this.parentNode.innerMenu.close();
					this.parentNode.innerMenu=null;
				}
				this.style.backgroundImage="url(styles/"+currStyle+"/images/moreItems.gif)";
				this.style.backgroundRepeat="no-repeat";
				this.style.backgroundPosition="right";
				evt=getEventObject(evt);
				var element=getEventSource(evt);
				if(this.getAttribute("disabledItem")=="true"){
					this.style.color="#999999";
				}else{
					var x=(this.parentNode.offsetLeft+this.parentNode.offsetWidth);
					var y=getAbsolutePosition(this).y;
					var o={x:x,y:y,caller:opts.caller,parentMenu:this.parentNode};
					menuDiv.innerMenu=openElementMenu(element,o);
				}
			}
			menuItem.onmouseout=function(evt){
				this.className="menuItem";
				this.style.backgroundImage="url(styles/"+currStyle+"/images/moreItems.gif)";
				this.style.backgroundRepeat="no-repeat";
				this.style.backgroundPosition="right";
				if(this.getAttribute("disabledItem")=="true"){
					this.style.color="#999999";
				}
			}
		}else{
			menuItem.calledFunction=menu[i].calledFunction;
			menuItem.onmouseover=function(evt){
				this.className="contextMenuHover";
				if(this.parentNode.innerMenu!=null){
					this.parentNode.innerMenu.close();
					this.parentNode.innerMenu=null;
				}
				if(this.getAttribute("disabledItem")=="true"){
					this.style.color="#999999";
				}
			}
			menuItem.onmouseout=function(evt){
				this.className="menuItem";
				if(this.getAttribute("disabledItem")=="true"){
					this.style.color="#999999";
				}
			}
			if(menuItem.getAttribute("disabledItem")!="true"){
				menuItem.calledFunction=new Function("caller",menuItem.calledFunction);
				menuItem.onclick=function(evt){
					this.calledFunction(this);
					closeContextMenues();
					cancelBubble(evt);
				}
			}
		}
		menuDiv.close=function(){
			this.parentNode.removeChild(this);
		}
		menuDiv.appendChild(menuItem);
	}
	addListener(document,"click",closeContextMenues);
	//Effect.Appear(menuDiv, { duration:1.0,from:0,to:1 });
	menuDiv.style.left=opts.x+"px";
	menuDiv.style.top=opts.y+"px";
	document.body.appendChild(menuDiv);
	if(opts.openup){
		menuDiv.style.top=(opts.y-menuDiv.offsetHeight)+"px";
	}
	if( (menuDiv.offsetLeft+menuDiv.offsetWidth)>getStageWidth() ){
		var left=menuDiv.offsetLeft-menuDiv.offsetWidth;
		if(menuDiv.parentMenu){
			left=menuDiv.parentMenu.offsetLeft-menuDiv.offsetWidth;
		}
		menuDiv.style.left=(left+2)+"px";
	}
	if( (menuDiv.offsetTop+menuDiv.offsetHeight)>getStageHeight() ){
		menuDiv.style.top=((menuDiv.offsetTop-menuDiv.offsetHeight)+25)+"px";//(menuDiv.offsetTop-(getStageHeight()-( menuDiv.offsetTop+menuDiv.offsetHeight )))+"px";
	}
	return menuDiv;
}

function closeContextMenues(){
	var divs=document.getElementsByTagName("DIV");
	var menues=new Array();
	for(var i=0;i<divs.length;i++){
		if(divs[i].className=="contextMenu"){
			menues.push(divs[i]);
		}
	}
	while(menues.length>0){
		menues[0].parentNode.removeChild(menues[0]);
		menues.splice(0,1);
	}
}

var tooltip;
function moveToolTip(evt){
	var mX=getMouseX(evt);
	var mY=getMouseY(evt);
	var x=mX;
	var y=mY;
	if(document.getElementById("tooltip")){
		if(hitTest(tooltip.element,{x:x,y:y} )){
			//setTimeout('tooltip.style.display="block"',1500);
			tooltip.style.display="block";
			if((x+10+tooltip.offsetWidth)>getStageWidth()){
				x=getStageWidth()-tooltip.offsetWidth-20;
			}
			if( ( ((x+10)-mX)*( ( (x+10)+tooltip.offsetWidth)-mX) )<0 ){
				x=((mX-30)-(tooltip.offsetWidth));
			}
			tooltip.style.left=(x+10)+"px";
			var top=parseInt(y);
			top-=(parseInt(tooltip.offsetHeight)+30)/2;//(parseInt(tooltip.offsetHeight)+30);
			if((top+10+tooltip.offsetHeight)>getStageHeight()){
				top=getStageHeight()-tooltip.offsetHeight-20;
			}
			if(MSIE && top<0){
				top=0;
			}else if(top<-20){top=-20;}
			tooltip.style.top=(top+"px");
		}else{
			hideToolTip();
		}
	}else{
		 hideToolTip();
	}
}

function showToolTip(element){
	if(tooltip){
		tooltip.id="tooltip";
	}else{
		tooltip=document.createElement("DIV");
		tooltip.style.position="absolute";
		tooltip.style.minWidth="40px";
		tooltip.style.backgroundColor="white";
		tooltip.style.border="1px solid black";
		tooltip.align="center";
		tooltip.style.padding="3px";
		tooltip.style.top="-120px";
		tooltip.style.fontFamily="Arial";
		tooltip.style.fontSize="10px";
		tooltip.id="tooltip";
		topArea.appendChild(tooltip);
		addListener(document,"mousemove",moveToolTip);
	}
	closeContextMenues()
	var text=element.tooltip;
	tooltip.element=element;
	tooltip.innerHTML=text;
}
function hideToolTip(){
	if(tooltip!=null){
		tooltip.style.display="none";
		tooltip.id="";
	}
	//removeListener(document,"mousemove",document.dockMove);
}
function addToolTip(el){
	addListener(el,"mouseover",function(evt){showToolTip(evt.element);});
	addListener(el,"mouseout",function(){hideToolTip();});
}

function showLoadingIcon(div){
	if(!div.loadingIcon){
		var loadingIcon=document.createElement("DIV");
		loadingIcon.innerHTML='<object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=6,0,29,0" width="50" height="50"><param name="movie" value="flash/loading.swf"><param name="wmode" value="transparent"><param name="flashvars" value=""><param name="quality" value="high"><embed src="flash/loading.swf" quality="high" pluginspage="http://www.macromedia.com/go/getflashplayer" type="application/x-shockwave-flash" width="50" height="50" wmode="transparent" flashvars=""></embed></object>';
		loadingIcon.style.position="relative"
		loadingIcon.style.height="50px";
		loadingIcon.style.width="50px";
		div.appendChild(loadingIcon);
		div.loadingIcon=loadingIcon;
		div.align="center";
		loadingIcon.style.top="100px";
	}
}

function clearLoadingIcon(div){
	if(div.loadingIcon){
		div.removeChild(div.loadingIcon);
		div.loadingIcon=null;
	}
}

function showHelpTip(atts){
	if(!helpTips){helpTips=new Array();}
	var helpTip=document.createElement("DIV");
	helpTip.style.position="absolute";
	helpTip.innerHTML='<div style="position:relative;"><table cellpadding="0" cellspacing="0" height="12px"><tbody><tr><td style="width:12px"><img src="images/helpTipTL.png"/></td><td style="border-top:1px solid black; background-color:#FFFFCC;"><img src="images/transparentpixel.gif"></td><td style="width:12px"><img src="images/helpTipTR.png"/></td></tr></tbody></table></div><div style="border-left:1px solid black;border-right:1px solid black;background-color:#FFFFCC; padding-left:8px; padding-right:8px; font-family:tahoma;font-size:12px;min-width:200px;">'+atts.text+'</div><div style="position:relative;"><table cellpadding="0" cellspacing="0" height="12px"><tbody><tr><td style="width:12px"><img src="images/helpTipBL.png"/></td><td style="border-bottom:1px solid black; background-color:#FFFFCC;"><img src="images/transparentpixel.gif"></td><td style="width:12px"><img src="images/helpTipBR.png"/></td></tr></tbody></table></div><div style="position:absolute;width:16px;height:16px;background-image:url(images/helpTipArrow.png)"></div>';
	topArea.appendChild(helpTip);
	var divs=helpTip.getElementsByTagName("DIV");
	helpTip.arrow=divs[divs.length-1];
	divs[0].getElementsByTagName("TD")[1].getElementsByTagName("IMG")[0].style.width=(divs[1].offsetWidth-24)+"px";
	divs[2].getElementsByTagName("TD")[1].getElementsByTagName("IMG")[0].style.width=(divs[1].offsetWidth-24)+"px";
	divs[0].getElementsByTagName("TD")[1].getElementsByTagName("IMG")[0].style.height="0px";
	divs[2].getElementsByTagName("TD")[1].getElementsByTagName("IMG")[0].style.height="0px";
	helpTip.arrow.style.top=(helpTip.offsetTop+helpTip.offsetHeight-6)+"px";
	helpTip.arrow.style.left=(helpTip.offsetLeft+20)+"px";
	helpTip.style.top=(atts.y-(helpTip.offsetTop+helpTip.offsetHeight+15))+"px";
	helpTip.style.left=(atts.x-(helpTip.offsetLeft+10))+"px";
	helpTip.style.zIndex=0;
	helpTips.push(helpTip);
	addListener(helpTip,"click",function(evt){evt.element.close();})
	helpTip.close=function(){
		new Effect.Opacity(this, {duration:1.5,from:1, to:0,afterFinish:function(evt){closeHelpTip(evt.element);}});
	}
	helpTip.onmouseover=function(){
		this.onmouseout=function(evt){
			cancelBubble(evt);
			this.close();
		}
	}
	return helpTip;
}

function clearCreatedFolder(){
	if(document.tempFolder && document.textAux && (document.textAux.value=="" || containsNamedElement(document.tempFolder,document.textAux.value))  ){
		document.tempFolder.remove();
		document.onkeydown=null;
		document.onkeypress=null;
		document.tempFolder=null;
		document.onmousedown=null;
		if(document.textAux.parentNode){
			document.body.removeChild(document.textAux);
		}
		document.textAux=null;
	}
}
function startNameWriter(folderIcon){
	deskTop.unSelectAll();
	clearCreatedFolder();
	var text=folderIcon.getElementsByTagName("DIV")[1];
	text.style.backgroundImage="url(styles/"+currStyle+"/images/transparentBack.png)";
	text.style.color="#222277";
	document.textFocused=text;
	document.tempFolder=folderIcon;
	var textAux=document.createElement("input");
	document.textAux=textAux;
	textAux.style.position="absolute";
	textAux.style.top="-200px";
	textAux.value=folderIcon.getObject().name;
	textAux.setAttribute("originalName",textAux.value);
	document.textAux.onkeyup=function(){
		document.textFocused.innerHTML=this.value.toUpperCase();
	}
	document.textAux.onkeydown=function(evt){
		evt=getEventObject(evt);
		if(evt.keyCode==13) {
			document.textFocused.style.backgroundImage="";
			document.textFocused.style.color="#000000";
			document.onkeydown=null;
			document.onkeypress=null;
			document.onclick=null;
			if(document.textAux.value=="" || containsNamedElement(document.tempFolder,document.textAux.value)){
				clearCreatedFolder();
			}else{
				document.tempFolder.getObject().name=document.textAux.value;
			}
		}
		document.textFocused.innerHTML=this.value.toUpperCase();
		document.textFocused.parentNode.setAttribute("name",this.value.toUpperCase());
		document.textFocused.parentNode.setAttribute("text",this.value.toUpperCase());
		document.textFocused.parentNode.tooltip=getToolTipText(document.textFocused.parentNode);
	}
	
	document.textAux.onblur=function(evt){
		if(document.textFocused){
			evt=getEventObject(evt);
			document.textFocused.style.backgroundImage="";
			document.textFocused.style.color="#000000";
			document.onclick=null;
			document.body.removeChild(document.textAux);
			if((document.textAux && document.textAux.value=="") || containsNamedElement(document.tempFolder,document.textAux.value)){
				clearCreatedFolder();
			}else if(document.tempFolder ){
				document.textFocused.style.backgroundImage="";
				document.textFocused.style.color="#000000";
				document.tempFolder.getObject().name=document.textAux.value;
				document.textFocused.innerHTML=this.value.toUpperCase();
				document.textFocused.parentNode.setAttribute("name",this.value.toUpperCase());
				document.textFocused.parentNode.setAttribute("text",this.value.toUpperCase());
				document.textFocused.parentNode.tooltip=getToolTipText(document.textFocused.parentNode);
				document.textAux=null;
			}
		}
	}
	
	
	document.body.appendChild(textAux);
	document.textAux.focus();
	setSelection(document.textAux, document.textAux.value.length, document.textAux.value.length);
}

function closeHelpTip(helpTip){
	for(var i=0;i<helpTips.length;i++){
		if(helpTips[i]==helpTip){
			helpTips.splice(i);
			helpTip.parentNode.removeChild(helpTip);
		}
	}	
}

function updateVariable(name,value,vars){
	if(vars.indexOf(name)>=0){
		var i=vars.indexOf(name);
		while(vars.charAt(i)!="&" && i<vars.length){
			i++;
		}
		vars=vars.substring(0,vars.indexOf(name))+vars.substring(i,vars.length);
		if(value!=""){
			vars+="&"+name+"="+value;
		}
	}else{
		vars+="&"+name+"="+value;
	}
	return vars;
}

function getFlashObject(movieName){
	if (window.document[movieName]){
		return window.document[movieName];
	}
	if (navigator.appName.indexOf("Microsoft Internet")==-1){
		if (document.embeds && document.embeds[movieName]){
			return document.embeds[movieName];
		}
	}else{ // if (navigator.appName.indexOf("Microsoft Internet")!=-1){
		//return document.getElementById(movieName);
		var objs=document.getElementsByTagName("PARAM");
		for(var i=0;i<objs.length;i++){
			if(objs[i].getAttribute("value")==movieName){
				return objs[i].parentNode;
			}
		}
	}
}

function insideStage(el){
	if( (el.offsetLeft+el.offsetWidth)>getStageWidth() ){
		el.style.left=(getStageWidth() - el.offsetWidth)+"px";
	}
	if( (el.offsetTop+el.offsetHeight) > menuBar.offsetTop){
		el.style.top=(menuBar.offsetTop - el.offsetHeight)+"px";
	}
	if(el.offsetTop<0){
		el.style.top="0px";
	}
	if(el.offsetLeft<0){
		el.style.left="0px";
	}
}

function makeSelectable(element) {
	element.onselectstart = function(evt) {
		cancelBubble(evt);
		return true;
	}
	element.unselectable = "false";
	element.style.MozUserSelect = "true";
}


function makeUnselectable(element) {
	element.onselectstart = function() {
		return false;
	}
	element.unselectable = "on";
	element.style.MozUserSelect = "none";
	element.style.cursor = "default";
}

function containsNamedElement(el,name){
	var elements;
	if(el.parentNode.elements){
		elements=el.parentNode.elements;
	}else{
		elements=el.parentNode.parentNode.elements;
	}
	for(var i=0;i<elements.length;i++){
		if(elements[i]!=el && elements[i].object.name==name){
			return true;
		}
	}
	return false;
}