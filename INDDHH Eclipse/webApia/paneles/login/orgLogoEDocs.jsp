<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import="com.dogma.Parameters"%>
	
<html>

	<head>
	
		<%

 		String ambiente = "eDOCS";
		
		String image = "";
				
		if (ambiente.equals("AGESIC")) {
			image = "agesic_eDocs.png";
		}
		if (ambiente.equals("eDOCS")) {
			image = "eDocs.png";
		}
		
		String imageUrl = Parameters.ROOT_PATH + "/paneles/login/img/logos/" + image;		
		%>
	
		<script type="text/javascript">
		
			function cargarEstiloLogoLeft(){
				var logo = "<%=ambiente%>";
				switch(logo){
										
					case "AGESIC":
						document.getElementById("logoEDocs").style.position	= "relative";
						document.getElementById("logoEDocs").style.top		= "32%";
						document.getElementById("logoEDocs").style.left		= "0%";
						document.getElementById("logoEDocs").style.width	= "20%";
						break;
						
					case "eDOCS":
						document.getElementById("logoEDocs").style.position	= "relative";
						document.getElementById("logoEDocs").style.top		= "50%";
						document.getElementById("logoEDocs").style.left		= "0%";
						document.getElementById("logoEDocs").style.width	= "20%";
						break;
					
				}
			}
		
		</script>
	
		<style type="text/css">
			
			#boxLeftImgContainer {
				height:115px;
				width: auto !important;
			}
			div.pnl_PNL_LP_LOGO_EDOCS {
/*  				margin-right: 15px;  */
				margin-top: 155px !important;
				width: 305px !important;
				display: inline-block !important;
				margin-bottom: 35px;

			}
		
		</style>
				
	</head>
	
	<body>
	
		<div id='boxLeftImgContainer' class='client box'>			
			<img id='logoEDocs' class ='logoEDocs' src='<%=imageUrl%>'>			
		</div>
		
	</body>
	
</html>
