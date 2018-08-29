	function doLIAction(aEvent){
		document.getElementById("scrolledDiv").setAttribute("scrollTopAux",document.getElementById("scrolledDiv").scrollTop);
		var element=getEventSource(aEvent);
		aEvent=getEventObject(aEvent);
		aEvent.cancelBubble = true;
		if (element.className=="clsFolder"){
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
			var func="updateIframeSize()";
			setTimeout(func,10);
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
				redirect(url);
			}
		}
		var obj=document.getElementById("treeMenu");
		obj.getElementsByTagName("DIV")[0].style.display="none";
		obj.getElementsByTagName("DIV")[0].style.display="block";
//		obj.style.width="600px";
		updateIframeSize();
		if(!MSIE){
			document.getElementById("scrolledDiv").scrollTop=document.getElementById("scrolledDiv").getAttribute("scrollTopAux");
		}
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
		if(!document.getElementById("treeMenuContainer").isShown){
			document.getElementById("treeMenuContainer").isShown=true;
			doMenuAction("show");
			document.getElementById("closer").style.left="0px";
			document.getElementById("closer").style.display="block";
		}else{
			hideMenu();
		}
	}

	function doMenuAction(show){
		updateIframeSize();
		if(MSIE &&(window.event)){
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
				e=getEventObject(e);
				if(MSIE){
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
			if(MSIE){
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
		/*if(navigator.userAgent.indexOf("MSIE")<0){
			document.getElementById("scrolledDiv").style.overflow="hidden";
			document.getElementById("scrolledDiv").style.overflow="-moz-scrollbars-vertical";
		}*/
	}
	
	function redirect(url){
		document.getElementById("workArea").src=url;
	}
	function updateIframeSize(){
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
	}
	