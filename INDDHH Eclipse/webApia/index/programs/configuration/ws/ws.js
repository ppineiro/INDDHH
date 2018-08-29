function selectUsers(inputName){
	var input = document.getElementById(inputName);

	var arr = input.value.split(",");
	var reqData = "";
	for(i=0;i<arr.length;i++){
		if(i!=0){
			reqData += "&"
		}
		reqData += "reqData=" + arr[i];
	}
	var rets = openModal("/programs/configuration/ws/users.jsp?"+reqData,500,300);
	var doLoad=function(rets){
	 	input.value = "";
		if (rets != null) {
			for (j = 0; j < rets.length; j++) {
				var ret = rets[j];
				if(j!=0){
					input.value += ",";
				}
				input.value += ret  
			}
		}
	}
	rets.onclose=function(){
		doLoad(this.returnValue);
	}
}


function btnUnPub_click(envId, pubId){
	document.getElementById("frmMain").action = "configuration.WsAction.do?action=unpublish&envId="+envId + "&pubId="+pubId;
	submitForm(document.getElementById("frmMain"));
}

function btnPub_click(envId, pubId, index){
 
	var wss = document.getElementById("chkWss"+index).checked;
 	var wssUser = document.getElementById("txtUsu"+index).value;
	document.getElementById("frmMain").action = "configuration.WsAction.do?action=publish&envId="+envId + "&pubId="+pubId + "&wss=" + wss + "&wssUser=" + wssUser;
	submitForm(document.getElementById("frmMain"));
}

function btnUnPubDeleted_click(pubName){
	document.getElementById("frmMain").action = "configuration.WsAction.do?action=unpublishDeleted&wsName="+pubName ;
	submitForm(document.getElementById("frmMain"));
}

function btnUnPubAll_click(){
	document.getElementById("frmMain").action = "configuration.WsAction.do?action=unpublishAll";
	submitForm(document.getElementById("frmMain"));
}


function chkWSSClick(obj,index){
	if(obj.checked){
		document.getElementById("txtUsu"+index).disabled = false;
	} else {
		document.getElementById("txtUsu"+index).disabled = true;
	}
}