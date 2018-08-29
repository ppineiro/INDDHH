function setIconView(div){
	div.innerHTML="";
	div.win.elements=[];
	div.addElement=function(el){
		var anElement=el.getIconElement();
		anElement.id=(this.win.id+"_"+this.win.nextElement);
		anElement.win=this.win;
		anElement.remove=function(){
			this.win.objectData.removeElement(this.getObject());
		}
		this.nextElement++;
		var dist=100;
		var cantPorCol=Math.floor(this.clientWidth/dist);
		var aCol=Math.floor(this.win.elements.length/cantPorCol);
		anElement.style.position="absolute";
		anElement.style.top=(Math.floor(aCol*dist))+"px";
		anElement.style.left=(Math.floor((this.win.elements.length%cantPorCol)*dist))+"px";
		this.win.elements.push(anElement);
		this.appendChild(anElement);
		anElement.menu=[{text:lblDeleteElement,calledFunction:"caller.parentNode.caller.win.objectData.removeElement(caller.parentNode.caller.getObject());"}];
		if(anElement.getObject().type=="folder"){
			anElement.menu.push({ text:lblChangeName, calledFunction:"caller.parentNode.caller.changeName()" });
		}
		setWindowElementMenu(anElement);
		anElement.onmousedown=function(aEvent){
			if(this.win.selectedElement){
				this.win.selectedElement.style.backgroundImage="";
			}
			this.style.backgroundImage="url(styles/"+currStyle+"/images/selectedBack.png)";
			this.win.selectedElement=this;
			aEvent=getEventObject(aEvent);
			if(aEvent.button==2){
				/*aEvent.cancelBubble=true;
				document.oncontextmenu=function(){
					return false;
				}*/
			}else{
				//var clone=this.cloneNode(true);
				var clone=Object.clone(this.getObject()).getIconElement();
				clone.id="clone";
				clone.style.zIndex=99999999;
				clone.style.left=getMouseX(aEvent);
				clone.style.top=getMouseY(aEvent);
				clone.style.display="none";
				clone.original=this;
				document.body.appendChild(clone);
				aEvent=getEventObject(aEvent);
				cancelBubble(aEvent);
				clone.dragWindow=this.win;
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
					if(aEvent.ctrlKey){
						clone.original.style.display="block";
					}else{
						clone.original.style.display="none";
					}
				}
				document.onmouseup=function(aEvent){
					doDrop(aEvent);
				}
			}
		}
		return anElement;
	}
	
	div.sizeMe=function(){
		if(this.win.elements.length>0){
			var elements=this.win.elements;
			var elementWidth=elements[0].clientWidth;
			var elementHeight=elements[0].clientHeight;
			var contentWidth=this.offsetWidth;
			cantPerLine=Math.floor(contentWidth/elementWidth);
			for(var i=0;i<elements.length;i++){
				var position=i;
				var y=0;
				while(position>=cantPerLine){
					position-=cantPerLine;
					y++;
				}
				elements[i].style.left=((position*elementWidth))+"px";
				elements[i].style.top=((y*elementHeight))+"px";
			}
		}
	}
	
	div.setDataSource=function(els){
		for(var i=0;i<els.length;i++){
			this.addElement(els[i]);
		}
	}
	
	div.clear=function(){
		this.innerHTML="";
	}

}