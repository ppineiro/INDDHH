<%@page import="com.dogma.Parameters"%><HTML><head><script src="<%=Parameters.ROOT_PATH%>/scripts/events.js"></script><script defer=true>
	try {
		hideResultFrame()
	} catch (e) {
		alert("Error al intentar cerrar el dialogo 'Espere un momento'");
	} 
</script></head><body><iframe FRAMEBORDER=0 src="<%= request.getParameter("url") %>" width="100%" height="100%" scrolling="auto"></iframe></body></HTML>
