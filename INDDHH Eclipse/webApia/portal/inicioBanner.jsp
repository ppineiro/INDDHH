<%@page import="com.dogma.Configuration"%>
<html>
<head>
	<meta charset="utf-8">
	<title>
		tramites.en.linea.gub.uy
	</title>
	
    <!-- STYLES -->
	<link href="<%=Configuration.ROOT_PATH %>/portal/css/estilos-responsive.css?subtype=css" rel="stylesheet" type="text/css">
	
	<script type="text/javascript">
	function fncLoadURLBanner() {			
		var url = "<%=Configuration.ROOT_PATH %>/portal/buscador/resultado.jsp";
		url = url + "?q=" + document.getElementById("q").value;		
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

<div class="subheader" style=" margin-bottom: 0px; padding-top: 0px; padding-bottom: 0px; padding-left: 0px; background-color: #f0f0f0;">
    <div style="margin-right: 0px; max-width: 100%; padding-left: 0px; ">
<!--     class="container"   -->
<!--     background-color: #ffffff; -->
    <img src="/Apia/images/logo_web.png" alt="URSEC: Unidad reguladora de Servicios de Comunicaciones" 
     style="width:186px;height:91px; position: relative; align: letf; padding-left: 0px;">

<!-- <img src="/Apia/images/bgHeader.png" style="width:974px;height:130px; position: relative; align: right;"> -->

    
<!--     	cambiar imagen y link en imagen -->
<%--         <h2><a href="<%=Configuration.ROOT_PATH %>/" title="Ir a la página principal de tramites.gub.uy"><img src="<%=Configuration.ROOT_PATH %>/portal/img/logoTramitesURSEC.png" alt="tramites.gub.uy"></a></h2> --%>
        
        <iframe frameborder=0 width="39px" height="30px" scrolling="no" style="border: 0px; float: right; margin-top: 30px;" src="/Chat/iframe.jsp"></iframe>
        
        <form onSubmit="return btnClick()" class="buscador row">
            <input type="text" name="q" id="q" title="Buscar trámites" style=" margin-top: 20px;">
            <input type="submit" value="Buscar" onclick="fncLoadURLBanner()" style=" margin-top: 20px;">
		</form>
		
    </div>
</div>



</body>
</html>