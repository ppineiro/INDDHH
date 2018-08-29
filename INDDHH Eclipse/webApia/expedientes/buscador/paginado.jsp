<!-- INICIO PAGINADO -->

<%
	System.out.println("CANTIDAD_REGISTROS_POR_PAGINA: " + CANTIDAD_REGISTROS_POR_PAGINA);

	boolean mostrarPaginado = true;
	int cantRegistros = arr.size();
	if (cantRegistros < 11)
		mostrarPaginado = false;
	int cantPaginas = cantRegistros / CANTIDAD_REGISTROS_POR_PAGINA;
	if ((cantRegistros % CANTIDAD_REGISTROS_POR_PAGINA) > 0) {
		if (cantPaginas > 0) {
			cantPaginas = cantPaginas + 1;
		}
	}

	int paginaInicio = 0;
	int paginaFin = 0;
	if (cantPaginas > CANTIDAD_REGISTROS_POR_PAGINA) {
		if (PAGINA_ACTUAL > (CANTIDAD_REGISTROS_POR_PAGINA / 2)) {
			if ((PAGINA_ACTUAL + (CANTIDAD_REGISTROS_POR_PAGINA / 2)) < cantPaginas) {
				paginaInicio = PAGINA_ACTUAL - (CANTIDAD_REGISTROS_POR_PAGINA / 2);
				paginaFin = PAGINA_ACTUAL + (CANTIDAD_REGISTROS_POR_PAGINA / 2);
			} else {
				paginaInicio = cantPaginas - CANTIDAD_REGISTROS_POR_PAGINA;
				paginaFin = cantPaginas;
			}
		} else {
			paginaInicio = 1;
			paginaFin = (CANTIDAD_REGISTROS_POR_PAGINA + 1);
		}
	} else {
		paginaInicio = 1;
		paginaFin = cantPaginas;
	}

	int inicio = (PAGINA_ACTUAL * CANTIDAD_REGISTROS_POR_PAGINA) - CANTIDAD_REGISTROS_POR_PAGINA;
	int fin = (PAGINA_ACTUAL * CANTIDAD_REGISTROS_POR_PAGINA) - 1;

	if (inicio > cantRegistros) {
		inicio = cantRegistros - 1;
	}
	if (fin > cantRegistros) {
		fin = cantRegistros - 1;
	}
%>
<!-- INICIO PAGINADO -->
<%
	String url = "";
%>
<div>

	<table style="border-collapse: collapse; float: left; width: 60%">
		<tr>
			<td width="2.5%">&nbsp;</td>
			<%
				if (PAGINA_ACTUAL > (CANTIDAD_REGISTROS_POR_PAGINA / 2) + 1) {
					url = ROOT_PATH + "/expedientes/buscador/resultado.jsp";
					url = url + "?q=" + texto;
					url = url + "&op=" + op;
					url = url + "&pagina=1";
					url = url + "&usr=" + usuario;
					url = url + TAB_ID_REQUEST;
			%>
			<td width="6%" style="text-align: left;">&nbsp;<a
				href="<%=url%>"> &lt;&lt; Inicio </a>&nbsp;
			</td>
			<%
				} else if (mostrarPaginado) {
			%>
			<td width="6%" style="text-align: left;">&nbsp; &lt;&lt; Inicio
				&nbsp;</td>
			<%
				}
			%>
			<%
				if (PAGINA_ACTUAL > 1) {
					url = ROOT_PATH + "/expedientes/buscador/resultado.jsp";
					url = url + "?q=" + texto;
					url = url + "&op=" + op;
					url = url + "&pagina=" + (PAGINA_ACTUAL - 1);
					url = url + "&usr=" + usuario;
					url = url + TAB_ID_REQUEST;
			%>
			<td width="4%" style="text-align: left;"><a href="<%=url%>">
					&lt; Anterior </a></td>
			<%
				} else if (mostrarPaginado) {
			%><td width="4%"
				style="text-align: left;">&lt; Anterior</td>
			<%
				}
			%>
			<%
				//for (int i=1; i<(cantPaginas+1); i++){
				for (int i = paginaInicio; i <= (paginaFin); i++) {
					if (i == PAGINA_ACTUAL) {
			%>
			<td width="2.5%" style="text-align: center;"><%=PAGINA_ACTUAL%></td>
			<%
				} else {
						url = ROOT_PATH + "/expedientes/buscador/resultado.jsp";
						url = url + "?q=" + texto;
						url = url + "&op=" + op;
						url = url + "&pagina=" + (i);
						url = url + "&usr=" + usuario;
						url = url + TAB_ID_REQUEST;
			%>
			<td width="2.5%" style="text-align: center;"><a href="<%=url%>"><%=(i)%></a></td>
			<%
				}
			%>
			<%
				}
			%>
			<%
				if (PAGINA_ACTUAL < (cantPaginas - 1)) {
					url = ROOT_PATH + "/expedientes/buscador/resultado.jsp";
					url = url + "?q=" + texto;
					url = url + "&op=" + op;
					url = url + "&pagina=" + (PAGINA_ACTUAL + 1);
					url = url + "&usr=" + usuario;
					url = url + TAB_ID_REQUEST;
			%>
			<td width="5%" style="text-align: right;"><a href="<%=url%>">
					Siguiente &gt;</a></td>
			<%
				} else if (mostrarPaginado) {
			%>
			<td width="5%" style="text-align: right;">Siguiente &gt;</td>
			<%
				}
			%>
			<%
				if ((cantPaginas > CANTIDAD_REGISTROS_POR_PAGINA)
						&& (PAGINA_ACTUAL < (cantPaginas - (CANTIDAD_REGISTROS_POR_PAGINA / 2)))) {
					url = ROOT_PATH + "/expedientes/buscador/resultado.jsp";
					url = url + "?q=" + texto;
					url = url + "&op=" + op;
					url = url + "&pagina=" + (cantPaginas - 1);
					url = url + "&usr=" + usuario;
					url = url + TAB_ID_REQUEST;
			%>
			<td width="4%" style="text-align: right;"><a href="<%=url%>">
					Fin &gt;&gt;</a></td>
			<%
				} else if (mostrarPaginado) {
			%>
			<td width="4%" style="text-align: right;">Fin &gt;&gt;</td>
			<%
				}
			%>
			<td width="4%" style="text-align: right;">
				<div style="background: transparent url(./img/exportar.png) no-repeat; width: 24px; height: 24px; cursor: pointer;position: relative; left: 50%;background-size: 24px; opacity: 0.90;" title="exportar" onClick="exportarResultado(); return false;"></div>
			</td>
			
		</tr>
	</table>
	<table style="border-collapse: collapse; float: right; margin: auto">
		<tr>
			<td>
				<span style="align: right; float: right;">
				Resultados<strong><%=(inicio + 1)%></strong> - <strong><%=(fin + 1)%></strong>de aproximadamente <strong><%=cantRegistros%></strong> en <%=session.getAttribute("tiempoEjec")%>seg.
				</span>
			</td>
		</tr>
	</table>

</div>
<br>
<br>
<!-- FIN PAGINADO -->