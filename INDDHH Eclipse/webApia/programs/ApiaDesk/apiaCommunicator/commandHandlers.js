function PostitCommandHanlder(){
	this.name="PostitCommand";
	this.runCommand=function(command){
		createPostit(command.postitText);
	}
}

function URLCommandHanlder(){
	this.name="URLCommand";
	this.runCommand=function(command){
		openWindow({ url:command.url ,width:500 , height:300 , title:("URL:"+command.url), fixedSize:false, persistable:false});
	}
}

function SendTaskCommandHanlder(){
	this.name="SendTaskCommand";
	this.runCommand=function(command){
		var url="execution.TasksListAction.do?action=work&workMode=R&proInstId="+command.proInstId+"&proEleInstId="+command.proEleInstId
		openWindow({ url:url ,width:500 , height:300 , title:("WORKING"), fixedSize:false });
	}
}


/*function PostitCommandHanlder(){
	this.name="PostitCommandHanlder";
	this.runCommand=function(command){
		createPostit(command.postitText);
	}
}*/