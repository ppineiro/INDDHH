<%@page import="com.dogma.Configuration"%>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<title>
		tramites.en.linea.gub.uy
	</title>
	
    <!-- STYLES -->
	<link href="<%=Configuration.ROOT_PATH %>/portal/css/estilos-responsive.css?subtype=css" rel="stylesheet" type="text/css">
	
	<style type="text/css">
		div.col.tercio {
			width: 32% !important;
		}
		
		.paginadoAlfa li {
			cursor: pointer;
		}
	
	</style>
	
	<script type="text/javascript">
		function loadURLListado(url) {
			document.id('iframe_pnlId_1_1009_1150').getChildren('iframe').set('src', url);
			new Fx.Scroll($(document.body)).start(0, 200);
		}
		function fncLoadURLListado() {			
			var url = "<%=Configuration.ROOT_PATH %>/portal/buscador/resultadoAlfabetico.jsp";
			url = url + "?q=null" ;		
			url = url + "&pagina=1";
			document.id('iframe_pnlId_1_1009_1150').getChildren('iframe').set('src', url);
			cancelFormSubmission();
		}

		function btnClick() {			
			return false;
		}	

	</script>
</head>

<body>

<table width="100%" align="center" border="0">
<tr>
<td>

<center>
<div align="center">

<div class="contenedor indiceAlfa cfx" style="margin-bottom: 0px;">
	<div class="top"><span class="topRg"></span></div>
	<div class="contenido group">
		<div class="left">
			<h3>Listado de trámites ordenados alfabéticamente</h3>
			
			<ul class="paginadoAlfa">
				<li><a onclick="fncLoadURL('');"></a></li>
			</ul>
		</div>
		<div class="right">
			<!-- Acá va el link de ver todos los tramites -->
			<a href="<%@page import="com.dogma.Configuration"%>" target="parent">Ver los trámites en orden alfabético</a>
		</div>
	</div><!--contenido-->
	<div class="bottom cfx"><span class="botRg"></span></div>
	<script type="text/javascript">fncLoadURL('')</script>
</div>
	
	
</div>
</center>
  
</td>
</tr>
</table>
    
</body>
</html>