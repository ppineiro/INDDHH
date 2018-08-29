function CommHandler(){
	this.handle=function(message){
	
		var win=comm.activeWindows[message.conferenceId];
		if(win && message.closeConference=="true"){
			win.close();
			return;
		}
		if(!win){
			try{
				win=comm.openMessageWindow(message.conferenceId,message.initUser.split("-")[0]);
			}catch(e){
				win=comm.openMessageWindow(message.conferenceId,"");
			}
		}
		message.value=Base64.decode(message.value);
		win.receive(message.from,message.value);
	}
}

function StatusHandler(){
	this.handle=function(message){
		var from=message.from;
		var value=message.value;
		var icon="styles/classic/images/";
		if(!from){
			return;
		}
		var name=from.split("-")[0];
		var contact={name:name,id:from,icon:icon};
		if(value==0){
			this.removeContact(contact);
		}else{
			contact.status=value;
			this.updateContact(contact);
		}
		comm.updateRosterModel();
		/*if(comm.commWindow){
			comm.updateRosterLists();
		}*/
	}
	
	this.removeContact=function(contact){
		for(var i=0;comm.comm.roster.length;i++){
			if(comm.comm.roster[i].id==contact.id){
				comm.comm.roster.splice(i,1);
				return;
			}
		}
	}
	
	this.updateContact=function(contact){
		var addedContact=this.isContactAdded(contact);
		if(addedContact==false){
			comm.comm.roster.push(contact);
		}else{
			for(var i in addedContact){
				addedContact[i]=contact[i];
			}
		}
	}
	
	this.isContactAdded=function(contact){
		for(var i=0;i<comm.comm.roster.length;i++){
			if(comm.comm.roster[i].id==contact.id){
				return comm.comm.roster[i];
			}
		}
		return false;
	}
	
}

function KnockHandler(){
	this.handle=function(message){
		//comm.comm.answerKnock()
		var from=message.from;
		if(from==comm.comm.id){
			return;
		}
		var usu=from.split("-")[0];
		var notify=deskTop.notify(usu+" desea chatear ");
		starTilt(usu+" RINGS",notify)
		notify.user=from;
		notify.groupTo=message.groupTo;
		notify.onclick=function(){
			stopObjTilt(this);
			comm.comm.answerKnock(this.user,this.groupTo);
			comm.comm.getNewConference(this.user);
			
		}
	}
	
}

function KnockAnswerHandler(){
	this.handle=function(message){
		var from=message.from;
		var groupTo=message.groupTo;
		var who=message.who;
		for(var i=0;i<deskTop.notifications.length;i++){
			if(deskTop.notifications[i].user==who && deskTop.notifications[i].groupTo==groupTo){
				deskTop.closeNotification(deskTop.notifications[i].id);
			}
		}
	}
	
}

function FileRequestHandler(){
	this.handle=function(message){
		var win=comm.activeWindows[message.confId];
		if(!win){
			win=comm.openMessageWindow(message.confId,message.initUser.split("-")[0]);
		}
		if(message.transferStarted){
			win.startDownload();
		}else{
			win.requestDownload(message.fileName);
		}
	}
}

function FileAcceptedHandler(){
	this.handle=function(message){
		var win=comm.activeWindows[message.confId];
		win.startUpload();
	}
}

function ConferenceReadyHandler(){
	this.handle=function(message){
	
		var chatWith="";
		for(var i=0;i<message.childNodes.length;i++){
			if(comm.chatUserId == message.childNodes[i].id){
				continue;
			}
			if(chatWith.length == 0){
				chatWith= (message.childNodes[i].id.split("-")[0]);
			}else {
				chatWith= chatWith + " " + (message.childNodes[i].id.split("-")[0]);
			}
		}
		
		var win=comm.activeWindows[message.confId];
		if(!win){
			win=comm.openMessageWindow(message.confId,chatWith);
		}
		if(message.initUser==comm.chatUserId && message.titleSet){
			win.showTitleSet();
		}else{
			var tit=message.initUser.split("-")[0];	
			starTilt(tit+" RINGS",win)
		}
		win.clearList();
		for(var i=0;i<message.childNodes.length;i++){
			win.addContact(message.childNodes[i].id);
		}
	}
}

function UnregisterContactHandler(){
	this.handle=function(message){
		var win=comm.activeWindows[message.confId];
		//for(var i=0;i<message.childNodes.length;i++){
			try{
			win.removeContact(message.from);
			}catch(e){}
		//}
	}
}

var tilting=false;
var tilts=new Array();
var lastTilt=0;
function starTilt(tit,obj){
	tilts.push({caller:obj,title:tit});
	if(!tilting){
		tilting=true;
		tilt();
	}
	
}
function stopObjTilt(obj){
	for(var i=0;i<tilts.length;i++){
		if(obj==tilts[i].caller){
			tilts.splice(i,1);
		}
	}
	if(tilts.length==0){
		stopTilt();
	}
}
function stopTilt(){
	tilting=false;
	//window.document.title=DESK_WIN_TITLE;
	setWindowTitle(DESK_WIN_TITLE);
}
function tilt(){
	var tiltTitle=DESK_WIN_TITLE;
	if(lastTilt<tilts.length){
		tiltTitle=tilts[lastTilt].title;
		lastTilt++;
	}else{
		lastTilt=0;
	}
	/*if(MSIE){
		window.title=tiltTitle;
	}
	window.document.title=tiltTitle;
	*/
	setWindowTitle(tiltTitle);
	if(tilting){
		setTimeout(tilt,1000);
	}
}

//addListener(window,"unload",function(){stopTilt()});
//addListener(window,"close",function(){stopTilt()});