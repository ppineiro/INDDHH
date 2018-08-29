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
		function loadURLInPanel(url) {
			document.id('iframe_pnlId_1_1013_1232').getChildren('iframe').set('src', url);
			new Fx.Scroll($(document.body)).start(0, 200);
		}
		function fncLoadURL(letra) {			
			var url = "<%=Configuration.ROOT_PATH %>/portal/buscador/resultadoAlfabetico.jsp";
			url = url + "?q=" + letra ;		
			url = url + "&pagina=1";
			document.id('iframe_pnlId_1_1013_1232').getChildren('iframe').set('src', url);
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
				<!-- 
				<li><a onclick="loadURLInPanel('<%=Configuration.ROOT_PATH %>/portal/buscador/resultadoAlfabetico.jsp?pagina=1&q=A');">A</a></li>
				<li><a onclick="loadURLInPanel('<%=Configuration.ROOT_PATH %>/portal/buscador/resultadoAlfabetico.jsp?pagina=1&q=B');">B</a></li>
				<li><a onclick="loadURLInPanel('<%=Configuration.ROOT_PATH %>/portal/buscador/resultadoAlfabetico.jsp?pagina=1&q=C');">C</a></li>
				<li><a onclick="loadURLInPanel('<%=Configuration.ROOT_PATH %>/portal/buscador/resultadoAlfabetico.jsp?pagina=1&q=D');">D</a></li>
				<li><a onclick="loadURLInPanel('<%=Configuration.ROOT_PATH %>/portal/buscador/resultadoAlfabetico.jsp?pagina=1&q=E');">E</a></li>
				<li><a onclick="loadURLInPanel('<%=Configuration.ROOT_PATH %>/portal/buscador/resultadoAlfabetico.jsp?pagina=1&q=F');">F</a></li>
				<li><a onclick="loadURLInPanel('<%=Configuration.ROOT_PATH %>/portal/buscador/resultadoAlfabetico.jsp?pagina=1&q=G');">G</a></li>
				<li><a onclick="loadURLInPanel('<%=Configuration.ROOT_PATH %>/portal/buscador/resultadoAlfabetico.jsp?pagina=1&q=H');">H</a></li>
				<li><a onclick="loadURLInPanel('<%=Configuration.ROOT_PATH %>/portal/buscador/resultadoAlfabetico.jsp?pagina=1&q=I');">I</a></li>
				<li><a onclick="loadURLInPanel('<%=Configuration.ROOT_PATH %>/portal/buscador/resultadoAlfabetico.jsp?pagina=1&q=J');">J</a></li>
				<li><a onclick="loadURLInPanel('<%=Configuration.ROOT_PATH %>/portal/buscador/resultadoAlfabetico.jsp?pagina=1&q=K');">K</a></li>
				<li><a onclick="loadURLInPanel('<%=Configuration.ROOT_PATH %>/portal/buscador/resultadoAlfabetico.jsp?pagina=1&q=L');">L</a></li>
				<li><a onclick="loadURLInPanel('<%=Configuration.ROOT_PATH %>/portal/buscador/resultadoAlfabetico.jsp?pagina=1&q=M');">M</a></li>
				<li><a onclick="loadURLInPanel('<%=Configuration.ROOT_PATH %>/portal/buscador/resultadoAlfabetico.jsp?pagina=1&q=N');">N</a></li>				
				<li><a onclick="loadURLInPanel('<%=Configuration.ROOT_PATH %>/portal/buscador/resultadoAlfabetico.jsp?pagina=1&q=O');">O</a></li>
				<li><a onclick="loadURLInPanel('<%=Configuration.ROOT_PATH %>/portal/buscador/resultadoAlfabetico.jsp?pagina=1&q=P');">P</a></li>
				<li><a onclick="loadURLInPanel('<%=Configuration.ROOT_PATH %>/portal/buscador/resultadoAlfabetico.jsp?pagina=1&q=Q');">Q</a></li>
				<li><a onclick="loadURLInPanel('<%=Configuration.ROOT_PATH %>/portal/buscador/resultadoAlfabetico.jsp?pagina=1&q=R');">R</a></li>
				<li><a onclick="loadURLInPanel('<%=Configuration.ROOT_PATH %>/portal/buscador/resultadoAlfabetico.jsp?pagina=1&q=S');">S</a></li>
				<li><a onclick="loadURLInPanel('<%=Configuration.ROOT_PATH %>/portal/buscador/resultadoAlfabetico.jsp?pagina=1&q=T');">T</a></li>
				<li><a onclick="loadURLInPanel('<%=Configuration.ROOT_PATH %>/portal/buscador/resultadoAlfabetico.jsp?pagina=1&q=U');">U</a></li>
				<li><a onclick="loadURLInPanel('<%=Configuration.ROOT_PATH %>/portal/buscador/resultadoAlfabetico.jsp?pagina=1&q=V');">V</a></li>
				<li><a onclick="loadURLInPanel('<%=Configuration.ROOT_PATH %>/portal/buscador/resultadoAlfabetico.jsp?pagina=1&q=W');">W</a></li>
				<li><a onclick="loadURLInPanel('<%=Configuration.ROOT_PATH %>/portal/buscador/resultadoAlfabetico.jsp?pagina=1&q=X');">X</a></li>
				<li><a onclick="loadURLInPanel('<%=Configuration.ROOT_PATH %>/portal/buscador/resultadoAlfabetico.jsp?pagina=1&q=Y');">Y</a></li>
				<li><a onclick="loadURLInPanel('<%=Configuration.ROOT_PATH %>/portal/buscador/resultadoAlfabetico.jsp?pagina=1&q=Z');">Z</a></li>
				 -->
				<li><a onclick="fncLoadURL('A');">A</a></li>
				<li><a onclick="fncLoadURL('B');">B</a></li>
				<li><a onclick="fncLoadURL('C');">C</a></li>
				<li><a onclick="fncLoadURL('D');">D</a></li>
				<li><a onclick="fncLoadURL('E');">E</a></li>
				<li><a onclick="fncLoadURL('F');">F</a></li>
				<li><a onclick="fncLoadURL('G');">G</a></li>
				<li><a onclick="fncLoadURL('H');">H</a></li>
				<li><a onclick="fncLoadURL('I');">I</a></li>
				<li><a onclick="fncLoadURL('J');">J</a></li>
				<li><a onclick="fncLoadURL('K');">K</a></li>
				<li><a onclick="fncLoadURL('L');">L</a></li>
				<li><a onclick="fncLoadURL('M');">M</a></li>
				<li><a onclick="fncLoadURL('N');">N</a></li>				
				<li><a onclick="fncLoadURL('O');">O</a></li>
				<li><a onclick="fncLoadURL('P');">P</a></li>
				<li><a onclick="fncLoadURL('Q');">Q</a></li>
				<li><a onclick="fncLoadURL('R');">R</a></li>
				<li><a onclick="fncLoadURL('S');">S</a></li>
				<li><a onclick="fncLoadURL('T');">T</a></li>
				<li><a onclick="fncLoadURL('U');">U</a></li>
				<li><a onclick="fncLoadURL('V');">V</a></li>
				<li><a onclick="fncLoadURL('W');">W</a></li>
				<li><a onclick="fncLoadURL('X');">X</a></li>
				<li><a onclick="fncLoadURL('Y');">Y</a></li>
				<li><a onclick="fncLoadURL('Z');">Z</a></li>

			</ul>
		</div>
		<div class="right">
			<!-- Acá va el link de ver todos los tramites -->
			<a href="<%@page import="com.dogma.Configuration"%>" target="parent">Ver los trámites en orden alfabético</a>
		</div>
	</div><!--contenido-->
	<div class="bottom cfx"><span class="botRg"></span></div>
</div>
	
	
</div>
</center>
  
</td>
</tr>
</table>
    
</body>
</html>