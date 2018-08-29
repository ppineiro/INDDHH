function btnConf_click(){
	if (verifyRequiredObjects()) {
			document.getElementById("frmMain").action = "security.UserAction.do?action=confirm";
			submitForm(document.getElementById("frmMain"));
	}
}
function chkNotActOnClick(obj){
	if(obj.checked != null && obj.checked == true){
		document.getElementById('txtBlockDesc').className='';
		document.getElementById('txtBlockDesc').disabled=false;
		setRequiredField(document.getElementById('txtBlockDesc'));
	} else {
		document.getElementById('txtBlockDesc').className='txtReadOnly';
		document.getElementById('txtBlockDesc').disabled=true;
		document.getElementById('txtBlockDesc').value='';
		unsetRequiredField(document.getElementById('txtBlockDesc'));
	} 
}

function btnNext_click(){
	if (verifyRequiredObjects()) {
		if(LDAP_AUTH){
			if(document.getElementById("txtPwd").value == document.getElementById("txtConf").value){
				if (isGlobal && document.getElementById("chkAllEnv").checked != true && (document.getElementById("gridEnvironments").getRows().length == 0)){
					alert(MSG_USU_MUS_HAV_ENV);
				}else{
					document.getElementById("frmMain").action = "security.UserAction.do?action=step2";
					submitForm(document.getElementById("frmMain"));
				}
			} else {
				alert(MSG_PWD_DIF);
			}
		}else if(isValidLogin(document.getElementById("txtLogin").value)){
			if(document.getElementById("txtPwd").value == document.getElementById("txtConf").value){
				if (isGlobal && document.getElementById("chkAllEnv").checked != true && (document.getElementById("gridEnvironments").getRows().length == 0)){
					alert(MSG_USU_MUS_HAV_ENV);
				}else{
					document.getElementById("frmMain").action = "security.UserAction.do?action=step2";
					submitForm(document.getElementById("frmMain"));
				}
			} else {
				alert(MSG_PWD_DIF);
			}
		}
	}
}

function btnRea_click(x){
	if(x!="clone"){
		document.getElementById("frmMain").action = "security.UserAction.do?action=reactivate";
	} else {
		document.getElementById("frmMain").action = "security.UserAction.do?action=reactivateClone";	
	}
	submitForm(document.getElementById("frmMain"));
}

function btnExit_click(){
	var msg = confirm(GNR_PER_DAT_ING);
	if (msg) {
		splash();
	}
}
function btnBack_click() {
	var msg = confirm(GNR_PER_DAT_ING);
	if (msg) {
		document.getElementById("frmMain").action = "security.UserAction.do?action=backToList";
		submitForm(document.getElementById("frmMain"));
	}
}


function btnBackStep1_click() {
	document.getElementById("frmMain").action = "security.UserAction.do?action=backToStep1";
	submitForm(document.getElementById("frmMain"));
}

function chkinHierarchy() {
   if (inHierarchy && document.getElementById("chkAllEnv").checked == true){
		alert(MSG_IN_HIERARCHY);
		document.getElementById("chkAllEnv").checked = false;
   }else if (inHierarchy && document.getElementById("chkAllEnv").checked == false){
		alert(MSG_IN_HIERARCHY);
		document.getElementById("chkAllEnv").checked = true;
   }else{	
   		if(navigator.userAgent.indexOf("MSIE")>0){
			if(document.getElementById("chkAllEnv").checked == false){
				document.getElementById("divEnv").style.display = "block";
				setTimeout('document.getElementById("gridEnvironments").getElementsByTagName("TABLE")[0].style.display="block";document.getElementById("divEnv").style.display = "block";',100);
			} else {
				document.getElementById("divEnv").style.display = "none";
				setTimeout('document.getElementById("gridEnvironments").getElementsByTagName("TABLE")[0].style.display="none";document.getElementById("divEnv").style.display = "none";',100);
			}
		}else{
			if(document.getElementById("chkAllEnv").checked == false){
				document.getElementById("divEnv").style.display = "block";
			} else {
				document.getElementById("divEnv").style.display = "none";
			}
		}
	}
}

function chkAllEnvClick() {
	
	if(document.getElementById("chkAllEnv").checked == true) {
		document.getElementById("divEnv").style.display = "none";
	} else {
		if (inHierarchy){
			//alert(MSG_IN_HIERARCHY);
			//document.getElementById("chkAllEnv").checked = true;
		}else{	
			if(MSIE){
				document.getElementById("divEnv").style.display = "block";
				setTimeout('document.getElementById("gridEnvironments").getElementsByTagName("TABLE")[0].style.display="block";document.getElementById("divEnv").style.display = "block";',100);
			}else{
				document.getElementById("divEnv").style.display = "block";
			}
		}
	}
}

//window.onload=function() {
//	try{
//		chkAllEnvClick();
//	}catch(e){}
//}

function searchExt(){
	var rets = openModal("/programs/modals/users.jsp?external=true",500,300);
	var doAfter=function(rets){
		if(rets != null) {
			var ret = rets[0];
			document.getElementById("txtLogin").value = ret[0];
			document.getElementById("txtPwd").value = ret[0];
			document.getElementById("txtConf").value = ret[0];
			document.getElementById("txtName").value = ret[1];
			document.getElementById("txtEmail").value = ret[2];
			document.getElementById("txtComments").value = ret[3];
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


function btnDelProfile_click() {
	document.getElementById("gridProfiles").removeSelected();
}

function btnAddEnvironment_click() {
	var rets = openModal("/programs/modals/environments.jsp",500,300);
	var doAfter=function(rets){
		if (rets != null) {
			for (j = 0; j < rets.length; j++) {
				var ret = rets[j];
				var addRet = true;
				
				trows=document.getElementById("gridEnvironments").rows;
				for (i=0;i<trows.length && addRet;i++) {
					if (trows[i].getElementsByTagName("TD")[0].getElementsByTagName("INPUT")[1].value == ret[0]) {
						addRet = false;
					}
				}
				
				if (addRet) {
					var oTd0 = document.createElement("TD"); 
					var oTd1 = document.createElement("TD"); 
			
					oTd0.innerHTML = "<input type='hidden' name='chkEnvSel'><input type='hidden' name='chkEnv'>";
					oTd0.getElementsByTagName("INPUT")[1].value = ret[0];
					oTd0.align="center";
			
					oTd1.innerHTML = ret[1];
			
					var oTr = document.createElement("TR");
					oTr.appendChild(oTd0);
					oTr.appendChild(oTd1);
					document.getElementById("gridEnvironments").addRow(oTr);
				}
			}
		}
	}
	rets.onclose=function(){
		doAfter(rets.returnValue);
	}
	/*if (window.navigator.appVersion.indexOf("MSIE")<0){
		var aux=ret.document;
		var isOpen=true;
		ret.onunload=function(event){
			event.cancelBubble=true;
			if(!isOpen){
				doLoad(ret.returnValue);
			}
			isOpen=false;
	    }
    }else{
		doLoad(ret);
	}*/
}

function btnDelEnvironment_click() {
	document.getElementById("gridEnvironments").removeSelected();
}

function btnAddStyle_click() {
	var rets = openModal("/programs/modals/styles.jsp",500,300);
	var doAfter=function(rets){
		if (rets != null) {
			for (j = 0; j < rets.length; j++) {
				var ret = rets[j];
				var addRet = true;
				
				trows=document.getElementById("gridStyles").rows;
				for (i=0;i<trows.length && addRet;i++) {
					if (trows[i].getElementsByTagName("TD")[0].getElementsByTagName("INPUT")[1].value == ret[0]) {
						addRet = false;
					}
				}
				if (addRet) {
					var oTd0 = document.createElement("TD"); 
					var oTd1 = document.createElement("TD"); 
					var oTd2 = document.createElement("TD"); 
			
					oTd0.innerHTML = "<input type='hidden' name='chkStySel'><input type='hidden' name='chkSty'>";
					oTd0.getElementsByTagName("INPUT")[1].value = ret[0];
					oTd0.align="center";
			
					oTd1.innerHTML = ret[0];
					
					oTd2.innerHTML = "<input type='checkbox' name='chkSelSty' onclick='selStyle(this,\"" + ret[0] + "\")'>";
			
					var oTr = document.createElement("TR");
					oTr.appendChild(oTd0);
					oTr.appendChild(oTd1);
					oTr.appendChild(oTd2);
					document.getElementById("gridStyles").addRow(oTr);
				}
			}
		}
	}
	rets.onclose=function(){
		doAfter(rets.returnValue);
	}
	/*if (window.navigator.appVersion.indexOf("MSIE")<0){
		var aux=ret.document;
		var isOpen=true;
		ret.onunload=function(event){
			event.cancelBubble=true;
			if(!isOpen){
				doLoad(ret.returnValue);
			}
			isOpen=false;
	    }
    }else{
		doLoad(ret);
	}*/
}

function btnDelStyle_click() {
	document.getElementById("gridStyles").removeSelected();
}

function selStyle(obj,styleName){
	var chked = obj.checked;
	trows=document.getElementById("gridStyles").rows;
	for (i=0;i<trows.length;i++) {
		trows[i].getElementsByTagName("TD")[2].getElementsByTagName("INPUT")[0].checked = false;
	}
	obj.checked = chked;
	if (chked){
		document.getElementById("hidSelStyle").value = styleName;
	}else{
		document.getElementById("hidSelStyle").value = "";
	}
}

function btnAddPool_click() {
	var rets = null;
	if(isAllEnv) {
		if(isGlobal){
			rets = openModal("/programs/modals/pools.jsp?showAutogenerated=false&showGlobal=true",500,350);
		} else {
			rets = openModal("/programs/modals/pools.jsp?showAutogenerated=false&showGlobal=true&showOnlyEnv=true&envAndGlobal=true&envId="+envId,500,350);
		}
	} else {
		
		if(isGlobal){
			rets = openModal("/programs/security/users/modals/pools.jsp?a=1"+windowId,500,350);
		} else {
			rets = openModal("/programs/modals/pools.jsp?showAutogenerated=false&showGlobal=true&showOnlyEnv=true&envAndGlobal=true&envId="+envId,500,350);
		}
	}
	var doLoad=function(rets){
		if (rets != null) {
			if (rets != null) {
				for (j = 0; j < rets.length; j++) {
					var ret = rets[j];
					var addRet = true;
					trows=document.getElementById("gridPools").rows;
					for (i=0;i<trows.length && addRet;i++) {
						if (trows[i].getElementsByTagName("TD")[0].getElementsByTagName("INPUT")[1].value == ret[0]) {
							addRet = false;
						}
					}
					
					if (addRet) {
						var oTd0 = document.createElement("TD"); 
						var oTd1 = document.createElement("TD"); 
						var oTd2 = document.createElement("TD"); 
						
						oTd0.innerHTML = "<input type='checkbox' name='chkPoolSel'><input type='hidden' name='chkPool'>";
						oTd0.getElementsByTagName("INPUT")[1].value = ret[0];
						oTd0.align="center";
						
						if(ret[2]==1){
							oTd1.innerHTML = "<B>"+ret[1]+"</B>";			
						} else {
							oTd1.innerHTML = ret[1];			
						}
						
						oTd2.innerHTML = ret[4];		
						var oTr = document.createElement("TR");
						oTr.appendChild(oTd0);
						oTr.appendChild(oTd1);
						oTr.appendChild(oTd2);
						document.getElementById("gridPools").addRow(oTr);
						
						
						var rows = document.getElementById("gridPools").getRows();
						if(rows.length > 1) {
							var imgs1 = rows[0].getElementsByTagName('IMG');
							var imgs2 = oTr.getElementsByTagName('IMG');
							for(var k = 0; k < imgs1.length; k++) {
								if(imgs2[k] != null)
									imgs2[k].style.width = imgs1[k].style.width;
							}
						}
					}
				}
			}
		}
	}
	rets.onclose=function(){
		doLoad(rets.returnValue);
	}
	/*if (window.navigator.appVersion.indexOf("MSIE")<0){
		var aux=rets.document;
		var isOpen=true;
		rets.onunload=function(event){
			event.cancelBubble=true;
			if(!isOpen){
				doLoad(rets.returnValue);
			}
			isOpen=false;
	    }
    }else{
		doLoad(rets);
	}*/
}

function btnDelPool_click() {
	document.getElementById("gridPools").removeSelected();
}

function btnAddProfile_click() {

	var rets = null;
	
	if(isAllEnv) {
		if(isGlobal){
			rets = openModal("/programs/modals/profiles.jsp",500,300);
		} else {
			rets = openModal("/programs/modals/profiles.jsp?onlyEnv=true&envId="+envId,500,300);
		}
	} else {
		rets = openModal("/programs/security/users/modals/profiles.jsp",500,300);
	}
	var doLoad=function(rets){
		if (rets != null) {
			if (rets != null) {
				for (j = 0; j < rets.length; j++) {
					var ret = rets[j];
					var addRet = true;
					
					trows=document.getElementById("gridProfiles").rows;
					for (i=0;i<trows.length && addRet;i++) {
						if (trows[i].getElementsByTagName("TD")[0].getElementsByTagName("INPUT")[1].value == ret[0]) {
							addRet = false;
						}
					}
					
					if (addRet) {
						var oTd0 = document.createElement("TD"); 
						var oTd1 = document.createElement("TD"); 
				
						oTd0.innerHTML = "<input type='checkbox' name='chkPrfSel'><input type='hidden' name='chkPrf'>";
						oTd0.getElementsByTagName("INPUT")[1].value = ret[0];
						oTd0.align="center";
				
						if(ret[2]==1){
							oTd1.innerHTML = "<B>"+ret[1]+"</B>";			
						} else {
							oTd1.innerHTML = ret[1];			
						}
				
						var oTr = document.createElement("TR");
						oTr.appendChild(oTd0);
						oTr.appendChild(oTd1);
						document.getElementById("gridProfiles").addRow(oTr);
					}
				}
			}
		}
	}
	rets.onclose=function(){
		doLoad(rets.returnValue);
	}
	/*if (window.navigator.appVersion.indexOf("MSIE")<0){
		var aux=ret.document;
		var isOpen=true;
		ret.onunload=function(event){
			event.cancelBubble=true;
			if(!isOpen){
				doLoad(ret.returnValue);
			}
			isOpen=false;
	    }
    }else{
		doLoad(ret);
	}*/
}