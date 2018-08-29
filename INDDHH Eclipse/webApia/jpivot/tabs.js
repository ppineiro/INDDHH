// JavaScript Document
var tabElements=new Array();
function setTabs(){
	var divs=document.getElementsByTagName("DIV");
	for(var i=0;i<divs.length;i++){
		var div=divs[i];
		if(div.getAttribute("type")=="tabElement" && div.getAttribute("ready")!="true"){
			div.setAttribute("ready","true");
			div.tabs=new Array();
			var tabs=div.getElementsByTagName("DIV");
			for(var u=0;u<tabs.length;u++){
				var tab=tabs[u];
				if(tab.getAttribute("type")=="tab"){
					div.tabs.push(tab);
				}
			}
			setTab(div);
			tabElements.push(div);
		}
	}
	sizeTabs();
}

function setTab(element){
	var tabs=element.tabs;
	var tabHolder=document.createElement("TABLE");
	tabHolder.border="0";
	tabHolder.cellPadding="0";
	tabHolder.cellSpacing="0";
	tabHolder.style.paddingLeft="30px";
	var tabContainer=document.createElement("TR");
	tabContainer.id="tabContainer";
	tabContainer.style.padding="0px";
	tabHolder.appendChild(tabContainer);
	if(!MSIE){
		tabHolder.style.marginBottom="1px";
	}
	var tab="";
	if(tabs.length==0){
		element.style.display="none";
	}
	for(var i=0;i<tabs.length;i++){
		var tabText=tabs[i].getAttribute("tabText");
		var tabTitle=tabs[i].getAttribute("tabTitle");
		var classStyle="";
		var td=document.createElement("TD");
		if(i==0){
			td.className="here";
			tabs[i].style.visibility="visible";
			
		}else{
			tabs[i].style.display="none";
		}
		//tabs[i].style.overflow="hidden";
		
		tabs[i].style.position="relative";
		tabs[i].id=("content"+i);
		td.innerHTML="<table onclick='fireElementEvent(this.parentNode,\"click\");' title='"+tabTitle+"' cellpadding='0' cellspacing='0'><tr><td style='background-image:url("+URL_ROOT_PATH+"/images/jpivot/tabLeft.gif)'><div style='position:relative;width:8px;height:0px;'></div></td><td style='background-image:url("+URL_ROOT_PATH+"/images/jpivot/tabCenter.gif)'><div style='position:static;'>"+tabText+"</div></td><td style='background-image:url("+URL_ROOT_PATH+"/images/jpivot/tabRight.gif)'><div style='position:relative;width:11px;height:0px;'></div></td></tr></table>";
		td.setAttribute("content",i)
		tabContainer.appendChild(td);
	}
	var tabBottom=document.createElement("DIV");
	if(!MSIE){
		element.parentNode.insertBefore(tabBottom,element);
		element.parentNode.insertBefore(tabHolder,tabBottom);
	}else{
		element.insertAdjacentHTML("beforeBegin","<div></div>");
		tabBottom=element.previousSibling;
		tabBottom.insertAdjacentHTML("beforeBegin",(tabHolder.outerHTML));
		//element.insertAdjacentHTML("beforeBegin",(tabHolder.outerHTML));
	}
	if(!MSIE6){
		tabBottom.innerHTML="&nbsp!";
	}
	tabBottom.className="tabBottom";
	tabBottom.style.position="relative";
	tabBottom.style.height="2px";
	tabBottom.style.fontSize="1px";
	tabBottom.style.backgroundColor="#F8F8F8";
	tabBottom.style.border="1px solid #919999";
	element.tabBottom=tabBottom;
	tabHolder=element.previousSibling.previousSibling;
	element.tabContainer=tabHolder.getElementsByTagName("TR")[0];
	var tabTds=element.tabContainer.childNodes;
	for(var i=0;i<tabTds.length;i++){
		tabTds[i].onclick=function(event){
			event=getEventObject(event);
			event.cancelBubble=true;
			var tabElement=this.parentNode;
			while(tabElement.id!="tabContainer"){
				tabElement=tabElement.parentNode;
			}
			while(tabElement.tagName!="TABLE"){
				tabElement=tabElement.parentNode;
			}
			while(tabElement.getAttribute("type")!="tabElement"){
				tabElement=tabElement.nextSibling;
			}
			var content=this;
			while(!content.getAttribute("content")){
				content=content.parentNode;
			}
			tabElement.showContent(content.getAttribute("content"));
		}
	}
	
	element.hideAllContents=function(){
		for(var i=0;i<this.tabs.length;i++){
			this.tabs[i].style.display="none";
		}
		var tds=this.tabContainer.childNodes;
		for(var i=0;i<tds.length;i++){
			tds[i].className="notHere";
			var tds2=tds[i].getElementsByTagName("TD");
			if(tds2.length>3){
				tds2[0].style.backgroundImage="url("+URL_ROOT_PATH+"/images/jpivot/tabLeft.gif)";
				tds2[1].style.backgroundImage="url("+URL_ROOT_PATH+"/images/jpivot/tabCenter.gif)";
				tds2[2].style.backgroundImage="url("+URL_ROOT_PATH+"/images/jpivot/tabRight.gif)";
			}
		}
	}
	element.showContent=function(contentNumber){
		if(this.tabs.length==0 || contentNumber<0){
			return false;
		}else if(contentNumber==null || contentNumber=="null" || contentNumber==this.tabs.length){
			contentNumber=0;
		}
		if(document.getElementById("content"+this.shownIndex).getElementsByTagName("EMBED").length>0
		&& !MSIE
		&& flashLoaded){
			
			listener.contentNumber=contentNumber;
			hideFlash();
			this.shownIndex=contentNumber;
		}else{
			if(contentNumber && this.tabs[contentNumber]==undefined){
				this.showContent(contentNumber-1);
				return;
			}
			this.hideAllContents();
			this.tabs[contentNumber].style.display="block";
			this.tabs[contentNumber].style.visibility="visible";
			if(this.tabs[contentNumber].scrollWidth>this.tabs[contentNumber].offsetWidth){
				this.tabs[contentNumber].style.width=this.tabs[contentNumber].scrollWidth+"px";
			}
			
			var td=this.tabContainer.childNodes[contentNumber];
			td.className="here";
			var tds=td.getElementsByTagName("TD");
			if(tds.length>3){
				tds[0].style.backgroundImage="url("+URL_ROOT_PATH+"/images/jpivot/tabLeftB.gif)";
				tds[1].style.backgroundImage="url("+URL_ROOT_PATH+"/images/jpivot/tabCenterB.gif)";
				tds[2].style.backgroundImage="url("+URL_ROOT_PATH+"/images/jpivot/tabRightB.gif)";
			}
			if(window.name!=""){
			var container=window.parent.document.getElementById(window.name);
				if(container){
					var width=container.style.width;
					if(!MSIE){
						container.style.display="none";
						container.style.display="block";
					}
				}
			}
			var divs=document.getElementById("content"+contentNumber).getElementsByTagName("DIV");
			for(var i=0;i<divs.length;i++){
				if(divs[i].getAttribute("type")=="grid"){
					var width=divs[i].parentNode.offsetWidth;
					if(document.getElementById("divContent").scrollHeight>document.getElementById("divContent").clientHeight){
						width=width-50;
						divs[i].setWidth(width-20);
						var navBar=divs[i].nextSibling;
						if(!MSIE){
							document.getElementById("divContent").style.overflow="hidden";
							document.getElementById("divContent").style.overflow="-moz-scrollbars-vertical";
							while(navBar && navBar.tagName!="TABLE"){
								navBar=navBar.nextSibling;
							}
						}
						if(navBar){
							navBar.style.width=width+"px";
						}
					}else if(!MSIE){
						document.getElementById("divContent").style.overflow="auto";
					}
				}
			}
			this.shownIndex=contentNumber;
			if(this.getAttribute("ontabswitch")!=null){
				try{
					this.onswitch();
					//setTimeout('window.frames["frameContent'+contentNumber+'"].refresh()',200);
				}
				catch(e){
					showMessage(ERR_UNEXPECTED);
				}
			}
		}
	}
	element.getSelectedTabIndex=function(){
		return this.shownIndex;
	}
	element.shownIndex=0;
	if(element.getAttribute("ontabswitch")!=null){
		element.onswitch=new Function(element.getAttribute("ontabswitch"));
	}
	if(element.getAttribute("defaultTab")){
		element.showContent(element.getAttribute("defaultTab"));
	}
}

function sizeTabs(){
	if(getElementsByClassName("navigatorTd").length==0){
		for(var i=0;i<tabElements.length;i++){
			var tabElement=tabElements[i];
			var width=(getStageWidth()-30)+"px";
			tabElement.tabBottom.style.width=width;
			var p=tabElement.parentNode;
			if(p.tagName=="TD"){
				p.parentNode.parentNode.parentNode.style.width=width;
			}
			var tabs=tabElement.tabs;
			tabElement.style.width=width;
			/*for(var t=0;t<tabs.length;t++){
				//tabs[t].style.width=width;
			}*/
		}
	}
}

function sizeTabElements(height,width){
	for(var i=0;i<tabElements.length;i++){
		var tabElement =tabElements[i];
		tabElement.style.width=(width)+"px";//"100%";
		var tabs=tabElement.tabs;
		for(var u=0;u<tabs.length;u++){
			tabs[u].style.width=(width)+"px";//"100%";
			if(tabs[u].getElementsByTagName("IFRAME")[0] && 
			(tabs[u].getElementsByTagName("IFRAME")[0].id.indexOf("frameContent")>=0)){
				tabElement.style.width=width+"px";
				tabs[u].style.width=(width-5)+"px";
				tabs[u].getElementsByTagName("IFRAME")[0].style.height=(height-2)+"px";
				tabs[u].getElementsByTagName("IFRAME")[0].style.width="100%";//(width-8)+"px";//"100%";
			}
			var objects=tabs[u].getElementsByTagName("OBJECT");
			if(objects.length>0){
				var object=objects[0];
				if(!MSIE){
					var embed=getFlashObject("shell");
					if(embed){
						object.width="100%";///(width-80)+"px";
						object.style.height=(height-20)+"px";
					}
				}else{
					object.width="100%";
					object.height=(height-25)+"px";
					object.align="left";
				}
			}
		}
	}
}

function hideFlash(){
	getFlashObject("shell").SetVariable("call","hideFlash");
}


function getFlashObject(movieName){
	if (window.document[movieName]){
		return window.document[movieName];
	}
	if (navigator.appName.indexOf("Microsoft Internet")==-1){
		if (document.embeds && document.embeds[movieName]){
			return document.embeds[movieName];
		}
	}else{
		return document.getElementById(movieName);
	}
}

function testclick(){
	var tabTds=document.getElementById("tabContainer").childNodes;
	var td=tabTds[0];
	for(var i=0;i<tabTds.length;i++){
		/*td.onclick=function(event){
			event=getEventObject(event);
			event.cancelBubble=true;
			var tabElement=this.parentNode;
			while(tabElement.id!="tabContainer"){
				tabElement=tabElement.parentNode;
			}
			while(tabElement.tagName!="TABLE"){
				tabElement=tabElement.parentNode;
			}
			while(tabElement.getAttribute("type")!="tabElement"){
				tabElement=tabElement.nextSibling;
			}
			var content=this;
			while(!content.getAttribute("content")){
				content=content.parentNode;
			}
			tabElement.showContent(content.getAttribute("content"));
		}*/
	}
}