function btnNew_click(){
	document.getElementById("frmMain").action = "configuration.StylesAction.do?action=create";
	submitForm(document.getElementById("frmMain"));
}

function btnDel_click(){
	if(document.getElementById("gridList").selectedItems.length>0){
		if(document.getElementById("gridList").selectedItems[0].getAttribute("systemStyle")!="true"){
			if (confirm(GNR_DELETE_RECORD)) {
				document.getElementById("frmMain").action = "configuration.StylesAction.do?action=remove";
				submitForm(document.getElementById("frmMain"));
			}
		}
	}else{
		alert(GNR_CHK_AT_LEAST_ONE);
	}
}


function btnDnld_click(){
	if(document.getElementById("gridList").selectedItems.length==1){
		var selected=document.getElementById("gridList").selectedItems[0];
		document.getElementById("downloadStyle").src="configuration.StylesAction.do?action=download&style="+selected.getAttribute("styleName");
	}else if(document.getElementById("gridList").selectedItems.length>1){
		alert(GNR_CHK_ONLY_ONE);
	}else{
		alert(GNR_CHK_AT_LEAST_ONE);
	}
}