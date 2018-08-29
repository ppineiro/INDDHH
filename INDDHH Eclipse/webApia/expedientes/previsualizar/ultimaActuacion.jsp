<%@page import="uy.com.st.adoc.expedientes.preview.Preview"%>
<%@page import="com.dogma.UserData"%>
<%@page import="com.dogma.controller.ThreadData"%>

<html>
	<head>
		<%
		String actuacion  = request.getParameter("datos").split("/td/")[0].toString();
		String nroExp  = request.getParameter("datos").split("/td/")[1].toString();
		String nombre = "Actuacion-" + actuacion + "-" + nroExp + ".pdf";
		
		UserData uData = ThreadData.getUserData();		
		int envId = uData.getEnvironmentId();
		
		Preview preview = new Preview();
		String path = preview.getUltimaActuacion(nroExp, nombre, envId);
		
		%>
		
		<style type="text/css">
			div.pdfContainer{ width:100%; height:100%; }
			embed { width:100%; height:100%; }
		</style>
	
	</head>
	
	<body>
		<div class="pdfContainer">	
			<embed src="<%=path%>" alt="pdf" pluginspage="http://www.adobe.com/products/acrobat/readstep2.html">
		</div>
	</body>
	
</html>