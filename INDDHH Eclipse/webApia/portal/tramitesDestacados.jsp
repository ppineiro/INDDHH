<%@page import="com.dogma.Configuration"%>
<!DOCTYPE html>
<head>
<link href="<%=Configuration.ROOT_PATH %>/portal/css/estilos-responsive.css?subtype=css" rel="stylesheet" type="text/css">
<style>
	ul.points li {
	    background: transparent url('portal/img/bullet.png') no-repeat 0 8px;
	    padding-left: 15px;
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
 
<div class="contenedor accesos cfx" style="margin-bottom: 0px; border: none; box-shadow: none; height: 375px;">
	<div class="top cfx"><span class="topRg"></span></div>
	<div class="contenido group">
		<h5>Trámites Destacados</h5>
		<ul class="points">
			<li><a class="a-navigation" href="http://tramites.gub.uy/ampliados?id=423">Calendario de Vencimientos de la DGI</a></li>
			<li><a class="a-navigation" href="http://tramites.gub.uy/ampliados?id=1962">Exoneración de IRPF por Arrendamientos de Inmuebles</a></li>
			
			<li><a class="a-navigation" href="http://tramites.gub.uy/ampliados?id=137">Descarga de Formularios y Programas de Ayuda</a></li>
			
			<li><a class="a-navigation" href="http://tramites.gub.uy/ampliados?id=142">Impresión de Boletos de Pago - Adeudos DGI</a></li>
			
			<li><a class="a-navigation" href="http://tramites.gub.uy/ampliados?id=147">Solicitud de Certificado Único DGI</a></li>
		</ul>
		<div class="right link" style="width: 100%"><a class="a-navigation" href="http://tramites.gub.uy/destacados">Ver los trámites destacados</a></div>
	</div><!--contenido-->
	<div class="bottom cfx"><span class="botRg"></span></div>
</div>
 
</body>
</html>