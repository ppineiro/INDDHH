var modalInIndex;

function changeAdmType(obj,idx){
	if(obj.value=="F"){
		document.getElementById("chkProCre"+idx).disabled=true;
		document.getElementById("chkProAlt"+idx).disabled=true;
	}else{ 
		document.getElementById("chkProCre"+idx).disabled=false;
		document.getElementById("chkProAlt"+idx).disabled=false;
	}
	
}

function btnConf_click(){
	if (verifyRequiredObjects()) {
		document.getElementById("frmMain").action = "administration.EntitiesAction.do?action=impactMer";
		try {
			submitForm(document.getElementById("frmMain"));
		} catch (e) {
			alert(e.message);
		}
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
		document.getElementById("frmMain").action = "administration.EntitiesAction.do?action=backToMer";
		submitForm(document.getElementById("frmMain"));
	}
}


function btnVerAtts_click(tableName, index){
	
	modalInIndex=index;
	var fatherNames=new Array();
	var childNames=new Array();
	var fatherCheckedHer="";
	var fatherCheckedBind="";
	var childCheckedAdm="";
	
	var grd=document.getElementById("gridList");
	var rows=grd.rows;
	var cells=rows[index].cells;
	
	var td=cells[6];
	var inputs=td.getElementsByTagName("INPUT");
	for(var i=0;i<inputs.length;i++){
		if(inputs[i].id.indexOf("father")>=0){
			fatherNames.push(inputs[i].value);
		}
	}
	
	
	td=cells[7];
	inputs=td.getElementsByTagName("INPUT");
	for(var i=0;i<inputs.length;i++){
		if(inputs[i].id.indexOf("chkBind")>=0){
			if(inputs[i].checked){
				fatherCheckedBind += fatherNames[i] + ";";
			}
		}
	}
	
	td=cells[9];
	inputs=td.getElementsByTagName("INPUT");
	for(var i=0;i<inputs.length;i++){
		if(inputs[i].id.indexOf("chkHerFrm")>=0){
			if(inputs[i].checked){
				fatherCheckedHer += fatherNames[i] + ";";
			}
		}
	}
	
	var td=cells[10];
	var inputs=td.getElementsByTagName("INPUT");
	for(var i=0;i<inputs.length;i++){
		if(inputs[i].id.indexOf("childAdm")>=0){
			childNames.push(inputs[i].value);
		}
	}
	
	td=cells[11];
	inputs=td.getElementsByTagName("INPUT");
	for(var i=0;i<inputs.length;i++){
		if(inputs[i].id.indexOf("chkAdmHij")>=0){
			if(inputs[i].checked){
				childCheckedAdm += childNames[i] + ";";
			}
		}
	}

	
	var rets = openModal("/programs/administration/entities/modalMerToEntities.jsp?tableName="+tableName+"&fatherCheckedHer="+fatherCheckedHer+"&fatherCheckedBind="+fatherCheckedBind+"&childCheckedAdm="+childCheckedAdm,480,600);
	var doLoad=function(rets){
		onModalClose(rets);
		
		
	}
	rets.onclose=function(){
		doLoad(rets.returnValue);
	}	
	
}

function onModalClose(rets){
	var grd=document.getElementById("gridList");
	var rows=grd.rows;
	var cells=rows[modalInIndex].cells;
	var hiddenAtts=cells[14].getElementsByTagName("INPUT")[0];
	hiddenAtts=rets;
	
}

function saveState(){
	
	eraseCookie("MER");
	
	var strCookie = "";
	//recorrer todos los elementos de la pagina
	
	var elements = document.getElementsByTagName("INPUT");
	var elementsCmb = document.getElementsByTagName("SELECT");
	
	
	for(var i=0;i<elementsCmb.length;i++){
		var name = elementsCmb[i].name;
		var val = elementsCmb[i].value;
		if(name && name!=null && name.length>0){
			if(strCookie.length>0){
				strCookie = strCookie + "#";
			}
			strCookie = strCookie + name + "|" + val;
		}
	}
	
	//armar string
	for(var i=0;i<elements.length;i++){
		var name = elements[i].name;
		var val = elements[i].value;
		if(elements[i].type=="checkbox"){
			val = elements[i].checked;
		}
		if(name && name!=null && name.length>0){
			if(strCookie.length>0){
				strCookie = strCookie + "#";
			}
			strCookie = strCookie + name + "|" + val;
		}
	}


	
	
	//guardar 
	
	var caller = new AjaxCall();
	caller.callUrl			= "administration.EntitiesAction.do?action=saveStatus";
	caller.callParams		= "str="+strCookie;
	caller.onBeforeCall		= function() {
		var win = window;
		while(!win.document.getElementById("iframeMessages") || !win.document.getElementById("iframeResult")){
			win=win.parent;
		}
		win.document.getElementById("iframeResult").style.visibility="hidden";
		win.document.getElementById("iframeResult").style.display="block";
		win.document.getElementById("iframeResult").doCenterFrame();
		win.document.getElementById("iframeMessages").showResultFrame(document.body);
		win.document.getElementById("iframeResult").style.visibility="visible";
	};
	caller.onErrorCall		= function() { hideResultFrame(); };
	caller.onProcessCall	= function(xml) {
		hideResultFrame();
	};
	caller.doCall();
	
	
	
	
}

function loadState(){

	
	var caller = new AjaxCall();
	caller.callUrl			= "administration.EntitiesAction.do?action=getStatus";
	caller.callParams		= "";
	caller.onBeforeCall		= function() {
		var win = window;
		while(!win.document.getElementById("iframeMessages") || !win.document.getElementById("iframeResult")){
			win=win.parent;
		}
		win.document.getElementById("iframeResult").style.visibility="hidden";
		win.document.getElementById("iframeResult").style.display="block";
		win.document.getElementById("iframeResult").doCenterFrame();
		win.document.getElementById("iframeMessages").showResultFrame(document.body);
		win.document.getElementById("iframeResult").style.visibility="visible";
	};
	caller.onErrorCall		= function() { hideResultFrame(); };
	caller.onProcessCall	= function(xml) {
		loadString(xml);
		hideResultFrame();
	};
	caller.doCall();
}	

function loadString(xml){
	
	var strCookie = "";
	
	if(xml.childNodes[0].childNodes[0].firstChild.nodeValue=="1"){
		strCookie=xml.childNodes[0].childNodes[1].firstChild.nodeValue;
	}else{
		for(x=0;x<parseInt(xml.childNodes[0].childNodes[0].firstChild.nodeValue);x++){
			strCookie+=xml.childNodes[0].childNodes[x+1].firstChild.nodeValue;
		}
	}
	
	//por cada par del cookie, buscar el elemento para setearle valor
	var pairs = strCookie.split("#");
	for(var i=0;i<pairs.length;i++){
		var arr = pairs[i].split("|");
		var name = arr[0];
		var val = arr[1];
		var eleArr = document.getElementsByName(name);
		var ele = eleArr[0];
		if (ele.type == "checkbox"){
			
			if(val=="true"){
				
				ele.checked=true;
				if(ele.nextSibling){
					if(ele.nextSibling.type=="select-one"){
						ele.nextSibling.disabled=false;
					}
				}
			}else{
				ele.checked=false;
			}
		} else {
			ele.value = val;
			fireEvent(ele,"change");
		}
	}
}
