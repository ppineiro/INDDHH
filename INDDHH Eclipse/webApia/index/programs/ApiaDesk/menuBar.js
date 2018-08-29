// JavaScript Document
var menuBar;
var menuItems;
var shortCutsURL=URL_ROOT_PATH+"/programs/ApiaDesk/jsps/shortcuts.jsp?langId="+LANG_ID;

function setMenu(){
	setMenuBar();
	//loadMenu("menu.xml");
	loadMenu("FramesAction.do?action=menu&xmlMenu=true");
}

function setMenuBar(){
	menuBar=document.createElement("DIV");
	menuBar.style.height="30px";
	menuBar.id="menuBar";
	menuBar.blocked=false;
	menuArea.appendChild(menuBar);
	//document.body.appendChild(menuBar);
	menuBar.style.position="absolute";
	menuBar.style.width=(getStageWidth()-2)+"px";;
	menuBar.style.top=(getStageHeight()-30)+"px";
	menuBar.style.left="0px";
	var startButton=document.createElement("DIV");
	startButton.innerHTML="<span><img src='styles/"+currStyle+"/images/startIcon.gif'></span>";
	startButton.innerImage=startButton.getElementsByTagName("IMG")[0];
	startButton.style.backgroundImage="url(styles/"+currStyle+"/images/startIconBack.gif)";
	startButton.style.backgroundRepeat="no-repeat";
	startButton.id="startButton";
	menuArea.appendChild(startButton);
	startButton.style.position="absolute";
	startButton.style.width="45px";
	startButton.style.height="40px";
	startButton.style.top=(getStageHeight()-40)+"px";
	startButton.style.left="20px";
	startButton.style.zIndex=300;
	menuBar.startButton=startButton;
	var licence=licenceInfo.split("&nbsp;").join(" ");
	licence=licence.split("&copy;").join(" ");
	startButton.title=licence;
	startButton.onclick=function(evt){
		cancelBubble(evt);
		//try{}catch(e){}
		if(this.menuOpen){
			menuItems.close();
			this.menuOpen=false;
		}else{
			menuItems.openMenu();
			this.menuOpen=true;
		}
	}
	startButton.onmouseover=function(){
		new Effect.Opacity(this.innerImage, {duration:.5, from:1.0, to:0.1})
	}
	startButton.onmouseout=function(){
		new Effect.Opacity(this.innerImage, {duration:1.0, from:0.1, to:1.0})
	}
	menuBar.startButton=startButton;
	menuBar.block=function(){
		menuBar.blocked=true;
	}
	menuBar.unBlock=function(){
		menuBar.blocked=false;
	}
	menuBar.size=function(){
		menuBar.style.width=(getStageWidth()-2)+"px";;
		menuBar.style.top=(getStageHeight()-30)+"px";
		menuBar.style.top=(getStageHeight()-30)+"px";
		menuBar.style.left="0px";
		menuBar.startButton.style.top=(getStageHeight()-40)+"px";
		menuBar.startButton.style.left="20px";
	}
	setDock();
	//new Draggable(startButton);
}

function loadMenu(url){
	var xml=new xmlLoader();
	xml.onload=function(root){
		var menu=parseMenuXML(getFirstChild(root));
		startShortCuts(shortCutsURL)
	}
	xml.load(url);
}

function startShortCuts(url){
	var xml=new xmlLoader();
	xml.onload=function(root){
		setMenuItems();
		var menu=setShortCuts(getFirstChild(root));
		doShortcutsOnLoad();
	}
	xml.load(url);
}

function setMenuItems(){
	if(menuItems!=null){
		menuItems.style.position="absolute";
		menuItems.id="startMenu";
		menuItems.openMenu=function(){
			try{closeContextMenues()}catch(e){};
			this.style.display="block";
			this.innerHTML="<div class='menuBack' style='position:absolute;top:0px;left:0px;width:100%;height:100%;'></div><div style='position:relative;top:0px;left:0px;width:100%;height:100%;'></div><div style='position:relative;height:30px;border-top:1px solid black;white-space:nowrap;' align='right'><table cellpadding='0' cellspacing='0'><tr><td><div style='width:100px;position:relative;font-family:tahoma;font-size:8px;'>"+ENVIRONMENT+"</div></td><td width='0px'><div title='"+logoutLabel+"' class='opacity70' style='z-index:500;position:relative;vertical-align:middle;background-image:url(styles/"+currStyle+"/images/logout_icon.gif);width:57px;height:12px'></div></td></tr></table></div>"
			this.back=this.getElementsByTagName("DIV")[0];
			this.content=this.getElementsByTagName("DIV")[1];
			this.sysMenu=this.getElementsByTagName("DIV")[2];
			for(var i=0;i<this.elements.length;i++){
				var element=document.createElement("DIV");
				element.style.whiteSpace="nowrap";
				element.innerHTML=this.elements[i].text;
				element.setAttribute("name",this.elements[i].name);
				element.setAttribute("title",this.elements[i].title);
				element.setAttribute("text",this.elements[i].text);
				element.setAttribute("url",this.elements[i].url);
				element.setAttribute("icon",this.elements[i].icon);
				element.elements=this.elements[i].elements;
				setSubMenu(element);
				this.content.appendChild(element);
			}
			menuArea.appendChild(this);
			this.back.style.width=(this.offsetWidth-11)+"px";
			this.back.style.height=(this.offsetHeight-10)+"px";
			this.style.left="5px";
			this.style.top=((getStageHeight()-35)-this.offsetHeight)+"px";
			this.sysMenu.getElementsByTagName("DIV")[1].onmousedown=function(evt){cancelBubble(evt);logout();}
			this.sysMenu.getElementsByTagName("DIV")[1].onmouseup=function(){this.className="";}
			this.sysMenu.getElementsByTagName("DIV")[1].onmouseup=function(){this.className="opacity70";}
			this.style.zIndex=705;
			addListener(document,"click",function(){
				$("startMenu").close();
				clearCreatedFolder();
			});
			menuItems.showHeader();
		}
		menuItems.close=function(){
			menuBar.startButton.menuOpen=false;
			if(this.content.subMenu){
				this.content.subMenu.close();
			}
			this.style.display="none";
			this.innerHTML="";
			try{this.hideHeader();}catch(e){}
		}
		
		menuItems.showHeader=function(){
			var header=document.createElement("DIV");
			header.id="menuHeader";
			header.innerHTML="<table cellpadding='0' cellspacing='0'> <tr><td style='width:0px'><img src='styles/"+currStyle+"/images/menuTopLeft.png' /></td><td style='width:100%;background-image:url(styles/"+currStyle+"/images/menuTopCenter.png);background-repeat:repeat-x;font-family:tahoma;font-size:10px;'>"+LOGGED_USER_NAME+"</td><td style='width:0px'><img src='styles/"+currStyle+"/images/menuTopRight.png' /></td></tr> </table>";
			this.parentNode.appendChild(header);
			this.header=header;
			header.style.width=this.offsetWidth+"px";
			header.style.position="absolute";
			header.style.left=this.offsetLeft+"px";
			header.style.top=(this.offsetTop-37)+"px";
		}
		
		menuItems.hideHeader=function(){
			var header=document.getElementById("menuHeader");
			if(header){
				header.parentNode.removeChild(header);
			}
		}
		menuItems.hitTest=function(coords){
			var content=this.content;
			var subMenu=content;
			while(subMenu){
				if(hitTest(subMenu,coords)){
					return true;
				}
				subMenu=subMenu.subMenu;
			}
			return false;
		}
	}
	menuBar.ready=true;
	allReady();
}

function parseMenuXML(xml){
	menuItems=document.createElement("DIV");
	menuItems.elements=new Array();
	if(!xml){return;}
	for(var i=0;i<xml.childNodes.length;i++){
		if(xml.childNodes[i].nodeName=="element"){
			var element=parseMenuElement(xml.childNodes[i]);
			menuItems.elements.push(element);
		}
	}
}

function parseMenuElement(node){
	var elements=new Array;
	var element;
	var icon=node.getAttribute("ICON");
	if(!icon || icon==""){
		icon=getImg(node.getAttribute("URL"));
	}else{
		icon=URL_ROOT_PATH+"/images/"+( (icon.indexOf("-")==0)?"uploaded/"+icon:icon );
	}
	var url=node.getAttribute("URL");
	var fncId=node.getAttribute("FUNCTION_ID");
	
	element={node:node.getAttribute("class"),url:url,title:node.getAttribute("TITLE"),name:node.getAttribute("NAME"),text:node.getAttribute("NAME"),icon:icon,fncId:fncId};
	if(node.getElementsByTagName("elements")[0]){
		var nodeElements=node.getElementsByTagName("elements")[0];
		for(var i=0;i<nodeElements.childNodes.length;i++){
			if(nodeElements.childNodes[i].tagName=="element"){
				elements.push(parseMenuElement(nodeElements.childNodes[i]));
			}
		}
		element.elements=elements;
	}
	return element;
}

function getImg(url){
	if(url){
		if(url.indexOf("startProcess")>=0 || url.indexOf("ProStartAction")>=0){
			//return("styles/"+currStyle+"/images/procicon.png");
			return(URL_ROOT_PATH+"/images/uploaded/procicon.png")
		}
	}
	return "styles/"+currStyle+"/images/func_icon.png";
}

function setSubMenu(menuElement){
	if(menuElement.elements){
		menuElement.style.backgroundImage="url(styles/"+currStyle+"/images/moreItems.gif)";
		menuElement.style.backgroundRepeat="no-repeat";
		menuElement.style.backgroundPosition="right";
		menuElement.onmouseover=function(event){
			if(menuBar.blocked){
				return false;
			}
			this.className="elementHover folder";
			if(this.parentNode.subMenu){
				this.parentNode.subMenu.close();
			}
			var subMenu=document.createElement("DIV");
			subMenu.className="subMenu";
			subMenu.style.zIndex=800;
			subMenu.style.position="absolute";
			subMenu.style.left=(this.parentNode.offsetWidth+this.parentNode.offsetLeft)+"px";
			for(var i=0;i<this.elements.length;i++){
				var menuElement=document.createElement("DIV");
				menuElement.style.whiteSpace="nowrap";
				menuElement.innerHTML=this.elements[i].text;
				menuElement.setAttribute("text",this.elements[i].text);
				menuElement.setAttribute("name",this.elements[i].name);
				menuElement.setAttribute("url",this.elements[i].url);
				menuElement.setAttribute("icon",this.elements[i].icon);
				menuElement.setAttribute("fncId",this.elements[i].fncId);
				menuElement.elements=this.elements[i].elements;
				if(!menuElement.elements){
					menuElement.className="droppable";
				}
				setSubMenu(menuElement);
				subMenu.appendChild(menuElement);
			}
			menuArea.appendChild(subMenu);
			if(subMenu.offsetHeight>getStageHeight()){
				subMenu.totalHeight
				subMenu.style.height=(getStageHeight()-20)+"px";
				subMenu.onmouseover=function(evt){
					if(menuBar.blocked){
						return false;
					}
					var divs=this.getElementsByTagName("DIV");
					var y=getMouseYInElement(evt,this);
					var elementHeight=divs[0].offsetHeight;
					var maxMove=(elementHeight*divs.length)-(this.clientHeight-20);
					if(y<=this.offsetHeight && y>=0){
						var top=y*maxMove/this.clientHeight;
						this.scrollTop=(-top)+"px";
						for(var i=0;i<divs.length;i++){
							divs[i].style.position="relative";
							divs[i].style.top=(-top)+"px";
						}
					}
				}
				subMenu.style.top=((getStageHeight()-subMenu.offsetHeight)/2)+"px";
			}else{
				var parentMenu=this;
				while(parentMenu.className!="subMenu" && parentMenu.id!="startMenu"){
					parentMenu=parentMenu.parentNode;
				}
				subMenu.style.top=((parentMenu.offsetTop+this.offsetTop))+"px";
				if(subMenu.offsetTop+subMenu.offsetHeight>getStageHeight()){
					subMenu.style.top=(subMenu.offsetTop-((subMenu.offsetHeight+subMenu.offsetTop+20)-getStageHeight()))+"px";
				}
			}
			//element.parentNode.appendChild(subMenu);
			var items=subMenu.getElementsByTagName("DIV");
			for(var i=0;i<items.length;i++){
				//new Draggable(element.id, {revert:false,endeffect:function(e){e.bringToTop();}});
				items[i].doDrop=function(){
					$("startMenu").close();
				}
				if(!items[i].elements){
					new Draggable(items[i],{ghosting:true,revert:true,change:function(e){ if(e.element.onclick!=null){e.element.onclickAux=e.element.onclick;e.element.onclick=null;}}, starteffect:function(e){menuBar.block()},endeffect:function(e){menuBar.unBlock()}});
				}else{
					items[i].onclick=function(){
						return 0;
					}
				}
			}
			subMenu.close=function(){
				if(this.subMenu){
					this.subMenu.close();
				}
				if(this.parentNode){
				this.parentNode.removeChild(this);
				}
			}
			this.parentNode.subMenu=subMenu;
		}
		menuElement.onmouseout=function(event){
			this.className="droppable";
			this.style.backgroundImage="url(styles/"+currStyle+"/images/moreItems.gif)";
			this.style.backgroundRepeat="no-repeat";
			this.style.backgroundPosition="right";
		}
	}else{
		menuElement.onmouseover=function(event){
			if(menuBar.blocked){
				return false;
			}
			if(this.parentNode.subMenu){
				this.parentNode.subMenu.close();
			}
			this.className="elementHover droppable";
		}
		menuElement.onmouseout=function(event){
			this.className="droppable";
		}
		menuElement.onclick=function(){
		//menuElement.doclick=function(){
			var url=this.getAttribute("url");
			if(this.clicked){
				return;
			}else{
				this.clicked=true;
			}
			if(url.indexOf("?")!=url.lastIndexOf("?")){
				var urlTo=url.substring(url.lastIndexOf("?"));
				var url=url.substring(0,url.lastIndexOf("?"))+escape(urlTo);
			}
			var atts={text:this.getAttribute("text"),name:this.getAttribute("name"),url:url,icon:this.getAttribute("icon")};
			var winElement=new element(atts);
			openElementWindow(winElement.getIconElement());
			menuItems.close();
		}
		if(MSIE){
			addListener(menuElement,"mousedown",function(evt){
				evt=getEventObject(evt);
				el=getEventSource(evt);
				cancelBubble(evt);
				el.setAttribute("x",getMouseX(evt));
				el.setAttribute("y",getMouseY(evt));
			});
			addListener(menuElement,"mouseup",function(evt){
				evt=getEventObject(evt);
				el=getEventSource(evt);
				if(el.clicked){
					return;
				}else{
					el.clicked=true;
				}
				var x2=getMouseX(evt);
				var y2=getMouseY(evt);
				var x1=el.getAttribute("x");
				var y1=el.getAttribute("y");
				if( (Math.abs(x2-x1)<10 && Math.abs(y2-y1)<10)){
					var url=el.getAttribute("url");
					if(url.indexOf("?")!=url.lastIndexOf("?")){
						var urlTo=url.substring(url.lastIndexOf("?"));
						var url=url.substring(0,url.lastIndexOf("?"))+escape(urlTo);
					}
					var atts={text:el.getAttribute("text"),name:el.getAttribute("name"),url:url,icon:el.getAttribute("icon")};
					var winElement=new element(atts);
					openElementWindow(winElement.getIconElement());
					//menuItems.close();
				}
			});
		}
	}
}

function setShortCuts(xml){
	var shortCuts=document.createElement("DIV");
	shortCuts.style.position="absolute";
	menuBar.shortCuts=shortCuts;
	var content="<table><tr>";
	var elementMenuArray=new Array();
	var shortCutsArray=new Array();
	for(var i=0;i<xml.childNodes.length;i++){
		if(xml.childNodes[i].nodeName=="shortcut"){
			var shortcut=xml.childNodes[i];
			var js=shortcut.getAttribute("js");
			if(js){
				var script=document.createElement("SCRIPT");
				script.src=js;
				document.getElementsByTagName("HEAD")[0].appendChild(script);
			}
			var dockElement=dock.addElement(shortcut);
			shortCutsArray.push(dockElement);
			dockElement.setAttribute("loadFunction",shortcut.getAttribute("onload"));
			//content+="<td><img class='shortCut' ondblclick='"+shortcut.getAttribute("dblclick")+"' loadFunction='"+shortcut.getAttribute("onload")+"' style='filter:alpha(opacity=30);width:20px;height:20px;' src='"+shortcut.getAttribute("img")+"' title='"+shortcut.getAttribute("text")+"' onclick='' onmouseover='new Effect.Opacity(this,{duration:0.5, from:0.5, to:1});' onmouseout='new Effect.Opacity(this,{duration:0.5, from:1, to:.5});'></td>";
			var menuArray=new Array();
			if(shortcut.getElementsByTagName("menu")[0]){
				var menu=shortcut.getElementsByTagName("menu")[0];
				menuArray=parseMenuNode(menu);
			}
			elementMenuArray.push(menuArray);
		}
	}
	content+="</tr></table>";
	shortCuts.innerHTML=content;
	menuArea.appendChild(shortCuts);
//	var imgs=shortCuts.getElementsByTagName("IMG");
	var imgs=shortCutsArray;
	for(var i=0;i<imgs.length;i++){
		imgs[i].menu=elementMenuArray[i];
		imgs[i].onclick=function(evt){
			cancelBubble(evt);
			closeContextMenues();
			var x=getMouseX(evt);
			var y=getMouseY(evt);
			var opts={x:x,y:y,openup:true,caller:this};
			openElementMenu(this,opts)
		}
		/*if(imgs[i].getAttribute("loadFunction")!="" && imgs[i].getAttribute("loadFunction")!=undefined){
			//setTimeout(imgs[i].getAttribute("loadFunction"),0);
			try{
			var func=new Function("div",imgs[i].getAttribute("loadFunction"));
			func(imgs[i]);
			}catch(e){}
		}*/
	}
	shortCuts.style.top=(getStageHeight()-30)+"px";
	shortCuts.style.left=((getStageWidth()-  (imgs.length*25))-10)+"px";
	menuBar.shortCuts=shortCuts;
	setMinimizationBar();
}

function doShortcutsOnLoad(){
	for(var i=0;i<dock.elements.length;i++){
		dock.elements[i].doload=new Function("div",dock.elements[i].getAttribute("loadFunction"));
		dock.elements[i].index=i;
		dock.elements[i].tryLoad=function(id){
			var el=dock.elements[id];
			try{
				el.doload(el);
			}catch(e){
				if(MSIE){
					setTimeout("dock.elements["+id+"].tryLoad("+id+")",6000);
				}else{
					setTimeout(function(el){el.tryLoad(el.index)},6000,el);
				}
			}
		}
		dock.elements[i].tryLoad(i);
		/*try{
		func(imgs[i]);
		}catch(e){
			setTimeout(func(imgs[i]),6000)
		}*/
		
	}
}

function parseMenuNode(menu){
	var menuArray=new Array();
	for(var u=0;u<menu.childNodes.length;u++){
		if(menu.childNodes[u]){
			if(menu.childNodes[u].tagName=="menuItem"){
				var menuItem={text:menu.childNodes[u].getAttribute("text"),calledFunction:menu.childNodes[u].getAttribute("calledFunction")};
				if(menu.childNodes[u].getElementsByTagName("menuItem").length>0){
					menuItem.menu=parseMenuNode(menu.childNodes[u]);
				}
				menuArray.push(menuItem);
			}
		}
	}
	return menuArray;
}

function setMinimizationBar(){
	var minimizationBar=document.createElement("DIV");
	minimizationBar.style.overflow="hidden";
	minimizationBar.innerHTML="<table height='25px' width='100%'><tr></tr></table>";
	minimizationBar.style.position="absolute";
	menuBar.id="menuBar";
	menuArea.appendChild(minimizationBar);
	menuBar.minimizationBar=minimizationBar;
	menuBar.minimizationBar.style.top=(getStageHeight()-30)+"px";
	menuBar.minimizationBar.style.left=(menuBar.startButton.offsetLeft+menuBar.startButton.offsetWidth+5)+"px";
	menuBar.minimizationBar.style.width=((menuBar.shortCuts.offsetLeft-menuBar.minimizationBar.offsetLeft)-40)+"px";
	menuBar.minimizationBar.minimizedWindows=new Array();
	menuBar.minimizationBar.addMinimizedWindow=function(window){
		this.minimizedWindows.push(window);
		this.updateView();
	}
	menuBar.minimizationBar.updateView=function(){
		var conteinerTr=this.getElementsByTagName("TR")[0];
		while(conteinerTr.childNodes.length>0){
			conteinerTr.removeChild(conteinerTr.childNodes[conteinerTr.childNodes.length-1]);
		}
		conteinerTr.style.width="0px";
		var tdAux=document.createElement("TD");
		tdAux.style.width="100%";
		tdAux.innerHTML="<img src='styles/"+currStyle+"/images/cellSizer.gif' style='100%' >";
		this.getElementsByTagName("TR")[0].appendChild(tdAux);
		for(var i=0;i<this.minimizedWindows.length;i++){
			var win=this.minimizedWindows[i];
			var td=document.createElement("TD");
			td.className="minimizedWindow";
			td.style.width="150px";
			td.innerHTML="<span style='white-space:nowrap;'><img src='styles/"+currStyle+"/images/cellSizer.gif' style='height:0px;width:150px' ><br>"+win.name+"</span>";
			td.id=i;
			td.onclick=function(){
				menuBar.minimizationBar.maximizeWindow(this.id);
			}
			this.getElementsByTagName("TR")[0].appendChild(td);
			var text=win.name;
			while(td.offsetWidth>154){
				text=text.substring(0,text.length-5);
				td.innerHTML="<span style='white-space:nowrap;'><img src='styles/"+currStyle+"/images/cellSizer.gif' style='height:0px;width:150px' ><br>"+text+"...</span>"
			}
		}
		tdAux.parentNode.removeChild(tdAux);
		tdAux=document.createElement("TD");
		tdAux.style.width="100%";
		tdAux.innerHTML="<img src='styles/"+currStyle+"/images/cellSizer.gif' style='100%' >";
		this.getElementsByTagName("TR")[0].appendChild(tdAux);
		if(this.getElementsByTagName("TR")[0].clientWidth>this.offsetWidth && (menuBar.scroller==undefined || menuBar.scroller==null)) {
			var scroller=document.createElement("DIV");
			scroller.style.position="absolute";
			scroller.style.width="44px";
			scroller.style.height="22px";
			scroller.style.left=((this.offsetLeft+this.offsetWidth)-5)+"px";
			scroller.style.top="3px";
			scroller.scrollToLeft=function(){
				menuBar.minimizationBar.scrollLeft=menuBar.minimizationBar.scrollLeft-150;
			}
			scroller.scrollToRight=function(){
				mlLeft=menuBar.minimizationBar.scrollLeft+150;
			}
			menuBar.appendChild(scroller);
			menuBar.scroller=scroller;
		}else if(this.getElementsByTagName("TR")[0].clientWidth<=this.offsetWidth && menuBar.scroller!=null){
			var scroller=menuBar.scroller;
			scroller.parentNode.removeChild(scroller);
			menuBar.scroller=null;
		}
	}
	menuBar.minimizationBar.maximizeWindow=function(winNum){
		var win=this.minimizedWindows[winNum];
		this.minimizedWindows.splice(winNum,1);
		this.updateView();
		win.minimize();
	}
}
