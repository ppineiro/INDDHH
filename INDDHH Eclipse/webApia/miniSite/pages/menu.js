
window.addEvent('load', function() {
	sp = new Spinner(document.body,{message:WAIT_A_SECOND});
	
	
	getResume("R");
	getResume("A");
	
	
	$('btnExit').addEvent('click',function(e){
		e.stop();
		window.location = CONTEXT + '/miniSite/index.jsp';
	});
	
	$('taskList').addEvent('click',function(e){
		e.stop();
		window.location = CONTEXT + '/apia.security.LoginAction.run?action=gotoMinisiteTasks&tokenId=' + TOKENID;
	});
	
	$('startProcesses').addEvent('click',function(e){
		e.stop();
		window.location = CONTEXT + '/apia.security.LoginAction.run?action=gotoMinisiteProcesses&tokenId=' + TOKENID;
		
	});
	
	$('listQueries').addEvent('click',function(e){
		e.stop();
		window.location = CONTEXT + '/apia.security.LoginAction.run?action=gotoMinisiteQueries&tokenId=' + TOKENID;
		
	});
});

function getResume(mode){
	var request = new Request({
		method: 'post',
		url: CONTEXT + '/apia.security.LoginAction.run?action=getMinisiteTaskResume&tokenId=' + TOKENID,
		data: {
			workMode:mode
		},
		onRequest: function() { },
		onComplete: function(resText, resXml) { processXMLResponse(resXml,mode); }
	}).send();
}
	
function processXMLResponse(resXml,mode){
	if (resXml != null) {
		//obtener el codigo de retorno
		var code = resXml.getElementsByTagName("code");
		var value = code.item(0).firstChild.nodeValue;
		//alert(mode + " " + value);
		if("A"==mode){
			$('divAcq').innerHTML = value;
		} else {
			$('divRdy').innerHTML = value;
		}
	}
}