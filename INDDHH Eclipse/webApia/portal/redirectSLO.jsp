<html>
<head>
	<%@include file="../page/includes/startInc.jsp" %>
	<%@include file="../page/includes/headInclude.jsp" %>
	
	<script type="text/javascript">
		function initPage(){
			new Spinner($('_body'),{message:WAIT_A_SECOND}).show();
					
			<%
				boolean samlSession = false;	
				try{
					samlSession = uData.getUserAttributes().get("samlAssertion") != null;	
				} catch (Exception e){
				}
			%>
		
			
			<%if (samlSession) { %>
				var iframe = $('_frmSLO');
				
				iframe.src = CONTEXT + '/coesys.slo';
				iframe.addEvent('domready', function() { redirectToMain(1500); })
			<%} else { %>
				redirectToMain(500);
			<%} %> 
			
			var URL_SALIDA = "<%=request.getParameter("url")%>";
			
			if (URL_SALIDA == "null" || URL_SALIDA == "") {
				URL_SALIDA = CONTEXT;
			}
			
			
			function redirectToMain(timeout){
				setTimeout(function(){
					if (URL_SALIDA == "null" || URL_SALIDA == "") {
						URL_SALIDA = CONTEXT;
					}
					window.location = URL_SALIDA;				
				}, timeout);
			}
		}
	</script>
</head>
<body id='_body'>

<iframe id="_frmSLO" style="display:none;"></iframe>

</body>
</html>