

function setGrid(div){
	div.innerHTML="";
	div.win.elements=[];
	div.className="windowGrid";
	div.innerHTML="<div class='gridHeader'></div><div class='gridBody'></div>";
	div.header=div.firstChild;
	div.body=div.lastChild;
	
	
	var table=document.createElement("TABLE");
	table.style.width="100%";
	table.setAttribute("cellspacing",0);
	table.setAttribute("cellpadding",0);
	var tbody=document.createElement("TBODY");
	div.body.appendChild(table);
	table.appendChild(tbody);
	div.tbody=div.body.getElementsByTagName("TBODY")[0];
	
	div.body.onscroll=function(){
		div.header.scrollLeft=div.body.scrollLeft;
	}
	
	div.dataSource=null;
	
	div.setDataColumns=function(cols){
		var tableHead="<table cellpadding='0' cellspacing='0' width='100%'><thead><tr>";
		for(var i=0;i<cols.length;i++){
			var th="<th style='width:"+(cols[i].width?cols[i].width:130+"px")+"'><div style='width:"+(cols[i].width?cols[i].width:130+"px")+"'>"+cols[i].text+"</div></th>";
			tableHead+=th;
		}
		tableHead+="</tr></thead></table>";
		div.header.innerHTML=tableHead;
		var headers=div.getHeaders();
		for(var i=0;i<headers.length;i++){
			headers[i].name=cols[i].name;
			headers[i].text=cols[i].text;
			headers[i].width=cols[i].width?cols[i].width:130+"px";
			headers[i].rows=new Array();
			headers[i].setWidth=function(width){
				this.style.width=width;
				for(var i=0;i<this.rows.length;i++){
					this.rows[i].style.width=width;
				}
			}
		}
	}
	
	div.setDataSource=function(data){
		this.dataSource=data;
		this.refreshView();
	}
	
	div.refreshView=function(){
		var data=this.dataSource;
		var headers=div.getHeaders();
		for(var j=0;j<data.length;j++){
			this.addElement(data[j]);
		}
		this.sizeMe();
	}
	
	div.getHeaders=function(){
		return this.header.getElementsByTagName("DIV");
	}
	
	div.sizeMe=function(){
		this.body.style.height=((this.offsetHeight-this.header.offsetHeight)-3)+"px";
		if(this.body.offsetHeight<this.body.scrollHeight){
			this.header.style.width=(this.body.offsetWidth-20)+"px";
		}else{
			this.header.style.width="100%";
		}
	}
	
	
	
	div.getIconElement=function(el){
		var headers=this.getHeaders();
		var tr=document.createElement("TR");
		
		if(el.data){
		var row=el.data;
			for(var i=0;i<headers.length;i++){
				var td=document.createElement("TD");
				td.style.width=headers[i].width;
				td.innerHTML="<div style='width:"+headers[i].width+"'>"+row[headers[i].name]+"</div>";
				tr.appendChild(td);
				headers[i].rows.push(td.firstChild);
			}
		}else{
			var td=document.createElement("TD");
			td.innerHTML="<div style='width:"+headers[0].width+"'>"+el.name+"</div>";
			tr.appendChild(td);
			headers[0].rows.push(td.firstChild);
		}
		
		tr.setAttribute("url",el.url);
		tr.setAttribute("icon",el.icon);
		tr.setAttribute("name",el.name.toUpperCase());
		tr.setAttribute("text",el.name.toUpperCase());
		tr.name=el.name;
		tr.tooltip=el.name;
		tr.url=el.url;
		tr.elements=el.elements;
		
		tr.getObject=function(){
			return el;
		}
		makeUnselectable(tr);
		
		tr.ondblclick=function(){
			this.title=this.getObject().name;
			this.openWindow();
		}
		tr.openWindow=function(){
			if(this.getObject().elementWindow && this.getObject().elementWindow.ownerIcon ){
				this.getObject().elementWindow.bringToTop();
				return;
			}
			this.getObject().elementWindow=openElementWindow(this);
			this.getObject().elementWindow.ownerIcon=this;
			return this.getObject().elementWindow;
		}
		
		return tr;
	}
	
	div.clear=function(){
		//this.tbody.innerHTML="";
		while(this.tbody.rows.length>0){
			this.tbody.removeChild(this.tbody.rows[0]);
		}
	}
	
	
	div.addElement=function(el){
		if(this.getHeaders().length==0){
			var cols=[];
			if(el.data){
				var data=el.data;
				for(var i in data){
					cols.push({name:i,text:i, value:el[i]})
				}
				this.setDataColumns(cols);
			}else{
				cols.push({name:"name",text:"name",width:"100%"})
				this.setDataColumns(cols);
			}
		}
		//var anElement=el.getIconElement();
		var anElement=this.getIconElement(el);//.tbody
		anElement.id=(this.win.id+"_"+this.win.nextElement);
		anElement.win=this.win;
		anElement.remove=function(){
			this.win.objectData.removeElement(this.getObject());
		}
		this.nextElement++;
		var dist=100;
		var cantPorCol=Math.floor(this.clientWidth/dist);
		var aCol=Math.floor(this.win.elements.length/cantPorCol);
		this.win.elements.push(anElement);
		this.tbody.appendChild(anElement);
		anElement.menu=[{text:lblDeleteElement,calledFunction:"caller.parentNode.caller.win.objectData.removeElement(caller.parentNode.caller.getObject());"}];
		if(anElement.getObject().type=="folder"){
			anElement.menu.push({ text:lblChangeName, calledFunction:"caller.parentNode.caller.changeName()" });
		}
		setWindowElementMenu(anElement);
		var tmp=this;
		anElement.onmousedown=function(aEvent){
			tmp.unselectAll();
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
				clone.dragWindow=tmp.win;
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
					doDrop(aEvent);
				}
			}
			this.className="selected";
		}
		return anElement;
	}
	
	
	div.unselectAll=function(){
		var els=this.win.elements;
		for(var i=0;i<els.length;i++){
			els[i].className="";
		}
	}
	
	
}

