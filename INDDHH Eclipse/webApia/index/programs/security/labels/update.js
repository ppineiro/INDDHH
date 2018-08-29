function btnConf_click(){
	if (verifyRequiredObjects()) {
		if(isValidName(document.getElementById("txtLblSetName").value)){
			var langs = document.getElementsByName("langId");
			var notDeleted = "";
			
			if (langs != null) {
				for (i = 0; i < langs.length; i++) {
					if (notDeleted != "") {
						notDeleted += ",";
					}
					notDeleted += "" + langs[i].value;
				}
			}
		
			document.getElementById("notDeleted").value = notDeleted;
		
			document.getElementById("frmMain").target = "";
			document.getElementById("frmMain").action = "security.LabelsAction.do?action=confirm";
			submitForm(document.getElementById("frmMain"));
		}	
	}
}

function btnUpload_click(){
	if (verifyFile()) {
	
		var langs = document.getElementsByName("langId");
		var notDeleted = "";
		
		if (langs != null) {
			for (i = 0; i < langs.length; i++) {
				if (notDeleted != "") {
					notDeleted += ",";
				}
				notDeleted += "" + langs[i].value;
			}
		}
	
		document.getElementById("notDeleted").value = notDeleted;
	
		document.getElementById("frmMain").target = "";
		document.getElementById("frmMain").action = "security.LabelsAction.do?action=import";
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
		document.getElementById("frmMain").target = "";
		document.getElementById("frmMain").action = "security.LabelsAction.do?action=backToList";
		submitForm(document.getElementById("frmMain"));
	}
}

function getSelected() {
	var langs = new Array();
	for(var i=0;i<document.getElementById("gridList").selectedItems.length;i++){
		var input=document.getElementById("gridList").selectedItems[i].getElementsByTagName("INPUT")[1];
		if(input.id=="langId"){
			langs.push(input);
		}
	}
	var canDelete = null;
	var cant = 0;
	var selected = null;
	
	if (langs != null) {
		for (i = 0; i < langs.length; i++) {
			cant ++;
			selected = langs[i].value;
		}
	}
	return (cant == 1)?selected:null;
}


function btnDel_click() {
	for(var i=0;i<document.getElementById("gridList").selectedItems.length;i++){
		if(document.getElementById("gridList").selectedItems[i].getAttribute("canRemove")!="true"){
			return false;
		}
	}
	
	document.getElementById("gridList").removeSelected();
}

function btnDown_click(){
	var selected = getSelected();
	if (selected != null) {	
		var rets = openModal("/programs/modals/export.jsp?hiddeHtml=true&hiddeTXT=true&hiddePdf=true&hiddeXPDL=true&hiddeCount=true",500,220);
		var doAfter=function(rets){
			if (rets != null) {
				if (rets[0] == "excel") {
					document.getElementById("frmMain").action = "security.LabelsAction.do?action=downloadXls&langId=" + selected;
				} else if (rets[0] == "csv") {
					document.getElementById("frmMain").action = "security.LabelsAction.do?action=downloadTxt&langId=" + selected;
				}
		
				document.getElementById("frmMain").target = "idResult";
				document.getElementById("frmMain").submit();
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
	} else {
		alert(GNR_CHK_AT_LEAST_ONE);
	}
}

function verifyFile() {
	var txtUpload = document.getElementById("frmMain").txtUpload;
	if (txtUpload.value == "") {
		return false;
	}

	var badXls = txtUpload.value.lastIndexOf(".xls") == -1 || (txtUpload.value.lastIndexOf(".xls") + 4) != txtUpload.value.length;
	var badCsv = txtUpload.value.lastIndexOf(".csv") == -1 || (txtUpload.value.lastIndexOf(".csv") + 4) != txtUpload.value.length;
	var badTxt = txtUpload.value.lastIndexOf(".txt") == -1 || (txtUpload.value.lastIndexOf(".txt") + 4) != txtUpload.value.length

	if (badXls && badCsv && badTxt) {
		return false;
	}
	
	return true;
}