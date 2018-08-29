function setList(div){
	div.elements=new Array();
	div.style.overflow="auto";
	div.selectedItems=new Array();
	
	div.onElementDoubleClicked=function(){}
	div.onItemSelected=function(){}
	
	div.addElement=function(el){
		var element=this.getRow(el);
		element.listContainer=this;
		div.multiSelected=(div.getAttribute("multiSelected")=="true");
		element.ondblclick=function(){
			this.listContainer.onElementDoubleClicked(this);
			/*viewBrowser.parent=this;
			if(this.text.innerHTML.charAt(this.text.innerHTML.length-1)!="/"){
				viewBrowser.path+=this.text.innerHTML+"/";
			}
			document.getElementById("path").value=viewBrowser.path;
			viewBrowser.updateContent();*/
		}
		element.onclick=function(evt){
			evt=getEventObject(evt);
			if(this.className=="selected"){
				this.listContainer.unSelectElement(this);
			}
			if((!evt.ctrlKey && this.listContainer.multiSelected) || !this.listContainer.multiSelected){
				this.listContainer.unSelectAll();
			}
			this.listContainer.selectElement(this);
		}
		this.elements.push(element);
		this.appendChild(element);
		return element;
	}
	
	div.selectElement=function(el){
		div.selectedItems.push(el);
		el.className="selected";
		this.onItemSelected(el);
	}
	
	div.unSelectElement=function(el){
		el.className="";
		for(var i=0;i<this.selectedItems.length;i++){
			if(this.selectedItems[i]==el){
				this.selectedItems.splice(i,1);
				break;
			}
		}
	}
	
	div.unSelectAll=function(){
		this.selectedItems=new Array();
		for(var i=0;i<this.elements.length;i++){
			this.elements[i].className="";
		}
	}
	
	div.clear=function(){
		div.selectedItems=new Array();
		div.elements=new Array();
		div.innerHTML="";
	}
	
	div.getRow=function(el){
		var element=document.createElement("DIV");
		element.style.position="static";
		element.style.padding="2px";
		element.innerHTML="<table cellpadding='0' cellspacing='0'><tr><td style='width:0px;'><div style='position:relative;height:20px;width:20px;'></div></td><td><div style='position:relative;margin-left:5px;font-family:Tahoma;font-size:12px;'>"+el.name+"</div></td></tr></table>";
		element.icon=element.getElementsByTagName("DIV")[0];
		element.text=element.getElementsByTagName("DIV")[1];
		makeUnselectable(element);
		element.setAttribute("name",el.name);
		element.style.cursor="default";
		/*if(el.elements!=null && el.elements.length>=0){
			element.icon.innerHTML="<img src='../images/jpivot/folder_icon.png'>";
			element.setAttribute("type","folder");
			element.id=el.id;
		}else{
			element.icon.innerHTML="<img src='../images/jpivot/view_icon.png'>";
			//element.setAttribute("mdx",el.mdx);
			element.id=el.id;
			element.setAttribute("type","view");
		}*/
		element.icon.innerHTML="<img src='"+el.icon+"'>";
		element.data=el;
		return element;
	}
	
	div.deleteElement=function(el){
		for(var i=0;i<this.elements.length;i++){
			if(el==this.elements[i]){
				this.elements[i].parentNode.removeChild(this.elements[i]);
				this.elements.splice(i,1);
			}
		}
	}
	
	div.containsName=function(name){
		var els=this.elements;
		for(var i=0;i<els.length;i++){
			if(name==els[i].data.name){
				return true;
			}
		}
		return false;
	}
	
}