<html><head><script language="javascript">
	function cerrarVentana(){
		window.parent.returnValue= "<%=(request.getParameter("result")!=null && request.getParameter("result").length()>0)?request.getParameter("result"):request.getAttribute("result")%>";
		window.parent.close();
	}
</script></head><body onload="cerrarVentana()"></body></html>
