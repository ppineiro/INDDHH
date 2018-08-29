<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@page import="com.dogma.Parameters"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.HashMap"%>
<%@page import="uy.com.st.adoc.expedientes.mobile.ExpedienteMobile"%>
<%@page import="uy.com.st.adoc.expedientes.mobile.HelperMobile"%>
<%@page import="uy.com.st.documentum.seguridad.Base64"%>
<%@page import="com.dogma.UserData"%>
<%@page import="com.dogma.controller.ThreadData"%>

<%

	UserData uData = ThreadData.getUserData();
	String userLogin = uData.getUserId();
	Integer envId = null;
	envId = uData.getEnvironmentId();
	if (envId == null){
		envId = Integer.valueOf(1001); //no deberia suceder
	}
	HelperMobile helper = new HelperMobile();
	ArrayList<ExpedienteMobile> expedientes = helper.obtenerExpedientesParaFirma(userLogin);
	HashMap<String,String> pathsImagenesCaratulas = new HashMap<String,String>();
	for (ExpedienteMobile expediente : expedientes){
		String nroExp = expediente.getNroExpediente();
		pathsImagenesCaratulas.put(nroExp,helper.obtenerImagenCaratula(nroExp, envId));
	}
	
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
    <title>Expedientes para la firma</title>

	<script type="text/javascript" src="<%=Parameters.ROOT_PATH%>/expedientes/js/CustomJS-EXP-ELEC.js"></script>
	<script type="text/javascript" src="<%=Parameters.ROOT_PATH%>/js/mootools-core-1.4.5-full-compat.js"></script>
	<script type="text/javascript" src="<%=Parameters.ROOT_PATH%>/js/mootools-more-1.4.0.1-compat.js"></script>
	<script type="text/javascript" src="<%=Parameters.ROOT_PATH%>/js/generics.js"></script>
	<script type="text/javascript" src="<%=Parameters.ROOT_PATH%>/js/modal.js"></script>
	<script src="<%=Parameters.ROOT_PATH%>/js/modalController.js" type="text/javascript"></script>

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
  </head>
  <body>

    <div class="maincontent-area">
        <div class="zigzag-bottom"></div>
        <div class="container">
            <div class="row">
                <div class="col-md-12">
                    <div class="latest-product">
                        <!--<h2 class="section-title">Expedientes para firmar</h2>-->
                        <div class="product-carousel">
                            <% for (ExpedienteMobile exp : expedientes){ %>
                            <div class="single-product">
                                <div class="product-f-image" onclick="verFoliado('<%=new Base64().encode(exp.getNroExpediente())%>','TSKOtra'); return false;">
                               	    <a href="#" target="_self"><img src="<%=Parameters.ROOT_PATH %>/DownloadServlet?tipo=imagenCaratula&nroExp=<%=new Base64().encode(exp.getNroExpediente()) %>&cara=0"></a> 
                               	    
                          		</div>
                          		<div class="product-info">
                                	<h2><a href="<%=Parameters.ROOT_PATH %>/expedientes/movil/single-product.jsp?nroExp=<%=exp.getNroExpediente()%><%=TAB_ID_REQUEST%>" target="_self"><%= exp.getNroExpediente()%></a></h2>
                                	<div class="product-carousel-price">
                                	    <p><%=exp.getAsunto() %></p>
                                	</div>
                                </div>
                            </div>
                            <% } %>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div> <!-- End main content area -->

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

    <!-- Slider -->
    <script type="text/javascript" src="<%= Parameters.ROOT_PATH %>/expedientes/movil/js/bxslider.min.js"></script>
	<script type="text/javascript" src="<%= Parameters.ROOT_PATH %>/expedientes/movil/js/script.slider.js"></script>
  </body>
</html>
