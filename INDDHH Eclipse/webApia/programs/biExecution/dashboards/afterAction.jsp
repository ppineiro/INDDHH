<html><head><script language="javascript">
	function callAfter(){
		var result="<%=request.getParameter("result")%>";
		window.parent.afterAction(result);
		//window.parent.hideResultFrame();
	}
</script></head><body onload="callAfter()"></body></html>
