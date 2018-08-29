<%@page import="com.dogma.Configuration"%>
<html>
<head>
	<meta charset="utf-8">
	<title>
		tramites.en.linea.gub.uy
	</title>
	
    <!-- STYLES -->
	<link href="<%=Configuration.ROOT_PATH %>/portal/css/estilos-responsive.css?subtype=css" rel="stylesheet" type="text/css">
	
</head>

<body>

<div class="subheader">
    <div class="container">
        <h2><a href="http://tramites.gub.uy" title="Ir a la página principal de tramites.gub.uy"><img src="http://tramites.gub.uy/wps/wcm/connect/3bebdc0044660500894bcd305879a098/logoTramites.png?MOD=AJPERES&amp;amp;CACHEID=3bebdc0044660500894bcd305879a098" alt="tramites.gub.uy"></a></h2>
    </div>
</div>

<div class="box categorias">
    <h5>Explorar trámites por categoría</h5>	
    <div id="layout">
        <ul>
            <li>
				<center>
				<a href="http://tramites.gub.uy/busqueda?q=inmeta:PEU_Tramite_Tema=Hogar_y_Familia&amp;title=Hogar+y+Familia">
					<img src="<%=Configuration.ROOT_PATH %>/portal/img/1.png"></img>
					Hogar y familia
				</a>&nbsp&nbsp
				</center>
            </li>
			<li><center>&nbsp&nbsp</center></li>
            <li>
				<a href="http://tramites.gub.uy/busqueda?q=inmeta:PEU_Tramite_Tema=Uruguayos_en_el_Exterior&amp;title=Uruguayos+en+el+Exterior">
					<img src="<%=Configuration.ROOT_PATH %>/portal/img/2.png"></img>
					Uruguayos en el exterior
				</a>&nbsp&nbsp
            </li>
			<li><center>&nbsp&nbsp</center></li>
            <li>
				<div>
				<a href="http://tramites.gub.uy/busqueda?q=inmeta:PEU_Tramite_Tema=Documentacion&amp;title=Documentaci%C3%B3n">
					<img src="<%=Configuration.ROOT_PATH %>/portal/img/3.png"></img>
					Documentación
				</a>&nbsp&nbsp
				</div>
            </li>
			<li><center>&nbsp&nbsp</center></li>
            <li>
				<a href="http://tramites.gub.uy/busqueda?q=inmeta:PEU_Tramite_Tema=Actividad_Productiva_y_Empresarial&amp;title=Actividad+Productiva+y+Empresarial">
					<img src="<%=Configuration.ROOT_PATH %>/portal/img/4.png"></img>
					Actividad productiva y empresarial
				</a>&nbsp&nbsp
            </li>
        </ul>
    </div>
</div>

</body>
</html>