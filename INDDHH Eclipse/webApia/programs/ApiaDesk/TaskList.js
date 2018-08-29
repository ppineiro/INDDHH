// JavaScript Document
var taskList;

function initTaskList(){
	taskList = new Object();
	taskList.free=new freeTasks();
	taskList.my=new myTasks();
	taskList.ready=false;
	taskList.refresh=function(){
		try{taskList.my.refresh();}catch(e){}
		try{taskList.free.refresh();}catch(e){}
	}
	taskList.isRefreshing=function(){
		return taskList.my.refreshing && taskList.free.refreshing;
	}
	setXslSort();
}

function openTaskList(){
	//taskList.openTaskList();
}


function freeTasks(){
	freeTasks.prototype=new genericFreeTasks();
	
	this.id="taskList";
	
	this.openTaskList=function(){
		this.url="execution.TasksListAction.do?action=init&workMode=R&xml=true";
		if(taskList.ready){
			this.url="execution.TasksListAction.do?action=first&workMode=R&xml=true";
		}else{
			taskList.ready=true;
		}
		this.openList();
		this.listTable.clear();
		getTasks(this);
	}
	
	this.openList=function(){
		if(this.listTable){
			if(this.listTable.minimizedwin){
				fireEvent(this.listTable.minimizedwin,"click");
			}
			return false;
		}
		this.list=new folder({name:lblFreeTasks,url:"",elements:[],icon:"styles/"+currStyle+"/images/freeTasks_icon.png"});
		var icon=this.list.getIconElement();
		icon.openWindow();
		this.listTable=icon.getObject().elementWindow;
		this.listTable.list=this;
		this.listTable.taskList="FREE";
		this.listTable.content.menu=[{text:lblRefresh,calledFunction:"caller.parentNode.caller.parentNode.list.refresh();"}];
		this.listTable.content.menu.push({text:"List View",calledFunction:"caller.parentNode.caller.parentNode.setListView()"})
		this.listTable.content.menu.push({text:"Icon View",calledFunction:"caller.parentNode.caller.parentNode.setIconsView()"});
		setListsViews(this.listTable);
		this.listTable.onclose=function(){
			this.killMe();
		}
		this.listTable.killMe=function(){
			taskList.free.listTable=null;
		}
		this.listTable.update=function(){};
		setNavBar(this);
		this.listTable.doDrop=function(el){
			if(!el.getObject().id){return;}
			/*winFreeTask(el,taskList.free);
			var ret=this.objectData.addElement(el.getObject());
			if(el.original){
				this.objectData.addElement(Object.clone(el.original.object));
				this.refresh();
			}
			el.remove();*/
			var ret=winFreeTask(el,taskList.free);
			el.remove();
			return ret;
		}
	}
	
}
function myTasks(){
	myTasks.prototype=new genericMyTasks();
	
	this.id="taskList";
	
	this.openTaskList=function(){
		this.url="execution.TasksListAction.do?action=init&workMode=I&xml=true";
		if(taskList.ready){
			this.url="execution.TasksListAction.do?action=first&workMode=I&xml=true";
		}else{
			taskList.ready=true;
		}
		this.openList();
		this.listTable.clear();
		getTasks(this);
	}
	
	this.openList=function(){
		if(this.listTable){
			if(this.listTable.minimizedwin){
				fireEvent(this.listTable.minimizedwin,"click");
			}
			return false;
		}
		this.list=new folder({name:lblMyTasks,url:"",elements:[],icon:"styles/"+currStyle+"/images/myTasksIcon.png",atts:{onlyCopy:true}});
		var icon=this.list.getIconElement();
		icon.openWindow();
		this.listTable=icon.getObject().elementWindow;
		this.listTable.list=this;
		this.listTable.taskList="MY";
		this.listTable.content.menu=[{text:lblRefresh,calledFunction:"caller.parentNode.caller.parentNode.list.refresh();"}];
		this.listTable.content.menu.push({text:"List View",calledFunction:"caller.parentNode.caller.parentNode.setListView()"})
		this.listTable.content.menu.push({text:"Icon View",calledFunction:"caller.parentNode.caller.parentNode.setIconsView()"});
		setListsViews(this.listTable);
		this.listTable.onclose=function(){
			this.killMe();
		}
		this.listTable.killMe=function(){
			taskList.my.listTable=null;
		}
		setNavBar(this);
		this.listTable.doDrop=function(el){
			if(!el.getObject().id ||
			(el.dragWindow && taskList.free && el.dragWindow == taskList.free.listTable)){
			return el;}
			var ret=winAquireTask(el,taskList.my.id);
			return ret;
		}
		
	}
	
}

function nullAquireTask(task,list){
	var xml=new xmlLoader();
	xml.onload=function(root){
		reportClose(list.id);
		try{list.doAfter();}catch(e){}
	}
	var workMode=list.workMode;
	workMode="R";
	var urlAquire="execution.TasksListAction.do?action=init&after=acquire&workMode="+workMode+"&"+task.getObject().id+"&windowId="+list.id;
	xml.load(urlAquire);
}
function nullFreeTask(task,list){
	var xml=new xmlLoader();
	xml.onload=function(root){
		reportClose(list.id);
		try{list.doAfter();}catch(e){}
	}
	var workMode=list.workMode;
	workMode="N";
	var urlFree="execution.TasksListAction.do?action=init&after=release&workMode="+workMode+"&"+task.getObject().id+"&windowId="+list.id;
	xml.load(urlFree);
}
function winAquireTask(task,list){
	var xml=new xmlLoader();
	if(!taskList.isRefreshing()){
		xml.onload=function(root){
			taskList.refresh();
		}
	}
	var workMode=list.workMode;
	workMode="R";
	var id=task.id;
	if(task.getObject){
		id=task.getObject().id;
	}
	var urlAquire="execution.TasksListAction.do?action=acquire&xml=true&workMode="+workMode+"&"+id+"&windowId="+list.id;
	xml.load(urlAquire);
	return task;
}
function winFreeTask(task,list){
	var xml=new xmlLoader();
	if(( deskTop.selectedItems.length==1 || deskTop.selectedItems.length==0) && !taskList.isRefreshing() ){
		xml.onload=function(root){
				taskList.refresh();
		}
	}
	var workMode=list.workMode;
	workMode="N";
	var urlFree="execution.TasksListAction.do?action=release&xml=true&workMode="+workMode+"&"+task.getObject().id+"&windowId="+list.id;
	xml.load(urlFree);
	return task;
}
function taskXML(list,doAfter){
	var xml=new xmlLoader();
	xml.onload=function(root){
		after();
	}
	var url="execution.TasksListAction.do?action=INIT&workMode="+list.workMode+"&windowId="+list.id;
	xml.load(url);
}

function getTasks(list){
	var xml=new xmlLoader();
	xml.onload=function(root){
		list.modelXML=getFirstChild(root);
		list.model=getFirstChild(root);
		fillList(list);
	}
	xml.load(list.url+"&windowId="+list.id);
}

function browse(list,action){
	if(list.navBarBlocked){
		return;
	}
	list.refreshing=true;
	list.listTable.block();
	block();
	var xml=new xmlLoader();
	xml.onload=function(root){
		unBlock();
		list.modelXML=getFirstChild(root);
		list.model=getFirstChild(root);
		list.listTable.clear();
		fillList(list);
	}
	var url="execution.TasksListAction.do?action="+action+"&hidCantPages="+list.cantPages+"&hidTotalRecords="+list.hidTotalRecords+"&page="+list.page+"&workMode="+list.workMode+"&xml=true&windowId="+list.id;
	xml.load(url);
}

function fillList(list){
	var xml=list.model;
	var WORK_MODE=list.workMode;
	list.list=new Array();
	list.page=xml.getAttribute("page");
	list.cantPages=xml.getAttribute("cantPages");
	list.cantPages=(list.cantPages!="0")?list.cantPages:"1";
	list.hidTotalRecords=xml.getAttribute("hidTotalRecords");
	list.listTable.navBar.buttons[2].innerHTML=list.page+"/"+list.cantPages;
	list.listTable.list=list;
	list.listTable.clear();
	for(var i=0;i<xml.childNodes.length;i++){
		if(xml.childNodes[i].nodeName=="task"){
			var node=xml.childNodes[i];
			var owner=(node.getAttribute("owner")=="true");
			var ownerStyle=owner?"":"opacity30";
			var task=list.getTaskElement(node);
			//var taskIcon=task.getIconElement();
			var taskIcon=list.listTable.addElement(task);
			taskIcon.className=taskIcon.className+" "+ownerStyle;
			//list.listTable.addElement(taskIcon);
			taskIcon.getObject().task=true;
			taskIcon.tooltip=task.toolTip;
			taskIcon.getObject().id=node.getAttribute("id");
			taskIcon.onrelease=function(added){
				list.onreleaseout(added);
			}
			taskIcon.menu=list.elementMenu;
			addToolTip(taskIcon);
		}else if(xml.childNodes[i].nodeName=="folder"){
			var node=xml.childNodes[i];
			//var icon="styles/"+currStyle+"/images/folder_icon.png";
			var fold=list.getFolderElement(node);
			//var foldIcon=fold.getIconElement();
			var foldIcon=list.listTable.addElement(fold);
			foldIcon.list=list;
			foldIcon.ondblclick=function(){
				if(list.listTable.content.menu.length>2){
					list.listTable.content.menu[0].disabled=true;
				}
				list.model=this.object.elements;
				fillList(this.list);
			}
			//list.listTable.addElement(foldIcon);
			//var task=new folder({icon:icon,name:node.getAttribute("name"),url:("execution.TasksListAction.do?action=init&after=work&workMode=" + WORK_MODE +"&"+node.getAttribute("id")),tooltip:"" });
		}
	}
	
	list.listTable.unBlock();
	list.refreshing=false;
}



function setNavBar(list){
	var win=list.listTable;
	var navBar=document.createElement("DIV");
	navBar.innerHTML="<div style='position:relative;width:31px;height:23px;top:0px;background-image:url(styles/"+currStyle+"/images/taskList/first.png);'></div><div style='position:relative;width:31px;top:0px;height:23px;background-image:url(styles/"+currStyle+"/images/taskList/previous.png);'></div><div style='font-family:tahoma;position:relative;width:35px;height:23px;top:0px;' align='center'></div><div style='position:relative;width:31px;height:23px;top:0px;background-image:url(styles/"+currStyle+"/images/taskList/next.png);'></div><div style='position:relative;width:31px;height:23px;top:0px;background-image:url(styles/"+currStyle+"/images/taskList/last.png);'></div><div style='position:relative;width:10px;height:23px;top:0px;'></div><div style='position:relative;width:31px;height:22px;top:0px;background-image:url(styles/"+currStyle+"/images/taskList/refresh.png);'></div>"
	navBar.style.backgroundImage="url(../../styles/gradient.jsp?height=25&width=1&colors=EDEDED;D8D8D8&type=v)";
	navBar.style.backgroundRepeat="repeat-x";
	navBar.style.position="relative";
	navBar.style.zIndex=9999;
	win.appendChild(navBar);
	var btns=navBar.getElementsByTagName("DIV");
	win.navBar=navBar;
	win.navBar.buttons=btns;
	win.setSize=function(width,height){
		this.style.width=width+"px";
		this.style.height=height+"px";
		this.titleBar.style.width=(width-2)+"px";
		this.content.style.width=(width-8)+"px";
		this.content.style.height=((height-40)-8)+"px";
		try{this.content.sizeGrid()}catch(e){}
		this.sizer.style.top=(height-10)+"px";
		this.sizer.style.left=(width-10)+"px";
		this.content.style.top="20px";
		this.content.style.left="3px";
		this.buttons.style.top="0px";
		this.buttons.style.left=(width-120)+"px";
		win.titleBar.titleText.style.width=(width-135)+"px";
		this.titleBar.getElementsByTagName("TABLE")[0].style.width=width+"px";
		if(this.content.getElementsByTagName("IFRAME")[0]){
			var iframeWidth=(width)-6;
			var iframeHeight=(height-22)-6;
			if(!MSIE){
				iframeWidth-=3;
				iframeHeight-=3;
			}
			this.content.getElementsByTagName("IFRAME")[0].style.width=iframeWidth+"px";
			this.content.getElementsByTagName("IFRAME")[0].style.height=iframeHeight+"px";
		}
		this.content.sizeMe();
		this.navBar.style.top=(45-this.offsetHeight)+"px";
		this.navBar.style.width=(width-8)+"px";
		this.navBar.style.height="23px";
		/*this.navBar.style.border="#666666";
		this.navBar.style.backgroundColor="#CCCCCC";*/
		this.navBar.style.left="4px";
		this.navBar.style.backgroundColor="#EDEDED";
		this.navBar.style.border="1px solid #888888";
		this.content.style.border="1px solid #888888";
		var x=5;
		for(var i=0;i<this.navBar.buttons.length;i++){
			this.navBar.buttons[i].style.left=x+"px";
			this.navBar.buttons[i].style.position="absolute";
			x+=this.navBar.buttons[i].offsetWidth;
		}
		try{this.onresize();}catch(e){}
		list.first=function(){
			browse(this,"first");
		}
		list.previous=function(){
			browse(this,"prev");
		}
		list.next=function(){
			browse(this,"next");
		}
		list.last=function(){
			browse(this,"last");
		}
		list.refresh=function(){
			browse(this,"refresh");
		}
		list.sort=function(to){
			if(to!=""){
				this.listTable.content.menu[3].disabled=true;
				this.listTable.navBar.block();
				if(!MSIE){
					var ns="";
					try{if(parseInt(FIREFOXVER)>=3){
						ns="xsl:";
					}}catch(e){}
					taskList.xslSort.getElementsByTagName(ns+"template")[1].getElementsByTagName(ns+"variable")[0].getElementsByTagName(ns+"value-of")[0].setAttribute("select","'"+to+"'");
					this.model=xslTransform(this.modelXML.ownerDocument,taskList.xslSort).firstChild;
				}else{
					taskList.xslSort.lastChild.getElementsByTagName("xsl:template")[1].getElementsByTagName("xsl:variable")[0].getElementsByTagName("xsl:value-of")[0].setAttribute("select","'"+to+"'");
					this.model=xslTransform(this.modelXML.ownerDocument,taskList.xslSort).lastChild;
				}
				fillList(this);
				if(list.listTable.content.menu.length>2){
					list.listTable.content.menu[0].disabled=true;
				}
			}else{
				this.listTable.content.menu[3].disabled=false;
				this.listTable.navBar.unblock();
				this.model=this.modelXML;
				fillList(this);
			}
		}
		this.navBar.buttons[0].onclick=function(){
			list.first();
		}
		this.navBar.buttons[1].onclick=function(){
			list.previous();
		}
		this.navBar.buttons[3].onclick=function(){
			list.next();
		}
		this.navBar.buttons[4].onclick=function(){
			list.last();
		}
		this.navBar.buttons[6].onclick=function(){
			list.refresh();
		}
		this.navBar.block=function(){
			list.navBarBlocked=true;
			this.className="opacity70";
		}
		this.navBar.unblock=function(){
			list.navBarBlocked=false;
			this.className="";
		}
	}
	win.onclose=function(){
		for(var i=0;i<windows.length;i++){
			if(windows[i]==this){
				windows.splice(i,1);
			}
		}
		list.closed=true;
		if(taskList.free.closed && taskList.my.closed){
			reportClose("TaskList");
			taskList.ready=false;
		}
		this.killMe();
	}
	win.setSize(win.offsetWidth,win.offsetHeight);
}

function openTaskListWindow(elementData){
	var type;
	if(elementData.taskList=="MY"){
		type=taskList.my;
	}else{
		type=taskList.free;
	}
	type.openList();
	type.first();
	type.listTable.setSize(elementData.width,elementData.height);
	type.listTable.style.top=elementData.y+"px";
	type.listTable.style.left=elementData.x+"px";
}

function setXslSort(){
	taskList.xslSort=null;
	var xslLoader=new xmlLoader();
	xslLoader.onload=function(){
		taskList.xslSort=this.xmlLoaded;
	}
	xslLoader.load("groupby.xsl");
}



function genericFreeTasks(url){
	genericTasks(this);
	this.workMode="R";
	this.type="freeTasks";
	this.refreshing=false;
	this.url=url;
	this.openTaskList=function(){
		this.openList();
		this.listTable.clear();
		getTasks(this);
	}
	this.doDrop=function(task){
		this.freeTask(task);
	}
	this.openList=function(){
		if(this.listTable){
			if(this.listTable.minimizedwin){
				fireEvent(this.listTable.minimizedwin,"click");
			}
			return false;
		}
		this.list=new folder({name:lblFreeTasks,url:"",elements:[],icon:"styles/"+currStyle+"/images/freeTasks_icon.png"});
		var icon=this.list.getIconElement();
		icon.openWindow();
		this.listTable=icon.getObject().elementWindow;
		this.id=this.listTable.windowId;
		this.listTable.list=this;
		this.listTable.taskList="FREE";
		this.listTable.content.menu=[{text:lblRefresh,calledFunction:"caller.parentNode.caller.parentNode.list.refresh();"}];
		this.listTable.content.menu.push({text:"List View",calledFunction:"caller.parentNode.caller.parentNode.setListView()"})
		this.listTable.content.menu.push({text:"Icon View",calledFunction:"caller.parentNode.caller.parentNode.setIconsView()"});
		
		this.listTable.update=function(){};
		setNavBar(this);
		this.listTable.doDrop=function(el){
			if(!el.getObject().id){return;}
			var ret=winFreeTask(el,this.list);
			el.remove();
			return ret;
		}
	}
	this.updateList=function(){
		this.listTable.clear();
		getTasks(this);
	}
	this.aquireTask=function(task){
		if(taskList.ready){
			winAquireTask(task,taskList.free);
		}else{
			nullAquireTask(task,taskList.free);
		}
	}
	this.freeTask=function(task){
		if(taskList.ready){
			winFreeTask(task,taskList.my);
		}else{
			nullFreeTask(task,taskList.my);
		}
	}
	this.onreleaseout=function(added){
		winAquireTask(added,this);
		var obj=(added.getObject)?added.getObject():added;
		added.url="execution.TasksListAction.do?action=init&after=work&workMode=I&"+obj.id;
		if(added.iconElement){
			added.iconElement.setAttribute("url","execution.TasksListAction.do?action=init&after=work&workMode=I&"+obj.id);
		}
		if(added.getObject){
			added.getObject().url="execution.TasksListAction.do?action=init&after=work&workMode=I&"+obj.id;
			added.setAttribute("url","execution.TasksListAction.do?action=init&after=work&workMode=I&"+obj.id);
			try{added.bringToTop();}catch(e){}
		}
	}
	this.elementMenu=[{text:msgAquireTask,calledFunction:"caller.parentNode.caller.win.list.aquireTask(caller.parentNode.caller);"}];
}



function genericMyTasks(url){
	genericTasks(this);
	this.type="myTasks";
	this.workMode="I";
	this.refreshing=false;
	this.url=url;
	this.openTaskList=function(){
		this.openList();
		this.listTable.clear();
		getTasks(this);
	}
	this.doDrop=function(task){
		this.aquireTask(task);
	}
	this.openList=function(){
		if(this.listTable){
			if(this.listTable.minimizedwin){
				fireEvent(this.listTable.minimizedwin,"click");
			}
			return false;
		}
		this.list=new folder({name:lblMyTasks,url:"",elements:[],icon:"styles/"+currStyle+"/images/myTasksIcon.png",atts:{onlyCopy:true}});
		var icon=this.list.getIconElement();
		icon.openWindow();
		this.listTable=icon.getObject().elementWindow;
		this.listTable.list=this;
		this.listTable.taskList="MY";
		this.listTable.content.menu=[{text:lblRefresh,calledFunction:"caller.parentNode.caller.parentNode.list.refresh();"}];
		this.listTable.content.menu.push({text:"List View",calledFunction:"caller.parentNode.caller.parentNode.setListView()"})
		this.listTable.content.menu.push({text:"Icon View",calledFunction:"caller.parentNode.caller.parentNode.setIconsView()"});
		
		setNavBar(this);
		this.listTable.doDrop=function(el){
			if(!el.getObject().id ||
			(el.dragWindow && taskList.free && el.dragWindow == taskList.free.listTable)){
			return el;}
			var ret=winAquireTask(el,taskList.my);
			return ret;
		}
		
	}
	this.updateList=function(){
		this.listTable.clear();
		getTasks(this);
	}
	this.aquireTask=function(task){
		if(taskList.ready){
			winAquireTask(task,taskList.free);
		}else{
			nullAquireTask(task,taskList.free);
		}
	}
	this.freeTask=function(task){
		if(taskList.ready){
			winFreeTask(task,taskList.my);
		}else{
			nullFreeTask(task,taskList.my);
		}
	}
	this.onreleaseout=function(added){
		try{added.bringToTop();}catch(e){}
		//this.refresh();
	}
	this.elementMenu=[{text:msgFreeTask,calledFunction:"caller.parentNode.caller.win.list.freeTask(caller.parentNode.caller);"}];
}

function genericTasks(list){
	list.workMode="";
	list.getTaskElement=function(node){
		var WORK_MODE=this.workMode;
		//var icon="styles/"+currStyle+"/images/taskicon.png";
		var icon="../.."+unescape(node.getAttribute("icon"));
		var proInstId=node.getAttribute("proInstId");
		var task=new element({icon:icon,name:node.getAttribute("name"),url:("execution.TasksListAction.do?action=init&after=work&workMode=" + WORK_MODE +"&"+node.getAttribute("id")),tooltip:"" });
		var toolTip="<div style='position:relative;min-width:60px;'><table border=0><tr><td style='width:0px' align='left'><img style='width:25px;height:25px;' src='"+task.icon+"'></td><td style='width:100%;font-size:15px' align='left'>"+task.name+"</td></tr>";//</table></div>";
		//toolTip+="<div style='position:relative;min-width:60px;'><table border=0>"
		var attributes=[];
		var data=new Object();
		for(var u=0;u<node.childNodes.length;u++){
			if(node.childNodes[u].nodeName.toUpperCase()=="DATA" && node.childNodes[u].getAttribute("colname")!=null && node.childNodes[u].getAttribute("colvalue")!=null && node.childNodes[u].getAttribute("colname")!="" && node.childNodes[u].getAttribute("colvalue")!=""){
				var colValue=node.childNodes[u].getAttribute("colvalue");
				toolTip+="<tr><td width='50%' style='white-space:nowrap;align:left;' align='left'>"+node.childNodes[u].getAttribute("colname")+"</td><td width='50%' align='left' style='" + ( (colValue.length<40)?"white-space:nowrap;":"word-break:normal;") + "align:left;'>"+colValue+"</td></tr>";
				attributes.push({text:node.childNodes[u].getAttribute("colname"),calledFunction:"caller.parentNode.caller.parentNode.list.sort('"+node.childNodes[u].getAttribute("colname")+"');"});
				data[node.childNodes[u].getAttribute("colname")]=node.childNodes[u].getAttribute("colvalue");
			}
		}
		task.data=data;
		if(this.list.length==0){
			this.listTable.content.menu=[{text:lblRefresh,calledFunction:"caller.parentNode.caller.parentNode.list.refresh();"},
			{text:lblGroupBy,menu:attributes,disabled:this.listTable.listView},
			{text:lblUnGroup,calledFunction:"caller.parentNode.caller.parentNode.list.sort('');"}];
			this.listTable.content.menu.push({text:"List View",calledFunction:"caller.parentNode.caller.parentNode.setListView()"})
			this.listTable.content.menu.push({text:"Icon View",calledFunction:"caller.parentNode.caller.parentNode.setIconsView()"});
	
		}
		toolTip+="</table></div>";
		task.toolTip=toolTip;
		return task;
	}
	list.getFolderElement=function(node){
		var fold=new folder({icon:"styles/"+currStyle+"/images/folder_icon.png",name:( node.getAttribute("value") ),url:"",elements:node});
		return fold;
	}
	list.addIconElement=function(node){
		var icon=this.listTable.content.addElement(node);
		icon.tooltip=node.toolTip;
		addToolTip(icon);
		return icon;
	}
	
}

function setListsViews(win){
	win.setListView=function(){
		if(!this.listView){
			this.content.menu[1].disabled=true;
			setGrid(this.content);
			this.listView=true;
			this.iconView=false;
			this.content.setDataSource(this.objectData.elements);
		}
	}
	win.setIconsView=function(){
		if(!this.iconView){
			this.content.menu[1].disabled=false;
			setIconView(this.content);
			this.content.setDataSource=function(els){
				for(var i=0;i<els.length;i++){
					this.win.list.addIconElement(els[i]);
				}
			}
			this.listView=false;
			this.iconView=true;
			this.content.setDataSource(this.objectData.elements);
		}
	}
}
