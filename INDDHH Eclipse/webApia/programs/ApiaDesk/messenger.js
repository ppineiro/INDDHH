// JavaScript Document
var messagesURL=URL_ROOT_PATH+"/ApiaDeskAction.do?action=xmlList";
var messenger=new Object();
function startMessenger(){
//	messenger=new Object();
	var messenger2=document.getElementById("messenger");
	messenger.refreshRate=60000;
	messenger.checkCant=0;
	if(!messenger2){
		var messenger2=document.createElement("DIV");
		document.body.appendChild(messenger2);
		messenger.id="messenger2"
	}
	messenger.inbox=new Array();
	messenger.openInbox=function(){
		var xml=new xmlLoader();
		xml.onload=function(root){
			messenger.parseMsgList(getFirstChild(root));
		}
		xml.load(messagesURL);
	}
	
	messenger.parseMsgList=function(root){
		var list=new Array();
		for(var i=0;i<root.childNodes.length;i++){
			var node=root.childNodes[i].cloneNode(true);
			if(node.nodeName=="message"){
				list.push({ text:node.getAttribute("text"), title:node.getAttribute("title"), type:node.getAttribute("type"), id:node.getAttribute("id") });
			}
		}
		messenger.loadList(list);
	}
	
	messenger.loadList=function(list){
		if(!document.getElementById("inboxTable")){
			this.inboxWindow=openWindow({ url:"",x:(getStageWidth()-355) ,y:(getStageHeight()-(250+35)) ,width:350 , height:250 , title:"INBOX", fixedSize:true, persistable:false });
		}
		var inboxTable="<table width=100% cellpadding='0' cellspacing='0'><thead><tr><th></th><th>Mensaje</th></thead><tbody>";
		for(var i=0;i<list.length;i++){
			var msg=list[i];
			var src="styles/"+currStyle+"/images/";
			src+=msg.type+"Icon.png";
			inboxTable+="<tr><td><img";
			if(msg.id){
				inboxTable+=" onclick='marcarLeida("+msg.id+")'";
			}
			inboxTable+=" src='"+src+"'></td><td>"+msg.text+"</td></tr>";
			//inboxTable+="<tr><td>"+msg.title+"</td><td>"+msg.text+"</td></tr>";
		}
		inboxTable+="</tbody></table>";
		this.inboxWindow.content.id='inboxTable';
		this.inboxWindow.content.menu=[];
		this.inboxWindow.content.innerHTML=inboxTable;
	}
	
	messenger.updateInboxWindow=function(){
		var inboxTable="<table width=100% cellpadding='0' cellspacing='0'><thead><tr><th>Titulo</th><th>Mensaje</th></thead><tbody>";
		for(var i=0;i<messenger.inbox.length;i++){
			var msg=messenger.inbox[i];
			inboxTable+="<tr><td>"+msg.title+"</td><td>"+msg.text+"</td></tr>";
		}
		inboxTable+="</tbody></table>";
		this.inboxWindow.content.innerHTML=inboxTable;
	}

	messenger.gotMessage=function(call){
		var response=call.responseXML;
		if(!MSIE){
			response=response.firstChild;
		}else{
			response=response.childNodes[1];
		}
		var cant=0;
		var txt="";
		for(var i=0;i<response.childNodes.length;i++){
			var node=response.childNodes[i];
			if(node.nodeName=="cant"){
				cant=node.firstChild.nodeValue;
			}
		}
		if(cant==messenger.checkCant){
			return null;
		}else if(cant<messenger.checkCant){
			messenger.checkCant=cant;
			return null;
		}
		var newMsgCant=cant-messenger.checkCant;
		messenger.checkCant=cant;
		var advise=deskTop.notify("Se recibieron:"+newMsgCant+" mensajes");
		advise.onclick=function(){messenger.openInbox();}
		setTimeout("deskTop.closeNotification('"+advise.id+"');",2000);
		//this.updateInboxWindow();
	}
	messenger.setRefreshRate=function(time){
		messenger.refreshRate=(time*60);
		messenger.updater.stop();
		messenger.updater=new Ajax.PeriodicalUpdater("messenger2", (messagesURL+"&checkCant=true"), {asynchronous:true, frequency:messenger.refreshRate, onSuccess:function(call){messenger.gotMessage(call)}, onException:function(e){ }  });
	}
	messenger.updater=new Ajax.PeriodicalUpdater("messenger2", (messagesURL+"&checkCant=true"), {asynchronous:true, frequency:messenger.refreshRate, onSuccess:function(call){messenger.gotMessage(call)}, onException:function(e){	}  });
}

function marcarLeida(id){
	var xml=new xmlLoader();
	xml.onload=function(root){
		messenger.openInbox();
	}
	xml.load("execution.UsrNotificationReadAction.do?action=addNotRead&caca=true&messageId="+id);
}
