<%@page import="com.dogma.Configuration"%>
<html class=" js" lang="es">

<head>
    
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

	<title>
	 busqueda | Apia Trámites en Línea
	</title>
	<meta name="description" content="Guía completa y organizada de trámites del Estado Uruguayo.">	
	
	<meta name="viewport" content="width=device-width,initial-scale=1.0">
	
	 <!-- SCRIPTS 
	<script async="" src="//www.google-analytics.com/analytics.js"></script>
	<script type="text/javascript" src="http://tramites.gub.uy/wps/wcm/connect/PEU/PEU/JSArea/jquery.min.js?subtype=javascript"></script>
	<script type="text/javascript" src="http://tramites.gub.uy/wps/wcm/connect/PEU/PEU/JSArea/scripts-responsive.js?subtype=javascript"></script>
	-->
  
    <!-- STYLES -->
	<link href="estilos-busqueda.css" rel="stylesheet" type="text/css">
	
</head>

<body>

<div class="subheader">
    <div class="container">
        <h2>
			<a href="http://tramites.gub.uy" title="Ir a la página principal de tramites.gub.uy">
			<img src="http://tramites.gub.uy/wps/wcm/connect/3bebdc0044660500894bcd305879a098/logoTramites.png?MOD=AJPERES&amp;amp;CACHEID=3bebdc0044660500894bcd305879a098" alt="tramites.gub.uy"></a>
		</h2>          
		<form action="<%=Configuration.ROOT_PATH %>/portal/buscador/resultado.jsp" class="buscador row">
            <input type="text" name="q" title="Buscar trámites">
            <input type="submit" value="Buscar">
		</form>
    </div>
</div>

</body>
</html>	