<%response.setCharacterEncoding(com.dogma.Parameters.APP_ENCODING);%>
<%@page import="com.dogma.Parameters"%>
<%@page import="com.dogma.EnvParameters"%>
<%@page import="com.dogma.controller.ThreadData"%>
<%@page import="com.dogma.UserData"%>
<%@page import="com.dogma.Configuration"%>
<%@page import="java.util.Hashtable"%>
<%@page import="st.url.TramiteHelper"%>
<%
response.setHeader("Pragma","no-cache");
response.setHeader("Cache-Control","no-store");
response.setDateHeader("Expires",-1); 

String TIPO = "";
String TITULO = "";
String MSG = "";

UserData uData = ThreadData.getUserData();
try {
	if (uData!=null) {
		if ((uData.getUserAttributes() != null) && (uData.getUserAttributes().size()>0)) {
			if (uData.getUserAttributes().get("MSG_PAGINA") != null) {
				Hashtable<String, String> htPaginaMsg  = (Hashtable<String, String>) uData.getUserAttributes().get("MSG_PAGINA");				
				TIPO = htPaginaMsg.get("TIPO");
				TITULO = htPaginaMsg.get("TITULO");
				MSG = htPaginaMsg.get("MSG");
				uData.getUserAttributes().clear();
			}
		}
	}
} catch (Exception e) {	
}


if (TIPO.equals("")){
	Hashtable<String, String> htPaginaMsg = (Hashtable<String, String>)session.getAttribute("MSG_PAGINA");
	
	TIPO = htPaginaMsg.get("TIPO");
	TITULO = htPaginaMsg.get("TITULO");
	MSG = htPaginaMsg.get("MSG");	
}
%>
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
	<title><%=TITULO%></title>	
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
            <h1><%=TITULO%></h1>								
			<br>
			
			<%
			String tipoCss = "dialog-" + TIPO.toLowerCase();
			String iconoCss = "icn-" + TIPO.toLowerCase() + "-lg";			
			%>
			<!--
            <div class="dialog-box <%=tipoCss%>">
                <div class="dialog-icon">
                    <span class="icn <%=iconoCss%>"></span>
                </div>
                <div class="dialog-data">                    
                    <span class="dialog-title"><%=MSG%></span>					
                </div>
            </div>
            -->			
            <div class="dialog-box dialog-info">
				<div class="dialog-icon">
					<span class="icn icn-circle-info-lg"></span>
				</div>
				<div class="dialog-data">
					<span class="dialog-title"><%=MSG%></span>
				</div>
			</div>		
			<ul class="form-action-buttons">
				<li class="action-buttons-primary">
					<ul>
						<li>
							<button class="btn-lg btn-primario" onclick="next()">Salir &gt;&gt;</button>
						</li>						
					</ul>
				</li>				
			</ul>							

        </div>
    </div>
	
</body>

</html>