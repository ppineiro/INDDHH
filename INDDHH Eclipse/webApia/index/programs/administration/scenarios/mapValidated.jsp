<html><head><script language="javascript">
function loaded(){
var win=window;
while((!win.document.getElementById("iframeMessages") || !win.document.getElementById("workArea") || !win.document.getElementById("iframeResult")) && (win!=win.parent) ){
	win=win.parent;
}
if(win.document.getElementById("iframeMessages") && win.document.getElementById("iframeResult")){
	win.document.getElementById("iframeResult").hideResultFrame();
	win.document.getElementById("iframeMessages").hideResultFrame();
}
window.returnValue= "<%=(request.getParameter("result")!=null && request.getParameter("result").length()>0)?request.getParameter("result"):request.getAttribute("result")%>";
<%if(request.getParameter("result")!=null && request.getParameter("result").equals("OK")){%>
	window.parent.validScenario();
<%}else{%>
	window.parent.invalidScenario("<%=request.getParameter("result")%>");
<%}%>
}
</script></head><body onload="loaded()"></body></html>