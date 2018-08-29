<html><head><%@include file="includes/startInc.jsp" %><%@include file="includes/headInclude.jsp" %><script type="text/javascript">
		function initPage(){
			new Spinner($('_body'),{message:WAIT_A_SECOND}).show();
			
			<%
				boolean samlSession = false;	
				try{
					samlSession = uData.getUserAttributes().get("samlAssertion") != null;	
				} catch (Exception e){
				}
			%><% if (request.getParameter("url")!=null) { %>
			var REDIRECT_TO = '<%=request.getParameter("url")%>';
			<% } else {%>
			var REDIRECT_TO = CONTEXT;
			<% } %><%if (samlSession) { %>
				var iframe = $('_frmSLO');
				iframe.src = CONTEXT + '/coesys.slo';
				iframe.addEvent('domready', function() { redirectToMain(1500); })
			<%} else { %>
				redirectToMain(500);
			<%} %> 

			function redirectToMain(timeout){
				setTimeout(function(){
					window.location = REDIRECT_TO;				
				}, timeout);
			}
		}
	</script></head><body id='_body'><iframe id="_frmSLO" style="display:none;"></iframe></body></html>