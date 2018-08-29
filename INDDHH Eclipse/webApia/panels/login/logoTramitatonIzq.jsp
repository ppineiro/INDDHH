<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import="com.dogma.Parameters"%>
	
<html>

	<head>
		<script>
	    var init=function() {
	        var noi=window.innerHeight;
	        url="myPage.jsp?rows="+noi;
	        cm=document.getElementById('cm');
	        cm.href=url;
	        cm.click();
	    }
	    </script>
		<%
 		String imageUrl = Parameters.ROOT_PATH + "/panels/login/img/imgLeftTramitatonLger.png";
		%>
		<style type="text/css">
		
			body  { 
				background: url("<%=imageUrl%>") !important;
				background-repeat: no-repeat !important; 			
/* 				background-size: contain !important; */
			} 
/* 			.logoTramitatonIzq { */
/* 			    border-radius: 0m; */
/* 			    box-shadow: 0 0px 0px rgba(0, 0, 0, 0.3); */
/* 			    display: block; */
/* 			    height: 100%; */
/* 			    text-align: left !important; */
/* 			} */
			.title {
				display:none !important;
			}
 			#pnlId_1_1045_1688Content {  
 				display:none !important; 
 			} 
			
			#boxLeftImgContainer {
 				height:auto !important; 
 				margin-right: -20px;
 				margin-top: -20px;
 				position: relative;
    			z-index: 2;
			}

			.splashLayout div.left-TwoColumns { 
				margin: 0 0 0 0% !important; 
			}
			#bodyController {
				box-shadow:0px 0px 0px 0px #adadad !important;
			}
			div.body {
				max-width: 100%;
			}
			
		
		</style>
				
	</head>
	
	<body onload=init() class='body'>
		<a style='' id=cm HREF=''>&nbsp;</a>
	
<!-- 		<div id="background"> </div> -->

		
	</body>
	
</html>
