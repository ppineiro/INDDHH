<%@ page import="uy.com.st.adoc.expedientes.arbolExpediente.obj.sql.Consultas"%>
<%@page import="uy.com.st.adoc.expedientes.preview.Preview"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.dogma.UserData"%>
<%@page import="com.dogma.controller.ThreadData"%>

<html>
	<head>
		<%
		String exp = request.getParameter("nroExp").toString();
		String expSize = request.getParameter("size").toString();
		
		Preview preview = new Preview();
		UserData uData = ThreadData.getUserData();
		
		ArrayList<String> paths = preview.getPathsUltimasActuaciones(uData.getUserId(), exp , uData.getEnvironmentId());
		String sizes = ""; 
		String sep = "|";
		
		int count = paths.size();
		
		for (String path : paths){
			sizes += Consultas.getTamanioArchivoEE(exp, path, uData.getEnvironmentId()) + sep;
		}
		if (sizes != ""){
		sizes = sizes.substring(0, sizes.length() - 1);		
		}
		%>
	
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>Insert title here</title>
		
		<script type="text/javascript">
		
			function getModalReturnValue(modal) {
				var count = <%= count %>;
				var action = "vacio";
				var oRadio = document.getElementsByName("rb_preview");

				for (var i = 0; i < oRadio.length; i++) {
					if (oRadio[i].checked) {
						if (oRadio[i].value == "U3"){
							if(count == 1){ action = "1"; }
							if(count == 2){ action = "2"; }
							if (count >= 3){ action = "3"; }							
						}
						
						if (oRadio[i].value == "U5"){
							if(count == 4){ action = "4"; }
							if (count >= 5){ action = "5"; }
						}
						
						if (oRadio[i].value == "preview"){
							action = oRadio[i].value;
						}				
						
					}
				}				
				return action;
			}
			
			function view(){
				var count = <%= count %>;
				var sizes = "<%= sizes %>";
				var sep = "<%=sep%>";
				
				if (count == 0){
					document.getElementsByName("rb_preview")[2].checked = true;
					
					document.getElementById("trFirst").style.display = "none";
					document.getElementById("trSecond").style.display = "none";
					
					document.getElementById("trThird").style.position = "absolute";
					document.getElementById("trThird").style.top = "45%";
				}else{
					document.getElementsByName("rb_preview")[0].checked = true;
					if (count <= 3){
						document.getElementById("trSecond").style.display = "none";
						
						document.getElementById("trFirst").style.position = "absolute";
						document.getElementById("trFirst").style.top = "20%";
						if (count == 1){
							document.getElementById("lbFirst").innerHTML = "Visualizar última actuación";
							document.getElementById("lbFirstSize").innerHTML = "Tama\u00f1o: " + getSizeUnidad(sizes);
							document.getElementById("size1").style.position = "relative";
							document.getElementById("size1").style.left = "52%";
						} else{
							document.getElementById("lbFirst").innerHTML = "Visualizar últimas " + count + " actuaciones";
							var tamanio = 0;
							for(var i=0 ; i < sizes.split(sep).length ; i++){
								tamanio = parseInt(tamanio) + parseInt(sizes.split(sep)[i]);						
							}
							document.getElementById("lbFirstSize").innerHTML = "Tama\u00f1o: " + getSizeUnidad(tamanio);
							document.getElementById("size1").style.position = "relative"; 
							document.getElementById("size1").style.left = "39%"; 	
						}
						
						document.getElementById("trThird").style.position = "absolute";
						document.getElementById("trThird").style.top = "60%";
						
					}else{
						document.getElementById("lbFirst").innerHTML = "Visualizar últimas 3 actuaciones";
						var tamanio = 0;
						for(var i=0 ; i < 3 ; i++){
							tamanio += parseInt(sizes.split(sep)[i]);
						}
						document.getElementById("lbFirstSize").innerHTML = "Tama\u00f1o: " + getSizeUnidad(tamanio);
						document.getElementById("size1").style.position = "relative"; 
						document.getElementById("size1").style.left = "39%";
						
						tamanio = 0;
						if (count == 4){
							document.getElementById("lbSecond").innerHTML = "Visualizar últimas 4 actuaciones";
							for(var j=0 ; j < 4 ; j++){
								tamanio += parseInt(sizes.split(sep)[j]);
							}
							document.getElementById("lbSecondSize").innerHTML = "Tama\u00f1o: " + getSizeUnidad(tamanio);
							document.getElementById("size1").style.position = "relative";
							document.getElementById("size1").style.left = "39%";
						}else{
							document.getElementById("lbSecond").innerHTML = "Visualizar últimas 5 actuaciones";
							for(var j=0 ; j < 5 ; j++){
								tamanio += parseInt(sizes.split(sep)[j]);
							}
							document.getElementById("lbSecondSize").innerHTML = "Tama\u00f1o: " + getSizeUnidad(tamanio);
							document.getElementById("size1").style.position = "relative";
							document.getElementById("size1").style.left = "39%";
							
							document.getElementById("size2").style.left = "38.5%";
						}						
					}
					
				}
				
			}
			
			function getSizeUnidad(tamanio){
				var sizeUnit = "";
				var unit = "bytes";
				// KB
				var transform = (tamanio / 1024).toFixed(1);
				unit = "KB";		
				sizeUnit = transform + "";		
			
				if (transform.split(".")[0].length > 3){
					// MB
					transform = (transform / 1024).toFixed(1);
					unit = "MB";
					sizeUnit = transform + "";
			
					if (transform.split(".")[0].length > 3){
						// GB
						transform = (transform / 1024).toFixed(1);
						unit = "GB";
						sizeUnit = transform + "";
					
						if (transform.split(".")[0].length > 3){
							// TB
							transform = (transform / 1024).toFixed(1);
							unit = "TB";
						}						
					}
					
				}
				sizeUnit+= " " + unit;
				return sizeUnit;
			}
			
		</script>
		
		<style type="text/css">
		
			#imgPdfDoc {
				background: url(../templates/img/pdfDocs.png);
				background-size: 22px;
				background-repeat: no-repeat;
				width: 22px;
				height: 24px;
			}
					
			tr{ display: block; height: 40px; }				
			td.size2{ position: relative; left: 39%; }
			td.size3{ position: relative; left: 24%; }
			input.radio{ width: 18px; height: 16px; }
					
			label {	font-family: Verdana,Arial,Tahoma !important; font-size: 8.5pt !important; }
		
		</style>
		
	</head>
	
	<body onLoad="view()">
		
		<table width="100%">
			<tbody>
				
				<tr id="trFirst">
				<td><input class="radio" type="radio" name="rb_preview" value="U3"></td>
				<td><div id='imgPdfDoc'></div></td>
				<td><label id="lbFirst"></label></td>
				<td id="size1" class="size1"><label id="lbFirstSize"></label></td>
				</tr>
				
				<tr id="trSecond">
				<td><input class="radio" type="radio" name="rb_preview" value="U5"><br></td>
				<td><div id='imgPdfDoc'></div></td>
				<td><label id="lbSecond"></label></td>
				<td id="size2" class="size2"><label id="lbSecondSize"></label></td>
				</tr>
				
				<tr id="trThird">
				<td><input class="radio" type="radio" name="rb_preview" value="preview"><br></td>
				<td><div id='imgPdfDoc'></div></td>
				<td><label>Visualizar expediente <%=exp%></label></td>
				<td id="size3" class="size3"><label>Tama&#241;o: <%=expSize%></label></td>				
				</tr>
				
			</tbody>
		</table>
	
	</body>
	
</html>