<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import="com.dogma.Parameters"%>
	
<html>

	<head>
	
		<%
		String ambiente = "URUGUAY_DIGITAL";
		//String ambiente = "URUGUAY_NATURAL";
		//String ambiente = "COSTA_RICA";
		
		String image = "";
		if (ambiente.equals("URUGUAY_DIGITAL")) {
			image = "logo_uruguay_digital.png";
		}
		
		if (ambiente.equals("URUGUAY_NATURAL")) {
			image = "logo_uruguay_natural.png";
		}
		
		if (ambiente.equals("COSTA_RICA")) {
			image = "RD_PROT_COSTA RICA.png";
		}
		
		
		String imageUrl = Parameters.ROOT_PATH + "/paneles/login/img/logosLeft/" + image;		
		%>
	
		<script type="text/javascript">
		
			function cargarEstiloLogoLeft(){
				var logo = "<%=ambiente%>";
				switch(logo){
				
					case "URUGUAY_DIGITAL":
						document.getElementById("logoLeft").style.position	= "relative";
						document.getElementById("logoLeft").style.top		= "17%";
						document.getElementById("logoLeft").style.left		= "27%";
						document.getElementById("logoLeft").style.height	= "65%";
						break;
				
					case "URUGUAY_NATURAL":
						document.getElementById("logoLeft").style.position	= "relative";
						document.getElementById("logoLeft").style.top		= "17%";
						document.getElementById("logoLeft").style.left		= "27%";
						document.getElementById("logoLeft").style.height	= "65%";
						break;
					
					case "COSTA_RICA":
						document.getElementById("logoLeft").style.position	= "relative";
						document.getElementById("logoLeft").style.top		= "11%";
						document.getElementById("logoLeft").style.left		= "25%";
						document.getElementById("logoLeft").style.width		= "45%";
						break;
					
				}
			}
		
		</script>
	
		<style type="text/css">
			
			#boxLeftImgContainer {
				height:174px;
			}
		
		</style>
				
	</head>
	
	<body>
	
		<div id='boxLeftImgContainer' class='client box'>			
			<img id='logoLeft' class ='logoLeft' src='<%=imageUrl%>'>			
		</div>
		
	</body>
	
</html>
