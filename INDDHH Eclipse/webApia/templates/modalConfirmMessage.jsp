<html>
	<head>
		<%
		String texto = request.getParameter("msg").toString();
		%>
	
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>Insert title here</title>
		
		<style type="text/css">
			#previewMsg{ text-align: justify; font-size: 12pt;}		
		</style>
		
		<script type="text/javascript">
		
			function getModalReturnValue(modal) {
				return true;
			}
			
		</script>
		
	</head>
	
	<body>
		<div id="previewMsg">
			<%= texto%>
		</div>
	
	</body>
	
</html>