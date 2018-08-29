			<!-- INICIO PAGINADO -->
			<%
				int cantRegistros = arr.size();
				int cantPaginas = cantRegistros / CANTIDAD_REGISTROS;
				if ((cantRegistros % CANTIDAD_REGISTROS) > 0){
					if (cantPaginas>0){
						cantPaginas = cantPaginas + 1;
					}
				}
				
				int paginaInicio = 0;
				int paginaFin = 0;
				if (cantPaginas > Conf.CANTIDAD_REGISTROS){
					if (PAGINA_ACTUAL > (Conf.CANTIDAD_REGISTROS / 2)){
						if ((PAGINA_ACTUAL + (Conf.CANTIDAD_REGISTROS / 2)) < cantPaginas){					
							paginaInicio = PAGINA_ACTUAL - (Conf.CANTIDAD_REGISTROS / 2);
							paginaFin = PAGINA_ACTUAL + (Conf.CANTIDAD_REGISTROS / 2);
						}else{
							paginaInicio = cantPaginas - Conf.CANTIDAD_REGISTROS;
							paginaFin = cantPaginas;
						}
					}else{
						paginaInicio = 1;						
						paginaFin = (Conf.CANTIDAD_REGISTROS + 1);
					}
				}else{
					paginaInicio = 1;						
					paginaFin = cantPaginas;
				}
				/*
				System.out.println("---------------------------");
				System.out.println("paginaInicio: " + paginaInicio);
				System.out.println("paginaFin: " + paginaFin);
				System.out.println("---------------------------");
				*/	
				int inicio = (PAGINA_ACTUAL * CANTIDAD_REGISTROS) - CANTIDAD_REGISTROS; 
				int fin = (PAGINA_ACTUAL * CANTIDAD_REGISTROS) - 1;
				
				if (inicio>cantRegistros){
					inicio = cantRegistros - 1;
				}
				if (fin>cantRegistros){
					fin = cantRegistros - 1;
				}
			%>			
			<!-- INICIO PAGINADO -->
			<%String url = "";%>
			<table border="5" align="center" width="95%">
				<tr>
					<td width="15%">&nbsp;</td>
					<%if (PAGINA_ACTUAL > Conf.CANTIDAD_REGISTROS){
						url = "/Apia/expedientes/buscador/resultado.jsp";
						url = url + "?q=" + texto;		
						url = url + "&op=" + op;
						url = url + "&pagina=1";%>
						<td>&nbsp;<a href="<%=url%>"> &lt;&lt; Inicio </a>&nbsp;</td>
					<%}%>
					<%if (PAGINA_ACTUAL > 1){
						url = "/Apia/expedientes/buscador/resultado.jsp";
						url = url + "?q=" + texto;
						url = url + "&op=" + op;
						url = url + "&pagina=" + (PAGINA_ACTUAL -1);%>	
						<td><a href="<%=url%>"> &lt; Página Anterior </a></td>
					<%}%>											
					<%
					//for (int i=1; i<(cantPaginas+1); i++){
					for (int i=paginaInicio; i<(paginaFin); i++){
						if (i==PAGINA_ACTUAL){%>
							<td><%=PAGINA_ACTUAL%></td>
						<%}else{
							url = "/Apia/expedientes/buscador/resultado.jsp";
							url = url + "?q=" + texto;
							url = url + "&op=" + op;
							url = url + "&pagina=" + (i);%>
							<td><a href="<%=url%>"><%=(i)%></a></td>
						<%}%>		
					<%}%>				
					<%if (PAGINA_ACTUAL < (cantPaginas-1)){
						url = "/Apia/expedientes/buscador/resultado.jsp";
						url = url + "?q=" + texto;	
						url = url + "&op=" + op;
						url = url + "&pagina=" + (PAGINA_ACTUAL + 1);%>	
						<td><a href="<%=url%>"> Página Siguiente &gt;</a></td>
					<%}%>
					<%if ((cantPaginas > Conf.CANTIDAD_REGISTROS) && (PAGINA_ACTUAL < (cantPaginas-(Conf.CANTIDAD_REGISTROS / 2)))){
						url = "/Apia/expedientes/buscador/resultado.jsp";
						url = url + "?q=" + texto;
						url = url + "&op=" + op;
						url = url + "&pagina=" + cantPaginas;%>
						<td class="pagSg"><a href="<%=url%>"> Fin &gt;&gt;</a></td>
					<%}%>
				
					<td>
						<span style="align:right;float:right;">
							Resultados <strong><%=(inicio+1)%></strong> - <strong><%=(fin+1)%></strong> de aproximadamente <strong><%=cantRegistros%></strong> en <%=BDao.getTiempoEjecucionEnSeg()%> seg.
						</span>
					</td>
														
				</tr>
			</table>
			<br>
			<!-- FIN PAGINADO -->