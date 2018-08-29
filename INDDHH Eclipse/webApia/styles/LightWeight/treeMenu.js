	function doLIAction(aEvent){
		var element=aEvent.target;
		if(window.navigator.appVersion.indexOf("MSIE")>=0){
			aEvent=window.event;
			element=aEvent.srcElement;
		}
		aEvent.cancelBubble = true;
		if(element.tagName=="SPAN"){
			element=element.parentNode;
		}
		if (element.className=="tdInnerTitleAcord"){
			if(element.parentNode.nextSibling.firstChild.style.display!="block"){
				element.parentNode.nextSibling.firstChild.style.display="block";
				element.parentNode.nextSibling.style.display="block";
			}else{
				element.parentNode.nextSibling.firstChild.style.display="none";
				element.parentNode.nextSibling.style.display="none";
				element.parentNode.parentNode.parentNode.style.display="none";
				element.parentNode.parentNode.parentNode.style.display="block";
			}
		}else if (element.className=="clsFolder"){
			var fldAtt = element.Fldstate;
			if(fldAtt!="open"){
				element.Fldstate="open";
				var img=element.childNodes[0];
				img.src=URL_STYLE_PATH+"/images/folder_open.gif";
				//show open
			}else{
				element.Fldstate="";
				var img=element.childNodes[0];
				img.src=URL_STYLE_PATH+"/images/folder_closed.gif";
				//showCloseds
			}
			var eleChild=GetChildren(element,"UL");
			for(var i=0;i<eleChild.length;i++){
				var child=eleChild[i];
				if(child.style.display =="block"){
					child.style.display ="none";
				}else{
					child.style.display ="block";
				}
			}
		}else{
			//changeContent
			var url="";
			if(navigator.userAgent.indexOf("MSIE")>0){
				url=element.URL;
			}else{
				for(var i=0;i<element.attributes.length;i++){
					if(element.attributes[i].nodeName.toLowerCase()=="url"){
						url=element.attributes[i].nodeValue;
					}
				}
			}
			if(url!=null && url!=undefined){
				//redirect(url);
				doLink(element);
			}
		}
		sizeToc();
	}
	
	function setLiWidths(){
		var elements=document.getElementById("tocHolder").getElementsByTagName("LI");
		for(var i=0;i<elements.length;i++){
			if(elements[i].clientWidth>0){
				elements[i].setAttribute("realWidth",elements[i].clientWidth);
			}
		}
	}
	
	function mouseOverToc() {
		if(EXPAND_ON_MOUSEOVER == "true") {
			var already_sized = window.parent.document.getElementById("tocArea").getAttribute("already_sized") == "true";
			if(!already_sized) {
				window.parent.document.getElementById("tocArea").setAttribute("already_sized", "true");
				sizeToc();
			}
		}
	}
	
	function sizeToc(){
		if(navigator.userAgent.indexOf("MSIE")<0){
			document.getElementById("tocContainer").style.overflow="hidden";
			document.getElementById("tocContainer").style.overflow="-moz-scrollbars-vertical";
		}
		var elements=document.getElementById("tocHolder").getElementsByTagName("LI");
		var width=0;
		var max;
		for(var i=0;i<elements.length;i++){
			if(elements[i].parentNode.style.display!="none"){
				var thisWidth=elements[i].childNodes[0].offsetWidth+80;
				if(width<thisWidth){
					width=thisWidth;
					max=elements[i];
				}
			}
		}
		elements=document.getElementById("tocHolder").getElementsByTagName("TD");
		for(var i=0;i<elements.length;i++){
			if(elements[i].parentNode.style.display!="none"){
				if(elements[i].getElementsByTagName("SPAN")[0]){
					var thisWidth=elements[i].getElementsByTagName("SPAN")[0].offsetWidth+20;
					if(width<thisWidth){
						width=thisWidth;
						max=elements[i];
					}
				}
			}
		}
		var o=max.offsetParent;
		while(o!=null){
			width+=o.offsetLeft;
			o=o.offsetParent;
		}
		document.getElementById("tocHolder").style.width=(width-5)+"px";
		document.getElementById("tocContainer").style.width=(width-3)+"px";
		adjustBack(width);
		document.getElementById("tocContainer").style.height=(window.parent.document.getElementById("tocArea").clientHeight-5)+"px";
		if(navigator.userAgent.indexOf("MSIE")<0){
			document.getElementById("tocContainer").style.overflow="hidden";
			if(document.getElementById("tocContainer").offsetHeight<document.getElementById("tocHolder").clientHeight){
				if(OPERA || CHROME){
					document.getElementById("tocContainer").style.overflow="auto";
				}else{
					document.getElementById("tocContainer").style.overflow="-moz-scrollbars-vertical";
				}
			}
		}
		elements=document.getElementById("tocHolder").getElementsByTagName("TD");
		for(var i=0;i<elements.length;i++){
			if(elements[i].parentNode.style.display!="none"){
				elements[i].style.width=width+"px";
			}
		}
		window.parent.document.getElementById("tocArea").style.width=(width+2)+"px";
	}
	function adjustBack(width){
		document.getElementById("tocContainerBack").style.width=(width-4)+"px";
	}
	function hitTest(obj,x,y){
		if(navigator.userAgent.indexOf("MSIE")>0){
			if((x<(obj.clientWidth+2))&&(y>(obj.clientTop)) && (y<(obj.clientHeight+70))){
				return true;
			}else{
				return false;
			}
		}else{
			var height=removePX(obj.style.height);
			if((x<(obj.offsetWidth-2))&&(y>(obj.offsetTop)) && (y<(obj.offsetHeight+60))){
				return true;
			}else{
				return false;
			}
		}
	}
	function GetChildren(element,name){
		var nodeList = element.childNodes;
		//var nodeList = element.getElementsByTagName(name);
		var aux=new Array();
		for(var i=0;i<nodeList.length;i++){
			var node=nodeList[i];
			if(node.tagName==name){
				aux.push(node);
			}
		}
		return aux;
	}
	
	function doMenuBarAction(){
		if(document.getElementById("treeMenuContainer") && !document.getElementById("treeMenuContainer").isShown){
			document.getElementById("treeMenuContainer").isShown=true;
			doMenuAction("show");
			document.getElementById("closer").style.left="0px";
			document.getElementById("closer").style.display="block";
		}else if(document.getElementById("treeMenuContainer")){
			hideMenu();
		}
	}

	function doMenuAction(show){
		updateIframeSize();
		if(window.navigator.appVersion.indexOf("MSIE")>=0 &&(window.event)){
			window.event.cancelBubble=true;
		}
		var div=document.getElementById("treeMenuContainer");
		if(show=="show"){//div.style.posLeft!="0px" && div.style.left!="0px"){
			//moveDivTo(0);
			//document.getElementById("comboHider").parentNode.style.display="block";
			if(navigator.userAgent.indexOf("MSIE")>0){
				document.getElementById("comboHider").parentNode.style.left="3px";
				//document.getElementById("comboHider").parentNode.style.posLeft="0px";
			}else{
				document.getElementById("comboHider").parentNode.style.left="0px";
				document.getElementById("comboHider").parentNode.style.posLeft="0px";
			}
			div.style.posLeft="0px";
			div.style.left="0px";
			
			document.onmousemove=function(e){
				var tempY=0;
				var tempX=0;
				if(navigator.userAgent.indexOf("MSIE")>0){
					e=window.event;
					tempX = e.clientX + document.body.scrollLeft
					tempY = e.clientY + document.body.scrollTop
				}else{
				    tempX = e.pageX
				    tempY = e.pageY
				}
				e.cancelBubble = true;
				if(!(hitTest(document.getElementById("treeMenuContainer"),tempX,tempY))){
					document.onmousemove="";
					doMenuAction("hide");
				}
			}
			div.className="";
		}else{
			var toX=(-((div.clientWidth)-5));
			div.isShown=false;
			/*var func="moveDivTo('"+toX+"')";
			setTimeout(func,1000);*/
			hideMenu();
		}
		updateIframeSize();
	}
	function removePX(num){
		var newNum="";
		for(var i=0;i<num.length;i++){
			if(num[i]!="p" && num[i]!="x"){
				newNum=newNum+num[i];
			}
		}
		return newNum;
	}
	
	function moveDivTo(toX){
		var obj=document.getElementById("treeMenuContainer");
		var fromX=obj.style.left;
		if(navigator.userAgent.indexOf("MSIE")>0){
			fromX=obj.style.posLeft;
		}else{
			fromX=removePX(fromX);
		}
		var x=-10;
		/*if(parseInt(fromX)>parseInt(toX)){
			x=-1;
		}*/
		if(parseInt(fromX)>parseInt(toX)){
			if(navigator.userAgent.indexOf("MSIE")>0){
				obj.style.posLeft=obj.style.posLeft+x;
			}else{
				obj.style.left=((parseInt(fromX)+parseInt(x))+"px");
			}
			if(obj.isShown==false){
				var func="moveDivTo("+toX+")";
				setTimeout(func,1);
			}
		}else if(parseInt(fromX)<parseInt(toX)){
			obj.style.posLeft=(toX+3)+"px";
			obj.style.left=(toX+3)+"px";
			obj.className="hidden";
		}else{
			obj.className="hidden";
		}
	}
	
	function hideMenu(){
		try{
		updateIframeSize();
		document.getElementById("closer").style.left=(-document.getElementById("closer").clientWidth)+"px";
		document.getElementById("closer").style.display="none";
		var obj=document.getElementById("treeMenuContainer");
		var toX=(-((obj.clientWidth)-5));
		obj.isShown=false;
		obj.style.posLeft=(toX)+"px";
		obj.style.left=(toX)+"px";
//		document.getElementById("comboHider").parentNode.style.display="none";
		if(navigator.userAgent.indexOf("MSIE")>0){
			document.getElementById("comboHider").parentNode.style.posLeft=(toX+3)+"px";
			document.getElementById("comboHider").parentNode.style.left=(toX+3)+"px";
		}else{
			document.getElementById("comboHider").parentNode.style.posLeft=(toX)+"px";
			document.getElementById("comboHider").parentNode.style.left=(toX)+"px";
		}
		obj.className="hidden";
		}catch(e){}
	}
	
	function redirect(url){
		window.parent.document.getElementById("iframeMessages").showResultFrame(document.body);
		window.parent.document.getElementById("workArea").src=unescape(url);
	}
	function updateIframeSize(){
		try{
			var obj=document.getElementById("treeMenuContainer");
			obj.style.display="none";
			obj.style.display="block";
			var scrolledDiv=document.getElementById("scrolledDiv");
			document.getElementById("handle").style.width="5px";
			//scrolledDiv.style.width=(scrolledDiv.clientWidth*1.25)+"px";
			var hider=document.getElementById("comboHider");
			hider.style.width=(obj.clientWidth)+"px";
			hider.style.left="200px";
			hider.style.height=(obj.clientHeight)+"px";
		}catch(e){}
	}
	function updateHeight(){
		document.getElementById("tocContainer").style.height=(window.parent.document.getElementById("tocArea").clientHeight-5)+"px";
	}
	
	
	function doLink(par){
		//codigo para autoguardar tareas.... se llama siempre dado que el btnExit_click verifica el parametro
		window.parent.frames["workArea"].afterAutoSave=function(){}
		var isExecution = false;
		try{
			window.parent.frames["workArea"].frames["frameContent2"].afterAutoSave=function(){}
			window.parent.frames["workArea"].frames["frameContent2"].btnExit_click();
			isExecution = true;
		}catch(e){
			try{
				window.parent.frames["workArea"].frames["ifrAutoSave"].parent.btnExit_click();
				isExecution = true;
			}catch(e){}
		}
		eLink = par;
		try {
			if(isExecution){
				setTimeout('doLinkTimedOut()',300);
			} else {
				doLinkTimedOut();
			}
		} catch(e2) {}
	}	
	var eLink;
	function doLinkTimedOut(){	
		if (eLink.getAttribute("URL").indexOf(DATAWARE_ACTION) == -1) {
			window.parent.document.getElementById("iframeMessages").showResultFrame(document.body);
		}
		if(eLink.tagName=="LI"){
				var sList_Title = "&list_Title=" + escape(eLink.title);
				var sLink = eLink.URL + sList_Title;
				if (eLink.getAttribute("URL").indexOf(DATAWARE_ACTION) == -1) {
					doLogoutDataware();
					doLogoutScoreCard();
				} else {
					if (eLink.getAttribute("URL").indexOf(LOAD_CUBE) != -1 || eLink.getAttribute("URL").indexOf(LOAD_VIEW) != -1) {
						doLogoutScoreCard();
						DATAWARE_LOGED = true;
					} else if (eLink.getAttribute("URL").indexOf(LOAD_CARD) != -1) {
						doLogoutDataware();
						SCORECARD_LOGED = true;
					} else {
						doLogoutDataware();
						doLogoutScoreCard();
					}
				}
	
				if(eLink.getAttribute("FNC_NEW_WIN") != null && eLink.getAttribute("FNC_NEW_WIN") == 1) {
					/*window.open(eLink.URL,"Apia");*/
					var webLink = "";
					if (eLink.getAttribute("URL").indexOf("link") != -1) {
						webLink = eLink.getAttribute("URL").substring(eLink.URL.indexOf("link=")+5);
					}else if( eLink.getAttribute("URL").toLowerCase().indexOf("://") != -1  ) {
					    webLink = eLink.getAttribute("URL");
					} else if (eLink.getAttribute("URL").indexOf("../") == 0) {
						webLink = eLink.getAttribute("URL");
					} else {
						webLink = URL_APIA + "/" + eLink.getAttribute("URL");
					}
					window.parent.document.getElementById("iframeMessages").hideResultFrame(document.body);
					window.open(webLink,"","height=500,width=700,scrollbars=1,resizable=1");
				} else {
	
					/*parent.frames("workArea").location.href = eLink.URL;*/
					
					if( eLink.getAttribute("URL").toLowerCase().indexOf("://") != -1  ) {
						var url = "../../toc/redirectUrl.jsp?url=" + eLink.getAttribute("URL").substring(eLink.getAttribute("URL").indexOf("http://"));
						window.parent.frames["workArea"].location.href = url;
					} else if (eLink.getAttribute("URL").indexOf("link") != -1) {
						if (eLink.getAttribute("URL").indexOf("redirectUrl") != -1) {
							window.parent.frames["workArea"].location.href = "../../toc/redirectUrl.jsp?url=" + eLink.getAttribute("URL").substring(eLink.getAttribute("URL").indexOf("link=")+5);
						} else {
							var url=eLink.getAttribute("URL");
							url=url.split("link=")[0]+"link="+escape(url.split("link=")[1]);
							window.parent.frames["workArea"].location.href = url;
						}
					} else if (eLink.getAttribute("URL").indexOf("../") == 0) {
						window.parent.frames["workArea"].location.href = eLink.getAttribute("URL");
					} else {
						window.parent.frames["workArea"].location.href = URL_APIA + "/" + eLink.getAttribute("URL");
					}
				}
		}else{
		}
	}
if(window.navigator.appVersion.indexOf("MSIE")>=0){
	document.onmousedown=function(){
		sizeToc();
	}
}