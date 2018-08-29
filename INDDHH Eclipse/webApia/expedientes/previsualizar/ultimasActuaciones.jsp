<%@page import="uy.com.st.adoc.expedientes.preview.Preview"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.dogma.UserData"%>
<%@page import="com.dogma.controller.ThreadData"%>

<html>
	<head>
		<%
		String expediente = request.getParameter("exp").toString();
		int nroAct = Integer.parseInt(request.getParameter("cant").toString());
		
		UserData uData = ThreadData.getUserData();
		Preview preview = new Preview();
		
		String path = preview.getUltimasActuaciones(uData.getUserId(), expediente, nroAct, uData.getEnvironmentId(), uData.getLangId());		
		%>
	
		<style type="text/css">
			div.pdfContainer{ width:100%; height:100%; }
			embed { width:100%; height:100%; }		
		</style>
			
	</head>
	
	<body>
	
		<div class="pdfContainer">	
			<embed id="etotal" src="<%=path%>" alt="pdf" pluginspage="http://www.adobe.com/products/acrobat/readstep2.html">		
		</div>
	
	</body>
	
</html>