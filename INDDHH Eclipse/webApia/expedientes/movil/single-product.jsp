<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@page import="com.dogma.Parameters"%>
<%@page import="com.dogma.UserData"%>
<%@page import="com.dogma.controller.ThreadData"%>
<%@page import="uy.com.st.adoc.expedientes.mobile.HelperMobile"%>
<%@page import="uy.com.st.documentum.seguridad.Base64"%>
<%@page import="java.util.HashMap"%>

<%
	String nroExp = request.getParameter("nroExp");

	UserData uData = ThreadData.getUserData();
	String userLogin = uData.getUserId();

	Integer langId = uData.getLangId();
	Integer envId = uData.getEnvironmentId();

	HelperMobile helper = new HelperMobile();
	HashMap<String,String> datos = helper.obtenerDetalleExpediente(nroExp, langId, envId);
	
	String asunto = datos.get("asunto");
	int intCantidadActuaciones = Integer.parseInt(datos.get("cantidadActuaciones"));
	String encodedNombreArchivo = null;
	if (intCantidadActuaciones == 1){
		encodedNombreArchivo = new Base64().encode("Caratula-" + nroExp + ".pdf");
	}else{
		encodedNombreArchivo = new Base64().encode("Actuacion-" + (intCantidadActuaciones - 1) + "-" + nroExp + ".pdf");
	}
	
	
	
	String encodedNroExp = new Base64().encode(nroExp);
	

	String tokenId = "";
	if (request.getParameter("tokenId")!=null){
		tokenId = request.getParameter("tokenId").toString();
	}
	String  tabId = "";
	if (request.getParameter("tabId")!=null){
		tabId = request.getParameter("tabId").toString();
	}
	String TAB_ID_REQUEST = "&tabId=" + tabId +"&tokenId=" + tokenId;
	
%>
<!DOCTYPE html>
<!--
	ustora by freshdesignweb.com
	Twitter: https://twitter.com/freshdesignweb
	URL: https://www.freshdesignweb.com/ustora/
-->
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Detalle de expediente</title>
    
    <script type="text/javascript" src="<%=Parameters.ROOT_PATH%>/expedientes/js/CustomJS-EXP-ELEC.js"></script>
	<script type="text/javascript" src="<%=Parameters.ROOT_PATH%>/js/mootools-core-1.4.5-full-compat.js"></script>
	<script type="text/javascript" src="<%=Parameters.ROOT_PATH%>/js/mootools-more-1.4.0.1-compat.js"></script>
	<script type="text/javascript" src="<%=Parameters.ROOT_PATH%>/js/generics.js"></script>
	<script type="text/javascript" src="<%=Parameters.ROOT_PATH%>/js/modal.js"></script>
	<script src="<%=Parameters.ROOT_PATH%>/js/modalController.js" type="text/javascript"></script>
  	<script type="text/javascript" src="<%=Parameters.ROOT_PATH%>/expedientes/buscador/js/buscador.js"></script>
  
    <!-- Google Fonts -->
    <link href='http://fonts.googleapis.com/css?family=Titillium+Web:400,200,300,700,600' rel='stylesheet' type='text/css'>
    <link href='http://fonts.googleapis.com/css?family=Roboto+Condensed:400,700,300' rel='stylesheet' type='text/css'>
    <link href='http://fonts.googleapis.com/css?family=Raleway:400,100' rel='stylesheet' type='text/css'>

    <!-- Bootstrap -->
    <link rel="stylesheet" href="<%= Parameters.ROOT_PATH %>/expedientes/movil/css/bootstrap.min.css">

    <!-- Font Awesome -->
    <link rel="stylesheet" href="<%= Parameters.ROOT_PATH %>/expedientes/movil/css/font-awesome.min.css">

    <!-- Custom CSS -->
    <link rel="stylesheet" href="<%= Parameters.ROOT_PATH %>/expedientes/movil/css/owl.carousel.css">
    <link rel="stylesheet" href="<%= Parameters.ROOT_PATH %>/expedientes/movil/style.css">
    <link rel="stylesheet" href="<%= Parameters.ROOT_PATH %>/expedientes/movil/css/responsive.css">

    <!-- HTML5 shim and Respond.js for IE8 support of HTML5 elements and media queries -->
    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
    <!--[if lt IE 9]>
      <script src="https://oss.maxcdn.com/html5shiv/3.7.2/html5shiv.min.js"></script>
      <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
    <![endif]-->
    
    	<!-- SCRIPTS -->
		<script type="text/javascript">
		
			var TAB_ID_REQUEST        = "<%=TAB_ID_REQUEST%>";
			var CONTEXT               = "<%=Parameters.ROOT_PATH%>";
			var MOBILE                = <%="true".equals(session.getAttribute("mobile")) ? "true" : "false"%>;

		</script>
		
		
  </head>
  <body>

    <div class="single-product-area">
        <div class="zigzag-bottom"></div>
        <div class="container">
            <div class="row">

                <div class="col-md-8">
                    <div class="product-content-right">

                        <div class="row">

                            <div class="col-sm-6">
                                <div class="product-inner">

                                    <div role="tabpanel">
                                        <div class="tab-content">
                                            <div role="tabpanel" class="tab-pane fade in active" id="home">
                                                <h2>Expediente: <%= nroExp %></h2>
												<p>Asunto:<br> <%= asunto %> </p>
                                               <ul>
	                                                <li onclick="mostrarHistorialMobile('<%= nroExp %>')"><a href="#!">Historial</a></li>
	                                                
	                                                <li onclick="verCaratula('<%= encodedNroExp %>','TSKOtra')"><a href="#!">Ver carátula</a></li>	<!-- versiones caratula -->
	                                   
	                                                <li onclick="verFoliado('<%= encodedNroExp %>','TSKOtra')"><a href="#!">Descargar expediente</a></li>	<!-- verFoliado -->
	                                                
	                                                <li onclick="verActuacion('<%= encodedNroExp %>','<%= encodedNombreArchivo %>',<%= intCantidadActuaciones == 1 %>)">
	                                                	<a href="#!">Ver actuación a firmar</a>
	                                                
	                                                <%if(helper.esPaseParaFirma(userLogin, nroExp, envId)){ %>
	                                           		     <li onclick="verEstadoFirmas('<%= encodedNroExp %>')"><a href="#!">Ver estado de firmas</a></li>	<!-- generar resumen firmantes pase a firma -->
                                            		<%} %>
                                            	</ul>
                                            </div>
                                        </div>
                                        <ul class="product-tab" role="tablist">
                                            <li role="presentation" class="active">
                                            	<a href="index.jsp?p=0<%=TAB_ID_REQUEST%>">Volver</a>
                                            	<!-- 
	                                            <script>
 	   												document.write('<a href="' + document.referrer + '">Volver</a>');
												</script>
												 -->
                                            </li>
                                        </ul>
                                    </div>

                                </div>
                            </div>
                        </div>

                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Latest jQuery form server -->
    <script src="https://code.jquery.com/jquery.min.js"></script>

    <!-- Bootstrap JS form CDN -->
    <script src="http://maxcdn.bootstrapcdn.com/bootstrap/3.2.0/js/bootstrap.min.js"></script>

    <!-- jQuery sticky menu -->
    <script src="<%= Parameters.ROOT_PATH %>/expedientes/movil/js/owl.carousel.min.js"></script>
    <script src="<%= Parameters.ROOT_PATH %>/expedientes/movil/js/jquery.sticky.js"></script>

    <!-- jQuery easing -->
    <script src="<%= Parameters.ROOT_PATH %>/expedientes/movil/js/jquery.easing.1.3.min.js"></script>

    <!-- Main Script -->
    <script src="<%= Parameters.ROOT_PATH %>/expedientes/movil/js/main.js"></script>
    
	<script type="text/javascript" src="<%=Parameters.ROOT_PATH%>/expedientes/js/CustomJS-EXP-ELEC.js"></script>
	<script type="text/javascript" src="<%=Parameters.ROOT_PATH%>/js/mootools-core-1.4.5-full-compat.js"></script>
	<script type="text/javascript" src="<%=Parameters.ROOT_PATH%>/js/mootools-more-1.4.0.1-compat.js"></script>
	<script type="text/javascript" src="<%=Parameters.ROOT_PATH%>/js/generics.js"></script>
	<script type="text/javascript" src="<%=Parameters.ROOT_PATH%>/js/modal.js"></script>
	<script src="<%=Parameters.ROOT_PATH%>/js/modalController.js" type="text/javascript"></script>
	<script>		
    	function mostrarHistorial(nroExp) {
		var URL = userData.getContextPath() + "/expedientes/historialActuaciones.jsp?NroExp=" + nroExp;
		var w =  ModalController.openWinModal(URL + TAB_ID_REQUEST, 1000, 505);
		}
	</script>
	<script>
		function verEstadoFirmas(nroExp) {			
			// SE ARMA URL	
			var URL = getUrlApp() + "/DownloadServlet?tipo=verEstadoFirmas&nroExp=" + nroExp + TAB_ID_REQUEST;
			
			// DESCARGO EL ARCHIVO
			var anchorDownloader = new Element('a', {
				href: URL,
				download: 'true'
			}).setStyle('visibility', 'hidden').inject(document.body);
			anchorDownloader.click();	
		}
	</script>
	<script>
		function verActuacion(nroExp, nameArchivo, caratula) {			
			// SE ARMA URL
			var URL;
			if (caratula){
				URL = getUrlApp() + "/DownloadServlet?tipo=CARATULA&nroExp=" + nroExp + TAB_ID_REQUEST;
			}else{
				URL = getUrlApp() + "/DownloadServlet?tipo=VER_ACTUACION&nroExp=" + nroExp + "&nameArchivo=" + nameArchivo + TAB_ID_REQUEST;
			}
			// DESCARGO EL ARCHIVO
			var anchorDownloader = new Element('a', {
				href: URL,
				download: 'true'
			}).setStyle('visibility', 'hidden').inject(document.body);
			anchorDownloader.click();	
		}
	</script>
	<script type="text/javascript">
		function mostrarHistorialMobile(nroExp) {
			
			var URL = getUrlApp() + "/expedientes/movil/historialActuacionesMoible.jsp?NroExp=" + nroExp + TAB_ID_REQUEST;
			var tab = {
				title : "Historial " + nroExp,
				url : URL
			};
			parent.tabContainer.addNewTab(tab.title, tab.url);
			
		}
	</script>
  </body>
</html>
