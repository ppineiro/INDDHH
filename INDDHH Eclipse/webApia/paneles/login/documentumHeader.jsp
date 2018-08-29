<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ page import="com.dogma.Parameters"%>
	
<html>
	
	<head>
	
		<style type="text/css">
		
			.header {
			    background-color: white;
			    height: 47px !important;
			    padding: 1em 2%;
			    width: 96%;
			    border-bottom: #dddddd solid 0.25px;
			}
			
			.header .logo {
			    display: inline-block;
			    padding: 8px;
			    position: relative;
    			top: -15%;
			}
			
			div.header {
				height: 10%;
			}
			
			div.header div.languages label.language {
				padding-right: 5px;
				font-family: Tahoma, Verdana, Arial;
				text-transform: lowercase;
			}
			
			div.header div.languages label.language A {
				color: #0679B8;
			}
			
			div.languages {
				position: relative;
    			top: 12.5%;
			}
			
		</style>
		
	</head>
	
	<body>
		
		<div class="header">
			
			<div class="logo">			
				<img border="0" id="logo" src="<%=Parameters.ROOT_PATH%>/paneles/login/img/ad-cabezal-chico.jpg">			
			</div>
			
			<div class="languages">	
						
				<div class="languages">			
					
						<label class="language">
							<a href="<%=Parameters.ROOT_PATH%>/apia.security.LoginAction.run?action=language&langId=1">
							Espa&#241;ol
							</a>
						</label>
					
						<label class="language">
							<a href="<%=Parameters.ROOT_PATH%>/apia.security.LoginAction.run?action=language&langId=2">
							Portugu&#234;s
							</a>
						</label>
					
						<label class="language">
							<a href="<%=Parameters.ROOT_PATH%>/apia.security.LoginAction.run?action=language&langId=3">
							English
							</a>
						</label>
					
				</div>	
					
			</div>
			
		</div>	
		
	</body>

</html>
