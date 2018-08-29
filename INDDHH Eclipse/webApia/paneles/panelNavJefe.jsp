<%@page import="uy.com.st.adoc.expedientes.helper.HelperPaneles"%>
<%@page import="com.dogma.UserData"%>
<%@page import="com.dogma.controller.ThreadData"%>

<%
	UserData uData = ThreadData.getUserData();
	String login = uData.getUserId();
	int envId = uData.getEnvironmentId();
	HelperPaneles helper = new HelperPaneles();
	String url1 = helper.obtenerFuncionalidad(login,"Crear forma documental", envId);
	String url2 = helper.obtenerFuncionalidad(login,"Bandeja de entrada", envId);
	String url3 = helper.obtenerFuncionalidad(login,"Gestionar ausencias", envId);
	String url4 = helper.obtenerFuncionalidad(login,"Consulta global por número de expediente", envId);
	String url5 = helper.obtenerFuncionalidad(login,"Consulta expedientes por fecha", envId);
	String url6 = helper.obtenerFuncionalidad(login,"Consulta de movimientos de expedientes", envId);
	String url7 = helper.obtenerFuncionalidad(login,"Expedientes en oficina", envId);
	String url8 = helper.obtenerFuncionalidad(login, "Dashboard Tareas", envId);
%>

<html>
<head>
<meta charset="utf-8">
<title>ApiaDocumentum</title>


<style type="text/css">
.box,.contenedor {
	background: #fff;
	color: inherit;
	width: 100%;
	float: left;
}

.categorias ul {
	padding-left: 0px;
}

.categorias ul li {
	list-style: none;
	float: left;
	margin-right: 4px;
	margin-left: 4px;
}

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

.layout span {
	height: 70px;
	width: 70px;
	display: block;
	margin-bottom: 2px;
}

.layout li:hover {
	cursor: pointer;
	color: #0679B8;
	text-decoration: underline;
	border-color: #1D1918;
	/*font-weight: bold;*/
}

.layout span{
	background-repeat: no-repeat;
	border: 1px solid #A8ADB0;
	border-radius: 10px;
}

#img1 span {
	background: transparent url('paneles/img/CrearExpediente2.png')center 0;
}

#img2 span {
	background: transparent url('paneles/img/BandejaDeEntrada.png') center 0;
}

#img4 span {
	background: transparent url('paneles/img/ConsultaPorNumero.png')	center 0;
}

#img6 span {
	background: transparent url('paneles/img/MovimientosDeExpedientes.png')center 0;
}

#img5 span {
	background: transparent url('paneles/img/ConsultaPorFecha2.png') center 0;
}

#img3 span {
	background: transparent url('paneles/img/GestionarAusencias.png')	center 0;
}

#img7 span {
	background: transparent url('paneles/img/ConsultaPorOficina2.png')center 0;
}

#img8 span {
	background: transparent url('paneles/img/dashboard.png')	center 0;
}

</style>

<script type="text/javascript">
	var urls = {
		1 : {
			title : "Crear forma documental",
			url: "<%=url1%>"
		},
		2 : {
			title : "Bandeja de entrada",
			url: "<%=url2%>"
		},
		3 : {
			title : "Gestionar ausencias",
			url: "<%=url3%>"
		},
		4 : {
			title : "Consulta por número",
			url: "<%=url4%>"
		},
		5 : {
			title : "Consulta por fecha",
			url: "<%=url5%>"
		},
		6 : {
			title : "Movimientos de expedientes",
			url: "<%=url6%>"
		},
		7 : {
			title : "Expedientes en oficina",
			url: "<%=url7%>"
		},
		
		8 : {
			title : "Tareas",
			url : "<%=url8%>"
		}
			
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
				<%if (!url1.isEmpty()){%><li id='img1' onclick='loadURL(1)'><center><span></span> Crear forma<br>documental</center></li><%}%>
				<%if (!url2.isEmpty()){%><li id='img2' onclick='loadURL(2)'><center><span></span> Bandeja<br>de entrada</center></li><%}%>
				<%if (!url4.isEmpty()){%><li id='img4' onclick='loadURL(4)'><center><span></span> Consulta<br>por número</center></li><%}%>
				<%if (!url5.isEmpty()){%><li id='img5' onclick='loadURL(5)'><center><span></span> Consulta<br>por fecha</center></li><%}%>
				<!-- <%if (!url6.isEmpty()){%><li id='img6' onclick='loadURL(6)'><center><span></span> Movimientos<br>de expedientes</center></li><%}%>-->
				<%if (!url3.isEmpty()){%><li id='img3' onclick='loadURL(3)'><center><span></span> Gestionar<br>ausencias</center></li><%}%>
				<%if (!url7.isEmpty()){%><li id='img7' onclick='loadURL(7)'><center><span></span> Expedientes<br>en oficina</center></li><%}%>
				<%if (!url8.isEmpty()){%><li id='img8' onclick='loadURL(8)'><center><span></span> Tablero de<br>control</center></li>	<%}%>
			</ul>
		</div>
	</div>

</body>
</html>