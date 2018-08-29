<%@page import="com.dogma.Configuration"%>
<html>
<head>
	<meta charset="utf-8">
	<title>
		tramites.en.linea.gub.uy
	</title>
	
    <!-- STYLES -->
<!-- 	<link href="<%=Configuration.ROOT_PATH %>/portal/css/estilos-responsive.css?subtype=css" rel="stylesheet" type="text/css"> -->
	
	<style type="text/css">
	
		.box, .contenedor {
			border:1px solid #cfcfcf;
			background:#fff;
			color:inherit;
			border-radius:3px;
/* 			padding:25px 25px; */
			margin-bottom:1.25em;
			box-shadow:1px 1px 2px #cfcfcf;
			width:100%;
			float:left;
		}
		
		h1,
		h2,
		h3,
		h4,
		h5,
		h6 {
		  margin: 8px 0 18px 0;
		  font-family: inherit;
		  font-weight: 700;
		  line-height: 1em;
		  color: inherit;
		}
		
		h1 {font-size: 2.6em; letter-spacing:-1px;}
		h2 {font-size: 1.8em; letter-spacing:-1px;}
		h3 {font-size: 1.65em; font-weight:bold; letter-spacing:-0.5px;}
		h4 {font-size: 1.15em;}
		h5 {font-size: 1em;}
		h6 {font-size: 0.9em;}
		
		.categorias ul {
			padding-left: 5px;
		}
		
		.categorias ul li {
		  list-style: none;
		  width: 8%;
		  margin-right: 1%;
		  float: left;
		  margin-bottom: 0.5em;
		}
		
		@media (max-width: 1139px){
			.categorias ul li {
			  width: 14%;
			  margin-right: 1%;
			}
		}
		
		@media (max-width: 800px){
			.categorias ul li {
			  width: 19%;
			  margin-right: 1%;
			}
		}
		
		@media (max-width: 580px){
			.categorias ul li {
			  width: 48%;
			  margin-right: 0px;
			}
		}
		
		.layout span {
			background: transparent url('portal/img/sprite_categorias.png') center 0;
			height: 90px;
			display: block;
			background-repeat: no-repeat;
		}
		
		.layout li {
			height: 150px;
		}
		
		.layout li:hover {
			background-color: #f9f9f9;
			cursor: pointer;
		}
		
		#img1 span{
			background-position: center -384px; 
		}
		
		#img2 span{
			background-position: center -480px; 
		}
		
		#img3 span{
			background-position: center -290px; 
		}
		
		#img4 span{
			background-position: center -7px; 
		}
		
		#img5 span{
			background-position: center -197px; 
		}
		
		#img6 span{
			background-position: center -100px; 
		}
		
		#img7 span{
			background-position: center -576px; 
		}
		
		#img8 span{
			background-position: center -671px; 
		}
		
		#img9 span{
			background-position: center -863px; 
		}
		
		#img10 span{
			background-position: center -959px; 
		}
		
		#img11 span{
			background-position: center -768px; 
		}

	</style>
	
	<script type="text/javascript">
	
	var urls = {
		1: {
			title: "Hogar y familia",
			url: "apia.execution.TaskAction.run?action=startCreationProcess&busEntId=1006&proId=1022&attParams=eatt_NUM_TRM_CATEGORIA_NUM%3D1"
		},
		2: {
			title: "Uruguayos en el exterior",
			url: "apia.execution.TaskAction.run?action=startCreationProcess&busEntId=1006&proId=1022&attParams=eatt_NUM_TRM_CATEGORIA_NUM%3D2"
		},
		3: {
			title: "Documentación",
			url: "apia.execution.TaskAction.run?action=startCreationProcess&busEntId=1006&proId=1022&attParams=eatt_NUM_TRM_CATEGORIA_NUM%3D3"
		},
		4: {
			title: "Actividad productiva y empresarial",
			url: "apia.execution.TaskAction.run?action=startCreationProcess&busEntId=1006&proId=1022&attParams=eatt_NUM_TRM_CATEGORIA_NUM%3D4"
		},
		5: {
			title: "Cultura",
			url: "apia.execution.TaskAction.run?action=startCreationProcess&busEntId=1006&proId=1022&attParams=eatt_NUM_TRM_CATEGORIA_NUM%3D5"
		},
		6: {
			title: "Beneficios sociales",
			url: "apia.execution.TaskAction.run?action=startCreationProcess&busEntId=1006&proId=1022&attParams=eatt_NUM_TRM_CATEGORIA_NUM%3D6"
		},
		7: {
			title: "Discapacidad",
			url: "apia.execution.TaskAction.run?action=startCreationProcess&busEntId=1006&proId=1022&attParams=eatt_NUM_TRM_CATEGORIA_NUM%3D7" 
		},
		8: {
			title: "En Línea",
			url: "apia.execution.TaskAction.run?action=startCreationProcess&busEntId=1006&proId=1022&attParams=eatt_NUM_TRM_CATEGORIA_NUM%3D8"
		},
		9: {
			title: "Consultar trámite",
			url: "apia.query.MonitorProcessAction.run?action=init&query=1013"
		},
		10: {
			title: "Consultar expediente",
			url: "apia.execution.TaskAction.run?action=startCreationProcess&busEntId=1010&proId=1027"
		},
		11: {
			title: "Modificar usuario",
			url: "apia.execution.TaskAction.run?action=startCreationProcess&busEntId=1017&proId=1016"
		}
	};
	
	function loadURL(index) {
		TAB_CONTAINER.addNewTab(urls[index].title, urls[index].url);
		
	}
	</script>
</head>

<body>



<div class="box categorias" style="border: none; margin-bottom: 0px; padding-bottom: 0px;">
   
    <div class="layout">
        <ul>
            <li id="img1" onclick="loadURL(1)">
				<center>
					<span></span>
					Hogar y familia
				</center>
            </li>
            <li id="img2" onclick="loadURL(2)">
            	<center>
					<span></span>
					Uruguayos en el exterior
				</center>
            </li>
            <li id="img3" onclick="loadURL(3)">
            	<center>
					<span></span>
					Documentación
				</center>
            </li>
            <li id="img4" onclick="loadURL(4)">
            	<center>
					<span></span>
					Actividad productiva y empresarial
				</center>
            </li>
            <li id="img5" onclick="loadURL(5)">
            	<center>
					<span></span>
					Cultura
				</center>
            </li>
            <li id="img6" onclick="loadURL(6)">
            	<center>
					<span></span>
					Beneficios sociales
				</center>
            </li>
            <li id="img7" onclick="loadURL(7)">
            	<center>
					<span></span>
					Discapacidad
				</center>
            </li>
            <li id="img8" onclick="loadURL(8)">
            	<center>
					<span></span>
					En Línea
				</center>
            </li>
        	<li id="img9" onclick="loadURL(9)">
            	<center>
					<span></span>
					Consultar trámite
				</center>
            </li>
            <li id="img10" onclick="loadURL(10)">
            	<center>
					<span></span>
					Consultar expediente
				</center>
            </li>
            <li id="img11" onclick="loadURL(11)">
            	<center>
					<span></span>
					Modificar Usuario
				</center>
            </li>
        </ul>
    </div>
</div>

</body>
</html>