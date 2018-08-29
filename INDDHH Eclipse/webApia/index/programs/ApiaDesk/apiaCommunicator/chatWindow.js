var rosterModal=null;
var chatWindows=new Array();

function setChatWindow(win){
	chatWindows.push(win);
	win.content.innerHTML="<div style='width:250px;position:relative;'>"+
	"<div style='white-space:nowrap;margin:5px;'></div>"+
	"<table cellpadding='0' cellspacing='0'><tr><td style='padding:2px;'>"+
	"<div class='panel' style='width:200px;height:150px;padding:5px;overflow:auto;position:relative;font-family:arial;font-size:11px;'></div>"+
	"</td><td style='padding:2px;'>"+
	"<div class='panel' style='width:50px;height:150px;padding:5px;overflow:auto;position:relative;font-family:arial;font-size:11px;'></div>"+
	"</td></tr></table>"+
	"<div style='white-space:nowrap;margin:5px;'><input type='text'><button type='button'>Send</button></div></div>";
	var button=win.content.getElementsByTagName("BUTTON")[0];
	win.content.container=win.content.getElementsByTagName("DIV")[0];
	win.content.win=win;
	win.content.messageText=win.content.getElementsByTagName("INPUT")[0];
	win.content.messageBoard=win.content.container.childNodes[1].rows[0].cells[0].firstChild;
	win.content.users=win.content.container.childNodes[1].rows[0].cells[1].firstChild;
	win.content.menu=[];
	setList(win.content.users);
	win.content.users.refreshList=function(model){
		this.clear();
		for(var i=0;i<model.length;i++){
			this.addElement(model[i]);
		}
	}
	comm.addRosterList(win.content.users);
	win.content.users.refreshList=function(model){
	

	
		if(model.length==0){
			this.clear();
			return;
		}
		for(var i=0;i<model.length;i++){
			var toDelete=null;
			for(var u=0;u<this.elements.length;u++){
				toDelete=u;
				
				if(this.elements[u].data.name==model[i].name){
					toDelete=null ;
					break;
				}
			}
			if(toDelete){
				this.deleteElement(this.elements[toDelete]);
			}
		}
	}
	win.content.messageText.onkeypress=function(evt){
		var input=getEventSource(evt);
		evt=getEventObject(evt);
		input.focus();
		evt.cancelBubble=true;
		if(evt.keyCode == 13){
			var content=this.parentNode.parentNode.parentNode;
			/*if(!content.isAlphanumeric(content.messageText.value)){
				return false;
			}*/
			var to=content.to;
			if(content.messageText.value!=""){
				comm.comm.sendMessage(to, content.encodeHTML(content.messageText.value) );
				stopObjTilt(content.win);
			}
			content.messageText.value="";
		}
	}
	
	win.content.isAlphanumeric=function(alphane){
		var numaric = alphane;
		/*for(var j=0; j<numaric.length; j++)	{
		  var alphaa = numaric.charAt(j);
		  var hh = alphaa.charCodeAt(0);
		  if((hh > 47 && hh<58) || (hh > 64 && hh<91) || (hh > 96 && hh<123) || (hh==32)){
		  }else{
			 return false;
		  }
		}*/
	 	return true;
	}
	
	win.content.encodeHTML=function(str){
		var div = document.createElement("div");
		var text = document.createTextNode(str);
		div.appendChild(text);
		return (div.innerHTML.split('"').join("'"));
 	}
	
	
	//win.content.users.addElement(comm.chatUserId);
	//win.content.users.addElement( comm.getContactFromRoster(win.content.to) );
	win.content.buttons=win.content.container.childNodes[0];
	//win.content.buttons.innerHTML="<button type='button'>send file</button><button type='button'>history</button><button type='button'>*1</button><button type='button'>assist</button><button type='button'>conference</button>";//<br>Conference subject:<input >";
	//win.content.buttons.innerHTML="<img height='20px' width='20px' style='cursor:pointer;cursor:hand;' src='"+URL_ROOT_PATH+"/programs/ApiaDesk/styles/"+currStyle+"/images/apiacomm/sendFile.png' /><img height='20px' width='20px' style='cursor:pointer;cursor:hand;' src='"+URL_ROOT_PATH+"/programs/ApiaDesk/styles/"+currStyle+"/images/apiacomm/history.png' /><img height='20px' width='20px' style='cursor:pointer;cursor:hand;' src='"+URL_ROOT_PATH+"/programs/ApiaDesk/styles/"+currStyle+"/images/apiacomm/asterisk1.png' /><img height='20px' width='20px' style='cursor:pointer;cursor:hand;' src='"+URL_ROOT_PATH+"/programs/ApiaDesk/styles/"+currStyle+"/images/apiacomm/viewer.png' /><img height='20px' width='20px' style='cursor:pointer;cursor:hand;' src='"+URL_ROOT_PATH+"/programs/ApiaDesk/styles/"+currStyle+"/images/apiacomm/conference.png' />";//<br>Conference subject:<input >";
	
	//************SE SACA TEMPORALMENTE EL sendFiley el asterix !!!
	//VER LINEA 123 que tambien se toca.
	//var btnArray=["sendFile","history","asterisk1","conference"/*,"viewer"*/];
	var btnArray=["sendFile","history","conference"];


	var btns="";
	for(var i=0;i<btnArray.length;i++){
		btns+="<img height='25px' width='25px' style='padding-left:5px;cursor:pointer;cursor:hand;' src='"+URL_ROOT_PATH+"/programs/ApiaDesk/styles/"+currStyle+"/images/apiacomm/"+btnArray[i]+".png' />";
	}
	//win.content.buttons.innerHTML="<table width='100%' cellpadding='0' cellspacing='0'><tr><td><input /></td><td align='right'>"+btns+"</td></tr></table>";
	win.content.buttons.innerHTML=btns;
	
	win.content.buttons.firstChild.onclick=function(){
		//this.parentNode.parentNode.parentNode.parentNode.upload();
		this.parentNode.parentNode.parentNode.parentNode.openSendFile();
	}
	win.content.buttons.childNodes[1].onclick=function(){
		//this.content.users.elements[0].data.data.id;
		var hwin=HistoryManager.openHistoryWindow();
		var userList=this.parentNode.parentNode.parentNode.parentNode.content.users;
		if(userList.selectedItems.length>0){
			hwin.search("",userList.selectedItems[0].data.name,"","");
		}
	}
	
	//win.content.buttons.childNodes[3].onclick=function(){
	win.content.buttons.childNodes[2].onclick=function(){
		this.parentNode.parentNode.parentNode.parentNode.openRosterModal();
		rosterModal.opener=this.parentNode.parentNode.parentNode.parentNode;
		rosterModal.onclose=function(){
			var sel=this.returnValue;
			if(sel){
				var ids="";
				for(var i=0;i<sel.length;i++){
					ids+=sel[i].data.id;
					if(i<sel.length-1){
						ids+=",";
					}
				}
				var confId=rosterModal.opener.content.to;
				comm.comm.addToConference(confId,ids);
			}
		}
	}
	/*win.content.buttons.childNodes[4].onclick=function(){
		this.parentNode.parentNode.parentNode.parentNode.openRosterModal();
		rosterModal.opener=this.parentNode.parentNode.parentNode.parentNode;
		rosterModal.onclose=function(){
			var sel=this.returnValue;
			if(sel){
				var ids="";
				for(var i=0;i<sel.length;i++){
					ids+=sel[i].data.id;
					if(i<sel.length-1){
						ids+=",";
					}
				}
				var confId=rosterModal.opener.content.to;
				comm.comm.addToConference(confId,ids);
			}
		}
	}*/
	win.content.win=win;
	
	win.setSize=function(width,height){
		this.style.width=width+"px";
		this.style.height=height+"px";
		this.titleBar.style.width=(width-2)+"px";
		this.content.style.width=(width-8)+"px";
		//this.content.container.style.width=(width-16)+"px";
		this.content.messageBoard.style.width=(width-130)+"px";
		this.content.users.style.width="90px";
		this.content.messageText.style.width=(width-100)+"px";
		this.content.messageBoard.style.height=(height-120)+"px";
		this.content.users.style.height=(height-120)+"px";
		this.content.style.height=((height-22)-8)+"px";
		this.sizer.style.top=(height-10)+"px";
		this.sizer.style.left=(width-10)+"px";
		this.content.style.top="3px";
		this.content.style.left="3px";
		this.buttons.style.top="0px";
		this.buttons.style.left=(width-120)+"px";
		this.titleBar.titleText.style.width=(width-135)+"px";
		this.titleBar.getElementsByTagName("TABLE")[0].style.width=width+"px";
	}
	win.setSize(300,220);
	button.onclick=function(){
		var content=this.parentNode.parentNode.parentNode;
		var to=content.to;
		/*if(!content.isAlphanumeric(content.messageText.value)){
			return false;
		}*/
		//comm.comm.sendMessage(to, escape(content.messageText.value) );
		if(content.messageText.value!=""){
			comm.comm.sendMessage(to, content.encodeHTML(content.messageText.value) );
			stopObjTilt(content.win);
		}
		//content.win.write("you",content.messageText.value);
		content.messageText.value="";
	}
	win.receive=function(from,txt){
		this.write(from.split("-")[0], unescape(txt) );
	}
	win.requestDownload=function(name){
		
		var to="";
		if(this.content.users.elements.length==1){
			to=this.content.users.elements[0].data.data.id;
		}else{
			return;
		}
		this.fileShare=win.addFileSharing(to+comm.chatUserId);
		this.fileShare.to=to;
		this.fileId=(to+comm.chatUserId);
		this.fileShare.confId=this.content.to;
		this.fileShare.fileName=name;
		this.fileShare.onready=function(){
			this.setFileName(this.fileName);
			this.download(this.to+comm.chatUserId);
			
		}
		this.fileShare.oncomplete=function(){
			this.innerHTML=this.fileName+": completo";
			removeFileShare(this.fileId);
			
		}
		this.fileShare.oncancel=function(){
			this.cancel();
			removeFileShare(this.fileId);
			this.innerHTML=this.fileName+": cencelled";
		}
		this.fileShare.onerror=function(){
			removeFileShare(this.fileId);
			this.innerHTML=this.fileName+": cancelled";
		}
		this.fileShare.onopen=function(){
			/*removeFileShare(this.fileId);
			this.innerHTML=this.fileName+": cancelled";*/
			alert("this.fileName "+this.fileName);
		}
		this.fileShare.onaccept=function(){
			/*removeFileShare(this.fileId);
			this.innerHTML=this.fileName+": cancelled";*/
			/*var to=this.to;
			var message={from:comm.chatUserId,eventName:"fileAccepted",confId:this.confId};
			comm.comm.sender.sendMessage(to,message);
			alert("ACCEPT!!!!");*/
		}
		this.startDownload=function(){
			this.fileShare.startTransfer();
		}
		
		/*if(confirm("desean enviarle: " +name+ " , desea descargarlo?")){
			this.download(name);
		}else{
			
		}*/
		
	}
	win.upload=function(){
		if(this.content.users.elements.length==1){
			var to="";
			if(this.content.users.elements.length==1){
				to=this.content.users.elements[0].data.data.id;
			}else{
				return;
			}
			var confId=this.content.to;
			if(!isFileWorking(comm.chatUserId+to)){
				this.fileShare=win.addFileSharing(comm.chatUserId+to);
				this.fileId=comm.chatUserId+to;
				this.fileShare.to=to;
				this.fileShare.confId=confId;
				this.fileShare.onready=function(){
					this.upload();
				}
				this.fileShare.onopen=function(){
					var to=this.to;
					var message={from:comm.chatUserId,eventName:"fileSendRequest",fileName:this.fileName,confId:this.confId};
					comm.comm.sender.sendMessage(to,message);
				}
				this.fileShare.oncomplete=function(){
					this.innerHTML=this.fileName+": completo";
					removeFileShare(this.fileId);
				}
				this.fileShare.oncancel=function(){
					this.cancel();
					removeFileShare(this.fileId);
					this.innerHTML=this.fileName+": cancelled";
				}
				this.fileShare.onerror=function(){
					removeFileShare(this.fileId);
					this.innerHTML=this.fileName+": cancelled";
				}
				this.startUpload=function(){
					this.fileShare.startTransfer();
					var to=this.fileShare.to;
					var message={from:comm.chatUserId,eventName:"fileSendRequest",transferStarted:"true",fileName:this.fileShare.fileName,confId:this.fileShare.confId};
					comm.comm.sender.sendMessage(to,message);
				}
			}
		}
	}
	win.addFileSharing=function(id){
		this.content.messageBoard.innerHTML+="<div style='position:relative;margin:5px;'></div>";
		var divs=this.content.messageBoard.getElementsByTagName("DIV");
		var div=divs[divs.length-1];
		var confId=this.content.to;
		return setFileSharing(div,id,confId,comm.chatUserId);
	}
	win.write=function(who,what){
		if(!who && who!=""){
			who="";
		}else{
			who+=" said: "; 
		}
		this.content.messageBoard.innerHTML+="<div style='position:relative;margin:5px;'>"+who+what+"</div>";
		this.content.messageBoard.scrollTop=this.content.messageBoard.scrollHeight;//""
	}
	
	win.newMessages=function(messages){
		for(var i=0;i<messages.length;i++){
			var message=messages[i];
			
			if (MSG_TYPE_NEW_USER == message.type || MSG_TYPE_EXIT_USER == message.type){
				return; //No mostrar que hay nuevos usuarios, No mostrar que se fue un usuario
			}
			message.fromMe = (message.fromMe == "true");
				
			if (MSG_TYPE_NEW_FILE_TRANFER == message.type) {
				if (message.fromMe) {
					var form = document.getElementById(message.extraId);
					
					this.write(null, "<span id='spanMsg" + message.extraId + "'>Waiting for user to accept file: " + message.text + ". <a href='#' id='aMsgRej" + message.extraId + "'>Reject</a></span>", "msg" + message.extraId);
					
					var aReject = document.getElementById("aMsgRej" + message.extraId);
					aReject.setAttribute("url",comm.comm.options.url);
					aReject.setAttribute("extraId",message.extraId);
					aReject.setAttribute("fileName",message.text);
					aReject.setAttribute("conversationId",this.content.to);
					aReject.onclick=function(evt) {
						comm.comm.rejectFile(this.getAttribute("conversationId"), this.getAttribute("extraId"), this.getAttribute("fileName"));
						return false;
					};

				} else {
					var params = "";
					params += "action=aceptTransfer";
					params += "&";
					params += "fileName=" + message.text;
					params += "&";
					params += "transferId=" + message.extraId;
					params += "&";
					params += "conversationId=" + this.content.to;
					
					//var url = comm.comm.options.url + "?" + params;
					var url = comm.comm.options.downloadUrl + "?" + params;
					
					this.write(null, "<span id='spanMsg" + message.extraId + "'>" + message.from + " is sending the file: " + message.text + ". <a href='" + url + "' target='dwl" + message.extraId+"'>Accept</a> | <a href='#' id='aMsgRej" + message.extraId + "'>Reject</a></span><iframe id='dwl"+message.extraId+"' name='dwl"+message.extraId+"' style='visibility:hidden;width:2px;height:2px' >", "msg" + message.extraId);
					
					var span = document.getElementById("spanMsg" + message.extraId);
					
					var aReject = document.getElementById("aMsgRej" + message.extraId);
					aReject.setAttribute("url",comm.comm.options.url);
					aReject.setAttribute("extraId",message.extraId);
					aReject.setAttribute("fileName",message.text);
					aReject.setAttribute("conversationId",this.content.to);
					aReject.onclick=function(evt) {
						comm.comm.rejectFile(this.getAttribute("conversationId"), this.getAttribute("extraId"), this.getAttribute("fileName"));
						return false;
					};
				}
				
				return;
			}
			
			if (MSG_TYPE_ACCEPT_FILE_TRANFER == message.type) {
				var span = document.getElementById("spanMsg" + message.extraId);
				span.innerHTML = (message.fromMe ? "You" : message.from) + " accepted the transfer of file " + message.text + ".";
				
				if (! message.fromMe) {
					var iframe = document.getElementById("frm" + message.extraId);
					
					var params = "";
					params += "action=startTransfer";
					params += "&";
					params += "transferId=" + message.extraId;
					params += "&";
					params += "conversationId=" + this.content.to;
					
					var url = comm.comm.options.url + "?" + params;

					var form = document.getElementById(message.extraId);
					form.action = url;
					form.submit();
				}
				
				return;
			}
			
			if (MSG_TYPE_CANCEL_FILE_TRANFER == message.type) {
				var span = document.getElementById("spanMsg" + message.extraId);
				span.innerHTML = (message.fromMe ? "You" : message.from) + " cancel the transfer of file " + message.text + ".";

				var form = document.getElementById(message.extraId);
				if (form != null) form.parentNode.removeChild(form);
				
				var iframe = document.getElementById("frm" + message.extraId);
				if (iframe != null) iframe.parentNode.removeChild(iframe);

				return;
			}
			
			if (MSG_TYPE_COMPLET_FILE_TRANFER == message.type) {
				var span = document.getElementById("spanMsg" + message.extraId);
				span.innerHTML = (message.fromMe ? message.from : "You") + " finished the download of file " + message.text + ".";
				
				var form = document.getElementById(message.extraId);
				if (form != null) form.parentNode.removeChild(form);
				
				var iframe = document.getElementById("frm" + message.extraId);
				if (iframe != null) iframe.parentNode.removeChild(iframe);
				
				return;
			}
			
			if (MSG_TYPE_SENDING_FILE_TRANFER == message.type) {
				var span = document.getElementById("spanMsg" + message.extraId);
				span.innerHTML = (message.fromMe ? "You are" : (message.from + " is")) + " sending the file " + message.text + ".";
				return;
			}
			
			if (MSG_TYPE_ERROR_FILE_TRANFER == message.type) {
				var span = document.getElementById("spanMsg" + message.extraId);
				span.innerHTML = "Transfer error for file " + message.text + ", try later.";
				
				var form = document.getElementById(message.extraId);
				if (form != null) form.parentNode.removeChild(form);
				
				var iframe = document.getElementById("frm" + message.extraId);
				if (iframe != null) iframe.parentNode.removeChild(iframe);

				return;
			}
			
			
			
			
			
			this.write(message.from , message.text);
		}
		
	}
	
	win.openSendFile=function() {
		var spanFrm=document.createElement("DIV");
		spanFrm.style.position="relative";
		var id=(new Date()).getTime();
		spanFrm.innerHTML="<form id='id" + id +"' method='POST' enctype='multipart/form-data' target='frm"+id+"' > <input type='file' name='theFile' style='width:100px;position: relative;text-align: right;-moz-opacity:0 ;filter:alpha(opacity: 0);opacity: 0;z-index: 2;' formId='id" + id+"'> <div style='position:absolute;top:0px;left:0px;z-index:0'><a href='#'>Browse</a></div> </form><iframe id='frm"+id+"' name='frm"+id+"' style='visibility:hidden;width:2px;height:2px' >";
		
		var form = spanFrm.getElementsByTagName("FORM")[0];
		var input = form.getElementsByTagName("INPUT")[0];
		
		form.input=input;
		form.confId=this.content.to;
		
		input.onchange=function() {
			var form=document.getElementById(this.getAttribute("formId"));
			comm.comm.newTransfer(form.confId,form.id,this.value);
			form.style.display="none";
		}
		
		this.content.messageBoard.appendChild(spanFrm);
		this.content.messageBoard.scrollTop=this.content.messageBoard.scrollHeight;
	}
	
	win.keepParticipants=function(participants){
		this.clearList();
		if(participants){
			for(var i=0;i<participants.length;i++){
				var user=participants[i];
				this.addContact(user.id, user.name);
			}
		}
	}
	
	win.openRosterModal=function(){
		if(rosterModal){
			rosterModal.bringToTop();
			return rosterModal;
		}
		var x=(getStageWidth()-220)/2;
		var y=(getStageWidth()-500)/2;
		rosterModal=openWindow({ url:"" ,width:220 , height:330 , title:("Add User"), fixedSize:true,x:x,y:y,persistable:false,icon:"styles/classic/images/apiacomm/conference.png" });
		rosterModal.content.innerHTML="<div class='panel' style='position:relative;width:210;height:260px;'></div><table width='100%'><tr><td width='100%'></td><td width='0px'><button type='button'>OK</button></td><td width='0px'><button type='button'>CANCEL</button></td></tr></table>";
		rosterModal.list=rosterModal.content.firstChild;
		setList(rosterModal.list);
		rosterModal.list.refreshList=function(model){
			this.clear();
			for(var i=0;i<model.length;i++){
				this.addElement(model[i]);
			}
		}
		comm.addRosterList(rosterModal.list);
		comm.updateRosterLists();
		rosterModal.ok=rosterModal.content.getElementsByTagName("BUTTON")[0];
		rosterModal.cancel=rosterModal.content.getElementsByTagName("BUTTON")[1];
		
		rosterModal.onclose=function(){
			comm.removeRosterList(this.list);
			//this.close();
			comm.removeRosterList(this.list);
			//this.parentNode.removeChild(this);
			rosterModal=null;
		}
		rosterModal.cancel=function(){
			rosterModal.close();
			rosterModal=null;
		}
		rosterModal.confirm=function(){
			rosterModal.returnValue=rosterModal.list.selectedItems;
			rosterModal.close();
			rosterModal=null;
		}
		rosterModal.ok.onclick=rosterModal.confirm;
		rosterModal.cancel.onclick=rosterModal.cancel;
	}
	
	comm.addWindow(win,win.content.to);
	win.onclose=function(){
		removeChatWindow(win)
		comm.comm.quitConversation(this.content.to);
		comm.removeRosterList(this.content.users);
		if(this.fileShare){
			removeFileShare(this.fileShare.fileId);
		}
		comm.removeWindow(this.content.to);
	}
	
	win.clearList=function(id){
		this.content.users.clear();
	}
	
	win.addContact=function(id,name){
		if(id!=comm.chatUserId){
			//win.content.users.addElement( comm.getContactFromRoster(id) );
			var icon="styles/classic/images/apiaCommLogo.png";
			//win.content.users.addElement( { name:(id.split("-")[0]) , icon:icon , data:{id:id} } );
			win.content.users.addElement( { name:name , icon:icon , data:{id:id} } );
		}
	}
	
	win.removeContact=function(id){
		for(var i=0;i<this.content.users.elements.length;i++){
			if(this.content.users.elements[i].data.data.id==id){
				this.content.users.deleteElement(this.content.users.elements[i]);
				return;
			}
		}
	}
	
	win.doDrop=function(el){
		var to="";
		if(this.content.users.elements.length==1){
			to=this.content.users.elements[0].data.data.id;
		}else{
			return;
		}
		var content=this.content;
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
		el.remove();
	}
	
	win.showTitleSet=function(){
		var title=document.createElement("DIV");
		title.win=this;
		title.titleSet=true;
		title.style.position="absolute";
		title.style.width="99%";
		title.style.top="0px";
		title.style.border="1px solid black";
		//title.className="opacity50";
		title.innerHTML="<div style='width:99%;position:absolute;z-index:50;font-size:10px;height:60px;border:1px solid black;'><table cellspacing='0' width='100%' cellpadding='0'><tr><td align='center'>Escriba el titulo de la conversacion</td></tr><tr><td align='center'></td></tr><tr><td align='center'><input style='font-size:10px;width:180px'></td></tr><tr><td align='center'></td></tr><tr><td align='center'><button type='button' style='font-size:10px;'>ok</button></td></tr></table></div><div class='opacity50' style='width:99%;position:absolute;z-index:1;height:60px;background-color:#FFFFAA;'></div>"
		title.okBtn=title.getElementsByTagName("BUTTON")[0];
		title.titleTxt=title.getElementsByTagName("INPUT")[0];
		title.okBtn.onclick=function(){
			var titleSet=this.parentNode;
			while(!titleSet.titleSet){
				titleSet=titleSet.parentNode;
			}
			var text=titleSet.titleTxt.value;
			comm.chatHistory.setConferenceTitle(titleSet.win.content.to,text);
			titleSet.win.setTitle(win.name+" - "+text);
			titleSet.parentNode.removeChild(titleSet);
		}
		this.content.appendChild(title);
		
	}
	
	win.getConferenceUsers=function(){
		
	}
	
	Droppables.add(win, {accept:'trashable',hoverclass:'opacity50',
		onDrop:function(draggable,droppable){
			/*while(deskTop.selectedItems.length>0){
				//droppable.doDrop(draggable);
				var dropped=deskTop.selectedItems[0];
				droppable.doDrop(dropped);
				deskTop.unSelectElement(dropped);
			}*/
			droppable.doDrop(draggable);
		}
	} );
	
	return win;
	
}

function removeChatWindow(win){
	for(var i=0;i<chatWindows.length;i++){
		if(win==chatWindows[i]){
			chatWindows.splice(i,1);
		}
	}
}

function checkChatWindow(id){
	for(var i=0;i<chatWindows.length;i++){
		var users=chatWindows[i].content.users.elements;
		if(users.length==1){
			if(users[0].data.data.id==id){
				return chatWindows[i]; 
			}
		}
	}
	return null;
}