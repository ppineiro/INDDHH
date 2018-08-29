<%@page import="com.dogma.Parameters"%>
<%@page import="st.url.TramiteHelper"%>

<!--[if i]><![endif]-->
<!DOCTYPE html>
<!--[if lt IE 9]><html class="jsOff ie" lang="es-ES"> <![endif]-->
<!--[if gt IE 8]><!-->
<html class="jsOff" lang="es-ES"><!--<![endif]--><!--[if IE]>
	<meta http-equiv="X-UA-Compatible" content="IE=9; IE=8; IE=7; IE=EDGE" />
<![endif]--><head>
<meta http-equiv="content-type" content="text/html; charset=UTF-8">
    <meta charset="UTF-8">
    <meta name="description" content="La descripción debe contener de 70 a 140 caracteres. Se hace referencia al contenido principal donde se muestran los átomos y moléculas del formulario tipo.">
    <meta name="author" content="Nombre autor">
	<meta name="viewport" content="width=device-width, height=device-height, initial-scale=1, user-scalable=no">
	<title>Tarea no disponible</title>	
    <!-- CSS/RESET-GENERAL-FORMULARIOTIPO-RESPONSIVE -->
    <link rel="stylesheet" type="text/css" href="files/estilos-formulario-tipo.css" media="screen">
	
	<script type="text/javascript">

	var URL_RETORNO = "<%=new TramiteHelper().getUrlRetorno(1)%>";
	
	function next() {	
		window.top.location = URL_RETORNO;
	}
	
	</script>
</head>

<body role="document">
    <div class="contenedorGeneral">
        <div class="contGralContenido">
            <h1>Tarea no disponible</h1>								
			<br>
			
            <div class="dialog-box dialog-warning">
                <div class="dialog-icon">
                    <span class="icn icn-warning-lg"></span>
                </div>
                <div class="dialog-data">                    
                    <span class="dialog-title">Estimado ciudadano, el trámite ya no se encuentra disponible para ser trabajado.</span>
					<span class="dialog-title">Para obtener más información del trámite al que se le asignó el Nº <%=request.getParameter("nroInt")%> comuniquese con el organismo.</span>
                </div>
            </div>
            					
			<ul class="form-action-buttons">
				<li class="action-buttons-primary">
					<ul>
						<li>
							<button class="btn-lg btn-primario" onclick="next()">Continuar al paso siguiente &gt;&gt;</button>
						</li>						
					</ul>
				</li>				
			</ul>							

        </div>
    </div>
	
</body>

</html>