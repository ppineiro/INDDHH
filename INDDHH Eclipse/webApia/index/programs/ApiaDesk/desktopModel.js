// JavaScript Document
function folder(atts){
	this.elements=new Array();
	this.name;
	this.url;
	this.icon;
	this.toolTip;
	this.iconElement;
	this.elementWindow;
	this.atts;
	this.id;
	this.type="folder";
	this.windowId=null;
	if(atts){
		this.name=atts.name;
		this.url=atts.url;
		this.icon=atts.icon;
		this.toolTip=atts.toolTip;
		this.elements=atts.elements;
		this.atts=atts.atts;
		this.windowId=atts.windowId;
	}
	this.getIconElement=function(id){
		var icon=document.createElement("DIV");
		icon.style.width="100px";
		icon.style.height="100px";
		icon.style.position="absolute";
		icon.id=id;
		icon.elements=this.elements;
		if(element.droppable=="true"){
			icon.className="droppable";
		}
		icon.setAttribute("url",this.url);
		icon.setAttribute("icon",this.icon);
		icon.setAttribute("name",this.name.toUpperCase());
		icon.setAttribute("text",this.name.toUpperCase());
		icon.name=this.name;
		icon.tooltip=this.name;
		icon.url=this.url;
		icon.elements=this.elements;
		icon.ondblclick=function(){
			this.openWindow();
		}
		icon.openWindow=function(){
			if(this.object.elementWindow && this.object.elementWindow.ownerIcon ){
				if(!this.object.elementWindow.minimized){
					this.object.elementWindow.bringToTop();
				}else{
					this.object.elementWindow.minimize();
				}
				return;
			}
			this.object.elementWindow=openElementWindow(this);
			this.object.elementWindow.ownerIcon=this;
			return this.object.elementWindow;
		}
		//icon.innerHTML='<img style="position:absolute;left:25px;top:10px;width:50px;height:50px; " src="'+element.icon+'"><div style="position:absolute;width:100px;height:40px;left:0px;top:60px;font-family:tahoma;font-size:10px;" align="center">'+element.name.toUpperCase();+'</div>';
		icon.object=this;
		icon.innerHTML='<div style="position:absolute;left:25px;top:10px;width:50px;height:50px;background-image:url('+this.icon+');"></div><div style="position:absolute;width:100px;height:40px;left:0px;top:60px;font-family:tahoma;font-size:10px;cursor:pointer;cursor:default;overflow:hidden" align="center">'+this.name.toUpperCase();+'</div>';
		makeUnselectable(icon.childNodes[0]);
		makeUnselectable(icon.childNodes[1]);
		icon.getObject=function(){
			//return {url:this.url,name:this.name,url:this.url,tooltip:this.tooltip,icon:this.icon,elements:this.elements};
			return this.object;
		}
		icon.removeMe=function(){
			this.parentNode.removeChild(icon);
		}
		this.iconElement=icon;
		return icon;
	}
	
	this.addElement=function(obj){
		if(this.contains(obj)==null){
			this.elements.push(obj);
			if(this.elementWindow){
				this.elementWindow.update();
			}
			return obj;
		}
		return null;
	}
	this.removeElement=function(obj){
		var hasElement=this.contains(obj)
		if(hasElement){
			for(var i=0;i<this.elements.length;i++){
				if(hasElement.equals(this.elements[i])){
					if(hasElement.elementWindow){
						hasElement.elementWindow.close();
					}
					try{this.elements[i].clear();}catch(e){}
					this.elements.splice(i,1);
				}
			}
			if(this.elementWindow){
				this.elementWindow.update();
			}
			return true;
		}
		return false;
	}
	this.contains=function(obj){
		for(var i=0;i<this.elements.length;i++){
			var obj2=this.elements[i];
			if(obj2.equals(obj)){
				return obj2;
			}
		}
		return null;
	}
	this.equals=function(obj){
		if(this.name==obj.name && this.url==obj.url && this.icon==obj.icon && this.type==obj.type){
			return true;
		}
		return false;
	}
	this.clear=function(){
		for(var i=0;i<this.elements.length;i++){
			try{this.elements[i].clear();}catch(e){}
			if(this.elements[i].elementWindow){
				this.elements[i].elementWindow.close();
			}
		}
		this.elements=new Array();
	}
}

function element(atts){
	this.name;
	this.url;
	this.icon;
	this.toolTip;
	this.iconElement;
	this.elementWindow;
	this.atts;
	this.id;
	this.data=null;
	this.type="element";
	this.windowId=null;
	if(atts){
		this.name=atts.name;
		this.url=atts.url;
		this.icon=atts.icon;
		this.toolTip=atts.toolTip;
		this.atts=atts.atts;
		this.dblClickDo=atts.dblClickDo;
		this.windowId=atts.windowId;
	}
	this.getIconElement=function(id){
		var icon=document.createElement("DIV");
		icon.style.width="100px";
		icon.style.height="100px";
		icon.style.position="absolute";
		icon.id=id;
		if(element.droppable=="true"){
			icon.className="droppable";
		}
		icon.setAttribute("url",this.url);
		icon.setAttribute("icon",this.icon);
		icon.setAttribute("name",this.name.toUpperCase());
		icon.setAttribute("text",this.name.toUpperCase());
		icon.name=this.name;
		icon.tooltip=this.name;
		icon.url=this.url;
		if(!this.dblClickDo){
			icon.ondblclick=function(){
				this.openWindow();
			}
		}else{
			icon.dblClickDo=this.dblClickDo;
			icon.ondblclick=function(){
				this.dblClickDo(this);
			}
		}
		icon.openWindow=function(){
			if(this.object.elementWindow && this.object.elementWindow.ownerIcon ){
				if(!this.object.elementWindow.minimized){
					this.object.elementWindow.bringToTop();
				}else{
					this.object.elementWindow.minimize();
				}
				return;
			}
			this.object.elementWindow=openElementWindow(this);
			this.object.elementWindow.ownerIcon=this;
			return this.object.elementWindow;
		}
		//icon.innerHTML='<img style="position:absolute;left:25px;top:10px;width:50px;height:50px; " src="'+element.icon+'"><div style="position:absolute;width:100px;height:40px;left:0px;top:60px;font-family:tahoma;font-size:10px;" align="center">'+element.name.toUpperCase();+'</div>';
		icon.object=this;
		icon.innerHTML='<div style="position:absolute;left:25px;top:10px;width:50px;height:50px;background-image:url('+this.icon+');"></div><div style="position:absolute;width:100px;height:40px;left:0px;top:60px;font-family:tahoma;font-size:10px;cursor:pointer;cursor:default;overflow:hidden" align="center">'+this.name.toUpperCase();+'</div>';
		makeUnselectable(icon.childNodes[0]);
		makeUnselectable(icon.childNodes[1]);
		icon.getObject=function(){
			//return {url:this.url,name:this.name,url:this.url,tooltip:this.tooltip,icon:this.icon};
			return this.object;
		}
		this.iconElement=icon;
		return icon;
	}
	this.equals=function(obj){
		if(this.name==obj.name && this.url==obj.url && this.icon==obj.icon && this.type==obj.type){
			return true;
		}
		return false;
	}
}

/*function element(atts){
	if(atts.elements){
		return new Folder(atts);
	}else{
		return new Element(atts);
	}
}*/