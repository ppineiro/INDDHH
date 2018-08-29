<%@page import="com.dogma.Configuration"%>
<%@page import="st.access.tramites.TramiteDao"%>
<%@page import="st.access.tramites.Tramite"%>
<%@page import="java.util.ArrayList"%>

<% 
String texto = request.getParameter("q");
String pagina = request.getParameter("pagina");
TramiteDao tdao = new TramiteDao();
ArrayList<Tramite> arr = tdao.getTramitesAlfabeticoNominado(texto, 1);

int CANTIDAD_REGISTROS = 10;
int PAGINA_ACTUAL = Integer.parseInt(pagina);
%>

<html class=" js" lang="es">

<head>
    
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

	<title>
	 resultado | Apia Trámites en Línea
	
	</title>
	<meta name="description" content="Guía completa y organizada de trámites del Estado Uruguayo.">	
	
	<meta name="viewport" content="width=device-width,initial-scale=1.0">
	
	 <!-- SCRIPTS 
	<script async="" src="//www.google-analytics.com/analytics.js"></script>
	<script type="text/javascript" src="http://tramites.gub.uy/wps/wcm/connect/PEU/PEU/JSArea/jquery.min.js?subtype=javascript"></script>
	<script type="text/javascript" src="http://tramites.gub.uy/wps/wcm/connect/PEU/PEU/JSArea/scripts-responsive.js?subtype=javascript"></script>
	-->
  
  
  <script type="text/javascript">
  
  function openTramiteNominado(idTramite,nomTramite){
			  
	  	var url =  "<%=Configuration.ROOT_PATH %>" + "/apia.execution.TaskAction.run?action=startCreationProcess&busEntId=1006&proId=1033&favFncId=-10002" + parent.TAB_ID_REQUEST + "&E_TRM_COD_TRAMITE_STR=" + idTramite;
 	  	//alert("url:"+url);
		var tab = { title: nomTramite, url: url };		
		parent.parent.tabContainer.addNewTab(tab.title, tab.url);
		
	}
  
  </script>
    <!-- STYLES -->
	<link href="estilos-resultado.css?subtype=css" rel="stylesheet" type="text/css">
	
</head>

<body style="background-color: #ffffff;">

<div class="contenedor buscadorResultados cfx">
	<div class="top"><span class="topRg"></span></div>
	<div class="contenido cfx">
					  
		<%if (arr==null || arr.size()==0){ %>
			<div class="resultadosContenido">
				<!--tro2--><span class="p">
				<br>
				  Su búsqueda - <strong><%=texto%></strong> - no produjo ningún documento.
				  <br>
				<br>
				  Sugerencias:
				  <ul>
				<li>Asegúrese de que todas las palabras estén escritas correctamente.</li>
				<li>Intente usar otras palabras.</li>
				<li>Intente usar palabras más generales.</li>
				</ul>
				</span>
			</div>
		<%}else{ %>
		
			<%
			int cantRegistros = arr.size();
			int cantPaginas = cantRegistros / CANTIDAD_REGISTROS;
			if ((cantRegistros % CANTIDAD_REGISTROS) > 0){
				if (cantPaginas>0){
					cantPaginas = cantPaginas + 1;
				}
			}
			
			int inicio = (PAGINA_ACTUAL * CANTIDAD_REGISTROS) - CANTIDAD_REGISTROS; 
			int fin = (PAGINA_ACTUAL * CANTIDAD_REGISTROS) - 1;
			/*
			System.out.println("PAGINA_ACTUAL: " + PAGINA_ACTUAL);
			System.out.println("CANTIDAD_REGISTROS: " + CANTIDAD_REGISTROS);
			System.out.println("inicio: " + inicio);
			System.out.println("fin: " + fin);
			System.out.println("cantRegistros: " + cantRegistros);
			*/
			if (inicio>=cantRegistros){
				inicio = cantRegistros - 1;
			}
			if (fin>=cantRegistros){
				fin = cantRegistros - 1;
			}
			%>
<!-- 			<div class="left"> -->
<%-- 				<h4>Resultados de búsqueda para: <strong><%=texto%></strong></h4> --%>
<!-- 			</div> -->
<%-- 			<div class="right">Resultados <strong><%=(inicio+1)%></strong> - <strong><%=(fin+1)%></strong> de aproximadamente <strong><%=cantRegistros%></strong></div> --%>
 			<div class="left"> 
<!-- 				<h5>Trámites nominados:</h5> -->
 			</div>
			
			
						
			<div class="resultadosContenido">
			
				<div class="resultadosListado">
					<ul>
						<%
							/*
							System.out.println("cantRegistros: " + cantRegistros);
							System.out.println("cantPaginas: " + cantPaginas);
							System.out.println("PAGINA_ACTUAL: " + PAGINA_ACTUAL);
							System.out.println("inicio: " + inicio);
							System.out.println("fin: " + fin);
							*/
							for (int i=inicio; i<=fin; i++){
								//if (i<CANTIDAD_REGISTROS){
									/*
									System.out.println("i:" + i);
									System.out.println("arr.get(i): " + arr.get(i));
									*/
									Tramite t = arr.get(i);%>					
									<li style="margin-bottom: 10px;">
<!-- 										<h6> -->
											<span>
											<strong></strong>
											</span> 
											<!-- <a href="<%=Configuration.ROOT_PATH %>/page/externalAccess/open.jsp?logFromFile=true&onFinish=2&env=1&type=P&entCode=1006&proCode=1033&eatt_STR_TRM_NOMBRE_STR=<%=t.getNomb()%>"><strong><%=t.getNomb()%></strong></a> -->
											<a href="javascript:openTramiteNominado(<%=t.getId()%>,'<%=t.getNomb()%>')"><strong><%=t.getNomb()%></strong></a>																						  
<!-- 										</h6> -->
										</h7>
										<p><%=t.getDesc()%>...</p>
										</h7>
									</li>
							<%}
						%>
					</ul>
					<br>
				</div>
			</div>
			
			<BR>
			
			<div class="paginado">
				<ul class="cfx">
					<h6>
					<%if (PAGINA_ACTUAL > 1){
						String url = %><%Configuration.ROOT_PATH %><%;
						url = url + "/portal/buscador/resultadoAlfabeticoNominado.jsp";
							url = url + "?q=" + texto;		
							url = url + "&pagina=" + (PAGINA_ACTUAL -1);%>	
					<li class="pagSg"><a href="<%=url%>"> &lt;&lt; Página Anterior </a></li>
					<%}%>											
					<%for (int i=1; i<(cantPaginas+1); i++){
						if (i==PAGINA_ACTUAL){%>
							<li class="pagActual"><%=PAGINA_ACTUAL%></li>
						<%}else{
							String url = %><%Configuration.ROOT_PATH %><%;
							url = url + "/portal/buscador/resultadoAlfabeticoNominado.jsp";
							url = url + "?q=" + texto;		
							url = url + "&pagina=" + (i);
							%>
							<li><a href="<%=url%>"><%=(i)%></a></li>
						<%}%>		
					<%}%>				
					<%if (PAGINA_ACTUAL < cantPaginas){
						String url = %><%Configuration.ROOT_PATH %><%;
						url = url + "/portal/buscador/resultadoAlfabeticoNominado.jsp";
							url = url + "?q=" + texto;		
							url = url + "&pagina=" + (PAGINA_ACTUAL + 1);%>	
						<li class="pagSg"><a href="<%=url%>"> Página Siguiente &gt;&gt;</a></li>
					<%}%>		
					</h6>			
				</ul>
			</div>
		<%}%>
                
       </div>
   	<div class="bottom cfx"><span class="botRg"></span></div>
</div>

</body>
</html>	