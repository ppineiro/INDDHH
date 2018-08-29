<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import="uy.com.st.adoc.expedientes.conf.ConfigurationManager"%>
	
<html>

	<head>
	
		<%
		// EL ENVID Y LANGID A FUEGO ES PELIGROSO HAY QUE VER COMO PASARSELOS DINÁMICAMENTE
		// SINO SIGUE SIN SER DINÁMICO ESTE JSP.
		String imageUrl = ConfigurationManager.getDirGetLogoCaratula(1001, 1, false);
		
		imageUrl = "/Apia/images/uploaded/403051778.png";
		%>
	
		<script type="text/javascript">
			function cargarEstiloLogoRight(){
				document.getElementById("logoRight").style.position	= "relative";
				document.getElementById("logoRight").style.top		= "19%";
				document.getElementById("logoRight").style.left		= "9%";
			}
		
		</script>
	
		<style type="text/css">
			
			#boxRightImgContainer {
				height:174px;
				width: 98%;
			}
			
		</style>
		
	</head>
	
	<body>
	
		<div id='boxRightImgContainer' class='box ApiaDocumentum'>
			<img id='logoRight' class ='logoRight' src='<%=imageUrl%>'>
		</div>
		
	</body>
	
</html>
