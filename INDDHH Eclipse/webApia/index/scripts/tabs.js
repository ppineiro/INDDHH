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
	setPageOverFlow();
}

function setTab(element){
	var tabs=element.tabs;
	var defaultTab=element.getAttribute("defaultTab");
	defaultTab=(defaultTab)?defaultTab:0;
	
	if(tabs.length <= defaultTab)
		defaultTab = 0;
	
	var tabHolder=document.createElement("TABLE");
	tabHolder.border="0";
	tabHolder.cellpadding="0";
	tabHolder.cellspacing="0";
	tabHolder.style.marginLeft="30px";
	var tabContainer=document.createElement("TR");
	element.tabContainer=tabContainer;
	element.shownIndex=0;
	tabContainer.id="tabContainer";
	tabContainer.style.padding="0px";
	tabHolder.appendChild(tabContainer);
	if(!MSIE){
		tabHolder.style.marginBottom="1px";
	}
	var tabBottom=document.createElement("DIV");
	tabBottom.id="tabBottom";
	tabBottom.height="5px";
	tabHolder.style.padding="0px";
	element.tabBottom=tabBottom;
	var tab="";
	for(var i=0;i<tabs.length;i++){
		var tabText=tabs[i].getAttribute("tabText");
		var tabTitle=tabs[i].getAttribute("tabTitle")+" (ALT+"+(i+1)+")";
		if(window.name=="workArea" && document.body.className!="listBody"){
			tabs[i].style.marginLeft="5px";
		}
		var classStyle="";
		var td=document.createElement("TD");
		//if(i==0){
		if((i+"")==defaultTab){
			td.className="here";
			tabs[i].style.visibility="visible";
			element.shownIndex=i;
		}else{
			tabs[i].style.display="none";
		}
		tabs[i].style.overflow="hidden";
		tabs[i].style.position="relative";
		if(!MSIE){
			document.getElementById("divContent").style.overflow="auto";
			element.style.overflow="hidden";
		}else{
			document.getElementById("divContent").style.overflowX="hidden";
			document.getElementById("divContent").style.overflowY="auto";
			element.style.overflow="hidden";
		}
		tabs[i].id=("content"+i);
		if(!MSIE){
			td.innerHTML="<a id=\"tab"+i+"\" href=\"#\" style=\"white-space:nowrap;\" onclick=\"if(window.event){window.event.cancelBubble=true;}this.parentNode.onclick(event)\" title=\""+tabTitle+"\">"+tabText+"</a>";
		}else{
			td.innerHTML="<span id=\"tab"+i+"\" href=\"#\" style=\"white-space:nowrap;\" onmouseover=\"this.className='hover'\" href=\"#\" onmouseout=\"this.className=''\" onclick=\"if(window.event){window.event.cancelBubble=true;}this.parentNode.onclick(event)\" title=\""+tabTitle+"\">"+tabText+"</span>";
		}
		try{
		if(FLAG_OBS == "true" && tabs[i].getElementsByTagName("observations").length>0){
			td.firstChild.style.color = "red"
		}
		}catch(e){}
		
		try{
			if(tabs[i].getElementsByTagName("highlight").length>0){
				td.firstChild.style.color = "red"
			}
		}catch(e){}
		
		td.setAttribute("content",i)
		tabContainer.appendChild(td);
		if(tabs[i].getAttribute("tabText")==""){
			td.style.display="none";
		}
	}
	if(!MSIE){
		var divContent=document.getElementById("divContent");
		divContent.parentNode.insertBefore(tabHolder,divContent);
		divContent.parentNode.insertBefore(tabBottom,divContent);
	}else{
		document.getElementById("divContent").insertAdjacentHTML("beforeBegin",(tabHolder.outerHTML+tabBottom.outerHTML));
		element.tabContainer=document.getElementById("divContent").previousSibling.previousSibling.getElementsByTagName("TR")[0];
	}
	var tabTds=document.getElementById("tabContainer").getElementsByTagName("TD");
	for(var i=0;i<tabTds.length;i++){
		var td=tabTds[i];
		td.onclick=function(event){
			element.divContentToZero();
			event=getEventObject(event);
			event.cancelBubble=true;
			element.showContent(this.getAttribute("content"));
		}
	}
	element.hideAllContents=function(){
		for(var i=0;i<this.tabs.length;i++){
			document.getElementById("tab"+i).parentNode.className="";
			document.getElementById("content"+i).style.display="none";
		}
		var calDiv = document.getElementById("calendarDiv");
		if(calDiv != null && calDiv != undefined) {			
			calDiv.style.visibilty = "hidden";
			calDiv.innerHTML = "";
			calDiv.parentNode.removeChild(calDiv);
		}
	}
	element.showContent=function(contentNumber){
		if((contentNumber>this.tabs.length)/* || (this.shownIndex==contentNumber)*/){
			return;
		}
		if(this.tabs[contentNumber].getAttribute("tabDisabled")=="true"){
			return;
		}
		try{
		if(onTabChangeSaveFlash!=undefined){
			if( document.getElementById("content"+this.shownIndex)
			&& (document.getElementById("content"+this.shownIndex).getElementsByTagName("EMBED").length>0
			|| document.getElementById("content"+this.shownIndex).getElementsByTagName("OBJECT").length>0)
			&& flashLoaded){
				listener.contentNumber=contentNumber;
				onTabChangeSaveFlash(this,contentNumber);
				return;
			}
		}
		}catch(e){}
		if(document.getElementById("content"+this.shownIndex)
		&& document.getElementById("content"+this.shownIndex).getElementsByTagName("EMBED").length>0
		&& !MSIE) {
			var apia_flash_loaded = false;
			try {
				apia_flash_loaded = flashLoaded;
			} catch(e) {}
			if(apia_flash_loaded) {
				listener.contentNumber=contentNumber;
				hideFlash(document.getElementById("content"+this.shownIndex).getElementsByTagName("EMBED")[0].id);
				this.shownIndex=contentNumber;
			} else {
				this.afterShowContent(contentNumber);
			}
		}else{
			this.afterShowContent(contentNumber);
		}
	}
	
	element.afterShowContent=function(contentNumber){
		this.hideAllContents();
		document.getElementById("content"+contentNumber).style.display="block";
		document.getElementById("content"+contentNumber).style.visibility="visible";
		document.getElementById("tab"+contentNumber).parentNode.className="here";
		fixInnerGrids(document.getElementById("content"+contentNumber));
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
		this.shownIndex=contentNumber;
		if(this.getAttribute("ontabswitch")!=null){
			try{
				this.onswitch();
				//setTimeout('window.frames["frameContent'+contentNumber+'"].refresh()',200);
			}
			catch(e){
				alert("EXCEPTION");
			}
		}
		if(MSIE){
			var divs=document.getElementById("content"+contentNumber).getElementsByTagName("DIV");
			var grids=new Array();
			for(var i=0;i<divs.length;i++){
				if(divs[i].getAttribute("type")=="grid"){
					grids.push(divs[i]);
				}
			}
		}
		setPageOverFlow();
		sizeMe();
		setGridsScrollToZero();	
	}
	
	element.afterFlashLoad=function(){
	
	}
	element.getSelectedTabIndex=function(){
		return this.shownIndex;
	}
	if(element.getAttribute("ontabswitch")!=null){
		element.onswitch=function(){
			try{
			var func=new Function(this.getAttribute("ontabswitch"));
			func();
			}catch(e){}
		}
	}
	element.handleKey=function(eventObj){
		var eventObj=getEventObject(eventObj);
		var elKeyCode = eventObj.keyCode;
		var alt = eventObj.altKey;
		var index=elKeyCode-49;
		var ctrl = eventObj.ctrlKey;
		if(! ctrl && alt && index>=0 && index<this.tabs.length){
			this.showContent(index);
		}
	}
	element.disableTab=function(number){
		this.tabs[number+1].setAttribute("tabDisabled","true");
		var td=this.tabContainer.getElementsByTagName("TD")[number+1];
		td.style.display="none";
	}
	element.enableTab=function(number){
		element.tabs[number+1].setAttribute("tabDisabled","false");
		element.tabContainer.cells[number+1].style.display="block";
	}
	element.divContentToZero=function(){
		var divContent=document.getElementById("divContent");
		if(divContent){
			divContent.scrollTop=0;
		}
	}
	
	var divContent = document.getElementById("divContent");
	if(divContent){
		if(divContent.getAttribute('scollListener') != 'true') {

			if(divContent.addEventListener) {
				divContent.addEventListener('scroll', function() {
					var calDiv = document.getElementById("calendarDiv");
					if(calDiv) {			
						calDiv.style.visibilty = "hidden";
						calDiv.innerHTML = "";
						calDiv.parentNode.removeChild(calDiv);
					}
				});
			} else {
				divContent.attachEvent('onscroll', function() {
					var calDiv = document.getElementById("calendarDiv");
					if(calDiv) {			
						calDiv.style.visibilty = "hidden";
						calDiv.innerHTML = "";
						calDiv.parentNode.removeChild(calDiv);
					}
				});
			}
			
			divContent.setAttribute('scollListener', 'true')
		}
	}
	
	setTabShortcuts(element);
	
}

function sizeTabElements(height,width){
	for(var i=0;i<tabElements.length;i++){
		var tabElement =tabElements[i];
		tabElement.style.width=(width)+"px";//"100%";
		var tabs=tabElement.tabs;
		tabElement.tabBottom.style.width=(width-10)+"px";
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
				if(object.getAttribute("dont_resize") == undefined || object.getAttribute("dont_resize") == null) {
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
}

function hideFlash(id){
	getFlashObject(id).SetVariable("call","hideFlash");
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

function setTabShortcuts(tabElement){
	addListener(document,"keydown",function(evt){tabElement.handleKey(evt)})
}

function showDefaultContents(){
	for(var i=0;i<tabElements.length;i++){
		if(tabElements[i].getAttribute("defaultTab")){
			tabElements[i].showContent(tabElements[i].getAttribute("defaultTab"));
		}
	}
}