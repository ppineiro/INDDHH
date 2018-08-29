var selected = null;
var cantSelected = 0;

function clickChk(obj) {
	if (obj.checked){
		cantSelected ++;
	}else{
		cantSelected --;
	}
	
	selected = obj;
	document.getElementById("btnDel").disabled = ! obj.checked;
	document.getElementById("btnUpd").disabled = false;
	clearData();

	document.getElementById("cmbTyp").disabled=false;

	if(obj.checked==false){
		return;
	}
	
	selectOneChk(obj);
	cantSelected=(cantSelected>0)?1:0;

	document.getElementById("txtNom").value 		= obj.getAttribute("node_name");
	document.getElementById("txtUrl").value 		= obj.getAttribute("node_url");	
	document.getElementById("txtToolTip").value	= obj.getAttribute("node_tooltip");	
	document.getElementById("cmbTyp").value		= obj.getAttribute("node_type");	
	document.getElementById("cmbFather").value	= obj.getAttribute("node_father_id");
	document.getElementById("hidFncId").value		= obj.getAttribute("node_id");
	document.getElementById("txtOrd").value		= obj.getAttribute("node_sibling_id");
	document.getElementById("cmbOpen").value		= obj.getAttribute("node_open");
	document.getElementById("hidFncGlobal").value	= obj.getAttribute("node_global");

	if (document.getElementById("hidFncGlobal").value == "1" && ! ADM_GLOBAL) {
		if (obj.getAttribute("node_group") != 4 ){ //Si no fue creada por el usuario		
			document.getElementById("txtNom").readOnly = true;
			document.getElementById("txtNom").className = "txtReadOnly";
			
			document.getElementById("txtToolTip").readOnly = true;
			document.getElementById("txtToolTip").className = "txtReadOnly";

			document.getElementById("txtUrl").readOnly = true;
			document.getElementById("txtUrl").className = "txtReadOnly";
		}
		
		document.getElementById("cmbOpen").parentNode.style.display = "none";
		document.getElementById("txtOpen").value = document.getElementById("cmbOpen").options[document.getElementById("cmbOpen").selectedIndex].text
		document.getElementById("txtOpen").parentNode.style.display = "block";

		document.getElementById("cmbFather").style.display = "none";
		try{
			document.getElementById("txtFather").value = document.getElementById("cmbFather").options[document.getElementById("cmbFather").selectedIndex].text
		}catch(e){
			document.getElementById("txtFather").value = "";
		}

		document.getElementById("txtFather").style.display = "block";

		document.getElementById("txtTyp").value = document.getElementById("cmbTyp").options(document.getElementById("cmbTyp").selectedIndex).text
		document.getElementById("txtTyp").parentNode.style.display = "block";
		document.getElementById("cmbTyp").parentNode.style.display = "none";
		unsetRequiredField(document.getElementById("cmbTyp"));
 	
	 	if (obj.getAttribute("node_group") != 4 ){ //Si no fue creada por el usuario
			document.getElementById("txtOrd").readOnly	= true;
			document.getElementById("txtOrd").className	= "txtReadOnly";
		
			document.getElementById("btnUpd").disabled = true;
			document.getElementById("btnDel").disabled = true;
		}
		
	} else if(obj.getAttribute("node_type") == "F" || obj.getAttribute("node_group") != 4 ){
	 	if (obj.getAttribute("node_group") != 4 ){ //Si no fue creada por el usuario		
			document.getElementById("txtNom").readOnly = true;
			document.getElementById("txtNom").className = "txtReadOnly";
			
			document.getElementById("txtToolTip").readOnly = true;
			document.getElementById("txtToolTip").className = "txtReadOnly";
	
			document.getElementById("txtUrl").readOnly = true;
			document.getElementById("txtUrl").className = "txtReadOnly";
		}
		document.getElementById("cmbOpen").parentNode.style.display = "none";
		document.getElementById("txtOpen").value = document.getElementById("cmbOpen").options[document.getElementById("cmbOpen").selectedIndex].text
		document.getElementById("txtOpen").parentNode.style.display = "block";

		if (! obj.getAttribute("node_dw") || obj.getAttribute("node_father_id") == ADM_FNC_FATHER) {
			document.getElementById("cmbFather").style.display = "none";
			try{
				document.getElementById("txtFather").value = document.getElementById("cmbFather").options(document.getElementById("cmbFather").selectedIndex).text
			}catch(e){
				document.getElementById("txtFather").value = "";
			}
			document.getElementById("txtFather").style.display = "block";
		}

		document.getElementById("txtTyp").value = document.getElementById("cmbTyp").options[document.getElementById("cmbTyp").selectedIndex].text
		document.getElementById("txtTyp").parentNode.style.display = "block";
		document.getElementById("cmbTyp").parentNode.style.display = "none";
		unsetRequiredField(document.getElementById("cmbTyp"));
	} 
	
 	if (obj.getAttribute("node_group") != 4 ){ //Si no fue creada por el usuario
		document.getElementById("cmbTyp").disabled=true;
	}
 
}


function btnDW_click(){
	var rets = null;
	rets = openModal("/security.FunctionalityAction.do?action=dwModal",500,300);
	var doAfter=function(rets){
		if(rets != null) {
			var ret = rets[0];
			var strReq = "";
			strReq += "&dwName=" + ret[0];
			strReq += "&dwDesc=" + ret[1];
		
			document.getElementById("frmMain").action = "security.FunctionalityAction.do?action=dwAdd" + strReq;
			submitForm(document.getElementById("frmMain"));
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

function clearData() {
	document.getElementById("txtNom").value 		= "";
	document.getElementById("txtNom").readOnly 	= false;
	document.getElementById("txtNom").className 	= "";
	setRequiredField(document.getElementById("txtNom"));

	document.getElementById("txtUrl").value 		= "";
	document.getElementById("txtUrl").readOnly	= false;
	document.getElementById("txtUrl").className	= "";
	unsetRequiredField(document.getElementById("txtUrl"));
	
	document.getElementById("txtToolTip").value	= "";
	document.getElementById("txtToolTip").readOnly	= false;
	document.getElementById("txtToolTip").className	= "";

	document.getElementById("cmbTyp").value		= "";
	document.getElementById("txtTyp").parentNode.style.display = "none";	
	document.getElementById("cmbTyp").parentNode.style.display = "block";
	setRequiredField(document.getElementById("cmbTyp"));
	
	document.getElementById("cmbFather").value	= "";
	
	document.getElementById("hidFncId").value		= "";
	
	document.getElementById("txtOrd").value		= "";
	document.getElementById("txtOrd").readOnly	= false;
	document.getElementById("txtOrd").className	= "";
	setRequiredField(document.getElementById("txtOrd"));
	
	document.getElementById("txtOpen").parentNode.style.display	= "none";
	document.getElementById("cmbOpen").parentNode.style.display	= "block";
	setRequiredField(document.getElementById("cmbOpen"));
	
	document.getElementById("cmbFather").style.display = "block";
	document.getElementById("txtFather").style.display = "none";
}

function selectSelected(id){
	var element;
	var checks=document.getElementsByTagName("INPUT");
	for(var i=0;i<checks.length;i++){
		if(checks[i].type=="checkbox" && checks[i].getAttribute("node_id")==id){
			checks[i].checked=true;
			clickChk(checks[i]);
		}
	}
}

function btnDep_click(){
	
	if(cantSelected == 1) {
		document.getElementById("frmMain").action = "security.FunctionalityAction.do?action=viewDeps";
		submitForm(document.getElementById("frmMain"));	
	} else if (cantSelected > 1) {
		alert(GNR_CHK_ONLY_ONE_FUNC);
	} else {
		alert(GNR_CHK_AT_LEAST_ONE_FUNC);
	}
	
}

function btnNew_click(){
	if (selected != null) {
		selected.checked = false;
		clickChk(selected);
	}
	clearData();
}
function btnUpd_click(){
	if (verifyRequiredObjects()) {
		//if(isValidName(document.getElementById("txtNom").value)){
			document.getElementById("cmbTyp").disabled=false;
			document.getElementById("frmMain").action = "security.FunctionalityAction.do?action=update";
			submitForm(document.getElementById("frmMain"));
		//}	
	}
}
function btnDel_click(){
	document.getElementById("frmMain").action = "security.FunctionalityAction.do?action=remove";
	submitForm(document.getElementById("frmMain"));
}

function btnExit_click(){
	splash();
}

function btnConf_click() {
	document.getElementById("cmbTyp").disabled=false;
	document.getElementById("frmMain").action = "security.FunctionalityAction.do?action=confirm";
	submitForm(document.getElementById("frmMain"));
}
