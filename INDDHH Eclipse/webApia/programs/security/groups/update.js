
function btnExit_click(){
	var msg = confirm(GNR_PER_DAT_ING);
	if (msg) {
		splash();
	}
}
function btnBack_click() {
	var msg = confirm(GNR_PER_DAT_ING);
	if (msg) {
		document.getElementById("frmMain").action = "security.GroupsAction.do?action=backToList";
		submitForm(document.getElementById("frmMain"));
	}
}


function chkTodEnv_change(){
	if(document.getElementById("chkTodEnv").checked == true) {
		document.getElementById("divx").style.display = "none";
	} else {
		document.getElementById("divx").style.display = "block";	
	}
}

window.onload=function(){
	try{
	chkTodEnv_change();
	}catch(e){}
}

function btnAddEnv_click() {
	var rets = openModal("/programs/modals/envs.jsp",500,300);
	var doAfter=function(rets){
		if (rets != null) {
			for (j = 0; j < rets.length; j++) {
				var ret = rets[j];
				var addRet = true;
	
				trows=document.getElementById("gridEnv").rows;
				for (i=0;i<trows.length && addRet;i++) {
					if (trows[i].getElementsByTagName("TD")[0].getElementsByTagName("INPUT")[1].value == ret[0]) {
						addRet = false;
					}
				}
				
				if (addRet) {
					var oTd0 = document.createElement("TD"); 
					var oTd1 = document.createElement("TD"); 
			
			
					oTd0.innerHTML = "<input type='checkbox' name='chkEnv'><input type='hidden' name='chkEnv'>";
					oTd0.getElementsByTagName("INPUT")[1].value = ret[0];
					oTd0.align="center";
					
					oTd1.innerHTML = ret[1];
			
					var oTr = document.createElement("TR");
					oTr.appendChild(oTd0);
					oTr.appendChild(oTd1);
					
					document.getElementById("gridEnv").addRow(oTr);
				}
			}
		}
	}
	rets.onclose=function(){
		doAfter(rets.returnValue);
	}
	/*if (window.navigator.appVersion.indexOf("MSIE")<0){
		var aux=rets.document;
		var isOpen=true;
		rets.onunload=function(event){
			event.cancelBubble=true;
			if(!isOpen){
				doAfter(rets.returnValue);
			}
			isOpen=false;
	    }
	}else{
		doAfter(rets);
	}*/	
}

function btnDelEnv_click() {
	document.getElementById("gridEnv").removeSelected();
}


function openImagePicker(caller){
	var rets = openModal("/administration.ImagesAction.do?action=picker",560,300);
	var doAfter=function(rets){
		if(rets && rets.path && rets.id){
			var path=rets.path;
			var id=rets.id;
			caller.style.backgroundImage="url("+path+")";
			caller.firstChild.value=id;
		}else{
			caller.firstChild.value="";
			caller.style.backgroundImage="url("+URL_ROOT_PATH+"/images/uploaded/poolicon.png)";
		}
	}
	rets.onclose=function(){
		doAfter(rets.returnValue);
	}
}
