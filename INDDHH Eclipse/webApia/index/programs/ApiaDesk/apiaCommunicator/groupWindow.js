var GroupCallManager=new Object();
	
GroupCallManager.openGroupWindow=function(){
	if(this.groupWindow){
		this.groupWindow.bringToTop();
		return this.groupWindow;
	}
	var x=(getStageWidth()-320)/2;
	var y=(getStageHeight()-340)/2;
	this.groupWindow=openWindow({ url:"" ,width:260 , height:340 , title:(lblPool), fixedSize:true,x:x,y:y,persistable:false,icon:URL_ROOT_PATH+"/programs/ApiaDesk/styles/"+currStyle+"/images/apiaCommLogo.png" });
	
	var html="<input style='width:244px' />";
	html+="<div class='panel' style='position:relative;width:250;height:280px;'></div>";
	this.groupWindow.content.innerHTML=html;
	this.groupWindow.content.menu=[];
	this.groupWindow.userFilter=this.groupWindow.content.childNodes[0];
	this.groupWindow.list=this.groupWindow.content.childNodes[1];
	setList(this.groupWindow.list);
	
	this.groupWindow.btnSearch=this.groupWindow.content.getElementsByTagName("BUTTON")[0];
	
	this.groupWindow.userFilter.onkeyup=function(){
		GroupCallManager.groupWindow.list.filter(this.value);
	}
	
	this.groupWindow.list.onElementDoubleClicked=function(el){
		var id=el.data.id;
		//HistoryManager.getConference(id);
		comm.comm.requestConversation(id,"");
		GroupCallManager.groupWindow.close();
	}
	this.groupWindow.onclose=function(){
		GroupCallManager.groupWindow=null;
	}
	
	/*this.groupWindow.btnRefresh.onclick=function(){
		GroupCallManager.groupWindow.refresh();
	}*/
	this.groupWindow.refresh=function(){
		/*var tmp=this;
		var after=function(groups){
			for(var i=0;i<groups.length;i++){
				//if(tmp.chatUserId!=roster[i].id){
					tmp.list.addElement({name:groups[i].id,id:groups[i].id,icon:URL_ROOT_PATH+"/programs/ApiaDesk/styles/"+currStyle+"/images/apiacomm/groupRing.png"});
					//tmp.comm.roster.push(contact);
				//}
			}
			//tmp.comm.changeStatus(1);
			//tmp.updateRosterModel();
		}
		comm.comm.getGroups(after);*/
		var groups=comm.groupsModel;
		for(var i=0;i<groups.length;i++){
			this.list.addElement({name:groups[i].name,id:groups[i].id,icon:URL_ROOT_PATH+"/programs/ApiaDesk/styles/"+currStyle+"/images/apiacomm/groupRing.png"});
		}
	}
	
	this.groupWindow.refresh();
	
	return this.groupWindow;
}


