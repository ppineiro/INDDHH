// JavaScript Document
var dock;
var minIconSize=25;
var maxIconSize=50;
function setDock(){
	var imgs=[{src:"styles/"+currStyle+"/images/bin_icon.png"},{src:"styles/"+currStyle+"/images/freeTasks_icon.png"},{src:"styles/"+currStyle+"/images/myTasksIcon.png"}];
	dock=document.createElement("DIV");
	//dock.style.position="absolute";
	var content="<div id='container' style='border:0px solid red;vertical-align:super;'>";
	/*for(var i=0;i<imgs.length;i++){
		content+="<img src='"+imgs[i].src+"' title='"+imgs[i].src+"' style='width:30px;height:30px;'></img>";
	}*/
	content+="</div>";
	dock.innerHTML=content;
	dock.content=dock.getElementsByTagName("DIV")[0];
	/*deskTop.appendChild(dock);
	menuBar.appendChild(dock);*/
	menuArea.appendChild(dock);
	dock.elements=dock.getElementsByTagName("IMG");
	//Droppables.add(dock.elements[0], {accept:'trashable',hoverclass:'opacity70',onDrop:function(element){ element.remove(); } /*, onHover:function(draggable,droppable){draggable.className="opacity70";}*/ } );
	document.dockMove=function(evt){
		if(hitTest(dock,{x:getMouseX(evt),y:getMouseY(evt)} )){
			this.allSmall=false;
			evt=getEventObject(evt);
			var x=getMouseX(evt);
			x-=dock.offsetLeft;
			var distance=90;
			var maxSize=maxIconSize-minIconSize;
			for(var i=0;i<dock.elements.length;i++){
				var center=dock.elements[i].offsetLeft+15;
				if((center-x<distance && center-x>0) || (center-x>-distance && center-x<0)){
					var percentage=distance-Math.abs(center-x);
					var size=Math.round(percentage*maxSize/distance);
					dock.elements[i].style.width=(minIconSize+size)+"px";
					dock.elements[i].style.height=(minIconSize+size)+"px";
				}else{
					dock.elements[i].style.width=(minIconSize)+"px";
					dock.elements[i].style.height=(minIconSize)+"px";
				}
				if(hitTest(dock.elements[i],{x:getMouseX(evt),y:getMouseY(evt)})){
					dock.elements[i].className="";
				}else{
					dock.elements[i].className="opacity70";
				}
			}
			dock.positionate();
		}else if(!this.allSmall){
			for(var i=0;i<dock.elements.length;i++){
				dock.elements[i].style.width=(minIconSize)+"px";
				dock.elements[i].style.height=(minIconSize)+"px";
			}
			dock.positionate();
		}
	}
	addListener(document,"mousemove",document.dockMove);
	dock.onmouseout=function(evt){
		evt=getEventObject(evt);
		if(!hitTest(this,{x:getMouseX(evt),y:getMouseY(evt)})){
			for(var i=0;i<this.elements.length;i++){
				if(this.elements[i].offsetWidth>minIconSize){
					this.elements[i].style.width=(minIconSize)+"px";
					this.elements[i].style.height=(minIconSize)+"px";
				}
			}
			this.positionate();
			this.allSmall=true;
			/*removeListener(document,"mousemove",document.dockMove);
			document.dockMove=null;*/
		}
	}
	dock.addElement=function(element){
		var span=document.createElement("SPAN");
		var img=document.createElement("IMG");
		img.style.width=25+"px";
		img.style.height=25+"px";
		span.appendChild(img);
		this.content.appendChild(span);
		//this.content.appendChild(img);
		img.src=element.getAttribute("img");
		img.tooltip=element.getAttribute("text");
		if(img.tooltip==null){
			img.tooltip=element.name;
		}
		img.ondblclick=new Function(element.getAttribute("dblclick"));
		addListener(img,"dblclick",function(){
			closeContextMenues();
		});
		img.onload=element.getAttribute("onload");
		//img.className="opacity70";
		addToolTip(img);
		if(element.getAttribute("droppable")){
			Droppables.add(element, {accept:'trashable',hoverclass:'opacity70',onDrop:function(element){ element.remove(); } /*, onHover:function(draggable,droppable){draggable.className="opacity70";}*/ } );
		}
		this.positionate();
		return img;
	}
	dock.removeElement=function(element){
		hideToolTip();
		element.parentNode.removeChild(element);
		this.positionate();
	}
	dock.positionate=function(){
		/*this.style.top=((getStageHeight()-dock.offsetHeight)-30)+"px";
		this.style.left=((getStageWidth()-this.offsetWidth)/2)+"px";*/
		//this.style.top=((getStageHeight()-60)-(this.content.offsetHeight-28))+"px";
		this.style.top=((getStageHeight()-30)-(this.content.offsetHeight-28))+"px";
		this.style.width=((this.elements.length*minIconSize)+maxIconSize+(maxIconSize/2))+"px";//(dock.offsetWidth)+"px";
		//this.style.left=(30)+"px";
		this.style.left=(70)+"px";
	}
	dock.style.position="absolute";
	
	/*dock.style.padding="30px";
	dock.style.paddingBottom="2px";
	dock.style.paddingLeft="60px";
	dock.style.paddingRight="60px";*/
	
	dock.style.zIndex=5;
	/*dock.style.border="1px solid red";
	dock.style.width=(dock.elements.length*70)+"px";
	dock.style.width=(dock.offsetWidth)+"px";*/
	dock.positionate();
}
