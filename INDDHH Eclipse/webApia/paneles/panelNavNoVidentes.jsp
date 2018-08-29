<%@page import="uy.com.st.adoc.expedientes.helper.HelperPaneles"%>
<%@page import="com.dogma.UserData"%>
<%@page import="com.dogma.controller.ThreadData"%>

<%
	UserData uData = ThreadData.getUserData();
	String login = uData.getUserId();
	int envId = uData.getEnvironmentId();
	HelperPaneles helper = new HelperPaneles();
	String url1 = helper.obtenerFuncionalidad(login, "Crear forma documental", envId);
	String url2 = helper.obtenerFuncionalidad(login, "Bandeja de entrada", envId);
	String url3 = helper.obtenerFuncionalidad(login, "Consulta global por número de expediente", envId);	
%>

<html>
	<head>
		<meta charset="utf-8">
		<title>ApiaDocumentum</title>
			
		<style type="text/css">
		
			@media ( max-width : 1023px) {
				.categorias ul li {
					width: 19%;
					margin-right: 1%;
				}
			}
			
			@media ( max-width : 580px) {
				.categorias ul li {
					width: 48%;
				}
			}
			
			.box,.contenedor { background: #fff; color: inherit; width: 100%; float: left; }
			.categorias ul { padding-left: 0px; }
			.categorias ul li { list-style: none; float: left; margin-right: 4px; margin-left: 4px; }
			.layout span { height: 70px; width: 70px; display: block; margin-bottom: 2px; }
			.layout li:hover { cursor: pointer;	color: #0679B8; text-decoration: underline; border-color: #1D1918; }
			.layout span{ background-repeat: no-repeat; border: 1px solid #A8ADB0; border-radius: 10px; }
			a { position: relative; text-decoration: none; left: 4px; top: 5px; color: rgba(0, 0, 0, 0.75); }
			#aText { text-align: center; }
			
			#img1 { 
			    position: relative;
			    left: 14%;
			    height: 60px;
			    width: 65px;
				background: transparent url('paneles/img/CrearExpediente2.png')center;				
			    border: 1px solid #A8ADB0;
			    border-radius: 10px 10px 10px 10px;			    
			}
			
			#img2 {
				position: relative;
			    left: 14%;
				height: 60px;
				width: 65px;
				background: transparent url('paneles/img/BandejaDeEntrada.png') center;
				border: 1px solid #A8ADB0;
			    border-radius: 10px 10px 10px 10px;			    
			}
			
			#img3 {
				position: relative;
			    left: 14%;
			    height: 60px;
				width: 65px;
				background: transparent url('paneles/img/ConsultaPorNumero.png')	center;
				border: 1px solid #A8ADB0;
			    border-radius: 10px 10px 10px 10px;			    
			}
		
		</style>
		
		<script type="text/javascript">
			var urls = {
				1 : { title : "Crear forma documental", url: "<%=url1%>" },
				2 : { title : "Bandeja de entrada", url: "<%=url2%>" },
				3 : { title : "Consulta por número", url: "<%=url3%>" },				
			};
		
			function loadURL(index) {
				TAB_CONTAINER.addNewTab(urls[index].title, urls[index].url);	
			}
			
		</script>
	</head>

	<body>	
		<div class="box categorias"
			style="margin-bottom: 0px; padding-bottom: 0px;">
	
			<div class="layout">
				<ul>
					<%if (!url1.isEmpty()){%>
					<li style="height: 100px; width: 85px;">
						<div id="img1"></div>
						<a href="javascript:loadURL(1)">
							<div id ="aText">
								Crear forma<br>documental
							</div>
						</a>
					</li>
					<%}%>
							
					<%if (!url2.isEmpty()){%>
					<li style="height: 100px; width: 85px;">
						<div id="img2"></div>
						<a href="javascript:loadURL(2)">
							<div id ="aText">
								Bandeja de<br>entrada
							</div>
						</a>
					</li>
					<%}%>
									
					<%if (!url3.isEmpty()){%>
					<li style="height: 100px; width: 85px;">
						<div id="img3"></div>
						<a href="javascript:loadURL(3)">
							<div id ="aText">
								Consulta por<br>número
							</div>
						</a>
					</li>
					<%}%>
					
				</ul>
			</div>
		</div>
	
	</body>
</html>