<%@include file="../page/includes/startInc.jsp" %><html><head><%@include file="../page/includes/headInclude.jsp" %><script type="text/javascript">
		function continueLogin(){
			document.getElementById("frmMain").action="apia.splash.MenuAction.run?x=x" + TAB_ID_REQUEST;
			document.getElementById("frmMain").submit();
		}
	</script></head><body><div class="header"></div><div class="body" id="bodyDiv"><div class="gridContainer"><form id="frmMain" name="frmMain" method="POST"><button type="button" onclick="continueLogin()"  title="Continuar">Continuar</button></FORM></div></div></body></html>
