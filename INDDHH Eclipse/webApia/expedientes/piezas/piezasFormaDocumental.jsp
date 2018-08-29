<%@page import="uy.com.st.adoc.expedientes.piezas.HelperPiezas"%>
<%@page import="uy.com.st.adoc.expedientes.helper.HelperDocAdjunta"%>
<%@page import="uy.com.st.adoc.expedientes.piezas.Pieza"%>
<%@page import="com.dogma.UserData"%>
<%@page import="com.dogma.controller.ThreadData"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.dogma.Parameters"%>
<%@page import="uy.com.st.adoc.expedientes.arbolExpediente.obj.sql.Consultas"%>
<%@page import="uy.com.st.adoc.expedientes.conf.ConfigurationManager"%>

<html>
	
	<head>
		
		<%
		
		String nro = request.getParameter("nro").toString();
		
		String tabId = request.getParameter("tabId").toString();
		String tokenId = request.getParameter("tokenId").toString();		
		
		UserData uData = ThreadData.getUserData();		
		
		int tamanio = Integer.parseInt(ConfigurationManager.getTamanioPiezas(uData.getEnvironmentId(), uData.getLangId(), true));
		
		String unidad = "KB";
		HelperPiezas hp = new HelperPiezas();
		ArrayList<Pieza> piezas  = hp.getPiezasExpediente(tamanio , unidad , nro , uData.getUserId() , uData.getEnvironmentId() , uData.getLangId());
				
		int tamanioExp = 0;
		for(Pieza pieza : piezas){
			tamanioExp += pieza.getTamanio(); 			
		}
		String tamanioExp_str = HelperDocAdjunta.getUnitSize(tamanioExp);
				
		String ROOT_PATH = Parameters.ROOT_PATH;
		String TAB_ID_REQUEST = "&tabId=" + tabId + "&tokenId=" + tokenId;
		
		%>
		
		<script type="text/javascript" src="<%= ROOT_PATH %>/js/mootools-core-1.4.5-full-compat.js"></script>
		<script type="text/javascript" src="<%= ROOT_PATH %>/js/mootools-more-1.4.0.1-compat.js"></script>
		<script type="text/javascript" src="<%= ROOT_PATH %>/js/generics.js"></script>
		<script type="text/javascript">
			
			function visualizarPieza (paths , nro_pieza) {
				
				var url_crear_pieza = "<%=ROOT_PATH%>" + "/expedientes/piezas/piezasDescargarPieza.jsp?paths=" + paths + "&nro=" + "<%=nro%>" + "&pieza=" + nro_pieza + "<%=TAB_ID_REQUEST%>";
				
				var xmlHttp = getXmlHttp();	
				xmlHttp.onreadystatechange = function() {
					if (xmlHttp.readyState==4 && xmlHttp.status==200){
						var path = xmlHttp.responseText;
						
						if (path != ""){
							
							path = "/expedientes/piezas/temporales/Expediente_" + "<%=nro%>" + "_pieza_" + nro_pieza + ".pdf";
							var urlServlet = "<%=ROOT_PATH%>" + "/GetArchiveFromPathServlet?filePath=" + path + "<%=TAB_ID_REQUEST%>";
							
							
							var tab = { title: "Pieza " + nro_pieza + " expediente <%=nro%>", url: urlServlet };
							parent.tabContainer.addNewTab(tab.title, tab.url);
							
						}
						
					}
				}

				xmlHttp.open("POST",url_crear_pieza,false);
				xmlHttp.send();		
				
			}
						
			function descargaDirecta (paths , nro_pieza) {
				
				var url_crear_pieza = "<%=ROOT_PATH%>" + "/expedientes/piezas/piezasDescargarPieza.jsp?paths=" + paths + "&nro=" + "<%=nro%>" + "&pieza=" + nro_pieza + "<%=TAB_ID_REQUEST%>";
				
				var xmlHttp = getXmlHttp();	
				xmlHttp.onreadystatechange = function() {
					if (xmlHttp.readyState==4 && xmlHttp.status==200) {
						var path = xmlHttp.responseText;
						
						if (path != ""){
							
							path = "/expedientes/piezas/temporales/Expediente_" + "<%=nro%>" + "_pieza_" + nro_pieza + ".pdf";
							var urlServlet = "<%=ROOT_PATH%>" + "/GetArchiveFromPathServlet?filePath=" + path + "<%=TAB_ID_REQUEST%>";
							
							var anchorDownloader = new Element('a', {
								href: urlServlet,
								download: "Expediente_" + "<%=nro%>" + "_pieza_" + nro_pieza + ".pdf"
							}).setStyle('visibility', 'hidden').inject(document.body);
							anchorDownloader.click();
							
						}					
						
					}
				}
				
				xmlHttp.open("POST" , url_crear_pieza , false);
				xmlHttp.send();		
			}
			
			function getXmlHttp(){
				var xmlHttp = null;
				if(window.XMLHttpRequest){
					xmlHttp=new XMLHttpRequest();
				}
				else{
					xmlHttp=new ActiveXObject("Microsoft.XMLHTTP");
				}
				return xmlHttp;
			}
			
		</script>
			
		<style type="text/css">
			
			div.title{ border-bottom: solid #CCCCCC 1px; margin-bottom: 15px; font-size: 16pt; font-weight: bold; }
			
			ul.tree { padding: 0 0 0 30px; width: 97.5%; }
			li.file span {  background-image: url('../iconos/document.png'); background-position: 0 0; background-repeat: no-repeat; padding-left: 21px; text-decoration: none; display: block; }
			
			li.folder { margin-bottom: 10px; border: none; background-color: transparent; background-image: none; color: #000000; display: block; font-family: Verdana,Arial,Tahoma; font-size: 11.5pt; height: auto; letter-spacing: normal; line-height: normal; list-style: none; margin-left: -15px; padding: 0; position: relative; text-transform: normal; visibility: visible; width: auto; word-spacing: normal; z-index: auto; }
			li.folder label { background-image: url('../iconos/folder-closed.png'); background-position: 15px 3px; background-repeat: no-repeat; display: block; padding-left: 37px; }
			
			li.folder input { position: absolute; left: 0; margin-left: 0; opacity: 0; z-index: 2; cursor: pointer; height: 1em; width: 1em; top: 0; }  			 
			li.folder input ~ ul { background-image: url('../iconos/expand.png'); background-position: 40px -3px; background-repeat: no-repeat; margin: -0.938em 0 0 -44px; height: 1em; } 
			li.folder input ~ ul > li { display: none; margin-left: -14px !important; padding-left: 1px; }			
			li.folder input:checked ~ ul{ background-image: url('../iconos/contract.png'); background-position: 40px 0px; background-repeat: no-repeat; margin: -1.25em 0 0 -44px; padding: 1.563em 0 0 80px; height: auto; }
			li.folder input:checked ~ ul > li { display: block; margin: 0 0 0.125em; } 
			li.folder input:checked ~ label { background-image: url('../iconos/folder-opened.png'); }
			
		</style>
			
	</head>
	
	<body>
			
		<div>
		
			<div id="title" class="title">Piezas del expediente <%=nro%></div>
			
			<ul class="tree">
				<li class="folder">
					<input checked="checked" type="checkbox">
					<label style="background-image: url('../iconos/expediente.png');margin-bottom: 4px;">Expediente <%=nro%> - <%= tamanioExp_str.replace("$" , "")%></label>
					<ul>
					<%
					int nro_pieza = 1;
					for (Pieza pieza : piezas) {
						String docs_paths = pieza.getPathsDocs().toString().replace(",",";").replace("[","").replace("]","").replace(" ","");
						%>
						<li class="folder">
							<input checked="checked" type="checkbox">
							<label style="margin-bottom: 4px;"><%=pieza.getNombre()%> </label>
							<ul style="list-style:none">
								<li class="file">
								
									<span style="background-image: url('../iconos/pdf.gif');color: blue;text-decoration: underline;cursor: pointer;" onClick="descargaDirecta('<%=docs_paths%>', '<%=nro_pieza%>')">
									<%=pieza.getNombre()%> - <%=HelperDocAdjunta.getUnitSize(pieza.getTamanio()).replace("$" , "")%> - compuesta por <%=pieza.getNroDocs()%> documentos
									</span>
								
								<!--  
									<span style="background-image: url('../iconos/pdf.gif');color: blue;text-decoration: underline;cursor: pointer;" onClick="visualizarPieza('<%=docs_paths%>', '<%=nro_pieza%>')">
									<%=pieza.getNombre()%> - <%=HelperDocAdjunta.getUnitSize(pieza.getTamanio()).replace("$" , "")%> - compuesta por <%=pieza.getNroDocs()%> documentos
									</span>
								-->										
								</li>								
							</ul>
						</li>
						<%
						nro_pieza++;
					}
					%>
					</ul>
				</li>				
			</ul>
			
		</div>		
	
	</body>
	
</html>
