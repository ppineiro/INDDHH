<%@page import="com.dogma.Configuration"%>
<!DOCTYPE html>
<head>
<link href="<%=Configuration.ROOT_PATH %>/portal/css/estilos-responsive.css?subtype=css" rel="stylesheet" type="text/css">
<style>
	ul.points li {
	    background: transparent url('portal/img/bullet.png') no-repeat 0 8px;
	    padding-left: 10px;
	}
	h5 {
		color: #6b6b6b;
	}
	a.a-navigation {
		text-decoration: underline;
	}
	a.a-navigation:HOVER {
		text-decoration: none;
	}
</style>
</head>
 
<body>
 
<div class="contenedor accesos cfx" style="margin-bottom: 0px; border: none; box-shadow: none; height: auto;">
	<div class="top cfx"><span class="topRg"></span></div>
	<div class="contenido group">
		<h5>Trámites más consultados</h5>
		<ul class="points">
			<li><a class="a-navigation" href="http://tramites.gub.uy/ampliados?id=608">Solicitud de Grabación de Radio o TV</a></li>
			<li><a class="a-navigation" href="http://tramites.gub.uy/ampliados?id=307">Venta de trasmisores radioeléctricos</a></li>
			
			<li><a class="a-navigation" href="http://tramites.gub.uy/ampliados?id=1379">Modificación de la participación societaria</a></li>
			
			<li><a class="a-navigation" href="http://tramites.gub.uy/ampliados?id=231">Autorización de Transferencia o Cesión de Licencia</a></li>
			
			<li><a class="a-navigation" href="http://tramites.gub.uy/ampliados?id=21">Alta y Baja de Equipos Radioelectricos</a></li>
		</ul>
		<div class="right link" style="width: 100%"><a class="a-navigation" href="http://tramites.gub.uy/consultados">Ver los trámites más consultados</a></div>
	</div><!--contenido-->
	<div class="bottom cfx"><span class="botRg"></span></div>
</div>
 
</body>
</html>