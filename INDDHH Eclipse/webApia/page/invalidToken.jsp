<%@include file="includes/startInc.jsp" %><html><head><script language="javascript">
	function init(){
 		var parent = window.parent;
 		while(parent != parent.parent) {
 			parent = parent.parent;
 		}
 		parent.location.href = "<%=com.dogma.Parameters.ROOT_PATH%>/apia.security.LoginAction.run";
	}
	</script></head><body onload="init()"><div class="body" id="bodyDiv"><system:label show="text" label="msgInvalidToken" forScript="true" /></div></body></html>