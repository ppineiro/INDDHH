<%

%><html><head><script type="text/javascript" >
	 		function init(){
 				var parent = window.parent;
 	 			while(parent != parent.parent) {
 	 				parent = parent.parent;
 	 			}
 	 			parent.location.href = "<%=com.dogma.Parameters.ROOT_PATH%>/apia.security.LoginAction.run"; 
		 	}
		</script></head><body onload="init()"></body></html>