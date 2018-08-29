
<html>
	
	<head>
		<%
		String pathDownload = (String)request.getSession().getAttribute("pathSalida");
		System.out.println("pathDownload: " + pathDownload);
		%>
	
		<style type="text/css">
			div.pdfContainer{ width:100%; height:100%; }
			embed { width:100%; height:100%; }
		</style>	
			
	</head>
	
	<body>
	<div class="pdfContainer">	
		<embed src="<%=pathDownload%>" alt="pdf" pluginspage="http://www.adobe.com/products/acrobat/readstep2.html">
	</div>
	
	</body>
	
</html>