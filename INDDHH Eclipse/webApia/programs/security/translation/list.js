function btnSearch_click() {
	if(document.getElementById("txtTraObjName").value == "" && document.getElementById("txtTraObjId").value == "" && document.getElementById("cmbTraType").selectedIndex == 0){
		alert(MSG_SEL_AT_LEAST_ONE);
	}else{
		document.getElementById("frmMain").action = "security.TranslationAction.do?action=find";
		submitForm(document.getElementById("frmMain"));
	}
}
var selected;
function btnTrans_click(){
	if(document.getElementById("gridList").selectedItems.length <= 0)
	{
		alert(GNR_CHK_AT_LEAST_ONE);		
	}else{
		selected = document.getElementById("gridList").selectedItems[0].cells[0].getElementsByTagName("input")[1].value;
		var rets = openModal("/security.TranslationAction.do?action=translate&selected=" + selected,600,280);
		var doAfter=function(rets){
			if(rets != null) {
				var translations = "selected=" + selected;
				for (i = 0; i < rets.length; i++) {
					var ret = rets[i];
					
					translations += "&language=" + ret[0] + "&translation=" + encodeURIComponent(ret[1]) + "&translationTooltip=" + encodeURIComponent(ret[2]);				
				}
					
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
								
				http_request.open('POST', "security.TranslationAction.do?action=confirm", false);
				http_request.setRequestHeader("content-type","application/x-www-form-urlencoded; charset=utf-8");		
				http_request.send(translations);
			    
		     	if (http_request.readyState == 4) {
			        if (http_request.status == 200) {
						document.getElementById("gridList").selectedItems[0].cells[4].getElementsByTagName("img")[0].src=http_request.responseText;
			            return http_request.responseText;
			        } else {
			           alert('The system could not contact server using AJAX.');
			           return null;
			        }
			    }
			}
		}
		rets.onclose=function(){
			doAfter(rets.returnValue);
		}
	}
}

function first() {
	document.getElementById("frmMain").action = "security.TranslationAction.do?action=first";
	submitForm(document.getElementById("frmMain"));
}

function prev() {
	document.getElementById("frmMain").action = "security.TranslationAction.do?action=prev";
	submitForm(document.getElementById("frmMain"));
}

function next() {
	document.getElementById("frmMain").action = "security.TranslationAction.do?action=next";
	submitForm(document.getElementById("frmMain"));
}

function last() { 
	document.getElementById("frmMain").action = "security.TranslationAction.do?action=last";
	submitForm(document.getElementById("frmMain"));
}