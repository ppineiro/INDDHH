function btnConf_click(){
	if (verifyRequiredObjects()) {
		document.getElementById("frmMain").action = "execution.TaskReasignAction.do?action=confirm";
		submitForm(document.getElementById("frmMain"));
	}
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
		document.getElementById("frmMain").action = "execution.TaskReasignAction.do?action=backToList";
		submitForm(document.getElementById("frmMain"));
	}
}
function fncPoolChange() {
	borrarUsers();
	var poolSel = document.getElementById("cmbNewPool");
	var indiceSeleccionado = poolSel.selectedIndex;
  	if (indiceSeleccionado == 0) return;
	var opcionSeleccionada = poolSel.options[indiceSeleccionado];
	var poolId = opcionSeleccionada.value;
	var	http_request = getXMLHttpRequest();
	http_request.open('POST', "execution.TaskReasignAction.do?action=getPoolUsers", false);
	http_request.setRequestHeader("content-type","application/x-www-form-urlencoded; charset=utf-8");
    http_request.send("poolId=" + poolId);
    
     if (http_request.readyState == 4) {
            if (http_request.status == 200) {
                var users = http_request.responseText;
				if (users != "NOK" && users!="NULL"){
					var oOpt = document.createElement("OPTION");
					oOpt.value = "";
					oOpt.innerHTML = "";
					document.getElementById("cmbNewUser").appendChild(oOpt);
					while (users.indexOf(",")>-1){ //Siempre va a haber al menos una coma (usrLogin,usrName)
						var oOpt = document.createElement("OPTION");
						oOpt.value = users.substring(0,users.indexOf(","));
						users = users.substring(users.indexOf(",")+1, users.length);
						if (users.indexOf(",")>-1){
							oOpt.innerHTML = users.substring(0,users.indexOf(","));
							users = users.substring(users.indexOf(",")+1, users.length);
						}else{
							oOpt.innerHTML = users;
						}
						document.getElementById("cmbNewUser").appendChild(oOpt);
					}
				}else{
					var oOpt = document.createElement("OPTION");
					document.getElementById("cmbNewUser").appendChild(oOpt);
				}
            } else {
               	alert("Could not contact the server.");            
            }
     }
}

function borrarUsers(){
	var combo = document.getElementById("cmbNewUser");
	while (combo.options!=null && combo.options.length>0){
		combo.removeChild(combo.options[0]);
	}
}
