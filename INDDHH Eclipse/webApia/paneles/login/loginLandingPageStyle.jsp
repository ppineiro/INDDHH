<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import="com.dogma.Parameters"%>

<html>

	<head>
		<style type="text/css">
			
			body {
				overflow: auto;
				height: 100%;
				background: #f4f4f4;
				margin: 0px;
				padding: 0px;
				overflow: 0px;
				font-family: Arial;
				font-size: 9pt;
				color: #0679B8
			}
			
			div.spinner {
				width: 100% !important;
				height: 100% !important;
			}
			
			.boxWrapper {
				padding: 5px;
			}
			
			.box {
			    background-color: white;
			    border-radius: 0.5em;
			    box-shadow: 0 2px 2px rgba(0, 0, 0, 0.3);
			    display: inline-block;
			    width: 100%;
			    height: 100%;
			}
			
			div.pnl_LOGIN{
				background-color: white;
			    border-radius: 0.5em;
			    box-shadow: 0 2px 2px rgba(0, 0, 0, 0.3);
			    display: inline-block;
			    width: 100%;
			    height: 174px;
			}
			
			div.warning {
				position: relative !important;
				top: 15% !important;
			   	left: -15.5% !important;				
				width: 77% !important;
			}
			
			div.fatalError {
				color: #FF0000;
				font-size: 10pt;
				margin-bottom: 10px;
				text-align: center;
			}
			
			div.message {
				float: right;
				padding-right: 70px;
			}
			
			div.loginRemember {
				display: none;
			}
			
		</style>
	
		<script type="text/javascript">
			function pantalla(){
				// SE CARGAN LOS ESTILOS DE LA PAGINA EN GENERAL
				var browserWidth = document.body.offsetWidth;
				var formSize = browserWidth * 0.24;
				document.getElementsByTagName("form")[0].style.position = "absolute";				
				document.getElementsByTagName("form")[0].style.width = formSize + "px";				
				document.getElementsByTagName("form")[0].style.left = "38%";
				
				// SE CARGAN ESTILOS DEL LOGO IZQUIERDO
				cargarEstiloLogoLeft();
				
				// SE CARGAN ESTILOS DEL LOGO DERECHO
				cargarEstiloLogoRight();
				
				// SE CARGAN ESTILOS DE NOTICIAS
				cargarEstiloNoticias();
			}
		</script>
		
	</head>
	
	<body onLoad = "pantalla()">
	
	</body>
	
</html>