// JavaScript Document
var dragDiv;
function elementContainer(div){
	div.elements;
	div.data;
	this.nextElement=0;
	div.setData=function(element){
		this.data=element;
	}
	div.updateView=function(){
		this.nextElement=0;
		this.innerHTML="";
		this.elements=new Array();
		for(var i=0;i<this.data.elements.length;i++){
			this.addElementView(this.data.elements[i].getIconElement());
		}
	}
	div.addElement=function(element){
		this.data.addElement(element);
		this.addElementView(element.getIconElement());
	}
	div.removeElement=function(element){
		this.data.removeElement(element.getObject());
		element.removeMe();
	}
	div.addElementView=function(element){
		element.id=(this.id+"_"+this.nextElement);
		this.nextElement++;
		var dist=100;
		var cantPorCol=Math.floor(this.clientWidth/dist);
		var aCol=Math.floor(this.elements.length/cantPorCol);
		element.style.position="absolute";
		element.style.top=(Math.floor(aCol*dist))+"px";
		element.style.left=(Math.floor((this.elements.length%cantPorCol)*dist))+"px";
		this.elements.push(element);
		this.appendChild(element);
		element.onmousedown=function(aEvent){
			aEvent=getEventObject(aEvent);
			if(aEvent.button==2){
				/*aEvent.cancelBubble=true;
				document.oncontextmenu=function(){
					return false;
				}*/
			}else{
				var clone=this.cloneNode(true);
				clone.id="clone";
				clone.style.zIndex=99999999;
				clone.style.left=getMouseX(aEvent);
				clone.style.top=getMouseY(aEvent);
				clone.style.display="none";
				clone.original=this;
				dragDiv.appendChild(clone);
				aEvent=getEventObject(aEvent);
				cancelBubble(aEvent);
				dragWindow=this.parentNode.parentNode;
				if(!event.ctrlKey){
					this.style.display="none";
				}
				document.onmousemove=function(aEvent){
					var clone=document.getElementById("clone");
					clone.style.display="block";
					var tempY=0;
					var tempX=0;
					var doc;
					tempX=getMouseX(aEvent);
					tempY=getMouseY(aEvent);
					aEvent=getEventObject(aEvent);
					cancelBubble(aEvent);
					clone.style.left=(tempX-(clone.offsetWidth/2))+"px";
					clone.style.top=(tempY-(clone.offsetHeight/2))+"px";
				}
				document.onmouseup=function(aEvent){
					document.onmousemove=null;
					document.onmouseup=null;
					var clone=document.getElementById("clone");
					if(!hitTest(dragWindow,getMouseX(aEvent),getMouseY(aEvent))){
						clone.onmousedown=null;
						clone.onmouseup=null;
						var windowHit=deskTop.hitFolder({x:clone.offsetLeft,y:clone.offsetTop});
						if(windowHit){
							windowHit.elements.push({url:clone.getAttribute("url"),icon:clone.getAttribute("icon"),name:clone.getAttribute("name"),elements:clone.elements});
						}else{
							var addedElement=addToDesktop(clone);
							if(addedElement){
								addedElement.style.top=clone.offsetTop+"px";
								addedElement.style.left=clone.offsetLeft+"px";
								try{clone.original.onrelease(addedElement);}catch(e){}
							}
						}
					}
					if(clone.original.style.display=="none"){
						
					}
					clone.parentNode.removeChild(clone);
				}
			}
		}
	}
}