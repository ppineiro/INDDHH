<%@page import="com.dogma.Parameters"%>

<html>
	<head>
		<meta charset="utf-8">		
		<title>ApiaDocumentum</title>
		
		<style type="text/css">
			.searchBox {
				margin-right: 10px;
				margin-left: 10px;
				margin-top: 10px;
				height: 100px;
			}
			
			.searchBox input[type="submit"] {
				width: 20%;
				float: right;
				height: 33px;
				text-transform: uppercase;
				color: #fff;
				background: #0B72B5;
				border: 0;
				border-radius: 5px 5px 5px 5px;
				box-shadow: 0 2px 0 #0B72B5;
				text-shadow: 1px 1px 0px #02547F;
				transition: background 0.5s ease 0s;
				-webkit-appearance: push-button;
				cursor: pointer;
				padding-top: 4px;
				margin-right: 5px
			}
			
			.searchBox input[type="submit"]:hover {
				background: #1781C0;
				transition: background 0.5s ease 0s;
			}
			
			.searchBox input[type="search"] {
				float: left;
				padding: 5px 5px 5px 5px;
				width: 75%;
				height: 35px;
				font-size: 1.75em;
				transition: all 0.5s ease 0s;
				-webkit-transition: all 0.5s ease 0s;
				-moz-transition: all 0.5s ease 0s;
				-o-transition: all 0.5s ease 0s;
				-webkit-appearance: textfield;
				border: 1px solid;
				border-color: #d9d9d9;
				border-top-color: #c0c0c0;
				border-radius: 5px 5px 5px 5px;
				font-family: Arial;
				-webkit-appearance: searchfield;
				box-sizing: border-box;
				-webkit-rtl-ordering: logical;
				-webkit-user-select: text;
			}
			
			label.charLimit{
			    display: none;
			    font-style: italic;
			    font-size: 10pt;
			    color: #0679B8;
			    margin-top: 3%;
			}
		</style>		
		
		<script type="text/javascript">
			
			var url = {	title: "Búsqueda", url: "<%=Parameters.ROOT_PATH%>/expedientes/buscador/resultado.jsp"};
			<!-- var url = {	title: "Consulta global", url: "apia.query.UserAction.run?action=init&query=3504"};-->
			
			function loadURLConsulta() {
				var value = document.getElementById("expedienteSearch").value;
				if (value.length>=3){
					document.getElementById("charLimit").style.display = "none";
					TAB_CONTAINER.addNewTab(url.title, url.url + '?op=2&q=' + value + TAB_ID_REQUEST);
				}else{
					document.getElementById("charLimit").style.display = "inline-block";
				}
			}
		
			function valida(e){ 
				tecla=(document.all) ? e.keyCode : e.which; 
				if(tecla == 13){ 
					loadURLConsulta();		
				}		
			}	
			
		</script>
		
	</head>

	<body>
		<div class="searchBox" style="width: 98%;height:100%;">
		<br>
			<input id="expedienteSearch" type="search" class="search" placeholder onkeypress="valida(event)" title="Buscar expediente"></input>
			<input type="submit" onclick="loadURLConsulta()" class="submit" value="Buscar"></input>
			<label id="charLimit" class="charLimit">Su búsqueda debe tener al menos <%=st.access.conf.Buscador.CANT_MINIMA_CARACTERES%> caracteres.</label>
		</div>
	</body>
	
</html>