function btnConf_click(){
	if (verifyRequiredObjects()) {
		document.getElementById("frmMain").action = "configuration.EnvParametersAction.do?action=change"+windowId;
		submitForm(document.getElementById("frmMain"));
	}
}

function btnExit_click(){
	splash();
}

window.onload=function() {
	if (RELOAD_STYLE) {
		window.parent.frames[0].window.location = "FramesAction.do?action=top"; //header
		window.parent.frames[2].window.location.reload(); //menu
		window.parent.frames[3].window.location.reload(); //result
		window.parent.frames[4].window.location.reload(); //hidden frame
	}
}

function splashUploadModal(caller){
	var rets = openModal("/configuration.EnvParametersAction.do?action=imgListModal",560,400);
	var doAfter=function(rets){
		var input=caller.parentNode.getElementsByTagName("INPUT")[0];
		if(rets && rets.path && rets.id){
			var path=rets.path;
			var id=rets.id;
			//caller.style.backgroundImage="url("+path+")";
			input.value="/images/uploaded/"+id;
		}else{
			input.value="";
			//caller.style.backgroundImage="url("+URL_ROOT_PATH+"/images/uploaded/procicon.png)";
		}
	}
	rets.onclose=function(){
		doAfter(rets.returnValue);
	}
	
}

function initChat() {
	var chatCmb = document.getElementById("prmtEnvChatEnable");
	var chatGrpClass = document.getElementById("prmtEnvChatGrpClass");
	chatGrpClass.disabled = chatCmb.selectedIndex == -1 || chatCmb.options[chatCmb.selectedIndex].value != "true";
}
