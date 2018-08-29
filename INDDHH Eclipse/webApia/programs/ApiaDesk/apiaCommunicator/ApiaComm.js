var comm=null;

function setApiaComm(div){
	
	comm=div;
	comm.blocked=true;
	comm.commWindow;
	startApiaComm();
	
}

function startApiaComm(){
	comm.dockImg=comm.getElementsByTagName("IMG")[0];
	
	comm.chatUserId=LOGGED_USER;//+"-"+LOGGED_SESSION;
	
	comm.setBlock=function(block){
		if(block){
			this.dockImg.src=(this.dockImg.src.split(".pn")).join("D.pn");
			if(this.commWindow){
				this.commWindow.close();
			}
		}else{
			this.dockImg.src=(this.dockImg.src.split("D.png")).join(".png");
		}
		comm.blocked=block;
	}
	
	comm.setBlock(false);
	//var commUrl=URL_ROOT_PATH+"/programs/ApiaDesk/apiaCommunicator/chatServer.jsp";
	var commUrl=URL_ROOT_PATH+"/programs/ApiaDesk/apiaCommunicator/Chat.chat";
	var commDownloadUrl=URL_ROOT_PATH+"/programs/ApiaDesk/apiaCommunicator/chatServer.jsp";
		
	//comm.comm=new ApiaComm(comm.chatUserId);
	comm.comm=new ChatClient();
	comm.comm.setUi(comm);
	comm.comm.setUrl(commUrl);
	comm.comm.setDownloadUrl(commDownloadUrl);
	
	var tmp=comm;
	comm.comm.onblocked=function(){
		comm.setBlock(true);
	}
	comm.comm.onregistered=function(){
		//comm.updateRoster();
		this.refresh();
	}
	comm.comm.onshutdown=function(){
		for(var i in this.activeWindows){
			this.activeWindows[i].close();
		}
		if(comm.commWindow){
			comm.commWindow.close();
		}
	}
	
	comm.activeWindows=new Object();
	
	comm.addWindow=function(win,key){
		if(!this.activeWindows[key]){
			this.activeWindows[key]=win;
		}
	}
	
	comm.removeWindow=function(key){
		if(this.activeWindows[key]){
			this.activeWindows[key]=null;
		}
	}
	
	comm.openComm=function(){
		if(this.commWindow){
			return;
		}
		this.openCommWindow();
	}
	
	comm.openMessageWindow=function(key,title){
		if(this.activeWindows[key]){
			this.activeWindows[key].bringToTop();
			return this.activeWindows[key];
		}
		var win=openWindow({ url:"" ,width:350 , height:220 , title:title, fixedSize:false, persistable:false,icon:"styles/classic/images/apiacomm/conference.png" });
		win.content.to=key;
		
		return setChatWindow(win);
	}
	
	comm.processBroadcasts=function(broadcasts){
		for(var i=0;i<broadcasts.length;i++){
			var message=broadcasts[i];
			if (message.block == "true") {
				/*var dialog = new Jx.Dialog({
			        label: CHAT_LBL_BY + ': ' + message.from ,
			        image: 'images/page_white_text.png',
			        modal: true, 
			        resize: false,
			        move: false,
			        content: new Element("div", {'html': message.message}),
			        width: 320,
			        height: 120
				});
				dialog.open();*/
				alert(message.from+":"+message.text);
			} else {
				var not=deskTop.notify(message.from+":"+message.text);
				not.closeIn(4000);
			}
		}
	}
	
	comm.openCommWindow=function(){
		if(this.blocked==true){
			return;
		}
		if(this.commWindow){
			if(this.commWindow.minimizedwin){
				fireEvent(this.commWindow.minimizedwin,"click");
			}
			return false;
		}
		
		this.commWindow=openWindow({ url:"",x:(getStageWidth()-310) ,y:(getStageHeight()-(510+35)) ,width:300 , height:500 , title:"Communicator", fixedSize:false,persistable:false,icon:"styles/classic/images/apiacomm/conference.png" });
		
		this.commWindow.content.innerHTML="<div style='width:280px;height:75px;position:relative;padding:5px;'></div><div style='width:285px;height:360px;position:relative;' class='panel'></div>";
		//this.commWindow.content.innerHTML+="<div><div height='20px' style='font-family:Tahoma;font-size:11px;padding-left:'>search</div><div style='display:nones;position:relative;height:100px;'></div></div>";
		var divs=this.commWindow.content.childNodes;
		this.top=divs[0];
		this.rosterList=divs[1];
		//this.userSearch=divs[2];
		
		this.top.innerHTML="<table cellpadding='0' cellspacing='0' width='100%'><tr><td width='0'><img src='styles/classic/images/apiaCommLogo.png' height='50px' width='50px' /></td><td width='100%'>  <table width='100%'><tr><td>"+"</td><td width='0' align='left'> <select style='display:none' onchange='comm.changeStatus(this.options[this.selectedIndex].value);'><option value='1'>Online</option><option value='2'>Busy</option><option value='3'>Away</option></select> </td><td width='100%' align='right'><img src='"+URL_ROOT_PATH+"/programs/ApiaDesk/styles/"+currStyle+"/images/apiacomm/groupRing.png' style='height:40px;width:40px;cursor:pointer;cursor:hand' /><img style='display:none' src='"+URL_ROOT_PATH+"/programs/ApiaDesk/styles/"+currStyle+"/images/apiacomm/history.png' style='height:40px;width:40px;cursor:pointer;cursor:hand' /></td></tr></table>  </td></tr></table> <div style='width:100%;align:center;'><input style='font-size:10px;width:275px;' /></div> "
		
		this.commWindow.statusCmb=this.top.getElementsByTagName("SELECT")[0];
		this.commWindow.statusImage=this.top.getElementsByTagName("IMG")[0];
		this.commWindow.groupBtn=this.top.getElementsByTagName("IMG")[1];
		this.commWindow.historyBtn=this.top.getElementsByTagName("IMG")[2];
		this.commWindow.userFilter=this.top.getElementsByTagName("INPUT")[0];
		
		this.commWindow.userFilter.onkeyup=function(){
			comm.rosterList.filter(this.value);
		}
		this.commWindow.historyBtn.onclick=function(){
			var hwin=HistoryManager.openHistoryWindow();
			if(comm.rosterList.selectedItems.length>0){
				hwin.search("",comm.rosterList.selectedItems[0].data.name,"","");
			}
		}
		this.commWindow.groupBtn.onclick=function(){
			GroupCallManager.openGroupWindow();
		}
		
		this.commWindow.onclose=function(){
			comm.removeRosterList(comm.rosterList);
			comm.commWindow=null;
		}
		
		this.commWindow.minimize=this.commWindow.close;
		
		this.commWindow.content.menu=[];
		
		/*this.rosterLists.style.padding="3px;"
		this.rosterLists.innerHTML="<div></div>"*/
		
		
		this.commWindow.onresize=function(){
			var width=this.content.offsetWidth;
			var height=this.content.offsetHeight;
			comm.top.style.height="75px";
			comm.top.style.padding="0px";
			var rosterHeight=( (height-8)- ( comm.top.clientHeight /*+ comm.userSearch.clientHeight*/ ) )-30;
			comm.rosterList.style.height=((rosterHeight>100)?rosterHeight:100)+"px";
			if(this.content.offsetHeight<this.content.scrollHeight){
				width-=18;
			}
			comm.rosterList.style.width=(width-4)+"px";
			comm.top.style.width=(width-4)+"px";
			comm.commWindow.userFilter.style.width=(width-20)+"px";
			/*comm.userSearch.style.width=(width-4)+"px";
			comm.userSearch.sizeMe();*/
		}
		setList(this.rosterList);
		this.rosterList.refreshList=function(model){
			this.clear();
			for(var i=0;i<model.length;i++){
				this.addElement(model[i]);
			}
		}
		comm.addRosterList(comm.rosterList);
		comm.updateRosterLists();
		
		this.rosterList.onElementDoubleClicked=function(el){
			var key=el.data.id;
			
			var win=checkChatWindow(key);
			if(win){
				win.bringToTop();
			}else{
				var titlemodal=openModalWin();
				titlemodal.content.innerHTML="<table width='100%'><tr><td align='center'>"+"ingrese el titulo de la conversacion"+"</td></tr><tr><td align='center'><input type='text' /></td></tr></table><table width='100%'><tr><td align='center' width='50%'><button type='button'>Ok</button></td><td align='center' width='50%'><button type='button'>Cancel</button></td></tr></table><table><tr>"
				titlemodal.titleInput=titlemodal.getElementsByTagName("INPUT")[0];
				titlemodal.okBtn=titlemodal.getElementsByTagName("BUTTON")[0];
				titlemodal.cancelBtn=titlemodal.getElementsByTagName("BUTTON")[1];
				titlemodal.confirm=function(){
					comm.comm.startConversation(key,this.titleInput.value);
					this.close();
				}
				titlemodal.okBtn.onclick=function(){titlemodal.confirm();}
				titlemodal.cancelBtn.onclick=function(){titlemodal.close();}
				titlemodal.setSize(300,120);
			}			
		}
		//this.updateRosterModel();
		
		this.commWindow.doDrop=function(el){
			var content=this.content;
			if(comm.rosterList.selectedItems.length>0){
				var to=comm.rosterList.selectedItems[0].data.id;
				if(to){
					if(el.object.task){
						var url=el.url;
						nullFreeTask(el,{id:"apiaComm",doAfter:function(){
								var workMode=getUrlVar(url,"workMode");
								var proInstId=getUrlVar(url,"proInstId");
								var proEleInstId=getUrlVar(url,"proEleInstId");
								var command={event:"command",message:"Desea aceptar la tarea que se le envio?",type:"SendTaskCommand",workMode:workMode,proInstId:proInstId,proEleInstId:proEleInstId};
								comm.comm.sendCommand(to,command);
							}
						});
					}else if(el.url){
						var url=el.url;
						var command={event:"command",type:"URLCommand",url:escape(url)};
						comm.comm.sendCommand(to,command);
					}else if(el.type=="postit"){
						var command={event:"command",type:"PostitCommand",postitText:el.text.value  };
						comm.comm.sendCommand(to,command);
					}
				}
				el.remove();
			}
		}
		
		Droppables.add(this.commWindow, {accept:'trashable',hoverclass:'opacity50',
			onDrop:function(draggable,droppable){
				droppable.doDrop(draggable);
			}
		} );
		
		comm.updateGUIStatus();
		
	}
	
	comm.updateRosterModel=function(){
		this.rosterModel=new Array();
		//this.rosterList.clear();
		//for(var i=0;i<this.comm.roster.length;i++){
		var r=this.comm.getRoster();
		for(var i=0;i<r.length;i++){
			var contact=r[i];
			var icon="styles/classic/images/";
			switch(parseInt(contact.status)){
				case 2:
					icon+="commBusy.png";
				break;
				case 3:
					icon+="commAway.png";
				break;
				default:
					icon+="apiaCommLogo.png";
				break;
			}
			contact.icon=icon;
			//this.rosterList.addElement(contact);
			this.rosterModel.push(contact);
		}
		this.updateRosterLists();
	}
	
	comm.updateGroupModel=function(){
		this.groupsModel=new Array();
		var g=this.comm.getGroups();
		for(var i=0;i<g.length;i++){
			var grp=g[i];
			var icon="styles/classic/images/images/apiacomm/groupRing.png";
			
			grp.icon=icon;
			//this.rosterList.addElement(contact);
			this.groupsModel.push(grp);
		}
		//this.updateRosterLists();
	}
	
	comm.actualRequests=new Object();
	
	comm.updateRequests=function(){
		this.requestsModel=new Array();
		var r=this.comm.getRequests();
		for(var i=0;i<r.length;i++){
			var rqs=r[i];
			this.requestsModel.push(rqs);
		}
		var keep=new Object();
		if(this.requestsModel.length>0){
			for(var i=0;i<this.requestsModel.length;i++){
				var requestId=this.requestsModel[i].id;
				var user=this.requestsModel[i].user;
				var grpId=this.requestsModel[i].groupId;
				var group=this.requestsModel[i].group;
				if(!this.actualRequests[requestId]){
					var notify=deskTop.notify(user+" desea chatear con un miembro del grupo:"+group);
					//starTilt(usu+" RINGS",notify)
					notify.requestId=requestId;
					notify.user=user;
					notify.groupId=grpId;
					notify.group=group;
					addListener(advise,"click",function(e){
						e=getEventObject(e);
						var ad=getEventSource(e);
						if(ad.id==""){
							ad=ad.parentNode;
						}
						//stopObjTilt(ad);
						comm.comm.aceptConversationRequest(ad.requestId,ad.groupId);
					});
					this.actualRequests[requestId]=notify;
				}
				keep[requestId]=true;
			}
		}
		for(var i in this.actualRequests){
			if(!keep[i]){
				delete(comm.actualRequests[this.actualRequests[i].requestId]);
				try{deskTop.closeNotification(this.actualRequests[i].id);}catch(e){}
				
			}
		}
	}
	
	comm.getContactFromRoster=function(id){
		for(var i=0;i<this.rosterList.elements.length;i++){
			if(this.rosterList.elements[i].data.id==id){
				return this.rosterList.elements[i].data;
			}
		}
	}

	comm.getContactsFromRoster=function(id){
		var contacts=new Array();
		for(var i=0;i<comm.rosterList.elements.length;i++){
			contacts.push(comm.rosterList.elements[i].data);
		}
		return contacts;
	}
	
	//comm.updateRoster();
	
	comm.changeStatus=function(num){
		this.status=num;
		this.comm.changeStatus(num);
		comm.updateGUIStatus();
	}
	
	comm.updateGUIStatus=function(){
		var num=(this.status)?this.status:1;
		var icon="styles/classic/images/";
		switch(parseInt(num)){
			case 2:
				icon+="commBusy.png";
			break;
			case 3:
				icon+="commAway.png";
			break;
			default:
				icon+="apiaCommLogo.png";
			break;
		}
		comm.dockImg.src=icon;
		comm.commWindow.statusCmb.options[(parseInt(num)-1)].selected=true;
		comm.commWindow.statusImage.src=icon;
	}
	
	comm.answerKnock=function(){
		
	}
	
	comm.knock=function(){
		var notice=deskTop.notify(" KNOCK KNOCK!");
	}
	
	comm.rosterModel=new Array();
	comm.rosterLists=new Array();
	comm.updateRosterLists=function(){
		for(var u=0;u<this.rosterLists.length;u++){
			this.rosterLists[u].refreshList(this.rosterModel);
		}
	}
	
	comm.addRosterList=function(list){
		this.rosterLists.push(list);
	}
	comm.removeRosterList=function(list){
		for(var u=0;u<this.rosterLists.length;u++){
			if(this.rosterLists[u]==list){
				this.rosterLists.splice(u,1);
				return;
			}
		}
	}
	
	//comm.comm.sendLogin(comm.chatUserId,USER_GROUPS.toString());
	comm.comm.refresh();
	
	
}

function reconnectComm(){
	comm.setBlock(false);
	comm.comm.dispatcher.listen();
}

