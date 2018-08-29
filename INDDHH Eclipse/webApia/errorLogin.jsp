<html><head><%@include file="page/includes/startInc.jsp" %><%@include file="page/includes/headInclude.jsp" %><script type="text/javascript">
		function initPage(){
			<% if (request.getSession().getAttribute("message")!=null) { %>
				var msg = '<%= request.getSession().getAttribute("message") %>';
				if (msg != '') showMessage(msg);
			<% 
				request.getSession().removeAttribute("message");	
			} %>
		}
	</script></head><body></body></html>