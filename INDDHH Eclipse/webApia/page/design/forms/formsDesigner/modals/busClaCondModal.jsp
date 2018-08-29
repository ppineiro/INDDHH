<%@include file="../../../../includes/startInc.jsp" %><html><head><%@include file="../../../../includes/headInclude.jsp" %><link href="<system:util show="context" />/page/design/forms/formsDesigner/designer.css" rel="stylesheet" type="text/css" ></head><style type="text/css">
.condition-title { margin-top:15px; margin-bottom:10px; font-weight: bold; font-size: 1.2em; }
.condition-info  { font-size: 1.1em; white-space: pre-line; line-height: 17px; }
</style><script type="text/javascript"><% if (request.getParameter("requestAction")!=null) { %>
	var URL_REQUEST_AJAX = '<%=request.getParameter("requestAction")%>';
	<% } else { %>
	var URL_REQUEST_AJAX = '/apia.design.FormsAction.run';
	<% } %>

	var infoLbl = '<system:label show="text" label="flaProCndRul" forScript="true" />' +
		'<system:label show="text" label="flaProCndRul2" forScript="true" />' +
		'<system:label show="text" label="flaProCndRul3" forScript="true" />';
	var INFO  = infoLbl.replace(/%26/g, '&');
	var VALUE = parent.evtCondition;

	var LBL_CLOSE = '<system:label show="text" label="lblCloseWindow" forScript="true" />';
	var LBL_YES	 = '<system:label show="text" label="lblYes" forScript="true" />';
	var LBL_NO	 = '<system:label show="text" label="lblNo" forScript="true" />';
</script><script type="text/javascript">	
function initPage(){	
	$('info').innerHTML=INFO;
	$('skipCond').textContent=VALUE;
}

function checkCondition(){
	var request = new Request({
		method: 'post',
		data: {value: $('skipCond').value},
		url: CONTEXT + URL_REQUEST_AJAX +'?action=xmlValCondition&xml=true' + TAB_ID_REQUEST,		
		onComplete: function(resText, resXml) { 
			var exceptions = resXml.getElementsByTagName('EXCEPTION');
			if (exceptions && exceptions.length>0){
				var excMsg = Generic.espapeHTML(exceptions[0].textContent); 
				showMessage(excMsg, GNR_TIT_WARNING, 'modalWarning normalPreWrap');
			} else {
				frameElement.parentElement.fireEvent('customConfirm', [$('skipCond').value]);
			}
		}
	}).send();
}

function getModalReturnValue() {
	checkCondition();
	return null;
}
</script><body><div class="body" id="bodyDiv" style="padding: 0 10px 0 10px; overflow: hidden; "><div style="width:100%;height:100%;float:left"><div class="fieldGroup" style="height: inherit;position: relative;"><div class="title"><system:label show="text" label="flaProCnd" /></div><div class="gridContainer mdlTableContainer"><textarea id="skipCond" cols="1" style="width:99%; height:100px"></textarea><span id='info' class='condition-info'></span></div></div></div></div></body>

