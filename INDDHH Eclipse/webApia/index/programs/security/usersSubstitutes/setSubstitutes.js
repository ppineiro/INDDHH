function btnAddProfile_click(){
	var cant = chksChecked(document.getElementById("gridUserSubstitutes"));
	if(cant != 0) {
		var login = document.getElementById("txtLog").value;
		var selected = document.getElementById("gridUserSubstitutes").selectedItems;
		if(login!=null && !login==""){
			var rets = openModal("/programs/security/usersSubstitutes/modals/profiles.jsp?usrLogin="+login+"",500,300);
			var sel = selected[0];
			var doLoad=function(rets, sel){
				var pool = 	sel.getElementsByTagName("INPUT")[1].value;
				if (rets != null) {
					profileIds = new Array();
					profileNames = new Array();
					var i=0;
					for (j = 0; j < rets.length; j++) {
						var ret = rets[j];
						if(ret!=null){	
							profileIds[i] = ret[0];
							profileNames[i]= ret[1];
							i++;
						}
					}
					document.getElementById("frmMain").action = "security.UserSubstituteAction.do?action=addProfile&profiles=" + profileIds + "&prfNames="+profileNames +"&poolId=" + pool;
					submitForm(document.getElementById("frmMain"));
				}
			}
			rets.onclose=function(){
				doLoad(rets.returnValue, sel);
			}
		}
	} else {
		alert(GNR_CHK_AT_LEAST_ONE);
	}
}


function btnConf_click(){
	if (verifyRequiredObjects()) {
		document.getElementById("frmMain").action = "security.UserSubstituteAction.do?action=confirm";
		submitForm(document.getElementById("frmMain"));
	}
}


function btnExit_click(fromList){
	if(!fromList){
		var msg = confirm(GNR_PER_DAT_ING);
		if (msg) {
			splash();
		}
	}
	else{
		splash();
	}
}

function btnBack_click() {
	var msg = confirm(GNR_PER_DAT_ING);
	if (msg) {
		document.getElementById("frmMain").action = "security.UserSubstituteAction.do?action=backToList";
		submitForm(document.getElementById("frmMain"));
	}
}

function btnDel_click(){
	var cant = chksChecked(document.getElementById("gridUserSubstitutes"));
	if(cant != 0) {
		var selected = document.getElementById("gridUserSubstitutes").selectedItems;
		if (selected != null) {
			var sel = selected[0];
			var pool = 	sel.getElementsByTagName("INPUT")[1].value;
			var rets = openModal("/programs/security/usersSubstitutes/modals/substitutes.jsp?poolId="+ pool +"",500,300);
			var doLoad=function(rets, pool){
				if (rets != null) {
					substitutes = new Array();
					var i=0;
					for (j = 0; j < rets.length; j++) {
						var ret = rets[j];	
						if(ret!=null){		
							substitutes[i] = ret[0];
							i++;
						}
					}
					document.getElementById("frmMain").action = "security.UserSubstituteAction.do?action=remove&poolId=" +pool + "&substitutesToRemove=" + substitutes;
					submitForm(document.getElementById("frmMain"));
				}
			}
			rets.onclose=function(){
				doLoad(rets.returnValue, pool);
			}
		}
	} else {
		alert(GNR_CHK_AT_LEAST_ONE);
	}
}


function getUser(){
	var usrLogin = document.getElementById("txtLog").value;
	var startDate = document.getElementById("txtDteFrom").value;
	var endDate = document.getElementById("txtDteTo").value;
	
	if(document.getElementById("txtDteFrom").unMaskedText=="" && document.getElementById("txtDteTo").unMaskedText==""){
		return;
	}
	if(verifyDates() && usrLogin != null){
		document.getElementById("frmMain").action = "security.UserSubstituteAction.do?action=getUser&usrLogin=" + document.getElementById("txtLog").value;
		submitForm(document.getElementById("frmMain"));
	}
}

function verifyDates(){
var startDate = document.getElementById("txtDteFrom").value;
var endDate = document.getElementById("txtDteTo").value;
if(document.getElementById("txtDteFrom").unMaskedText!="" && document.getElementById("txtDteTo").unMaskedText!=""){
	var arrSD = new Array();
	var arrED = new Array();

	arrSD = startDate.split("/");
	arrED = endDate.split("/");
	var endYear= arrED[2];
	var endMonth=arrED[1];
	var endDay=arrED[0];
	var startYear=arrSD[2];
	var startMonth=arrSD[1];
	var startDay=arrSD[0];
	
	if (endYear < startYear){
	 // comparo años
	  alert(MSGFECFINMAYFECINI);
  
	  document.getElementById("txtDteFrom").clear();
	  document.getElementById("txtDteTo").clear();
	  
	  return false;
	}else {
	  if (endYear==startYear && endMonth < startMonth) {
		// comparo meses
		alert(MSGFECFINMAYFECINI);
		document.getElementById("txtDteFrom").clear();
	  	document.getElementById("txtDteTo").clear();
	  	return false;
		} else {
			if(endYear==startYear && endMonth== startMonth && endDay < startDay){ 
				// si los meses son iguales fecha1 debe ser mayor a fecha2
				alert(MSGFECFINMAYFECINI);
				document.getElementById("txtDteFrom").clear();
	  			document.getElementById("txtDteTo").clear();
	  			return false;
			}
		}
	}
	}
	else{
		return false;
	}
	return true;
}

function btnAddPools_click(index, fromList){
	var usrLogin = document.getElementById("txtLog").value;
	trows=document.getElementById("gridUserSubstitutes").rows;
	var substituteLogin = trows[index-1].getElementsByTagName("INPUT")[1].value;
	var rets = openModal("/programs/security/usersSubstitutes/modals/pools.jsp?usrLogin="+usrLogin+"&substituteLogin="+substituteLogin+"&fromList="+fromList+"",500,350);
	var doLoad=function(rets){
			if (rets != null) {
				pools = new Array();
				var i=0;
				for (j = 0; j < rets.length; j++) {
					var ret = rets[j];	
					if(ret!=null){		
						pools[i] = ret[0];
						i++;
					}
				}
				if(!fromList){
					document.getElementById("frmMain").action = "security.UserSubstituteAction.do?action=setSubstitutePools&substituteLogin=" + substituteLogin + "&substitutePools="+ pools;
					submitForm(document.getElementById("frmMain"));
				}
			}
		}
		rets.onclose=function(){
			doLoad(rets.returnValue);
		}
}

function btnDelProfile_click(){
	var cant = chksChecked(document.getElementById("gridUserSubstitutes"));
	if(cant != 0) {
		var selected = document.getElementById("gridUserSubstitutes").selectedItems;
		if (selected != null) {
			var sel = selected[0];
			var pool = 	sel.getElementsByTagName("INPUT")[1].value;
			var rets = openModal("/programs/security/usersSubstitutes/modals/profilesToDelete.jsp?poolId="+ pool +"",500,300);
			var doLoad=function(rets, pool){
				if (rets != null) {
					profiles = new Array();
					var i=0;
					for (j = 0; j < rets.length; j++) {
						var ret = rets[j];	
						if(ret!=null){		
							profiles[i] = ret[0];
							i++;
						}
					}
					document.getElementById("frmMain").action = "security.UserSubstituteAction.do?action=removeProfiles&poolId=" +pool + "&profilesToRemove=" + profiles;
					submitForm(document.getElementById("frmMain"));
				}
			}
			rets.onclose=function(){
				doLoad(rets.returnValue, pool);
			}
		}
	} else {
		alert(GNR_CHK_AT_LEAST_ONE);
	}
}



