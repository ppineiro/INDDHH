<%@page import="java.util.Enumeration"%><html><head><script type="text/javascript" src="<system:util show="context" />/js/mootools-core-1.4.5-full-compat.js"></script><script type="text/javascript" src="<system:util show="context" />/js/mootools-more-1.4.0.1-compat.js"></script></head><body></body><script type="text/javascript">
		var form = new Element('form', {
			action: '<%=request.getContextPath() + "/apia.portal.PortalAction.run"%>',
			method: 'post'
		});
		<%
			Enumeration<String> reqParams = request.getParameterNames();
		 	while (reqParams.hasMoreElements()){
		 		String parName = reqParams.nextElement();
		%> 		
				new Element('input', {
					name: '<%=parName%>', 
					value: '<%=request.getParameter(parName)%>',
					type: 'hidden'
				}).inject(form); 		
		<%
			}
	 	%>
	 	new Element('input', {
			name: 'action', 
			value: 'initMobile',
			type: 'hidden'
		}).inject(form);
		new Element('input', {
			name: 'tokenId', 
			value: '<%=System.currentTimeMillis()%>',
			type: 'hidden'
		}).inject(form);
		new Element('input', {
			name: 'tabId', value: '1',
			type: 'hidden'
		}).inject(form);
		
		form.inject(document.body);
		form.submit();
	</script></html>
