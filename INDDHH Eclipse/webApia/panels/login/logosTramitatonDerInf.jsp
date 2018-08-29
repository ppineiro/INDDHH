<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import="com.dogma.Parameters"%>
	
<html>

	<head>
		<%
 		String imageUrl = Parameters.ROOT_PATH + "/panels/login/img/imgRightTramitaton4.png";		
		%>
		<style type="text/css">
			
			#boxLeftInfImgContainer {
 				height:auto !important; 
			}

			div.pnl_PNL_LP_LOGO_EDOCS {
				margin-top: 155px !important;
				width: 305px !important;
				display: inline-block !important;
				margin-bottom: 35px;

			}
			.logoAgesic {
 				padding-right: 25px; 
 				width: 100%;
			}
			.boxIndoc {
			    border-radius: 0m;
			    box-shadow: 0 0px 0px rgba(0, 0, 0, 0);
			    display: block;
			    text-align: right !important;
				background-color: #ffffff;
			}
			#background-tramitaton {
			    position: fixed; 
 			    top: 0px; 
 			    width: 52%;
 			    height: 100%;
/*  			    background-color: #364B9B; */
				background-color: #ffffff;
 			    z-index: -1;
 			    right: 0;
			}
			
 			.pnl_LOGIN{ 
				background-color: #ffffff;
 			    border-left:  0px !important; 
 			    width: 50% !important;
 			    margin-top: 27% !important;
 			    margin-left: 25%;
			} 
		
		</style>
				
	</head>
	
	<body>
		<div id="background-tramitaton"></div>
		<div style="position:fixed; width:50%; height:75px; padding:10px; bottom:5px; ">
            <div id='#boxLeftInfImgContainer' class='boxIndoc'>			
				<img id='logos' class ='logoAgesic' src='<%=imageUrl%>'>			
			</div>
        </div>
		
		
	</body>
	
</html>
