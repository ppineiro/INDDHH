<%@page import="com.dogma.Configuration"%>
<html>
<head>
	<meta charset="utf-8">
	<title>
		tramites.en.linea.gub.uy
	</title>
	<meta name="description" content="Guía completa y organizada de trámites del Estado Uruguayo.">		
	<meta name="viewport" content="width=device-width,initial-scale=1.0">
	
	 <!-- SCRIPTS -->
	<script async="" src="//www.google-analytics.com/analytics.js"></script>
	<script type="text/javascript" src="<%=Configuration.ROOT_PATH %>/portal/js/jquery.min.js?subtype=javascript"></script>
	<script type="text/javascript" src="<%=Configuration.ROOT_PATH %>/portal/js/scripts-responsive.js?subtype=javascript"></script>
  
	<!--[if lt IE 9]>
	<script type="text/javascript" src="/wps/wcm/connect/PEU/PEU/JSArea/html5.js?subtype=javascript"></script>
	<![endif]--> 
	
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
    <h3>Explorar trámites por categoría</h3>	
    <div id="layout" class="layout1 group">
        <ul class="group">
            <li class="cat1"><a href="http://tramites.gub.uy/busqueda?q=inmeta:PEU_Tramite_Tema=Hogar_y_Familia&amp;title=Hogar+y+Familia" id="0" class="catLink"><span class="i"></span>Hogar y familia</a>
            </li>
            <li class="cat2"><a href="http://tramites.gub.uy/busqueda?q=inmeta:PEU_Tramite_Tema=Uruguayos_en_el_Exterior&amp;title=Uruguayos+en+el+Exterior" id="1"><span class="i"></span>Uruguayos en el exterior</a>
            </li>
            <li class="cat3"><a href="http://tramites.gub.uy/busqueda?q=inmeta:PEU_Tramite_Tema=Documentacion&amp;title=Documentaci%C3%B3n" id="2"><span class="i"></span>Documentación</a>
            </li>
            <li class="cat4"><a href="http://tramites.gub.uy/busqueda?q=inmeta:PEU_Tramite_Tema=Actividad_Productiva_y_Empresarial&amp;title=Actividad+Productiva+y+Empresarial" id="3" class="catLink"><span class="i"></span>Actividad productiva y empresarial</a>
            </li>
            <li class="cat5"><a href="http://tramites.gub.uy/busqueda?q=inmeta:PEU_Tramite_Tema=Cultura&amp;title=Cultura" id="4" class="catLink"><span class="i"></span>Cultura</a>
            </li>            
        </ul>
    </div>
</div>

</body>
</html>