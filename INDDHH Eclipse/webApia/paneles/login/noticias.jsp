<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import="com.dogma.Parameters"%>
	
<html>

	<head>
	
		<%
		//String ambiente = "NOTICIAS_AGESIC";
		String ambiente = "GENERIC";
		
		
		String image = "";

		if (ambiente.equals("GENERIC")) {
			image = "news_ee.png";
		}
		
		if (ambiente.equals("NOTICIAS_AGESIC")) {
			image = "noticias_agesic.gif";
		}		
		
		String imageUrl = Parameters.ROOT_PATH + "/paneles/login/img/noticias/" + image;		
		%>
		
    	<script type="text/javascript">
		
			function cargarEstiloNoticias(){
				var logo = "<%=ambiente%>";
				switch(logo){
				
					case "GENERIC":
						document.getElementById("noticiasGif").style.cursor 	= "pointer";
						document.getElementById("noticiasGif").style.position	= "relative";
						document.getElementById("noticiasGif").style.top		= "25%";
						document.getElementById("noticiasGif").style.width		= "-2%";
						break;					
						
					case "NOTICIAS_AGESIC":
						document.getElementById("noticiasGif").style.position	= "relative";
						document.getElementById("noticiasGif").style.top		= "17%";
						document.getElementById("noticiasGif").style.width		= "98%";
						break;
	
				}
			}
		
			function redirectNewsURL(){
				var logo = "<%=ambiente%>";
				switch(logo){
				
					case "GENERIC":
						window.open("http://www.agesic.gub.uy/innovaportal/v/4247/6/agesic/novedades-de-ee.html");
						break;
				
				}
			}
			
		</script>
	
		<style type="text/css">
		
			.campaing {     
				color: #bcbcbc;
			    font-size: 20px;
			    line-height: 100%;
			    text-align: center;
			    vertical-align: middle;
			}		
		
			div.container {
				width: 100%;
			}
			
			div.boxWrapper {
				height: 240px;
			}
		
			label.campaingContent {
				position: relative;
				top: 45%;
			}
		
		</style>
			
	</head>
	
	<body>
	
		<div  class="container">
			<div class="boxWrapper">
			
				<div class="box campaing">					
					<!-- <label class='campaingContent'>Área prevista para noticias.</label> -->
					<img onClick='redirectNewsURL()' id='noticiasGif' class ='logoRight' src='<%=imageUrl%>'>
				</div>
				
			</div>
		</div>
		
	</body>
	
</html>
