// JavaScript Document
var postIts=new Array();
var deskTop;
function setDeskTop(){
	deskTop=document.createElement("div");
	deskTop.id="deskTop";
	iconArea.appendChild(deskTop);
	//document.body.appendChild(deskTop);
	deskTop.elements=new Array();
	deskTop.nextElement=0;
	deskTop.style.width=getStageWidth()+"px";
	deskTop.style.height=(getStageHeight()-30)+"px";
	backArea.style.width=getStageWidth()+"px";
	backArea.style.height=(getStageHeight()-30)+"px";
	backArea.style.top="0px";
	backArea.style.left="0px";
	deskTop.style.top="0px";
	deskTop.style.left="0px";
	deskTop.style.overflow="hidden";
	deskTop.maxDepth=100;
	deskTop.arrange=function(by){
		this.sortIcons(by);
		for(var i=0;i<this.elements.length;i++){
			var element=this.elements[i];
			var dist=100;
			var cantPorFila=Math.floor(this.clientHeight/dist);
			var aFila=Math.floor(i/cantPorFila);
			element.style.left=(Math.floor(aFila*dist))+"px";
			element.style.top=(Math.floor((i%cantPorFila)*dist))+"px";
		}
	}
	deskTop.sortIcons=function(by){
		var strFnc="  if ( x.getAttribute('"+by+"').toLowerCase() < y.getAttribute('"+by+"').toLowerCase() ) {return -1; } if ( x.getAttribute('"+by+"').toLowerCase() > y.getAttribute('"+by+"').toLowerCase() ) {return 1; } return 0; ";
		var orden=new Function("x","y",strFnc);
		this.elements.sort(orden);
		var sortArray=new Array();
		for(var i=0;i<this.elements.length;i++){
			sortArray.push(this.elements[i].getAttribute(by));
		}
	}
	deskTop.selectedItems=new Array();
	deskTop.selectElement=function(element){
		//element.style.backgroundImage="url(selectedBack.png)";element.style.border="1px solid #85D8FB";
		this.selectedItems.push(element);
	}
	deskTop.unSelectElement=function(element){
		for(var i=0;i<this.selectedItems.length;i++){
			if(this.selectedItems[i]==element){
				//element.style.backgroundImage="";element.style.border="";
				//element.unselectMe();
				this.selectedItems.splice(i,1);
			}
		}
	}
	deskTop.unSelectAll=function(){
		while(this.selectedItems.length>0){
			this.selectedItems[0].unselectMe();
			//this.selectedItems.splice(0,1);
		}
	}
	deskTop.removeSelected=function(){
		while(this.selectedItems.length>0){
			var el=this.selectedItems[0];
			el.remove();
		}
	}
	deskTop.createFolder=function(caller){
		var y=caller.parentNode.offsetTop;
		var x=caller.parentNode.offsetLeft;
		//var icon=getIconElement({icon:"folder_icon.png",name:"",url:"",elements:new Array()});
		var aux=new folder({icon:"styles/"+currStyle+"/images/folder_icon.png",name:"",url:"",elements:new Array()});
		var icon=aux.getIconElement();
		icon.changeName=function(){
			startNameWriter(this);
		}
		this.addElement(icon);
		icon.doDrop=function(el){
			this.getObject().addElement( Object.clone(el.getObject()) );
			try{el.unselectMe();}catch(e){}
			el.remove();
		}
		Droppables.add(icon, {accept:'trashable',hoverclass:'opacity50',onDrop:function(draggable,droppable){ 
																				droppable.doDrop(draggable);
																				deskTop.dropSelected(droppable); } } );
		startNameWriter(icon);
	}
	deskTop.addElement=function(el){
		if(this.containsElement(el)){return null;}
		el.tooltip=getToolTipText(el);
		addToolTip(el);
		setDesktopElementMenu(el);
		var dist=100;
		var cantPorFila=Math.floor(deskTop.clientHeight/dist);
		var aFila=Math.floor(deskTop.elements.length/cantPorFila);
		/*if((deskTop.elements.length%cantPorFila)==0 && (deskTop.elements.length>0)){
			aFila++;
		}*/
		el.style.left=(Math.floor(aFila*dist))+"px";
		el.style.top=(Math.floor((deskTop.elements.length%cantPorFila)*dist))+"px";
		el.style.zIndex=this.maxDepth;
		makeUnselectable(el);
		el.className="trashable";
		this.maxDepth++;
		el.id="desktopElement"+this.nextElement;
		el.bringToTop=function(){
			this.style.zIndex=deskTop.maxDepth;
			insideStage(this);
			deskTop.maxDepth++;
		}
		el.remove=function(){
			deskTop.remove(this);
		}
		el.selectMe=function(){
			if(!this.selected){
				this.selected=true;
				this.style.backgroundImage="url(styles/"+currStyle+"/images/selectedBack.png)";//this.style.border="1px solid #85D8FB";
				deskTop.selectElement(this);
			}
		}
		el.unselectMe=function(){
			this.selected=false;
			this.style.backgroundImage="";//this.style.border="";
			deskTop.unSelectElement(this);
		}
		deskTop.appendChild(el);
		deskTop.elements.push(el);
		this.nextElement++;
		addListener(el,"mousedown",function(event){
			event.element;
			if(event.button!=2 && deskTop.selectedItems.length==0){
				if(!event.ctrlKey){
					deskTop.unSelectAll();
				}else if(event.element.selected){
					event.element.unselectMe();
					return true;
				}
				event.element.selectMe();
			}else if(!event.ctrlKey && !event.element.selected){
				deskTop.unSelectAll();
				event.element.selectMe();
			}
		});
		addListener(el,"mouseup",function(event){
			event.element;
			if(event.button!=2){
				if(event.ctrlKey && deskTop.selectedItems.length>0){
					event.element.selectMe();
				}
			}
		});
		new Draggable(el.id, {revert:false,endeffect:function(e){e.bringToTop();},starteffect:function(e){deskTop.startMultiDrag(e);},change:function(e){deskTop.multiDrag(e.element)} });
		if(el.elements && el.elements.length>0){
			Droppables.add(el, {accept:'trashable',hoverclass:'opacity50',onDrop:function(draggable,droppable){ 
																				droppable.getObject().addElement( Object.clone(draggable.getObject()) );
																				draggable.remove(); },onStart:function(){setDragDiv();},onEnd:function(){unSetDragDiv();} } );
		}
		return el;
	}
	
	deskTop.startMultiDrag=function(el){
		for(var i=0;i<this.selectedItems.length;i++){
			//if(this.selectedItems[i]!=el){
				this.selectedItems[i].startX=this.selectedItems[i].offsetLeft;
				this.selectedItems[i].startY=this.selectedItems[i].offsetTop;
			//}
		}
	}
	
	deskTop.multiDrag=function(el){
		var xDif=el.offsetLeft-el.startX;
		var yDif=el.offsetTop-el.startY;
		for(var i=0;i<this.selectedItems.length;i++){
			if(this.selectedItems[i]!=el){
				this.selectedItems[i].style.left=(this.selectedItems[i].startX+xDif)+"px";
				this.selectedItems[i].style.top=(this.selectedItems[i].startY+yDif)+"px";
			}
		}
	}
	
	deskTop.stopMultiDrag=function(el){
		for(var i=0;i<this.selectedItems.length;i++){
			if(this.selectedItems[i]!=el){
				this.selectedItems[i].startX=null;
				this.selectedItems[i].startY=null;
			}
		}
	}
	
	deskTop.remove=function(el){
		try{el.unselectMe()}catch(e){}
		for(var i=0;i<deskTop.elements.length;i++){
			if(deskTop.elements[i]==el){
				if(el.getObject().elementWindow && el.getObject().elementWindow.parentNode){
					//el.getObject().clear();
					el.getObject().elementWindow.close();
				}
				deskTop.elements.splice(i,1);
			}
		}
		deskTop.removeChild(el);
		this.nextElement--;
	}
	deskTop.containsElement=function(element){
		for(var i=0;i<this.elements.length;i++){
			if(element.getAttribute("url")==this.elements[i].getAttribute("url") &&
			element.getAttribute("icon")==this.elements[i].getAttribute("icon") && 
			element.getAttribute("name")==this.elements[i].getAttribute("name")){
				return true;
			}
		}
	}
	deskTop.hitElement=function(o){
		var x=o.x;
		var y=o.y;
		var desktopElements=this.childNodes;
		var zIndex=0;
		var toReturn=null;
		for(var e=0;e<desktopElements.length;e++){
			if(hitTest(desktopElements[e],o)){
				if(desktopElements[e].id=="widgetArea" && zIndex<desktopElements[e].style.zIndex){
					if(hitTest(calendarWidget,o)){
						toReturn=calendarWidget;
						zIndex=desktopElements[e].style.zIndex;
					}
				}
				if(desktopElements[e].getObject && desktopElements[e].getObject().type=="folder" && zIndex<desktopElements[e].style.zIndex){
					toReturn=desktopElements[e];
					zIndex=desktopElements[e].style.zIndex;
				}
				if(desktopElements[e].objectData && desktopElements[e].objectData.type=="folder" && !desktopElements[e].list && zIndex<desktopElements[e].style.zIndex){
					toReturn=desktopElements[e];
					zIndex=desktopElements[e].style.zIndex;
				}
				if(desktopElements[e].id=="bin" && zIndex<desktopElements[e].style.zIndex){
					toReturn=desktopElements[e];
					zIndex=desktopElements[e].style.zIndex;
				}
				if(o.dragWindow && o.dragWindow.list && desktopElements[e].id!=o.dragWindow.list.type && zIndex<desktopElements[e].style.zIndex){
					toReturn=desktopElements[e];
					zIndex=desktopElements[e].style.zIndex;
				}
				if(desktopElements[e].list && zIndex<desktopElements[e].style.zIndex && 
				(!dragWindow.list || (desktopElements[e].id!=o.dragWindow.list.type) ) ){
					toReturn=desktopElements[e];
					zIndex=desktopElements[e].style.zIndex;
				}
			}
		}
		return toReturn;
	}
	deskTop.doDrop=function(dropped){
		try{dropped.unselectMe()}catch(e){}
		var windowHit=deskTop.hitElement(dropped);
		var addedElement;
		if(windowHit && windowHit.objectData && windowHit.objectData.type=="folder"){
			if(windowHit && !dropped.dragWindow){
				if(dropped.getObject){dropped=dropped.getObject();}
				addedElement=windowHit.objectData.addElement(dropped);
			}else if(windowHit && dropped.dragWindow && dropped.dragWindow.id!=windowHit.id){
				addedElement=windowHit.doDrop(dropped);
			}
		}else if(windowHit!=null && windowHit.object && windowHit.object.type=="folder"){
			addedElement=windowHit.object.addElement(dropped.object);
		}else if(windowHit!=null && windowHit.id=="bin"){
			addedElement=windowHit.doDrop(dropped);
		}else if(windowHit!=null && (windowHit.id=="myTasks" || windowHit.id=="freeTasks")){
			addedElement=windowHit.doDrop(dropped);
		}else if(windowHit==calendarWidget){
			addedElement=windowHit.doDrop(dropped);
		}else{
			var aux=Object.clone(dropped.getObject());
			addedElement=addToDesktop(aux.getIconElement());
			if(addedElement){
				var pos=getAbsolutePosition(dropped);
				addedElement.style.top=pos.y+"px";
				addedElement.style.left=pos.x+"px";
			}
		}
		if(dropped.original && dropped.original.onrelease && addedElement){
			dropped.original.onrelease(addedElement);
		}
		//deskTop.dropSelected(windowHit);
	}
	
	deskTop.dropSelected=function(where){
		if(where && where.doDrop){
			while(this.selectedItems.length>0){
				var item=this.selectedItems[0];
				try{item.unselectMe();}catch(e){}
				addedElement=where.doDrop(item);
			}
			deskTop.unSelectAll();
		}
	}
	
	deskTop.notifications=new Array();
	
	deskTop.notify=function(msg){
		/*var advice=document.getElementById("messengerAdvice");
		if(!advice){*/
			advise=document.createElement("DIV");
			advise.id="messengerAdvise_"+this.notifications.length;
			advise.style.display="none";
			document.body.appendChild(advise);
			advise.className="messengerAdvice";
		//}
		advise.style.position="absolute";
		advise.style.height="40px";
		advise.style.width="250px";
		advise.style.top=( (getStageHeight()-70)-( this.notifications.length*40 ) )+"px";
		advise.style.left=(getStageWidth()-250)+"px";
		advise.style.zIndex="100";
		advise.align="center";
		advise.innerHTML="<div class='opacity50' style='background-color:#555555;width:250px;height:40px;position:relative:top:0px;'></div><div style='width:250px;height:40px;position:absolute;top:0px;left:0px;'>"+msg+"</div>";
		Effect.Grow(advise, {duration:1,afterFinish:function(){  } });
		addListener(advise,"click",function(e){
			e=getEventObject(e);
			var ad=getEventSource(e);
			if(ad.id==""){
				ad=ad.parentNode;
			}
			setTimeout("deskTop.closeNotification('"+ad.id+"');",50);
		});
		advise.closeIn=function(time){
			setTimeout("deskTop.closeNotification('"+this.id+"');",time);
		}
		this.notifications.push(advise);
		return advise;
	}
	
	deskTop.closeNotification=function(id){
		Effect.Shrink(id,{afterFinish:function(){
										for(var i=0;i<deskTop.notifications.length;i++){
												if(deskTop.notifications[i].id==id){
													deskTop.notifications[i].parentNode.removeChild(deskTop.notifications[i]);
													deskTop.notifications.splice(i,1);
												}
											}
										}
		});
	}
	
	deskTop.size=function(){
		deskTop.style.width=getStageWidth()+"px";
		deskTop.style.height=(getStageHeight()-30)+"px";
		backArea.style.width=getStageWidth()+"px";
		backArea.style.height=(getStageHeight()-30)+"px";
		
		backArea.firstChild.style.width=(getStageWidth()+40)+"px";
		backArea.firstChild.style.height=(getStageHeight()+90)+"px";
	}
	
	//Droppables.add(deskTop, {accept:'droppable', onDrop:function(element){element.onclick=function(){this.onclick=this.onclickAux; }; deskTop.addElement(getIconElement({text:element.getAttribute("text"),name:element.getAttribute("name"),url:element.getAttribute("url"),icon:element.getAttribute("icon")  })); } })
	Droppables.add(deskTop, {accept:'droppable', onDrop:function(elementDropped){
																elementDropped.onclick=function(){
																	this.onclick=this.onclickAux;
																}; 
																var aux;
																var atts;
																if(elementDropped.getObject){
																	atts=({text:elementDropped.getAttribute("text"),name:elementDropped.getAttribute("name"),url:elementDropped.getAttribute("url"),icon:elementDropped.getAttribute("icon"),elements:elementDropped.getObject().elements  })
																}else{
																	atts=({text:elementDropped.getAttribute("text"),name:elementDropped.getAttribute("name"),url:elementDropped.getAttribute("url"),icon:elementDropped.getAttribute("icon"),elements:null,atts:{fncId:elementDropped.getAttribute("fncId")} })
																}
																if(atts.elements){
																	aux=new folder(atts);
																}else{
																	aux=new element(atts);
																}
																//deskTop.addElement( aux.getIconElement() );
																elementDropped.object=aux;
																elementDropped.getObject=function(){return this.object;}
																//var icon=aux.getIconElement();
																var pos=getAbsolutePosition(elementDropped);
																if(menuItems.hitTest(pos)){
																	return false;
																}
																var added=deskTop.doDrop(elementDropped);
																//var added=deskTop.doDrop(icon);
																if(added){
																	added.style.top=pos.y+"px";
																	added.style.left=pos.x+"px";
																	return added;
																}
																return null;
															} 
							});
	setDesktopMenu(deskTop);
	//Droppables.add('deskTop', {accept:'droppable', onDrop:function(element){addToDesktop(element);}, hoverclass:'cart-active'});
	setBin();
	initWidgets();
	deskTop.ready=true;
	allReady();
	addListener(document,"mousedown",clearCreatedFolder);
	
	startMultiSelect()
	//addDocSearch();
}
function addDocSearch(){
	var docSearch=document.createElement("DIV");
	docSearch.id="docSearch";
	docSearch.style.width="81px";
	docSearch.style.width="69px";
	docSearch.style.position="absolute";
	docSearch.innerHTML="<img src='docSearch.gif'>"
	docSearch.style.top=(getStageHeight()-86)+"px";
	docSearch.style.left="5px";
	docSearch.onmouseover=function(){
		new Effect.Opacity(this.getElementsByTagName("IMG")[0],{duration:0.2,from:0.2,to:1.0});
	}
	docSearch.onmouseout=function(){
		new Effect.Opacity(this.getElementsByTagName("IMG")[0],{duration:0.2,from:1.0,to:0.2});
	}
	docSearch.onclick=function(){
		var docGridSearch=document.createElement("DIV");
		docGridSearch.id="docGridSearch";
		docGridSearch.style.position="absolute";
		docGridSearch.style.width="292px";
		docGridSearch.style.height="279px";
		docGridSearch.style.top="-229px";
		docGridSearch.style.backgroundImage="url(socSearchGrid.gif)";
		docGridSearch.style.backgroundRepeat="no-repeat";
		docGridSearch.innerHTML="<div style='position:relative;width:272px;height:212px;top:10px;left:10px;'><div><div style='position:relative;height:20px;' align='center'>BUSQUEDA DE DOCUMENTOS</div><div><table><tr><td><input type='text' style='vertical-align:top'></td><td><img src='search_icon.gif' style='padding:10px;'></td></tr></table></div><table class='searchGrid' cellpadding='0' cellspacing='0'><thead><tr><th>Nombre</th><th>Tama?o</th></tr></thead><tbody><tr><td>archivo1</td><td>10kb</td></tr><tr><td>archivo1</td><td>10kb</td></tr><tr><td>archivo1</td><td>10kb</td></tr><tr><td>archivo1</td><td>10kb</td></tr></tbody></table></div></div>"
		/*docGridSearch.onmouseover=function(){
			this.onmouseout=function(){
				new Effect.Opacity(this.parentNode,{duration:0.2,from:1.0,to:0.2});
				this.parentNode.removeChild(this);
			}
		}*/
		this.onmouseout=null;
		this.onmouseover=null;
		Droppables.remove("docSearch");
		$("deskTop").onclick=function(){
			new Draggable("docSearch", {revert:false});
			if($("docGridSearch")){
				$("docGridSearch").parentNode.removeChild($("docGridSearch"));
			}
			new Effect.Opacity($("docSearch").getElementsByTagName("IMG")[0],{duration:0.2,from:1.0,to:0.2});
			$("docSearch").onmouseout=function(){
				new Effect.Opacity(this.getElementsByTagName("IMG")[0],{duration:0.2,from:1.0,to:0.2});
			}
			$("docSearch").onmouseover=function(){
				new Effect.Opacity(this.getElementsByTagName("IMG")[0],{duration:0.2,from:0.2,to:1.0});
			}
		}
		this.appendChild(docGridSearch);
	}
	document.body.appendChild(docSearch);
	new Draggable("docSearch", {revert:false});
	new Effect.Opacity($("docSearch").getElementsByTagName("IMG")[0],{duration:0.5,from:1.0,to:0.2});
}

function setBin(){
	var bin=document.createElement("DIV");
	bin.style.height="78px";
	bin.style.width="70px";
	bin.id="bin";
	bin.style.position="absolute";
	bin.style.zIndex=800;
	bin.style.backgroundImage="url(styles/"+currStyle+"/images/bin_icon.png)";
	deskTop.appendChild(bin);
	bin.style.top=(getStageHeight()-115)+"px";
	bin.style.left=(getStageWidth()-80)+"px";
	bin.doDrop=function(dropped){
		if(dropped.dragWindow){
			dropped.dragWindow.objectData.removeElement(dropped.getObject());
			return true;
		}else if(dropped.type=="postit"){ 
			dropped.remove();
		}else{
			try{dropped.unselectMe();}catch(e){}
			dropped.remove();
		}
		deskTop.dropSelected(this);
	}
	new Draggable(bin, {revert:false,starteffect:null,endeffect:null,onStart:function(){setDragDiv();},endeffect:function(e){insideStage(e);unSetDragDiv();}});
	Droppables.add(bin, {accept:'trashable',hoverclass:'opacity70',onDrop:function(draggable,droppable){ droppable.doDrop(draggable); } /*, onHover:function(draggable,droppable){draggable.className="opacity70";}*/ } );
	
	var freeTasksIcon=document.createElement("DIV");
	freeTasksIcon.style.height="70px";
	freeTasksIcon.style.width="70px";
	freeTasksIcon.id="freeTasks";
	freeTasksIcon.style.position="absolute";
	freeTasksIcon.style.zIndex=780;
	freeTasksIcon.title=lblFreeTasks;
	freeTasksIcon.style.backgroundImage="url(styles/"+currStyle+"/images/freeTasks_icon.png)";
	deskTop.appendChild(freeTasksIcon);
	freeTasksIcon.style.top=(getStageHeight()-195)+"px";
	freeTasksIcon.style.left=(getStageWidth()-80)+"px";
	freeTasksIcon.ondblclick=function(){
		taskList.free.openTaskList();
	}
	freeTasksIcon.doDrop=function(dropped){
		if(dropped.getObject().task){
			taskList.free.doDrop(dropped);
			try{dropped.unselectMe();}catch(e){}
			try{dropped.remove();}catch(e){}
		}
		deskTop.dropSelected(this);
	}
	Droppables.add(freeTasksIcon, {accept:'trashable',hoverclass:'opacity70',onDrop:function(draggable,droppable){ droppable.doDrop(draggable);} } );
	new Draggable(freeTasksIcon, {revert:false,starteffect:null,endeffect:null,onStart:function(){setDragDiv();},endeffect:function(e){insideStage(e);unSetDragDiv();}});
	
	var myTasksIcon=document.createElement("DIV");
	myTasksIcon.style.height="70px";
	myTasksIcon.style.width="70px";
	myTasksIcon.id="myTasks";
	myTasksIcon.style.position="absolute";
	myTasksIcon.style.zIndex=785;
	myTasksIcon.title=lblMyTasks;
	myTasksIcon.style.backgroundImage="url(styles/"+currStyle+"/images/myTasksIcon.png)";
	deskTop.appendChild(myTasksIcon);
	myTasksIcon.style.top=(getStageHeight()-265)+"px";
	myTasksIcon.style.left=(getStageWidth()-80)+"px";
	myTasksIcon.ondblclick=function(){
		taskList.my.openTaskList();
	}
	myTasksIcon.doDrop=function(dropped){
		if(dropped.getObject().task){
			taskList.my.doDrop(dropped);
			try{dropped.unselectMe();}catch(e){}
			dropped.remove();
		}
		deskTop.dropSelected(this);
	}
	//Droppables.add(myTasksIcon, {accept:'trashable',hoverclass:'opacity70',onDrop:function(draggable,droppable){ droppable.doDrop(draggable); deskTop.remove(draggable);} } );
	new Draggable(myTasksIcon, {revert:false,starteffect:null,endeffect:null,onStart:function(){setDragDiv();},endeffect:function(e){insideStage(e);unSetDragDiv();}});
	initTaskList("");
}

function setClock(){
	var clock=document.createElement("DIV");
	clock.style.position="absolute";
	clock.style.width="150px";
	clock.style.height="150px";
	clock.style.left=(getStageWidth()-155)+"px";
	clock.style.top="5px";
	clock.innerHTML='<object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=6,0,29,0" width="150" height="150"><param name="movie" value="flash/clock.swf"><param name="wmode" value="transparent"><param name="flashvars" value="serverHour=1&serverMinute=0&serverDate=15&serverMonth=2&serverYear=2007"><param name="quality" value="high"><embed src="flash/clock.swf" quality="high" pluginspage="http://www.macromedia.com/go/getflashplayer" type="application/x-shockwave-flash" width="150" height="150" wmode="transparent" flashvars="serverHour=1&serverMinute=0&serverDate=15&serverMonth=2&serverYear=2007"></embed></object>';
	backArea.appendChild(clock);
}
function setCalendar(){
	var clock=document.createElement("DIV");
	clock.style.position="absolute";
	clock.style.width="150px";
	clock.style.height="150px";
	clock.style.left=(getStageWidth()-155)+"px";
	clock.style.top="160px";
	clock.innerHTML='<object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=6,0,29,0" width="150" height="150"><param name="movie" value="flash/calendar.swf"><param name="wmode" value="transparent"><param name="flashvars" value="serverHour=1&serverMinute=0&serverDate=15&serverMonth=4&serverYear=2007&months=Enero,Febrero,Marzo,Abril,Mayo,Junio,Julio,Agosto,Setiembre,Octubre,Noviembre,Diciembre&days=Domingo,Lunes,Martes,Miercoles,Jueves,Viernes,Sabado"><param name="quality" value="high"><embed src="flash/calendar.swf" quality="high" pluginspage="http://www.macromedia.com/go/getflashplayer" type="application/x-shockwave-flash" width="150" height="150" wmode="transparent" flashvars="serverHour=1&serverMinute=0&serverDate=15&serverMonth=8&serverYear=2007&months=Enero,Febrero,Marzo,Abril,Mayo,Junio,Julio,Agosto,Setiembre,Octubre,Noviembre,Diciembre&days=Domingo,Lunes,Martes,Miercoles,Jueves,Viernes,Sabado"></embed></object>';
	backArea.appendChild(clock);
}

function logout(){
	var func=function(){getModel();window.location.href="security.LoginAction.do?action=logout&apiaDesk=true";};
	topArea.fadeIn(func);
}

function getToolTipText(el){
	var tooltip="<div style='position:relative;min-width:60px;'><table border=0><tr><td style='width:0px'><img style='width:20px;height:20px' src='"+el.getAttribute("icon")+"'></td><td align='right' style='width:100%;'>"+el.getAttribute("name")+"</td></tr></table></div>";
	return tooltip;
}

function startMultiSelect(){
	var stopSelection=function(evt){
				document.onmousemove=null;
				while(document.getElementById("selectionSquare")){
					var sq=document.getElementById("selectionSquare");
					document.body.removeChild(sq);
				}
			}
	addListener(deskTop,"mousedown",function(evt){
		var x=getMouseX(evt);
		var y=getMouseY(evt);
		if(evt.button!=2 && !hitTest(widgetArea,{x:x,y:y})){
			try{closeContextMenues();}catch(e){}
			try{menuItems.close();}catch(e){}
			var selectionSquare=document.createElement("DIV");
			selectionSquare.id="selectionSquare";
			document.body.appendChild(selectionSquare);
			selectionSquare.style.position="absolute";
			selectionSquare.style.border="2px solid #31DDE3";
			selectionSquare.style.backgroundColor="#AAF3F4";
			selectionSquare.className="opacity30";
			selectionSquare.style.top=y+"px";
			selectionSquare.style.left=x+"px";
			selectionSquare.startX=x;
			selectionSquare.startY=y;
			selectionSquare.style.zIndex=50;
			addListener(selectionSquare,"mouseup",stopSelection);
			document.onmousemove=function(evt){
				evt=getEventObject(evt);
				var x=getMouseX(evt);
				var y=getMouseY(evt);
				var sq=document.getElementById("selectionSquare");
				if(sq.startX<x){
					sq.style.width=(x-sq.offsetLeft)+"px";
					sq.style.left=sq.startX+"px";
				}else if(sq.startX>x){
					sq.style.left=(x)+"px";
					sq.style.width=(sq.startX-x)+"px";
				}
				if(sq.startY<y){
					sq.style.height=(y-sq.offsetTop)+"px";
					sq.style.top=sq.startY+"px";
				}else if(sq.startY>y){
					sq.style.top=(y)+"px";
					sq.style.height=(sq.startY-y)+"px";
				}
				for(var i=0;i<deskTop.elements.length;i++){
					if(hitTest(sq,deskTop.elements[i])){
						deskTop.elements[i].selectMe();
					}else{
						deskTop.elements[i].unselectMe();
					}
				}
			}
		}
	})	
	addListener(deskTop,"mouseup",stopSelection);
}
