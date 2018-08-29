<%@page import="com.st.util.StringUtil"%><html><head><script language="javascript">
function func(){
	var msg="<%=StringUtil.replace(request.getParameter("result"),"\n","")%>";
	window.parent.<%=request.getParameter("after")%>(msg);
	window.parent.hideResultFrame();
}
</script></head><body onload="func()"></body></html>