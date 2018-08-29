function appletClose(result, tknId){
	window.parent.appletCloser(result, tknId);
}

function appletConfirm(result, tknId){
	window.parent.appletConfirmer(result, tknId);
}

function changeAriaLabel(msg) {
	var signApplet = document.getElementById("signApplet");
	signApplet.setAttribute("aria-label", msg);
	
	var event; // The custom event that will be created

	if (document.createEvent) {
    	event = document.createEvent("HTMLEvents");
    	event.initEvent("mouseover", true, true);
  	} else {
    	event = document.createEventObject();
    	event.eventType = "mouseover";
  	}

  	event.eventName = "mouseover";

  	if (document.createEvent) {
  		signApplet.dispatchEvent(event);
  	} else {
  		signApplet.fireEvent("on" + event.eventType, event);
	}
}

function hidePasswordField() {
	document.getElementById('certPassLbl').style.display = 'none';
	document.getElementById('certPass').style.display = 'none';
	
	document.getElementById('divContentMsg').innerHTML = lblContinueSign;
}

function btnNext_click() {
	if(eTokenNext) {
		signApplet.startNoBinarySign(null, document.getElementById('certPass').value);
		return;
	}
	var f = document.getElementById('certFile');
	if(filereader_support) {
		var reader = new FileReader();
		if(f.value) {
			reader.onload = (function(theFile) {
		        return function(e) {
		        	signApplet.startBinarySign(e.target.result, document.getElementById('certPass').value);
		          };
		        })(f);
			reader.readAsDataURL(document.getElementById('certFile').files[0]);
		} else {
			//No se selecciono archivo
		}
	} else {
		if(f.value) {
			signApplet.startNoBinarySign(document.getElementById('certFile').value, document.getElementById('certPass').value);
		} else {
			//No se selecciono archivo
		}
	}
}

function btnConf_click() {
	signApplet.btnConf_click();
}

function btnExit_click() {
	signApplet.btnExit_click();
}

function changeContent(msg) {
	document.getElementById("divContentMsg").tabIndex = "1";
	setTimeout(function() {
		document.getElementById("divContentMsg").focus();
	}, 100);
	
	
	document.getElementById('divContentMsg').innerHTML = msg;
	
	var certPass = document.getElementById('certPass');
	if(certPass)
		document.getElementById('certPass').value = '';
	
	var btnNext = document.getElementById('btnNext');
	if(btnNext)
		btnNext.disabled = 'true';
	
	if(msg == lblSignOk) {
		if(certPass) {
			certPass.style.display = 'none';
			document.getElementById('certPassLbl').style.display = 'none';
		}
		var certFile = document.getElementById('certFile');
		if (certFile) {
			certFile.style.display = 'none';
			document.getElementById('certFileLbl').style.display = 'none';
		}
	}
}

function enableConfirm() {
	if(eTokenNext) {
		document.getElementById('btnNext').style.display = 'none';
		document.getElementById('btnConf').style.display = '';
	} else {
		document.getElementById('btnConf').disabled = '';
	}
	
}

function disableConfirm() {
	document.getElementById('btnConf').disabled = 'true';
}


function createAutoStartPanel() {
	var r = document.getElementById('btnNext');
	r.parentNode.removeChild(r);
	document.getElementById('btnConf').style.display = "";
	document.getElementById('btnExit').style.display = "";
}

var filereader_support = window.File && window.FileReader && window.FileList;

function createBrowsePanel() {

	var divContent = document.getElementById('divContent');
	if (filereader_support) {
		divContent.innerHTML = "<br/><div id='divContentMsg'></div><label id='certFileLbl'>" + lblCert + "</label><br/><input id='certFile' type='file' accept='.p12,.pfx'/><br/><br/><label id='certPassLbl'>" + lblPwd + "</label><br/><input id='certPass' type='password' onkeyup='passKeyUp(this)'/>";
	} else {
		divContent.innerHTML = "<br/><div id='divContentMsg'></div><label id='certFileLbl'>" + lblCert + "</label><br/><input id='certFile' type='text'/><br/><br/><label id='certPassLbl'>" + lblPwd + "</label><br/><input id='certPass' type='password' onkeyup='passKeyUp(this)'/>";
	}
	
	document.getElementById('btnNext').style.display = "";
	document.getElementById('btnConf').style.display = "";
	document.getElementById('btnConf').disabled = 'true';
	document.getElementById('btnExit').style.display = "";
}

function passKeyUp(target) {
	if(target.value == '')
		document.getElementById('btnNext').disabled = 'true';
	else
		document.getElementById('btnNext').disabled = '';
}

var eTokenNext = false;

function createETokenPanel() {
	
	var divContent = document.getElementById('divContent');
	divContent.innerHTML = "<br/><div id='divContentMsg'></div><label id='certPassLbl'>" + lblPwd + "</label><br/><input id='certPass' type='password' onkeyup='passKeyUp(this)'/>";
	
	document.getElementById('btnNext').style.display = "";
	document.getElementById('btnNext').disabled = 'true';
	
	var btnConf = document.getElementById('btnConf');
//	document.getElementById('btnConf').style.display = "";
//	document.getElementById('btnConf').disabled = 'true';
	btnConf.style.display = "none";
	
	document.getElementById('btnExit').style.display = "";
	
	eTokenNext = true;
}

function initGUI() {
	document.getElementById("div-applet").style.display = "";
	//signApplet.style.display = "none";
	$('btnNext').addEvent('keyup', function(e) {
		if(e.key == 'space' || e.key == 'enter')
			btnNext_click();
	}).addEvent('click', function(e) {
		btnNext_click();
	});
	
	$('btnConf').addEvent('keyup', function(e) {
		if(e.key == 'space' || e.key == 'enter')
			btnConf_click();
	}).addEvent('click', function(e) {
		btnConf_click();
	});
	
	$('btnExit').addEvent('keyup', function(e) {
		if(e.key == 'space' || e.key == 'enter')
			btnExit_click();
	}).addEvent('click', function(e) {
		btnExit_click();
	});
	
	var divContent = $('divContent');
	if(window.navigator.appVersion.indexOf("MSIE 8") >= 0)
		$('divContent').setStyles({
			height: Number.from(divContent.getStyle('height')) + Number.from(divContent.getStyle('padding-top')) + Number.from(divContent.getStyle('padding-bottom')),
			width: Number.from(divContent.getStyle('width')) + Number.from(divContent.getStyle('padding-left')) + Number.from(divContent.getStyle('padding-right'))
		});
	
		
}