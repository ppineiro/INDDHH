var uploadingViewer=null;
var imageBrowsers=new Array();
var imgToolTip=new Object();
function setImageBrowsers(divs){
	for(var i=0;i<divs.length;i++){
		setImageBrowser(divs[i]);
	}
	addListener(document,"mousemove",function(){imgToolTip.hide();imgToolTip.moved=true;});
}
function setImageBrowser(div){
	div.className="imageBrowser";
	div.innerHTML="<div></div>";
	div.content=div.getElementsByTagName("DIV")[0];
	div.elements=new Array();
	div.items=new Array();
	div.selectedItems=new Array();
	div.listUrl=div.getAttribute("listUrl");
	div.addUrl=div.getAttribute("addUrl");
	div.removeUrl=div.getAttribute("removeUrl");
	div.multiSelect=(div.getAttribute("multiSelect")=="true");
	div.nameField=(div.getAttribute("nameField")!="false");
	div.descriptionField=(div.getAttribute("descriptionField")!="false");
	div.resizeField=(div.getAttribute("resizeField")!="false");
	div.thumbImage=(div.getAttribute("imageToolTip")=="true");
	
	div.refresh=function(){
		this.elements=new Array();
		this.items=new Array();
		var xml=new xmlLoader();
		var temp=this;
		xml.temp = this;
		
		xml.onload=function(root){
			temp.clear();
			if(root){
				temp.parseXml(root);
			}
		}
		xml.load(this.listUrl);
	}
	div.addImage=function(image){
		this.elements.push(image);
		var item=image.getIconElement();
		if(this.thumbImage){
			item.image.onmouseover=function(evt){
				if(!imgToolTip.uploadModalOn){
					imgToolTip.show(evt);
				}
			}
		}
		item.container=this;
		this.content.appendChild(item);
		this.items.push(item);
		div.sortIcons();
	}
	div.remove=function(image){
		this.unSelectItem( ((image.icon)?image.icon:image) );
		for(var i=0;i<this.elements.length;i++){
			if(this.elements[i]==image || this.items[i]==image){
				if(image.icon){
					image.icon.removeMe();
				}else{
					image.removeMe();
				}
				this.elements.splice(i,1);
				this.items.splice(i,1);
			}
		}
		this.sortIcons();
	}
	div.removeSelected=function(){
		while(this.selectedItems.length>0){
			this.remove(this.selectedItems[0]);
			this.selectedItems.splice(0,1)
		}
	}
	div.clear=function(){
		while(this.items.length>0){
			this.remove(this.items[0]);
		}
		this.content.innerHTML="";
	}
	div.deleteSelected=function(){
		div.imagesToDelete=this.selectedItems.length;
		for(var u=0;u<this.selectedItems.length;u++){
			this.deleteImage(this.selectedItems[u]);
		}
	}
	div.afterDeletion=function(){
		this.imagesToDelete--;
		if(this.imagesToDelete==0){
			if(this.selectedItems.length>0){
				var imagesNotDeleted="";
				for(var i=0;i<this.selectedItems.length;i++){
					var image=this.selectedItems[i].getObject();
					imagesNotDeleted+=" "+image.name;
				}
				alert(MSG_COULD_NOT_DELETE+":"+imagesNotDeleted);
			}
			this.refresh();
		}
	}
	div.selectItem=function(item){
		if(!item.selected){
			this.selectedItems.push(item);
		}
	}
	div.unSelectItem=function(item){
		if(item.selected){
			for(var i=0;i<this.selectedItems.length;i++){
				if(this.selectedItems[i]==item || this.selectedItems[i]==item.icon){
					this.selectedItems.splice(i,1);
					break;
				}
			}
		}
	}
	div.isSelected=function(item){
		for(var i=0;i<this.selectedItems.length;i++){
			if(this.selectedItems[i]==item || this.selectedItems[i]==item.icon){
				return true;
			}
		}
	}
	div.unSelectAll=function(){
		while(this.selectedItems.length>0){
			this.selectedItems[0].unSelectMe();
		}
	}
	div.updateView=function(){
//		this.innerHTML
	}
	div.sortIcons=function(){
		if(this.items.length>0){
			var elements=this.items;
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
	div.parseXml=function(xml){
		if(xml.childNodes!=undefined){
			for(var i=0;i<xml.childNodes.length;i++){
				if(xml.childNodes[i] && xml.childNodes[i].tagName.toUpperCase()=="IMAGE"){
					var io=new imageObject();
					io.name=xml.childNodes[i].getAttribute("name");
					io.description=xml.childNodes[i].getAttribute("description");
					io.path=xml.childNodes[i].getAttribute("path");
					io.id=xml.childNodes[i].getAttribute("id");
					this.addImage(io);
				}
			}
			this.sortIcons();
		}
	}
	div.uploadImage=function(url,name,description){
		var uploadModal=document.createElement("DIV");
		uploadModal.style.position="absolute";
		uploadModal.style.height="185px";
		uploadModal.style.width="470px";
		uploadModal.style.top=((getStageHeight()-150)/2)+"px";
		uploadModal.style.left=((getStageWidth()-200)/2)+"px";
		uploadModal.id="uploadModal";
		document.body.appendChild(uploadModal);
		var iframe=document.createElement("IFRAME");
		iframe.borders="none";
		iframe.style.height="185px";
		iframe.style.width="470px";
		iframe.name="imageUploadModal";
		uploadModal.appendChild(iframe);
		var doc;
		if(iframe.contentDocument){
		      doc = iframe.contentDocument;
		}else if(iframe.contentWindow){
		      doc = iframe.contentWindow.document;
		}else if(iframe.document){
		      doc = iframe.document;
		}
		doc.open();
		doc.close();
	//	doc.contentType="text/html; charset="+APP_ENCODING;
		var body="<div class='modalTitle' style='padding:0 4px;height:21px;width:45" + (MSIE?"9":"5") + "px;'>"+LBL_ADDIMAGE+"</div>";
		body+="<form " + (MSIE?"style='margin-top:0px;'":"") +"content='text/html;' enctype='multipart/form-data' id='imageUpload' method='post' action='"+this.addUrl+"'>";
		body+="<div style='position:relative;margin:5px;width:455px;'>";
		body+="<table cellspacing=0 cellpadding=0>";
		if(this.nameField){
			body+="<tr><td style='width:90px;margin:5px'>"+LBL_NAME+"</td><td style='padding-top:5px'>";
			body+="<input id='name' maxlength=20 onkeyup=\"var inputs=document.body.getElementsByTagName('input');for(var i=0;i<inputs.length;i++){if(inputs[i].value==''){document.getElementById('uploadBtn').disabled=true;return false;} } document.getElementById('uploadBtn').disabled=false;\" name='imgName' id='imgName' value='"+name+"' />*</td></tr>";
		}
		if(this.descriptionField){
			body+="<tr><td style='width:90px;margin:5px'>"+LBL_DESCRIPTION+"</td><td style='padding-top:5px'>";
			body+="<input id='description'  maxlength=20 onkeyup=\"var inputs=document.body.getElementsByTagName('input');for(var i=0;i<inputs.length;i++){if(inputs[i].value==''){document.getElementById('uploadBtn').disabled=true;return false;} } document.getElementById('uploadBtn').disabled=false;\" name='imgDesc' value='"+description+"' />*</td></tr>";
		}
		if(this.resizeField){
			body+="<tr><td style='width:90px;margin:5px'>Resize</td><td style='padding-top:5px'>";
			body+="<input type='checkbox' id='resize' onchange=\"var inputs=document.body.getElementsByTagName('input');for(var i=0;i<inputs.length;i++){if(inputs[i].value==''){document.getElementById('uploadBtn').disabled=true;return false;} } document.getElementById('uploadBtn').disabled=false;\" name='resize' /></td></tr>";
		}
		body+="<tr><td style='width:90px;margin:5px'>"+LBL_FILE+"</td><td style='padding-top:5px'>";
		body+="<input class='button' id='file' onchange=\"var inputs=document.body.getElementsByTagName('input');for(var i=0;i<inputs.length;i++){if(inputs[i].value==''){document.getElementById('uploadBtn').disabled=true;return false;} } document.getElementById('uploadBtn').disabled=false;\" type='file' name='imageName' value='"+url+"' />";
		body+="*</td></tr></table>";
		body+="</div>";
		body+="<table style='" + (!CHROME?"margin-top:16px;":"") + "height:28px;width:46" + (MSIE?"0":"4") + "px;' cellspacing='0' cellpadding='0' class='buttonBar' width='100%'><tr><td width='50%'></td>";
		//body+="<td width='0px'><button type='button' disabled='true' id='uploadBtn' onclick='document.getElementById(\"imageUpload\").submit();'>"+LBL_CONFIRM+"</button></td>";
		//body+="<td width='0px'><button type='button' id='cancelBtn' onclick='window.parent.document.getElementById(\"uploadModal\").close()'>"+LBL_CANCEL+"</button></td></tr></table>";
		body+="<td width='50%' align='right'><button type='button' disabled='true' id='uploadBtn' onclick='document.getElementById(\"imageUpload\").submit();'>"+LBL_CONFIRM+"</button><button type='button' id='cancelBtn' onclick='window.parent.document.getElementById(\"uploadModal\").close()'>"+LBL_CANCEL+"</button></td></tr></table>"
		body+="</form>";
		doc.body.innerHTML=body;
		doc.body.cellSpacing="0px";
		doc.body.cellPadding="0px";
		var link=doc.createElement("link");
		link.setAttribute("rel", "stylesheet");
		link.setAttribute("type", "text/css");
		link.setAttribute("href", (rootPath+"/styles/"+GNR_CURR_STYLE+"/css/imageViewer.css"));
		link.setAttribute("title",name);
		doc.getElementsByTagName("HEAD")[0].appendChild(link);
		doc.body.className="modalBody";
		
		uploadModal.close=function(){
			imgToolTip.uploadModalOn=false;
			this.parentNode.removeChild(this);
		}
		uploadModal.setAttribute("scrolling","no");
		if (!MSIE){
			iframe.addEventListener('load', function(evt){
				var el=evt.currentTarget;
				if(el.loaded || CHROME) {
					try {
						uploadingViewer.onuploadready({element:uploadingViewer});
					} catch(e) {}
					el.parentNode.close();
				}else{
					el.loaded=true;
				}
			}
			, false);
		}else{
			var func=function(){
				var el=window.event.srcElement;
				if (el.readyState=="complete"){
					try{
						uploadingViewer.onuploadready({element:uploadingViewer});
					}catch(e){}
					el.parentNode.close();
				}
			}
			iframe.attachEvent("onreadystatechange", func);
		}
		uploadingViewer=this;
		imgToolTip.uploadModalOn=true;
		doc.getElementById("name").focus();
		//doc.getElementById("imageUpload").submit();
	}
	div.deleteImage=function(image){
		if(image.getObject){image=image.getObject();}
		var xml=new xmlLoader();
		var temp=this;
		xml.onload=function(root){
			if(root){
				if(root.nodeName!="ERROR"){
					temp.remove(image);
				}
			}else{
				temp.remove(image);
			}
			temp.afterDeletion();
		}
		xml.load(this.removeUrl+("&imgPath="+image.id));
		//sendVars(this.removeUrl,("imgPath="+image.id))
	}
	addListener(window,"resize",function(event){sortAllIcons();});
	div.onuploadready=function(){
		this.refresh();	
	}
	div.setWidth=function(width){
		this.style.width=width+"px";
		this.sortIcons();
	}
	
	addListener(div,"mousedown",clickUnselectAll);
	div.refresh();
	div.style.position="relative";
	div.style.overflow="auto";
	div.content.style.position="absolute";
	div.content.style.width="100%";
	if(div.nextSibling.className=="navBar"){
		div.nextSibling.style.width=div.offsetWidth+"px";
	}
	imageBrowsers.push(div);
	
}

function clickUnselectAll(event){
	event.element.unSelectAll();
}

function imageObject(){
	this.name="";
	this.path="";
	this.description="";
	this.id="";
	
	this.getIconElement=function(){
		var icon=document.createElement("DIV");
		this.icon=icon;
		icon.object=this;
		icon.container=null;
		var imgWidth=50;
		var imgHeight=50;
		icon.innerHTML="<table cellpading=0 cellspacing=0><tr><td width='0px'><div image='"+this.path+"' style='width:50px;height:50px;background-repeat:no-repeat;background-image:url("+this.path+")'></div></td><td><table cellpading=0 cellspacing=0 style='height:100%;top:0px;'><tr height='0px'><td><div></div></td><tr><td><div></div></td></tr></table></td></tr></table>"
		var divs=icon.getElementsByTagName("DIV");
		icon.image=divs[0];
		icon.name=divs[1];
		icon.detail=divs[2];
		icon.name.innerHTML=this.name;
		icon.detail.innerHTML=this.description;
		icon.className="imageViewIcon";
		icon.selected=false;
		icon.image.className="imageViewIconImage";
		icon.name.className="imageViewIconName";
		icon.detail.className="imageViewIconDetail";
		icon.getObject=function(){
			return icon.object;
		}
		icon.selectMe=function(){
			this.container.selectItem(this);
			this.style.backgroundColor="#D5FFBB";
			this.selected=true;
		}
		icon.unSelectMe=function(){
			this.container.unSelectItem(this);
			this.style.backgroundColor="";
			this.selected=false;
		}
		icon.removeMe=function(){
			addListener(this,"mousedown",this.mouseDown);
			this.parentNode.removeChild(this);
		}
		icon.mouseDown=function(event){
			var el=event.element;
			event.cancelBubble=true;
			if(event.button!=2 && el.container.selectedItems.length==0){
				if(!event.ctrlKey){
					if(el.container){
						el.selectMe();
					}
				}else if(el.selected){
					el.unSelectMe();
					return true;
				}else if(el.container){
					el.container.unSelectAll();
					el.selectMe();
				}
			}else if(!event.ctrlKey){
				el.container.unSelectAll();
				el.selectMe();
			}else if(event.ctrlKey && el.container.multiSelect){
				if(el.selected){
					el.unSelectMe();
				}else{
					el.selectMe();
				}
			}
		}
		addListener(icon,"mousedown",icon.mouseDown);
		return icon;
	}
}

imgToolTip.show=function(evt){
	evt=getEventObject(evt);
	var img=getEventSource(evt);
	this.x=getMouseX(evt);
	this.y=getMouseY(evt);
	this.clone=img.cloneNode(true);
	this.caller=img;
	this.moved=false;
	img.onmouseout=function(evt){
		if(!this.hitTestMe(evt)){
			imgToolTip.hide();
			img.onmousemove=null;
			img.onmousemout=null;
		}
	}
	img.onmousemove=function(evt){
		if(!this.hitTestMe(evt)){
			imgToolTip.moved=true;
		}
	}
	img.hitTestMe=function(evt){
		var x=getMouseX(evt);
		var y=getMouseY(evt);
		var pos=getAbsolutePosition(this);
		if(x>pos.x && x<(pos.x+this.offsetWidth) && y>pos.y && y<(pos.y+this.offsetHeight)){
			return true;
		}
		return false;
	}
	setTimeout(function(){imgToolTip.appear();},500);
}

imgToolTip.restart=function(evt){
	evt=getEventObject(evt);
	var img=getEventSource(evt);
	imgToolTip.x=getMouseX(evt);
	imgToolTip.y=getMouseY(evt);
	imgToolTip.hide();
	imgToolTip.show(this.caller);
}

imgToolTip.appear=function(){
	if(!this.moved){
		while(document.getElementById("imgToolTip")){
			return false;
		}
		var toolTip=document.createElement("DIV");
		toolTip.id="imgToolTip";
		toolTip.style.position="absolute";
		toolTip.style.visibility="hidden";
		var abs=getAbsolutePosition(this.caller);
		toolTip.style.top=(abs.y)+"px";
		toolTip.style.left=(abs.x)+"px";
		document.body.appendChild(toolTip);
		toolTip.innerHTML="<img src='"+this.clone.getAttribute("image")+"' />"
		var img=toolTip.getElementsByTagName("IMG")[0];
		img.style.height=( (img.offsetHeight*150)/img.offsetWidth )+"px";
		img.style.width="150px";
		toolTip.style.visibility="visible";
		this.clone.onmousemove=function(){imgToolTip.hide;}
	}else{
		imgToolTip.moved=false;
		setTimeout(function(){imgToolTip.appear();},500);
	}
}

imgToolTip.hide=function(){
	while(document.getElementById("imgToolTip")){
		document.getElementById("imgToolTip").parentNode.removeChild(document.getElementById("imgToolTip"));
	}
}

function sortAllIcons(){
	for(var i=0;i<imageBrowsers.length;i++){
		imageBrowsers[i].sortIcons();
	}
}

function sizeImageViews(width){
	for(var i=0;i<imageBrowsers.length;i++){
		imageBrowsers[i].setWidth(width-22);
		var navBar=imageBrowsers[i].nextSibling;
		if(!MSIE){
			try{
				if( navBar!=undefined && navBar!=null){
					while(navBar.tagName!="TABLE" && navBar!=undefined && navBar!=null){
						navBar=navBar.nextSibling;
					}
				}
			}catch(e){}
		}
		if(navBar!=null && navBar!=undefined && navBar.className=="navBar" && (width-20)>0){
			navBar.style.width=(width-20)+"px";
		}
	}
}

/*if (document.addEventListener) {
    document.addEventListener("DOMContentLoaded", setImageBrowsers, false);
}else{
	setImageBrowsers();
}*/
