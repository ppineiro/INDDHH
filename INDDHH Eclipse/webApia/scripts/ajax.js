function submitAjax(frm,frmName){
	if(validating){
		return;
	}
	frm.action=frm.action+"&ajax=true&frmName="+frmName
	frm.target = "iframeAjax";
	try {
	prepareReadOnlyToSubmit();
	} catch (e) {}
	frm.submit();
	var win=window;
	var count = 0;
	while(count < 5 && !win.document.getElementById("iframeMessages") || !win.document.getElementById("iframeResult")){
		win=win.parent;
		count ++;
		if (count == 5) win = null;
	}
	win.document.getElementById("iframeMessages").showResultFrame(document.body);
	win.document.getElementById("iframeResult").style.visibility="visible";
	if(!SHOW_WAIT_IN_EXECUTION){
		win.document.getElementById("iframeResult").style.top=(-win.document.getElementById("iframeResult").offsetHeight)+"px";
		win.document.getElementById("iframeMessages").style.top=(-win.document.getElementById("iframeMessages").offsetHeight)+"px";
	}
}


function reload(frmName){
	var scrollTop=0;
	if(document.getElementById("divContent")){
		var divContent=document.getElementById("divContent");
		scrollTop=divContent.scrollTop/(divContent.scrollHeight-divContent.offsetHeight);
	}
	if(window.frames["iframeAjax"].document.getElementById("errorTable")){
		unsetScriptBehaviors(document.getElementById(frmName));
		document.getElementById(frmName).innerHTML =  window.frames["iframeAjax"].document.getElementById("errorTable").innerHTML;
		setScriptBehaviors(document.getElementById(frmName));
	} else {
		if("all" != frmName){
			
			//corregir editores de texto
			var editorsCol2=document.getElementsByTagName("INPUT");
			for(var i=0;i<editorsCol2.length;i++){
				if(editorsCol2[i].getAttribute("isEditor")){
					tinyMCE.execCommand("mceRemoveControl", false, editorsCol2[i].id); 
				}
			} 
			unsetScriptBehaviors(document.getElementById(frmName));
			document.getElementById(frmName).innerHTML =  window.frames["iframeAjax"].document.getElementById(frmName).innerHTML;
			setScriptBehaviors(document.getElementById(frmName));
			//aca ver de refrescar todos los forms marcados ademas del actual.
			var col = document.getElementsByTagName("DIV");
			copyRemoveFromIframe();
			for(var i=0;i<col.length;i++){
				var div=col[i];
				//ver si vino el form o no.. si esta invisible, o viene
				if(div.getAttribute("ajaxRefreshable")=='true'){
					if(window.frames["iframeAjax"].document.getElementById(div.id)){
						//refrescar este div tambien
						unsetScriptBehaviors(document.getElementById(div.id));
						document.getElementById(div.id).innerHTML =  window.frames["iframeAjax"].document.getElementById(div.id).innerHTML;
						setScriptBehaviors(document.getElementById(div.id));
						//verify if the forms are hidden or visible
						//hide form
						document.getElementById(div.id).style.display = window.frames["iframeAjax"].document.getElementById(div.id).style.display;
						//hide form title
						var titleId = document.getElementById(div.id).getAttribute("titleid");
						var frmName = "";
						if(titleId != null){
							frmName = titleId.substring(9);
							document.getElementById(titleId).style.display = window.frames["iframeAjax"].document.getElementById(titleId).style.display;
						}
						if (document.getElementById(div.id).parentNode != null) {
							document.getElementById(div.id).parentNode.style.display = window.frames["iframeAjax"].document.getElementById(div.id).parentNode.style.display;
						}
						if (document.getElementById("hidFrm" + frmName + "Hidden") != null) {
							document.getElementById("hidFrm" + frmName + "Hidden").value = window.frames["iframeAjax"].document.getElementById("hidFrm" + frmName + "Hidden").value;
						}
					}else {
						titleId = document.getElementById(div.id).getAttribute("titleid");
						//si no vino lo ocultamos
						document.getElementById(div.id).style.display = "none";
						//hide form title
						document.getElementById(titleId).style.display = "none";
						
					}
				}
			}
			//actualizar documentos de entidad
			try{
				if(document.getElementById("docGridentity")){
					unsetScriptBehaviors(document.getElementById("docGridentity").parentNode);
					document.getElementById("docGridentity").innerHTML =  window.frames["iframeAjax"].document.getElementById("docGridentity").innerHTML;
					setScriptBehaviors(document.getElementById("docGridentity").parentNode);
				}
			}catch(e){}
		} 
		 
		 
		//errorText is in the form when an error has raised
		if(window.frames["iframeAjax"].document.getElementById("errorText")){
			var errorText = window.frames["iframeAjax"].document.getElementById("errorText").value;
			try {  
				window.parent.parent.document.getElementById("iframeMessages").showMessage(errorText, document.body);
			} catch (e) {
				str = errorText;
				if (str.indexOf("</PRE>") != null) {
					str = str.substring(5,str.indexOf("</PRE>"));
				}
				alert(str);
			}
		} else {
		   try {
			   hideResultFrame();
		   } catch (e) {} 
		}
	}
	
	submitPerformed = false;
	
	//reset the script behaviors
	// reloadScriptBehaviors();
	//clearRequired();
	//setScriptBehaviors("true");
	//align the tables and other elements
	setPageOverFlow();
	sizeMe();
	
	//ver editores de texto
	var editorsCol=document.getElementsByTagName("INPUT");
	for(var i=0;i<editorsCol.length;i++){
		if(editorsCol[i].id!="" && document.getElementById(editorsCol[i].id).getAttribute("isEditor")){
			window.setTimeout("try{ var inputName = \""+ editorsCol[i].id+"\"; correctTxtArea(inputName);}catch(e){}",1);
		}
	}
	if(document.getElementById("divContent")){
		document.getElementById("divContent").style.display="none";
		setTimeout(("var divContent=document.getElementById('divContent');divContent.style.display='block';divContent.scrollTop="+scrollTop+"*(divContent.scrollHeight-divContent.offsetHeight);setFirstFocus();fixGridsHeader();"),200);
	}
}

function correctTxtArea(inputName){
	tinyMCE.execCommand("mceAddControl", false, inputName); 
}


function copyRemoveFromIframe(){	
	var htmlDIVS = document.getElementsByTagName("DIV");
	var iFrameDIVS = window.frames["iframeAjax"].document.getElementsByTagName("DIV");
	//se remueven los formularios ocultos	
	removeHiddens(htmlDIVS, iFrameDIVS);
	//Se agregan los formularios visibles que no estaban previamente
	insertVisibles(htmlDIVS, iFrameDIVS);
}

//para cada div del html, si no lo encuentra en el frame lo borra
function removeHiddens(htmlDIVS, iFrameDIVS){
	for(var i=0;i<htmlDIVS.length;i++){
		var divHtml=htmlDIVS[i];
		if(divHtml.getAttribute("ajaxRefreshable")=='true'){
			var found = false;
			var content = divHtml.parentNode.parentNode.id;
			for(var j=0; j<iFrameDIVS.length && !found;j++){ 
				var iFrameHtml = iFrameDIVS[j];
				if(divHtml.id == iFrameHtml.id){
					found = true;
				}
			}
			if(!found){
				var titleId = document.getElementById(divHtml.id).getAttribute("titleid");
				if (document.getElementById(content) == null) continue;
				document.getElementById(content).removeChild(document.getElementById(titleId));
				document.getElementById(content).removeChild(divHtml.parentNode);			
				unsetScriptBehaviors(divHtml.parentNode);
				var frmName = titleId.substring(9);
				var frmId = divHtml.parentNode.id.substring(6,10);
				if(document.getElementById("hidFrm" + frmId + "Closed")!=null){
					unsetScriptBehaviors(document.getElementById("hidFrm" + frmId + "Closed"));
					document.getElementById(content).removeChild(document.getElementById("hidFrm" + frmId + "Closed"));
				}
				if (document.getElementById("hidFrm" + frmName + "Hidden") != null) {
					unsetScriptBehaviors(document.getElementById("hidFrm" + frmName + "Hidden"));
					document.getElementById(content).removeChild(document.getElementById("hidFrm" + frmName + "Hidden"));
				}
				
			}
		}
	}
}


//para cada div del frame, si no lo encuentra en el html, lo agrega
function insertVisibles(htmlDIVS, iFrameDIVS){
	for(var i=0;i<iFrameDIVS.length;i++){
		var iFrameHtml=iFrameDIVS[i];
		if(iFrameHtml.getAttribute("ajaxRefreshable")=='true'){
			var found = false;
			for(var j=0; j<htmlDIVS.length && !found;j++){ 
				var divHtml = htmlDIVS[j];
				var content = divHtml.parentNode.id;
				if(divHtml.id == iFrameHtml.id){
					iFrameHtml.parentNode.parentNode.setAttribute("order",divHtml.parentNode.parentNode.getAttribute("order"));
					found = true;
				}
			}
			if(!found){
				var IFtabSet=iFrameHtml.parentNode.parentNode.parentNode;
				for(var ts=0;ts<iFrameDIVS.length;ts++){
					if(iFrameDIVS[ts].id=="samplesTab"){
						IFtabSet=iFrameDIVS[ts];
						break;						
					}
				}
				var tabSet=document.getElementById("samplesTab");
				
				var tabs=tabSet.tabs;
				var IFtabs=new Array();
				
				for(var ts=0;ts<IFtabSet.childNodes.length;ts++){
					if(IFtabSet.childNodes[ts].tagName=="DIV" && IFtabSet.childNodes[ts].getAttribute("type")=="tab"){
						IFtabs.push(IFtabSet.childNodes[ts]);
					}
				}
				
				for(var c=0;c<IFtabs.length;c++){
					if(IFtabs[c]==iFrameHtml.parentNode.parentNode.parentNode){
						//content="content"+(tabCount-(IFtabSet.childNodes.length-tabSet.childNodes.length));
						content="content"+c;
					}
				}
			}
			if(!found && content!=null){
				var titleId = window.frames["iframeAjax"].document.getElementById(iFrameHtml.id).getAttribute("titleid");
				var parentId = iFrameHtml.parentNode.id;			
				var frmName = titleId.substring(9);
				var frmId = parentId.substring(6,10);
				fixAjaxScriptsById(frmId);
				var next="";
				var actual=iFrameHtml.parentNode.nextSibling;	
				while(actual && next==""){
					if(actual.tagName=="DIV" && actual.id!=""){
						next=actual.id;
					}
					actual=actual.nextSibling;
				}
				
				var formDiv=document.createElement("DIV");
				formDiv.setAttribute("type","form");
				var formorder=iFrameHtml.parentNode.parentNode.getAttribute("formorder");
				formDiv.setAttribute("formorder",formorder);
				
				if(MSIE){//internet explorer
					var tit = document.createElement("DIV");
					tit.setAttribute("id", titleId);
					tit.innerHTML = window.frames["iframeAjax"].document.getElementById(titleId).outerHTML;
					if(!document.getElementById(content) && document.getElementById(next) || (document.getElementById(content) && document.getElementById(next) && document.getElementById(content)!=document.getElementById(next).parentNode)){
						content=document.getElementById(next).parentNode.id;
					}
					var div = document.createElement("DIV");
					div.setAttribute("id", iFrameHtml.parentNode.id);
					div.innerHTML = window.frames["iframeAjax"].document.getElementById(iFrameHtml.id).outerHTML;
					
					formDiv.appendChild(tit);
					
					if(window.frames["iframeAjax"].document.getElementById("hidFrm" + frmId + "Closed") != null){
						var closed = document.createElement("input");
						var type = window.frames["iframeAjax"].document.getElementById("hidFrm" + frmId + "Hidden").getAttribute("type");
						var value = window.frames["iframeAjax"].document.getElementById("hidFrm" + frmId + "Hidden").getAttribute("value");
						var name = window.frames["iframeAjax"].document.getElementById("hidFrm" + frmId + "Hidden").getAttribute("name");
						closed.setAttribute("id", "hidFrm" + frmId + "Closed");
						closed.setAttribute("type", type);
						closed.setAttribute("value", value);
						closed.setAttribute("name", name);
						formDiv.appendChild(closed);
					}
					if (window.frames["iframeAjax"].document.getElementById("hidFrm" + frmName + "Hidden") != null) {
						var hid = document.createElement("input");
						var type = window.frames["iframeAjax"].document.getElementById("hidFrm" + frmName + "Hidden").getAttribute("type");
						var value = window.frames["iframeAjax"].document.getElementById("hidFrm" + frmName + "Hidden").getAttribute("value");
						var name = window.frames["iframeAjax"].document.getElementById("hidFrm" + frmName + "Hidden").getAttribute("name");
						hid.setAttribute("id", "hidFrm" + frmName + "Hidden");
						hid.setAttribute("type", type);
						hid.setAttribute("value", value);
						hid.setAttribute("name", name);
						formDiv.appendChild(hid);
					}
					formDiv.appendChild(div);
				}
				
				else{
					divClone = iFrameHtml.parentNode.cloneNode(true);
					titClone = window.frames["iframeAjax"].document.getElementById(titleId).cloneNode(true);
					if(!document.getElementById(content) && document.getElementById(next) || (document.getElementById(content) && document.getElementById(next) && document.getElementById(content)!=document.getElementById(next).parentNode)){
						content=document.getElementById(next).parentNode.id;
					}
					formDiv.appendChild(titClone);
					if(window.frames["iframeAjax"].document.getElementById("hidFrm" + frmId + "Closed") != null){
						cloClone = window.frames["iframeAjax"].document.getElementById("hidFrm" + frmId + "Closed").cloneNode(true);
						formDiv.appendChild(cloClone);
					}
					if (window.frames["iframeAjax"].document.getElementById("hidFrm" + frmName + "Hidden") != null) {
						hidClone = window.frames["iframeAjax"].document.getElementById("hidFrm" + frmName + "Hidden").cloneNode(true);
						formDiv.appendChild(hidClone);
					}
					formDiv.appendChild(divClone);
					
				}
				
				if(next!="" && document.getElementById(next)){
					document.getElementById(content).insertBefore(formDiv,document.getElementById(next));
				}else{
					document.getElementById(content).appendChild(formDiv);
				}
				sortFormsByOrder(document.getElementById(content));
			}
		}
	}
}

function sortFormsByOrder(formContainer){
	var forms=new Array();
	for(var i=0;i<formContainer.childNodes.length;i++){
		if(formContainer.childNodes[i].tagName=="DIV" && formContainer.childNodes[i].getAttribute("type")=="form"){
			forms.push(formContainer.childNodes[i]);
		}
	}
	forms.sort(function(a,b){
		//return parseInt(b.getAttribute("order")) - parseInt(a.getAttribute("order"))
		return parseInt(b.getAttribute("formorder")) - parseInt(a.getAttribute("formorder"))
	});
	for(var i=0;i<forms.length;i++){
		formContainer.insertBefore(forms[i],formContainer.firstChild);
	}
}

function fixAjaxScriptsById(id){
	var ifrScripts=window.frames["iframeAjax"].document.getElementsByTagName("SCRIPT");
	var docScripts=document.getElementsByTagName("SCRIPT");
	var scripts=new Array();
	for(var i=0;i<ifrScripts.length;i++){
		if(id==ifrScripts[i].getAttribute("scriptId")){
			var script=ifrScripts[i].cloneNode(true);
			var actualScript=ifrScripts[i];
			if(actualScript.src){
				script=document.createElement("SCRIPT");
				script.setAttribute("language","javascript");
				script.setAttribute("scriptId",ifrScripts[i].getAttribute("scriptId"));
				script.src=ifrScripts[i].src;
			}else{
				actualScript.id="workingScript";
				var div=document.createElement("DIV");
				var html=actualScript.parentNode.innerHTML;
				document.body.appendChild(div);
				while(html.indexOf("DEFER")>0){
					html=html.split("DEFER").join("");
				}
				div.innerHTML=html;
				actualScript.id="";
				for(var s=0;s<div.getElementsByTagName("SCRIPT").length;s++){
					if(div.getElementsByTagName("SCRIPT")[s].id=="workingScript"){
						script=div.getElementsByTagName("SCRIPT")[s];
						script.id="";
					}
				}
				document.body.removeChild(div);
			}
			script.removeAttribute("DEFER");
			script.defer=false;
			var scr=document.createElement("SCRIPT");
			scr.language="javascript";
			scr.text=script.innerHTML;
			scripts.push(scr);
		}
	}
	var found=false;
	for(var i=0;i<docScripts.length;i++){
		if(id==docScripts[i].getAttribute("scriptId")){
			found=true;
			break;
		}
	}
	if(!found){
		for(var i=0;i<scripts.length;i++){
			var script=scripts[i];
			var s = document.getElementsByTagName('script')[0];
			s.parentNode.insertBefore(script, s);
		}
	}
}
   

function getXMLHttpRequest(){
	var http_request = null;
	if (window.XMLHttpRequest) {
		// browser has native support for XMLHttpRequest object
		http_request = new XMLHttpRequest();
	} else if (window.ActiveXObject) {
		// try XMLHTTP ActiveX (Internet Explorer) version
		try {
			http_request = new ActiveXObject("Msxml2.XMLHTTP");
		} catch (e1) {
			try {
				http_request = new ActiveXObject("Microsoft.XMLHTTP");
			} catch (e2) {
				http_request = null;
			}
		}
	}
	return http_request;
}

function AjaxCall() {
	this.callMethod = "post";
	this.callUrl	= null;
	this.callParams	= null;
	
	this.onBeforeCall = null;
	this.onErrorCall = null;
	this.onProcessCall = null;
	
	this.doCall = function () {
		var	http_request = getXMLHttpRequest();
		http_request.open(this.callMethod, this.callUrl, false);
		http_request.setRequestHeader("content-type","application/x-www-form-urlencoded");
		
		if (this.onBeforeCall) this.onBeforeCall();
		
		http_request.send(this.callParams);
		
		if (http_request.readyState == 4) {
			if (http_request.status == 200) {
				if (this.onProcessCall) {
					this.onProcessCall(http_request.responseXML);
				} else {
					return http_request.responseXML;
				}
	       } else {
	    	   if (this.onErrorCall) {
	    		   this.onErrorCall();
	    	   } else {
	    		   alert("Could not contact the server.");
	    	   }
	       }
		}
	}
}
