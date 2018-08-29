function getSelectedId(obj) {
	var rows = obj.rows;
	for (i=0;i<rows.length;i++) {
		if (rows(i).children(0).children(0).checked) {
			return rows(i).children(0).children(0).value;
		}
	}
	return "";
}

function getSelectedObj(obj) {
	var rows = obj.getElementsByTagName("TR");
	for (i=0;i<rows.length;i++) {
		/*if (rows[i].childNodes[0].childNodes[0].getAttribute("checked")) {
			return rows[0].childNodes[0].childNodes[0];
		}*/
	}
	return null;
}

function verifyPermission(obj) {
	if (obj.getAttribute("canModify") == "true") {
		return true;
	}
	alert(msgNotPer);
	return false;
}

function verifyLock(obj){
	if(obj.getAttribute("lock") == "[true]"){
		return true;
	}
	return false;
}

function btnSig_click(docBean, blnIns){
	selObj=document.getElementById("docGrid"+docBean).selectedItems[0];
	if (selObj && selObj != null) {	
		if (blnIns != "true") {
			if (!verifyPermission(selObj)) {
				return;
			}
			if (!verifyLock(selObj)) {
				alert(msgMusLoc);
				return;
			}
		}
		
		if(!DIGITAL_SIGN_IN_CLIENT){
			var ret = openModal("/DocumentAction.do?action=secretPhrase&docBean="+docBean+"&docId="+selObj.getAttribute("value")+windowId,500,300);
			ret.onclose=function(){
				if(this.returnValue==null){
					return;
				}
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
		
		
				http_request.open('POST', "DocumentAction.do?action=signDoc", false);
				http_request.setRequestHeader("content-type","application/x-www-form-urlencoded; charset=utf-8");
			    http_request.send("docBean="+docBean+"&docId="+selObj.getAttribute("value") + "&usrPhrase="+this.returnValue+windowId);
			    
			     if (http_request.readyState == 4) {
		            if (http_request.status == 200) {
		                if(http_request.responseText == "OK"){
		                	alert(DIGITAL_SIGNATURE_OK);
		                } else {
							alert(http_request.responseText);
		                }
		            } else {
		               	alert("Could not contact the server.");               
		            }
			     }
						
						
			}
		}else{
			//FIRMA EN CLIENTE CON APPLET
			
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
		
		
				http_request.open('POST', "DocumentAction.do?action=signDoc", false);
				http_request.setRequestHeader("content-type","application/x-www-form-urlencoded; charset=utf-8");
			    http_request.send("docBean="+docBean+"&docId="+selObj.getAttribute("value") + windowId);
			    
			     if (http_request.readyState == 4) {
		            if (http_request.status == 200) {
		                if(http_request.responseText == "OK"){
		                	alert("Documento marcado para firmar");
		                } else {
							alert(http_request.responseText);
		                }
		            } else {
		               	alert("Could not contact the server.");               
		            }
			     }
			
		}
	}
	verifyException(selObj,docBean);
}

function verifyException(selObj,docBean){
if (selObj && selObj != null) {	

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
	
	http_request.open('POST', "DocumentAction.do?action=verifyParentException", false);
	http_request.setRequestHeader("content-type","application/x-www-form-urlencoded; charset=utf-8");
    http_request.send("docBean="+docBean+"&docId="+selObj.getAttribute("value")+windowId);
    
     if (http_request.readyState == 4) {
           if (http_request.status == 200) {
               if(http_request.responseText == "OK"){
               		//do nothing... everything is ok
               } else {
               		alert(http_request.responseText);
               }
           } else {
              // alert('Hubo problemas con la petici?n.');
              	alert("Could not contact the server.");               
           }
     }
					
					
	}

}

function btnVerSig_click(docBean, blnIns){
selObj=document.getElementById("docGrid"+docBean).selectedItems[0];
	if (selObj != null) {	
		if (blnIns != "true") {
			if (!verifyPermission(selObj)) {
				return;
			}
			if (!verifyLock(selObj)) {
				alert(msgMusLoc);
				return;
			}
		}
		var ret = openModal("/DocumentAction.do?action=viewSigns&docBean="+docBean+"&docId="+selObj.getAttribute("value")+windowId,500,300);
		
	}
}

function btnUplDoc_click(docBean) {
	var ret = openModal("/DocumentAction.do?action=new&docBean="+docBean+windowId,500,420);
	ret.onclose=function(){
		doDocXMLLoad(document.getElementById("docGrid"+docBean), "consult&docBean="+docBean+windowId);
	}
}

function btnModDoc_click(docBean, blnIns) {
	selObj=document.getElementById("docGrid"+docBean).selectedItems[0];
	if (selObj != null) {	
		if (blnIns != "true") {
			if (!verifyPermission(selObj)) {
				return;
			}
			if (!verifyLock(selObj)) {
				alert(msgMusLoc);
				return;
			}
		}
		var ret = openModal("/DocumentAction.do?action=update&docBean="+docBean+"&docId="+selObj.getAttribute("value")+windowId,500,420);
		ret.onclose=function(){
			doDocXMLLoad(document.getElementById("docGrid" + docBean), "consult&docBean="+docBean);
		}
	}
}

function btnHisDoc_click(docBean, docId) {
	var ret = openModal("/DocumentAction.do?action=history&docBean="+ docBean +"&docId="+docId,500,320);
	window.event.cancelBubble=true;
	window.event.returnValue=false;
}

function btnLockDoc_click(docBean) {
	var selObjs = document.getElementById("docGrid"+docBean).selectedItems;
	if (selObjs != null && selObjs.length>0) {	
		strAction1 = "lock&docBean="+docBean;
		strAction2 = "";
		strAction3 = "";
		for(z=0;z<selObjs.length;z++){
			selObj = selObjs[z];
			var index=selObj.rowIndex-1;
			if (selObj != null) {	
				if (verifyPermission(selObj)) {	
					strAction2 += "&docId=" + selObj.getAttribute("value");
					if (selObj.getAttribute("lock") == "") {
						strAction3 += "&lock=1";
					} else {
						strAction3 += "&lock=0";
					}
					doDocXMLLoad(document.getElementById("docGrid"+docBean),  strAction1+strAction2+strAction3);
				}
			}
			//document.getElementById("docGrid"+docBean).unselectAll();
			//document.getElementById("docGrid"+docBean).selectElement(document.getElementById("docGrid"+docBean).rows[index]);
		}
	}
}
    
function btnDelDoc_click(docBean, blnIns) {
 
	var cant = chksChecked(document.getElementById("docGrid"+docBean));
	if (cant ==0){
		alert(GNR_CHK_AT_LEAST_ONE);
		return;
	}

	selObjs=document.getElementById("docGrid"+docBean).selectedItems;
	if (selObjs != null && selObjs.length>0) {	
		var docIds = "";
		for(z=0;z<selObjs.length;z++){
			selObj=selObjs[z];
			//selObj=document.getElementById("docGrid"+docBean).selectedItems[0];
			if (selObj != null) {	
				if (blnIns != "true") {
					if (!verifyPermission(selObj)) {	
						return;
					}
					if (!verifyLock(selObj)) {
						alert(msgMusLoc);
						return;
					}
				}
				docIds += "&docId=" + selObj.getAttribute("value");
			}
		}
		if (docIds.length >0 && confirm(GNR_DELETE_RECORD)) {
			doDocXMLLoad(document.getElementById("docGrid"+docBean), "delete&docBean="+docBean + docIds);
			document.getElementById("docGrid"+docBean).unselectAll();
		}

	}
}

function btnDelDocIns_click(docBean) {
	selObj = getSelectedObj(document.getElementById(docBean));
	if (selObj != null) {	
		if (confirm(GNR_DELETE_RECORD)) {
			doDocXMLLoad(document.getElementById(docBean), "delete&docBean="+docBean +"&docId=" + selObj.value);
		}
	}
}

function doDocXMLResult(obj, action){
	var sXMLSourceUrl = URL_ROOT_PATH + "/DocumentAction.do?action="+action;
	var listener=new Object();
	listener.onLoad=function(xml){
		if (isXMLOk(xml)) {
			readDocXML(xml,obj);
		}
	}
	xml.addListener(listener);
	sXmlResult = __readInDOMDocument(sXMLSourceUrl);
}

function doDocXMLLoad(obj, action){
	var sXMLSourceUrl = URL_ROOT_PATH + "/DocumentAction.do?action="+action;
	var listener=new Object();
	listener.onLoad=function(xml){
		if (isXMLOk(xml)) {		
			readDocXML(xml,obj);
		}else{
			if(MSIE){
				var xmlRoot = xml.documentElement;
				if (xmlRoot.nodeName == "EXCEPTION") {
					alert(xmlRoot.firstChild.nodeValue);
				}
			}else{
				if (xml.responseXML.documentElement.nodeName == "EXCEPTION" || xml.responseXML.documentElement.nodeName == "exception"){
					alert(xml.responseXML.documentElement.textContent);
				}
			}
		}
	}
	xml.addListener(listener);
	sXmlResult = __readInDOMDocument(sXMLSourceUrl);
}

function readDocXML(sXmlResult,obj){
	obj.clearTable();
	var xmlRoot=getXMLRoot(sXmlResult);
	for(var i=0;i<xmlRoot.childNodes.length;i++){
		var tr=document.createElement("TR");
		for(var u=0;u<7;u++){
			var td=document.createElement("TD");
			tr.appendChild(td);
		}
		var row=xmlRoot.childNodes[i];
		fillTR(tr,row,obj);
		obj.addRow(tr);
	}
	sizeMe();
}

function fillTR(firstTR,xRow,obj){
	firstTR.id="";
	var value,canModify,lock;
	if(xRow.childNodes[0].firstChild!=null){
		firstTR.setAttribute("value",xRow.childNodes[0].firstChild.nodeValue);
	}
	if(xRow.childNodes[2].firstChild!=null){
		firstTR.setAttribute("canModify",xRow.childNodes[2].firstChild.nodeValue);
	}
	if(xRow.childNodes[1].firstChild!=null){
		firstTR.setAttribute("lock",xRow.childNodes[1].firstChild.nodeValue);
	}else{
		firstTR.setAttribute("lock","");
	}
	var firstTD=firstTR.getElementsByTagName("TD")[0];
	firstTD.innerHTML="<INPUT type='hidden' name='chkDoc' value='' canModify='' lock='[true]'>"
	
	firstTD.setAttribute("valign","top");
	var secondtTD=firstTR.getElementsByTagName("TD")[1];
	secondtTD.innerHTML="<img>";
	firstTR.getElementsByTagName("TD")[2].innerHTML="<img>";
	secondtTD.setAttribute("valign","top");
	if(secondtTD.getElementsByTagName("IMG")[0]!=undefined){
		//firstTR.getElementsByTagName("TD")[2].getElementsByTagName("IMG")[0].style.visibility="hidden";
		firstTR.getElementsByTagName("TD")[2].getElementsByTagName("IMG")[0].setAttribute("src",(URL_STYLE_PATH + "/images/history.gif"));
		if (xRow.childNodes[1].firstChild != null){ 
			if (xRow.childNodes[1].firstChild.nodeValue == "[true]") {
				secondtTD.getElementsByTagName("IMG")[0].setAttribute("src",URL_STYLE_PATH + "/images/lock.gif");
			} else {
				secondtTD.getElementsByTagName("IMG")[0].setAttribute("src",URL_STYLE_PATH + "/images/lock2.gif");
			}
			secondtTD.getElementsByTagName("IMG")[0].style.visibility="";
		}else{
			secondtTD.getElementsByTagName("IMG")[0].style.visibility="hidden";
		}
	}
	oTd2=firstTR.getElementsByTagName("TD")[2];
	oTd2.setAttribute("valign","top");
	oTd3=firstTR.getElementsByTagName("TD")[3];
	oTd3.setAttribute("valign","top");
	oTd4=firstTR.getElementsByTagName("TD")[4];
	oTd4.setAttribute("valign","top");
	oTd5=firstTR.getElementsByTagName("TD")[5];
	oTd5.setAttribute("valign","top");
	oTd6=firstTR.getElementsByTagName("TD")[6];
	oTd6.setAttribute("valign","top");

	oTd2.setAttribute("obj_id",obj.id);
	oTd2.setAttribute("node_Value",xRow.childNodes[0].firstChild.nodeValue);

	addListener(oTd2,"click",funcHis);
	
	if(xRow.childNodes[3].firstChild!=null){
		oTd3.innerHTML="<a href='#nowhere' onclick=\"downloadDocument('"+xRow.childNodes[0].firstChild.nodeValue+"','"+obj.docBean+"')\">" + xRow.childNodes[3].firstChild.nodeValue + "</a>";
		//oTd3.innerHTML = ""+xRow.childNodes[3].firstChild.nodeValue+"";
	}
	if(xRow.childNodes[4].firstChild!=null){
		oTd4.innerHTML =xRow.childNodes[4].firstChild.nodeValue+"";
	}
	if(xRow.childNodes[5].firstChild!=null){
		oTd5.innerHTML = "<a>"+xRow.childNodes[5].firstChild.nodeValue+"</a>";
	}else{
		if (window.navigator.appVersion.indexOf("MSIE")>0){
			oTd5.innerHTML ="";
		}
	}
	if(xRow.childNodes[6].firstChild!=null){
		oTd6.innerHTML = ""+xRow.childNodes[6].firstChild.nodeValue+"";
	}else{
		oTd6.innerHTML = "";
		if (window.navigator.appVersion.indexOf("MSIE")>0){
			oTd6.innerHTML ="";
		}
	}
	
	if(xRow.childNodes[7].firstChild){
		oTd3.title=xRow.childNodes[7].firstChild.nodeValue;
	}
}

function funcHis(evt){
	e = getEventSource(evt);
	btnHisDoc_click(e.getAttribute("obj_id"), e.getAttribute("node_Value"));
}

function downloadDocument (docId, docBean) {
	openWindow2(URL_ROOT_PATH + "/DocumentAction.do?action=download&docId="+docId+"&docBean="+docBean,700,500,"yes");
//	document.getElementById("docFrame").src="DocumentAction.do?action=download&docId="+docId+"&docBean="+docBean;
}
